import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Data/model/song.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying({super.key, required this.playingSong, required this.songs});
  final Song playingSong;
  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    return NowPlayingPage(
        playingSong: playingSong,
        songs: songs
    );
  }
}

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({super.key, required this.playingSong, required this.songs});
  final Song playingSong;
  final List<Song> songs;

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage>
  with SingleTickerProviderStateMixin
  {
  late AnimationController _imageAnimationController;

  @override
  void initState(){
    super.initState();
    _imageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12000),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const delta = 64;
    final double imageWidth = (screenWidth - delta)/2;


    // return const Scaffold(
    //   body: Center(
    //     child: Text('Now Playing'),
    //   ),
    // );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Now Playing'
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz),
            ),
    ),
    child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Text(widget.playingSong.album),
            const SizedBox(height: 16),
            const Text('_ ____ _'),
            const SizedBox(
                height: 48
              ),
            RotationTransition(turns: Tween(begin: 0.0, end: 0.0).animate(_imageAnimationController),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(imageWidth),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/img.png',
                    image: widget.playingSong.image,
                    width: screenWidth - delta,
                    height: screenWidth - delta,
                    imageErrorBuilder: (context, error, stackTrace){
                    return  Image.asset(
                        'assets/img.png',
                        width: screenWidth - delta - 10,
                        height: screenWidth - delta - 10,
                      );
                    }
                  ),
                ),
              ),
            Padding(padding: const EdgeInsets.only(top:64, bottom: 16),
              child: SizedBox(
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.share_outlined),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Column(
                      children: [
                        Text(widget.playingSong.title,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium!.color
                    ),),
                        const SizedBox(height: 8),
                        Text(widget.playingSong.artist,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium!.color
                          ),
                        ),
                      ]
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_border),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    ],
                  ),
                )
              ),
            ],
          ),
        ),
      )
    );
  }
}
