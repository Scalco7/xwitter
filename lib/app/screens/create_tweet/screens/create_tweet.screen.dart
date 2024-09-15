import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/controllers/tweet.controller.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/common/helpers/file_to_base64.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/widgets/profile_photo.widget.dart';
import 'package:xwitter/app/screens/create_tweet/widgets/tweet_button.widget.dart';

class CreateTweetScreen extends StatefulWidget {
  const CreateTweetScreen({
    super.key,
    required this.routePop,
    required this.goToHomeScreen,
    required this.goToSearchLocationScreen,
  });

  final void Function() routePop;
  final void Function() goToHomeScreen;
  final void Function(
    void Function(String? location) setLocation,
  ) goToSearchLocationScreen;

  @override
  State<StatefulWidget> createState() => _CreateTweetScreen();
}

class _CreateTweetScreen extends State<CreateTweetScreen> {
  final UserModel loggedUser = UserController().loggedUser!;

  ITweetController tweetController = TweetController();
  TextEditingController tweetTextController = TextEditingController();
  late bool disabledTweetButton;
  String? tweetLocation;
  bool canRetweet = true;
  File? tweetFile;

  void publishTweet() async {
    String? mediaBase64 =
        tweetFile != null ? await fileToBase64(tweetFile!, 'image/png') : null;

    tweetController.publishTweet(
      text: tweetTextController.text,
      canRetweet: canRetweet,
      location: tweetLocation,
      mediaBase64: mediaBase64,
    );

    widget.goToHomeScreen();
  }

  void disabledButton() {
    setState(() {
      disabledTweetButton = tweetTextController.text.isEmpty;
    });
  }

  void setCanRetweet(bool value) {
    setState(() {
      canRetweet = value;
    });
  }

  void setTweetLocation(String? location) {
    setState(() {
      tweetLocation = location;
    });
  }

  void removeTweetFile() {
    setState(() {
      tweetFile = null;
    });
  }

  void selectImageFromGallery() async {
    XFile? returnedFile = await ImagePicker().pickMedia();

    if (returnedFile == null) return;

    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: returnedFile.path,
        compressFormat: ImageCompressFormat.png,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cortar',
            toolbarColor: ColorConsts.primaryColor,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: ColorConsts.primaryColor,
            cropStyle: CropStyle.rectangle,
            lockAspectRatio: true,
            showCropGrid: true,
            hideBottomControls: false,
            initAspectRatio: CropAspectRatioPreset.ratio4x3,
            aspectRatioPresets: [CropAspectRatioPreset.ratio4x3],
          ),
          IOSUiSettings(
            //testar IOS ###
            title: 'Cortar',
            cropStyle: CropStyle.rectangle,
            aspectRatioPickerButtonHidden: true,
            resetAspectRatioEnabled: false,
            aspectRatioPresets: [CropAspectRatioPreset.ratio4x3],
          ),
        ]);

    if (croppedFile == null) return;

    setState(() {
      tweetFile = File(croppedFile.path);
    });
  }

  void handleImageButtonClicked() {
    if (tweetFile == null) {
      selectImageFromGallery();
    } else {
      removeTweetFile();
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    tweetTextController.text = "";
    disabledTweetButton = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: widget.routePop,
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(
                            color: ColorConsts.primaryColor, fontSize: 17),
                      ),
                    ),
                    TweetButtonWidget(
                      disabled: disabledTweetButton,
                      onPressButton: publishTweet,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => setCanRetweet(!canRetweet),
                      child: const Row(
                        children: <Widget>[
                          Icon(
                            Icons.repeat,
                            color: ColorConsts.primaryColor,
                            size: 30,
                          ),
                          SizedBox(width: 7),
                          Text(
                            "Pode retweetar",
                            style: TextStyle(
                              fontSize: 18,
                              color: ColorConsts.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 35,
                      height: 35,
                      child: Switch(
                        activeColor: ColorConsts.primaryColor,
                        value: canRetweet,
                        onChanged: (bool value) => setCanRetweet(value),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GestureDetector(
                  onTap: () =>
                      widget.goToSearchLocationScreen(setTweetLocation),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.location_on_rounded,
                            color: ColorConsts.primaryColor,
                            size: 30,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            tweetLocation ?? "Adiconar localização",
                            style: TextStyle(
                              fontSize: 18,
                              color: tweetLocation != null
                                  ? Colors.black
                                  : ColorConsts.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => tweetLocation != null
                            ? setTweetLocation(null)
                            : widget.goToSearchLocationScreen(setTweetLocation),
                        child: Icon(
                          tweetLocation != null
                              ? Icons.close
                              : Icons.chevron_right_outlined,
                          color: ColorConsts.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: tweetTextController,
                  onChanged: (value) => disabledButton(),
                  decoration: InputDecoration(
                    icon: ProfilePhotoWidget(
                      photoUrl: loggedUser.photoUrl,
                      size: 35,
                    ),
                    border: InputBorder.none,
                    hintText: "Eu queria...",
                  ),
                  maxLines: null,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLength: 280,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: <Widget>[
                    if (tweetFile != null)
                      Image.file(
                        tweetFile!,
                        height: 350,
                        fit: BoxFit.contain,
                      ),
                    TextButton(
                      onPressed: handleImageButtonClicked,
                      child: Text(
                        tweetFile == null
                            ? "Adicionar foto/vídeo"
                            : "Remover foto/vídeo",
                        style: const TextStyle(
                          fontSize: 16,
                          color: ColorConsts.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
