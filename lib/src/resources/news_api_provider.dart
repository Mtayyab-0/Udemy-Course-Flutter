import 'dart:convert';
import '../models/item_model.dart';
import 'repository.dart';
import 'package:http/http.dart' show Client;

class NewsApiProvider implements Source {
  Client client = Client();
  final _root = 'https://hacker-news.firebaseio.com/v0';
  Future<List<int>> fetchTopIds() async {
    final response = await client.get(Uri.parse('$_root/topstories.json'));
    final ids = json.decode(response.body);
    return ids.cast<int>();
  }

  Future<ItemModel> fetchItem(int id) async {
    final response = await client.get(Uri.parse('$_root/item/$id.json'));
    final Map<String, dynamic> parsedJson = jsonDecode(response.body);
    ItemModel im = ItemModel.fromJson(parsedJson);
    return im;
  }
}
