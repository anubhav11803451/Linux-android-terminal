// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class MyDockerApp extends StatefulWidget {
//   @override
//   _MyDockerAppState createState() => _MyDockerAppState();
// }

// class _MyDockerAppState extends State<MyDockerApp> {
//   String cmd;

//   String imageName;

//   bool waiting = false;

//   List history = ["docker run -it centos:7"];

//   int count;

//   String output = "";

//   List commands = [
//     "docker ps",
//     "docker images",
//     "docker network ls",
//     "docker volume ls",
//     "docker inspect <enter_name>",
//     "docker run -dit --name <enter_name> centos:7",
//     "docker stop <enter_name>",
//     "docker rm -f \$(docker ps -a -q)"
//   ];

//   List cmdnames = [
//     "List all docker containers",
//     "List all docker images",
//     "List all docker networks",
//     "List all docker volumes",
//     "Inspect",
//     "Launch new docker",
//     "Stop a docker",
//     "Delete all dockers"
//   ];

//   final myController = TextEditingController();

//   var ip = "192.168.225,205";

//   @override
//   initState() {
//     count = 0;
//   }

//   web() async {
//     String newcmd = cmd?.replaceAll(" ", "_"); //if cmd is null,? checks it

//     var url = "http://$ip/cgi-bin/script.py?x=${newcmd}";
//     setState(() {
//       waiting = true;
//       myController.text = "";
//     });
//     var response = await http.get(url);
//     setState(() {
//       waiting = false;
//     });
//     print(response.body);
//     var temp = jsonDecode(response.body.toString());
//     output = temp['output'];
//     print(cmd);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: AppBar(
//           backgroundColor: Colors.blue[50],
//         ),
//         body: Center(
//           child: Stack(children: [
//             Container(
//                 width: double.infinity,
//                 height: double.infinity,
//                 color: Color(0x011627),
//                 child: Column(
//                   children: <Widget>[
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       height: 350,
//                       child: Flexible(
//                           //what is flexible
//                           child: new ListView.builder(
//                         itemCount: history.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           return new Row(
//                             children: [
//                               SizedBox(
//                                 width: 20,
//                               ),
//                               Text(
//                                 "Bash \$ ",
//                                 style: TextStyle(color: Colors.red),
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               if (history.length - index == 1) //doubt
//                                 Flexible(
//                                     child: TextField(
//                                   controller: myController,
//                                   maxLines: null,
//                                   onChanged: (value) {
//                                     cmd = value;
//                                   },
//                                   style: TextStyle(color: Colors.white),
//                                   decoration: InputDecoration(
//                                     contentPadding: EdgeInsets.all(10),
//                                     border: InputBorder.none,
//                                   ),
//                                 ))
//                               else
//                                 Flexible(
//                                     child: Text(
//                                   history[index +
//                                       1], //doubt: what's happening here?
//                                   style: TextStyle(color: Colors.white),
//                                 )),
//                               SizedBox(
//                                 height:
//                                     25, //doubt: what's this for? probably padding
//                               )
//                             ],
//                           );
//                         },
//                       )),
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(20),
//                       color: Colors.white,
//                       height: double.infinity,
//                       width: double.infinity,
//                       child: Column(
//                         children: <Widget>[
//                           Text("output"),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Container(
//                             padding: EdgeInsets.all(20),
//                             height: 100,
//                             width: 350, //line 155
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(20),
//                               boxShadow: [
//                                 new BoxShadow(
//                                     color: Colors.grey[800], blurRadius: 20.0)
//                               ],
//                             ),
//                             child: Flex(
//                                 direction: Axis.vertical,
//                                 children: <Widget>[
//                                   Expanded(
//                                       child: SingleChildScrollView(
//                                           child: waiting
//                                               ? Center(
//                                                   child:
//                                                       CircularProgressIndicator())
//                                               : Text(output == ""
//                                                   ? "Enter a Command"
//                                                   : output))),
//                                 ]),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 )),
//             Positioned(
//               bottom: 20,
//               child: Builder(
//                 builder: (context) => FlatButton(
//                   child: Container(
//                     margin: EdgeInsets.all(20),
//                     height: 50,
//                     width: 180,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[50],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Text(
//                       "List of Commands",
//                       style: TextStyle(color: Colors.grey[400]),
//                     ),
//                   ),
//                   onPressed: () {
//                     SizedBox.expand(
//                       child: DraggableScrollableSheet(
//                         builder: (BuildContext context,
//                             ScrollController scrollController) {
//                           return Container(
//                             height: 400,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               color: Colors.blue[50],
//                               boxShadow: [
//                                 new BoxShadow(
//                                     color: Colors.grey[850], blurRadius: 20.0)
//                               ],
//                             ),
//                             child: new ListView.builder(
//                                 controller: scrollController,
//                                 itemCount: commands.length,
//                                 itemBuilder: (BuildContext context, int index) {
//                                   return Container(
//                                       height: double.infinity,
//                                       width: double.infinity,
//                                       child: new FlatButton(
//                                           child: Text(cmdnames[index]),
//                                           onPressed: () {
//                                             myController.text = commands[index];
//                                             cmd = myController.text;
//                                           }));
//                                 }),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             Positioned(
//                 top: 350,
//                 left: 200, //doubt--> self positioned like MediaQuery
//                 child: GestureDetector(
//                     onTap: () {
//                       web();
//                       if (cmd != null) {
//                         history.add(cmd);
//                         setState() {
//                           count++;
//                         }

//                         cmd = null;
//                         print(history);
//                       }
//                     },
//                     child: FloatingActionButton(
//                       onPressed: () {},
//                       child: Icon(Icons.play_arrow),
//                       backgroundColor: Color(0x2AA298),
//                     )))
//           ]),
//         ),
//       ),
//     );
//   }
// }
