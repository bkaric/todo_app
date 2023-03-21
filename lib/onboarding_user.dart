import 'dart:io';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_graphql/models/Todo.dart';
import 'package:todo_graphql/user_profile.dart';
import 'package:todo_graphql/provider.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class UserOnboarding extends StatefulWidget {
  static const routeName = 'user-onboarding';
  const UserOnboarding({super.key});

  @override
  State<UserOnboarding> createState() => _UserOnboardingState();
}

class _UserOnboardingState extends State<UserOnboarding> {
  // late XFile profile_picture;

  String generateRandomString(int length) {
    var random = Random();
    var codeUnits = List.generate(
      length,
      (index) => random.nextInt(26) + 97,
    );

    return String.fromCharCodes(codeUnits);
  }

  Future<void> createTodo(String idUsera, String ime, String prezime) async {
    try {
      final todo = Todo(id: idUsera, name: ime, description: prezime);
      safePrint(todo);

      final request = ModelMutations.create(todo);
      safePrint(request);
      final response = await Amplify.API.mutate(request: request).response;

      final createdTodo = response.data;
      safePrint(request);
      if (createdTodo == null) {
        safePrint('errors: ${response.errors}');
        return;
      }
      safePrint('Mutation result: ${createdTodo.name}');
    } on ApiException catch (e) {
      safePrint('Mutation failed: $e');
    }
  }

  Future<void> _selectAndPickImage() async {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      provider.changeProfilePicture(pickedFile);
    }
  }

  Future<void> _captureAndPickImage() async {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      provider.changeProfilePicture(pickedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController ime = TextEditingController();
    TextEditingController prezime = TextEditingController();
    String idUsera = generateRandomString(10);
    final key1 = GlobalKey<FormState>();
    final key2 = GlobalKey<FormState>();
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Onboarding'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Form(
                    key: key1,
                    child: TextFormField(
                      key: const Key('test1'),
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
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Form(
                    key: key2,
                    child: TextFormField(
                      key: const Key('test2'),
                      controller: prezime,
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Consumer<ProfileProvider>(
                  builder: ((context, value, child) {
                    return CircleAvatar(
                      radius: 60,
                      backgroundImage: value.profilna != null
                          ? FileImage(File(value.profilna!.path))
                          : const AssetImage('assets/images/blank.png')
                              as ImageProvider<Object>,
                    );
                  }),
                ),
                ElevatedButton(
                  onPressed: () {
                    _selectAndPickImage();
                  },
                  child: const Text('Change profile picture from phone'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _captureAndPickImage();
                  },
                  child: const Text('Change profile picture from camera'),
                ),
                ElevatedButton(
                  key: const Key('create'),
                  onPressed: () async {
                    if (key1.currentState!.validate() &&
                        key2.currentState!.validate()) {
                      await createTodo(idUsera, ime.text, prezime.text);
                      await provider.queryItem(idUsera);
                      Navigator.pushNamed(context, UserProfile.routeName);
                    }
                  },
                  child: const Text('Create user'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
