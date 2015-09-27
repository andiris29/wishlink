// third party library
var async = require('async');
var mongoose = require('mongoose');
var _ = require('underscore');

// model
var Trades = require('../../model/trades');


var TradeService = module.exports;

TradeService.Status = {
    UNPAY : {
        code : 0,
        order : 'a0',
        name : '未付款'
    },
    PAID: {
        code : 1,
        order : 'b0',
        name : '已付款'
    },
    UN_ORDER_RECEIVE : {
        code : 2,
        order : 'b0',
        name : '未接单'
    },
    ORDER_RECEIVED : {
        code : 3,
        order : 'c0',
        name : '已接单'
    },
    DELIVERED : {
        code : 4,
        order : 'c0',
        name : '已发货'
    },
    RECEIVED : {
        code : 5,
        order : 'd0',
        name : '已确认收货'
    },
    AUTO_RECEIVED : {
        code : 6,
        order : 'd0',
        name : '自动确认收货'
    },
    REQUEST_CANCEL : {
        code : 7,
        order : 'c0',
        name : '请求撤单中'
    },
    CANCELED : {
        code : 8,
        order : 'd0',
        name : '已撤单'
    },
    AUTO_CANCELED : {
        code: 9, 
        order : 'd0',
        name : '自动撤单'
    },
    COMPLAINING : {
        code: 10, 
        order : 'd0',
        name : '投诉处理中'
    },
    COMPLAINED : {
        code: 11,
       order : 'd0',
        name : '投诉处理完成'
    },
    ITEM_REVIEW_REJECTED : {
        code: 12, 
        order : 'b0',
        name : '商品审核失败'
    },
    TRANSFER_TO_SELLER: {
        code: 13, 
        order : 'd0',
        name : '向卖家转账完成'
    },
    TRANSFER_TO_BUYER: {
        code: 14, 
        order : 'd0',
        name : '向买家转账完成'
    }
};

/**
 * 更新交易状态，并加入一条 statusLog
 * 
 * @param {db.user._id} userRef
 * @param {db.trade} trade
 * @param {int} toStatus
 * @param {string} comment
 * @param {statusTo~callback} callback
 */
/**
 * @callback statusTo~callback
 * @param {string} err
 * @param {db.trade} trade
 */
TradeService.statusTo = function(userRef, trade, toStatus, comment, callback) {
    trade.statusLog = trade.statusLog || [];
    var newLog = {
        userRef : userRef,
        status : toStatus,
        comment : comment
    };

    trade.status = toStatus;
    trade.statusOrder = TradeService.findOrderAndNameByCode(toStatus).order;
    trade.update = new Date();
    trade.statusLog.push(newLog);
    trade.save(function(error, trade) {
        callback(error, trade);
    });
};

TradeService.findOrderAndNameByCode = function(code) {
    var targetKey;
    _.each(TradeService.Status, function(value, key) {
        if (value.code === code) {
            targetKey = key;
        }
    });
    return TradeService.Status[targetKey];
};
