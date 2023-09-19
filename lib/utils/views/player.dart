import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_x/utils/const/colors.dart';
import 'package:player_x/utils/controllers/player_controller.dart';

import 'package:player_x/utils/widgets/icon_widgets.dart';

// ignore: must_be_immutable
class PlayerScreen extends StatelessWidget {
  PlayerScreen({super.key, required this.data});
  final List<SongModel> data;
  var controller = Get.put(PlayerController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.setFirstOpenFalse();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: RichText(
            text: TextSpan(
                text: "Player",
                style: Theme.of(context).textTheme.titleLarge,
                children: const [
                  TextSpan(
                      text: 'X',
                      style: TextStyle(
                        color: secondaryColor,
                      ))
                ]),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.expand_more,
              size: 25,
            ),
            onPressed: () {
              controller.setFirstOpenFalse();
              Get.back();
            },
          ),
          actions: [
            ThemeToggleButton(), // Use the new widget
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              double dx = details.primaryVelocity!;
              if (dx < 0) {
                controller.playSong(data[controller.playIndex.value + 1].uri,
                    controller.playIndex.value + 1);
                controller
                    .textisLong(data[controller.playIndex.value + 1].title);
              } else if (dx > 0) {
                // ignore: unrelated_type_equality_checks
                if (controller.playIndex == 0) {
                  Get.back();
                } else {
                  controller.playSong(data[controller.playIndex.value - 1].uri,
                      controller.playIndex.value - 1);
                  controller
                      .textisLong(data[controller.playIndex.value - 1].title);
                }
              }
            },
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onVerticalDragUpdate: (DragUpdateDetails details) {
                      controller.setFirstOpenFalse();
                      Get.back();
                    },
                    child: Obx(
                      () => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorDark,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .shadow
                                      .withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: const Offset(2, 5),
                                )
                              ]),
                          height: 100,
                          width: 250,
                          alignment: Alignment.center,
                          child: QueryArtworkWidget(
                            id: data[controller.playIndex.value].id,
                            type: ArtworkType.AUDIO,
                            artworkQuality: FilterQuality.high,
                            artworkHeight: double.infinity,
                            artworkWidth: double.infinity,
                            artworkBorder: BorderRadius.zero,
                            nullArtworkWidget: const Icon(
                              Icons.music_note,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      child: Obx(
                        () => SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: SizedBox(
                                  width: 200,
                                  height: 50,
                                  child: controller.isLongText.value
                                      ? Marquee(
                                          text: data[controller.playIndex.value]
                                              .title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                          scrollAxis: Axis.horizontal,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          blankSpace: 20.0,
                                          velocity: 50.0,
                                          startPadding: 10,
                                          pauseAfterRound:
                                              const Duration(seconds: 1),
                                          fadingEdgeEndFraction: 0.1,
                                          fadingEdgeStartFraction: 0.1,
                                          accelerationDuration:
                                              const Duration(seconds: 1),
                                          accelerationCurve: Curves.linear,
                                          decelerationDuration:
                                              const Duration(milliseconds: 500),
                                          decelerationCurve: Curves.easeOut,
                                        )
                                      : Text(
                                          data[controller.playIndex.value]
                                              .title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                          textAlign: TextAlign.center,
                                        ),
                                ),
                              ),
                              Text(
                                data[controller.playIndex.value]
                                    .artist
                                    .toString(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Obx(
                                () => Row(
                                  children: [
                                    Text(
                                      controller.postion.value,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    Expanded(
                                      child: Slider(
                                          thumbColor: secondaryColor,
                                          activeColor: buttonColor,
                                          inactiveColor:
                                              Theme.of(context).focusColor,
                                          min: const Duration(seconds: 0)
                                              .inSeconds
                                              .toDouble(),
                                          max: controller.max.value,
                                          value: controller.value.value,
                                          onChanged: (newValue) {
                                            controller.changeDurationtoSec(
                                                newValue.toInt());
                                            newValue = newValue;
                                          }),
                                    ),
                                    Text(
                                      controller.duration.value,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        controller.audioPlayer.loopMode ==
                                                LoopMode.one
                                            ? controller.audioPlayer
                                                .setLoopMode(LoopMode.all)
                                            : controller.audioPlayer
                                                .setLoopMode(LoopMode.one);
                                      },
                                      child: Container(
                                        child: StreamBuilder<LoopMode>(
                                            stream: controller
                                                .audioPlayer.loopModeStream,
                                            builder: (context, snapshot) {
                                              final loopMode = snapshot.data;
                                              if (LoopMode.one == loopMode) {
                                                return const Icon(
                                                  Icons.repeat_one,
                                                  color: Colors.white70,
                                                );
                                              } else {
                                                return const Icon(
                                                  Icons.repeat,
                                                  color: Colors.white70,
                                                );
                                              }
                                            }),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(
                                      Icons.skip_previous_rounded,
                                      size: 45,
                                    ),
                                    onPressed: () {
                                      controller.playSong(
                                          data[controller.playIndex.value - 1]
                                              .uri,
                                          controller.playIndex.value - 1);
                                      controller.textisLong(
                                          data[controller.playIndex.value]
                                              .title);
                                    },
                                  ),
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.transparent,
                                    foregroundColor:
                                        Theme.of(context).primaryColorLight,
                                    child: Transform.scale(
                                      scale: 1.5,
                                      child: IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            if (controller.isPlaying.value) {
                                              controller.audioPlayer.pause();
                                              controller.isPlaying(false);
                                            } else {
                                              controller.audioPlayer.play();
                                              controller.isPlaying(true);
                                            }
                                          },
                                          icon: Obx(
                                            () => controller.isPlaying.value
                                                ? const Icon(Icons.pause,
                                                    size: 50)
                                                : const Icon(
                                                    Icons.play_arrow_rounded,
                                                    size: 50),
                                          )),
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(Icons.skip_next_rounded,
                                        size: 45),
                                    onPressed: () {
                                      controller.textisLong(
                                          data[controller.playIndex.value + 1]
                                              .title);
                                      controller.playSong(
                                          data[controller.playIndex.value + 1]
                                              .uri,
                                          controller.playIndex.value + 1);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
