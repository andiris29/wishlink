var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var entitySchema = Schema({
    iso3166 : String,
    name : String,
    icon : String,
    words : [String]
});

var model = mongoose.model('countries', entitySchema);

module.exports = model;
