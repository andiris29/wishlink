var async = require('async');

var words = require('../../../model/words');
var items = require('../../../model/items');
var words = require('../../../model/words');
//var countries = require('../../../model/countries');
//var brands = require('../../../model/brands');
//var categories = require('../../../model/categories');
var MongoHelper = require('../../helper/MongoHelper');
var ServerError = require('../../server-error');

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

/**
 * 查询 db.words 中 word 以 keyword 开头的数据
 * Populate type 为 item 的数据
 * 将 item.name 以及其他 word.word 组成 suggestions 返回
 */
SearchSuggestionService.queryAny = function(keyword, pageNo, pageSize, callback) {
    var retWords = [];
    async.waterfall([
        function (callback) {
            _queryWordEntities(keyword, null, pageNo, pageSize, callback);
        }, function (wordEntities, callback) {
            var tasks = [];
            wordEntities.forEach(function (wordEntity, index) {
                var task = function (callback) {
                    if (wordEntity.type === 'items') {
                        items.findOne({
                            _id : wordEntity.ref
                        }, function (err, item) {
                            if (!err && item) {
                                retWords[index] = item.name;
                            }
                            callback();
                        })
                    } else {
                        retWords[index] = wordEntity.word;
                        callback();
                    }
                };
                tasks.push(task);
            });
            async.waterfall(tasks, callback);
        }
    ], function (err) {
        retWords = retWords.filter(function (r) {
            return r && r.length;
        });
        callback(err, retWords);
    });
};

/**
 * 查询 db.items 中 name 以 keyword 开头的数据
 * 将 item.name 组成 suggestions 返回
 */
SearchSuggestionService.queryName = function(keyword, pageNo, pageSize, callback) {
    async.waterfall([
        function (callback) {
            _parseKeyword(keyword, callback);
        },
        function (k, callback) {
            var query = items.find({
                name : _generatePrefixRegex(k)
            });
            MongoHelper.queryPaging(query, pageNo, pageSize, callback);
        }, function (items, callback) {
            var itemsNames = items.map(function (i) {
                return i.name;
            }).filter(function (n) {
                return n && n.length;
            });
            callback(null, itemsNames)
        }
    ], callback);
};
/**
 * 查询 db.words 中 type 为国家的数据，按照 weight 排序
 * 将 word.word 组成 suggestions 返回
 */
SearchSuggestionService.queryCountry = function(keyword, pageNo, pageSize, callback) {
    _queryWords(keyword, 'countries', pageNo, pageSize, callback);
};
/**
 * 类似 SearchSuggestionService.queryCountry
 */
SearchSuggestionService.queryBrand = function(keyword, pageNo, pageSize, callback) {
    _queryWords(keyword, 'brands', pageNo, pageSize, callback);
};


var _parseKeyword = function (keyword, callback) {
    keyword = keyword || "";
    var list = keyword.split(' ').filter(function (b) { return b && b.length});
    if (!list || !list.length) {
        callback(ServerError.fromCode(ServerError.ERR_NOT_ENOUGH_PARAM));
        return;
    }
    var lastKeyword = list[list.length - 1];
    if (!lastKeyword || !lastKeyword.length) {
        callback(ServerError.fromCode(ServerError.ERR_NOT_ENOUGH_PARAM));
    } else {
        callback(null, lastKeyword);
    }
};

var _generatePrefixRegex = function(prefix) {
    var regexStr = "^" + prefix;
    return new RegExp(regexStr, 'i');
};

var _queryWords = function (keyword, type, pageNo, pageSize, callback) {
    async.waterfall([
        function (callback) {
            _queryWordEntities(keyword, type, pageNo, pageSize, callback);
        }, function (wordEntities, callback) {
            var words = wordEntities.map(function (i) {
                return i.word;
            }).filter(function (n) {
                return n && n.length;
            });
            callback(null, words)
        }
    ], callback);
};

var _queryWordEntities = function (keyword, type, pageNo, pageSize, callback) {
    async.waterfall([
        function (callback) {
            _parseKeyword(keyword, callback);
        },
        function (k, callback) {
            var c = {
                word : _generatePrefixRegex(k)
            };
            if (type && type.length) {
                c.type = type;
            }
            var query = words.find(c);
            MongoHelper.queryPaging(query, pageNo, pageSize, callback);
        }
    ], callback);
};

module.exports = SearchSuggestionService;