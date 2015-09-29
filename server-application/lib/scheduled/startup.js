var winston = require('winston');

module.exports =  function(config) {

    require('./trade/autoReceiving')(config);
    require('./trade/autoCanceled')(config);

    // 推送热门商品
    require('./recommend/push')(config);
    // 备份融云纪录
    require('./maintenance/rongcloud')(config);

    winston.info('Startup scheduled success');
};

