// Third party library
var async = require('async');
var mongoose = require('mongoose');
var _ = require('underscore');

// Model
var Trades = require('../../model/trades');
var Items = require('../../model/items');
var Users = require('../../model/users');

// Helper
var ServerError = require('../server-error');
var RequestHelper = require('../helper/RequestHelper');
var ResponseHelper = require('../helper/ResponseHelper');
var RelationshipHelper = require('../helper/RelationshipHelper');
var ServiceHelper = require('../helper/ServiceHelper');
var MongoHelper = require('../helper/MongoHelper');

var tradeFeeding = module.exports;

/**
 * 查询 assigneeRef 为当前登录用户的交易
 *
 * @param {int[]} req.statuses
 */
tradeFeeding.asSeller = {
    method : 'get',
    permissionValidators : ['validateLogin'],
    func : function(req, res) {
        ServiceHelper.queryPaging(req, res, function(param, callback) {
            var criteria = {
                assigneeRef : req.currentUserId,
            };
            if (param.statuses) {
                criteria.status = {
                    '$in' : RequestHelper.parseInts(param.statuses)
                };
            }
            MongoHelper.queryPaging(Trades.find(criteria).populate('itemRef').populate('ownerRef'), param.pageNo, param.pageSize, callback);
        }, function(trades) {
            return {
                'trades' : trades 
            };
        }, {
        });
    }
};

/**
 * 查询 ownerRef 为当前登录用户的交易
 *
 * @param {int[]} req.statuses
 */
tradeFeeding.asBuyer = {
    method : 'get',
    permissionValidators : ['validateLogin'],
    func : function(req, res) {
        ServiceHelper.queryPaging(req, res, function(param, callback) {
            var criteria = {
                ownerRef : req.currentUserId,
            };
            if (param.statuses) {
                criteria.status = {
                    '$in' : RequestHelper.parseInts(param.statuses)
                };
            }
            MongoHelper.queryPaging(Trades.find(criteria).populate('itemRef').populate('ownerRef'), param.pageNo, param.pageSize, callback);
        }, function(trades) {
            return {
                'trades' : trades 
            };
        }, {
        });
    }
};

/**
 * 查询该商品对应的交易
 *
 * @param {db.item._id} req._id
 */
tradeFeeding.byItem = {
    method : 'get',
    permissionValidators : ['validateLogin'],
    func : function(req, res) {
        ServiceHelper.queryPaging(req, res, function(param, callback) {
            var criteria = {
                itemRef : RequestHelper.parseId(param._id),
            };
            MongoHelper.queryPaging(Trades.find(criteria).populate('itemRef').populate('ownerRef'), param.pageNo, param.pageSize, callback);
        }, function(trades) {
            return {
                'trades' : trades 
            };
        }, {
        });
    }
};
