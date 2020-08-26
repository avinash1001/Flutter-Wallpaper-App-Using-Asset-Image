import 'dart:typed_data';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';

class Wall extends StatefulWidget {
  @override
  _WallState createState() => _WallState();
}

class _WallState extends State<Wall> {
  final List<String> images = [
    'assets/images/w1.jpg',
    'assets/images/w2.jpg',
    'assets/images/w3.jpg',
    'assets/images/w4.jpg',
    'assets/images/w5.jpg',
    'assets/images/w6.jpg',
    'assets/images/w7.jpg',
    'assets/images/w8.jpg',
    'assets/images/w9.jpg',
    'assets/images/w10.jpg',
    'assets/images/w11.jpg',
    'assets/images/w12.jpg',
    'assets/images/w13.jpg',
    'assets/images/w14.jpg',
    'assets/images/w15.jpg',
    'assets/images/w16.jpg',
    'assets/images/w17.jpg',
    'assets/images/w18.jpg',
    'assets/images/w19.jpg',
    'assets/images/w20.jpg',
    'assets/images/w21.jpg',
    'assets/images/w22.jpg',
    'assets/images/w23.jpg',
    'assets/images/w24.jpg',
    'assets/images/w25.jpg',
    'assets/images/w26.jpg',
    'assets/images/w27.jpg',
    'assets/images/w28.jpg',
    'assets/images/w29.jpg',
    'assets/images/w30.jpg',
    'assets/images/w31.jpg',
    'assets/images/w32.jpg',
    'assets/images/w33.jpg',
    'assets/images/w34.jpg',
    'assets/images/w35.jpg',
    'assets/images/w36.jpg',
    'assets/images/w37.jpg',
    'assets/images/w38.jpg',
    'assets/images/w39.jpg',
    'assets/images/w40.jpg',
    'assets/images/w41.jpg',
    'assets/images/w42.jpg',
    'assets/images/w43.jpg',
    'assets/images/w44.jpg',
    'assets/images/w45.jpg',
    'assets/images/w46.jpg',
    'assets/images/w47.jpg',
    'assets/images/w48.jpg',
    'assets/images/w49.jpg',
    'assets/images/w50.jpg',
  ];
  String _wallpaperAsset = 'Unknown';
  @override
  void initState() {
    super.initState();
    _requestPermission();
    Admob.initialize('ca-app-pub-9468435791390939~9733871948');
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
    _toastInfo(info);
  }

  Future printUrl(int index) async {
    Navigator.pop(context);
    _onLoading1();
    StorageReference ref =
        FirebaseStorage.instance.ref().child("images/w${index + 1}.jpg");
    String url = (await ref.getDownloadURL()).toString();
    print(url);
    _saveImage(url);
  }

  _saveImage(String url) async {
    var response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
    );

    print(result);
    _toastInfo("$result");
  }

  void _toastInfo(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: 2, gravity: gravity);
  }

  show1(BuildContext context, int index, String path) {
    AlertDialog alert = AlertDialog(
      buttonPadding: EdgeInsets.all(10),
      actions: [
        FlatButton(
            onPressed: () {
              printUrl(index);
            },
            child: Text('Save to Gallery')),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
              show2(context, path);
            },
            child: Text('Set Wallpaper')),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  show2(BuildContext context, String path) {
    AlertDialog alert = AlertDialog(
      buttonPadding: EdgeInsets.all(10),
      actions: [
        FlatButton(
            onPressed: () {
              setWallpaperFromAssetLock(path);
            },
            child: Text('Lock Screen')),
        FlatButton(
            onPressed: () {
              setWallpaperFromAssetHome(path);
            },
            child: Text('Home Screen')),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _onLoading1() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new HeartbeatProgressIndicator(
          child: Icon(
            Icons.photo,
            color: Colors.white,
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 3), () {
      Navigator.pop(context); //pop dialog
    });
  }

  void _onLoading2() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new HeartbeatProgressIndicator(
          child: Icon(
            Icons.favorite_border,
            color: Colors.white,
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 3), () {
      Navigator.pop(context);
      // Navigator.pop(context); //pop dialog
    });
  }

  Future<void> setWallpaperFromAssetHome(String path) async {
    Navigator.pop(context);
    _onLoading2();
    setState(() {
      _wallpaperAsset = "Loading";
    });
    String result;
    String assetPath = path;
    try {
      result = await WallpaperManager.setWallpaperFromAsset(
          assetPath, WallpaperManager.HOME_SCREEN);
    } on PlatformException {
      result = 'Failed to get wallpaper.';
    }
    if (!mounted) return;

    setState(() {
      _wallpaperAsset = result;
    });
  }

  Future<void> setWallpaperFromAssetLock(String path) async {
    Navigator.pop(context);
    _onLoading2();
    setState(() {
      _wallpaperAsset = "Loading";
    });
    String result;
    String assetPath = path;
    try {
      result = await WallpaperManager.setWallpaperFromAsset(
          assetPath, WallpaperManager.LOCK_SCREEN);
    } on PlatformException {
      result = 'Failed to get wallpaper.';
    }
    if (!mounted) return;

    setState(() {
      _wallpaperAsset = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: images.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: .5,
      ),
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
            onTap: () {
              show1(context, index, images[index]);
            },
            child: Card(elevation: 10, child: Image.asset(images[index])));
      },
    );
  }
}
