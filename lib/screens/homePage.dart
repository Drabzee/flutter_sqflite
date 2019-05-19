import 'package:flutter/material.dart';
import '../utils/db_client.dart';
import '../models/todo_model.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DatabaseHelper dbInstance = DatabaseHelper();
  List todos = [];
  
  Future<void> fetchTodoList() async {
    todos = await dbInstance.getAllTodos();
  }

  Future<void> addMyTodo(String todo) async {
    await dbInstance.saveTodo(Todo(todo, DateFormat("EEEE, MMMM d, y", "en_US").add_jm().format(DateTime.now())));
  }

  Future<void> deleteMyTodo(int id) async {
    await dbInstance.deleteTodo(id);
  }

  Future<void> updateMyTodo(String todo, int id) async {
    await dbInstance.updateTodo(todo, id);
  }

  void myAlertDialog(BuildContext context, [Todo currentTodo]) {

    var controller = TextEditingController();
    controller.text = currentTodo != null?currentTodo.item:"";
    
    var alertDialog = AlertDialog(
      content: Row(
        children: <Widget>[
          Icon(Icons.note_add, color: Colors.blueAccent,),
          SizedBox(width: 10.0),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Item',
                hintText: 'Todo...'
              ),
            )
          ),
        ],
      ),
      actions: <Widget>[
        currentTodo == null
        ?FlatButton(
          child:Text('Add'),
          onPressed: () {
            setState(() {
              addMyTodo(controller.text);
              Navigator.pop(context);
            });
          },
        )
        :FlatButton(
          child:Text('Update'),
          onPressed: () {
            setState(() {
              updateMyTodo(controller.text, currentTodo.id);
              Navigator.pop(context);
            });
          },
        ),
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => alertDialog
    );
  }

  Widget getHomePageView() {
    return FutureBuilder(
      future: fetchTodoList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(todos.length == 0) {
          return Center(
            child: Text('No Todo Available', style: TextStyle(color: Colors.white54)),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int pos) {
            return Card(
              color: Color(0xFF303030),
              child: ListTile(
                title: Text(todos[pos].item, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)),
                subtitle: Text(todos[pos].date, style: TextStyle(color: Colors.white54, fontSize: 15.0)),
                trailing: GestureDetector(
                  child: Icon(Icons.delete, color: Colors.redAccent),
                  onTap: () {
                    setState(() {
                      deleteMyTodo(todos[pos].id);
                    });
                  },
                ),
                onLongPress: () {
                  setState(() {
                    myAlertDialog(context, todos[pos]);
                  });
                },
              )
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF212121),
      appBar: AppBar(
        backgroundColor: Color(0xFF535353),
        title: Text('Todo App'),
        centerTitle: true,
      ),
      body: getHomePageView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.add),
        onPressed: () {
          myAlertDialog(context);
        },
      ),
    );
  }
}