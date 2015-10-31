var mongoose = require('mongoose');
var textSearch = require('mongoose-text-search');

var Schema = mongoose.Schema;

require('./countries');
require('./brands');
require('./categories');

var entitySchema = Schema({
    __context: Object,
    status: Number,
    images: [String],
    name: String,
    nameWords: {
        type: [String]//,
        //index : 'text'
    },
    approved: Boolean,
    country: String,
    countryRef: {
        type: Schema.Types.ObjectId,
        ref: 'countries'
    },
    countryWords: {
        type: [String]//,
        //index : 'text'
    },
    brand: String,
    brandRef: {
        type: Schema.Types.ObjectId,
        ref: 'brands'
    },
    brandWords: {
        type: [String]//,
        //index : 'text'
    },
    category: String,
    categoryRef: {
        type: Schema.Types.ObjectId,
        ref: 'categories'
    },
    categoryWords: {
        type: [String]//,
        //index : 'text'
    },
    weight: Number,
    spec: String,
    price: Number,
    notes: String,
    create: {
        'type': Date,
        'default': Date.now
    }
});

entitySchema.plugin(textSearch);

entitySchema.index(
    {
        nameWords: 'text',
        countryWords: 'text',
        brandWords: 'text',
        categoryWords: 'text'
    } , {
        name: 'text_search_index',
        weights: {
            nameWords: 1,
            countryWords: 1,
            brandWords: 1,
            categoryWords: 1
        }
    }
);

/*
db.getCollection('items').createIndex(
    {
        nameWords: "text",
        countryWords: "text",
        brandWords: "text",
        categoryWords : "text"
    }
)
*/

var model = mongoose.model('items', entitySchema);

module.exports = model;
