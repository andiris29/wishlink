var async = require('async');

var MongoHelper = require('../../helper/MongoHelper');
var Items = require('../../../model/items');
var Users = require('../../../model/users');

var SegmentService = require('../SegmentService');

var SearchService = {};
//TODO
/**
 * [cache]
 *
 * 调用分词服务获得 keyword 的分词
 * 通过全文检索查询 db.items，按 textScore 排序
 *
 * @param {string} keyword
 * @param {int} pageNo
 * @param {int} pageSize
 * @param {search~callback} callback
 */
/**
 * @callback search~callback
 * @param {string} err
 * @param {db.item[]} items
 */
SearchService.search = function(keyword, pageNo, pageSize, callback) {
    async.waterfall([
        function (callback) {
            SegmentService.segment(keyword, callback);
        }, function (segs, callback) {
            var searchKeyword = segs.join(' ');
            MongoHelper.queryPaging(Items.find({
                    $text: {
                        $search: searchKeyword
                    }
                }, {
                    score: { $meta: "textScore"
                    }
                }
            ).sort({ score: { $meta: "textScore" } } ), pageNo, pageSize, callback);
        }
    ], callback);
};

SearchService.saveHistory = function(keyword, userId, callback) {
    if (!userId) {
        callback();
        return;
    }
    async.waterfall([
        function (callback) {
            Users.findOne({
                '_id' : userId
            },callback);
        }, function (user, callback) {
            var searchHistory = user.searchHistory = user.searchHistory || {};
            var entry = searchHistory.entry = searchHistory.entry || [];
            var i = 0;
            //删除已有的重复keyword
            for (i = 0; i < entry.length; i++ ) {
                var e = entry[i];
                if (e.keyword === keyword) {
                    entry.splice(i, 1);
                }
            }
            entry.unshift({
                keyword : keyword,
                create : new Date()
            });
            user.save(callback);
        }
    ], function (err) {
        callback(err);
    });
};

module.exports = SearchService;