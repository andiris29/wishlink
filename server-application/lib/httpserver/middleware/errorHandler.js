//var ResponseHelper = require('../helpers/ResponseHelper');

function error_handler(err, req, res, next) {
    if (!err) {
        return next();
    } else {
        //TODO
//        ResponseHelper.response(res, err);
    }
}

module.exports = error_handler;
