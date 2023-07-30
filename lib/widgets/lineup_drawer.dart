import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wacken_lineup/provider/lineup_provider.dart';
import 'package:wacken_lineup/widgets/favorites.dart';
import 'package:wacken_lineup/widgets/flat_icon_text_button.dart';
import 'package:wacken_lineup/widgets/line_up_by_day.dart';

class LineUpDrawer extends StatelessWidget {
  final String title;
  LineUpDrawer({required this.title});

  @override
  build(BuildContext context) {
    var favorites = Provider.of<LineUpProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: Text(title),
        leading: Semantics(
          label: 'Close menu',
          child: IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          FlatIconTextButton(
            icon: Icons.calendar_today,
            text: 'Show Overview',
            onPressed: title == 'Favorites'
                ? () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LineUpByDay();
                        },
                      ),
                    );
                  }
                : null,
          ),
          FlatIconTextButton(
            icon: Icons.favorite,
            text: 'Show Favorites',
            onPressed: title == 'Overview'
                ? () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Favorites(),
                      ),
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
