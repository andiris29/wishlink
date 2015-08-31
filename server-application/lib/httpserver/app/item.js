/**
 * Created by qusheng @ 2015.08.28
 *
 */
var mongoose = require('mongoose');
var async = require('async');

var ServerError = require('../server-error');
var RequestHelper = require('../helper/RequestHelper');
var ResponseHelper = require('../helper/ResponseHelper');

var Item = require('../../model/items');

//Services
var SearchBuildService = require('../service/search/SearchBuildService');


var item = module.exports;

var itemImageResizeOptions = [
    {'suffix' : '_640', 'width' : 640, 'height' : 640},
    {'suffix' : '_320', 'width' : 320, 'height' : 320},
    {'suffix' : '_160', 'width' : 160, 'height' : 160}
];

/**
 * 保存上传的 1-4 张图片，保存原图以及压缩图 _640 _320 _160，并传输图片到 CDN 服务器
 * 创建 db.item
 *
 * @param {string} req.name
 * @param {string} req.brand
 * @param {string} req.country
 * @param {number} req.price
 * @param {string} req.spec
 * @param {string} [req.comment]
 */
item.create = {
    method : 'post',
    permissionValidators : ['validateLogin'],
    func : function(req, res) {
        var newItem = new Item({
            name : req.name,
            brand : RequestHelper.parseId(req.brand),
            country : req.country,
            spec : req.spec,
            price : RequestHelper.parseNumber(req.price),
            notes :req.notes
        });

        async.waterfall([function(callback) {
            newItem.save(function(error, item) {
                if (err) {
                    callback(err);
                } else if (!item) {
                    callback(ServerError.ERR_UNKOWN);
                } else {
                    callback(null, item);
                }
            });
        }, function(item, callback) {
            RequestHelper.parseFiles(req, res, global.uploads.item.image.ftpPath, resizeOptions, function(error, files) {
                if (error) {
                    callback(error);
                } else {
                    item.images = [];
                    files.forEach(function(file) {
                        var path = global.uploads.item.image.exposeToUrl + '/' + path.relative(global.uploads.item.image.ftpPath, file.path);
                        item.images.push(path);
                    });

                    item.save(function(error, item) {
                        if (error) {
                            callabck(error);
                        } else if (!item) {
                            callback(ServerError.ERR_UNKOWN);
                        } else {
                            callback(null, item);
                        }
                    });
                }
            });
        }, function (item, callback) {
            SearchBuildService.enableSearch(item, callback);
        }], function(error, item) {
            ResponseHelper.response(res, error, {
                'item' : item
            });
        });
    }
};
