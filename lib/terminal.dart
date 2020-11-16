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
    super.initState();
  }

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
      'timestamp': "",
    });
    print("Send to Web: Complete");
  }

  Future getOutput() async {
    // StreamBuilder<QuerySnapshot>(
    //   stream: fireStore
    //       .collection("users")
    //       .doc(widget.userDocID)
    //       .collection("commands")
    //       .snapshots(),
    //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //     if (!snapshot.hasData)
    //       return new Text('Loading...');
    //     else
    //       return new ListView.builder(
    //         // children: [
    //         //   snapshot.data.documents.map((DocumentSnapshot document){}),
    //         // ],
    //       );
    //   },
    // );

    var userQuery = fireStore
        .collection("users")
        .doc(widget.userDocID)
        .collection("commands")
        .where('output', isEqualTo: "")
        .limit(1);
    await userQuery.get().then((data) {
      data.docChanges.forEach((change) {
        print('documentChanges ${change.doc.data}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sendToWeb();
          getOutput();

          if (cmd != null) {
            history.add(cmd);
            setState(() {
              count++;
            });

            cmd = null;
            print(history);
          }
        },
        child: Icon(Icons.play_arrow),
        backgroundColor: Colors.indigo[800],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
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
                    child: Column(
                      children: [
                        Expanded(
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
                                    if (history.length - index == 1)
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
                                    else
                                      Flexible(
                                          child: Text(
                                        history[index + 1],
                                        style: TextStyle(color: Colors.white),
                                      )),
                                  ],
                                );
                              }),
                        ),
                        Row(
                          children: [
                            Text(
                              "output: ",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(output != null ? output : "..."),
                          ],
                        )
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 300,
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
                              top: 45,
                              child: Container(
                                height: 150,
                                width: 250,
                                color: Colors.amber,
                              )),
                          Container(
                            height: 200,
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
                    ],
                  ),
                ])
          ],
        ),
      ),
    );
  }
}
