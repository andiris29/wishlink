/**
 * Created by wxy325 on 8/28/15.
 */

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
};


module.exports = SearchService;