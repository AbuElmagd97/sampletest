import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sampletest/vdoplayback_view.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VdoCipher Sample Application',
      home: MyHome(),
      navigatorObservers: [VdoPlayerController.navigatorObserver('/player/(.*)')],
      theme: ThemeData(
          primaryColor: Colors.white,
          textTheme: TextTheme(bodyText1: TextStyle(fontSize: 12.0))),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  String? _nativePlatformLibraryVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    getNativeLibraryVersion();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getNativeLibraryVersion() async {
    String? version;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      version = await (Platform.isIOS ? VdocipherMethodChannel.nativeIOSAndroidLibraryVersion : VdocipherMethodChannel.nativeAndroidLibraryVersion);
    } on PlatformException {
      version = 'Failed to get native platform library version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _nativePlatformLibraryVersion = version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('VdoCipher Sample Application'),
        ),
        body: Center(child: Column(
          children: <Widget>[
            Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _goToVideoPlayback,
                    child: const Text('Online Playback',
                        style: TextStyle(fontSize: 20)),
                  ),
                  ElevatedButton(
                    onPressed: null,
                    child: const Text('Todo: video selection',
                        style: TextStyle(fontSize: 20)),
                  )
                ])),
            Padding(padding: EdgeInsets.all(16.0),
                child: Text('Native ${Platform.isIOS ? 'iOS' : 'Android'} library version: $_nativePlatformLibraryVersion',
                    style: TextStyle(color: Colors.grey, fontSize: 16.0)))
          ],
        ))
    );
  }

  void _goToVideoPlayback() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: RouteSettings(name: '/player/sample/video'),
        builder: (BuildContext context) {
          return VdoPlaybackView();
        },
      ),
    );
  }
}