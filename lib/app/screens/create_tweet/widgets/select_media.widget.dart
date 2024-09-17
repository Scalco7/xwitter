import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';
import 'package:xwitter/app/screens/create_tweet/widgets/video_player_file.widget.dart';

class SelectMediaWidget extends StatelessWidget {
  const SelectMediaWidget({
    super.key,
    this.tweetFile,
    required this.tweetFileIsImg,
    required this.handleImageButtonClicked,
  });

  final File? tweetFile;
  final bool tweetFileIsImg;
  final void Function() handleImageButtonClicked;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (tweetFile != null)
          tweetFileIsImg
              ? Image.file(
                  tweetFile!,
                  width: 450,
                  height: 290,
                  fit: BoxFit.contain,
                )
              : SizedBox(
                  width: 450,
                  height: 290,
                  child: VideoPlayerFileWidget(videoFile: tweetFile!),
                ),
        TextButton(
          onPressed: handleImageButtonClicked,
          child: Text(
            tweetFile == null ? "Adicionar foto/vídeo" : "Remover foto/vídeo",
            style: const TextStyle(
              fontSize: 16,
              color: ColorConsts.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
