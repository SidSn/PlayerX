// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
  var playIndex = 0.obs;
  var isPlaying = false.obs;
  var duration = ''.obs;
  var postion = ''.obs;

  var max = 0.0.obs;
  var value = 0.0.obs;
  var loop = false.obs;
  var isLongText = false.obs;

  List<SongModel> songs = [];
  var currentSongTitle = ''.obs;
  Rx<LoopMode> loopMode = LoopMode.off.obs;
  @override
  void onInit() {
    super.onInit();
    checkPermission();
    getAllSongs();
  }

  ConcatenatingAudioSource createPlaylist(List<SongModel> songs) {
    List<AudioSource> sources = [];
    for (var song in songs) {
      sources.add(AudioSource.uri(Uri.parse(song.uri!)));
    }
    return ConcatenatingAudioSource(children: sources);
  }

  changeDurationtoSec(seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  Future<void> getAllSongs() async {
    final query = OnAudioQuery();
    final songsResult = await query.querySongs();
    songs.assignAll(songsResult);
  }

  Future<void> createAndPlayPlaylist() async {
    // Create a playlist
    final playlist = ConcatenatingAudioSource(children: []);

    // Add songs to the playlist
    for (final song in songs) {
      playlist.add(AudioSource.uri(Uri.parse(song.uri!)));
    }

    // Load and play the playlist
    await audioPlayer.setAudioSource(playlist);
    await audioPlayer.play();
  }

  updatePotion() {
    audioPlayer.durationStream.listen((d) {
      duration.value = d.toString().split('.')[0];
      max.value = d!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((p) {
      postion.value = p.toString().split('.')[0];
      value.value = p.inSeconds.toDouble();
    });
  }

  playSong(String? uri, index) async {
    playIndex.value = index;
    try {
      await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
      isPlaying(true);
      updatePotion();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  checkPermission() async {
    var perm = Permission.storage.request();
    if (await perm.isGranted) {
    } else {
      checkPermission();
    }
  }

  var isFirstOpen = true.obs;

  void setFirstOpenFalse() {
    isFirstOpen.value = false;
  }

  textisLong(String text) {
    int shortTextThreshold = 20;
    if (text.length > shortTextThreshold) {
      isLongText.value = true;
    } else {
      isLongText(false);
    }
  }
}
