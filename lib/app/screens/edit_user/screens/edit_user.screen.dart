import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/controllers/route.controller.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/common/helpers/file_to_base64.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/widgets/bottom_navigation_bar.widget.dart';
import 'package:xwitter/app/common/widgets/primary_button.widget.dart';
import 'package:xwitter/app/common/widgets/profile_photo.widget.dart';
import 'package:xwitter/app/common/widgets/user_app_bar.widget.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key});

  @override
  State<StatefulWidget> createState() => _EditUserScreen();
}

class _EditUserScreen extends State<EditUserScreen> {
  static final RouteController routeController = RouteController();
  static final IUserController userController = UserController();
  static const double headerHeight = 80;
  static const double perfilPhotoSize = 130;

  late UserModel user;
  late bool savingLoading;
  late TextEditingController nameController;
  late TextEditingController bioController;
  late String? editingPhotoUrl;
  late File? perfilPhotoFile;

  void onSave() async {
    setSavingLoading(true);

    String name = nameController.text;
    String bio = bioController.text;

    String? photoBase64 = perfilPhotoFile != null
        ? await fileToBase64(perfilPhotoFile!, "image/png")
        : editingPhotoUrl == null
            ? ""
            : null;

    bool success = await userController.editUser(
      user: user,
      name: name,
      bio: bio,
      photoBase64: photoBase64,
    );

    if (success) {
      updateUserScreen();
    }

    setSavingLoading(false);
  }

  void updateUserScreen() {
    routeController.goToUserScreenAndReload(
      context,
      userController.loggedUser!,
    );
  }

  void setSavingLoading(bool value) {
    setState(() {
      savingLoading = value;
    });
  }

  void handleRemovePhoto() {
    setState(() {
      perfilPhotoFile = null;
      editingPhotoUrl = null;
    });
  }

  void selectImageFromGallery() async {
    XFile? returnedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedFile == null) return;

    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: returnedFile.path,
        compressFormat: ImageCompressFormat.png,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cortar',
            toolbarColor: ColorConsts.primaryColor,
            toolbarWidgetColor: Colors.white,
            cropStyle: CropStyle.circle,
            lockAspectRatio: true,
            showCropGrid: true,
            hideBottomControls: true,
            initAspectRatio: CropAspectRatioPreset.square,
            aspectRatioPresets: [CropAspectRatioPreset.square],
          ),
          IOSUiSettings(
            //testar IOS ###
            title: 'Cortar',
            cropStyle: CropStyle.circle,
            aspectRatioPickerButtonHidden: true,
            resetAspectRatioEnabled: false,
            aspectRatioPresets: [CropAspectRatioPreset.square],
          ),
        ]);

    if (croppedFile == null) return;

    setState(() {
      perfilPhotoFile = File(croppedFile.path);
    });
  }

  @override
  void initState() {
    user = userController.loggedUser!;
    savingLoading = false;
    editingPhotoUrl = user.photoUrl;
    perfilPhotoFile = null;
    nameController = TextEditingController(text: user.name);
    bioController = TextEditingController(text: user.bio);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    const InputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(
        color: Colors.black,
        width: 1,
      ),
    );

    void disableKeyboard() {
      FocusScope.of(context).requestFocus(FocusNode());
    }

    return Scaffold(
      appBar: UserAppBarWidget(
        height: headerHeight,
        text: "@${user.username}",
        showActions: false,
      ),
      body: SizedBox(
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  perfilPhotoFile != null
                      ? ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          child: Image.file(
                            perfilPhotoFile!,
                            width: perfilPhotoSize,
                            height: perfilPhotoSize,
                            fit: BoxFit.fill,
                          ),
                        )
                      : ProfilePhotoWidget(
                          photoUrl: editingPhotoUrl,
                          size: perfilPhotoSize,
                        ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      PrimaryButtonWidget(
                        text: "Remover",
                        onPressed: handleRemovePhoto,
                      ),
                      const SizedBox(height: 5),
                      PrimaryButtonWidget(
                        text: "Selecionar nova foto",
                        onPressed: selectImageFromGallery,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(5),
                    child: Text("Nome: "),
                  ),
                  SizedBox(
                    height: 55,
                    child: TextField(
                      onTapOutside: (event) => disableKeyboard(),
                      controller: nameController,
                      maxLines: 1,
                      maxLength: 30,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        disabledBorder: inputBorder,
                        border: inputBorder,
                        errorBorder: inputBorder,
                        enabledBorder: inputBorder,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(5),
                    child: Text("Bio: "),
                  ),
                  SizedBox(
                    height: 200,
                    child: TextField(
                      onTapOutside: (event) => disableKeyboard(),
                      controller: bioController,
                      maxLines: 4,
                      maxLength: 100,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        disabledBorder: inputBorder,
                        border: inputBorder,
                        errorBorder: inputBorder,
                        enabledBorder: inputBorder,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  PrimaryButtonWidget(
                    isLoading: savingLoading,
                    text: "Save",
                    onPressed: onSave,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(currentIndex: 2),
    );
  }
}
