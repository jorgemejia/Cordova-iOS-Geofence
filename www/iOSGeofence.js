var exec = require('cordova/exec');


var Geofence = {
    echo :  function(arg0, success, error){
        exec(success, error, "iOSGeofence", "echo", [arg0]);
    },

    requestPermission : function(arg0, success, error){
        exec(success, error, "iOSGeofence", "requestPermission", [arg0]);
    }
};

module.exports = Geofence;
