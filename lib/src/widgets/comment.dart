import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news/src/widgets/widget_container.dart';
import '../models/item_model.dart';

class Comment extends StatelessWidget {
  late final int itemId;
  late final depth;
  late final Map<int, Future<ItemModel>> itemMap;
  Comment({required this.itemId, required this.itemMap, required this.depth});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: itemMap[itemId],
        builder: (context, AsyncSnapshot<ItemModel> snapshot) {
          if (!snapshot.hasData) {
            return LoadingContainer();
          }
          final item = snapshot.data!;
          final children = <Widget>[
            ListTile(
              title: buildText(item.text),
              subtitle: item.by == "" ? Text("Comment Deleted") : Text(item.by),
              contentPadding: EdgeInsets.only(
                right: 16.0,
                left: 16.0 + (depth * 16.0),
              ),
            ),
            Divider(),
          ];
          snapshot.data!.kids.forEach((kidId) {
            children.add(
                Comment(itemId: kidId, itemMap: itemMap, depth: depth + 1));
          });
          return Column(
            children: children,
          );
        });
  }

  Widget buildText(String text) {
    final newText = text
        .replaceAll('&#x27;', "'")
        .replaceAll('<p>', '\n\n')
        .replaceAll('</p>', "")
        .replaceAll('&#x2F;', '/');
    return Text(newText);
  }
}
