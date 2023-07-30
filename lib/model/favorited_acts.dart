/*
congress_fahrplan
This is the dart file containing the FavoritedTalks class needed by the Fahrplan class.
SPDX-License-Identifier: GPL-2.0-only
Copyright (C) 2019 Benjamin Schilling
*/

import 'package:wacken_lineup/utility/file_storage.dart';

class FavoritedActs {
  final List<int> uids;

  FavoritedActs({required this.uids});

  factory FavoritedActs.fromJson(Map json) {
    if (json != null) {
      return FavoritedActs(
        uids: json['ids'].cast<int>(),
      );
    }
    return FavoritedActs(uids: List<int>.empty(growable: true));
  }

  factory FavoritedActs.empty() {
    return FavoritedActs(uids: []);
  }

  void addFavoriteAct(int id) {
    uids.add(id);
    FileStorage.writeFavoritesFile('{"ids": $uids}');
    print('added: $id');
    print(uids);
  }

  void removeFavoriteAct(int id) {
    uids.remove(id);
    FileStorage.writeFavoritesFile('{"ids": $uids}');
    print('removed: $id');
    print(uids);
  }
}
