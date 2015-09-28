var moment = require('moment-timezone');
var _ = require('underscore');

var now = new Date();
var tz1 = moment.tz(now, 'Asia/Tokyo');

console.log(tz1.format());

var array = [1, 2, 3, 4, 5];

var a = _.filter(array, function(num) {
    return (num % 2) === 0;
});

console.log(a);

var b = _.filter(array, function(num) {
    setTimeout(function(num) {
        return (num % 2) === 0;
    }, 100);
});

console.log(b);
