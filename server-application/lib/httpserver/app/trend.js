var async = require('async');

var SearchTrendService = require('../service/search/SearchTrendService');
var ResponseHelper = require('../helper/ResponseHelper');

var trend = module.exports;

/**
 * trend [paging]
 * @method get
 * @return {object[]} res.data.trends
 * @return {string} res.data.trends[].name
 * @return {int} res.data.trends[].weight
 * @return {string} [res.data.trends[].icon]
 */

/**
 * 调用 SearchTrendService.queryKeywords
 */
trend.keywords = {
    method : 'get',
    func : function(req, res) {
        _handleTrendWithService(SearchTrendService.queryKeywords, req, res);
    }
};

/**
 * 调用 SearchTrendService.queryCounties
 */
trend.country = {
    method : 'get',
    func : function(req, res) {
        _handleTrendWithService(SearchTrendService.queryCounties, req, res);
    }
};

/**
 * 调用 SearchTrendService.queryBrands
 */
trend.brand = {
    method : 'get',
    func : function(req, res) {
        _handleTrendWithService(SearchTrendService.queryBrands, req, res);
    }
};

/**
 * 调用 SearchTrendService.queryItems
 */
trend.category = {
    method : 'get',
    func : function(req, res) {
        _handleTrendWithService(SearchTrendService.queryItems, req, res);
    }
};

var _handleTrendWithService = function (serviceMethod, req, res) {
    var param = req.queryString;
    var pageNo = parseInt(param.pageNo || 0);
    var pageSize = parseInt(param.pageSize || 10);

    async.waterfall([
        function (callback) {
            serviceMethod(pageNo, pageSize, callback);
        }
    ], function (err, trends) {
        ResponseHelper.response(res, err, {
            trends : trends
        });
    })

};