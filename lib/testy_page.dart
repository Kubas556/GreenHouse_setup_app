import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Testy extends StatefulWidget {
  @override
  _TestyState createState() => _TestyState();
}

class _TestyState extends State<Testy> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Greenhouse config App"),
          backgroundColor: Colors.lightGreen,
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(text: "test1"),
              Tab(text: "test2"),
              Tab(text: "test3")
            ],
          ),
        ),
        body: Center(
          child: TabBarView(
            children: [
              Column(children: [FlatButton(
                child: Text("test 1"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return Text("push");
                      })
                  );
                },
              )]),
              Column(children: [Text("test 2")]),
              Column(children: [Text("test 3")])
            ],
          ),
        ),
      ),
    );
  }
}
