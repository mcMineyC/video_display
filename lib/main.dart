import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  runApp(const Appy());
}

class Appy extends StatelessWidget {
  const Appy({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  late VlcPlayerController _controller;
  bool played = false;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    _controller = VlcPlayerController.asset(
      "keynote_tablet.mp4",
      hwAcc: HwAcc.decoding,
      autoPlay: true,
      // autoInitialize: true,
      options: VlcPlayerOptions()
    );
    _controller.initialize().then((thing) {
      print("Done?");
      setState(() {
        print("Set stated");
      });
    });
    _controller.addListener(() {
      print("Listener: ${_controller.value.position.inSeconds} ${_controller.value.position} ${played} playing ${_controller.value.isPlaying}");
      if(_controller.value.position.inSeconds >= 74) {
        print("pausing for haxx");
        _controller.pause();
      }
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() async {
    super.dispose();
    // await _controller.stopRendererScanning();
    // await _controller.dispose();
    Wakelock.disable();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
      VlcPlayer(
        controller: _controller,
        aspectRatio: 16/9,
        placeholder: Center(
          child: CircularProgressIndicator(color: Colors.blue[600])
        ),
      ),
      GestureDetector(
      onTap: () async {
        print("tap: ${_controller.value.position.inSeconds} ${_controller.value.position} ${played} playing ${_controller.value.isPlaying}");
        await _controller.seekTo(Duration.zero);
        await _controller.play();
        // setState(() {});
      },
      onDoubleTap: () {
        if(_controller.value.isPlaying) {
          _controller.pause();
        }else{
          _controller.play();
        }
      },
      onLongPress: () {
        _controller.seekTo(const Duration(seconds: 70));
      },
      ),
      ],
    );
  }
}