var winston = require('winston');

module.exports =  function(config) {

    require('./trade/autoReceiving')(config);
    require('./trade/autoCanceled')(config);

    // TODO 推送热门商品
    // TODO 备份融云纪录

    winston.info('Startup scheduled success');
};

