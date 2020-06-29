import 'dart:async';
import 'dart:io';

import 'package:audioplayer/audioplayer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:hack20/widgets/audio_button.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

enum PlayerState { stopped, playing, paused }

class _HomeState extends State<Home> with TickerProviderStateMixin {
  AnimationController animationController;
  AnimationController animationControllerHandle;
  Duration duration;
  Duration position;
  List<File> files = [];
  AudioPlayer audioPlayer = AudioPlayer();

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';

  get positionText =>
      position != null ? position.toString().split('.').first : '';
  int selectedIndex = -1;
  bool isMuted = false;
  var _handleWidth = -100;

  String audioURL =
      'https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3';
  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  final Tween<double> turnsTween = Tween<double>(
    begin: 1,
    end: 3,
  );
  AudioPlayer audioPlugin = AudioPlayer();
  Tween<double> handleTween;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    animationControllerHandle = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    initAudioPlayer();
    handleTween = Tween<double>(
      begin: -(500 / 3) - 1,
      end: 0,
    );
    animationControllerHandle.forward();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _handleWidth = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              Container(
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RotationTransition(
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
                                  playerState == PlayerState.playing
                                      ? pause()
                                      : play();
                                },
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: <Widget>[
                                    Container(
                                      child: Image(
                                        image: Svg(
                                          'assets/images/disk.svg',
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8)
                                              .floor(),
                                          height: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8)
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
                        SizedBox(
                          width: 1,
                        )
                      ],
                    ),
                    Positioned(
                      top: 80,
                      right: 50,
                      child: Image(
                        image: Svg(
                          'assets/images/handle.svg',
                          width: (screenSize.width * 0.25).floor(),
                          //height: (screenSize.width * 0.).floor(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  AudioButton(
                    icon: Icons.fast_rewind,
                    handler: () {
                      playPrevious();
                    },
                  ),
                  SizedBox(
                    width: screenSize.width * 0.04,
                  ),
                  AudioButton(
                    icon: Icons.play_arrow,
                    handler: () {
                      play();
                    },
                  ),
                  SizedBox(
                    width: screenSize.width * 0.04,
                  ),
                  AudioButton(
                    icon: Icons.pause,
                    handler: () {
                      pause();
                    },
                  ),
                  SizedBox(
                    width: screenSize.width * 0.04,
                  ),
                  AudioButton(
                    icon: Icons.fast_forward,
                    handler: () {
                      playNext();
                    },
                  ),
                  SizedBox(
                    width: screenSize.width * 0.04,
                  ),
                  AudioButton(
                    icon: Icons.add,
                    handler: () async {
                      var selelectedFiles = await FilePicker.getMultiFile(
                        type: FileType.custom,
                        allowedExtensions: ['mp3', 'wav', 'm4a'],
                      );
                      if (selelectedFiles != null) {
                        setState(() {
                          files.addAll(selelectedFiles);
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(right: 15, left: 15),
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            audioURL = files[index].path;
                            selectedIndex = index;
                          });
                          stop();
                          play();
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15),
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 15),
                          decoration: BoxDecoration(
                            color: Color(0xFFE6C8A3),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(
                                  files[index].path.split('/').last,
                                  textScaleFactor: 1,
                                  maxLines: null,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: selectedIndex == index
                                        ? Colors.deepOrange[900]
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              Image(
                                image: Svg(
                                  'assets/disque_vinyl.svg',
                                  //width: (screenSize.width * 0.2).floor(),
                                  height: 50,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {},
                    );
                  },
                ),
              ),
            ],
          ),
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

  void stop() async {
    await audioPlayer.stop();
    animationController.stop();
    setState(() {
      playerState = PlayerState.stopped;
    });
  }

  Future playNext() async {
    if (selectedIndex > -1 && selectedIndex < files.length - 1) {
      selectedIndex++;
    } else if (selectedIndex == files.length - 1) {
      selectedIndex = 0;
    }
    audioURL = files[selectedIndex].path;
    await audioPlayer.stop();
    await audioPlayer.play(audioURL, isLocal: false);
    animationController.reset();
    animationController.repeat();
    setState(() {
      playerState = PlayerState.playing;
    });
  }

  Future playPrevious() async {
    if (selectedIndex > 0 && selectedIndex < files.length) {
      selectedIndex--;
    } else if (selectedIndex == 0) {
      selectedIndex = files.length - 1;
    }
    audioURL = files[selectedIndex].path;
    await audioPlayer.stop();
    await audioPlayer.play(audioURL, isLocal: false);
    animationController.reset();
    animationController.repeat();
    setState(() {
      playerState = PlayerState.playing;
    });
  }
}
