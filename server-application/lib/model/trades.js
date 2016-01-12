var mongoose = require('mongoose');
var Schema = mongoose.Schema;

require('./users');
require('./items');

var entitySchema = Schema({
    status: Number,
    statusOrder: String,
    itemRef: {
        type: Schema.Types.ObjectId,
        ref: 'items'
    },
    quantity: Number,
    ownerRef: {
        type: Schema.Types.ObjectId,
        ref: 'users'
    },
    receiver: {
        name: String,
        phone: String,
        province: String,
        address: String
    },
    assigneeRef: {
        type: Schema.Types.ObjectId,
        ref: 'users'
    },
    pay: {
        weixin: {
            prepayid: String,
            transaction_id: String,
            partner: String,
            trade_mode: String,
            total_fee: String,
            fee_type: String,
            AppId: String,
            OpenId: String,
            time_end: String,
            notifyLogs: [{
                notify_id: String,
                trade_state: String,
                date: {
                    type: Date,
                    'default': Date.now
                }
            }]
        },
        alipay: {
            trade_no: String,
            trade_status: String,
            total_fee: String,
            refund_status: String,
            gmt_refund: String,
            seller_id: String,
            seller_email: String,
            buyer_id: String,
            buyer_email: String,
            notifyLogs: [{
                notify_type: String,
                notify_id: String,
                trade_status: String,
                refund_status: String,
                date: {
                    type: Date,
                    'default': Date.now
                }
            }]
        }
    },
    delivery: {
        company: String,
        trackingId: String,
        receiptDate: Date
    },
    statusLogs: [{
        userRef: {
            type: Schema.Types.ObjectId,
            ref: 'users'
        },
        status: Number,
        comment: String,
        create: {
            type: Date,
            'default': Date.now
        }
    }],
    complaints: [{
        problem: String,
        images: [String],
        create: {
            type: Date,
            'default': Date.now
        },
        resolution: {
            staffRef: {
                type: Schema.Types.ObjectId,
                ref: 'users'
            },
            notes: String,
            update: {
                type: Date,
                'default': Date.now
            }
        }
    }],
    create: {
        type: Date,
        'default': Date.now
    },
    update: {
        type: Date,
        'default': Date.now
    }
});

var model = mongoose.model('trades', entitySchema);

module.exports = model;
