import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mww/wall.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Admob.initialize('ca-app-pub-9468435791390939~9733871948');
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoggedIn = false;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  _logout() {
    _googleSignIn.signOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  Future<FirebaseUser> _login() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    setState(() {
      _isLoggedIn = true;
    });
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Scaffold(
      body: _isLoggedIn
          ? Column(
              children: [
                SizedBox(
                  height: mq.padding.top,
                ),
                Container(
                  color: Colors.transparent,
                  height: (mq.size.height - mq.padding.top) * 0.12,
                  child: Card(
                    elevation: 10,
                    child: ListTile(
                      leading: Image.network(
                        _googleSignIn.currentUser.photoUrl,
                      ),
                      subtitle: Text('CobraApps'),
                      title: Text(_googleSignIn.currentUser.displayName),
                      trailing: OutlineButton(
                        child: Text("Logout"),
                        onPressed: () {
                          _logout();
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  height: (mq.size.height - mq.padding.top) * 0.78,
                  child: Wall(),
                ),
                AdmobBanner(
                    adUnitId: 'ca-app-pub-9468435791390939/5794626934',
                    adSize: AdmobBannerSize.BANNER),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'MINIMALISTIC WHITE WALLPAPERS',
                  style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 1,
                      wordSpacing: 2,
                      color: Colors.black54),
                ),
                SizedBox(
                  height: (mq.size.height) * 0.1,
                ),
                Center(
                  child: Container(
                    height: (mq.size.height) * 0.1,
                    child: InkWell(
                      onTap: () {
                        _login();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 40,
                            child: Image(image: AssetImage('assets/gs3.png')),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Login With Google',
                              style: TextStyle(
                                color: Colors.lightBlue,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
