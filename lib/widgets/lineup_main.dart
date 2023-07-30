import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wacken_lineup/provider/lineup_provider.dart';
import 'package:wacken_lineup/widgets/line_up_by_day.dart';

class LineUpMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<LineUpProvider>(context);
    return SafeArea(
      child: LineUpByDay(),
    );
  }
}
