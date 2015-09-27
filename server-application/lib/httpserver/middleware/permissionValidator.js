var async = require('async');
var _ = require('underscore');

var ServerError = require('../server-error');
var _validatorsMap = {};

var _init = function(services) {
    services.forEach(function(service) {
        var module = service.module,
            path = service.path;
        for (var id in module) {
            var validators = module[id].permissionValidators;
            if (validators) {
                _validatorsMap['/services/' + path + '/' + id] = validators;
            }
        }
    });
    return _validate;
};

var _validate = function(req, res, next) {
    var validators = _validatorsMap[req.path];
    if (validators) {
        var tasks = [];
        validators.forEach(function(validator) {
            tasks.push(function(callback) {
                if (_.isString(validator)) {
                    validator = _builtInValidators[validator];
                }
                validator(req, res, callback);
            });
        });
        async.series(tasks, function(err) {
            if (err) {
                next(new ServerError(err));
            } else {
                next();
            }
        });
    } else {
        next();
    }
};

var _builtInValidators = {
    'validateLogin' : function(req, res, callback) {
        if (req.currentUserId) {
            callback(null);
        } else {
            // TODO now nologin
            //callback(ServerError.ERR_NOT_LOGGED_IN);
            callback(null);
        }
    },
    'validateAdmin' : function(req, res, callback) {
        if (req.currentUserId) {
            callback(null);
        } else {
            callback(ServerError.ERR_PERMISSION_DENIED);
        }
    }
};

module.exports = _init;
