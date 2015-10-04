var async = require('async');

var RequestHelper = require('../helper/RequestHelper');
var ResponseHelper = require('../helper/ResponseHelper');

var SearchService = require('../service/search/SearchService');

var search = module.exports;


search.search = {
    method : 'get',
    func : function(req, res) {
        var param = req.queryString;
        var keyword = param.keyword;
        var pageNo = param.pageNo;
        var pageSize = param.pageSize;

        async.waterfall([
            function (callback) {
                SearchService.saveHistory(keyword, req.currentUserId, callback);
            }, function (callback) {
                SearchService.search(keyword, pageNo, pageSize, callback);
            }
        ], function (err, items) {
            ResponseHelper.response(res, err, {
                items : items
            });
        });
    }
};