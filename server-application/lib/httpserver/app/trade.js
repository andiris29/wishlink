// third party library
var async = require('async');
var mongoose = require('mongoose');
var _ = require('underscore');

// model
var Trades = require('../../model/trades');
var Items = require('../../model/items');
var Users = require('../../model/users');

// helper
var ServerError = require('../server-error');
var RequestHelper = require('../helper/RequestHelper');
var ResponseHelper = require('../helper/ResponseHelper');
var RelationshipHelper = require('../helper/RelationshipHelper');

// Service
var TradeService = require('../service/TradeService');

var trade = module.exports;

/**
 * 创建 db.trade，status 为 0
 *
 * @param {string} req.itemRef
 * @param {int} req.quantity
 */
trade.create = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        var newTrade = new Trades({
            itemRef: RequestHelper.parseId(req.body.itemRef),
            quantity: RequestHelper.parseNumber(req.body.quantity),
            ownerRef: req.currentUserId
        });

        async.waterfall([function(callback) {
            newTrade.save(function(error, trade) {
                if (error) {
                    callback(error);
                } else if (!trade) {
                    callback(ServerError.ERR_UNKOWN);
                } else {
                    callback(null, trade);
                }
            });
        }, function(trade, callback) {
            TradeService.statusTo(req.currentUserId, trade, 0, 'trade/create', function(error, trade) {
                if (error) {
                    callback(error);
                } else if (!trade) {
                    callback(ServerError.ERR_UNKOWN);
                } else {
                    callback(null, trade);
                }
            });
        }], function(error, trade) {
            ResponseHelper.response(res, error, {
                trade: trade
            });
        });
    }
};

/**
 * 保存收获地址
 *
 * @param {string} req.receiver.name
 * @param {string} req.receiver.phone
 * @param {string} req.receiver.province
 * @param {string} req.receiver.address
 */
trade.updateReceiver = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        async.waterfall([function(callback) {
            Trades.findOne({
                _id: RequestHelper.parseId(req.body._id)
            }, function(error, trade) {
                if (error) {
                    callback(error);
                } else if (!trade) {
                    callback(ServerError.ERR_TRADE_NOT_EXIST);
                } else {
                    callback(null, trade);
                }
            });
        }, function(trade, callback) {
            trade.receiver = {
                name: req.body.receiver.name,
                phone: req.body.receiver.phone,
                province: req.body.receiver.province,
                address: req.body.receiver.address
            };

            trade.save(function(error, trade) {
                if (error) {
                    callback(error);
                } else if (!trade) {
                    callback(ServerError.ERR_UNKOWN);
                } else {
                    callback(null, trade);
                }
            });
        }], function(error, trade) {
            ResponseHelper.response(res, error, {
                trade: trade
            });
        });
    }
};

/**
 * 调用 PaymentService.getPrepayId 更新交易
 */
trade.prepay = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        async.waterfall([function(callback) {
            Trades.findOne({
                _id: RequestHelper.parseId(req.body._id)
            }, function(error, trade) {
                if (error) {
                    callback(error);
                } else if (!trade) {
                    callback(ServerError.ERR_TRADE_NOT_EXIST);
                } else {
                    callback(null, trade);
                }
            });
        }, function(trade, callback) {
            if (req.body.pay || req.body.pay.weixin) {
                PaymentService.getPrepayId(trade, RequestHelper.getIp(req), function(error, trade) {
                    if (error) {
                        callback(error);
                    } else if (!trade) {
                        callback(ServerError.ERR_UNKOWN);
                    } else {
                        callback(null, trade);
                    }
                });
            } else {
                callback(null, trade);
            }
        }], function(error, trade) {
            ResponseHelper.response(res, error, {
                trade: trade
            });
        });
    }
};

/**
 * 更新 trade 的支付宝／微信支付信息，
 *   如果对应 item.status 为审核中，则新状态为 审核中
 *   如果对应 item.status 为审核通过，则新状态为 审核通过
 *   如果对应 item.status 为审核失败，则新状态为 审核失败
 * 调用 TradeService.statusTo 更新交易状态
 * 如果是支付宝交易，且 ownerRef.alipay.id 为空，则将 trade.pay.alipay.buyer_id 复制到 ownerRef.alipay.id
 */
trade.payCallback = {
    method: 'post',
    func: function(req, res) {
        async.waterfall([function(callback) {
            // find target trade
            Trades.findOne({
                _id: RequestHelper.parseId(req.body._id)
            }, function(error, trade) {
                if (error) {
                    callback(error);
                } else if (!trade) {
                    callback(ServerError.ERR_TRADE_NOT_EXIST);
                } else {
                    callback(null, trade);
                }
            });
        }, function(trade, callback) {
            // update trade's pay info
            if (req.body.type === 'alipay') {
                // update alipay
                trade.pay.alipay.trade_no = req.body.trade_no;
                trade.pay.alipay.trade_status = req.body.trade_status;
                trade.pay.alipay.total_fee = req.body.total_fee;
                trade.pay.alipay.refund_status = req.body.refund_status;
                trade.pay.alipay.gmt_refund = req.body.gmt_refund;
                trade.pay.alipay.seller_id = req.body.seller_id;
                trade.pay.alipay.seller_email = req.body.seller_email;
                trade.pay.alipay.buyer_id = req.body.buyer_id;
                trade.pay.alipay.buyer_email = req.body.buyer_email;

                trade.pay.alipay.notifyLogs = trade.pay.alipay.notifyLogs || [];
                trade.pay.alipay.notifyLogs.push({
                    'notify_type': req.body.notify_type,
                    'notify_id': req.body.notify_id,
                    'trade_status': req.body.trade_status,
                    'refund_status': req.body.refund_status,
                });
            } else if (req.body.type === 'wechat') {
                // update wechat
                trade.pay.weixin.trade_mode = req.body.trade_type;
                trade.pay.weixin.partner = req.body.mch_id;
                trade.pay.weixin.total_fee = req.body.total_fee / 100;
                trade.pay.weixin.transaction_id = req.body.transaction_id;
                trade.pay.weixin.time_end = req.body.time_end;
                trade.pay.weixin.appId = req.body.appid;
                trade.pay.weixin.openId = req.body.openid;
                trade.pay.weixin.notifyLogs = trade.pay.weixin.notifyLogs || [];
                trade.pay.weixin.notifyLogs.push({
                    //'trade_state': req.body['trade_state'],
                    //'date': Date.now
                });
            } else {
                callback(ServerError.ERR_UNKOWN);
                return;
            }

            trade.save(function(error, trade) {
                callback(error, trade);
            });
        }, function(trade, callback) {
            // find item by itemRef
            Items.findOne({
                _id: trade.itemRef
            }, function(error, item) {
                if (error) {
                    callback(error);
                } else if (!item) {
                    callback(ServerError.ERR_ITEM_NOT_EXIST);
                } else {
                    callback(null, trade, item);
                }
            });
        }, function(trade, item, callback) {
            // update trade status
            var newStatus = TradeService.Status.PAID.code;
            if (item.status === 0) {
                // 如果对应 item.status 为审核中，则新状态为 审核中
                newStatus = TradeService.Status.PAID.code;
            } else if (item.status === 1) {
                // 如果对应 item.status 为审核通过，则新状态为 审核通过
                newStatus = TradeService.Status.UN_ORDER_RECEIVE.code;
            } else if (item.status === 2) {
                // 如果对应 item.status 为审核失败，则新状态为 审核失败
                newStatus = TradeService.Status.ITEM_REVIEW_REJECTED.code;
            }
            TradeService.statusTo(null, trade, newStatus, 'trade/payCallback', function(error, trade) {
                if (error) {
                    callback(error);
                } else if (!trade) {
                    callback(ServerError.ERR_UNKOWN);
                } else {
                    callback(null, trade);
                }
            });
        }, function(trade, callback) {
            // find people
            Users.findOne({
                _id: trade.ownerRef
            }, function(error, user) {
                if (error) {
                    callback(error);
                } else if (!user) {
                    callback(ServerError.ERR_USER_NOT_EXIST);
                } else {
                    callback(null, trade, user);
                }
            });
        }, function(trade, user, callback) {
            // update alipay id
            if (req.body.type === 'alipay') {
                if (user.alipay === null || user.alipay.id === null || user.alipay.id.length === 0) {
                    user.alipay.id = trade.pay.alipay.buyer_id;
                    user.save(function(error, user) {
                        callback(null, trade);
                    });
                } else {
                    callback(null, trade);
                }
            } else {
                callback(null, trade);
            }
        }], function(error, trade) {
            ResponseHelper.response(res, error, {
                trade: trade
            });
        });
    }
};

/**
 * 调用 PaymentService.syncStatus 更新交易
 */
trade.postpay = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        async.waterfall([function(callback) {
            Trades.findOne({
                _id: RequestHelper.parseId(req.body._id)
            }, function(error, trade) {
                if (error) {
                    callback(error);
                } else if (!trade) {
                    callback(ServerError.ERR_TRADE_NOT_EXIST);
                } else {
                    callback(null, trade);
                }
            });
        }, function(trade, callback) {
            PaymentService.syncStatus(trade, function(error, trade) {
                callback(error, trade);
            });
        }], function(error, trade) {
            ResponseHelper.response(res, error, {
                trade: trade
            });
        });
    }
};

/**
 * 如果当前 trade.assigneeRef 为空，则新状态为 已撤单
 * 如果对应 trade.assigneeRef 不为空，则新状态为 请求撤单中
 * 调用 TradeService.statusTo 更新交易状态
 */
trade.cancel = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        async.waterfall([function(callback) {
            Trades.findOne({
                _id: RequestHelper.parseId(req.body._id)
            }, function(error, trade) {
                if (error) {
                    callback(error);
                } else if (!trade) {
                    callback(ServerError.ERR_TRADE_NOT_EXIST);
                } else {
                    callback(null, trade);
                }
            });
        }, function(trade, callback) {
            var newStatus = TradeService.Status.CANCELED.code;
            if (trade.assigneeRef !== null) {
                newStatus = TradeService.Status.REQUEST_CANCEL.code;
            }

            TradeService.statusTo(req.currentUserId, trade, newStatus, 'trade/cancel', function(error, trade) {
                callback(error, trade);
            });
        }], function(error, trade) {
            ResponseHelper.response(res, error, {
                trade: trade
            });
        });
    }
};

/**
 * 更新 trade.assigneeRef
 * 调用 TradeService.statusTo 更新交易状态
 */
trade.assignToMe = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        async.waterfall([function(callback) {
            Trades.findOne({
                _id: RequestHelper.parseId(req.body._id)
            }, function(error, trade) {
                if (error) {
                    callback(error);
                } else if (!trade) {
                    callback(ServerError.ERR_TRADE_NOT_EXIST);
                } else {
                    callback(null, trade);
                }
            });
        }, function(trade, callback) {
            trade.assigneeRef = req.currentUserId;
            TradeService.statusTo(req.currentUserId, trade, TradeService.Status.ORDER_RECEIVED.code, 'trade/assignToMe', function(error, trade) {
                callback(error, trade);
            });
        }], function(error, trade) {
            ResponseHelper.response(res, error, {
                trade: trade
            });
        });
    }
};

/**
 * 更新 trade.assigneeRef
 * 调用 TradeService.statusTo 更新交易状态
 */
trade.unassign = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        async.waterfall([function(callback) {
            // find trade
            Trades.findOne({
                _id: RequestHelper.parseId(req.body._id)
            }, function(error, trade) {
                if (error) {
                    callback(error);
                } else if (!trade) {
                    callback(ServerError.ERR_TRADE_NOT_EXIST);
                } else {
                    callback(null, trade);
                }
            });
        }, function(trade, callback) {
            var newStatus = 0;
            if (trade.status === TradeService.Status.ORDER_RECEIVED.code) {
                newStatus = TradeService.Status.UN_ORDER_RECEIVE.code;
            } else {
                callback(ServerError.ERR_TRADE_STATUS);
                return;
            }

            trade.assigneeRef = null;
            TradeService.statusTo(req.currentUserId, trade, newStatus, 'trade/unassign', function(error, trade) {
                callback(error, trade);
            });
        }], function(error, trade) {
            ResponseHelper.response(res, error, {
                trade: trade
            });
        });
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
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        async.waterfall([function(callback) {
            Trades.findOne({
                _id: RequestHelper.parseId(req.body._id)
            }, function(error, trade) {
                if (error) {
                    callback(error);
                } else if (!trade) {
                    callback(ServerError.ERR_TRADE_NOT_EXIST);
                } else {
                    callback(null, trade);
                }
            });
        }, function(trade, callback) {
            trade.delivery = {
                company: req.body.company,
                trackingId: req.body.trackingId
            };

            TradeService.statusTo(req.currentUserId, trade, TradeService.Status.DELIVERED.code, 'trade/deliver', function(error, trade) {
                callback(error, trade);
            });
        }], function(error, trade) {
            ResponseHelper.response(res, error, {
                trade: trade
            });
        });
    }
};

/**
 * 调用 TradeService.statusTo 更新交易状态
 */
trade.receipt = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        async.waterfall([function(callback) {
            Trades.findOne({
                _id: RequestHelper.parseId(req.body._id)
            }, function(error, trade) {
                if (error) {
                    callback(error);
                } else if (!trade) {
                    callback(ServerError.ERR_TRADE_NOT_EXIST);
                } else {
                    callback(null, trade);
                }
            });
        }, function(trade, callback) {
            trade.delivery = trade.delivery || {};
            trade.delivery.receiptDate = new Date();

            TradeService.statusTo(req.currentUserId, trade, TradeService.Status.RECEIVED.code, 'trade/receipt', function(error, trade) {
                callback(error, trade);
            });
        }], function(error, trade) {
            ResponseHelper.response(res, error, {
                trade: trade
            });
        });
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
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        async.waterfall([function(callback) {
            Trades.findOne({
                _id: RequestHelper.parseId(req.body._id)
            }, function(error, trade) {
                if (error) {
                    callback(error);
                } else if (!trade) {
                    callback(ServerError.ERR_TRADE_NOT_EXIST);
                } else {
                    callback(null, trade);
                }
            });
        }, function(trade, callback) {
            trade.complaints = trade.complaints || [];
            RequestHelper.parseFiles(req, global.config.uploads.trade.complaint.ftpPath, null, function(error, fields, files) {
                if (error) {
                    callback(error);
                    return;
                }

                var complaint = {
                    problem: fields.problem,
                    images: [],
                    resolution: {}
                };

                files.forEach(function(file) {
                    var imagePath = global.config.uploads.trade.complaint.exposeToUrl + '/' + path.relative(global.config.uploads.trade.complaint.ftpPath, file.path);
                    complaint.images.push(imagePath);
                });
                TradeService.statusTo(req.currentUserId, trade, TradeService.Status.COMPLAINING.code, 'trade/complaint', function(error, trade) {
                    callback(error, trade);
                });
            });
        }], function(error, trade) {
            ResponseHelper.response(res, error, {
                trade: trade
            });
        });
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
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        async.waterfall([function(callback) {
            Trades.findOne({
                _id: RequestHelper.parseId(req.body._id)
            }, function(error, trade) {
                if (error) {
                    callback(error);
                } else if (!trade) {
                    callback(ServerError.ERR_TRADE_NOT_EXIST);
                } else {
                    callback(null, trade);
                }
            });
        }, function(trade, callback) {
            trade.complaints[RequestHelper.parseInteger(req.body.index)].resolution = {
                staffRef: req.currentUserId,
                notes: req.body._id
            };

            TradeService.statusTo(req.currentUserId, trade, TradeService.Status.COMPLAINED.code, 'trade/resolveComplaint', function(error, trade) {
                callback(error, trade);
            });
        }], function(error, trade) {
            ResponseHelper.response(res, error, {
                trade: trade
            });
        });
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
/*
trade.markTransfered = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
    }
};
*/

/**
 * 移除相关 user.unread.tradeRefs
 */
trade.read = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        async.waterfall([function(callback) {
            Trades.findOne({
                _id: RequestHelper.parseId(req.body._id)
            }, function(error, trade) {
                if (error) {
                    callback(error);
                } else if (!trade) {
                    callback(ServerError.ERR_TRADE_NOT_EXIST);
                } else {
                    callback(null, trade);
                }
            });
        }, function(trade, callback) {
            Users.findOne({
                _id: trade.ownerRef
            }, function(error, user) {
                if (error) {
                    callback(error);
                } else if (!user) {
                    callback(ServerError.ERR_USER_NOT_EXIST);
                } else {
                    callback(null, trade, user);
                }
            });
        }, function(trade, user, callback) {
            user.unread.tradeRefs = user.unread.tradeRefs || [];
            var tradeRefs = _.filter(user.unread.tradeRefs, function(e) {
                return e.toString !== trade._id.toString();
            });
            user.unread.tradeRefs = tradeRefs;
            user.save(function(error, user) {
                if (error) {
                    callback(error);
                } else if (!user) {
                    callback(ServerError.ERR_UNKOWN);
                } else {
                    callback(null, trade);
                }
            });
        }], function(error, trade) {
            ResponseHelper.response(res, error, {
                trade: trade
            });
        });
    }
};

