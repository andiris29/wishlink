var mongoose = require('mongoose');

require('./users');

var Schema = mongoose.Schema;
var jPushAudiencesSchema = Schema({
    userRef: {
        type: Schema.Types.ObjectId,
        ref: 'users'
    },
    registrationId: String,
    create: {
        type: Date,
        'default': Date.now
    }
});

var jPushAudiences = mongoose.model('jPushAudiences', jPushAudiencesSchema);
module.exports = jPushAudiences;
