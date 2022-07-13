import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      drawer: MainDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.approval,
              size: 46.0,
              color: Colors.grey,
            ),
            SizedBox(height: 10.0),
            Text(
              'This is an App',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 10.0),
            Text(
              'Version 1.0',
              style: Theme.of(context).textTheme.headline5,
            )
          ],
        ),
      ),
    );
  }
}
