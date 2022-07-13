import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/criterion.dart';
import '../providers/criteria.dart';
import '../widgets/criterion_item.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late List<Criterion> _criteria;
  var _isInit = true;
  var _isLoading = false;
  late final TextEditingController _nameController;
  late final TextEditingController _minScoreController;
  late final TextEditingController _maxScoreController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _nameController = TextEditingController();
    _minScoreController = TextEditingController();
    _maxScoreController = TextEditingController();
    super.initState();
  }

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

  @override
  void dispose() {
    _nameController.dispose();
    _minScoreController.dispose();
    _maxScoreController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    final isValid = _formKey.currentState!.validate();

    if (!isValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      Provider.of<Criteria>(context, listen: false).createCriterion(
        _nameController.text,
        int.parse(_minScoreController.text),
        int.parse(_maxScoreController.text),
      );

      _nameController.clear();
      _minScoreController.clear();
      _maxScoreController.clear();
    } catch (e) {
      throw e;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _criteria = context.watch<Criteria>().critera;

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.cyan,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _minScoreController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Min Score',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.cyan,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a number';
                            }

                            final number = num.tryParse(value);

                            if (number == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _maxScoreController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Max Score',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.cyan,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a number';
                            }

                            final number = num.tryParse(value);

                            if (number == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _saveForm,
                  child: Text('Save'),
                ),
                (_criteria.length > 0)
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _criteria.length,
                        itemBuilder: (ctx, index) {
                          return CriterionItem(criterion: _criteria[index]);
                        },
                      )
                    : Center(
                        child: Text('You have no criteria...'),
                      )
              ],
            ),
          );
  }
}
