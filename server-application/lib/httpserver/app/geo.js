// third party library
var async = require('async');
var mongoose = require('mongoose');
var _ = require('underscore');

// model
var GeoTraces = require('../../model/geoTraces');
var Users = require('../../model/users');
var Countries = require('../../model/countries');

var RequestHelper = require('../helper/RequestHelper');
var ResponseHelper = require('../helper/ResponseHelper');

var RecommendationService = require('../service/RecommendationService');
var NotificationService = require('../service/NotificationService');
var GeoService = require('../service/GeoService');

var geo = module.exports;

/**
 * 将地理位置保存到 geoTraces 中
 * A，获取最后一次有 geoTrace.coutryRef 的数据
 * B，调用 GeoService.differentCountries 获取新国家信息
 *
 * 如果 A 查询失败，或 B 获取到新国家信息成功
 *    更新当前 geoTrace.countryRef 以及 user.countryRef
 *    如果新国家 country.iso3166 不是 CHN，
 *      调用 RecommendationService.recommendInForeignCountry
 *      以及 NotificationService.notifyGotoForeignCountry
 *
 * @method post
 * @param {number} req.device
 * @param {number} req.location.lat
 * @param {number} req.location.lng
 */
geo.trace = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        async.waterfall([function(callback) {
            GeoTraces.find({
                device: req.body.device,
                countryRef: {
                    '$exists': true
                }
            }).sort({
                create: -1
            }).limit(1).exec(function(error, countries) {
                if (error) {
                    callback(error);
                } else if (countries.length === 0) {
                    GeoService.reverseGeocoding(req.body.location, function(error, country) {
                        if (error) {
                            callback(error);
                            return;
                        }
                        var trace = new GeoTraces({
                            device: req.body.device,
                            location: req.body.location,
                            countryRef: country._id
                        });
                        trace.save(function(error, trace) {
                            if (error) {
                                callback(error);
                            } else if (!trace) {
                                callback(ServerError.ERR_UNKOWN);
                            } else {
                                callback(null, trace);
                            }
                        });
                    });
                } else {
                    GeoService.differentCountries(traces[0].location, traces[0].countryRef, req.body.location, function(error, country) {
                        if (error) {
                            callback(error);
                        } else if (country) {
                            var trace = new GeoTraces({
                                device: req.body.device,
                                location: req.body.location,
                                countryRef: country._id
                            });
                            trace.save(function(error, trace) {
                                if (error) {
                                    callback(error);
                                } else if (!trace) {
                                    callback(ServerError.ERR_UNKOWN);
                                } else {
                                    callback(null, trace);
                                }
                            });
                        } else {
                            callback(null, traces[0]);
                        }
                    });
                }
            });
        }, function(trace, callback) {
            Users.findOne({
                _id: req.currentUserId
            }, function(error, user) {
                if (error) {
                    callback(error);
                } else if (!user) {
                    callback(ServerError.ERR_UNKOWN);
                } else {
                    user.countryRef = trace.countryRef;
                    user.save(function(error, user) {
                        if (error) {
                            callback(error);
                        } else if (!user) {
                            callback(ServerError.ERR_UNKOWN);
                        } else {
                            callback(null, trace);
                        }
                    });
                }
            });
        }, function(trace, callback) {
            Countries.findOne({
                _id: trace.countryRef
            }, function(error, country) {
                if (error) {
                    callback(error);
                } else if (!country) {
                    callback(null, trace);
                } else {
                    if (country.iso3166 !== 'CHN') {
                        RecommendationService.recommendItemsInForeignCountry(req.currentUserId, function(error) {
                            var notifyType = NotificationService.notifyGotoForeignCountry;
                            NotificationService.notify([req.currentUserId], notifyType.command, notifyType.message, {}, null);
                            callback(null, trace);
                        });
                    } else {
                        RecommendationService.recommendItems(req.currentUserId, function(error) {
                            callback(null, trace);
                        });
                    }
                }
            });
        }], function(error, trace) {
            ResponseHelper.response(res, error, {
                trace: trace
            });
        });
    }
};

