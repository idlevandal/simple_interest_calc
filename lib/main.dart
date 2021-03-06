import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:validators/validators.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.indigo,
        accentColor: Colors.indigoAccent,
      ),
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _formKey = GlobalKey<FormState>();

//  List<String> _currencies = ['Rupees', 'Dollars', 'Pounds'];
  List<Map<String, String>> _currencyMap = [
    {'name': 'Rupees', 'locale': 'in_IN', 'symbol': '₹'},
    {'name': 'Dollars', 'locale': 'en_US', 'symbol': '\$'},
    {'name': 'Pound', 'locale': 'en_UK', 'symbol': '£'},
  ];

  final _minimumPadding = 5.0;
  String _currentItemSelected = 'Dollars';

  TextEditingController principalController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController termController = TextEditingController();

  String displayResult = '';

  @override
  Widget build(BuildContext context) {
    // needs to be here to get context
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
//      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Simple Interest Calculator'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(_minimumPadding * 2),
          child: ListView(
            children: <Widget>[
              getImageAsset(),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: TextFormField(
                    controller: principalController,
                    keyboardType: TextInputType.number,
                    style: textStyle,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter prinicpal amount!';
                      } else if (!isNumeric(value)){
                        principalController.text = '';
                        return 'Numeric values only!';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                        labelText: 'Principal',
                        hintText: 'Enter Principal e.g. 1',
                        errorStyle: TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: 15.0
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(_minimumPadding)))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: TextFormField(
                    controller: rateController,
                    keyboardType: TextInputType.number,
                    style: textStyle,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter interest rate';
                      } else if (!isNumeric(value)){
                        rateController.text = '';
                        return 'Numeric values only!';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                        labelText: 'Rate of Interest',
                        hintText: 'In percent',
                        errorStyle: TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: 15.0
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                          controller: termController,
                          keyboardType: TextInputType.number,
                          style: textStyle,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Please enter the term';
                            } else if (!isNumeric(value)){
                              termController.text = '';
                              return 'Numeric values only!';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                              labelText: 'Term',
                              hintText: 'Time in years',
                              errorStyle: TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 15.0
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0)))),
                    ),
                    SizedBox(
                      width: _minimumPadding * 5,
                    ),
                    Expanded(
                      child: DropdownButton(
                        items: _currencyMap.map((value) {
                          return DropdownMenuItem<String>(
                            value: value['name'],
                            child: Text(value['name']),
                          );
                        }).toList(),
                        value: _currentItemSelected,
                        onChanged: (String newValueSelected) {
                          setState(() {
                            _currentItemSelected = newValueSelected;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              Divider(color: Colors.grey[500],),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton.icon(
                        icon: Icon(FontAwesomeIcons.calculator),
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).primaryColorDark,
                        label: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            'Calculate',
                            textScaleFactor: 1.5,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            if (_formKey.currentState.validate()) {
                              displayResult = _calculateTotalReturns();
                            }
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RaisedButton.icon(
                        icon: Icon(FontAwesomeIcons.undo),
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        label: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            'Reset',
                            textScaleFactor: 1.5,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _reset();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(_minimumPadding * 2),
                child: Text(
                  displayResult.length < 1 ? displayResult : 'Total: $displayResult',
                  style: textStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getImageAsset() {
    return Container(
      child: Image.asset(
        'images/business-and-finance.png',
        height: 125.0,
        width: 125.0,
      ),
      margin: EdgeInsets.all(_minimumPadding * 10),
    );
  }

  String _calculateTotalReturns() {
    double principal = double.parse(principalController.text);
    double rate = double.parse(rateController.text);
    double term = double.parse(termController.text);
    double result = principal + (principal * rate * term) / 100;

    var location =
        _currencyMap.firstWhere((cur) => cur['name'] == _currentItemSelected);

    var numFormat = new NumberFormat.currency(
        locale: '${location['locale']}',
        symbol: '${location['symbol']}',
        decimalDigits: 2);

    return numFormat.format(result);
  }

  void _reset() {
    // this MUST go before clearing text otherwise textFormFields don't clear!
    _formKey.currentState.reset();

    principalController.text = '';
    rateController.text = '';
    termController.text = '';
    displayResult = '';
    _currentItemSelected = _currencyMap[1]['name'];
  }
}
