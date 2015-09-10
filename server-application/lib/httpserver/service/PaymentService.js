// third party library
var async = require('async');
var mongoose = require('mongoose');
var _ = require('underscore');
var request = require('request');
var winston = require('winston');

// model
var Trades = require('../../model/Trades');

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
    var orderName = trade.itemSnapshot.name;
    var url = 'http://localhost:8080/wishilink-payment/wechat/prepay?id=' + trade._id.toString() + '&totalFee=' + trade.totalFee + '&orderName=' + encodeURIComponent(orderName) + '&clientIp=' + ip;
    winston.info(new Date(), 'call weixin prepay url=' + url);
    request.get(url, function(error, response, body) {
        var jsonObject = JSON.parse(body);
        winston.info(new Date(), 'weixin prepayid response :', jsonObject);
        if (jsonObject.metadata) {
            callback(jsonObject.metadata, trade);
        } else {
            trade.pay.weixin['prepayid'] = jsonObject.data.prepay_id;
            trade.save(function(err) {
                callback(err, trade);
            });
        }
    });
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

