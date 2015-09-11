// third party library
var async = require('async');
var mongoose = require('mongoose');
var _ = require('underscore');
var request = require('request');
var winston = require('winston');

// model
var Trades = require('../../model/trades');
var Items = require('../../model/items');

// helper
var ServerError = require('../server-error');
var RequestHelper = require('../helper/RequestHelper');
var ResponseHelper = require('../helper/ResponseHelper');
var RelationshipHelper = require('../helper/RelationshipHelper');

var PaymentService = module.exports;

/** 
 * 参考倾秀
 * 调用支付服务 wechat/prepay
 */
PaymentService.getPrepayId = function(trade, ip, callback) {
    async.waterfall([function(cb) {
        Items.findOne({
            _id : trade.itemRef
        }, function(error, item) {
            if (error) {
                cb(error);
            } else if (!item) {
                cb(ServerError.ERR_ITEM_NOT_EXIST);
            } else {
                cb(null, item);
            }
        });
    }, function(item, cb) {
        var orderName = item.name;
        var totalFee = Math.max(0.01, trade.quantity * item.price).toFixed(2);
        var url = 'http://localhost:8080/wishilink-payment/wechat/prepay?id=' + trade._id.toString() + '&totalFee=' + totalFee + '&orderName=' + encodeURIComponent(orderName) + '&clientIp=' + ip;
        winston.info(new Date(), 'call weixin prepay url=' + url);
        request.get(url, function(error, response, body) {
            var jsonObject = JSON.parse(body);
            winston.info(new Date(), 'weixin prepayid response :', jsonObject);
            if (jsonObject.metadata) {
                cb(jsonObject.metadata, trade);
            } else {
                trade.pay.weixin['prepayid'] = jsonObject.data.prepay_id;
                trade.save(function(err) {
                    cb(err, trade);
                });
            }
        });
    }], callback);
};

/** 
 * 参考倾秀
 * 调用支付服务 wechat/queryOrder
 */
PaymentService.syncStatus = function(trade, callback) {
};

/** 
 * 参考倾秀
 * 调用支付服务 wechat/deliverNotify
 */
PaymentService.reverseSyncDelivery = function(trade, callback) {
};

/**
 * 退款，将钱从平台账户转至买家账户。不会修改交易本身
 * 
 * @param {db.trade} trade
 * @param {refund~callback} callback
 */
/**
 * @callback refund~callback
 * @param {string} err
 */
PaymentService.refund = function(trade, callback) {
};

/**
 * 支付，将钱从平台账户转至卖家账户。不会修改交易本身
 * 
 * @param {db.trade} trade
 * @param {pay~callback} callback
 */
/**
 * @callback pay~callback
 * @param {string} err
 */
PaymentService.pay = function(trade, callback) {
};

