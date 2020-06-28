import 'dart:async';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController animationController;
  Duration duration;
  Duration position;

  AudioPlayer audioPlayer = AudioPlayer();

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';

  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;
  String audioURL =
      'https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3';
  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  final Tween<double> turnsTween = Tween<double>(
    begin: 1,
    end: 3,
  );
  AudioPlayer audioPlugin = AudioPlayer();

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));

    initAudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('Hack20 - The Dubai Team'),
        // ),
        body: Stack(
          children: <Widget>[
            CustomScrollView(
              reverse: true,
              // shrinkWrap: true,
              // scrollDirection: Axis.horizontal,
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(
                      height: 20,
                    )
                  ]),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 120.0,
                    width: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Transform(
                          // Transform widget
                          transform: Matrix4.identity()
                            ..setEntry(1, 2, 0.213) // perspective
                            ..rotateX(7)
                            ..rotateY(3),
                          alignment: FractionalOffset.center,

                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              // width: 100.0,
                              child: Card(
                                elevation: 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image(
                                    image: Svg(
                                      'assets/disque_vinyl.svg',
                                      width:
                                          (MediaQuery.of(context).size.width *
                                                  0.8)
                                              .floor(),
                                      height:
                                          (MediaQuery.of(context).size.width *
                                                  0.8)
                                              .floor(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: RotationTransition(
                turns: AlwaysStoppedAnimation(50 / 360),
                child: Transform(
                  // Transform widget
                  transform: Matrix4.identity()
                    ..setEntry(1, 2, 0.113) // perspective
                    ..rotateX(15)
                    ..rotateY(15),
                  alignment: FractionalOffset.center,

                  child: RotationTransition(
                    turns: turnsTween.animate(animationController),
                    child: GestureDetector(
                      onTap: () {
                        playerState == PlayerState.playing ? pause() : play();
                      },
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          Container(
                            child: Image(
                              image: Svg(
                                'assets/disque_vinyl.svg',
                                width: (MediaQuery.of(context).size.width * 0.8)
                                    .floor(),
                                height:
                                    (MediaQuery.of(context).size.width * 0.8)
                                        .floor(),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            child: Text(
                              'HACK 20',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            child: Text(
                              'HACK 20',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        //onComplete();
        animationController.stop();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        animationController.stop();
        duration = Duration(seconds: 0);
        position = Duration(seconds: 0);
      });
    });
  }

  Future play() async {
    await audioPlayer.play(audioURL, isLocal: false);
    animationController.reset();
    animationController.repeat();
    setState(() {
      playerState = PlayerState.playing;
    });
  }

  Future pause() async {
    await audioPlayer.pause();
    animationController.stop();
    setState(() {
      playerState = PlayerState.paused;
    });
  }
}

enum PlayerState { stopped, playing, paused }
