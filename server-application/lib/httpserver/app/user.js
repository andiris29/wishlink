// third party library
var async = require('async');
var mongosee = require('mongoose');
var crypto = require('crypto');

// model
var Users = require('../../model/users');

// service
var NotificationService = require('../service/NotificationService');

// helper
var RequestHelper = require('../helper/RequestHelper');
var ResponseHelper = require('../helper/ResponseHelper');
var ServerError = require('../server-error');

var user = module.exports;

// password's secret key
var _secret = 'wishlink@secret';

var _encrypt = function(value) {
    var cipher = crypto.createCipher('aes192', _secret);
    var enc = cipher.update(value, 'utf8', 'hex');
    enc += cipher.final('hex');
    return enc;
};

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


