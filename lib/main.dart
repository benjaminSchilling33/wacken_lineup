import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wacken_lineup/model/lineup.dart';
import 'package:wacken_lineup/provider/lineup_provider.dart';
import 'package:wacken_lineup/widgets/lineup_main.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MaterialApp(
        home: ThemeWrapper(),
      ),
    );
  });
}

class ThemeWrapper extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText1: TextStyle(
            color: Colors.redAccent,
          ),
          bodyText2: TextStyle(
            color: Colors.redAccent,
          ),
          button: TextStyle(
            color: Colors.redAccent,
          ),
          caption: TextStyle(
            color: Colors.white,
          ),
          headline1: TextStyle(
            color: Colors.redAccent,
          ),
          headline2: TextStyle(
            color: Colors.redAccent,
          ),
          headline3: TextStyle(
            color: Colors.redAccent,
          ),
          headline4: TextStyle(
            color: Colors.redAccent,
          ),
          headline5: TextStyle(
            color: Colors.redAccent,
          ),
          headline6: TextStyle(
            color: Colors.redAccent,
          ),
          overline: TextStyle(
            color: Colors.redAccent,
          ),
          subtitle1: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          subtitle2: TextStyle(
            color: Colors.redAccent,
          ),
        ),
        brightness: Brightness.dark,
        backgroundColor: Colors.black54,
        tabBarTheme: const TabBarTheme(
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          unselectedLabelStyle:
              TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
          labelPadding: EdgeInsets.fromLTRB(0, 16, 0, 16),
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 3,
              color: Colors.white,
              style: BorderStyle.solid,
            ),
          ),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Colors.redAccent,
        ),
        primaryColorDark: Color(0xFF500053),
        indicatorColor: Color(0xff344955),
        scaffoldBackgroundColor: Colors.black54,
        bottomAppBarTheme: BottomAppBarTheme(
          color: Color(0xFF212C39),
        ),
        cardColor: Color(0xFF751a1a),
        appBarTheme: AppBarTheme(
          color: Color(0xFF212C39),
          iconTheme: IconThemeData(
            color: Color(0xFFF8F8FF),
          ),
        ),
        dialogBackgroundColor: Color(0xff344955),
        iconTheme: IconThemeData(
          color: Color(0xFFF8F8FF),
        ),
        toggleableActiveColor: Color(0xFF0967F3),
      ),
      home: WackenLineup(),
    );
  }
}

class WackenLineup extends StatelessWidget {
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LineUpProvider(),
      child: Consumer<LineUpProvider>(
        builder: (context, lineUpProvider, child) => FutureBuilder<LineUp>(
          future: lineUpProvider.futureLineUp,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              lineUpProvider.initializeProvider(snapshot.data!);
              return MaterialApp(
                theme: Theme.of(context),
                home: LineUpMain(),
              );
            } else {
              // As long as no data is available show the loading screen
              return MaterialApp(
                theme: Theme.of(context),
                title: 'Wacken - Running Order',
                home: Scaffold(
                  appBar: AppBar(
                    title: const Text(
                      "Wacken - Running Order",
                    ),
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const CircularProgressIndicator(),
                        Container(
                          child: const Text('Loading Running Order...'),
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
