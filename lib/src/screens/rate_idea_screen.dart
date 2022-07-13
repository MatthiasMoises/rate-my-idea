import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/idea.dart';
import '../models/criterion.dart';
import '../providers/criteria.dart';

class RateIdeaScreen extends StatefulWidget {
  final Idea idea;
  const RateIdeaScreen({
    required this.idea,
    Key? key,
  }) : super(key: key);

  @override
  _RateIdeaScreenState createState() => _RateIdeaScreenState();
}

class _RateIdeaScreenState extends State<RateIdeaScreen> {
  late List<Criterion> _criteria;
  var _isInit = true;
  var _isLoading = false;
  List _sliderValues = [];
  var _defaultSliderValue = 3.0;

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
  Widget build(BuildContext context) {
    _criteria = context.watch<Criteria>().critera;

    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Idea'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (_criteria.length > 0)
              ? Center(
                  child: Column(
                    children: [
                      Text(widget.idea.title),
                      Text(widget.idea.description),
                      Column(
                        children: _criteria.map((criterion) {
                          var index = _criteria.indexOf(criterion);

                          _sliderValues.add(_defaultSliderValue);

                          return Row(
                            children: [
                              Text(criterion.name),
                              Slider(
                                value: _sliderValues[index],
                                min: criterion.minScore.toDouble(),
                                max: criterion.maxScore.toDouble(),
                                divisions: 5,
                                label: _sliderValues[index].round().toString(),
                                onChanged: (double value) {
                                  setState(() {
                                    _sliderValues[index] = value;
                                  });
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Text('No criteria available...'),
                ),
    );
  }
}
