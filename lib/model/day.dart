import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wacken_lineup/model/act.dart';
import 'package:wacken_lineup/model/stage.dart';
import 'package:wacken_lineup/provider/lineup_provider.dart';

class Day {
  String name;
  List<Stage> stages;

  Day({required this.name, required this.stages});

  int getNumberOfActs() {
    int numActs = 0;
    for (Stage s in stages) {
      for (Act a in s.acts) {
        numActs++;
      }
    }
    return numActs;
  }

  List<Act> getAllActs(List<String> filter) {
    List<Act> acts = List<Act>.empty(growable: true);

    for (Stage s in stages) {
      for (Act a in s.acts) {
        if (filter.contains(a.performance)) {
          acts.add(a);
        }
      }
    }

    acts.sort(
      (a, b) => a.start.compareTo(b.start),
    );
    return acts;
  }

  List<Act> getFavoritedActs(BuildContext context) {
    List<Act> acts = List<Act>.empty(growable: true);

    LineUpProvider provider =
        Provider.of<LineUpProvider>(context, listen: false);
    for (Stage s in stages) {
      for (Act a in s.acts) {
        if (provider.lineUp.favActs.uids.contains(a.uid)) {
          acts.add(a);
        }
      }
    }

    acts.sort(
      (a, b) => a.start.compareTo(b.start),
    );
    return acts;
  }
}
