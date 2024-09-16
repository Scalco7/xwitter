import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';

class VideoPlayerFileWidget extends StatefulWidget {
  const VideoPlayerFileWidget({super.key, required this.videoFile});
  final File videoFile;

  @override
  State<VideoPlayerFileWidget> createState() => _VideoPlayerFileWidgetState();
}

class _VideoPlayerFileWidgetState extends State<VideoPlayerFileWidget> {
  FlickManager? flickManager;

  @override
  void initState() {
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.file(widget.videoFile),
    );
    super.initState();
  }

  @override
  void dispose() {
    flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlickVideoPlayer(
      flickVideoWithControls: FlickVideoWithControls(
        videoFit: BoxFit.contain,
        controls: FlickPortraitControls(
          progressBarSettings:
              FlickProgressBarSettings(playedColor: ColorConsts.primaryColor),
        ),
      ),
      flickManager: flickManager!,
    );
  }
}
