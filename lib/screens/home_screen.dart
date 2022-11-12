import 'package:flutter/material.dart';
import 'package:gif_loader/data/gif_repository.dart';

import '../data/gif.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _gifRepository = GifRepository(); //положили в переменную

  var _searchQuery = ''; //хранит поисковый запрос

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
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
                  future: _gifRepository.getGifs(_searchQuery),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(snapshot.data![index].url),
                          ); // SizedBox(height: 50,),
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
