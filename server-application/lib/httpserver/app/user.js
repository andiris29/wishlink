// Third party library
var async = require('async');
var mongosee = require('mongoose');
var crypto = require('crypto');
var fs = require('fs');
var uuid = require('node-uuid');
var path = require('path');
var request = require('request');
var rongcloudSDK = require('rongcloud-sdk');

// Model
var Users = require('../../model/users');
var rUserRecommendedItems = require('../../model/rUserRecommendedItem');

// Service
var NotificationService = require('../service/NotificationService');
var RecommendationService = require('../service/RecommendationService');
var SmsService = require('../service/SmsService');

// Helper
var RequestHelper = require('../helper/RequestHelper');
var ResponseHelper = require('../helper/ResponseHelper');
var ServerError = require('../server-error');
var ftp = require('../../runtime/ftp');

var user = module.exports;

// password's secret key
var _secret = 'wishlink@secret';

var userPortraitResizeOptions = [
    {'suffix': '_200', 'width': 200, 'height': 200},
    {'suffix': '_100', 'width': 100, 'height': 100},
    {'suffix': '_50', 'width': 50, 'height': 50},
    {'suffix': '_30', 'width': 30, 'height': 30}
];

var _encrypt = function(value) {
    var cipher = crypto.createCipher('aes192', _secret);
    var enc = cipher.update(value, 'utf8', 'hex');
    enc += cipher.final('hex');
    return enc;
};

var _generateCode = function() {
    return Math.floor(Math.random() * (999999 - 100000)) + 100000;
};

var _downloadHeadIcon = function(path, callback) {
    var tempName = path.replace(/[\.\/:]/g, '_');
    var tempPath = '/tmp/' + tempName;

    request(path).pipe(fs.createWriteStream(tempPath))
        .on('close', function() {
            callback(null, tempPath);
        })
        .on('error', function(err) {
            callback(err);
        });
};

var _upload = function(req, res, config, keyword, resizeOptions) {
    RequestHelper.parseFile(req, config.ftpPath, resizeOptions, function(error, fields, file) {
        if (error) {
            ResponseHelper.response(res, error);
            return;
        }
        Users.findOne({
            _id: req.currentUserId
        }, function(error, user) {
            user.set(keyword, config.exposeToUrl + '/' + path.relative(config.ftpPath, file.path));
            user.save(function(error, user) {
                ResponseHelper.response(res, error, {
                    user: user
                });
                if (keyword === 'portrait') {
                    rongcloudSDK.init(global.config.api.rongcloud.appkey, global.config.api.rongcloud.appsecret);
                    rongcloudSDK.user.refresh(user._id.toString(), user.nickname, user.portrait, null);
                }
            });
        });
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
    method: 'get',
    func: function(req, res) {
        var param = req.queryString;
        async.waterfall([function(callback) {
            if (req.currentUserId) {
                callback();
                return;
            }
            if (param && param.registrationId) {
                NotificationService.unbind(param.registrationId, null, function(error) {
                    callback(error || ServerError.ERR_NOT_LOGGED_IN);
                });
            } else {
                callback(ServerError.ERR_NOT_LOGGED_IN);
            }
        }, function(callback) {
            Users.findOne({
                _id: req.currentUserId
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
                user: user
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
    method: 'post',
    func: function(req, res) {
        var config = global.config;
        var param = req.body;
        var code = param.code;
        if (!code) {
            ResponseHelper.response(res, ServerError.ERR_NOT_ENOUGH_PARAM);
            return;
        }

        var appId = config.social.network.sdk.wechat.appid;
        var secret = config.social.network.sdk.wechat.secret;

        var isNewUser = false;
        async.waterfall([function(callback) {
            var tokenUrl = 'https://api.weixin.qq.com/sns/oauth2/access_token?appid=' +
                appId + '&secret=' + secret + '&code=' + code + '&grant_type=authorization_code';
            request.get(tokenUrl, function(error, response, body) {
                var data = JSON.parse(body);
                if (data.errcode !== undefined) {
                    callback(data);
                    return;
                }
                callback(null, data.access_token, data.openid);
            });
        }, function(token, openid, callback) {
            var userUrl = 'https://api.weixin.qq.com/sns/userinfo?access_token=' + token + '&openid=' + openid;

            request.get(userUrl, function(errro, response, body) {
                var data = JSON.parse(body);
                if (data.errorcode !== undefined) {
                    callback({
                        errorcode: data.errcode,
                        weixinErr: data
                    });
                    return;
                }

                callback(null, {
                    openid: data.openid,
                    nickname: data.nickname,
                    sex: data.sex,
                    province: data.province,
                    city: data.city,
                    country: data.country,
                    headimgurl: data.headimgurl,
                    privilege: data.privilege,
                    unionid: data.unionid
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
                'weixin.openid': user.openid
            }, function(error, target) {
                if (error) {
                    callback(error);
                    return;
                } else if (target) {
                    callback(null, target);
                    return;
                }

                isNewUser = true;
                var newUser = new Users({
                    role: 0,
                    nickname: user.nickname,
                    portrait: user.headimgurl,
                    weixin: {
                        openid: user.openid,
                        nickname: user.nickname,
                        sex: user.sex,
                        province: user.province,
                        city: user.city,
                        country: user.country,
                        headimgurl: user.headimgurl,
                        unionid: user.unionid
                    },
                    receivers: [],
                    unread: {
                        tradeRef: [],
                        itemRecommendationRef: []
                    }
                });

                newUser.save(function(error, target) {
                    if (error) {
                        callback(error);
                    } else if (!target) {
                        callback(ServerError.ERR_UNKNOWN);
                    } else {
                        callback(null, target);
                    }
                });
            });
        }, function(user, callback) {
            if (isNewUser) {
                RecommendationService.recommendItems(user._id, function(error) {
                    callback(error, user);
                });
            } else {
                callback(null, user);
            }
        }, function(user, callback) {
            req.session.userId = user._id;
            req.session.loginDate = new Date();
            callback(null, user);
        }], function(error, user) {
            ResponseHelper.response(res, error, {
                user: user
            });
            // exists user do not get rongcloud's token
            if (!isNewUser) {
                return;
            }
            rongcloudSDK.init(global.config.api.rongcloud.appkey, global.config.api.rongcloud.appsecret);
            rongcloudSDK.user.getToken(user._id.toString(), user.nickname, user.portrait, function(error, result) {
                var data = JSON.parse(result);
                if (data.code !== 200) {
                    return;
                }
                user.rongcloud.token = date.token;
                user.save();
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
    method: 'post',
    func: function(req, res) {
        var config = global.config;
        var param = req.body;
        var token = param.access_token;
        var uid = param.uid;
        var registrationId = param.registrationId;
        if (!token || !uid || !registrationId) {
            ResponseHelper.response(res, ServerError.ERR_UNKNOWN);
            return;
        }

        var isNewUser = false;
        async.waterfall([function(callback) {
            // request webio api for get weibo user's information
            var url = 'https://api.weibo.com/2/users/show.json?access_token=' + token + '&uid=' + uid;
            request.get(url, function(error, response, body) {
                var data = JSON.parse(body);
                if (data.error !== undefined) {
                    callback(data);
                    return;
                }

                // get weibo user's inforamtion
                callback(null, {
                    id: data.id,
                    screen_name: data.screen_name,
                    province: data.province,
                    country: data.country,
                    gender: data.gender,
                    avatar_large: data.avatar_large
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
                ftp.uploadWithResize(tempPath, baseName, portraitUploadInfo.ftpPath, userPortraitResizeOptions, function(error) {
                    if (error) {
                        callback(error);
                        return;
                    }

                    var newPath = path.join(portraitUploadInfo.ftpPath, baseName);
                    user.avatar_large = portraitUploadInfo.exposeToUrl + '/' +
                        path.relative(portraitUploadInfo.ftpPath, newPath);

                    callback(null, user);
                });
            });
        }, function(user, callback) {
            // find weibo user has existsed in owen system
            Users.findOne({
                'weibo.id': user.id
            }, function(error, target) {
                if (error) {
                    callback(error);
                    return;
                } else if (target) {
                    callback(null, target);
                    return;
                }

                isNewUser = true;
                // when not exist , add a new user
                var newUser = new Users({
                    role: 0,
                    nickname: user.screen_name,
                    portrait: user.avatar_large,
                    weibo: {
                        id: user.id,
                        screen_name: user.screen_name,
                        province: user.province,
                        country: user.country,
                        gender: user.gender,
                        avatar_large: user.avatar_large
                    },
                    receivers: [],
                    unread: {
                        tradeRef: [],
                        itemRecommendationRef: []
                    }
                });

                newUser.save(function(error, target) {
                    if (error) {
                        callback(error);
                    } else if (!target) {
                        callback(ServerError.ERR_UNKNOWN);
                    } else {
                        callback(null, target);
                    }
                });
            });
        }, function(user, callback) {
            if (isNewUser) {
                RecommendationService.recommendItems(user._id, function(error) {
                    callback(error, user);
                });
            } else {
                callback(null, user);
            }
        }, function(user, callback) {
            // add user to session
            req.session.userId = user._id;
            req.session.loginDate = new Date();
            callback(null, user);
        }], function(error, user) {
            ResponseHelper.response(res, error, {
                user: user
            });
            // exists user do not get rongcloud's token
            if (!isNewUser) {
                return;
            }
            rongcloudSDK.init(global.config.api.rongcloud.appkey, global.config.api.rongcloud.appsecret);
            rongcloudSDK.user.getToken(user._id.toString(), user.nickname, user.portrait, function(error, result) {
                var data = JSON.parse(result);
                if (data.code !== 200) {
                    return;
                }
                user.rongcloud.token = date.token;
                user.save();
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
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        var _id = req.currentUserId;
        delete req.session.userId;
        delete req.session.loginDate;
        delete req.currentUserId;
        delete req.session.mobileVerification;
        ResponseHelper.response(res, null, null);
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
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        async.waterfall([function(callback) {
            Users.findOne({
                _id: req.currentUserId
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
            if (param.nickname != null && param.nickname.length != 0) {
                user.nickname = param.nickname;
            }
            if (param['alipay'] != null && param['alipay']['id'].length != 0) {
                user.alipay = {
                    id: param.alipay.id
                };
            }
            user.save(function(error, user) {
                if (error) {
                    callback(error);
                } else if (!user) {
                    callback(ServerError.ERR_UNKNOWN);
                } else {
                    callback(null, user);
                }
            });
        }], function(error, user) {
            ResponseHelper.response(res, error, {
                user: user
            });
            rongcloudSDK.init(global.config.api.rongcloud.appkey, global.config.api.rongcloud.appsecret);
            rongcloudSDK.user.refresh(user._id.toString(), user.nickname, user.portrait, null);
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
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        _upload(req, res, global.config.uploads.user.portrait, 'portrait', userPortraitResizeOptions);
    }
};

/**
 * 上传背景
 *
 * @method post
 * @return {db.user} res.data.user
 */
user.updateBackground = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        _upload(req, res, global.config.uploads.user.background, 'background');
    }
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
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        var param = req.body;
        var i = 0;
        async.waterfall([function(callback) {
            Users.findOne({
                _id: req.currentUserId
            }, function(error, user) {
                if (!error && !user) {
                    callback(ServerError.ERR_USER_NOT_EXIST);
                } else {
                    callback(null, user);
                }
            });
        }, function(user, callback) {
            var receiver = {
                name: param.name,
                phone: param.phone,
                province: param.province,
                address: param.address,
                isDefault: param.isDefault
            };

            if (!param.uuid || param.uuid.length === 0) {
                receiver.uuid = uuid.v1();
            } else {
                receiver.uuid = param.uuid;
            }

            user.receivers = user.receivers || [];
            var isExists = false;
            var hitIndex = -1;
            for (i = 0; i < user.receivers.length; i++) {
                if (user.receivers[i].uuid === receiver.uuid) {
                    user.receivers[i].name = receiver.name;
                    user.receivers[i].phone = receiver.phone;
                    user.receivers[i].province = receiver.province;
                    user.receivers[i].address = receiver.address;
                    user.receivers[i].isDefault = receiver.isDefault;
                    isExists = true;
                    hitIndex = i;
                    break;
                }
            }

            if (!isExists) {
                user.receivers.push(receiver);
                hitIndex = user.receivers.length - 1;
            }

            if (receiver.isDefault) {
                for (i = 0; i < user.receivers.length; i++) {
                    if (hitIndex !== i) {
                        user.receivers[i].isDefault = false;
                    }
                }
            }

            user.save(function(error, user) {
                callback(error, user, receiver.uuid);
            });
        }], function(error, user, uuid) {
            ResponseHelper.response(res, error, {
                user: user,
                uuid: uuid
            });
        });
    }
};

/**
 * 删除收货地址
 *
 * @method post
 * @param {string} req.uuid
 * @return {db.user} res.data.user
 */
user.removeReceiver = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        var param = req.body;
        async.waterfall([function(callback) {
            Users.findOne({
                _id: req.currentUserId
            }, function(error, user) {
                if (!error && !user) {
                    callback(ServerError.ERR_USER_NOT_EXIST);
                } else {
                    callback(null, user);
                }
            });
        }, function(user, callback) {
            user.receivers = user.receivers || [];
            var index = -1;
            var isDefault = false;
            for (i = 0; i < user.receivers.length; i++) {
                if (user.receivers[i].uuid === param.uuid) {
                    index = i;
                    isDefault = user.receivers[i].isDefault;
                    break;
                }
            }

            if (index > -1) {
                user.receivers.splice(index, 1);
                if (isDefault && user.receivers.length > 0) {
                    user.receivers[0].isDefault = true;
                }
            }
            user.save(function(error, user) {
                callback(error, user);
            });
        }], function(error, user) {
            ResponseHelper.response(res, error, {
                user: user
            });
        });
    }
};

user.login = {
    method: 'post',
    func: function(req, res) {
        var param = req.body;
        var mobile = param.mobile || '';
        var password = param.password || '';
        Users.findOne({
            '$and': [{
                mobile: mobile
            }, {
                '$or': [{
                    password: password
                }, {
                    encryptedPassword: _encrypt(password)
                }]
            }]
        }, function(error, user) {
            if (error) {
                ResponseHelper.response(res, error);
            } else if (user) {
                //login succeed
                req.session.userId = user._id;
                req.session.loginDate = new Date();
                ResponseHelper.response(res, error, {
                    user: user
                });
            } else {
                //login fail
                delete req.session.userId;
                delete req.session.loginDate;
                ResponseHelper.response(res, ServerError.ERR_INCORRECT_ID_OR_PASSWORD);
            }
        });
    }
};

/**
 * 移除搜索历史
 *
 * @method post
 * @return {db.user} res.data.user
 */
user.clearSearchHistory = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        async.waterfall([function(callback) {
            Users.findOne({
                _id: req.currentUserId
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
            user.searchHistory.entry = [];
            user.save(function(error, user) {
                if (error) {
                    callback(error);
                } else if (!user) {
                    callback(ServerError.ERR_UNKNOWN);
                } else {
                    callback(null, user);
                }
            });
        }], function(error, user) {
            ResponseHelper.response(res, error, {
                user: user
            });
        });
    }
};

/**
 * 删除推荐商品
 *
 * @method post
 * @param {db.item._id} req._id
 * @return {db.user} res.data.user
 */
user.removeRecommendedItem = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        async.waterfall([function(callback) {
            rUserRecommendedItems.remove({
                initiatorRef: req.currentUserId,
                targetRef: RequestHelper.parseId(req.body._id)
            }, function(error) {
                callback(error);
            });
        }, function(callback) {
            Users.findOne({
                _id: req.currentUserId
            }, function(error, user) {
                callback(error, user);
            });
        }], function(error, user) {
            ResponseHelper.response(res, error, {
                user: user
            });
        });
    }
};

/**
 * 删除所有推荐商品
 *
 * @method post
 * @return {db.user} res.data.user
 */
user.removeAllRecommendedItems = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        async.waterfall([function(callback) {
            rUserRecommendedItems.remove({
                initiatorRef: req.currentUserId
            },function(error) {
                callback(error);
            });
        }, function(callback) {
            Users.findOne({
                _id: req.currentUserId
            }, function(error, user) {
                callback(error, user);
            });
        }], function(error, user) {
            ResponseHelper.response(res, error, {
                user: user
            });
        });
    }
};

/**
 * 验证 mobileVerification 是否已经存在，并且 create 在 1分钟以内
 * 随机生成一个 100000 - 999999 的数字，并调用 SmsService.send 发送给用户
 * 将手机号以 mobileVerification.mobile 为关键字存入 session
 * 将生成的验证码以 mobileVerification.code 为关键字存入 session
 * 将生成的时间以 mobileVerification.create 为关键字存入 session
 *
 * @method post
 * @param {string} req.mobile
 *
 * @return {string} res.data.code
 *      ERR_INVALID_MOBILE
 *      ERR_FREQUENT_REQUEST
 */
user.requestBindMobile = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        var now = new Date();
        var param = req.body;
        if (param.mobile == null || param.mobile.length === 0) {
            ResponseHelper.response(res, ServerError.ERR_INVALID_MOBILE);
            return;
        }
        if (req.session.mobileVerification != null) {
            if ((now.getTime() - req.session.mobileVerification.create.getTime()) < (60 * 1000)) {
                ResponseHelper.response(res, ServerError.ERR_FREQUENT_REQUEST);
                return;
            }
        }

        var mobileVerification = {
            mobile: param.mobile,
            code: '' + _generateCode()
        };

        SmsService.send(param.mobile, mobileVerification.code, function(error) {
            if (error) {
                ResponseHelper.response(res, error);
            } else {
                mobileVerification.create = new Date();
                req.session.mobileVerification = mobileVerification;
                ResponseHelper.response(res, null, {
                    code: mobileVerification.code
                });
            }
        });
    }
};

/**
 * 验证 req.code 是否和 session 中的一致
 * 如果一致，将 req.mobile 存入 db
 *
 * @method post
 * @param {string} req.code
 * @return
 *      ERR_INVALID_CODE
 *      ERR_MOBILE_ALREADY_EXIST
 */
user.bindMobile = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        var param = req.body;
        if (param.code == null || param.code.length === 0) {
            ResponseHelper.response(res, ServerError.ERR_NOT_ENOUGH_PARAM);
            return;
        }

        if (param.code != req.session.mobileVerification.code) {
            ResponseHelper.response(res, ServerError.ERR_INVALID_CODE);
            return;
        }

        async.waterfall([function(callback) {
            Users.find({
                mobile: req.session.mobileVerification.mobile
            }).exec(function(error, users) {
                if (error) {
                    callback(error);
                } else if (users != null && users.length > 0) {
                    callback(null);
                } else {
                    callback(ServerError.ERR_MOBILE_ALREADY_EXIST);
                }
            });
        }, function(callback) {
            Users.findOne({
                _id: req.currentUserId
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
            user.mobile = req.session.mobileVerification.mobile;
            user.role = 1;
            user.save(function(error, user) {
                if (error) {
                    callback(error);
                } else if (!user) {
                    callback(ServerError.ERR_UNKNOWN);
                } else {
                    callback(null, user);
                }
            });
        }], function(error, user) {
            delete req.session.mobileVerification;
            ResponseHelper.response(res, error, {
                user: user
            });
        });
    }
};

/**
 * 调用 NotificationService.bind 绑定该 registrationId 与当前用户
 *
 * @method post
 * @param {string} req.registrationId
 * @return {db.user} res.data.user
 */
user.bindRegistrationId = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        if (req.body.registrationId == null || req.body.registrationId.length === 0) {
            ResponseHelper.response(res, ServerError.ERR_NOT_ENOUGH_PARAM);
            return;
        }

        var userId = req.currentUserId;
        async.waterfall([function(callback) {
            User.findOne({
                _id: userId
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
            NotificationService.bind(req.body.registrationId, userId, function(error) {
                callback(error, user);
            });
        }], function(error, user) {
            ResponseHelper.response(res, error, {
                user: user
            });
        });
    }
};

/**
 * 调用 NotificationService.unbind 解除该 registrationId 与当前用户的绑定
 *
 * @method post
 * @param {string} req.registrationId
 * @return {db.user} res.data.user
 */
user.unbindRegistrationId = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        if (req.body.registrationId == null || req.body.registrationId.length === 0) {
            ResponseHelper.response(res, ServerError.ERR_NOT_ENOUGH_PARAM);
            return;
        }

        var userId = req.currentUserId;
        async.waterfall([function(callback) {
            User.findOne({
                _id: userId
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
            NotificationService.unbind(req.body.registrationId, userId, function(error) {
                callback(error, user);
            });
        }], function(error, user) {
            ResponseHelper.response(res, error, {
                user: user
            });
        });
    }
};

/**
 * 批量查询用户信息
 *
 * @method get
 * @param {string[]} req._ids
 * @return {db.user[]} res.data.user
 */
user.fetch = {
    method: 'get',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        var param = req.queryString;
        var criteral = {};
        if (param._ids == null || param._ids.length === 0) {
            criteral = {};
        } else {
            criteral = {
                _id: {
                    '$in': RequestHelper.parseIds(param._ids)
                }
            };
        }

        Users.find(criteral).exec(function(error, users) {
            ResponseHelper.response(res, error, {
                users: users
            });
        });
    }
};

/**
 * 创建一个 User，role 为 Guest
 *
 * @method post
 * @return {db.user} res.data.user
 */
user.loginAsGuest = {
    method: 'get',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        var user = new Users({
            role: 0
        });

        user.save(function(error, target) {
            if (error) {
                ResponseHelper.response(res, error);
            } else if (!target) {
                ResponseHelper.response(res, ServerError.ERR_UNKNOWN);
            } else {
                ResponseHelper.response(res, null, {
                    user: target
                });
            }
        });
    }
};

/**
 * 验证当前 session 中的用户的 role 是否为 Guest
 *      ERR_DUPLICATE_REGISTER
 * 验证 req.mobile 是否已经和 db 中的一致
 *      ERR_INVALID_MOBILE
 * 调用 RecommendationService 向用户推荐商品
 *
 * @method post
 * @param {string} req.nickname
 * @param {string} req.password
 * @param {string} req.mobile
 * @return {db.user} res.data.user
 *
 */
user.register = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        var param = req.body;
        if (param.nickname == null || param.nickname.length === 0) {
            ResponseHelper.response(res, ServerError.ERR_NOT_ENOUGH_PARAM);
            return;
        }
        if (param.password == null || param.password.length === 0) {
            ResponseHelper.response(res, ServerError.ERR_NOT_ENOUGH_PARAM);
            return;
        }
        if (param.mobile == null || param.mobile.length === 0) {
            ResponseHelper.response(res, ServerError.ERR_NOT_ENOUGH_PARAM);
            return;
        }

        async.waterfall([function(calllback) {
            Users.findOne({
                _id: req.currentUserId
            }, function(error, user) {
                if (error) {
                    callback(error);
                } else if (!user) {
                    callback(ServerError.ERR_UNKNOWN);
                } else {
                    callback(null, user);
                }
            });
        }, function(user, callback) {
            // 验证当前 session 中的用户的 role 是否为 Guest
            if (user.role != 0) {
                callback(ServerError.ERR_DUPLICATE_REGISTER);
                return;
            }

            // 验证 req.mobile 是否已经和 db 中的一致
            if (param.mobile != user.mobile) {
                callback(ServerError.ERR_INVALID_MOBILE);
                return;
            }

            user.role = 1;
            user.nickname = param.nickname;
            user.encryptedPassword = _encrypt(param.password);
            user.password = null;

            user.save(function(error, target) {
                if (error) {
                    callback(error);
                } else if (!target) {
                    callback(ServerError.ERR_UNKNOWN);
                } else {
                    callback(null, target);
                }
            });
        }], function(error, user) {
            ResponseHelper.response(res, error, {
                user: user
            });
        });
    }
};

