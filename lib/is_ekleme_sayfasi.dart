import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_tracking_app/page_2.dart';

import 'one_signal.dart';

class is_ekleme_sayfasi extends StatefulWidget {
  final User user;
  const is_ekleme_sayfasi({Key? key, required this.user, }) : super(key: key);
  @override
  State<is_ekleme_sayfasi> createState() => _is_ekleme_sayfasiState();
}

class _is_ekleme_sayfasiState extends State<is_ekleme_sayfasi> {

  void is_ekleme_fonksiyonu(String is_adi, String is_zamani, String isi_atayan, String isi_yapan) {
    Map<String, dynamic> is_datasi = {
      'işadı': is_adi,
      'işiatayan': isi_atayan,
      'işiyapan': isi_yapan,
      'işzamanı': is_zamani
    };
    FirebaseFirestore.instance.collection('tanımlıişler').add(is_datasi);
  }

   final is_adi_controller = TextEditingController();
   final is_zamani_controller = TextEditingController();
   String atanan_kisi_maili = "";
   String atanan_kisi_adi = "Waiting...";

  List<String> atanacak_kisi = [
    "USER 1",
    "USER 2",
    "HARUN",

  ];




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(

         backgroundColor: Colors.black,
          title:Center(child: Text("WORK ASSIGNMENT PAGE")),

        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            decoration:BoxDecoration(gradient: LinearGradient(
              colors: [
                Colors.yellow,
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,

            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                Center(
                  child:            Container(


                    margin: EdgeInsets.all(20),
                    width: 200,
                    height: 150,
                    child: Image.asset("assets/company.png",fit: BoxFit.fill),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                    ),
                  ),

                ),
                Container(

                  margin: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [   ElevatedButton(style: ButtonStyle(

                        backgroundColor: MaterialStateProperty.all(Colors.black)
                    ),onPressed: () {
                      setState(() {
                        atanan_kisi_maili = "";
                        atanan_kisi_adi = "";
                      });

                    }, child: Text(""),),
                      SizedBox(width: 20,),

                      ElevatedButton(style: ButtonStyle(

                          backgroundColor: MaterialStateProperty.all(Colors.black)
                      ),onPressed: () {

                        setState(() {
                          atanan_kisi_maili = "";
                          atanan_kisi_adi = "";
                        });

                      }, child: Text("USER 2"),),
                      SizedBox(width: 20,),
                      ElevatedButton(style: ButtonStyle(

                          backgroundColor: MaterialStateProperty.all(Colors.black)
                      ),onPressed: () {
                        setState(() {
                          atanan_kisi_maili = "";
                          atanan_kisi_adi = "";
                        });

                      }, child: Text("USER 3"),)],
                  ),
                ),

                Container(height: 65,color: Colors.transparent,
                    child: Center(child: Text("the person who will do the work : "  + atanan_kisi_adi,style: TextStyle(fontSize: 20),),)),
                SizedBox(height: 6,),
                Container(height: 45,color: Colors.transparent,
                  child: TextFormField(
                    controller: is_adi_controller,
                    decoration: InputDecoration(

                      prefixIconColor: Colors.black,
                      prefixIcon: Icon(Icons.work),

                      labelText: 'Enter the work : ',
                    ),
                  ),),
                SizedBox(height: 15,),
                Container(height: 45,color: Colors.transparent,
                  child: TextFormField(

                    controller: is_zamani_controller,
                    decoration: InputDecoration(
                      prefixIconColor: Colors.black,
                      prefixIcon: Icon(Icons.timer),

                      labelText: 'Enter the time : ',
                    ),
                  ),),
                SizedBox(height: 50,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(vertical: 45,horizontal: 35),
                    child: Row(

                      children: [
                        ElevatedButton(onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SecondPage(user: widget.user)),
                          );
                        },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.black)
                            ),child: Row(
                              children: [
                                Icon(Icons.close_sharp,),
                                SizedBox(width: 5,),
                                Text("CANCEL")
                              ],
                            )),

                        SizedBox(width: 120,),
                        ElevatedButton(onPressed: () {
                          setState(() {
                            if(is_zamani_controller.text != "" && is_adi_controller.text != "" && atanan_kisi_maili != ""){
                              is_ekleme_fonksiyonu(
                                  is_adi_controller.text,is_zamani_controller.text,widget.user.email.toString(),atanan_kisi_maili.toString()
                              );

                              OneSignalApi.sendNotification("YOU HAVE A NEW DEFINED WORK !");
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SecondPage(user: widget.user)),
                              );

                            }
                          }
                          );},
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.black)
                            ),child: Row(
                              children: [
                                Icon(Icons.save,),
                                SizedBox(width: 5,),
                                Text("SAVE")
                              ],
                            )),


                      ],
                    ),
                    color: Colors.transparent,
                  ),

                )
              ],
            ),
          ),
        ),
      ),

    );
  }
}


Future<List<String>> getTokensFromFirestore() async {
  List<String> tokens = [];
  QuerySnapshot snapshot =
  await FirebaseFirestore.instance.collection('users').get();
  snapshot.docs.forEach((doc) {
    String token = doc['token'];
    tokens.add(token);
  });
  return tokens;
}
