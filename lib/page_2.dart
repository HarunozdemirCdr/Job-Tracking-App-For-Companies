import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_tracking_app/main.dart';
import 'package:job_tracking_app/yap%C4%B1l%C4%B1yor_isler_sayfasi.dart';
import 'package:job_tracking_app/yap%C4%B1lamayan_isler_sayfasi.dart';
import 'package:job_tracking_app/yap%C4%B1lan_isler_sayfasi.dart';

import 'is_ekleme_sayfasi.dart';
import 'islem_sayfasi.dart';


class SecondPage extends StatefulWidget {

  const SecondPage({Key? key, required this.user}) : super(key: key);
  final User user;


  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  String fonksiyon_adi = "";
  String islem_numarasi= "";

  List<String> work_category = [
    "DEFINED WORK",
    "COMPLETED WORK",
    "UNCOMPLETED WORK",
    "WORK IN PROGRESS",
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(

          backgroundColor: Colors.black,
          title: Center(child: Text("Business control screen"),)
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
                  children: [

                    Container(
                      height: height*0.70,
                      color: Colors.transparent,
                      child: Column(

                        children: [Expanded(child: GridView.builder(
                          primary: false,
                          padding: EdgeInsets.all(10),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: work_category.length,
                          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 10,
                            mainAxisExtent: 100,
                            crossAxisCount: 1,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black),
                                child: ListTile(
                                  title: Center(child: Text(work_category[index],style: TextStyle(color: Colors.white,fontSize: height/40),)),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  fonksiyon_adi = work_category[index].toString();
                                  if (fonksiyon_adi ==  "DEFINED WORK") { Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => islem_sayfa(islem_numarasi: islem_numarasi,indivudual_user_data: widget.user,)),
                                  );  islem_numarasi = fonksiyon_adi;}
                                  if (fonksiyon_adi == "COMPLETED WORK") { Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => yapilan_isler(islem_numarasi: islem_numarasi,indivudual_user_data: widget.user,)),
                                  );   islem_numarasi = fonksiyon_adi;}
                                  if (fonksiyon_adi == "UNCOMPLETED WORK") {Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => yapilamayan_isler(islem_numarasi: islem_numarasi,indivudual_user_data: widget.user,)),
                                  ); islem_numarasi = fonksiyon_adi;}
                                  if (fonksiyon_adi == "WORK IN PROGRESS") { Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => yapiliyor_isler(islem_numarasi: islem_numarasi,indivudual_user_data: widget.user,)),
                                  );   islem_numarasi = fonksiyon_adi;}

                                });
                              },
                            );
                          },
                        ),
                        ),

                        ],
                      ),
                    ),


                 SingleChildScrollView(
                   scrollDirection: Axis.horizontal,
                   child:    Container(
                     margin: EdgeInsets.symmetric(horizontal: 40),
                     height: height*0.10,
                     color: Colors.transparent,
                     child: Row(
                       children: [
                         SizedBox(width: 7,),
                         ElevatedButton(onPressed: () {
                           Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => MyApp()),
                           );
                         },
                             style: ButtonStyle(
                                 backgroundColor: MaterialStateProperty.all(Colors.black)
                             ),child: Row(
                               children: [
                                 Icon(Icons.arrow_back,),
                                 SizedBox(width: 5,),

                                 Text("LOG OUT")
                               ],
                             )),

                         SizedBox(width: 30,),
                         ElevatedButton(onPressed: () {
                          Navigator.push(
                           context,
                          MaterialPageRoute(builder: (context) => is_ekleme_sayfasi(user: widget.user,)),
                          );
                         },
                             style: ButtonStyle(
                                 backgroundColor: MaterialStateProperty.all(Colors.black)
                             ),child: Row(
                               children: [
                                 Icon(Icons.work_history_rounded,),
                                 SizedBox(width: 5,),
                                 Text("ASSİGN WORK")
                               ],
                             ))
                       ],
                     ),
                   ),
                 ),
                    Text("Developed by Harun Özdemir",style: TextStyle(fontWeight: FontWeight.bold)),
                    Container(height: 20,width:20)
                  ])),
        )));
        
  }
}
