import 'package:flutter/material.dart';
import 'package:wacken_lineup/model/act.dart';
import 'package:wacken_lineup/model/day.dart';
import 'package:wacken_lineup/model/favorited_acts.dart';
import 'package:wacken_lineup/model/stage.dart';

enum LineUpFetchState { ok, timeout, noDataConnection, unknownError }

class LineUp {
  late List<Day> days;
  List<Act> acts;
  FavoritedActs favActs;
  LineUpFetchState fetchState;
  String fetchMessage;
  List<String> performances;

  LineUp({
    required this.acts,
    required this.favActs,
    required this.fetchState,
    required this.fetchMessage,
    required this.performances,
  }) {
    initDays();
  }

  factory LineUp.fromJson(var json, FavoritedActs favActs) {
    return LineUp(
        acts: jsonToActList(json, favActs),
        favActs: favActs,
        fetchState: LineUpFetchState.ok,
        fetchMessage: '',
        performances: jsonToPerformances(json));
  }

  static List<String> jsonToPerformances(Iterable<dynamic> json) {
    List<String> performances = [];
    for (var j in json) {
      if (j['performance']['uid'] != null &&
          j['performance']['title'] != null &&
          j['performance']['title'] != 'null') {
        if (performances.contains(j['performance']['title'])) {
          continue;
        } else {
          performances.add(j['performance']['title']);
        }
      } else {
        print(j['uid']);
      }
    }
    return performances;
  }

  static List<Act> jsonToActList(
      Iterable<dynamic> json, FavoritedActs favActs) {
    List<Act> actList = [];
    for (var j in json) {
      actList.add(Act(
        uid: j['uid'],
        name: j['artists'][0]['title'],
        day: j['festivalday']['title'],
        stage: j['stage']['title'],
        performance: j['performance']['title'],
        favorite: favActs.uids.contains(j['uid']),
        end: DateTime.fromMillisecondsSinceEpoch(int.parse(j['end']) * 1000),
        start:
            DateTime.fromMillisecondsSinceEpoch(int.parse(j['start']) * 1000),
      ));
    }
    return actList;
  }

  void initDays() {
    days = List<Day>.empty(growable: true);
    List<String> allDays = List<String>.empty(growable: true);
    List<String> allStages = List<String>.empty(growable: true);

    for (Act a in acts) {
      if (!allDays.contains(a.day)) {
        allDays.add(a.day);
      }
    }
    for (Act a in acts) {
      if (!allStages.contains(a.stage)) {
        allStages.add(a.stage);
      }
    }

    for (String currentDay in allDays) {
      Day d = Day(name: currentDay, stages: []);
      for (String currentStage in allStages) {
        Stage s = Stage(name: currentStage, acts: []);
        for (Act currentAct in acts) {
          if (currentAct.day == currentDay &&
              currentAct.stage == currentStage) {
            s.acts.add(currentAct);
          }
        }
        d.stages.add(s);
      }
      days.add(d);
    }
  }

  List<Widget> getDaysAsText() {
    List<Text> texts = List<Text>.empty(growable: true);
    for (Day d in days) {
      texts.add(Text(d.name.substring(0, 2)));
    }
    return texts;
  }
}
