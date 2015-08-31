
var SegmentService = require('../SegmentService');
var async = require('async');
var words = require('../../../model/words');

var SearchBuildService = {};

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
    async.waterfall([
        function (callback) {

        }, function (callback) {

        }
    ], function (err) {

    });
    async.parallel([
        function (callback) {
            SearchBuildService.rebuildName(item, callback);
        }, function (callback) {
            SearchBuildService.rebuildCountry(item, callback);
        }, function (callback) {
            SearchBuildService.rebuildBrand(item, callback);
        }, function (callback) {
            SearchBuildService.rebuildCategory(item, callback);
        }
    ], function (err) {
        callback(err, item);
    });

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
    //TODO
    async.waterfall([
        function (callback) {
            SegmentService.segment(item.name, callback);
        }, function (words, callback) {
            item.nameWords = words;
            callback(null, item);

        }
    ], function (err) {

    });

    callback(null, item);
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
    //TODO
    callback(null, item);
};

/**
 * 类似 SearchBuildService.rebuildCountry
 */
SearchBuildService.rebuildBrand = function(item, callback) {
    //TODO
    callback(null, item);
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
    //TODO
    callback(null, item);
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
 * 比较 fromWords 和 toWords 以找出减少／增加的 word, 并创建或删除
 *
 * @param {int} type
 * @param {ObjectId} ref
 * @param {string[]} fromWords
 * @param {string[]} toWords
 * @param {_syncWords~callback} callback
 */
/**
 * @callback _syncWords~callback
 * @param {string} err
 */
SearchBuildService._syncWords = function(type, ref, fromWords, toWords, callback) {
    var wordsToBeRemoved = fromWords && fromWords.filter(function (w) {
        return toWords.indexOf(w) === -1;
    });
    var wordsToBeAdded = toWords && toWords.filter(function (w) {
        return fromWords.indexOf(w) === -1;
    });

    var tasks = [];

    //Remove old words
    wordsToBeRemoved && wordsToBeRemoved.forEach(function (w) {
        var task = function (callback) {
            async.waterfall([
                function (callback) {
                    words.findOne({
                        type : type,
                        word : w,
                        ref : ref
                    }, callback);
                }, function (word, callback) {
                    if (word) {
                        word.remove(callback);
                    } else {
                        callback();
                    }
                }
            ], function (err) {
                callback();
            });
        };
        tasks.push(task);
    });

    //Create new words
    wordsToBeAdded && wordsToBeAdded.forEach(function (w) {
        var task = function (callback) {
            async.waterfall([
                function (callback) {
                    words.findOne({
                        type : type,
                        word : w,
                        ref : ref
                    }, callback);
                }, function (word, callback) {
                    if (word) {
                        callback();
                    } else {
                        new words({
                            type : type,
                            word : w,
                            ref : ref
                        }).save(callback);
                    }
                }
            ], function (err) {
                callback();
            });
        };
        tasks.push(task);
    });
    async.parallel(tasks, callback);
};

/**
 * 调整 db.words 中相应数据的 weight
 *
 * @param {int} type
 * @param {ObjectId} ref
 * @param {string[]} words
 * @param {int} weight
 * @param {_syncWeight~callback} callback
 */
/**
 * @callback _syncWeight~callback
 * @param {string} err
 */
SearchBuildService._syncWeight = function(type, ref, words, weight) {
    var tasks = [];

    words && words.forEach(function (w) {
        var task = function (callback) {
            async.waterfall([
                function (callback) {
                    words.findOne({
                        type : type,
                        word : w,
                        ref : ref
                    }, callback);
                }, function (word, callback) {
                    if (!word) {
                        new words({
                            type : type,
                            word : w,
                            ref : ref,
                            weight : weight
                        }).save(callback);
                    } else {
                        word.weight = weight;
                        word.save(callback);
                    }
                }
            ], function (err) {
                callback();
            })
        };
        tasks.push(task);
    });

    async.parallel(tasks, callback);
};

module.exports = SearchBuildService;