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

var trade = module.exports;

/**
 * 创建 db.trade，status 为 0
 *
 * @param {string} req.itemRef
 * @param {int} req.quantity
 */
trade.create = {
    method : 'post',
    permissionValidators : ['validateLogin'],
    func : function(req, res) {
    }
};

/**
 * 调用 PaymentService.getPrepayId 更新交易
 */
trade.prepay = {
    method : 'post',
    permissionValidators : ['validateLogin'],
    func : function(req, res) {
    }
};

/**
 * 更新 trade 的支付宝／微信支付信息，
 *   如果对应 item.status 为审核中，则新状态为 审核中
 *   如果对应 item.status 为审核通过，则新状态为 审核通过
 *   如果对应 item.status 为审核失败，则新状态为 审核失败
 * 调用 TradeService.statusTo 更新交易状态
 * 如果是支付宝交易，且 ownerRef.alipay.id 为空，则将 trade.pay.alipay.buyer_id 复制到 ownerRef.alipay.id
 * 
 */
trade.payCallback = {
    method : 'post',
    permissionValidators : ['validateLogin'],
    func : function(req, res) {
    }
};

/**
 * 调用 PaymentService.syncStatus 更新交易
 */
trade.postpay = {
    method : 'post',
    permissionValidators : ['validateLogin'],
    func : function(req, res) {
    }
};

/**
 * 如果当前 trade.assigneeRef 为空，则新状态为 已撤单
 * 如果对应 trade.assigneeRef 不为空，则新状态为 请求撤单中
 * 调用 TradeService.statusTo 更新交易状态
 */
trade.cancel = {
    method : 'post',
    permissionValidators : ['validateLogin'],
    func : function(req, res) {
    }
};

/**
 * 更新 trade.assigneeRef
 * 调用 TradeService.statusTo 更新交易状态
 */
trade.assignToMe = {
    method : 'post',
    permissionValidators : ['validateLogin'],
    func : function(req, res) {
    }
};

/**
 * 更新 trade.assigneeRef
 * 调用 TradeService.statusTo 更新交易状态
 */
trade.unassign = {
    method : 'post',
    permissionValidators : ['validateLogin'],
    func : function(req, res) {
    }
};

/**
 * 更新 trade.delivery.*
 * 调用 TradeService.statusTo 更新交易状态
 * 调用 PaymentService.reverseSyncDelivery 更新交易
 *
 * @param {string} req.company
 * @param {string} req.trackingId
 */
trade.deliver = {
    method : 'post',
    permissionValidators : ['validateLogin'],
    func : function(req, res) {
    }
};

/**
 * 调用 TradeService.statusTo 更新交易状态
 */
trade.receipt = {
    method : 'post',
    permissionValidators : ['validateLogin'],
    func : function(req, res) {
    }
};

/**
 * 保存上传的投诉图片
 * 往 trade.complaints 中添加一个元素
 * 调用 TradeService.statusTo 更新交易状态
 * 
 * @param {string} req.problem
 */
trade.complaint = {
    method : 'post',
    permissionValidators : ['validateLogin'],
    func : function(req, res) {
    }
};

/**
 * 更新 trade.complaints[]
 * trade.complaints[].staffRef 为当前登录用户
 * 调用 TradeService.statusTo 更新交易状态
 * 
 * @param {string} req.index
 * @param {string} req.notes
 */
trade.resolveComplaint = {
    method : 'post',
    permissionValidators : ['validateLogin'],
    func : function(req, res) {
    }
};


/**
 * 更新 trade.transfer
 * 调用 TradeService.statusTo 更新交易状态
 *
 * @param {string} direction 枚举 "buyer", "seller"
 * @param {string} [req.weixin.transaction_id]
 * @param {string} [req.alipay.trade_no]
 */
trade.markTransfered = {
    method : 'post',
    permissionValidators : ['validateLogin'],
    func : function(req, res) {
    }
};

/**
 * 移除相关 user.unread.tradeRefs
 */
trade.read = {
    method : 'post',
    permissionValidators : ['validateLogin'],
    func : function(req, res) {
    }
};

