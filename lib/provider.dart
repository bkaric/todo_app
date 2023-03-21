import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_graphql/models/Todo.dart';

class ProfileProvider with ChangeNotifier {
  XFile? profile_picture;
  Image? webProfile;
  Todo? user;

  XFile? get profilna => profile_picture;
  Image? get webProfilna => webProfile;

  void changeProfilePicture(XFile slika) {
    profile_picture = slika;
    notifyListeners();
  }

  void changeWebProfilePicture(Image slika) {
    webProfile = slika;
    notifyListeners();
  }

  Future<Todo?> queryItem(String id) async {
    try {
      final request = ModelQueries.get(Todo.classType, id);
      safePrint(request);
      final response = await Amplify.API.query(request: request).response;
      final todo = response.data;
      if (todo == null) {
        print('errors: ${response.errors}');
      }
      safePrint(todo!.name);
      safePrint(todo);
      user = todo;
      return todo;
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
      return null;
    }
  }
}
