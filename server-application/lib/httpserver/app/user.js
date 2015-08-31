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
    method : get,
    func : function(req, res) {
        var param = req.queryString;
        async.waterfall([function(callback) {
            if (param.registrationId === null || param.registrationId.length === 0) {
                callback(ServerError.ERR_NOT_ENOUGH_PARAM);
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
                    callback(ServerError.ERR_NOT_LOGGED_IN);
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
                            callback(ServerError.ERR_NOT_LOGGED_IN);
                        }
                    });
                } else {
                    callback(null, user);
                }
            });
        }], function(error, user) {
            ResponseHelper.response(res, error, {
                user : user
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
    method : 'post',
    func : function(req, res) {
        var config = global.config;
        var param = req.body;
        var code = param.code;
        if (!code) {
            ResponseHelper.response(res, ServerError.ERR_NOT_ENOUGH_PARAM);
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
                    openid : data.openid,
                    nickname : data.nickname,
                    sex : data.sex,
                    province : data.province,
                    city : data.city,
                    country : data.country,
                    headimgurl : data.headimgurl,
                    privilege : data.privilege,
                    unionid : data.unionid
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
                } else if (user) {
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
                    },
                    receivers : [],
                    unread : {
                        tradeRef : [],
                        itemRecommendationRef : []
                    }
                });

                newUser.save(function(error, user) {
                    if (error) {
                        callback(error);
                    } else if (!user) {
                        callback(ServerError.ERR_UNKOWN);
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

/**
 * 微博登录
 * 调用 NotificationService.unbind 绑定该 registrationId 与当前用户
 *
 * @method post
 * @param {string} req.access_token
 * @param {string} req.uid
 * @param {string} req.registrationId
 * @return {db.user} res.data.user
 */
user.loginViaWeibo = {
    method : 'post',
    func : function(req, res) {
        var config = global.config;
        var param = reg.body;
        var token = param.access_token;
        var uid = param.uid;
        if (!toke || !uid || !registrationId) {
            ResponseHelper.response(res, ServerError.ERR_UNKOWN);
            return;
        }

        async.waterfall([function(callback) {
            // request webio api for get weibo user's information
            var url = "https://api.weibo.com/2/users/show.json?access_token=" + token + "&uid=" + uid;
            request.get(url, function(error, response, body) {
                var data = JSON.parse(body);
                if (data.error !== undefined) {
                    callback(data);
                    return;
                }

                // get weibo user's inforamtion
                callback(null, {
                    id : data.id,
                    screen_name : data.screen_name,
                    province : data.province,
                    country : data.country,
                    gender : data.gender,
                    avatar_large : data.avatar_large
                });
            });

        }, function(user, callback) {
            var url = user.avatar_large;
            var portraitUploadInfo = config.uploads.user.portrait;

            // download headIcon from weibo 
            _downloadHeadIcon(url, function(error, tempPath) {
                if (error) {
                    callback(error);
                    return;
                }

                // upload headIcon to ftp
                var baseName = path.basename(tempPath);
                ftp.uploadWithResize(
                        tempPath, 
                        baseName, 
                        portraitUploadInfo.ftpPath, 
                        userPortraitResizeOptions, function(error) {

                    if (error) {
                        callback(error);
                        return;
                    }

                    var newPath = path.jon(portraitUploadInfo.ftpPath, baseName);
                    user.avatar_large = portraitUploadInfo.exposeToUrl + '/' + 
                        path.relative(portraitUploadInfo.ftpPath, newPath);

                    callback(null, user);
                });
            });
        }, function(user, callback) {
            // find weibo user has existsed in owen system
            Users.findOne({
                'weibo.id' : user.id
            }, function(error, user) {
                if (error) {
                    callback(error);
                    return;
                } else if (user) {
                    callback(null, user);
                    return;
                }

                // when not exist , add a new user
                var newUser = new Users({
                    nickname : user.screen_name,
                    portrait : user.avatar_large,
                    weibo : {
                        id : user.id,
                        screen_name : user.screen_name,
                        province : user.province,
                        country : user.country,
                        gender : user.gender,
                        avatar_large : user.avatar_large
                    },
                    receivers : [],
                    unread : {
                        tradeRef : [],
                        itemRecommendationRef : []
                    }
                });

                newUser.save(function(error, user) {
                    if (error) {
                        callback(error);
                    } else if (!user) {
                        callback(ServerError.ERR_UNKOWN);
                    } else {
                        callback(null, user);
                    }
                });
            });
        }, function(user, callback) {
            // add user to session
            req.session.userId = user._id;
            req.session.loginDate = new Date();
            // add registrationId to jPushAudiences
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

/**
 * 调用 NotificationService.unbind 解除该 registrationId 与当前用户的绑定
 * 登出
 *
 * @method post
 * @param {string} req.registrationId
 */
user.logout = {
    method : 'post',
    permissionValidator : ['validateLogin'],
    func : function(req, res) {
        var _id = req.currentUserId;
        delete req.session.userId;
        delete req.session.loginDate;
        delete req.currentUserId;
        NotificationService.unbind(req.body.registrationId, _id, function(error) {
            ResponseHelper.response(res, error);
        });
    }
};

/**
 * 更新用户信息
 *
 * @method post
 * @param {string} [req.nickname]
 * @param {string} [req.alipay.id]
 * @return {db.user} res.data.user
 */
user.update = {
    method : 'post',
    permissionValidator : ['validateLogin'];
    func : function(req, res) {
        async.waterfall([function(callback) {
            Users.findOne({
                _id : req.currentUserId
            }, function(error, user) {
                if (error) {
                    callback(error);
                } else if (!user) {
                    callback(ServerError.ERR_USER_NOT_EXIST);
                } else {
                    callback(null, user);
                }
            });
        }, function(user, callback) {
            var param = req.body;
            if (param.nickname !== null && param.nickname.length !== 0) {
                user.nickname = param.nickname;
            }
            if (param['alipay.id'] !== null && param['alipay.id'].length !== 0) {
                user.alipay = {
                    id : param['alipay.id']
                };
            }
            user.save(function(error, user) {
                if (error) {
                    callback(error);
                } else if (!user) {
                    callback(ServerError.ERR_UNKOWN);
                } else {
                    callback(null, user);
                }
            });
        }], function(error, user) {
            ResponseHelper.response(res, error, {
                user : user
            });
        });
    }
};

/**
 * 上传头像
 *
 * @method post
 * @return {db.user} res.data.user
 */
user.updatePortrait = {
};

/**
 * 上传背景
 *
 * @method post
 * @return {db.user} res.data.user
 */
user.updateBackground = {
};

/**
 * 添加／修改收货地址
 * 
 * @method post
 * @param {string} [req.uuid]
 * @param {string} req.name
 * @param {string} req.phone
 * @param {string} req.province
 * @param {string} req.address
 * @param {string} req.isDefault
 * @return {db.user} res.data.user
 * @return {string} res.data.uuid
 */
user.saveReceiver = {
};

/**
 * 删除收货地址
 *
 * @method post
 * @param {string} req.uuid
 * @return {db.user} res.data.user
 */
user.removeReceiver = {
};
