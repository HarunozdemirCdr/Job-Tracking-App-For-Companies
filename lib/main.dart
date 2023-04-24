import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:job_tracking_app/one_signal.dart';
import 'package:job_tracking_app/page_2.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OneSignalApi.setupOneSignal();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter APP',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> userPlayerIds = [
    '',
    ''
        ''
  ];

  var user;
  late FirebaseAuth auth = FirebaseAuth.instance;

  final email_controller = TextEditingController();
  final password_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Colors.yellow,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
              child: Column(
                children: [
                  SizedBox(
                    height: 65,
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    width: 500,
                    height: 300,
                    child: Image.asset("assets/company.png"),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    height: 80,
                    width: 300,
                    margin: EdgeInsets.all(20),
                    child: TextField(
                      controller: email_controller,
                      decoration: InputDecoration(
                        prefixIconColor: Colors.black,
                        prefixIcon: Icon(Icons.mail_outline),
                        labelText: 'E-mail',
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.all(20),
                    child: TextField(
                      controller: password_controller,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.security_rounded),
                          prefixIconColor: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        login();
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(Size(200, 30)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                        padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                      ),
                      child: Text("LOGIN")),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Developed by Harun Özdemir",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          )),
    );
  }

  void login() async {
    var user_credential = await auth.signInWithEmailAndPassword(
      email: email_controller.text,
      password: password_controller.text,
    );
    user = user_credential.user;

    String? token = await _getOneSignalUserId();
    if (token != null) {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      DocumentReference userRef = users.doc(user!.uid);

      Map<String, dynamic> data = {
        'token': token,
      };

      if ((await userRef.get()).exists) {
        userRef.update(data);
      } else {
        userRef.set(data);
      }
    } else {
      // Token alınamadı, hata mesajı gösterilebilir
      print('OneSignal user ID not found');
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SecondPage(
                user: user!,
              )),
    );
  }
}

Future<String?> _getOneSignalUserId() async {
  var deviceState = await OneSignal.shared.getDeviceState();
  return deviceState?.userId;
}
