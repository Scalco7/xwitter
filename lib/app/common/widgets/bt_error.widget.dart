import 'package:flutter/material.dart';

class BTErrorWidget extends StatelessWidget {
  const BTErrorWidget({super.key, required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(error),
      ),
    );
  }
}
