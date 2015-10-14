// Third party Library
var mongoose = require('mongoose');
var async = require('async');

// Model
var Users = require('../../model/users');
var Items = require('../../model/items');
var Trades = require('../../model/trades');
var rUserFavoriteItems = require('../../model/rUserFavoriteItem');

var ContextHelper = module.exports;

ContextHelper.appendItemContext = function(currentUserId, items, callback) {
    items = _prepare(items);

    // __context.favoritedByCurrentUser
    var favoritedByCurrentUser = function(callback) {
        _rInitiator(rUserFavoriteItems, currentUserId, items, 'favoritedByCurrentUser', callback);
    };

    // __conetxt.numTrades
    var numTrades = function(callback) {
        var tasks = items.map(function(item) {
            return function(cb) {
                Trades.count({
                    itemRef: item._id
                }, function(error, count) {
                    item.__context.numTrades = count || 0;
                    cb(null);
                });
            };
        });

        async.parallel(tasks, function(error) {
            callback(null, items);
        });
    };

    async.parallel([favoritedByCurrentUser, numTrades], err => {
        callback(null, items);
    });
};

var _prepare = function(models) {
    return models.filter(function(model) {
        return model;
    }).map(function(model) {
        model.__context = model.__context || {};
        return model;
    });
};

var _rInitiator = function(RModel, initiatorRef, models, contextField, callback) {
    var tasks = models.map(function(model) {
        return function(callback) {
            if (initiatorRef) {
                RModel.findOne({
                    'initiatorRef': initiatorRef,
                    'targetRef': model._id
                }, function(err, relationship) {
                    model.__context[contextField] = Boolean(!err && relationship);
                    callback();
                });
            } else {
                model.__context[contextField] = false;
                callback();
            }
        };
    });
    async.parallel(tasks, error => {
        callback(null, models);
    });
};
