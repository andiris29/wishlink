var async = require('async');

var words = require('../../../model/words');

//TODO
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
};

/**
 * 查询 db.items，按照 weight 倒叙
 * 将 items 包装成 object 返回
 */
SearchTrendService.queryItems = function(pageNo, pageSize, callback) {

};



/**
 * 查询 db.words 中 type 为国家的数据，根据 ref 做数据聚集，按照 weight 排序
 * Populate ref
 * 将 countries 包装成 object 返回
 */
SearchTrendService.queryCounties = function(pageNo, pageSize, callback) {
    async.waterfall([
        function (callback) {
            _queryWithType('countries', pageNo, pageSize, callback, callback);
        }, function (callback) {

        }], function (err) {

    });

};




/**
 * 类似 SearchTrendService.queryCounties
 */
SearchTrendService.queryBrands = function(pageNo, pageSize, callback) {
};



/**
 * 类似 SearchTrendService.queryBrands
 */
SearchTrendService.queryCategories = function(pageNo, pageSize, callback) {
};

var _queryWithType = function (type, pageNo, pageSize, callback) {
    async.waterfall([
        function (callback) {
            words.aggregate([{
                $match : {type : type}
            },{
                $group: {
                    _id: '$word',
                    refs : {
                        $push: '$ref'
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
        }, function (results, callback) {
            callback(null, results);
        }
    ], function (err, results) {
        console.log(err);
        /*
        * [ { _id: '日本', refs: [], weight: 40 },
         { _id: '中国', refs: [], weight: 25 } ]
        * */
        callback(err, results);

    });
};

module.exports = SearchTrendService;