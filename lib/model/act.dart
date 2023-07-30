import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wacken_lineup/provider/lineup_provider.dart';
import 'package:wacken_lineup/utility/time_utilities.dart';

class Act extends StatelessWidget {
  int uid;
  String name;
  String stage;
  String day;
  DateTime start;
  DateTime end;
  bool favorite;
  String performance;

  Act({
    Key? key,
    required this.uid,
    required this.name,
    required this.stage,
    required this.day,
    required this.start,
    required this.end,
    required this.performance,
    required this.favorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          name,
        ),
        leading: Consumer<LineUpProvider>(
          builder: (context, favoriteProvider, child) => IconButton(
            icon: Icon(favorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              LineUpProvider provider =
                  Provider.of<LineUpProvider>(context, listen: false);
              provider.favoriteAct(context, this);
            },
          ),
        ),
        subtitle: Column(
          children: [
            Text('$stage - $performance'),
            Text(
                '${TimeUtilities.formatTime(start.hour)}:${TimeUtilities.formatTime(start.minute)} - ${TimeUtilities.formatTime(end.hour)}:${TimeUtilities.formatTime(end.minute)}')
          ],
        ),
      ),
    );
  }
}
