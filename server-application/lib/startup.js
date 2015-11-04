var async = require('async');
var path = require('path');
var fs = require('fs');

var properties = require('properties');

// Log
var folderLogs = path.join(__dirname, 'logs');
if (!fs.existsSync(folderLogs)) {
    fs.mkdirSync(folderLogs);
}
var winston = require('winston');
winston.add(winston.transports.DailyRotateFile, {
    'filename': path.join(folderLogs, 'winston.log')
});

async.waterfall([
    function(callback) {
        // Load the config file(config.properties)
        var configPath = path.join(__dirname, 'config.properties');
        properties.parse(configPath, {
            path: true,
            namespaces: true,
            variables: true
        }, callback);
    }, function(config, callback) {
        var ftp = require('./runtime/ftp');
        ftp.connect(config.ftp, function() {
            callback(null, config);
        });
    }, function(config, callback) {
        // Load handle
        winston.info(config);

        // config service
        var segmentService = require('./httpserver/service/SegmentService');
        segmentService.setConfig(config.segment);

        //Database Connection
        var runtimeDb = require('./runtime/db');
        runtimeDb.connect(config.mongodb);
        callback(null, runtimeDb, config);
    }, function(runtimeDb, config, callback) {
        require('./httpserver/startup')(config, runtimeDb);
        callback();
    }
], function(err) {
    if (err) {
        winston.info(err);
    }
});

// Handle uncaught exceptions
process.on('uncaughtException', function(err) {
    winston.error(new Date().toString() + ': uncaughtException');
    winston.error(err);
    winston.error('\t' + err.stack);
});
