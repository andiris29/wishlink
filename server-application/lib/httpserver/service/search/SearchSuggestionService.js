/**
 * Created by wxy325 on 8/28/15.
 */


//TODO

var SearchSuggestionService = {};

/**
 * @param {string} keyword
 * @param {queryXxx~callback} callback
 */
/**
 * @callback queryXxx~callback
 * @param {string} err
 * @param {string[]} suggestions
 */
SearchSuggestionService.queryXxx = function(keyword, pageNo, pageSize, callback) {
};
/**
 * 查询 db.words 中 word 以 keyword 开头的数据
 * Populate type 为 item 的数据
 * 将 item.name 以及其他 word.word 组成 suggestions 返回
 */
SearchSuggestionService.queryAny = function(keyword, pageNo, pageSize, callback) {
};

/**
 * 查询 db.items 中 name 以 keyword 开头的数据
 * 将 item.name 组成 suggestions 返回
 */
SearchSuggestionService.queryName = function(keyword, pageNo, pageSize, callback) {
};
/**
 * 查询 db.words 中 type 为国家的数据，按照 weight 排序
 * 将 word.word 组成 suggestions 返回
 */
SearchSuggestionService.queryCountry = function(keyword, pageNo, pageSize, callback) {
};
/**
 * 类似 SearchSuggestionService.queryCountry
 */
SearchSuggestionService.queryBrand = function(keyword, pageNo, pageSize, callback) {
};

module.exports = SearchSuggestionService;