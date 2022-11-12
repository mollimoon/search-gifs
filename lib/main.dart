import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Gif>> getGifs(String search) async {
  if (search.isEmpty) return []; //пустой запрос

  const apiKey = ''; // TODO: Insert API key
  final response = await http.get(Uri.parse(
      'https://api.giphy.com/v1/gifs/search?api_key=$apiKey&q=$search&limit=18&offset=0&rating=g&lang=en'));

  // If the server did return a 200 OK response,
  // then parse the JSON.
  if (response.statusCode == 200) {
    //если есть данные есть body. The body is always String
    final json = jsonDecode(response.body);
    final dataList = json['data'];
    final list = dataList
        .map<Gif>((item) => Gif.fromJson(item['images']['original']))
        .toList();
    return list;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Gif {
  final String url;

  Gif({
    required this.url,
  });

  factory Gif.fromJson(Map<String, dynamic> json) {
    return Gif(
      url: json['url'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var _searchQuery = ''; //хранит поисковый запрос

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: Scaffold(
          // appBar: AppBar(
          //   title: const Text("🖤 Itachi"),
          // ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onFieldSubmitted: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          _searchQuery = value;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                FutureBuilder<List<Gif>>(
                  future: getGifs(_searchQuery),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Image.network(snapshot
                              .data![index].url); // SizedBox(height: 50,),
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
