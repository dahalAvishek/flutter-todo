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
    notifyListeners();
  }

  void deleteTodoFromList(List<Todo> todos, Todo todo) {
    todos.remove(todo);
  }

  void addCompletedTodos(int index) {
    var completedTodo = todos.elementAt(index);
    completedTodos.add(completedTodo);
    todos.remove(completedTodo);
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
    var appState = context.watch<MyAppState>();
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

class TodosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter new todo',
          ),
        ),
        // ListView(
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.all(20),
        //       child: Text('You have ${appState.todos.length} todos'),
        //     ),
        //     for (var todo in appState.todos)
        //       Row(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           ElevatedButton.icon(
        //             onPressed: () {
        //               appState.deleteTodoFromList(appState.todos, todo);
        //             },
        //             icon: Icon(Icons.done),
        //             label: Text(todo.todo),
        //           ),
        //         ],
        //       )
        //   ],
        // ),
      ],
    );
  }
}

class CompletedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Completed Page"),
    );
  }
}
