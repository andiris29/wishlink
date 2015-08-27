var mongoose = require('mongoose');
var Schema = mongoose.Schema;

require('./countries');

var entitySchema = Schema({
    device : String,
    location : {
        lat : Number,
        lng : Number
    },
    countryRef : {
        type : Schema.Types.ObjectId,
        ref : 'countries'
    },
    create : {
        'type' : Date,
        'default' : Date.now
    }
});

var model = mongoose.model('geoTraces', entitySchema);

module.exports = model;
