import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_device_identifier/flutter_device_identifier.dart';
import 'package:http/http.dart' as http;

import '../../constants/api_path.dart';
import '../../modules/models/review.dart';
import 'exceptions.dart';
import 'local_storage_service.dart';

const Duration _timeoutDuration = Duration(seconds: 10);

Future<http.Response> _onTimeout() => throw TimeoutException('Timeout Request!');

Future<http.Response> apiPostDeviceCodeV2() async {
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
            // '\n${response.body}');
    }
  } on Exception catch (e) {
    throw e.toString();
  }
}
