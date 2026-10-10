import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RASS Live',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: LiveHome(),
    );
  }
}

class LiveHome extends StatefulWidget {
  @override
  _LiveHomeState createState() => _LiveHomeState();
}

class _LiveHomeState extends State<LiveHome> {
  CameraController? controller;
  bool isLive = false;

  @override
  void initState() {
    super.initState();
    initCam();
  }

  initCam() async {
    await [Permission.camera, Permission.microphone].request();
    controller = CameraController(cameras[0], ResolutionPreset.high);
    await controller!.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("World Live No.1 - RASS"), backgroundColor: Colors.red),
      body: Column(
        children: [
          Expanded(
            child: controller!= null && controller!.value.isInitialized
               ? CameraPreview(controller!)
                : Center(child: CircularProgressIndicator()),
          ),
          Container(
            color: Colors.black,
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() => isLive =!isLive);
                  },
                  icon: Icon(isLive? Icons.stop : Icons.live_tv),
                  label: Text(isLive? "Stop Live" : "Go Live"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                ),
                Icon(Icons.people, color: Colors.white),
                Text("0 Viewers", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
