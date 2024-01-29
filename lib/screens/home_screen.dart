import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restart_app/restart_app.dart';
import '../common/strings.dart' as strings;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _players = [];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('/players.json');
    final data = await json.decode(response);
    setState(() {
      _players = data["players"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: const Text(strings.homeScreenTitle),
        actions: [
          IconButton(
            onPressed: () => showDummyWorld(context),
            icon: const Icon(Icons.public),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(children: [
        _players.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                    itemCount: _players.length,
                    itemBuilder: (context, index) {
                      return Card(
                          key: ValueKey(_players[index]["id"]),
                          margin: const EdgeInsets.all(8.0),
                          color: Colors.green.shade100,
                          child: ListTile(
                            // leading: CircleAvatar(
                            //   backgroundImage: NetworkImage(_players[index]["image"]),
                            // ),
                            title: Text(_players[index]["name"]),
                            subtitle: Text(_players[index]["club"]),
                            trailing: Text(_players[index]["position"]),
                          ));
                    }),
              )
            : ElevatedButton(
                onPressed: () {
                  readJson();
                },
                child: const Center(
                  child: Text("Load JSON"),
                ))
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDummyDialog(context),
        label: const Text('NO'),
        icon: const Icon(Icons.restart_alt),
        focusColor: Colors.green,
        splashColor: Colors.yellow,
        foregroundColor: Colors.red,
        mouseCursor: SystemMouseCursors.cell,
      ),
    );
  }

  void showDummyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Hello Dialog'),
          content: Text('This is my content text for the dialog.'),
        );
      },
    );
  }

  void showDummyWorld(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Locaion Info'),
          content: Text('You are in Romania!'),
        );
      },
    );
  }
}
