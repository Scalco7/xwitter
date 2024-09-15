import 'dart:convert';
import 'dart:io';

Future<String> fileToBase64(File file) async {
  final bytes = await file.readAsBytes();
  String img64 = base64Encode(bytes);
  return img64;
}
