var async = require('async');
var _ = require('underscore');

var MongoHelper = require('./MongoHelper');
var ResponseHelper = require('./ResponseHelper');
var RequestHelper = require('./RequestHelper');

var ServerError = require('../server-error');

ServiceHelper = module.exports;

ServiceHelper.queryPaging = function(req, res, querier, responseDataBuilder, aspectInceptions) {
    // afterQuery, afterParseRequest, beforeEndResponse
    aspectInceptions = aspectInceptions || {};
    var param;
    async.waterfall([
    function(callback) {
        // Parse request
        try {
            param = RequestHelper.parsePageInfo(req.queryString);
            if (aspectInceptions.afterParseRequest) {
                _.extend(param, aspectInceptions.afterParseRequest(req.queryString));
            }
            callback();
        } catch(err) {
            callback(ServerError.fromError(err));
        }
    },
    function(callback) {
        // Query
        querier(param, function(err, currentPageModels, numTotal) {
            if (err) {
                callback(err);
            } else {
                if (currentPageModels.length === 0) {
                    callback(ServerError.PagingNotExist);
                } else {
                    if (aspectInceptions.afterQuery) {
                        aspectInceptions.afterQuery(param, currentPageModels, numTotal, function(err) {
                            callback(err, currentPageModels, numTotal);
                        });
                    } else {
                        callback(err, currentPageModels, numTotal);
                    }
                }
            }
        });
    }], function(err, currentPageModels, numTotal) {
        // Send response
        var data, metadata;
        if (!err) {
            data = responseDataBuilder(currentPageModels);
            metadata = {
                'numTotal' : numTotal,
                'numPages' : parseInt((numTotal + param.pageSize - 1) / param.pageSize)
            };
        }
        ResponseHelper.response(res, err, data, metadata, aspectInceptions.beforeEndResponse);
    });
};

