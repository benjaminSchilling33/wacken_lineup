import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wacken_lineup/model/act.dart';
import 'package:wacken_lineup/model/lineup.dart';
import 'package:wacken_lineup/utility/lineup_fetcher.dart';

class LineUpProvider extends ChangeNotifier {
  late Future<LineUp> futureLineUp;
  late LineUp lineUp;
  bool isInitialized = false;

  List<String> appliedFilter = [
    'Concert',
    'Action',
    'Walking Acts',
    'Party',
    'Spoken Word'
  ];

  LineUpProvider() {
    futureLineUp = LineUpFetcher.fetchLineUp();
    futureLineUp.then((value) => initializeProvider(value));
  }

  void initializeProvider(LineUp lineUp) async {
    if (!isInitialized) {
      this.lineUp = lineUp;
      lineUp.initDays();
      appliedFilter = lineUp.performances;
      isInitialized = true;
    }
  }

  void favoriteAct(BuildContext context, Act act) {
    if (act.favorite) {
      lineUp.favActs.removeFavoriteAct(act.uid);
    } else {
      lineUp.favActs.addFavoriteAct(act.uid);
    }
    act.favorite = !act.favorite;
    print(
        'Act: ' + act.name + ' Favorite: ' + (act.favorite ? 'true' : 'false'));
    notifyListeners();
  }

  void addFilter(String performance) {
    appliedFilter.add(performance);
    notifyListeners();
  }

  void removeFilter(String performance) {
    appliedFilter.removeAt(appliedFilter.indexOf(performance));
    notifyListeners();
  }
}
