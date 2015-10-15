var async = require('async'), _ = require('underscore');
var ServerError = require('../server-error');
var RequestHelper = require('./RequestHelper');

var MongoHelper = module.exports;

/**
 *
 * @param {Object} query
 * @param {Object} pageNo
 * @param {Object} pageSize
 * @param {Object} callback function(err, models)
 */
MongoHelper.queryPaging = function(query, pageNo, pageSize, callback) {
    async.waterfall([function(cb) {
        // Query
        query.skip((pageNo - 1) * pageSize).limit(pageSize).exec(function(err, models) {
            if (err) {
                cb(ServerError.fromDescription(err));
            } else if (!models || !models.length) {
                cb(ServerError.PAGING_NOT_EXIST);
            } else {
                cb(err, models);
            }
        });
    }, function(models, cb) {
        // Count
        query.count(function(err, count) {
            if (err) {
                cb(ServerError.genUnkownError(err));
            } else {
                if ((pageNo - 1) * pageSize >= count) {
                    cb(ServerError.PAGING_NOT_EXIST);
                } else {
                    cb(null, models, count);
                }
            }
        });
    }], function(error, models, numTotals) {
        callback(error, models, numTotals);
    });
};

MongoHelper.aggregatePaging =  function(aggregate, pageNo, pageSize, callback) {
    async.waterfall([
        function(callback) {
            // Query
            aggregate.skip((pageNo - 1) * pageSize).limit(pageSize).exec(function(err, models) {
                if (err) {
                    callback(ServerError.fromDescription(err));
                } else if (!models || !models.length){
                    callback(ServerError.PAGING_NOT_EXIST);
                } else {
                    callback(err, models);
                }
            });
        }], callback);
};

/**
 *
 * @param {Object} query
 * @param {Object} queryCount
 * @param {Object} size
 * @param {Object} callback function(err, models)
 */
MongoHelper.queryRandom = function(query, queryCount, size, callback) {
    async.waterfall([
        function(callback) {
            // Count
            queryCount.count(function(err, count) {
                if (err) {
                    callback(ServerError.fromDescription(err));
                } else {
                    callback(null, count);
                }
            });
        },
        function(count, callback) {
            var tasks = [], skipped = [];
            size = Math.min(size, count);
            for (var i = 0; i < size; i++) {
                tasks.push(function(callback) {
                    // Generate skip
                    var skip;
                    while (skip === undefined || skipped.indexOf(skip) !== -1) {
                        skip = _.random(0, count - 1);
                    }
                    skipped.push(skip);
                    // Query
                    query.skip(skip).limit(1).exec(function(err, models) {
                        if (err) {
                            callback(ServerError.fromDescription(err));
                        } else {
                            callback(err, models[0]);
                        }
                    });
                });
            }
            async.series(tasks, callback);
        }], callback);
};

MongoHelper.querySchema = function(Model, qsParam) {
    var criteria = {};
    for (var key in qsParam) {
        var value = qsParam[key];
        if (!qsParam[key] || qsParam[key].length === 0) {
            continue;
        }
        if (key === '__context' || key === '__v' || key === 'pageNo' || key === 'pageSize') {
            continue;
        }
        if (!value || value.length === 0) {
            continue;
        }
        var column = Model.schema.paths[key];
        if (column === null) {
            continue;
        }
        var type = column.instance;

        var rawValue = value;
        if (type == 'String') {
            rawValue = value;
        } else if (type == 'Number') {
            rawValue = RequestHelper.parseNumber(value);
        } else if (type == 'Date') {
            rawValue = RequestHelper.parseDate(value);
        } else if (type == 'ObjectId') {
            rawValue = RequestHelper.parseId(value);
        } else if (type == 'Mixed') {
            continue;
        } else if (type == 'Array') {
            continue;
        }

        criteria[key] = rawValue;
    }

    return criteria;
};
