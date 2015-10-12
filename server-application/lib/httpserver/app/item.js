// Third party library
var mongoose = require('mongoose');
var async = require('async');
var path = require('path');
var _ = require('underscore');

// Helper
var ServerError = require('../server-error');
var RequestHelper = require('../helper/RequestHelper');
var ResponseHelper = require('../helper/ResponseHelper');
var RelationshipHelper = require('../helper/RelationshipHelper');

// Model
var Items = require('../../model/items');
var Trades = require('../../model/trades');
var RUserFavoriteItem = require('../../model/rUserFavoriteItem');

// Services
var NotificationService = require('../service/NotificationService');
var SearchBuildService = require('../service/search/SearchBuildService');
var TradeService = require('../service/TradeService');

var item = module.exports;

var itemImageResizeOptions = [
    {'suffix': '_640', 'width': 640, 'height': 640},
    {'suffix': '_320', 'width': 320, 'height': 320},
    {'suffix': '_160', 'width': 160, 'height': 160}
];

/**
 * 保存上传的 1-4 张图片，保存原图以及压缩图 _640 _320 _160，并传输图片到 CDN 服务器
 * 创建 db.item
 *
 * @param {string} req.name
 * @param {string} req.brand
 * @param {string} req.country
 * @param {number} req.price
 * @param {string} req.spec
 * @param {string} [req.comment]
 */
item.create = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        async.waterfall([function(callback) {
            RequestHelper.parseFiles(req, global.config.uploads.item.image.ftpPath, itemImageResizeOptions, function(error, fields, files) {
                if (error) {
                    callback(error);
                } else {
                    var param = fields;
                    var newItem = new Items({
                        name: param.name,
                        brand: param.brand,
                        country: param.country,
                        spec: param.spec,
                        price: RequestHelper.parseNumber(param.price),
                        notes: param.notes,
                        images: []
                    });
                    files.forEach(function(file) {
                        var imagePath = global.config.uploads.item.image.exposeToUrl + '/' + path.relative(global.config.uploads.item.image.ftpPath, file.path);
                        newItem.images.push(imagePath);
                    });

                    newItem.save(function(error, newItem) {
                        if (error) {
                            callback(error);
                        } else if (!newItem) {
                            callback(ServerError.ERR_UNKOWN);
                        } else {
                            callback(null, newItem);
                        }
                    });
                }
            });
        }, function(item, callback) {
            SearchBuildService.enableSearch(item, callback);
        }], function(error, item) {
            ResponseHelper.response(res, error, {
                'item': item
            });
        });
    }
};

/**
 * 将 item.approved 更新为 true
 * 将 itemRef 为该 item 的 trade.status 更新为审核通过
 */
item.approve = {
    method: 'post',
    permissionValidators: ['validateLogin', 'validateAdmin'],
    func: function(req, res) {
        var param = req.body;
        async.waterfall([function(callback) {
            Items.findOne({
                '_id': RequestHelper.parseId(param._id)
            }, function(error, item) {
                if (error) {
                    callback(error);
                } else if (!item) {
                    callback(ServerError.ERR_ITEM_NOT_EXIST);
                } else {
                    callback(null, item);
                }
            });
        }, function(item, callback) {
            item.approved = true;
            item.save(function(error, item) {
                callback(error, item);
            });
        }, function(item, callback) {
            Trades.find({
                itemRef: item._id,
                status: TradeService.Status.PAID.code
            }).exec(function(error, trades) {
                callback(error, item, trades);
            });
        }, function(item, trades, callback) {
            var tasks = _.map(trades, function(trade) {
                return function(internalCallback) {
                    TradeService.statusTo(req.currentUserId, trade, TradeService.Status.UN_ORDER_RECEIVE.code, 'item/approve', function(error, trade) {
                        internalCallback(error);
                        NotificationService.notify([trade.ownerRef], NotificationService.notifyItemApproved.command, NotificationService.notifyItemApproved.message, {
                            _id : trade._id
                        }, null);
                    });
                };
            });

            async.parallel(tasks, function(error) {
                callback(null, item);
            });
        }], function(error, item) {
            ResponseHelper.response(res, error, {
                item: item
            });
        });
    }
};

/**
 * 将 item.approved 更新为 false
 * 将 itemRef 为该 item 的 trade.status 更新为审核未通过
 */
item.disapprove = {
    method: 'post',
    permissionValidators: ['validateLogin', 'validateAdmin'],
    func: function(req, res) {
        var param = req.body;
        async.waterfall([function(callback) {
            Items.findOne({
                '_id': RequestHelper.parseId(param._id)
            }, function(error, item) {
                if (error) {
                    callback(error);
                } else if (!item) {
                    callback(ServerError.ERR_ITEM_NOT_EXIST);
                } else {
                    callback(null, item);
                }
            });
        }, function(item, callback) {
            item.approved = false;
            item.save(function(error, item) {
                callback(error, item);
            });
        }, function(item, callback) {
            Trades.find({
                itemRef: item._id,
                status: TradeService.Status.PAID.code
            }).exec(function(error, trades) {
                callback(error, item, trades);
            });
        }, function(item, trades, callback) {
            var tasks = _.map(trades, function(trade) {
                return function(internalCallback) {
                    TradeService.statusTo(req.currentUserId, trade, TradeService.Status.ITEM_REVIEW_REJECTED.code, 'item/disapprove', function(error, trade) {
                        internalCallback(error);
                        NotificationService.notify([trade.ownerRef], NotificationService.notifyItemDisapproved.command, NotificationService.notifyItemDisapproved.message, {
                            _id : trade._id
                        }, null);
                    });
                };
            });

            async.parallel(tasks, function(error) {
                callback(null, item);
            });
        }], function(error, item) {
            ResponseHelper.response(res, error, {
                item: item
            });
        });
    }
};

/**
 * 创建 db.rUserFavoriteItem
 */
item.favorite = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        var initiatorRef = req.currentUserId;
        var targetRef = RequestHelper.parseId(req.body._id);
        async.waterfall([function(callback) {
            RelationshipHelper.create(RUserFavoriteItem, initiatorRef, targetRef, function(error, relationship) {
                callback(error);
            });
        }, function(callback) {
            Items.findOne({
                _id: targetRef
            }, function(error, item) {
                if (error) {
                    callback(error);
                } else if (!item) {
                    callback(ServerError.ERR_ITEM_NOT_EXIST);
                } else {
                    callback(null, item);
                }
            });
        }], function(error, item) {
            ResponseHelper.response(res, error, {
                item: item
            });
        });
    }
};

/**
 * 删除 db.rUserFavoriteItem
 */
item.unfavorite = {
    method: 'post',
    permissionValidators: ['validateLogin'],
    func: function(req, res) {
        var initiatorRef = req.currentUserId;
        var targetRef = RequestHelper.parseId(req.body._id);
        async.waterfall([function(callback) {
            RelationshipHelper.remove(RUserFavoriteItem, initiatorRef, targetRef, function(error, relationship) {
                callback(error);
            });
        }, function(callback) {
            Items.findOne({
                _id: targetRef
            }, function(error, item) {
                if (error) {
                    callback(error);
                } else if (!item) {
                    callback(ServerError.ERR_ITEM_NOT_EXIST);
                } else {
                    callback(null, item);
                }
            });
        }], function(error, item) {
            ResponseHelper.response(res, error, {
                item: item
            });
        });
    }
};

/**
 * 更新 item.category
 * 调用 SearchBuildService.rebuildCategory
 *
 * @param {db.category._id} _categoryId
 */
item.updateCategory = {
    method: 'post',
    permissionValidators: ['validateLogin', 'validateAdmin'],
    func: function(req, res) {
        var param = req.body;
        async.waterfall([function(callback) {
            Items.findOne({
                _id: RequestHelper.parseId(param._id)
            }, function(error, item) {
                if (error) {
                    callback(error);
                } else if (!item) {
                    callback(ServerError.ERR_ITEM_NOT_EXIST);
                } else {
                    callback(null, item);
                }
            });
        }, function(item, callback) {
            SearchBuildService.changeToNewCategory(item, RequestHelper.parseId(param._categoryId), callback);
        }], function(error, item) {
            ResponseHelper.response(res, error, {
                item: item
            });
        });
    }
};

