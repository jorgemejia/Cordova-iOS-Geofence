var exec = require('cordova/exec');

exports.coolMethod = function(arg0, success, error) {
    exec(success, error, "iOSGeofence", "coolMethod", [arg0]);
};

exports.echo = function(arg0, success, error){
	exec(success, error, "iOSGeofence", "echo", [arg0]);
}
