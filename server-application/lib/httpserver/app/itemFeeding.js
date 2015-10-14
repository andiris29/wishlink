// Third party library
var mongoose =  require('mongoose');
var async = require('async');
var _ = require('underscore');

// Model
var Items = require('../../model/items');
var rUserFavoriteItems = require('../../model/rUserFavoriteItem');
var rUserRecommendedItems = require('../../model/rUserRecommendedItem');

// Helper
var RequestHelper = require('../helper/RequestHelper');
var ResponseHelper = require('../helper/ResponseHelper');
var ServiceHelper = require('../helper/ServiceHelper');
var MongoHelper = require('../helper/MongoHelper');
var ContextHelper = require('../helper/ContextHelper');

// Service
var SearchService = require('../service/search/SearchService');

var itemFeeding = module.exports;

/**
 * 查询 rUserRecommendedItem 获得推荐商品
 */
itemFeeding.recommendation = {
    method: 'get',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        ServiceHelper.queryPaging(req, res, function(param, callback) {
            async.waterfall([function(cb) {
                var criteria = {
                    initiatorRef: req.currentUserId
                };
                MongoHelper.queryPaging(rUserRecommendedItems.find(criteria).populate('targetRef').sort({create: -1}), param.pageNo, param.pageSize, cb);
            }, function(models, count, cb) {
                var items = [];
                models.forEach(function(relations) {
                    items.push(relations.targetRef);
                });
                cb(null, items, count);
            }], callback);
        }, function(models) {
            return {
                items: models
            };
        }, {
            afterQuery: function(param, currentPageModels, numTotal, callback) {
                async.series([function(cb) {
                    ContextHelper.appendItemContext(req.currentUserId, currentPageModels, callback);
                }], callback);
            }
        });
    }
};

/**
 * 查询当前用户收藏的 item
 */
itemFeeding.favorite = {
    method: 'get',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        ServiceHelper.queryPaging(req, res, function(param, callback) {
            async.waterfall([function(cb) {
                var criteria = {
                    initiatorRef: req.currentUserId
                };
                MongoHelper.queryPaging(rUserFavoriteItems.find(criteria).populate('targetRef'), param.pageNo, param.pageSize, cb);
            }, function(models, count, cb) {
                var items = [];
                models.forEach(function(relationship) {
                    items.push(relationship.targetRef);
                });
                cb(null, items, count);
            }], callback);
        }, function(models) {
            return {
                items: models
            };
        }, {
            afterQuery: function(param, currentPageModels, numTotal, callback) {
                async.series([function(cb) {
                    ContextHelper.appendItemContext(req.currentUserId, currentPageModels, callback);
                }], callback);
            }
        });
    }
};

itemFeeding.search = {
    method: 'get',
    func: function(req, res) {
        var param = req.queryString;
        var keyword = param.keyword;
        var pageNo = param.pageNo;
        var pageSize = param.pageSize;

        async.waterfall([function (callback) {
            SearchService.saveHistory(keyword, req.currentUserId, function (err) {
                //ignore error of save history
                callback();
            });
        }, function(callback) {
            SearchService.search(keyword, pageNo, pageSize, callback);
        }, function(callback) {
            ContextHelper.appendItemContext(req.currentUserId, items, callback);
        }], function(err, items) {
            ResponseHelper.response(res, err, {
                items: items
            });
        });
    }
};
