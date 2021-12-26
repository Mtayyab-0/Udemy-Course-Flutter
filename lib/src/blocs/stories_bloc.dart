import 'package:rxdart/rxdart.dart';
import '..//models/item_model.dart';
import '..//resources/repository.dart';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemsFetcher = PublishSubject<int>();

  //Getters to Streams
  Stream<List<int>> get topIds => _topIds.stream;
  Stream<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  //Getter to Sinks
  Function(int) get fetchitem => _itemsFetcher.sink.add;

  StoriesBloc() {
    _itemsFetcher.stream.transform(itemsTransformer()).pipe(_itemsOutput);
  }

  itemsTransformer() {
    return ScanStreamTransformer(
        (Map<int, Future<ItemModel>> cache, int id, index) {
      cache[id] = _repository.fetchItem(id);
      return cache;
    }, <int, Future<ItemModel>>{});
  }

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  Future<int?> clearCache() {
    return _repository.clearCache();
  }

  dipose() {
    _topIds.close();
    _itemsOutput.close();
    _itemsFetcher.close();
  }
}
