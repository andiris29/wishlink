var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var entitySchema = Schema({
    name : String,
    icon : String,
    words : [String]
});

var model = mongoose.model('brands', entitySchema);

module.exports = model;
