var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var entitySchema = Schema({
    name : String,
    icon : String,
    words : [String],
    parentRef : {
        type : Schema.Types.ObjectId,
        ref : 'categories'
    }
});

var model = mongoose.model('categories', entitySchema);

module.exports = model;
