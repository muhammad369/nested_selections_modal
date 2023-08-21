import 'package:flutter/material.dart';
import 'package:nested_selection_dialog/nested_selection_modal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? selection = null;
  List<int> selections = []; // [2010,3,4];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  var r = await showNestedSelectionsModal<String>(context,
                      initialSelections: [],
                      items: _createItems()!,
                      );
                  print(r?.toString());
                },
                child: Text('show Nested Selection Modal')),
            SizedBox(
              height: 30,
            ),
            // NestedSelectionView<int>(
            //     selections: selections,
            //     onSelectionChanged: (s) {
            //       selections = s;
            //       setState(() {});
            //     },
            //     items: List.generate(30, (index) => index + 2000)
            //         .map((e) => SelectionItemModel(
            //             label: '$e',
            //             value: e,
            //             children: List.generate(
            //                 12,
            //                 (index) => SelectionItemModel(
            //                     label: (index + 1).toString(),
            //                     value: (index + 1),
            //                     children: List.generate(30,
            //                         (index) => SelectionItemModel(label: (index + 1).toString(), value: index + 1))))))
            //         .toList())
          ],
        ),
      ),
    );
  }

  List<SelectionItemModel<String>>? _createItems({String? parent = null, int level = 0}) {
    if (level == 4) return null;
    if (level == 0) {
      return ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J']
          .map((e) => SelectionItemModel(label: e, value: e, children: _createItems(parent: e, level: level + 1)))
          .toList();
    }
    //
    return List.generate(
      10,
      (index) => SelectionItemModel(
          label: '$parent-${index + 1}',
          value: '$parent-${index + 1}',
          children: _createItems(parent: '$parent-${index + 1}', level: level + 1)),
    );
  }
}
