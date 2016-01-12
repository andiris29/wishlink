// Third party library
var async = require('async');
var _ = require('underscore');
var winston = require('winston');
var schedule = require('node-schedule');
var moment = require('moment-timezone');

// Model
var Users = require('../../model/users');
var Countries = require('../../model/countries');

// Service
var RecommendationService = require('../../httpserver/service/RecommendationService');
var NotificationService = require('../../httpserver/service/NotificationService');

var _next = function(now, trigger) {
    var nowHours = now.getHours();
    async.waterfall([function(callback) {
        Users.find({}).exec(function(error, users) {
            callback(error, users);
        });
    }, function(users, callback) {
        var targets = [];
        var tasks = _.map(users, function(user) {
            return function(cb) {
                Countries.findOne({
                    _id: user.countryRef
                }, function(error, country) {
                    var tz = moment.tz(now, country.timezone);
                    if (tz.hours() == trigger) {
                        targets.push(users);
                    }
                    cb();
                });
            };
        });

        async.parallel(tasks, function(error) {
            callback(null, targets);
        });
    }, function(users, callback) {
        var tasks = _.map(users, function(user) {
            return function(cb) {
                async.waterfall([function(cb2) {
                    Countries.findOne({
                        _id: user.countryRef
                    }, function(error, country) {
                        cb2(error, country);
                    });
                }, function(country, cb2) {
                    if (country.iso3166 === 'CHN') {
                        RecommendationService.recommendItems(user._id, function(error) {
                            NotificationService.notify([user._id],
                                    NotificationService.notifyDailyInChina.command,
                                    NotificationService.notifyDailyInChina.message,
                                    {},
                                    null);
                            cb2();
                        });
                    } else {
                        RecommendationService.recommendItemsInForeignCountry(user._id, function(error) {
                            NotificationService.notify([user._id],
                                    NotificationService.notifyDailyInForeignCountry.command,
                                    NotificationService.notifyDailyInForeignCountry.message,
                                    {},
                                    null);
                            cb2();
                        });
                    }
                }], function(error) {
                    cb();
                });
            };
        });

        async.parallel(tasks, function(error) {
            callback();
        });
    }], function(error) {
        winston.info('Recommendation Push Notification complete');
    });
};

var _run = function(trigger) {
    var now = new Date();
    winston.info('Recommendation Push Notification at: ', now);
    _next(now, trigger);
};

module.exports = function(config) {
    var trigger = config.schedule.recommendation.hour;
    var rule = new schedule.RecurrenceRule();
    rule.minue = 0;
    schedule.scheduleJob(rule, function() {
        _run(trigger);
    });
};
