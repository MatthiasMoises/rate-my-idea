import 'package:flutter/material.dart';

import '../models/criterion.dart';

class CriterionDragItem extends StatelessWidget {
  final Criterion criterion;
  final int acceptedData;

  const CriterionDragItem({
    required this.criterion,
    required this.acceptedData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<Criterion>(
      // Data is the value this Draggable stores.
      data: criterion,
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.lightBlueAccent,
        child: Center(
          child: Text(criterion.name),
        ),
      ),
      feedback: Container(
        color: Colors.deepOrange,
        height: 100,
        width: 100,
        child: const Icon(Icons.add),
      ),
      childWhenDragging: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.pinkAccent,
        child: Center(
          child: Text(criterion.name),
        ),
      ),
    );
  }
}
