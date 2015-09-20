// third party library
var mongoose =  require('mongoose');
var async = require('async');
var _ = require('underscore');

// model
var Items = require('../../model/items');
var rUserFavoriteItems = require('../../model/rUserFavoriteItem');
var rUserRecommendedItems = require('../../model/rUserRecommendedItem');


// helper
var RequestHelper = require('../helper/RequestHelper');
var ResponseHelper = require('../helper/ResponseHelper');
var ServiceHelper = require('../helper/ServiceHelper');
var MongoHelper = require('../helper/MongoHelper');

var itemFeeding = module.exports;

/**
 * 查询 rUserRecommendedItem 获得推荐商品
 */
itemFeeding.recommendation = {
    method : 'get',
    func : function(req, res) {
    }
};

/**
 * 查询当前用户收藏的 item
 */
itemFeeding.favorite = {
    method : 'get',
    permissionValidators : ['validateLogin'],
    func : function(req, res) {
        ServiceHelper.queryPaging(req, res, function(param, callback) {
            async.waterfall([function(cb) {
                var criteria = {
                    initiatorRef : req.currentUserId
                };
                MongoHelper.queryPaging(rUserFavoriteItems.find(criteria).populate('targetRef'), param.pageNo, param.pageSize, function(error, models) {
                    cb(error, models);
                });
            }, function(models, cb) {
                var items = [];
                models.forEach(function(relationship) {
                    items.push(relationship.targetRef);
                });
                cb(null, items); 
            }], callback);
        }, function (models) {
            return {
                item : models
            };
        });
    }
};
