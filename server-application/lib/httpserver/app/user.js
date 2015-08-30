// third party library
var async = require('async');
var mongosee = require('mongoose');
var crypto = require('crypto');
var fs = require('fs');

// model
var Users = require('../../model/users');

// service
var NotificationService = require('../service/NotificationService');

// helper
var RequestHelper = require('../helper/RequestHelper');
var ResponseHelper = require('../helper/ResponseHelper');
var ServerError = require('../server-error');
var ftp = require('../../runtime/ftp');

var user = module.exports;

// password's secret key
var _secret = 'wishlink@secret';

var userPortraitResizeOptions = [
    {'suffix' : '_200', 'width' : 200, 'height' : 200},
    {'suffix' : '_100', 'width' : 100, 'height' : 100},
    {'suffix' : '_50', 'width' : 50, 'height' : 50},
    {'suffix' : '_30', 'width' : 30, 'height' : 30}
];

var _encrypt = function(value) {
    var cipher = crypto.createCipher('aes192', _secret);
    var enc = cipher.update(value, 'utf8', 'hex');
    enc += cipher.final('hex');
    return enc;
};

var _downloadHeadIcon = function (path, callback) {
    var tempName = path.replace(/[\.\/:]/g, '_');
    var tempPath = "/tmp/" + tempName;

    request(path).pipe(fs.createWriteStream(tempPath))
        .on('close', function () {
            callback(null, tempPath);
        })
        .on('error', function (err) {
            callback(err);
        });
};

/**
 * 获取当前登录用户
 * 如果无法获取，则调用 NotificationService.unbind 解除该 registrationId 对应的所有绑定
 * 
 * @method get
 * @param {string} req.registrationId
 * @return {db.user} res.data.user
 */
user.get = {
    'method' : 'get',
    'func' : function(req, res) {
        var param = req.queryString;
        async.waterfall([function(callback) {
            if (param.registrationId === null || param.registrationId.length === 0) {
                callback(ServerError.NotEnoughParam);
            }
        }, function(callback) {
            if (req.currentUserId) {
                callback();
                return;
            }
            NotificationService.unbind(param.registrationId, null, function(error) {
                if (error) {
                    callback(error);
                } else {
                    callback(ServerError.NeedLogin);
                }
            });
        }, function(callback) {
            Users.findOne({
                '_id' : req.currentUserId
            }, function(error, user) {
                if (error) {
                    callback(error);
                } else if (!user) {
                    NotificationService.unbind(param.registrationId, null, function(error) {
                        if (error) {
                            callback(error);
                        } else {
                            callback(ServerError.NeedLogin);
                        }
                    });
                } else {
                    callback(null, user);
                }
            });
        }], function(error, user) {
            ResponseHelper.response(res, error, {
                'user' : user
            });
        });
    }
};

/**
 * 微信登录
 * 调用 NotificationService.unbind 绑定该 registrationId 与当前用户
 * 
 * @method post
 * @param {string} req.code
 * @param {string} req.registrationId
 * @return {db.user} res.data.user
 */
user.loginViaWeixin = {
    'method' : 'post',
    'func' : function(req, res) {
        var config = global.config;
        var param = req.body;
        var code = param.code;
        if (!code) {
            ResponseHelper.response(res, ServerError.NotEnoughParam);
            return;
        }

        var appid = config.social.network.sdk.wechat.appid;
        var secret = config.social.network.sdk.wechat.secret;

        async.waterfall([function(callback) {
            var token_url = 'https://api.weixin.qq.com/sns/oauth2/access_token?appid=' + appid + '&secret=' + secret + '&code=' + code + '&grant_type=authorization_code';
            request.get(token_url, function(error, response, body) {
                var data = JSON.parse(body);
                if (data.errcode !== undefined) {
                    callback(data);
                    return;
                }
                callback(null, data.access_token, data.openid);
            });
        }, function(token, openid, callback) {
            var usr_url = 'https://api.weixin.qq.com/sns/userinfo?access_token=' + token + '&openid=' + openid;

            request.get(usr_url, function(errro, response, body) {
                var data = JSON.parse(body);
                if (data.errorcode !== undefined) {
                    callback({
                        errorcode : data.errcode,
                        weixin_err : data
                    });
                    return;
                }

                callback(null, {
                    'openid' : data.openid,
                    'nickname' : data.nickname,
                    'sex' : data.sex,
                    'province' : data.province,
                    'city' : data.city,
                    'country' : data.country,
                    'headimgurl' : data.headimgurl,
                    'privilege' : data.privilege,
                    'unionid' : data.unionid
                });
            });
        }, function(user, callback) {
            var url = user.headimgurl;
            _downloadHeadIcon(url, function(error, tempPath) {
                if (error) {
                    callback(error);
                    return;
                }

                // update head icon to ftp
                var baseName = path.basename(tempPath);
                ftp.uploadWithResize(tempPath, baseName, 
                        config.uploads.user.portrait.ftpPath, 
                        userPortraitResizeOptions, function(error) {
                    if (error) {
                        callback(error);
                    } else {
                        var newPath = path.join(config.uploads.user.portrait.ftpPath, baseName);
                        user.headimgurl = config.uploads.user.portrait.exposeToUrl + '/' + 
                            path.relative(config.uploads.user.portrait.ftpPath, newPath);
                        callback(null, user);
                    }
                });
            });
        }, function(user, callback) {
            Users.findOne({
                'weixin.openid' : user.openid
            }, function(error, user) {
                if (error) {
                    callback(error);
                    return;
                } else if (!user) {
                    callback(null, user);
                    return;
                }

                var newUser = new Users({
                    nickname : user.nickname,
                    portrait : user.headimgurl,
                    weixin : {
                        openid : user.openid,
                        nickname : user.nickname,
                        sex : user.sex,
                        province : user.province,
                        city : user.city,
                        country : user.country,
                        headimgurl : user.headimgurl,
                        unionid : user.unionid
                    }
                });

                newUser.save(function(error, user) {
                    if (error) {
                        callback(error);
                    } else if (!user) {
                        callback(ServerError.ServerError);
                    } else {
                        callback(null, user);
                    }
                });
            });
        }, function(user, callback) {
            req.session.userId = user._id;
            req.session.loginDate = new Date();
            NotificationService.bind(param.registrationId, user._id, function(error) {
                callback(error, user);
            });
        }], function(error, user) {
            ResponseHelper.response(res, error, {
                user : user
            });
        });
    }
};
