var async = require('async');
var _ = require('underscore');

var words = require('../../../model/words');
var items = require('../../../model/items');
var countries = require('../../../model/countries');
var brands = require('../../../model/brands');
var categories = require('../../../model/categories');

var SearchTrendService = {};
/**
 * [cache]
 *
 * @param {int} pageNo
 * @param {int} pageSize
 * @param {queryXxx~callback} callback
 */
/**
 * @callback queryXxx~callback
 * @param {string} err
 * @param {object[]} trends
 * @param {string} trends[].name
 * @param {string} trends[].icon
 * @param {int} trends[].weight
 */
//TODO 这个是啥
SearchTrendService.queryXxx = function(pageNo, pageSize, callback) {

};
/**
 * 并发调用
 *      SearchTrendService.queryItems, 占 pageSize 的 30%
 *      SearchTrendService.queryCounties, 占 pageSize 的 30%
 *      SearchTrendService.queryBrands, 占 pageSize 的 20%
 *      SearchTrendService.queryCategories, 占 pageSize 的 20%
 * 将返回内容组合成数组返回
 */
SearchTrendService.queryKeywords = function(pageNo, pageSize, callback) {
    var itemSize = parseInt(0.3 * pageSize);
    var countrySize = parseInt(0.3 * pageSize);
    var brandSize = parseInt(0.2 * pageSize);
    var categorySize = pageSize - itemSize - countrySize - brandSize;

    var sizes = [
        itemSize,
        countrySize,
        brandSize,
        categorySize];
    var serviceMethods = [
        SearchTrendService.queryItems,
        SearchTrendService.queryCounties,
        SearchTrendService.queryBrands,
        SearchTrendService.queryCategories
    ];

    var tasks = [];
    var retResults = [];
    sizes.reduce(function (previousValue, currentValue, index) {
        var nextValue = previousValue + currentValue;
        var task = function (callback) {
            serviceMethods[index](pageNo, currentValue, function (err, results) {
                for (var i = previousValue; i < nextValue; i++ ) {
                    retResults[i] = results[i - previousValue];
                }
                callback(err);
            });
        };
        tasks.push(task);
        return nextValue;
    }, 0);

    async.parallel(tasks, function (err) {
        retResults = retResults.filter(function (r) {
            return !!r;
        });
        callback(err, retResults);
    });
};

/**
 * 查询 db.items，按照 weight 倒叙
 * 将 items 包装成 object 返回
 */
SearchTrendService.queryItems = function(pageNo, pageSize, callback) {
    async.waterfall([
        function (callback) {
            _aggregateWithName('items', pageNo, pageSize, callback);
        }, function (results, callback) {
            _postHandleItem(results, items, callback);
        }
    ], callback);
};



/**
 * 查询 db.words 中 type 为国家的数据，根据 ref 做数据聚集，按照 weight 排序
 * Populate ref
 * 将 countries 包装成 object 返回
 */
SearchTrendService.queryCounties = function(pageNo, pageSize, callback) {
    async.waterfall([
        function (callback) {
            _aggregateWithRef('countries', pageNo, pageSize, callback);
        }, function (results, callback) {
            _postHandleCountryAndBrands(results, countries, callback);
        }], callback);

};

/**
 * 类似 SearchTrendService.queryCounties
 */
SearchTrendService.queryBrands = function(pageNo, pageSize, callback) {
    async.waterfall([
        function (callback) {
            _aggregateWithRef('brands', pageNo, pageSize, callback);
        }, function (results, callback) {
            _postHandleCountryAndBrands(results, brands, callback);
        }], callback);
};

/**
 * 类似 SearchTrendService.queryBrands
 */
SearchTrendService.queryCategories = function(pageNo, pageSize, callback) {
    async.waterfall([
        function (callback) {
            _aggregateWithRef('categories', pageNo, pageSize, callback);
        }, function (results, callback) {
            _postHandleCountryAndBrands(results, categories, callback);
        }], callback);
};

/**
 *
 * @param type
 * @param pageNo
 * @param pageSize
 * @param callback
 *          @param err
 *          @param rawData {_id : id, weight : weigth}
 * @private
 */
var _aggregateWithRef = function (type, pageNo, pageSize, callback) {
    async.waterfall([
        function (callback) {
            words.aggregate([{
                $match : {type : type}
            },{
                $group: {
                    _id: '$ref',
                    weight: {
                        $avg: '$weight'
                    }
                }
            },{
                $sort : {
                    'weight' : -1
                }
            }, {
                $skip : pageNo * pageSize
            }, {
                $limit : pageSize
            }
            ]).exec(callback);
        }
    ], callback);
};


var _postHandleCountryAndBrands = function (rawData, Model, callback) {
    var retData = [];
    var tasks = [];
    rawData = rawData || [];
    rawData.forEach(function (row, index) {
        var task = function (callback) {
            async.waterfall([
                function (callback) {
                    Model.findOne({
                        _id : row._id
                    }, callback);
                }, function (m, callback) {
                    retData[index] = {
                        name : m.name,
                        icon : m.icon,
                        weight : row.weight
                    };
                    callback();
                }
            ], callback);
        };
        tasks.push(task);
    });
    async.parallel(tasks, function (err) {
        retData = retData.filter(function (d) {
            return !!d;
        });
        callback(err, retData);
    })
};


var _aggregateWithName = function (type, pageNo, pageSize, callback) {
    async.waterfall([
        function (callback) {
            words.aggregate([{
                $match : {type : type}
            },{
                $group: {
                    _id: 'name',
                    refs : {
                        $push : '$ref'
                    },
                    weight: {
                        $avg: '$weight'
                    }
                }
            },{
                $sort : {
                    'weight' : -1
                }
            }, {
                $skip : pageNo * pageSize
            }, {
                $limit : pageSize
            }
            ]).exec(callback);
        }
    ], callback);
};


var _postHandleItem = function (rawData, Model, callback) {
    var retData = [];
    var tasks = [];
    rawData = rawData || [];
    rawData.forEach(function (row, index) {
        var task = function (callback) {
            async.waterfall([
                function (callback) {
                    var refs = row.refs;
                    var index = _.random(0, refs.length);
                    var ref = refs[index];
                    Model.findOne({
                        _id : ref
                    }, callback);

                }, function (m, callback) {
                    retData[index] = {
                        name : row._id,
                        icon : m.images && m.images[0],
                        weight : row.weight
                    };
                    callback();
                }
            ], callback);
        };
        tasks.push(task);
    });
    async.parallel(tasks, function (err) {
        retData = retData.filter(function (d) {
            return !!d;
        });
        callback(err, retData);
    })
};



module.exports = SearchTrendService;