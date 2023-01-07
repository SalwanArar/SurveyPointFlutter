import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '/src/modules/models/review.dart';
import '/src/utils/services/local_storage_service.dart';
import '/src/utils/services/rest_api_service_v02.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = "assets/sqlite/test.db";
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE "reviews"(
          "id" INTEGER PRIMARY KEY AUTOINCREMENT,
          "comment" TEXT,
          "contact_number" TEXT,
          "name" TEXT
        );
        ''');
        await db.execute('''
        CREATE TABLE "questions"(
          "id" INTEGER PRIMARY KEY AUTOINCREMENT,
          "question_id" INTEGER,
          "review_id" INTEGER,
          
          FOREIGN KEY ("review_id") REFERENCES "reviews" ("id") ON DELETE CASCADE
        );
        ''');
        await db.execute('''
        CREATE TABLE "answers"(
          "answer_id" INTEGER,
          "question_id" INTEGER,
          
          FOREIGN KEY ("question_id") REFERENCES "questions" ("id") ON DELETE CASCADE
        );
        ''');
      },
    );
  }

  Future<void> addReview(Review review) async {
    final db = await database;
    db.insert(
      'reviews',
      {
        'comment': review.reviewedCustomerInfo.toJson(),
      },
    );
    var reviewIdQuery = await db.rawQuery(
      "SELECT MAX(id) as id FROM reviews",
    );
    int reviewId = reviewIdQuery.first['id'] as int;

    for (ReviewedQuestion reviewedQuestion in review.reviewedQuestions) {
      db.insert(
        'questions',
        {
          'question_id': reviewedQuestion.questionId,
          'review_id': reviewId,
        },
      );
      var questionIdQuery = await db.rawQuery(
        "SELECT MAX(id) as id FROM questions",
      );
      int questionId = questionIdQuery.first["id"] as int;

      for (int answerId in reviewedQuestion.answers) {
        db.insert(
          'answers',
          {
            'answer_id': answerId,
            'question_id': questionId,
          },
        );
      }
    }
  }

  Future<bool> isEmpty() async => (await (await database).query(
        'reviews',
        limit: 1,
      ))
          .isEmpty;

  Future<void> uploadReview() async {
    final db = await database;

    var reviewIdQuery = await db.rawQuery(
      "SELECT MAX(id) as id FROM reviews",
    );
    int reviewId = reviewIdQuery.first["id"] as int;

    final reviewQuery = await db.query(
      'reviews',
      where: 'id = ?',
      whereArgs: [reviewId],
    );

    final reviewedQuestionsQuery = await db.query(
      'questions',
      where: 'review_id = ?',
      whereArgs: [reviewId],
    );

    List<ReviewedQuestion> reviewedQuestions = [];
    List<int> questionIds = [];

    for (var reviewedQuestion in reviewedQuestionsQuery) {
      questionIds.add(reviewedQuestion['id'] as int);
      final tempAnswers = await db.query('answers',
          where: 'question_id = ?', whereArgs: [reviewedQuestion['id']]);
      reviewedQuestions.add(
        ReviewedQuestion(
          questionId: reviewedQuestion['question_id'] as int,
          answers: tempAnswers
              .map<int>(
                (e) => e['answer_id'] as int,
              )
              .toList(),
        ),
      );
    }

    final Review review = Review(
      surveyId: await getSurveyId(),
      // name: reviewQuery.first['name'] as String?,
      // comment: reviewQuery.first['comment'] as String?,
      // contactNumber: reviewQuery.first['contactNumber'] as String?,
      deviceId: await getDeviceId(),
      reviewedQuestions: reviewedQuestions,
      reviewedCustomerInfo: const ReviewedCustomerInfo(),
    );

    // TODO: remove print
    if (kDebugMode) {
      print(review.toJson());
    }

    try {
      final response = await apiPostReview(review);
      if (response.statusCode == HttpStatus.created) {
        await db.delete('reviews', where: 'id = ?', whereArgs: [reviewId]);
      }
    } catch (_) {}
  }

  Future<void> emptyDatabase() async {
    final db = await database;
    await db.execute('DELETE FROM reviews;');
  }

  Future<int> getReviewsCount() async =>
      (await (await database).query('reviews')).length;
}
