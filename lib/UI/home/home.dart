import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_app/UI/discovery/discovery.dart';
import 'package:music_app/UI/home/viewmodel.dart';

import '../../Data/model/song.dart';
import '../now_playing/playing.dart';
import '../setting/setting.dart';
import '../user/user.dart';

class MusicApp extends StatelessWidget{
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey)
            .copyWith(secondary: Colors.redAccent),
        useMaterial3: true,
      ),
      home: const MusicHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MusicHomePage extends StatefulWidget {
  const MusicHomePage({super.key});

  @override
  State<MusicHomePage> createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  @override
  final List<Widget> _tabs = [
  const HomeTab(),
    const DiscoveryTab(),
    const AccountTab(),
    const SettingTab(),
  ];
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
          middle:  Text('Music App'),
        ),
        child: CupertinoTabScaffold(
          tabBar:  CupertinoTabBar(
            backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
            items: [
               BottomNavigationBarItem(icon: Icon(Icons.home)
                ,label: 'Home',),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.music_albums),
                label: 'Albums',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person),
                label: 'Account',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.settings),
                label: 'Settings',
              ),
            ],
          ),
          tabBuilder:(BuildContext context, int index){
            return _tabs[index];
          },
        ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeTabPage();
  }
}

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  List<Song> songs = [];
  late MusicAppViewModel _viewModel ;

  @override
  void initState(){
    _viewModel = MusicAppViewModel();
    _viewModel.loadSongs();
    observeSong();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: getBody(),
    );
  }

  @override
  void dispose(){
    _viewModel.songStream.close();
    super.dispose();
  }

  Widget getBody(){
    bool showLoading = songs.isEmpty;
    if(showLoading){
      return getProgressBar();
    }else {
      return getListView();
    }
  }

  Widget getProgressBar(){
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget getListView(){
    return ListView.separated(
        itemBuilder: (context,position){
          return getRow(position);
        },
        separatorBuilder: (context,index){
          return const Divider(
            color: Colors.grey,
            thickness: 1,
            indent: 24,
            endIndent: 24,
          );
        },
        itemCount: songs.length,
      shrinkWrap: true,
    );
  }

  Widget getRow(int i){
    return _SongItemSection(parent: this, song: songs[i]
    );
  }

  void observeSong(){
    _viewModel.songStream.stream.listen((songList) {
      setState(() {
        songs.addAll(songList);
      });
    });
  }
  void showBottomSheet(){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return  ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child:Container(
              height: 400,
              color: Colors.blueGrey,
              child: Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Model Bottom Sheet'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close Bottom Sheet'),
                    )
                  ]
                ),
              )
            )
          );
        }
    );
  }
  void navigate(Song song){
    Navigator.push(context,
      CupertinoModalPopupRoute(builder: (context){
        return NowPlaying(
          songs: songs,
          playingSong: song,
        );
      })
    );
  }
}
class _SongItemSection extends StatelessWidget{
  const _SongItemSection({
    required this.parent,
    required this.song,
  });
  final _HomeTabPageState parent;
  final Song song;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        left: 24,
        right: 8,
      ),
      title: Text(song.title),
      subtitle: Text(song.artist),
      leading:ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child:  FadeInImage.assetNetwork(
            placeholder: 'assets/img.png',
            image: song.image,
            width: 48,
            height: 48,
            imageErrorBuilder: (context, error, stackTrace)
            // => const Icon(Icons.error),
            => Image.asset('assets/img.png')
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.play_arrow),
        onPressed: () {
          parent.showBottomSheet();
        },
      ),
      onTap: () {
        parent.navigate(song);
      },
    );
  }
}


