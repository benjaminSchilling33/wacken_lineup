/*
congress_fahrplan
This is the dart file containing the FahrplanFetcher class needed to fetch the Fahrplan.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 - 2020 Benjamin Schilling
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:wacken_lineup/model/favorited_acts.dart';
import 'package:wacken_lineup/model/lineup.dart';
import 'package:wacken_lineup/utility/file_storage.dart';

class LineUpFetcher {
  static String completeLineUpUrl =
      'https://www.wacken.com/fileadmin/Json/events-complete.json';

  static Future<LineUp> fetchLineUp() async {
    File? lineUpFile;
    DateTime lineUpLastModified;
    String lineUpJson;

    /// Used to reduce traffic
    String ifNoneMatch = "";
    String ifModifiedSince = "";

    ///Fetch the favorites from the local file
    FavoritedActs favActs;
    File favoriteFile;
    if (await FileStorage.favoriteFileAvailable) {
      favoriteFile = await FileStorage.localFavoriteFile;
      String favoriteData = await favoriteFile.readAsString();
      favActs = FavoritedActs.fromJson(json.decode(favoriteData));
    } else {
      favActs = FavoritedActs(
        uids: List<int>.empty(growable: true),
      );
    }

    ///Load the modification date of the lineUpFile for the If-Modified-Since http request header
    if (await FileStorage.dataFileAvailable) {
      lineUpFile = await FileStorage.localDataFile;
      lineUpLastModified = await lineUpFile.lastModified();

      /// Set If-Modified-Since
      ifModifiedSince = HttpDate.format(lineUpLastModified.toUtc());
    }

    /// Fetch the LineUp from the REST API
    /// Check for network connectivity
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      /// Fetch the fahrplan depending on what is set in the settings,
      /// if the timeout expires load the local fahrplan

      final response = await http
          .get(
            Uri.parse(completeLineUpUrl),
            headers: {
              "If-Modified-Since": ifModifiedSince,
            },
          )
          .timeout(const Duration(seconds: 20))
          .catchError((e) {});

      ///If the HTTP Status code is 200 OK use the Fahrplan from the response,
      ///Else if the HTTP Status Code is 304 Not Modified use the local file.
      ///Else if a local fahrplan file is available use it
      ///Else return empty fahrplan
      if (response.statusCode == 200 && response.bodyBytes != null) {
        lineUpJson = utf8.decode(response.bodyBytes);

        /// Store the fetched JSON
        FileStorage.writeDataFile(lineUpJson);

        return LineUp.fromJson(json.decode(lineUpJson), favActs);
      } else if (response.statusCode == 304) {
        lineUpJson = await lineUpFile!.readAsString();
        if (lineUpJson != '') {
          return LineUp.fromJson(json.decode(lineUpJson), favActs);
        }
      } else {
        return LineUp(
          acts: [],
          favActs: FavoritedActs.empty(),
          fetchState: LineUpFetchState.timeout,
          fetchMessage: 'Please check your network connection.',
          performances: [],
        );
      }

      /// If not connected, try to load from file, otherwise set Fahrplan.isEmpty
    } else {
      lineUpJson = await lineUpFile!.readAsString();
      if (lineUpJson != '') {
        return LineUp.fromJson(json.decode(lineUpJson), favActs);
      } else {
        return LineUp(
          acts: [],
          favActs: FavoritedActs.empty(),
          fetchState: LineUpFetchState.noDataConnection,
          fetchMessage: 'Please enable mobile data or Wifi.',
          performances: [],
        );
      }
    }
    return LineUp(
      acts: [],
      favActs: FavoritedActs.empty(),
      fetchState: LineUpFetchState.unknownError,
      fetchMessage: 'Unknown error',
      performances: [],
    );
  }
}
