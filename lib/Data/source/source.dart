import 'dart:convert';

import 'package:flutter/services.dart';

import '../model/song.dart';
import 'package:http/http.dart' as http;

abstract interface class DataSource{
  Future<List<Song>?> loadSongs();
}

class RemoteDataSource implements DataSource {
  @override
  Future<List<Song>?> loadSongs() async {
    const url ='https://thantrieu.com/resources/braniumapis/songs.json';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200){
     final bodyContent = utf8.decode((response.bodyBytes));
     var songWrapper = json.decode(bodyContent) as Map;
     var songList = songWrapper['songs'] as List;
     List<Song> songs = songList.map((e) => Song.fromJson(e)).toList();
     return songs;
    } else {
      return null;
    }
  }
}

class LocalDataSource implements DataSource {
  @override
  Future<List<Song>?> loadSongs() async {
    final String ressponse = await rootBundle.loadString('assets/songs.json');
    final jsonContent = json.decode(ressponse) as Map;
    final songList = jsonContent['songs'] as List;
    List<Song> songs = songList.map((e) => Song.fromJson(e)).toList();
    return songs;
  }
}
