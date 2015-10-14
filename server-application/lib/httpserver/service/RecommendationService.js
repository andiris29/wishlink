// third party library
var async = require('async');
var mongoose = require('mongoose');
var _ = require('underscore');

// model
var Items = require('../../model/items');
var Users = require('../../model/users');
var Countries = require('../../model/countries');
var rUserRecommendedItem = require('../../model/rUserRecommendedItem');

// services
var SearchTrendService = require('./search/SearchTrendService');
var SearchService = require('./search/SearchService');

// helpers
var RelationshipHelper = require('../helper/RelationshipHelper');
var ServerError = require('../server-error');

var RecommendationService = module.exports;

/**
 * 通过 SearchTrendService.queryItems 查询热门商品
 * 将商品插入 rUserRecommendedItem
 *
 * @param {db.user._id} _id
 * @param {recommendItems~callback} callback
 */
/**
 * @callback recommendItems~callback
 * @param {string} err
 */
RecommendationService.recommendItems = function(_id, callback) {
    SearchTrendService.queryItems(1, 10, function(error, trends) {
        if (error) {
            callback(error);
            return;
        }
        var tasks = _.map(trends, function(trend) {
            return function(cb) {
                RelationshipHelper.create(rUserRecommendedItem, _id, trend.name, function(error) {
                    cb(error);
                });
            };
        });

        async.parallel(tasks, function(error) {
            callback(error);
        });
    });
};

/**
 * 通过 SearchService.search 查询该国家热门商品
 * 将商品插入 rUserRecommendedItem
 *
 * @param {db.user._id} _id
 * @param {recommendItemsInForeignCountry~callback} callback
 */
/**
 * @callback recommendItemsInForeignCountry~callback
 * @param {string} err
 */
RecommendationService.recommendItemsInForeignCountry = function(_id, callback) {
    async.waterfall([function(cb) {
        Users.findOne({
            _id: _id
        }, function(error, user) {
            if (error) {
                cb(error);
            } else if (!user) {
                cb(ServerError.ERR_USER_NOT_EXIST);
            } else {
                cb(null, user);
            }
        });
    }, function(user, cb) {
        Countries.findOne({
            _id: user.countryRef
        }, function(error, country) {
            if (error) {
                cb(error);
            } else {
                cb(null, country);
            }
        });
    }, function(country, cb) {
        SearchService.search(country.name, 1, 10, function(error, items) {
            if (error) {
                cb(error);
                return;
            }
            var tasks = _.map(items, function(item) {
                return function(internalCallback) {
                    RelationshipHelper.create(rUserRecommendedItem, _id, item._id, function(error) {
                        internalCallback(error);
                    });
                };
            });
            async.parallel(tasks, cb);
        });
    }], function(error) {
        callback(error);
    });
};
