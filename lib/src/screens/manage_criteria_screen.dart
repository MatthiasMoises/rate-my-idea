import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/criterion.dart';
import '../providers/criteria.dart';
import '../widgets/criterion_drag_item.dart';

class ManageCriteriaScreen extends StatefulWidget {
  const ManageCriteriaScreen({Key? key}) : super(key: key);

  @override
  _ManageCriteriaScreenState createState() => _ManageCriteriaScreenState();
}

class _ManageCriteriaScreenState extends State<ManageCriteriaScreen> {
  late List<Criterion> _criteria;
  var _isInit = true;
  var _isLoading = false;
  int _acceptedData = 0;
  final List<Criterion?> _assignedCriteria = [];

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(Duration(milliseconds: 500)).then((_) {
        Provider.of<Criteria>(context, listen: false).fetchCriteria().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _removeAssignedCriterion(Criterion criterion) {
    setState(() {
      _assignedCriteria.remove(criterion);
    });
  }

  @override
  Widget build(BuildContext context) {
    _criteria = context.watch<Criteria>().critera;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Criteria'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, _assignedCriteria);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              DragTarget<Criterion>(
                builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejected,
                ) {
                  return Container(
                    width: double.infinity,
                    height: 200.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.orange,
                        width: 2.0,
                      ),
                    ),
                    child: (_assignedCriteria.length > 0)
                        ? ListView(
                            scrollDirection: Axis.vertical,
                            children: _assignedCriteria
                                .map(
                                  (criterion) => ListTile(
                                    title: Text(criterion!.name),
                                    trailing: GestureDetector(
                                      child: Icon(Icons.remove_circle),
                                      onTap: () =>
                                          _removeAssignedCriterion(criterion),
                                    ),
                                  ),
                                )
                                .toList(),
                          )
                        : Center(
                            child: Text('Nothing assigned...'),
                          ),
                  );
                },
                onAccept: (Criterion criterion) {
                  setState(() {
                    _assignedCriteria.add(criterion);
                  });
                },
              ),
              SizedBox(height: 20.0),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : (_criteria.length > 0)
                      ? ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: _criteria.length,
                          itemBuilder: (ctx, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10.0),
                              child: CriterionDragItem(
                                criterion: _criteria[index],
                                acceptedData: _acceptedData,
                              ),
                            );
                          },
                        )
                      : Center(
                          child: const Text('No criteria available...'),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
