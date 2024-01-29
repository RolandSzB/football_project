import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            onPressed: () {
              _openSearch(context);
            },
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
        label: const Text('Refresh'),
        icon: const Icon(Icons.restart_alt),
        backgroundColor: Colors.green,
        foregroundColor: Colors.black,
        mouseCursor: SystemMouseCursors.cell,
      ),
    );
  }

  void _openSearch(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(strings.searchScreenTitle),
            ),
          );
        },
      ),
    );
  }

  void showDummyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Refresh'),
        );
      },
    );
  }

  showDummyWorld(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDateTime = "${now.toLocal()}".split('.')[0];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Info'),
          content: Text(
              'You are in Romania!\nCurrent Date and Time: $formattedDateTime'),
        );
      },
    );
  }
}
