import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class Todos{
  String todoTitle;
  String todoContent;
  List<Todos> allTodos = [];
  final storage = new FlutterSecureStorage();
  Todos( this.todoTitle, this.todoContent);

   registerTodo(Todos todo) async {
    // Enregistrer le todo
    await storage.write(key: todo.todoTitle, value: todo.todoContent);
  }

  Future<List<Todos>> displayTodos() async {
    final allTodos = await storage.readAll();
    var todosList = allTodos.entries
        .map((todo) => Todos(todo.key, todo.value))
        .toList(growable: false);
    return todosList;
  }

}