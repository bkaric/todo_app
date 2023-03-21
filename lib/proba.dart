import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:todo_graphql/models/Todo.dart';

class Proba extends StatefulWidget {
  const Proba({super.key});

  @override
  State<Proba> createState() => _ProbaState();
}

class _ProbaState extends State<Proba> {
  Future<void> createTodo(Todo klasa) async {
    try {
      //final todo =   Todo(id: s, name: 'Kenan Selman', description: 'poslo sam ti ga');
      final todo = klasa;
      final request = ModelMutations.create(todo);
      final response = await Amplify.API.mutate(request: request).response;

      final createdTodo = response.data;
      if (createdTodo == null) {
        safePrint('errors: ${response.errors}');
        return;
      }
      safePrint('Mutation result: ${createdTodo.name}');
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }

  Future<Todo?> queryItem(Todo queriedTodo) async {
    try {
      final request = ModelQueries.get(Todo.classType, queriedTodo.id);
      final response = await Amplify.API.query(request: request).response;
      final todo = response.data;
      if (todo == null) {
        print('errors: ${response.errors}');
      }
      safePrint(todo!.name);
      return todo;
    } on ApiException catch (e) {
      print('Query failed: $e');
      return null;
    }
  }

  Future<void> updateTodo(Todo originalTodo, String str) async {
    final todoWithNewName = originalTodo.copyWith(name: str);

    final request = ModelMutations.update(todoWithNewName);
    final response = await Amplify.API.mutate(request: request).response;
    print('Response: $response');
  }

  Future<void> deleteTodo(Todo todoToDelete) async {
    final request = ModelMutations.delete(todoToDelete);
    final response = await Amplify.API.mutate(request: request).response;
    print('Response: $response');
  }

  // Future<Todo> getTodoById(String id) async {
  //   final request = ModelQueries.get(Todo.classType, id);
  //   final response = await Amplify.API.query(request: request).response;
  //   final todo = jsonDecode(response);

  //   return Todo.fromJson(response.data);
  // }

  Future<void> updateUserName(String id, String newName) async {
    try {
      final currentTodo = ModelQueries.get(Todo.classType, id);
      final response1 = await Amplify.API.query(request: currentTodo).response;
      final todo = response1.data;
      final todoToUpdate =
          Todo(id: id, name: newName, description: todo!.description);

      final request = ModelMutations.update(todoToUpdate);
      final response = await Amplify.API.mutate(request: request).response;
      final updatedTodo = response.data;
      if (updatedTodo == null) {
        print('Error updating user with ID $id');
        return;
      }
      print('User with ID $id updated successfully');
    } catch (e) {
      print('Error updating user with ID $id: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String str = 'ovo-je-kenanov-id-999112ddoop';
    Todo primjer = Todo(name: 'KenanNovo', description: 'hljebovi');
    TextEditingController ime = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Primjeri')),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  createTodo(primjer);
                },
                child: const Text('Pošalji'),
              ),
              ElevatedButton(
                onPressed: () {
                  queryItem(primjer);
                },
                child: const Text('Vrati'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextFormField(
                  controller: ime,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  updateTodo(primjer, ime.text);
                },
                child: const Text('Upadate'),
              ),
              ElevatedButton(
                onPressed: () {
                  //upadateTodoById();
                  updateUserName(primjer.id, 'Kralj Kenan');
                },
                child: const Text('Upadate by id'),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
