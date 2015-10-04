var async = require('async');

var RequestHelper = require('../helper/RequestHelper');
var ResponseHelper = require('../helper/ResponseHelper');
var ServiceHelper = require('../helper/ServiceHelper');
var MongoHelper = require('../helper/MongoHelper');

var Items = require('../../model/items');

var search = module.exports;


search.search = {
    method : 'get',
    func : function(req, res) {
        ServiceHelper.queryPaging(req, res, function(param, callback) {
            async.waterfall([function(cb) {
                var keyword = param.keyword;
                var regex = RegExp(keyword);

                var criteria = {
                    'name' : regex
                };

                MongoHelper.queryPaging(Items.find(criteria),
                    param.pageNo,
                    param.pageSize,
                    function(error, models) {
                        cb(error, models);
                    });
            }], callback);
        }, function(models) {
            return {
                items: models
            };
        });
    }
};