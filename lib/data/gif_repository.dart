import 'gif.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class GifRepository { //инкапсулируем логику получения данных
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
}
