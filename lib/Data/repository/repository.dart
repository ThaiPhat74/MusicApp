import '../model/song.dart';
import '../source/source.dart';

abstract interface class Repository {
  Future<List<Song>?> loadSongs();
}

class DefaultRepository implements Repository {
  final _localDataSource = LocalDataSource();
  final _remoteDataSource = RemoteDataSource();

  @override
  Future<List<Song>?> loadSongs() async {
    List<Song> songs = [];
    await _remoteDataSource.loadSongs().then((values) {
      if(values == null){
        _localDataSource.loadSongs().then((localSongs) {
         if(localSongs != null){
           songs.addAll(localSongs);
         }
        });
      } else {
        songs.addAll(values);
      }
    });
    return songs;
  }
}