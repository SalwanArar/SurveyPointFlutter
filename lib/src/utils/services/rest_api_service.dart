import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:flutter_device_identifier/flutter_device_identifier.dart';

import '../../modules/models/review.dart';
import '/src/constants/api_path.dart';
import '/src/utils/services/local_storage_service.dart';
import 'package:http/http.dart' as http;

import 'exceptions.dart';

const Duration _timeoutDuration = Duration(seconds: 10);

Future<http.Response> _onTimeout() => throw TimeoutException(
      'Timeout Request!!!!!!',
      _timeoutDuration,
    );

Future<http.Response> apiPostDeviceCode() async {
  try {
    final serialNumber = await FlutterDeviceIdentifier.serialCode;
    var url = Uri.parse(apiPathPostDeviceCodeV02);
    // print(apiPathPostDeviceCodeV02);
    // print(serialNumber);
    var response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'serial_number': serialNumber,
      },
    ).timeout(
      _timeoutDuration,
      onTimeout: _onTimeout,
    );

    print(response.statusCode);
    switch (response.statusCode) {
      case HttpStatus.ok:
      case HttpStatus.created:
        final jsonResponse = jsonDecode(response.body);
        setDeviceId(jsonResponse['device_code_id']);
        setDeviceCode(jsonResponse['device_code']);
        return response;
      case HttpStatus.unprocessableEntity:
        throw Exception(
          "Api DeviceCode:\twrong SerialNumber!"
              'StatusCode:\t${response.statusCode}',
        );
      case HttpStatus.tooManyRequests:
        throw const TooManyAttemptsException(
            'Too Many Attempts from apiPostDeviceCodeV2');
      default:
        throw Exception(
          "\nApi DeviceCode2:\tCouldn't get|create the device code\n"
              'StatusCode:\t${response.statusCode}',
        );
    }
  } catch (e) {
    throw e.toString();
  }
}

Future<http.Response> apiPostDevice() async {
  try {
    int? deviceId = await getDeviceId();
    String? deviceCode = await getDeviceCode();

    print('DeviceId:\t$deviceId');
    print('DeviceCode:\t$deviceCode');

    var url = Uri.parse(apiPathDevice);
    var response = await http.post(url, headers: {
      'Accept': 'application/json',
    }, body: {
      'device_code_id': deviceId.toString(),
      'device_code': deviceCode,
    }).timeout(
      _timeoutDuration,
      onTimeout: _onTimeout,
    );

    switch (response.statusCode) {
      case HttpStatus.created:
        setToken(json.decode(response.body)['token']);
        return response;
      case HttpStatus.ok:
        throw const DeviceAlreadyAttachedException('Already Attached');
      case HttpStatus.noContent:
        return response;
      case HttpStatus.unprocessableEntity:
        throw Exception(
          "Api Device:\twrong Device Id or Device Code!"
          'StatusCode:\t${response.statusCode}',
        );
      case HttpStatus.tooManyRequests:
        throw const TooManyAttemptsException(
            'Too Many Attempts from apiPostDevice');
      default:
        throw Exception(
          'Api DeviceAttached:\tSomething went wrong'
          'StatusCode:\t${response.statusCode}',
        );
    }
  } on TimeoutException {
    rethrow;
  } catch (e) {
    rethrow;
  }
}

Future<http.Response> apiGetDeviceInfo() async {
  try {
    String? token = await getToken();
    print('Token:\t$token');
    String? lastUpdate = await getLastUpdate();

    var url = Uri.parse('$apiPathDevice/$lastUpdate');
    var response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).timeout(
      _timeoutDuration,
      onTimeout: _onTimeout,
    );
    if (response.statusCode == HttpStatus.tooManyRequests) {
      throw const TooManyAttemptsException('Too many Attempts');
    }
    return response;
  } catch (e) {
    print('error:\tapiGetDeviceInfo()');
    rethrow;
  }
}

Future<http.Response> apiGetVerification() async {
  try {
    String? token = await getToken();
    print('Api GetVerification:\t$token');
    var url = Uri.parse(apiPathPostIsVerified);
    var response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).timeout(
      _timeoutDuration,
      onTimeout: _onTimeout,
    );
    print('Api GetVerification:\t${response.statusCode}');
    switch (response.statusCode) {
      case HttpStatus.noContent:
      case HttpStatus.unauthorized:
        return response;
      case HttpStatus.tooManyRequests:
        throw const TooManyAttemptsException(
            'Too Many Attempts from apiGetVerification');
      default:
        throw Exception(
          'Api IsVerified:\t Verified not completed!'
          'StatusCode:\t${response.statusCode}',
        );
    }
  } catch (e) {
    print('apiGetVerification');
    rethrow;
  }
}

Future<http.Response> apiGetLogout() async {
  try {
    final deviceId = await getDeviceId();
    var url = Uri.parse('$apiPathPostLogout$deviceId');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    ).timeout(
      _timeoutDuration,
      onTimeout: _onTimeout,
    );
    switch (response.statusCode) {
      case HttpStatus.noContent:
        await deletePreferences();
        return response;
      case HttpStatus.tooManyRequests:
        throw const TooManyAttemptsException(
            'Too Many Attempts from apiGetLogout');
      default:
        throw Exception('Api PostLogout:\tLogout failed!'
            '\nStatusCode:\t${response.statusCode}');
    }
  } catch (e) {
    throw e.toString();
  }
}

Future<http.Response> apiPostReview(Review review) async {
  try {
    String? token = await getToken();

    var url = Uri.parse(apiPathPostReviewV02);
    var response = await http.post(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'review': review.toJson(),
    }).timeout(
      _timeoutDuration,
      onTimeout: _onTimeout,
    );

    switch (response.statusCode) {
      case HttpStatus.created:
      case HttpStatus.unauthorized:
        return response;
      case HttpStatus.internalServerError:
      // TODO: create internalServerError exception
      default:
        throw Exception('Api postReview:\t ${response.statusCode}');
    }
  } on Exception catch (e) {
    throw e.toString();
  }
}

Future<http.Response> apiPostDeviceStatus(bool status) async {
  try {
    String? token = await getToken();

    var url = Uri.parse(apiPathDeviceStatusV02);
    var response = await http.post(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'status': status ? '1' : '0',
    }).timeout(
      _timeoutDuration,
      onTimeout: _onTimeout,
    );

    switch (response.statusCode) {
      case HttpStatus.created:
      case HttpStatus.unauthorized:
        return response;
      case HttpStatus.internalServerError:
      // TODO: create internalServerError exception
      default:
        throw Exception('Api PostDeviceStatus:\t ${response.statusCode}');
    }
  } catch (e) {
    print('Api PostDeviceStatus:\t${e.toString()}');
    rethrow;
  }
}

