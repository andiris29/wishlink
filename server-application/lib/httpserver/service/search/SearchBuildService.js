
var SegmentService = require('../SegmentService');
var async = require('async');

var words = require('../../../model/words');
var trades = require('../../../model/trades');
var countries = require('../../../model/countries');
var brands = require('../../../model/brands');
var categories = require('../../../model/categories');
var mongoose = require('mongoose');

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
            _calculateWeight(item, callback);
        }, function (newWeight, callback) {
            var oldWeight = item.weight || 0;
            async.parallel([
                function (callback) {
                    SearchBuildService.rebuildName(item, oldWeight, newWeight, callback);
                }, function (callback) {
                    SearchBuildService.rebuildCountry(item, oldWeight, newWeight, callback);
                }, function (callback) {
                    SearchBuildService.rebuildBrand(item, oldWeight, newWeight, callback);
                }, function (callback) {
                    SearchBuildService.rebuildCategory(item, oldWeight, newWeight, callback);
                }
            ], function (err) {
                callback(err, item);
            });
        }
    ], callback);
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
SearchBuildService.rebuildName = function(item, oldWeight, newWeight, callback) {
    var newWords = null;
    async.waterfall([
        function (callback) {
            SegmentService.segment(item.name, callback);
        }, function (words, callback) {
            newWords = words;
            var oldNameWords = item.nameWords
            item.nameWords = words;
            _syncWords('items', item._id, oldNameWords, words, callback);
        }, function (callback) {
            _syncWeight('item', item._id, newWords, newWeight, callback);
        }
    ], function (err) {
        callback(err, item);
    });
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
SearchBuildService.rebuildCountry = function(item, oldWeight, newWeight, callback) {
    var countryName = item.country;
    async.waterfall([
        function (callback) {
            countries.findOne({
                'words' : countryName
            }, callback);
        }, function (country, callback) {
            if (!country) {
                async.waterfall([
                    function (callback) {
                        new countries({
                            name : countryName,
                            words : [countryName]
                        }).save(callback);
                    }, function (c, count, callback) {
                        _syncWords('countries', c._id, null, c.words, function (err) {
                            callback(err, c);
                        });
                    }
                ], callback)
            } else {
                callback(null, country);
            }
        }, function (country, callback) {
            //update item
            item.countryRef = country._id;
            item.countryWords = country.words;
            item.save(function (err, item) {
                callback(err, country);
            });
        }, function (country, callback) {
            //update country word weight
            //query old country weight
            words.findOne({
                type : 'countries',
                word : country.name,
                ref : country._id
            }, function (err, word) {
                //update new country weight
                if (!err && word) {
                    var oldCountryWeight = word.weight || 0;
                    var newCountryWeight = oldCountryWeight + newWeight - oldWeight;
                    _syncWeight('countries', country._id, country.words, newCountryWeight, callback);
                } else {
                    callback(err);
                }
            });
        }
    ], function (err) {
        callback(err, item);
    });
};

/**
 * 类似 SearchBuildService.rebuildCountry
 */
SearchBuildService.rebuildBrand = function(item, oldWeight, newWeight, callback) {
    var brandName = item.brand;
    async.waterfall([
        function (callback) {
            brands.findOne({
                'words' : brandName
            }, callback);
        }, function (brand, callback) {
            if (!brand) {
                async.waterfall([
                    function (callback) {
                        new brands({
                            name : brandName,
                            words : [brandName]
                        }).save(callback);
                    }, function (b, count, callback) {
                        _syncWords('brands', b._id, null, b.words, function (err) {
                            callback(err, b);
                        })
                    }
                ], callback)
            } else {
                callback(null, brand);
            }
        }, function (brand, callback) {
            //update item
            item.brandRef = brand._id;
            item.brandWords = brand.words;
            item.save(function (err, item) {
                callback(err, brand);
            });
        }, function (brand, callback) {
            //update brand word weight
            //query old country weight
            words.findOne({
                type : 'brands',
                word : brand.name,
                ref : brand._id
            }, function (err, word) {
                //update new country weight
                if (!err && word) {
                    var oldBrandWeight = word.weight || 0;
                    var newBrandWeight = oldBrandWeight + newWeight - oldWeight;
                    _syncWeight('brands', brand._id, brand.words, newBrandWeight, callback);
                } else {
                    callback(err);
                }
            });
        }
    ], function (err) {
        callback(err, item);
    });
};

SearchBuildService.changeToNewCategory = function (item, newCategoryRef, callback) {
    async.waterfall([
        function (callback) {
            SearchBuildService.clearOldCategory(item, callback);
        }, function (item, callback) {
            item.categoryRef = newCategoryRef;
            item.save(callback);
        }, function (item, count, callback) {
            SearchBuildService.rebuildCategory(item, 0, item.weight, callback);
        }
    ], callback);
};

SearchBuildService.clearOldCategory = function(item, callback) {
    if (!item.categoryRef) {
        callback(null, item);
        return;
    }
    //TODO
    callback(null, item);
};

/**
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
SearchBuildService.rebuildCategory = function(item, oldWeight, newWeight, callback) {
    var categories = null;
    async.waterfall([
        function (callback) {
            _queryAllParentCategories(item.categoryRef, callback);
        }, function (newCategories, callback) {
            categories = newCategories;

            var newWords = newCategories.map(function (c) {
                return c.name;
            }).filter(function (c) {
                return c && c.length;
            });
            item.categoryWords = newWords;
            item.save(callback);
        }, function (i, count, callback) {
            var tasks = [];
            categories.forEach(function (c) {
                var task = function(callback) {
                    //update brand word weight
                    //query old country weight
                    words.findOne({
                        type : 'categories',
                        word : c.name,
                        ref : c._id
                    }, function (err, word) {
                        if (!err && word) {
                            var oldCategoryWeight = word.weight || 0;
                            var newCategoryWeight = oldCategoryWeight + newWeight - oldWeight;
                            _syncWeight('categories', c._id, c.words, newCategoryWeight, function (err) {
                                //TODO 失败暂不处理
                                callback();
                            });
                        } else {
                            //TODO 失败暂不处理
                            callback();
                        }
                    });
                };
                tasks.push(task);
            });
            async.parallel(tasks, callback);
        }
    ], function (err) {
        callback(err, item);
    });
};


var _queryAllParentCategories = function (childCategoryId, callback) {
    var newCategories = [];
    var _queryNextCategory = function (categoryId, innerCallback) {
        async.waterfall([
            function (asyncCallback) {
                categories.findOne({
                    '_id' : categoryId
                }, asyncCallback);
            }
        ], function (err, item) {
            if (err) {
                innerCallback(err, newCategories);
            } else {
                var parentRef = null;
                if (item) {
                    newCategories.push(item);
                    parentRef = item.parentRef;
                }
                if (parentRef) {
                    _queryNextCategory(parentRef, innerCallback);
                } else {
                    innerCallback(null, newCategories);
                }
            }
        })
    };
    _queryNextCategory(childCategoryId, function (err, c) {
        callback(err, newCategories);
    });
};

/**

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
    //TODO
};


/**
 * 计算item当前的重量
 * 查询 item 所对应的 trades 的数量，作为 A
 * 查询 item 所对应的交易成功的 trades 的数量，作为 B
 * weight = A * 1 + B * 4
 * @param item
 * @param callback
 * @private
 */
/**
 * @callback _calculateWeight~callback
 * @param {int} weight
 * @param callback
 * @private
 */
var _calculateWeight = function (item, callback) {
    async.waterfall([
        function (callback) {
            trades.find({
                itemRef : item._id
            }, callback)
        }, function (tradeEntities, callback) {
            var aCount = tradeEntities.length;
            var bCount = 0;

            tradeEntities.forEach(function (t){
                if (t.status === 5 || t.status === 6) {
                    ++bCount;
                }
            });

            var weight = aCount + bCount * 4;
            callback(null, weight);
        }
    ], callback);
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
var _syncWords = function(type, ref, fromWords, toWords, callback) {
    fromWords = fromWords || [];
    toWords = toWords || [];
    var wordsToBeRemoved = fromWords.filter(function (w) {
        return toWords.indexOf(w) === -1;
    });
    var wordsToBeAdded = toWords.filter(function (w) {
        return fromWords.indexOf(w) === -1;
    });

    var tasks = [];

    //Remove old words
    wordsToBeRemoved.forEach(function (w) {
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
                callback(err);
            });
        };
        tasks.push(task);
    });

    //Create new words
    wordsToBeAdded.forEach(function (w) {
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
                callback(err);
            });
        };
        tasks.push(task);
    });
    async.parallel(tasks, function (err) {
        callback(err);
    });
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
var _syncWeight = function(type, ref, words, weight, callback) {
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
                callback(err);
            })
        };
        tasks.push(task);
    });

    async.parallel(tasks, function (err) {
        callback(err);
    });
};

module.exports = SearchBuildService;