import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/idea.dart';
import '../providers/ideas.dart';
import '../utils/navigation_helper.dart';
import '../utils/constants.dart';

class IdeaItem extends StatelessWidget {
  final Idea idea;

  const IdeaItem({required this.idea, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(idea.id.toString()),
      onDismissed: (direction) {
        Provider.of<Ideas>(context, listen: false).deleteIdea(idea.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Idea deleted'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 75.0,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.all(15.0),
        elevation: 5.0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                idea.title,
                style: Theme.of(context).textTheme.headline5,
              ),
              (idea.imageName != '')
                  ? Image.network(
                      '$publicBucketUrl/${idea.imageName}',
                      fit: BoxFit.cover,
                    )
                  : const Image(
                      image: AssetImage('assets/images/placeholder.png'),
                      fit: BoxFit.cover,
                    ),
              SizedBox(height: 10.0),
              Text(
                idea.description,
                overflow: TextOverflow.fade,
                maxLines: 3,
                softWrap: false,
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () =>
                        navigateToIdeaActionScreen(context, 'rate', idea),
                    child: Text('Rate Idea'),
                  ),
                  OutlinedButton(
                    onPressed: () =>
                        navigateToIdeaActionScreen(context, 'edit', idea),
                    child: Text('Edit Idea'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
