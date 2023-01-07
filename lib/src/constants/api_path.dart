// const String _apiPathDomain = 'https://survey-point.com/spapi/public/api';
// const String _apiPathDomain = 'http://172.107.174.161/api';
const String _apiPathDomain = 'http://192.168.0.103:8080/api';
//http://172.107.174.161/index.php
// TODO: Add API version to all
const String _apiPathVersion = '/v01';

const String apiPathPostDeviceCode =
    '$_apiPathDomain$_apiPathVersion/device-code';

const String apiPathPostIsVerified =
    '$_apiPathDomain$_apiPathVersion/authentication';

const String apiPathDevice = '$_apiPathDomain$_apiPathVersion/device';

// TODO: CHANGE TO ONLY LOGOUT
const String apiPathPostLogout = '$_apiPathDomain$_apiPathVersion/device/logout/';

// Version v02
const String _apiPathVersionV02 = '/v02';

const String apiPathPostDeviceCodeV02 =
    '$_apiPathDomain$_apiPathVersionV02/device-code';

const String apiPathPostReviewV02 =
    '$_apiPathDomain$_apiPathVersionV02/review';

const String apiPathDeviceStatusV02 =
    '$_apiPathDomain$_apiPathVersionV02/device/out-of-service';
