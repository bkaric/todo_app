import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_graphql/provider.dart';

class UserProfile extends StatefulWidget {
  static const routeName = 'user-profile';
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 70,
              ),
              if (provider.profilna == null) ...[
                const Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/images/blank.png'),
                  ),
                ),
              ] else ...[
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: FileImage(File(provider.profilna!.path)),
                  ),
                ),
              ],
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  '${provider.user!.name} ${provider.user!.description}',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
