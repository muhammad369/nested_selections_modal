library nested_selection_dialog;

import 'package:flutter/cupertino.dart';

class SelectionView<T> extends StatelessWidget{

  final List<T> items;
  final selctedIndex;

  const SelectionView({super.key, required this.items, required this.selctedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          physics: FixedExtentScrollPhysics(),
          itemBuilder: (context, index) => Text(items[index].toString())),
    );
  }

}