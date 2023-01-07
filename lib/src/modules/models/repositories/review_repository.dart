import 'dart:io';

import '/src/modules/models/review.dart';

import '../../../utils/services/rest_api_service_v02.dart';
import '../../../utils/services/secure_storage_service.dart';

class ReviewRepository {
  static Future<bool?> submitReview(Review review) async {
    try {
      final responseReview = await apiPostReview(review);
      switch (responseReview.statusCode) {
        case HttpStatus.created:
          return true;
        case HttpStatus.unauthorized:
          return false;
        default:
          DBProvider.db.addReview(review);
          return null;
      }
    } catch (e) {
      DBProvider.db.addReview(review);
      print('Review Repository:\t ${e.toString()}');
      rethrow;
    }
  }
}
