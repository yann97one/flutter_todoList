import 'package:flutter/material.dart';
import 'package:todo_list_flutter/Todo.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:   MyHomePage(),
    );
  }
}


class MyHomePage extends StatelessWidget {
   MyHomePage({Key? key}) : super(key: key);
  List<Todos> todosList = [];

  @override
  Widget build(BuildContext context) {
    final Todos todos = Todos('', '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar Demo'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Liste de vos Todo',
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: 200,
            height: 100,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Colors.black,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => toDoList()),
                );
              },
              child: const Icon(
                Icons.add,
                size: 40,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Todos>>(
              future: todos.displayTodos(),
              builder: (BuildContext context, AsyncSnapshot<List<Todos>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }  else if(snapshot.hasData){
                          todosList = snapshot.data!;
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Une erreur s\'est produite.'));

                } else {
                  return ListView.builder(
                    itemCount: todosList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Todos todo = todosList[index];
                      return ListTile(

                        title: Text(todo.todoTitle),
                        subtitle: Text(todo.todoContent),

                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


class toDoList extends StatefulWidget {
  const toDoList({super.key});

  @override
  _toDoListState createState() => _toDoListState();

}

class _toDoListState extends State<toDoList>{
  final _formKey = GlobalKey<FormState>();
  late String todoTitle;
  late String todoContent;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
         title: const Text( 'Ajouter un todo')
      ),

      body:
     Form(
       key: _formKey,
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           TextFormField(
             onSaved: (String? title){todoTitle = title!;},
             decoration: const InputDecoration(
               hintText: 'Titre de votre Todo',
             ),
             validator: (String? value) {
               if (value == null || value.isEmpty) {
                 return 'Please enter some text';
               }
               return null;
             },
           ),

           TextFormField(
             onSaved: (String? content){todoContent = content!;},
             decoration: const InputDecoration(
               hintText: 'Contenu de votre todo',
             ),
             validator: (String? value) {
               if (value == null || value.isEmpty) {
                 return 'Please enter some text';
               }
               return null;
             },
           ),
           Padding(
             padding: const EdgeInsets.symmetric(vertical: 16.0),
             child: ElevatedButton(
               onPressed: () async {
                if(_formKey.currentState!.validate()){
                  _formKey.currentState!.save();

                  final Todos todo = Todos(todoTitle,todoContent);
                  todo.registerTodo(todo);

                  // Afficher tous les todos dans la console


                  // Réinitialiser le formulaire
                  _formKey.currentState!.reset();


                }

               },
               child: const Text('Submit'),
             ),
           ),
         ],
       )
     )
    );
  }


}

