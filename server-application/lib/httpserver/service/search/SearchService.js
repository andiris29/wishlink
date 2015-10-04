var async = require('async');

var MongoHelper = require('../../helper/MongoHelper');
var Items = require('../../../model/items');

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

    var regex = RegExp(keyword);
    var criteria = {
        'name' : regex
    };
    async.waterfall([
        function (callback) {
            MongoHelper.queryPaging(Items.find(criteria), pageNo, pageSize, callback);
        }
    ], callback);
};

SearchService.saveHistory = function(keyword, userId, callback) {
    if (!userId) {
        callback();
        return;
    }
    callback();

};

module.exports = SearchService;