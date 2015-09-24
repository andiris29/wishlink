// third party library
var JPush = require('jpush-sdk');
var winston = require('winston');
var _ = require('underscore');
var winston = require('winston');

// model
var Users = require('../../model/users');
var jPushAudiences = require('../../model/jPushAudiences');


var NotificationService = module.exports;

// get appkey and master key from config.properties
var _getJPushClient = function() {
    var config = global.config.notification.jpush.sdk;
    return JPush.buildClient(config.appkey, config.masterkey);
};

var client = _getJPushClient();

// Recommend's Push Notification 
NotificationService.notifyDailyInChina= {
    command : 'recommend/dailyInChina',
    message : 'recommend/dailyInChina\'s message!'  // TBD
};
NotificationService.notifyDailyInForeignCountry= {
    command : 'recommend/dailyInForeignCountry',
    message : 'recommend/dailyInForeignCountry\'s message!'  // TBD
};
NotificationService.notifyGotoForeignCountry = {
    command : 'recommend/gotoForeignCountry',
    message : 'recommend/gotoForeignCountry\'s message!'  // TBD
};

// Trade's Push Notification
NotificationService.notifyItemApproved = {
    command : 'trade/itemApproved',
    message : '恭喜哟！你发布的心愿审核通过了'
};

NotificationService.notifyItemDisapproved = {
    command : 'trade/itemApproved',
    message : '你发布的心愿还需要完善，现在就去吧'
};
NotificationService.notifyAssigned = {
    command : 'trade/assigned',
    message : '你的心愿已经被接单了，请耐心等待哦'
};
NotificationService.notifyUnassigned = {
    command : 'trade/unassigned',
    message : '你确定要撤单吗？'
};
NotificationService.notifyUnassigned2 = {
    command : 'trade/unassigned2',
    message : '已被接单的订单需要卖家同意才能撤销哦'
};
NotificationService.notifyDelivered = {
    command : 'trade/delivered',
    message : '你的心愿快要达成了，正马不停蹄朝你飞来'
};
NotificationService.notifyRequestCancel = {
    command : 'trade/requestCancel',
    message : '您取消了抢单，买家会伤心的，确定要取消吗？'
};
NotificationService.notifyRequestCancel2 = {
    command : 'trade/requestCancel2',
    message : '买家请求撤单，请帮助买家取消此订单，谢谢'
};
NotificationService.notifyreceipted = {
    command : 'trade/receipted',
    message : '撤单成功'
};
NotificationService.notifyComplaint = {
    command : 'trade/complaint',
    message : '您的投诉我们很在乎，会尽快处理哦'
};
NotificationService.notifyComplaintResolved = {
    command : 'trade/complaintResolved',
    message : '您的投诉已解决，请查看'
};

/**
 * 绑定用户与极光推送的 registrationId
 * 
 * @param {string} registrationId
 * @param {db.user._id} _id
 * @param {bind~callback} callback
 */
/**
 * @callback bind~callback
 * @param {string} err
 * @param {db.jPushAudiences} audience
 */
NotificationService.bind = function(registrationId, _id, callback) {
    jPushAudiences.remove({
        'registrationId' : registrationId
    }, function(error) {
        if (error) {
            callback(error);
            return;
        }
        var info = new jPushAudiences({
            'registrationId' : registrationId,
            'userRef' : _id
        });
        info.save(function(error, info) {
            callback(error, info);
        });
    });
};

/**
 * 解除用户与极光推送的 registrationId 绑定
 * 
 * @param {string} registrationId
 * @param {db.user._id} [_id]
 * @param {unbind~callback} callback
 */
/**
 * @callback unbind~callback
 * @param {string} err
 */
NotificationService.unbind = function(registrationId, _id, callback) {
    var criteria = {
        'registrationId' : registrationId
    };

    if (_id) {
        criteria.userRef = _id;
    }
    jPushAudiences.remove(criteria. callback);
};

/**
 * 发送推送通知
 * 
 * @param {db.user._id[]} _ids
 * @param {string} command
 * @param {string} message
 * @param {object} [extras]
 * @param {notify~callback} callback
 */
/**
 * @callback notify~callback
 * @param {string} err
 */
NotificationService.notify = function(_ids, command, message, extras, callback) {
    async.waterfall([function(cb) {
        jPushAudiences.find({
            userRef : {
                '$in' : _ids
            }
        }).exec(function(error, infos) {
            cb(error, infos);
        });
    }, function(targets, cb) {
        var registrationIDs = [];
        targets.forEach(function(target) {
            registrationIDs.push(target.registrationId);
        });
        var sendTargets = _.filter(registrationIDs, function(registrationId) {
            return (registrationId && (registrationId.length > 0));
        });
        if (sendTargets.length > 0) {
            extras.command = command;
            client.push().setPlatform('ios', 'android')
                .setAudience(JPush.registration_id(sendTargets))
                .setNotification(JPush.ios(message, 'default', null, false, extras), JPush.android(message, message, null, extras))
                .setOptions(null, null, null, true, null)
                .send(function(err, res) {
                    if (err) {
                        winston.error('Push error: ', err);
                    } else {
                        winston.info('Push success: ', res);
                    }
                    if (cb) {
                        cb(err, res);
                    }
                });
        }
    }], function(error) {
        if (callbck) {
            callbck(error);
        }
    });
};
