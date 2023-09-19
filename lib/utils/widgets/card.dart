import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

import 'package:on_audio_query/on_audio_query.dart';

import 'package:player_x/utils/controllers/player_controller.dart';

// ignore: must_be_immutable, camel_case_types
class card extends StatelessWidget {
  final List<SongModel> data;
  var controller = Get.put(PlayerController());

  card({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 7,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        QueryArtworkWidget(
                          id: data[controller.playIndex.value].id,
                          type: ArtworkType.AUDIO,
                          artworkBorder: BorderRadius.zero,
                          nullArtworkWidget: const Icon(
                            Icons.music_note,
                            size: 30,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: 200,
                                  height: 25,
                                  child: controller.isLongText.value
                                      ? Marquee(
                                          text: data[controller.playIndex.value]
                                              .title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                          scrollAxis: Axis.horizontal,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          blankSpace: 20,
                                          velocity: 50.0,
                                          fadingEdgeEndFraction: 0.1,
                                          pauseAfterRound:
                                              const Duration(seconds: 1),
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
                                              .headlineMedium,
                                        )),
                              SizedBox(
                                width: 180,
                                child: Text(
                                  data[controller.playIndex.value]
                                      .artist
                                      .toString(),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
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
                            ? const Icon(Icons.pause, size: 18)
                            : const Icon(
                                Icons.play_arrow_rounded,
                              ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
