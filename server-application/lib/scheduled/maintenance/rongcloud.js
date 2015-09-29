// Third party library
var async = require('async');
var _ = require('underscore');
var winston = require('winston');
var schedule = require('node-schedule');
var moment = require('moment');

var exec = require('child_process').exec;

var rongcloudSDK = require('rongcloud-sdk');
var _path;

var _next = function(now) {
    var begin = moment(now);
    var tasks = [];
    for (var i = 1; i <= 24; i++) {
        var history = begin.subtract(i, 'hours');
        var dateString = history.format('YYYYMMDDHH');
        tasks.push(function(callback) {
            rongcloudSDK.message.history(dateString, 'json', function(error, resultText) {
                if (error) {
                    callbck(error);
                } else {
                    var result = JSON.parse(resultText);
                    if (result.code !== 200) {
                        callback();
                        return;
                    }

                    var url = result.url;
                    if (url.length === 0) {
                        callbck();
                        return;
                    }

                    var wget = 'wget -P ' + _path + ' ' + url;
                    winston.debug('Download command [', wget, '] execute');
                    var child = exec(wget, function(error, stdout, stderr) {
                        if (error) {
                            callbck(error);
                        }
                    });
                }
            });
        });
    }
    async.parallel(tasks, function(error) {
        winston.info('Backup RongCloud\'s message complete');
    });
};

var _run = function() {
    var now = new Date();
    winston.info('Backup RongCloud\'s message history run at :', now);
    _next(now);
};

module.exports = function(config) {
    rongcloudSDK.init(config.api.rongcloud.appkey, config.api.rongcloud.appsecret);
    _path = config.schedule.maintenance.message.backupPath;
    var rule = new schedule.RecurrenceRule();
    rule.hour = 1;
    rule.minute = 0;
    schedule.scheduleJob(rule, function() {
        _run();
    });
};
