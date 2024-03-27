import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';

class EditUserButtonWidget extends StatelessWidget {
  const EditUserButtonWidget({super.key, required this.editUser});
  final Function() editUser;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => editUser(),
      style: ButtonStyle(
        elevation: const MaterialStatePropertyAll<double>(0),
        backgroundColor: const MaterialStatePropertyAll(Colors.white),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
              side: const BorderSide(
                width: 2,
                color: ColorConsts.primaryColor,
              ),
              borderRadius: BorderRadius.circular(20)),
        ),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        ),
      ),
      child: const Text(
        "Editar",
        style: TextStyle(
          fontSize: 14,
          color: ColorConsts.primaryColor,
        ),
      ),
    );
  }
}
