import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wacken_lineup/model/day.dart';
import 'package:wacken_lineup/provider/lineup_provider.dart';
import 'package:wacken_lineup/utility/time_utilities.dart';
import 'package:wacken_lineup/widgets/checkbox_button.dart';
import 'package:wacken_lineup/widgets/lineup_drawer.dart';

class LineUpByDay extends StatelessWidget {
  late Widget dayTabCache;

  @override
  Widget build(BuildContext context) {
    return buildDayLayout(context);
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
                child: ListView.builder(
                  itemCount: d.getAllActs(provider.appliedFilter).length,
                  itemBuilder: (context, index) {
                    return d.getAllActs(provider.appliedFilter)[index];
                  },
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
          title: const Text('Wacken - Running Order'),
          actions: [
            IconButton(
                onPressed: () => showFilterDialog(context),
                icon: Icon(Icons.filter_list))
          ],
          bottom: PreferredSize(
            child: TabBar(
              tabs: provider.lineUp.getDaysAsText(),
            ),
            preferredSize: const Size.fromHeight(50),
          ),
        ),
        drawer: LineUpDrawer(
          title: 'Overview',
        ),
        body: dayTabCache,
      ),
    );
  }

  void showFilterDialog(BuildContext context) {
    LineUpProvider provider =
        Provider.of<LineUpProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.all(10),
        title: Text('Select Performance Types'),
        content: getPerformanceTypesList(context, provider),
      ),
    );
  }

  Widget getPerformanceTypesList(
      BuildContext context, LineUpProvider provider) {
    return Container(
      height: 400,
      width: 400,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: provider.lineUp.performances.length,
        itemBuilder: (context, index) {
          return CheckboxButton(
              text: '${provider.lineUp.performances[index]}',
              provider: provider);
        },
      ),
    );
  }
}
