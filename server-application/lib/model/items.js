var mongoose = require('mongoose');
var Schema = mongoose.Schema;

require('./countries');
require('./brands');
require('./categories');

var entitySchema = Schema({
    status : Number,
    images : [string],
    name : String,
    countryWords : [String],
    country : String,
    countryRef : {
        type : Schema.Types.ObjectId,
        ref : 'countries'
    },
    brand : String,
    brandRef : {
        type : Schema.Types.ObjectId,
        ref : 'brands'
    },
    brandWords : [String],
    category : String,
    categoryRef : {
        type : Schema.Types.ObjectId,
        ref : 'categories'
    },
    categoryWords : [String],
    weight : Number,
    spec : String,      //TODO 这个是啥
    price : Number,
    notes: String,
    create : {
        'type' : Date,
        'default' : Date.now
    }
});

var model = mongoose.model('items', entitySchema);

module.exports = model;
