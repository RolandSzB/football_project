import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  void _openSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: PlayerSearchDelegate(_players, showDetailsPopup),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: () {},
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
      body: Column(
        children: [
          _players.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: _players.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_players[index]["name"]),
                        subtitle: Text(_players[index]["club"]),
                        trailing: Text(_players[index]["position"]),
                      );
                    },
                  ),
                )
              : ElevatedButton(
                  onPressed: () {
                    readJson();
                  },
                  child: const Center(
                    child: Text("Load footballers"),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Refresh'),
        icon: const Icon(Icons.restart_alt),
        backgroundColor: Colors.green,
        foregroundColor: Colors.black,
        mouseCursor: SystemMouseCursors.cell,
      ),
    );
  }

  void showDetailsPopup(
      BuildContext context, Map<String, dynamic> playerDetails) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Player Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${playerDetails["name"]}'),
              Text('Club: ${playerDetails["club"]}'),
              Text('Position: ${playerDetails["position"]}'),
              Text('Age: ${playerDetails["age"]}'),
              Text('Height: ${playerDetails["height"]}'),
              Text('Foot: ${playerDetails["foot"]}'),
            ],
          ),
        );
      },
    );
  }
}

class PlayerSearchDelegate extends SearchDelegate<String> {
  final List players;
  final Function(BuildContext, Map<String, dynamic>) showDetailsCallback;

  PlayerSearchDelegate(this.players, this.showDetailsCallback);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchResults = players
        .where((player) =>
            player["name"].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(searchResults[index]["name"]),
          subtitle: Text(searchResults[index]["club"]),
          trailing: Text(searchResults[index]["position"]),
          onTap: () {
            showDetailsCallback(context, searchResults[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = players
        .where((player) =>
            player["name"].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index]["name"]),
          subtitle: Text(suggestionList[index]["club"]),
          trailing: Text(suggestionList[index]["position"]),
          onTap: () {
            // Call the method to show details
            showDetailsCallback(context, suggestionList[index]);
          },
        );
      },
    );
  }
}
