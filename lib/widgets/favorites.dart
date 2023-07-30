import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wacken_lineup/model/day.dart';
import 'package:wacken_lineup/provider/lineup_provider.dart';
import 'package:wacken_lineup/utility/time_utilities.dart';
import 'package:wacken_lineup/widgets/lineup_drawer.dart';

class Favorites extends StatelessWidget {
  late Widget dayTabCache;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme.of(context),
      home: SafeArea(
        child: buildDayLayout(context),
      ),
    );
  }

  List<Widget> buildDayTabs(BuildContext context) {
    LineUpProvider provider = Provider.of<LineUpProvider>(context);
    List<Column> dayColumns = [];
    for (Day d in provider.lineUp.days) {
      if (d.getNumberOfActs() > 0) {
        List<Widget> widgets = [];
        widgets.addAll(d.getAllActs(provider.appliedFilter));
        dayColumns.add(
          Column(
            children: <Widget>[
              Expanded(
                child: Consumer<LineUpProvider>(
                  builder: (context, favoriteProvider, child) =>
                      ListView.builder(
                    itemCount: d.getFavoritedActs(context).length,
                    itemBuilder: (context, index) {
                      return d.getFavoritedActs(context)[index];
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
    return dayColumns;
  }

  Widget buildDayLayout(BuildContext context) {
    LineUpProvider provider = Provider.of<LineUpProvider>(context);
    dayTabCache = TabBarView(
      children: buildDayTabs(context),
    );
    return DefaultTabController(
      length: provider.lineUp.days.length,
      initialIndex: TimeUtilities.getInitialIndex(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wacken 2022 - Favorites'),
          bottom: PreferredSize(
            child: TabBar(
              tabs: provider.lineUp.getDaysAsText(),
            ),
            preferredSize: const Size.fromHeight(50),
          ),
        ),
        drawer: LineUpDrawer(
          title: 'Favorites',
        ),
        body: dayTabCache,
      ),
    );
  }
}
