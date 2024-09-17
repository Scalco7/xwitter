import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/common/controllers/route.controller.dart';
import 'package:xwitter/app/common/controllers/tweet.controller.dart';
import 'package:xwitter/app/common/controllers/user.controller.dart';
import 'package:xwitter/app/common/helpers/file_to_base64.dart';
import 'package:xwitter/app/common/models/user.model.dart';
import 'package:xwitter/app/common/widgets/profile_photo.widget.dart';
import 'package:xwitter/app/screens/create_tweet/widgets/can_retweet.widget.dart';
import 'package:xwitter/app/screens/create_tweet/widgets/choose_location.widget.dart';
import 'package:xwitter/app/screens/create_tweet/widgets/header.widget.dart';
import 'package:mime/mime.dart';
import 'package:xwitter/app/screens/create_tweet/widgets/select_media.widget.dart';

class CreateTweetScreen extends StatefulWidget {
  const CreateTweetScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CreateTweetScreen();
}

class _CreateTweetScreen extends State<CreateTweetScreen> {
  static final RouteController routeController = RouteController();
  final UserModel loggedUser = UserController().loggedUser!;

  ITweetController tweetController = TweetController();
  TextEditingController tweetTextController = TextEditingController();
  late bool disabledTweetButton;
  String? tweetLocation;
  bool canRetweet = true;
  File? tweetFile;
  bool tweetFileIsImg = false;

  void goToHomeScreen() {
    routeController.goToHomeScreen(context);
  }

  void publishTweet() async {
    String? mediaBase64 = tweetFile != null
        ? await fileToBase64(
            tweetFile!, tweetFileIsImg ? 'image/png' : 'video/mp4')
        : null;

    tweetController.publishTweet(
      text: tweetTextController.text,
      canRetweet: canRetweet,
      location: tweetLocation,
      mediaBase64: mediaBase64,
    );

    goToHomeScreen();
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

    File? newTweetFile;

    final String? mime = lookupMimeType(returnedFile.path);
    tweetFileIsImg = mime == null || mime.startsWith('image');

    if (tweetFileIsImg) {
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
              initAspectRatio: CropAspectRatioPreset.ratio5x3,
              aspectRatioPresets: [CropAspectRatioPreset.ratio5x3],
            ),
            IOSUiSettings(
              //testar IOS ###
              title: 'Cortar',
              cropStyle: CropStyle.rectangle,
              aspectRatioPickerButtonHidden: true,
              resetAspectRatioEnabled: false,
              aspectRatioPresets: [CropAspectRatioPreset.ratio5x3],
            ),
          ]);

      if (croppedFile == null) return;
      newTweetFile = File(croppedFile.path);
    } else {
      newTweetFile = File(returnedFile.path);
    }

    setState(() {
      tweetFile = newTweetFile;
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
                child: HeaderWidget(
                  publishTweet: publishTweet,
                  disabledTweetButton: disabledTweetButton,
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CanRetweetWidget(
                  canRetweet: canRetweet,
                  setCanRetweet: setCanRetweet,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ChooseLocationWidget(
                  setTweetLocation: setTweetLocation,
                  tweetLocation: tweetLocation,
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
                child: SelectMediaWidget(
                  tweetFile: tweetFile,
                  tweetFileIsImg: tweetFileIsImg,
                  handleImageButtonClicked: handleImageButtonClicked,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
