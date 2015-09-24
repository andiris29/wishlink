// third party library
var async = require('async');
var mongoose = require('mongoose');
var _ = require('underscore');

// model
var Items = require('../../model/items');
var Users = require('../../model/users');

// services
var SearchTrendService = require('./SearchTrendService');

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
};
