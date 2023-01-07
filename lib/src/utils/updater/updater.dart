import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';

class Updater extends StatelessWidget {
  const Updater({Key? key}) : super(key: key);

  Future<UpdaterModel?> getVersion() async {
    try {
      Uri url = Uri.parse('http://192.168.0.103/app/release.json');
      final response = await http.get(url);
      if (response.statusCode == HttpStatus.ok) {
        // UpdaterModel updaterModel = UpdaterModel.fromJson(response.body);
        String buildNumber = (await PackageInfo.fromPlatform()).buildNumber;
        return UpdaterModel.fromJson(
          response.body,
          buildNumber,
        );
      }
      // TODO: remove print
      if (kDebugMode) {
        print(response.statusCode);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Updater getVersion:\t $e');
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getVersion(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Container(
            constraints: const BoxConstraints(
              maxWidth: 512.0,
              maxHeight: 512.0,
            ),
            alignment: Alignment.center,
            child: Text(snapshot.error.toString()),
          );
        }
        UpdaterModel updaterModel = snapshot.data!;
        int currentBuildNumber = int.parse(updaterModel.currentBuildNumber);
        if (updaterModel.buildNumber > currentBuildNumber) {
          return UpdateDialog(
            isMandatory: updaterModel.minimumVersion > currentBuildNumber,
            apkUrl: updaterModel.apkUrl,
          );
        }
        return Container(
          margin: const EdgeInsets.all(128.0),
          alignment: Alignment.center,
          color: Theme.of(context).colorScheme.background,
          child: Text(
            '${snapshot.data!.buildNumber}\t${snapshot.data!.currentBuildNumber}\n'
            'There is no Update Available',
          ),
        );
      },
    );
  }
}

class UpdateDialog extends StatefulWidget {
  const UpdateDialog({
    Key? key,
    required this.isMandatory,
    required this.apkUrl,
  }) : super(key: key);

  final bool isMandatory;
  final String apkUrl;

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

///Print error
void printError(dynamic text) {
  debugPrint('\x1B[31m${text.toString()}\x1B[0m');
}

class _UpdateDialogState extends State<UpdateDialog> {
  Future startDownload(String url, String id) async {
    Directory tempDirectory = await directory();
    List<FileSystemEntity> listEntity = tempDirectory.listSync();

    for (FileSystemEntity entity in listEntity) {
      File file = File(entity.path);
      file.deleteSync();
    }

    int downloadedLength = 0;

    String totalLength = await checkFileSize(url);

    if (totalLength.isNotEmpty) {
      totalLength = '${int.parse(totalLength) - 1}';
    }

    listEntity = tempDirectory.listSync();

    for (FileSystemEntity entity in listEntity) {
      File file = File(entity.path);
      downloadedLength = downloadedLength + file.lengthSync();
    }
    int index = 0;

    if (listEntity.isNotEmpty) {
      index =
          int.tryParse(listEntity.last.path.split('-').last.split('.').first) ??
              0;
    }
    String fileName = '${tempDirectory.path}/app$id-${index + 1}.apk';

    try {
      await Dio().download(
        url,
        fileName,
        // cancelToken: token,
        onReceiveProgress: (currentProgress, totalProgress) {

        },
        options: Options(),
        deleteOnError: false,
      );
    } catch (e) {
      printError(e);
    }
  }

  Future<Directory> directory() async {
    Directory tempDir = await getTemporaryDirectory();
    Directory updateDirectory = Directory('${tempDir.path}/Updater/');

    if (!await updateDirectory.exists()) {
      await updateDirectory.create();
    }

    return updateDirectory;
  }

  Future<String> checkFileSize(String url) async {
    try {
      Response response = await Dio().head(url);
      return (response.headers.value(Headers.contentLengthHeader)) ?? '';
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.updateTitle),
      content: const LinearProgressIndicator(
        value: 0.9,
      ),
    );
  }
}

class UpdaterModel {
  const UpdaterModel({
    required this.buildNumber,
    required this.version,
    required this.minimumVersion,
    required this.apkUrl,
    required this.currentBuildNumber,
  });

  final int buildNumber;
  final String version;
  final int minimumVersion;
  final String apkUrl;
  final String currentBuildNumber;

  factory UpdaterModel.fromJson(
    String str,
    String currentBuildNumber,
  ) =>
      UpdaterModel.fromMap(json.decode(str), currentBuildNumber);

  factory UpdaterModel.fromMap(
    Map<String, dynamic> json,
    String currentBuildNumber,
  ) =>
      UpdaterModel(
        buildNumber: json['versionCode'],
        version: json['versionName'],
        minimumVersion: json['minSupport'],
        apkUrl: json['url'],
        currentBuildNumber: currentBuildNumber,
      );
}
