// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';

 String dropdownValue = "blue";

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _inputController = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);
  final ButtonStyle plainStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.blue);

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Item To Add'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _inputController,
              decoration:
                  const InputDecoration(hintText: "type something here"),
            ),
            actions: <Widget>[
              // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _inputController,
                builder: (context, value, child) {
                  return ElevatedButton(
                    key: const Key("OKButton"),
                    style: yesStyle,
                    onPressed: value.text.isNotEmpty
                        ? () {
                            setState(() {
                              _handleNewItem(valueText);
                              Navigator.pop(context);
                            });
                          }
                        : null,
                    child: const Text('OK'),
                  );
                },
              ),
              ElevatedButton(
                key: const Key("CancelButton"),
                style: noStyle,
                child: const Text('Cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  String valueText = "";

  final List<Item> items = [const Item(name: "add more todos")];

  final _itemSet = <Item>{};

  void _handleListChanged(Item item, bool completed) {
    setState(() {
      items.remove(item);
      if (!completed) {
        _itemSet.add(item);
        items.add(item);
      } else {
        _itemSet.remove(item);
        items.insert(0, item);
      }
    });
  }
  

  void _itemSort() {
    // a function that sorts the item
    items.sort((a, b) {
      return a.name.compareTo(b.name);
    });
  }

  void _handleDeleteItem(Item item) {
    setState(() {
      items.remove(item);
    });
  }

  void _handleNewItem(String itemText) {
    setState(() {
      Item item = Item(name: itemText);
      items.insert(0, item);

      _itemSort(); // calls the function i created

      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('To Do List'),
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
          //creates the dropdown menu needed to select the color of the icons
        drawer:  DropdownButton<String>(
              isExpanded: true,
              value: dropdownValue, 
              dropdownColor: colorSelect(dropdownValue),
              items: <String>["pink", "red", "blue", "green", "purple"]
              .map<DropdownMenuItem<String>>((String value){
                return DropdownMenuItem<String>(
                  value:value,
                child: Text(value)
                );
              }).toList(), 
              onChanged: (String? newValue){
                setState(() {
                  dropdownValue = newValue!;
                });
              }),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              _displayTextInputDialog(context);
            }));
  }
}
Color colorSelect(String colorChange){
    if (colorChange == "pink"){
      return Colors.pink;
    }else if(colorChange == "red"){
      return Colors.red;
    }else if(colorChange == "purple"){
      return Colors.purple;
    }else if(colorChange == "green"){
      return Colors.green;
    }else if(colorChange == "blue"){
      return Colors.blue;
    }
    return Colors.orange;
  }
      String getValue(){
    return dropdownValue;
  }

void main() {
  runApp(const MaterialApp(
    title: 'To Do List',
    home: ToDoList(),
  ));
}
