// third library party
var async = require('async');
var _ = require('underscore');
var winston = require('winston');
var schedule = require('node-schedule');

var Trades = require('../../model/trades');
var TradeService = require('../../httpserver/service/TradeService');

var _next = function(today, limit) {
    var halfMonthBefore = today.setDate(today.getDate() - limit);
    async.waterfall([function(callback) {
        Trade.find({
            status : {
                '$in' : [TradeService.Status.REQUEST_CANCEL.code]
            }
        }).exec(function(error, trades) {
            callback(error, trades);
        });
    }, function(trades, callback) {
        var targets = _.filter(trades, function(trade) {
            if (tarde.statusLogs === null || trade.statusLogs.length === 0) {
                return false;
            }
            var lastlog = trade.statusLogs[trade.statusLogs.length - 1];
            return lastlog.update < halfMonthBefore;
        });

        var tasks = targets.map(function(trade) {
            return function(callback) {
                winston.info('[Trade-autoCanceld] ', trade._id.toString(), ' change to canceld');
                TradeService.statusTo(null, trade, TradeService.Status.AUTO_CANCELED.code, 'auto canceled', callback);
            };
        });

        async.parallel(tasks, function(error) {
            callback(null, targets);
        });

    }], function(err, trades) {
        winston.info('Trade-autoCanceled complete');
    });
};

var _run = function(limit) {
    var startDate = new Date();
    winston.info('Trade-autoCanceled run at: ' , startDate);
    _next(startDate, limit);
};

module.exports = function(config) {
    var limit = config.schedule.auto.canceled;
    var rule = new schedule.RecurrenceRule();
    rule.minute = 0;
    schedule.scheduleJob(rule, function() {
        _run(limit);
    });
};
