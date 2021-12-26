import 'package:flutter/material.dart';
import 'package:news/src/models/item_model.dart';
import 'package:news/src/widgets/comment.dart';
import '../blocs/comments_provider.dart';

class NewsDetail extends StatelessWidget {
  late final int itemId;
  NewsDetail({required this.itemId});
  @override
  Widget build(BuildContext context) {
    final bloc = CommentProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
        stream: bloc.itemWithComments,
        builder:
            (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading...");
          }
          final itemFuture = snapshot.data![itemId];
          return FutureBuilder(
              future: itemFuture,
              builder: (context, AsyncSnapshot<ItemModel> itemSnapShot) {
                if (!itemSnapShot.hasData) {
                  return Text("Loading...");
                }
                return buildList(itemSnapShot.data!, snapshot.data!);
              });
        });
  }

  Widget buildList(ItemModel item, Map<int, Future<ItemModel>> itemMap) {
    final children = <Widget>[];
    children.add(buildTitle(item));
    final commentList = item.kids.map((kidId) {
      return Comment(itemId: kidId, itemMap: itemMap, depth: 0);
    }).toList();
    children.addAll(commentList);
    return ListView(
      children: children,
    );
  }

  Widget buildTitle(ItemModel item) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.all(10.0),
      child: Text(
        item.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
