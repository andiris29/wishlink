// third party library
var async = require('async');
var mongoose = require('mongoose');
var _ = require('underscore');

var geo = module.exports;

/**
 * 将地理位置保存到 geoTraces 中
 * A，获取最后一次有 geoTrace.coutryRef 的数据
 * B，调用 GeoService.differentCountries 获取新国家信息
 * 
 * 如果 A 查询失败，或 B 获取到新国家信息成功
 *    更新当前 geoTrace.countryRef 以及 user.countryRef
 *    如果新国家 country.iso3166 不是 CHN，
 *      调用 RecommendationService.recommendInForeignCountry 
 *      以及 NotificationService.notifyGotoForeignCountry
 * 
 * @method post
 * @param {number} req.device
 * @param {number} req.location.lat
 * @param {number} req.location.lng
 */
geo.trace = {
    method : 'post',
    func : function(req, res) {
    }
};

