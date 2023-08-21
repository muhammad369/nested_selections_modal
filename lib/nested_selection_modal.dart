library nested_selection_modal;

import 'package:flutter/material.dart';

Future<List<T>?> showNestedSelectionsModal<T>(BuildContext context,
    {required List<SelectionItemModel<T>> items,
    List<T>? initialSelections,
    Widget Function(SelectionItemModel<T>)? itemBuilder,
    Widget Function(SelectionItemModel<T>)? selectedItemBuilder,
    double selectorHeight = 250,
    double selectionMagnification = 1,
    double itemHeight = 40,
    double selectorWidth = 120,
    String okText = 'Ok',
    String cancelText = 'Cancel'}) {
  return showModalBottomSheet<List<T>?>(
      isDismissible: false,
      constraints: BoxConstraints(maxHeight: selectorHeight + 150),
      context: context,
      builder: (context) {
        List<T> selections = initialSelections ?? [];
        return StatefulBuilder(
            builder: (context, setState) => _NestedSelectionModal(
                  items: items,
                  okText: okText,
                  cancelText: cancelText,
                  selectorWidth: selectorWidth,
                  selections: selections,
                  selectorHeight: selectorHeight,
                  selectionMagnification: selectionMagnification,
                  itemHeight: itemHeight,
                  itemBuilder: itemBuilder,
                  selectedItemBuilder: selectedItemBuilder,
                  onSelectionChanged: (s) {
                    setState(() {
                      selections = s;
                    });
                  },
                ));
      });
}

class _NestedSelectionModal<T> extends StatelessWidget {
  final List<SelectionItemModel<T>> items;
  final List<T>? selections;
  final Widget Function(SelectionItemModel<T>)? itemBuilder;
  final Widget Function(SelectionItemModel<T>)? selectedItemBuilder;
  final double selectionMagnification;
  final double selectorHeight;
  final double itemHeight;
  final double selectorWidth;
  final void Function(List<T>) onSelectionChanged;
  //
  final String okText, cancelText;

  const _NestedSelectionModal(
      {super.key,
      required this.items,
      this.selections,
      this.itemBuilder,
      this.selectedItemBuilder,
      this.selectorHeight = 250,
      this.selectionMagnification = 1,
      this.itemHeight = 40,
      this.selectorWidth = 120,
      required this.okText,
      required this.cancelText,
      required this.onSelectionChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text(okText),
                  onPressed: () {
                    Navigator.of(context).pop(selections);
                  },
                ),
                SizedBox(
                  width: 30,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text(cancelText),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          NestedSelectionView<T>(
            onSelectionChanged: onSelectionChanged,
            items: items,
            itemBuilder: itemBuilder,
            selectedItemBuilder: selectedItemBuilder,
            itemHeight: itemHeight,
            selections: selections,
            selectionMagnification: selectionMagnification,
            selectorHeight: selectorHeight,
            selectorWidth: selectorWidth,
          ),
        ],
      ),
    );
  }
}

class NestedSelectionView<T> extends StatelessWidget {
  final List<SelectionItemModel<T>> items;
  final List<T>? selections;
  final Widget Function(SelectionItemModel<T>)? itemBuilder;
  final Widget Function(SelectionItemModel<T>)? selectedItemBuilder;
  final void Function(List<T>) onSelectionChanged;
  final double selectionMagnification;
  final double selectorHeight;
  final double itemHeight;
  final double selectorWidth;

  const NestedSelectionView(
      {super.key,
      required this.items,
      this.selections,
      this.itemBuilder,
      this.selectedItemBuilder,
      required this.onSelectionChanged,
      this.selectorHeight = 250,
      this.selectionMagnification = 1,
      this.itemHeight = 40,
      this.selectorWidth = 120});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: getListsAndSelections()
              .mapIndexed((i, e) => SelectionView<T>(
                    items: e.$2,
                    selection: e.$1,
                    onSelectionChanged: (s) {
                      List<T> newSelections;
                      //
                      if (selections == null || selections!.isEmpty) {
                        newSelections = [s];
                      } else if (selections!.length <= i) {
                        //selections!.add(s);
                        newSelections = selections!..add(s);
                      } else {
                        newSelections = [];
                        selections![i] = s;
                        // inner selections should be set null
                        for (int j = 0; j <= i; j++) {
                          newSelections.add(selections![j]);
                        }
                      }
                      onSelectionChanged(newSelections);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  Iterable<(T?, List<SelectionItemModel<T>>)> getListsAndSelections() sync* {
    //int index = 0;
    //
    if (selections == null || selections!.isEmpty) {
      yield (null, items);
      return;
    }
    //
    List<SelectionItemModel<T>>? currentItems = items;
    for (var selection in selections!) {
      yield (selection, currentItems!);
      //
      currentItems = currentItems.firstWhere((element) => element.value == selection).children;
    }
    //
    if (currentItems != null) {
      yield (null, currentItems);
    }
  }

  List<T> getDefaultSelections() {
    var selections = <T>[];

    List<SelectionItemModel<T>>? currentItems = items;
    //
    while (currentItems != null) {
      selections.add(currentItems.first.value);
      //
      currentItems = currentItems.first.children;
    }
    //
    return selections;
  }
}

class SelectionView<T> extends StatelessWidget {
  final List<SelectionItemModel<T>> items;
  final T? selection;
  final Widget Function(SelectionItemModel<T>)? itemBuilder;
  final Widget Function(SelectionItemModel<T>)? selectedItemBuilder;
  final void Function(T) onSelectionChanged;
  final double selectionMangnification;
  final double selectorHeight;
  final double itemHeight;
  final double selectorWidth;

  const SelectionView(
      {super.key,
      required this.items,
      this.selection,
      this.itemBuilder,
      this.selectedItemBuilder,
      required this.onSelectionChanged,
      this.selectorHeight = 250,
      this.selectionMangnification = 1,
      this.itemHeight = 40,
      this.selectorWidth = 120});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: selectorHeight,
        width: selectorWidth,
        child: ListWheelScrollView(
          magnification: selectionMangnification,
          onSelectedItemChanged: (i) => onSelectionChanged(items[i].value),
          useMagnifier: selectionMangnification > 1,
          itemExtent: itemHeight,
          controller: FixedExtentScrollController(initialItem: items.indexOfWhere((e) => e.value == selection) ?? 0),
          physics: const FixedExtentScrollPhysics(),
          children: itemBuilder == null
              ? items
                  .map(
                    (e) => GestureDetector(
                      onDoubleTap: () {
                        onSelectionChanged(e.value);
                        //print('item double tapped ${e.value}');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: Text(e.label,
                            style: e.value == selection ? TextStyle(fontWeight: FontWeight.bold, fontSize: 25) : null),
                      ),
                    ),
                  )
                  .toList()
              : items
                  .map(
                    (e) => GestureDetector(
                        onDoubleTap: () {
                          onSelectionChanged(e.value);
                          //print('item double tapped ${e.value}');
                        },
                        child: (e.value == selection && selectedItemBuilder != null)
                            ? selectedItemBuilder!(e)
                            : itemBuilder!(e)),
                  )
                  .toList(),
        ));
  }
}

class SelectionItemModel<T> {
  final String label;
  final T value;
  final List<SelectionItemModel<T>>? children;

  SelectionItemModel({required this.label, required this.value, this.children});
}

extension IterableExtensions<Y> on Iterable<Y> {
  Iterable<T> mapIndexed<T>(T Function(int index, Y item) mapper) sync* {
    int i = 0;
    for (final element in this) {
      yield mapper(i, element);
      i++;
    }
  }

  int? indexOfWhere(bool Function(Y item) cond) {
    var index = 0;
    for (final element in this) {
      if (cond(element)) {
        return index;
      }
      index++;
    }
    return null;
  }
}
