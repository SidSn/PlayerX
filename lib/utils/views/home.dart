import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:player_x/utils/const/colors.dart';
import 'package:player_x/utils/controllers/player_controller.dart';
import 'package:player_x/utils/views/player.dart';
import 'package:player_x/utils/widgets/card.dart';
import 'package:player_x/utils/widgets/icon_widgets.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  var controller = Get.put(PlayerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          actions: [
            ThemeToggleButton(), // Use the new widget
          ],
        ),
        body: FutureBuilder<List<SongModel>>(
          future: controller.audioQuery.querySongs(
            ignoreCase: true,
            orderType: OrderType.ASC_OR_SMALLER,
            sortType: null,
            uriType: UriType.EXTERNAL,
          ),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.isEmpty) {
              return const Center(child: Text("No Song Found"));
            } else {
              controller.songs.clear();
              controller.songs = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    ListView.builder(
                        itemCount: snapshot.data.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .shadow
                                          .withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8))),
                              child: Obx(
                                () => ListTile(
                                    title: Text(snapshot.data![index].title),
                                    subtitle: Text(
                                        snapshot.data![index].artist ??
                                            "No Artist"),
                                    leading: QueryArtworkWidget(
                                      id: snapshot.data![index].id,
                                      type: ArtworkType.AUDIO,
                                      artworkBorder: BorderRadius.zero,
                                      nullArtworkWidget: const Icon(
                                        Icons.music_note,
                                        size: 30,
                                      ),
                                    ),
                                    // ignore: unrelated_type_equality_checks
                                    trailing: controller.playIndex == index &&
                                            controller.isPlaying.value
                                        ? const Icon(Icons.play_arrow)
                                        : null,
                                    onTap: () async {
                                      controller.textisLong(
                                          snapshot.data[index].title);
                                      if (controller.isPlaying.value == true &&
                                          controller.playIndex.value == index) {
                                        await controller.audioPlayer
                                            .setAudioSource(
                                                controller.createPlaylist(
                                                    snapshot.data!),
                                                initialIndex: index);
                                        Get.to(
                                            () => PlayerScreen(
                                                  data: snapshot.data!,
                                                ),
                                            transition: Transition.downToUp);
                                      } else {
                                        controller.playSong(
                                            snapshot.data![index].uri, index);
                                        controller.audioPlayer.playerStateStream
                                            .listen((playerState) {
                                          if (playerState.processingState ==
                                              ProcessingState.completed) {
                                            controller.playSong(
                                                snapshot
                                                    .data![controller
                                                            .playIndex.value +
                                                        1]
                                                    .uri,
                                                controller.playIndex.value + 1);
                                            controller.setFirstOpenFalse();
                                          }
                                        });
                                        Get.to(
                                            () => PlayerScreen(
                                                  data: snapshot.data!,
                                                ),
                                            transition: Transition.downToUp);
                                      }
                                    }),
                              ),
                            ),
                          );
                        }),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Obx(() {
                            if (controller.isFirstOpen.value == true) {
                              return const Text('');
                            } else {
                              return GestureDetector(
                                onHorizontalDragEnd: (details) {
                                  double dx = details.primaryVelocity!;
                                  if (dx < 0) {
                                    controller.playSong(
                                        snapshot
                                            .data[
                                                controller.playIndex.value + 1]
                                            .uri,
                                        controller.playIndex.value + 1);
                                    controller.textisLong(snapshot
                                        .data[controller.playIndex.value]
                                        .title);
                                  } else if (dx > 0) {
                                    // ignore: unrelated_type_equality_checks
                                    if (controller.playIndex == 0) {
                                      Get.back();
                                    } else {
                                      controller.playSong(
                                          snapshot
                                              .data[controller.playIndex.value -
                                                  1]
                                              .uri,
                                          controller.playIndex.value);
                                      controller.textisLong(snapshot
                                          .data[controller.playIndex.value]
                                          .title);
                                    }
                                  }
                                },
                                onVerticalDragUpdate:
                                    (DragUpdateDetails details) {
                                  Get.to(
                                      () => PlayerScreen(
                                            data: snapshot.data!,
                                          ),
                                      transition: Transition.downToUp);
                                },
                                onTap: () {
                                  Get.to(
                                      () => PlayerScreen(
                                            data: snapshot.data!,
                                          ),
                                      transition: Transition.downToUp);
                                },
                                child: card(
                                  data: snapshot.data,
                                ),
                              );
                            }
                          }),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ));
  }
}
