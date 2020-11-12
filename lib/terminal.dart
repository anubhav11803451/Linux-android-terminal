import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';

class MyCLI2 extends StatefulWidget {
  final User user;
  final clientID;
  final userDocID;

  MyCLI2({this.user, this.clientID, this.userDocID}) : super();
  @override
  _MyCLI2State createState() => _MyCLI2State();
}

class _MyCLI2State extends State<MyCLI2> {
  //final FirebaseAuth _authc = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final TextEditingController _textController = new TextEditingController();

  String cmd;
  String serverID = "192.168.29.228";
  //String clientID;
  String output = "";
  bool waiting = false;
  int count;
  List history = ["docker run -it centos:7"];

  List commands = [
    "ls",
    "cd ..",
    "mkdir <directory name>",
    "ifconfig",
    "date",
    "cal",
    "docker ps",
    "docker images",
  ];

  List cmdnames = [
    "List all documents in current directory",
    "current directory",
    "create a new directory",
    "",
    "view date",
    "view calender",
    "List all docker containers",
    "List all docker images",
  ];

  @override
  initState() {
    count = 0;
  }

  //Future<void> getOutput() {}

  Future<void> sendToWeb() async {
    DocumentReference reference = FirebaseFirestore.instance
        .collection('users')
        .doc("${widget.userDocID}")
        .collection("commands")
        .doc();

    print("************************************* HERE *********************");

    await reference.set({
      'input': cmd,
      'output': "",
      //'clientID': widget.clientID.toString(),
      'clientID': "XYZ123",
    });
    print("Send to Web: Complete");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Stack(
                //alignment: AlignmentDirectional.topCenter,
                children: [
                  Container(
                    // height: MediaQuery.of(context).size.height * 50,
                    //width: MediaQuery.of(context).size.width,
                    height: 300,
                    width: double.infinity,
                    color: HexColor("#011627"),
                    child: Flexible(
                        child: new ListView.builder(
                            itemCount: history.length,
                            itemBuilder: (BuildContext context, int index) {
                              return new Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "Bash \$ ",
                                    style: TextStyle(
                                      color: Colors.red[400],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: TextField(
                                      controller: _textController,
                                      onChanged: (value) {
                                        cmd = value;
                                      },
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              );
                            })),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 320,
                      ),
                      Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                            height: 400,
                            width: double.infinity,
                            color: Colors.blue[50],
                          ),
                          // Container(
                          //   height: 30,
                          //   width: 60,
                          //   color: Colors.red,
                          // ),
                          Positioned(
                              left: 50,
                              right: 50,
                              top: 100,
                              child: Container(
                                height: 150,
                                width: 250,
                                color: Colors.amber,
                              )),
                          Container(
                            height: 400,
                            width: double.infinity,
                            //color: Colors.red,
                            child: SizedBox.expand(
                              child: DraggableScrollableSheet(builder:
                                  (BuildContext context,
                                      ScrollController scrollController) {
                                return Container(
                                  color: Colors.white,
                                  child: ListView.builder(
                                      controller: scrollController,
                                      itemCount: commands.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        // return ListTile(title: Text(cmdnames[index]));
                                        return Container(
                                          width: double.infinity,
                                          child: new FlatButton(
                                            child: Text(cmdnames[index]),
                                            onPressed: () {
                                              _textController.text =
                                                  commands[index];
                                              cmd = _textController.text;
                                            },
                                          ),
                                        );
                                      }),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   height: 140,
                      // ),
                    ],
                  ),
                  Positioned(
                      top: 270,
                      left: 300,
                      height: 70,
                      width: 70,
                      //bottom: 300,
                      child: GestureDetector(
                        onTap: () {
                          // sendToWeb();
                          // if (cmd != null) {
                          //   history.add(cmd);
                          //   setState() {
                          //     count++;
                          //   }

                          //   cmd = null;
                          //   print(history);
                          // }
                        },
                        child: FloatingActionButton(
                          onPressed: () {
                            //print("COMMAND: $cmd");
                            sendToWeb();
                          },
                          child: Icon(Icons.play_arrow),
                          backgroundColor: Colors.indigo[800],
                        ),
                      ))
                ])
          ],
        ),
      ),
    );
  }
}
