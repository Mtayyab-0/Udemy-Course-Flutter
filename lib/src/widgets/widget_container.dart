import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: buildContainer(),
          subtitle: buildContainer(),
        ),
        Divider(
          height: 10.0,
        )
      ],
    );
  }

  Widget buildContainer() {
    return Container(
      color: Colors.grey[400],
      height: 24,
      width: 150,
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
    );
  }
}
