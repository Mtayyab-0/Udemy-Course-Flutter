import '../models/item_model.dart';
import 'news_api_provider.dart';
import 'news_db_hive.dart';
import 'dart:async';

class Repository {
  List<Source> sources = <Source>[newsDbHive, NewsApiProvider()];
  List<Cache> caches = <Cache>[newsDbHive];
  fetchTopIds() {
    return sources[1].fetchTopIds();
  }

  Future<ItemModel> fetchItem(int id) async {
    ItemModel item;
    var source;
    item = ItemModel.fake();
    for (source in sources) {
      item = await source.fetchItem(id);
      if (!item.isFake()) {
        break;
      }
    }
    if (!item.isFake()) {
      for (Cache cache in caches) {
        if (cache != source) cache.addItem(item);
      }
    }
    return item;
  }

  clearCache() {
    for (Cache cache in caches) {
      cache.clear();
    }
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  void addItem(ItemModel item);
  void clear();
}
