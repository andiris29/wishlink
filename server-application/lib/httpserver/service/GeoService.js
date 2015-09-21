// third party library
var mongoose = require('mongoose');
var async = require('async');
var _ = require('underscore');
var request = require('request');

var GeoService = module.exports;

/**
 * 通过 Google reverseGeocoding api 查询地理位置。
 * 和 db.countries 进行比对后返回。
 * 
 * @param {object} location
 * @param {number} location.lat
 * @param {number} location.lng
 * @param {reverseGeocoding~callback} callback
 */
/**
 * @callback reverseGeocoding~callback
 * @param {string} err
 * @param {db.countries} country
 */
GeoService.reverseGeocoding = function(location, callback) {
};

/**
 * 通过经纬度比对距离差。
 * 如果距离差比较大则通过 GeoService.reverseGeocoding 比对国家信息，
 * 如果获得到国家信息和 country1 不同，则新国家作为 country2 返回，
 * 其他情况返回 null。
 * 
 * @param {object} location1
 * @param {db.country} country1
 * @param {object} location2
 * @param {differentCountries~callback} callback
 */
/**
 * @callback differentCountries~callback
 * @param {string} err
 * @param {db.country} country2
 */
GeoService.differentCountries = function(location1, country1, location2, callback) {
};


//dlon = lon2 - lon1 
//dlat = lat2 - lat1 
//a = (sin(dlat/2))^2 + cos(lat1) * cos(lat2) * (sin(dlon/2))^2 
//c = 2 * atan2( sqrt(a), sqrt(1-a) ) 
//d = R * c (where R is the radius of the Earth)
var R = 6367.0;
var _calcDistance = function(lat1, lng1, lat2, lng2) { 
    var dlat = _diffRadian(lat1, lat2);
    var dlon = _diffRadian(lng1, lng2);
    var a = Math.pow(Math.sin(dlat/2),2) + Math.cos(lat1) * Math.cos(lat2) * Math.pow(Math.sin(dlon/2),2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); // great circle distance in radians
    return (R * c).toFixed(2);
};

var _diffRadian = function(point1, point2) {
    return _toRadian(point2) - _toRadian(point1);
};


var _toRadian = function(v) { 
    return v * (Math.PI / 180);
};

