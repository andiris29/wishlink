/**
 * Created by wxy325 on 8/28/15.
 */
var SearchBuildService = {};

//TODO

/**
 * 并发调用
 *      rebuildName 以获得 nameWords
 *      rebuildCountry 以获得 countryRef, countryWords
 *      rebuildBrand 以获得 brandRef, brandWords
 *      rebuildCategory 以获得 categoryRef, categoryWords
 *
 * @param {db.item} item
 * @param {enableSearch~callback} callback
 */
/**
 * @callback enableSearch~callback
 * @param {string} err
 * @param {db.item} item
 */
SearchBuildService.enableSearch = function(item, callback) {
};

/**
 * 调用分词服务获得 item.name 的分词，保存到 item.nameWords
 * 通过 _syncWords 将分词结果同步到 db.words
 *
 * @param {db.item} item
 * @param {rebuildName~callback} callback
 */
/**
 * @callback rebuildName~callback
 * @param {string} err
 * @param {db.item} item
 */
SearchBuildService.rebuildName = function(item, callback) {
};

/**
 * 通过全文检索查询 db.counties 中 words 字段，以获得 country
 *      如果查询失败则创建一个新的 country
 * 保存 item.countryRef, item.countryWords
 * 通过 _syncWords 将分词结果同步到 db.words
 *
 * @param {db.item} item
 * @param {rebuildCountry~callback} callback
 */
/**
 * @callback rebuildCountry~callback
 * @param {string} err
 * @param {db.item} item
 */
SearchBuildService.rebuildCountry = function(item, callback) {
};

/**
 * 类似 SearchBuildService.rebuildCountry
 */
SearchBuildService.rebuildBrand = function(item, callback) {
};

/**
 * 查询 db.categories 以获得 category，
 *      如果查询失败则创建一个新的 category
 * 查询每一级 category.parentRef
 * 保存 item.categoryRef, 并将 category.name 以及所有 parentRef.name 保存为 item.categoryWords
 * 通过 _syncWords 将分词结果同步到 db.words
 *
 * @param {db.item} item
 * @param {rebuildCategory~callback} callback
 */
/**
 * @callback rebuildCategory~callback
 * @param {string} err
 * @param {db.item} item
 */
SearchBuildService.rebuildCategory = function(item, callback) {
};

/**
 * 查询 item 所对应的 trades 的数量，作为 A
 * 查询 item 所对应的交易成功的 trades 的数量，作为 B
 * weight = A * 1 + B * 4
 * 通过 _syncWeight 将计算结果同步到 db.words 中
 *
 * @param {db.item} item
 * @param {recalculateWeight~callback} callback
 */
/**
 * @callback recalculateWeight~callback
 * @param {string} err
 * @param {db.item} item
 */
SearchBuildService.recalculateWeight = function(item, callback) {
};

/**
 * 比较 fromWords 和 toWords 以找出减少／增加的 word
 * 调整 db.words 中相应数据的 weight
 *
 * @param {int} type
 * @param {string[]} fromWords
 * @param {string[]} toWords
 * @param {int} weight
 * @param {_syncWords~callback} callback
 */
/**
 * @callback _syncWords~callback
 * @param {string} err
 */
SearchBuildService._syncWords = function(type, fromWords, toWords, weight, callback) {
};

/**
 * 比较 fromWords 和 toWords 以找出减少／增加的 word
 * 调整 db.words 中相应数据的 weight
 *
 * @param {int} type
 * @param {string[]} words
 * @param {int} fromWeight
 * @param {int} toWeight
 * @param {_syncWeight~callback} callback
 */
/**
 * @callback _syncWeight~callback
 * @param {string} err
 */
SearchBuildService._syncWeight = function(type, words, fromWeight, toWeight) {


};

module.exports = SearchBuildService;