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
import 'package:xwitter/app/common/models/mention_user.model.dart';
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
  static final ITweetController tweetController = TweetController();
  static final IUserController userController = UserController();
  final UserModel loggedUser = UserController().loggedUser!;

  TextEditingController tweetTextController = TextEditingController();
  FocusNode tweetTextFocus = FocusNode();
  late bool disabledTweetButton;
  String? tweetLocation;
  bool canRetweet = true;
  File? tweetFile;
  bool tweetFileIsImg = false;

  String lastTweetText = "";
  bool isMention = false;
  List<String> mentionsNames = [];
  TextStyle tweetTextStyle = const TextStyle(fontSize: 16);

  void goToHomeScreen() {
    routeController.goToHomeScreen(context);
  }

  void publishTweet() async {
    String tweetText = formatTweetTextForPublish(tweetTextController.text);
    String? mediaBase64 = tweetFile != null
        ? await fileToBase64(
            tweetFile!, tweetFileIsImg ? 'image/png' : 'video/mp4')
        : null;

    tweetController.publishTweet(
      text: tweetText,
      canRetweet: canRetweet,
      location: tweetLocation,
      mediaBase64: mediaBase64,
    );

    goToHomeScreen();
  }

  String formatTweetTextForPublish(String text) {
    for (String mentionName in mentionsNames) {
      text = text.replaceFirst("@$mentionName", "@:$mentionName");
    }

    return text;
  }

  void handleOnChangedTweetText(String value) {
    if ((disabledTweetButton && tweetTextController.text.isNotEmpty) ||
        (!disabledTweetButton && tweetTextController.text.isEmpty)) {
      disabledButton();
    }

    if (value.endsWith("@")) {
      isMention = true;
    } else if (isMention) {
      if (value.endsWith(" ")) {
        isMention = false;
      } else if (value.length < lastTweetText.length &&
          lastTweetText.endsWith('@') &&
          !value.endsWith('@')) {
        isMention = false;
      } else if (value.length >= lastTweetText.length) {
        String searchName = value.substring(value.lastIndexOf('@') + 1);
        searchMentions(searchName);
      }
    }

    lastTweetText = value;
  }

  void searchMentions(String searchName) async {
    List<MentionUserModel> mentions =
        await userController.searchMentionsUsers(prefix: searchName);

    showContextMentionsMenu(mentions);
  }

  void showContextMentionsMenu(List<MentionUserModel> mentions) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    TextPainter painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        style: tweetTextStyle,
        text: tweetTextController.text
            .substring(0, tweetTextController.text.lastIndexOf("@") + 1),
      ),
    );
    painter.layout();

    print(tweetTextController.text
        .substring(0, tweetTextController.text.lastIndexOf("@") + 1));

    double top = tweetTextFocus.offset.dy + painter.height + 3;
    double left = tweetTextFocus.offset.dx + painter.width + 10;

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(left, top, 10, 10),
        Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
            overlay.paintBounds.size.height),
      ),
      items: mentions
          .map(
            (mention) => PopupMenuItem(
              value: 'Fix',
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              height: 40,
              onTap: () => selectMention(mention),
              child: Row(
                children: <Widget>[
                  ProfilePhotoWidget(photoUrl: mention.photoUrl, size: 30),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    mention.username,
                    style: const TextStyle(
                      color: ColorConsts.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  void selectMention(MentionUserModel mention) {
    String beforeText = tweetTextController.text
        .substring(0, tweetTextController.text.lastIndexOf("@") + 1);
    tweetTextController.text = beforeText + mention.username;

    mentionsNames.add(mention.username);
    FocusScope.of(context).requestFocus(tweetTextFocus);
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

  void disableKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
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
      resizeToAvoidBottomInset: false,
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
                  focusNode: tweetTextFocus,
                  controller: tweetTextController,
                  onTapOutside: (event) => disableKeyboard(),
                  onChanged: handleOnChangedTweetText,
                  style: tweetTextStyle,
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
