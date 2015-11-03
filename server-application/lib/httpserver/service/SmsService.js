// Third Party Library
var async = require('async');
var request = require('request');
var winston = require('winston');
var crypto = require('crypto');
var moment = require('moment');

var SmsService = module.exports;

var version = '';

var _md5sign = function(value) {
    var md5Sign = crypto.createHash('md5');
    md5Sign.update(value);
    var result = md5Sign.digest('hex');
    return result = result.toUpperCase();
};

var _base64 = function(value) {
    var buf = new Buffer(value);
    return buf.toString('base64');
};

/**
 * 通过 容联云 发送短消息给该手机
 */
SmsService.send = function(mobile, code) {
    // get cloopen's config from config file
    var config = global.config.api.cloopen;
    var sid = config.sid;
    var token = config.token;
    var version = config.version;
    var appid = config.appid;

    var appSetting = config.appSetting[config.mode];

    // generate timestamp
    var now = moment();
    var timestamp = now.format('YYYYMMDDHHmmss');

    // generate sign
    // sign's rule reference: [http://docs.yuntongxun.com/index.php/Rest%E4%BB%8B%E7%BB%8D]
    var sig = _md5sign(sid + token + timestamp);

    // send template sms's api
    var apiUrl = appSetting.url + '/' + version + '/Accounts/' + sid + '/SMS/TemplateSMS?sig=' + sig;

    winston.info('call cloopen\'s template sms api:', apiUrl);

    // generate base authorization's head
    // head's rule reference: [http://docs.yuntongxun.com/index.php/Rest%E4%BB%8B%E7%BB%8D]
    var baseAuthorization = _base64(sid + ':' + timestamp);
    // make http head
    var httpHeader = {
        'Accept': 'application/json',
        'Content-Type': 'application/json;charset=utf-8',
        'Authorization': baseAuthorization
    };

    var options = {
        method: 'post',
        url: apiUrl,
        headers: httpHeader,
        json: true,
        body: {
            to: mobile,
            appid: appid,
            datas: {
                data: code,
                data: 1
            }
        }
    };
    request(options, function(error) {
    });
};
