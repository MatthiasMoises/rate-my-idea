import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/criterion.dart';
import '../providers/criteria.dart';

class CriterionItem extends StatelessWidget {
  final Criterion criterion;

  const CriterionItem({required this.criterion, Key? key}) : super(key: key);

  Future<void> deleteCriterion(BuildContext context, int id) async {
    Provider.of<Criteria>(context, listen: false).deleteCriterion(id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(),
        ),
      ),
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        title: Text(criterion.name),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              child: Icon(
                Icons.edit,
              ),
              onTap: () => null,
            ),
            GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onTap: () => deleteCriterion(context, criterion.id),
            ),
          ],
        ),
      ),
    );
  }
}
