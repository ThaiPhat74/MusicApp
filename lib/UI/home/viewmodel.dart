import 'dart:async';

import 'package:music_app/UI/home/home.dart';

import '../../Data/model/song.dart';
import '../../Data/repository/repository.dart';

class MusicAppViewModel{
  StreamController<List<Song>> songStream = StreamController();

  void loadSongs(){
    final repository = DefaultRepository();
    repository.loadSongs().then((value) => songStream.add(value!));
  }
}