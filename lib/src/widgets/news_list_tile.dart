import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:news/src/widgets/widget_container.dart';
import '..//models/item_model.dart';
import '../blocs/stories_provider.dart';

class NewsListTiles extends StatelessWidget {
  late final int itemId;
  NewsListTiles(int id) {
    itemId = id;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        } else {
          return FutureBuilder(
            initialData: ItemModel.fake(),
            future: snapshot.data![itemId],
            builder: (context, AsyncSnapshot<ItemModel> itemsnapshot) {
              if (itemsnapshot.connectionState == ConnectionState.waiting) {
                return LoadingContainer();
              } else if (itemsnapshot.hasError) {
                return Text(itemsnapshot.error.toString());
              } else if (itemsnapshot.hasData) {
                return Column(
                  children: [
                    buildTile(itemsnapshot.data, context),
                    Divider(
                      height: 10.0,
                    )
                  ],
                );
              } else
                return Text('Idamncare');
            },
          );
        }
      },
    );
  }

  Widget buildTile(ItemModel? im, BuildContext context) {
    return ListTile(
      title: Text(im != null ? im.title : 'Item Not Found',
          style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(im != null ? im.score.toString() + 'points' : ''),
      trailing: Column(
        children: [
          Icon(Icons.comment),
          Text(im != null ? im.descendants.toString() : '')
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, '/${im!.id}');
      },
    );
  }
}
