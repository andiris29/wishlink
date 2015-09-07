// third party library
var async = require('async');
var mongoose = require('mongoose');
var _ = require('underscore');

// model
var Trades = require('../../model/Trades');

// helper
var ServerError = require('../server-error');
var RequestHelper = require('../helper/RequestHelper');
var ResponseHelper = require('../helper/ResponseHelper');
var RelationshipHelper = require('../helper/RelationshipHelper');

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
    }
}

/**
 * 查询该商品对应的交易
 *
 * @param {db.item._id} req._id
 */
tradeFeeding.byItem = {
    method : 'get',
    permissionValidators : ['validateLogin'],
    func : function(req, res) {
    }
}
