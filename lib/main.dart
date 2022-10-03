// Started with https://docs.flutter.dev/development/ui/widgets-intro

import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _inputController = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.red);

  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add a Location'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _inputController,
              decoration: const InputDecoration(hintText: "type location here"),
            ),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("OKButton"),
                style: yesStyle,
                onPressed: () {
                  setState(() {
                    _handleNewItem(valueText);
                    Navigator.pop(context);
                  });
                },
                child: const Text('Ok'),
              ),

              // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _inputController,
                builder: (context, value, child) {
                  return ElevatedButton(
                    key: const Key("CancelButton"),
                    style: noStyle,
                    onPressed: value.text.isNotEmpty
                        ? () {
                            setState(() {
                              _handleNewItem(valueText);
                              Navigator.pop(context);
                            });
                          }
                        : null,
                    child: const Text('Cancel'),
                  );
                },
              ),
            ],
          );
        });
  }

  String valueText = "";

  final List<Item> items = [
    const Item(name: "Trieschmann"),
    const Item(name: "Brick Pit"),
    const Item(name: "Bailey")
  ];

  final _itemSet = <Item>{};

  void _handleListChanged(Item item, bool completed) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      //items.remove(item);
      //if (!completed) {
      //  print("Completing");
      //  _itemSet.add(item);
      //  items.add(item);
      //} else {
      //  print("Making Undone");
      //  _itemSet.remove(item);
      //  items.insert(0, item);
      //}

      _displayCatInput(context);
    });
  }

  Future<void> _displayCatInput(BuildContext context) async {
    print("Loading Cat Dialog");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Add a Cat'),
              content: TextField(
                onChanged: (value) {
                  setState(() {
                    valueText = value;
                  });
                },
                controller: _inputController,
                decoration:
                    const InputDecoration(hintText: "type cat name here"),
              ),
              actions: <Widget>[
                ElevatedButton(
                  key: const Key("OKButton"),
                  style: yesStyle,
                  onPressed: () {
                    setState(() {
                      //needs to add a cat in the list
                      Navigator.pop(context);
                    });
                  },
                  child: const Text('Ok'),
                ),
              ]);
        });
  }

  void _handleDeleteItem(Item item) {
    setState(() {
      print("Deleting item");
      items.remove(item);
    });
  }

  void _handleNewItem(String itemText) {
    setState(() {
      print("Adding new item");
      Item item = Item(name: itemText);
      items.insert(0, item);
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Hendrix Cats'),
          backgroundColor: Colors.orange,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: items.map((item) {
            return ToDoListItem(
              item: item,
              completed: _itemSet.contains(item),
              onListChanged: _handleListChanged,
              onDeleteItem: _handleDeleteItem,
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              _displayTextInputDialog(context);
            }));
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Hendrix Cats',
    home: ToDoList(),
  ));
}
