var mongoose = require('mongoose');
var Schema = mongoose.Schema;

require('./countries');
require('./items');
require('./brands');
require('./categories');

var entitySchema = Schema({
    type : String,
    word : String,
    weight : Number,
    ref : Schema.Types.ObjectId
});

var model = mongoose.model('words', entitySchema);

module.exports = model;
