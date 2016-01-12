/**
 * Created by wxy325 on 9/6/15.
 */
var async = require('async');

var SearchSuggestionService = require('../service/search/SearchSuggestionService');
var ResponseHelper = require('../helper/ResponseHelper');

var suggestion = module.exports;

suggestion.any = {
    method : 'get',
    func : function(req, res) {
        _handleSuggestionWithService(SearchSuggestionService.queryAny, req, res);
    }
};

suggestion.name = {
    method : 'get',
    func : function(req, res) {
        _handleSuggestionWithService(SearchSuggestionService.queryName, req, res);
    }
};

suggestion.country = {
    method : 'get',
    func : function(req, res) {
        _handleSuggestionWithService(SearchSuggestionService.queryCountry, req, res);
    }
};

suggestion.brand = {
    method : 'get',
    func : function(req, res) {
        _handleSuggestionWithService(SearchSuggestionService.queryBrand, req, res);
    }
};



var _handleSuggestionWithService = function (serviceMethod, req, res) {
    var param = req.queryString;
    var keyword = param.keyword;
    var pageNo = parseInt(param.pageNo || 1);
    var pageSize = parseInt(param.pageSize || 10);
    serviceMethod(keyword, pageNo, pageSize, function (err, results) {
        ResponseHelper.response(res, err, {
            suggestions : results
        });
    });
};