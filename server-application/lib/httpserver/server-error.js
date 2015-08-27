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
    return new ServerError(ServerError.ServerError, description, new Error());
};
ServerError.fromError = function(err) {
    return new ServerError(ServerError.ServerError, 'Server Error: ' + err.toString(), err);
};

util.inherits(ServerError, Error);

//TODO just some sample
//ErrorCode
ServerError.ServerError = 1000;
ServerError.IncorrectMailOrPassword = 1001;
ServerError.SessionExpired = 1002;
ServerError.NeedLogin = 1003;

var _codeToString = function(code) {
    switch (code) {
        case 1000 :
            return "ServerError";
        case 1001 :
            return "IncorrectMailOrPassword";
        case 1002 :
            return "SessionExpired";
        case 1003 :
            return "NeedLogin";
    }
};

module.exports = ServerError;
