// third party library
var JPush = require('jpush-sdk');
var winston = require('winston');
var _ = require('underscore');

// model
var Users = require('../../model/users');
var jPushAudiences = require('../../model/jPushAudiences');


var NotificationService = module.exports;

// get appkey and master key from config.properties
//TODO @Hashmap 编译时global.config还没设置，需要延迟读取
//var config = global.config.notification.jpush.sdk;
//var client = JPush.buildClient(config.appkey, config.masterkey);

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
};
