// import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Todo app',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class Todo {
  int id;
  String todo;
  bool isCompleted;

  Todo({
    required this.id,
    required this.todo,
    required this.isCompleted,
  });
}

class TodoManager {
  // Method to create a new todo
  Todo createTodo(int id, String todoText) {
    Todo newTodo = Todo(
      id: id,
      todo: todoText,
      isCompleted: false,
    );
    return newTodo;
  }
}

class MyAppState extends ChangeNotifier {
  var todos = <Todo>[];
  var todoManager = TodoManager();
  var completedTodos = <Todo>[];

  void addTodo(String inputString) {
    int newId;
    todos.isEmpty ? newId = 0 : newId = todos.length;
    Todo newTodo = todoManager.createTodo(newId, inputString);
    todos.add(newTodo);
    print("input string ${todos.length}");
    notifyListeners();
  }

  void deleteTodoFromList(List<Todo> todos, Todo todo) {
    todos.remove(todo);
    notifyListeners();
  }

  void addCompletedTodos(Todo todo) {
    completedTodos.add(todo);
    todos.remove(todo);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<MyAppState>();
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = TodosPage();

      case 1:
        page = CompletedPage();

      default:
        throw UnimplementedError('no widget for selected Index');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Avishek todos app"),
        ),
        body: Center(child: page),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Todos'),
            BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Completed')
          ],
          currentIndex: selectedIndex,
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
        ),
      );
    });
  }
}

class TodosPage extends StatefulWidget {
  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(5.0),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: 'Enter new todo',
                  ),
                  controller: myController,
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              SizedBox(
                height: 48,
                child: FilledButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onPressed: () {
                    appState.addTodo(myController.text);
                    myController.text = '';
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
                child: Text('You have ${appState.todos.length} todos',
                    style: TextStyle(color: Colors.lightBlue, fontSize: 15)),
              ),
              for (var todo in appState.todos)
                Dismissible(
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(5.0),
                    child: Icon(Icons.done, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.all(5.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.horizontal,
                  key: Key(todo.id.toString()),
                  onDismissed: (direction) => {
                    if (direction == DismissDirection.startToEnd)
                      {appState.addCompletedTodos(todo)}
                    else if (direction == DismissDirection.endToStart)
                      {appState.deleteTodoFromList(appState.todos, todo)}
                  },
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border(bottom: BorderSide())),
                    child: ListTile(
                      title: Text(todo.todo,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}

class CompletedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return ListView(
      children: [
        Container(
          decoration: BoxDecoration(border: Border(bottom: BorderSide())),
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
          child: Text(
              'You have ${appState.completedTodos.length} completed todos',
              style: TextStyle(color: Colors.lightBlue, fontSize: 15)),
        ),
        for (var todo in appState.completedTodos)
          Dismissible(
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(5.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(5.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.horizontal,
            key: Key(todo.id.toString()),
            onDismissed: (direction) => {
              {appState.deleteTodoFromList(appState.completedTodos, todo)}
            },
            child: Container(
              decoration: BoxDecoration(border: Border(bottom: BorderSide())),
              child: ListTile(
                title: Text(todo.todo,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              ),
            ),
          )
      ],
    );
  }
}
