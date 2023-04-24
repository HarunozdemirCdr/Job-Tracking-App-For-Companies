
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class yapiliyor_isler extends StatefulWidget {
  const yapiliyor_isler({Key? key, required this.islem_numarasi,required this.indivudual_user_data}) : super(key: key);
  final String islem_numarasi;
  final User indivudual_user_data;
  @override
  State<yapiliyor_isler> createState() => _yapiliyor_islerState();
}

class _yapiliyor_islerState extends State<yapiliyor_isler> {

  Stream<QuerySnapshot> getYapiliyorIsler() {
    return FirebaseFirestore.instance.collection('yapılıyor').where('işiyapan', isEqualTo: widget.indivudual_user_data.email).snapshots();
  }

  void change_state_button1(String documentId,) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('yapılıyor')
        .doc(documentId)
        .get();

    if (!doc.exists) {
      return;
    }

    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

    await FirebaseFirestore.instance
        .collection('yapılanişler')
        .doc(documentId)
        .set(data);

    await FirebaseFirestore.instance
        .collection('yapılıyor')
        .doc(documentId)
        .delete();



  }


  void change_state_button2(String documentId,) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('yapılıyor')
        .doc(documentId)
        .get();

    if (!doc.exists) {
      return;
    }

    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

    await FirebaseFirestore.instance
        .collection('yapılamayanişler')
        .doc(documentId)
        .set(data);

    await FirebaseFirestore.instance
        .collection('yapılıyor')
        .doc(documentId)
        .delete();



  }


  void change_state_button3(String documentId,) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('yapılıyor')
        .doc(documentId)
        .get();

    if (!doc.exists) {
      return;
    }

    Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

    await FirebaseFirestore.instance
        .collection('tanımlıişler')
        .doc(documentId)
        .set(data);

    await FirebaseFirestore.instance
        .collection('yapılıyor')
        .doc(documentId)
        .delete();



  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,

        title: Text('WORK IN PROGRESS SCREEN'),
      ),
      body: Container(
          decoration:BoxDecoration(gradient: LinearGradient(
            colors: [
              Colors.yellow,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

          )),
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [Container(
              color: Colors.transparent,
              height: height*0.7,
              child: StreamBuilder<QuerySnapshot>(

                stream: getYapiliyorIsler(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                  if (snapshot.hasError) {
                    return Text('THERE IS A PROGBLEM: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('THERE IS NO WORK !'));
                  }

                  return ListView(

                    padding: EdgeInsets.all(15),
                    shrinkWrap: false,
                    scrollDirection: Axis.vertical,
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      return Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 150,
                        width: 250,

                        child: Column(

                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [SingleChildScrollView(scrollDirection: Axis.horizontal,
                            child: Container(

                              color: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5,),
                                  Text("ASSIGNED TO THE WORK :"+ data['işiyapan'],style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 5,),
                                  Text("WORK : " + data['işadı'],),
                                  SizedBox(height: 5,),
                                  Text("TIME : " + data['işzamanı']),
                                  SizedBox(height: 5,),
                                  Text("ASSIGNER :"+ data['işiatayan'])],
                              ),

                            ),),


                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      change_state_button1(document.id);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 35,
                                      width: 85,
                                      child: Text("COMPLETED"),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  GestureDetector(
                                    onTap: () {change_state_button2(document.id);},
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        color: Colors.red,
                                      ),
                                      alignment: Alignment.center,
                                      height: 35,
                                      width: 85,
                                      child: Text("UNCOMPLETED"),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  GestureDetector(
                                    onTap: () {change_state_button3(document.id);},
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        color: Colors.blue,
                                      ),
                                      alignment: Alignment.center,
                                      height: 35,
                                      width: 85,
                                      child: Text("DEFINED"),
                                    ),
                                  )
                                ],
                              ),
                            ),],

                        ),margin: EdgeInsets.all(10),
                      );
                    }).toList(),

                  );

                },
              ),
            ),],
          )
      ),
    );
  }
}
