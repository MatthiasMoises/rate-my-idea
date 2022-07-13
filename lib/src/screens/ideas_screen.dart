import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/idea_item.dart';
import '../models/idea.dart';
import '../providers/ideas.dart';

class IdeasScreen extends StatefulWidget {
  @override
  _IdeasScreenState createState() => _IdeasScreenState();
}

class _IdeasScreenState extends State<IdeasScreen> {
  late List<Idea> _ideas;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Future.delayed(Duration(milliseconds: 500)).then((_) {
        Provider.of<Ideas>(context, listen: false).fetchIdeas().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _ideas = context.watch<Ideas>().ideas;

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : (_ideas.length > 0)
            ? ListView.builder(
                itemCount: _ideas.length,
                itemBuilder: (ctx, index) {
                  return IdeaItem(idea: _ideas[index]);
                },
              )
            : Center(
                child: Text('You have no idea...'),
              );
  }
}
