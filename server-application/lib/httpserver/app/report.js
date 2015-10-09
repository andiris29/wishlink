// thrid party library
var mongoose = require('mongoose');
var async = require('async');
var _ = require('underscore');

// model
var Trades = require('../../model/trades');
var Users = require('../../model/users');
var Items = require('../../model/items');

// helpers
var RequestHelper = require('../helper/RequestHelper');
var ResponseHelper = require('../helper/ResponseHelper');

// Services
var TradeService = require('../service/TradeService');

var report = module.exports;

/**
 * 聚集 db.trade 获得所有订单数量，以及完成订单数量
 * 
 * @method get
 * @return {int} res.data.numTrades
 * @return {int} res.data.numCompleteTrades
 */
report.numTrades = {
    method : 'get',
    func : function(req, res) {
        var mapReduce = {
            map : function() {
                if (this.status === 14 || this.status === 13) {
                    emit('numCompleteTrades', 1);
                }
                emit('numTrades', 1);
            }, 
            reduce : function(key, values) {
                return Array.sum(values);
            },
            query : {},
            out : {
                inline : 1
            }
        };

        Trades.mapReduce(mapReduce, function(error, results) {
            if (error) {
                ResponseHelper.response(res, error);
                return;
            }

            var data = {
                numTrades : 0,
                numCompleteTrades : 0
            };

            results.forEach(function(e) {
                data[e._id] = e.value;
            });

            ResponseHelper.response(res, error, {
                numTrades : data.numTrades,
                numCompleteTrades : data.numCompleteTrades
            });
        });
    }
};

