var mongoose = require('mongoose');
var Schema = mongoose.Schema;

require('./users');
require('./items');

var entitySchema = Schema({
    'initiatorRef' : {
        'type' : Schema.Types.ObjectId,
        'ref' : 'users'
    },
    'targetRef' : {
        'type' : Schema.Types.ObjectId,
        'ref' : 'items'
    },
    'create' : {
        'type' : Date,
        'default' : Date.now
    }
});

var model = mongoose.model('rUserFavoriteItem', entitySchema);

module.exports = model;
