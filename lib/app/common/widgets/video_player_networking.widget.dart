import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:xwitter/app/common/consts/style.consts.dart';

class VideoPlayerNetworkingWidget extends StatefulWidget {
  const VideoPlayerNetworkingWidget({
    super.key,
    required this.videoUrl,
    required this.iconsSize,
    required this.loop,
  });
  final String videoUrl;
  final double iconsSize;
  final bool loop;

  @override
  State<VideoPlayerNetworkingWidget> createState() =>
      _VideoPlayerNetworkingWidgetState();
}

class _VideoPlayerNetworkingWidgetState
    extends State<VideoPlayerNetworkingWidget> {
  late FlickManager flickManager;

  @override
  void initState() {
    flickManager = FlickManager(
      videoPlayerController:
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
            ..setLooping(widget.loop),
    );
    super.initState();
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlickVideoPlayer(
      flickVideoWithControls: FlickVideoWithControls(
        videoFit: BoxFit.contain,
        controls: FlickPortraitControls(
          iconSize: widget.iconsSize,
          fontSize: 8,
          progressBarSettings:
              FlickProgressBarSettings(handleColor: ColorConsts.primaryColor),
        ),
        playerLoadingFallback: Positioned.fill(
          child: Stack(
            children: <Widget>[
              Container(),
              const Positioned(
                right: 10,
                top: 10,
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    strokeWidth: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      flickVideoWithControlsFullscreen: const FlickVideoWithControls(
        controls: FlickLandscapeControls(),
        iconThemeData: IconThemeData(
          size: 40,
          color: Colors.white,
        ),
        textStyle: TextStyle(fontSize: 16, color: Colors.white),
      ),
      flickManager: flickManager,
    );
  }
}
