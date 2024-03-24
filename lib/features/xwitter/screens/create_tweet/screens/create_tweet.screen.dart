import 'package:flutter/material.dart';

class CreateTweetScreen extends StatelessWidget {
  const CreateTweetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text("Create Tweet Page"),
      ),
    );
  }
}
