var util = require('util');
var winston = require('winston');

var ServerError = function(errorCode, description, err) {
    Error.call(this, 'server error');
    this.errorCode = errorCode;
    this.description = description || _codeToString(errorCode);
    if (errorCode === ServerError.ServerError) {
        err = err || new Error();
        this.stack = err.stack;
        winston.error(new Date().toString() + '- ServerError: ' + this.errorCode);
        winston.error('\t' + this.stack);
    }
};

ServerError.fromCode = function(code) {
    return new ServerError(code);
};
ServerError.fromDescription = function(description) {
    return new ServerError(ServerError.ERR_UNKOWN, description, new Error());
};
ServerError.fromError = function(err) {
    return new ServerError(ServerError.ERR_UNKOWN, 'ERR_UNKOWN: ' + err.toString(), err);
};

util.inherits(ServerError, Error);

//TODO just some sample
//ErrorCode
ServerError.ERR_UNKOWN = 1000;
ServerError.ERR_NOT_LOGGED_IN = 1001;
ServerError.ERR_PERMISSION_DENIED = 1002;
ServerError.ERR_NOT_ENOUGH_PARAM = 1003;

var _codeToString = function(code) {
    switch (code) {
        case 1000 :
            return "ERR_UNKOWN";
        case 1001 :
            return "ERR_NOT_LOGGED_IN";
        case 1002 :
            return "ERR_PERMISSION_DENIED";
        case 1003 :
            return "ERR_NOT_ENOUGH_PARAM";
    }
};

module.exports = ServerError;
