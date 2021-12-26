import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class CommentsBloc {
  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _repository = Repository();
  //stream getter
  Stream<Map<int, Future<ItemModel>>> get itemWithComments =>
      _commentsOutput.stream;
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;
  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }

  _commentsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
        (cache, int id, index) {
      print(index);
      cache[id] = _repository.fetchItem(id);
      cache[id]!.then((ItemModel item) {
        item.kids.forEach((element) {
          fetchItemWithComments(element);
        });
      });
      return cache;
    }, <int, Future<ItemModel>>{});
  }
}
