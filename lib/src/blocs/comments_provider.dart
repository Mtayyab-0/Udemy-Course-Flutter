import 'package:flutter/material.dart';
import 'comments_bloc.dart';
export 'comments_bloc.dart';

class CommentProvider extends InheritedWidget {
  final CommentsBloc bloc;
  CommentProvider({Key? key, required Widget child})
      : bloc = CommentsBloc(),
        super(key: key, child: child);
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static CommentsBloc of(BuildContext context) {
    return (context
        .dependOnInheritedWidgetOfExactType<CommentProvider>()!
        .bloc);
  }
}
