import 'package:flutter/material.dart';
import 'package:wacken_lineup/provider/lineup_provider.dart';
import 'package:wacken_lineup/widgets/flat_icon_text_button.dart';

class CheckboxButton extends StatefulWidget {
  final String text;
  final LineUpProvider provider;
  late bool checked;
  CheckboxButton({required this.text, required this.provider}) {
    checked = provider.appliedFilter.contains(text);
  }

  @override
  _CheckboxButton createState() => _CheckboxButton();
}

class _CheckboxButton extends State<CheckboxButton> {
  @override
  Widget build(BuildContext context) {
    return FlatIconTextButton(
        icon: widget.checked ? Icons.check_box : Icons.check_box_outline_blank,
        text: widget.text,
        onPressed: widget.checked ? removeFilter : addFilter);
  }

  void removeFilter() {
    widget.provider.removeFilter(widget.text);
    setState(() {
      widget.checked = !widget.checked;
    });
  }

  void addFilter() {
    widget.provider.addFilter(widget.text);
    setState(() {
      widget.checked = !widget.checked;
    });
  }
}
