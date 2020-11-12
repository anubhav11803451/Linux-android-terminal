import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';

class MyCLI extends StatefulWidget {
  final User user;
  final clientID;
  final userDocID;

  MyCLI({this.user, this.clientID, this.userDocID}) : super();
  @override
  _MyCLIState createState() => _MyCLIState();
}

class _MyCLIState extends State<MyCLI> {
  final FirebaseAuth _authc = FirebaseAuth.instance;
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
    "mkdir",
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
        .doc(widget.userDocID)
        .collection("commands")
        .doc();

    reference.set({
      'input': cmd,
      'output': "",
      'clientID': widget.clientID,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[800],
      ),
      body: Stack(children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: HexColor("#011627"),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  height: 350,
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
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          if (history.length - index == 1)
                            Flexible(
                              child: TextField(
                                controller: _textController,
                                maxLines: null,
                                onChanged: (value) {
                                  cmd = value;
                                },
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  border: InputBorder.none,
                                ),
                              ),
                            )
                          else
                            Flexible(
                              child: Text(
                                history[index + 1],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          SizedBox(
                            height: 25,
                          ),
                        ],
                      );
                    },
                  ))),
              Container(
                height: double.infinity,
                width: double.infinity,
                padding: EdgeInsets.all(20),
                //height: 50,
                //width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  children: [
                    Text("output"),
                    SizedBox(
                      height: 10,
                    ),
                    // Container(
                    //   padding: EdgeInsets.all(20),
                    //   height: 100,
                    //   width: double.infinity,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(10),
                    //     boxShadow: [
                    //       new BoxShadow(
                    //           color: Colors.grey[800], blurRadius: 10.0)
                    //     ],
                    //   ),
                    //   child: Flex(
                    //     direction: Axis.vertical,
                    //     children: [
                    //       Expanded(
                    //           child: SingleChildScrollView(
                    //         child: waiting
                    //             ? Center(child: CircularProgressIndicator())
                    //             : Text(output == ""
                    //                 ? "Enter a command"
                    //                 : output),
                    //       )),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          child: Builder(
            builder: (context) => FlatButton(
              child: Container(
                margin: EdgeInsets.all(20),
                height: 50,
                width: 180,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "List of Commands",
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
              onPressed: () {
                SizedBox.expand(
                  child: DraggableScrollableSheet(builder:
                      (BuildContext context,
                          ScrollController scrollController) {
                    return Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue[50],
                        boxShadow: [
                          new BoxShadow(
                              color: Colors.grey[850], blurRadius: 20.0)
                        ],
                      ),
                      child: new ListView.builder(
                          controller: scrollController,
                          itemCount: commands.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                height: double.infinity,
                                width: double.infinity,
                                child: new FlatButton(
                                  child: Text(cmdnames[index]),
                                  onPressed: () {
                                    _textController.text = commands[index];
                                    cmd = _textController.text;
                                  },
                                ));
                          }),
                    );
                  }),
                );
              },
            ),
          ),
        ),
        Positioned(
            top: 350,
            left: 200,
            child: GestureDetector(
              onTap: () {
                sendToWeb();
                if (cmd != null) {
                  history.add(cmd);
                  setState() {
                    count++;
                  }

                  cmd = null;
                  print(history);
                }
              },
              child: FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.play_arrow),
                backgroundColor: HexColor("#2AA298"),
              ),
            ))
      ]),
    );
  }
}

// Container(
//   height: 100,
//   width: 200,
//   color: Colors.red,
//   child: Column(
//     children: [
//       Text("Hello World"),
//       TextField(
//         controller: _textController,
//         onChanged: (value) {
//           command = value;
//         },
//         decoration: InputDecoration(
//           hintText: 'Enter the command',
//         ),
//       ),
//       IconButton(
//           icon: Icon(Icons.send),
//           onPressed: () {
//             inputCommand();
//           })
//     ],
//   ),
// ),
