//TODO
var path = require('path');
var async = require('async');
var request = require('request');

var SegmentService = {};

var apiAddress = null;

SegmentService.setConfig = function (config) {
    apiAddress = config.server + config.path;
};

/**
 *
 * @param sentence 需要分词的句子
 * @param callback
 *       err
 *       results [String] 分词结果
 */

SegmentService.segment = function (sentence, callback) {
    if (!apiAddress) {
        callback([sentence]);
        return;
    }
    async.waterfall([
        function (callback) {
            request.post({
                    url: apiAddress,
                    form: {
                        input: sentence
                    }
                },
                callback);
        }, function (httpResponse, body, callback) {
            var b = JSON.parse(body);
            callback(null, b.result);
        }
    ], function (err, result) {
        callback(null, result);
    });

};

module.exports = SegmentService;