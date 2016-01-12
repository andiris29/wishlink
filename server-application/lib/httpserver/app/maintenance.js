
var async = require('async');
var Words = require('../../model/words');
var Items = require('../../model/items');
var SearchBuildService = require('../service/search/SearchBuildService');
var ResponseHelper = require('../helper/ResponseHelper');

var maintenance = module.exports;

/**
 * ?? db.words ? type ??????
 * ?? db.items??? SearchBuildService.rebuildCountry
 */
maintenance.rebuildCountries = {
    method : 'get',
    func : function(req, res) {
        _rebuildModelWords('countries', SearchBuildService.rebuildCountry, function (err) {
            ResponseHelper.response(res, err, {});
        });
    }
};

/**
 * ?? maintenance/rebuildCountries
 */
maintenance.rebuildBrands = {
    method : 'get',
    func : function(req, res) {
        _rebuildModelWords('brands', SearchBuildService.rebuildBrand, function (err) {
            ResponseHelper.response(res, err, {});
        });
    }
};

/**
 * ?? maintenance/rebuildCountries
 */
maintenance.rebuildCategories = {
    method : 'get',
    func : function(req, res) {
        _rebuildModelWords('categories', SearchBuildService.rebuildCategory, function (err) {
            ResponseHelper.response(res, err, {});
        });
    }
};

var _rebuildModelWords = function (type, RebuildServiceMethod, callback) {
    async.waterfall([
        function (callback) {
            //remove all
            Words.remove({ type: type }, function (err) {
                callback(err);
            });
        }, function (callback) {

            Items.find(callback);
        }, function (allItems, callback) {
            var tasks = [];
            allItems.forEach(function (i) {
                var task = function (callback) {
                    RebuildServiceMethod(i, 0, i.weight, function () {
                        callback();
                    });
                };
                tasks.push(task);
            });
            async.parallel(tasks, callback);
        }
    ], callback);
};