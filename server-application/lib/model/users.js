var mongoose = require('mongoose');
var Schema = mongoose.Schema;

require('./trades');
require('./items');

var entitySchema = Schema({
    __context : Object,
    nickname: String,
    portrait : String,
    background : String,
    password : {
        type : String,
        select : false
    },
    encryptedPassword : {
        type : String,
        select : false
    },
    weixin : {
        openid : String,
        nickname : String,
        sec : Number,
        province : String,
        country : String,
        headimgurl : String,
        unionid : String
    },
    weibo : {
        id : String,
        screen_name : String,
        province : Number,
        country : Number,
        gender : String,
        avatar_large : String
    },
    alipay : {
        id : String
    },
    receivers : [{
        uuid: String,
        name : String,
        phone : String,
        province : String,
        address : String,
        isDefault : Boolean
    }],
    unread : {
        tradeRefs : [{
            type : Schema.Types.ObjectId,
            ref : 'trades'
        }],
        itemRecommendationRefs : [{
            type : Schema.Types.ObjectId,
            ref : 'items'
        }]
    },
    countryRef : {
        type : Schema.Types.ObjectId,
        ref : 'countries'
    },
    create : {
        type : Date,
        'default' : Date.now
    },
    update : {
        type : Date,
        'default' : Date.now
    }
});

var model = mongoose.model('users', entitySchema);

module.exports = model;
