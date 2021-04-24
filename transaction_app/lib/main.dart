import 'package:flutter/material.dart';
import 'package:transaction_app/widgets/chart.dart';
import 'package:transaction_app/widgets/newTransaction.dart';
import 'package:transaction_app/widgets/transactionList.dart';
import './models/transaction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      home: MyHomePage(),
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.purple,
          errorColor: Colors.red,
          textTheme: ThemeData.light().textTheme.copyWith(
                  // ignore: deprecated_member_use
                  title: TextStyle(
                fontFamily: 'BarlowCondensed',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              )),
          fontFamily: 'BarlowCondensed',
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                      // ignore: deprecated_member_use
                      title: TextStyle(
                    fontFamily: 'BarlowCondensed',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  )))),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;

  final List<Transaction> _userTransactions = [
    Transaction(
        id: 't1', title: 'transaction 1', amount: 55.99, date: DateTime.now()),
    Transaction(
        id: 't2', title: 'transaction 2', amount: 199, date: DateTime.now()),
    Transaction(
        id: 't3', title: 'transaction 3', amount: 55.99, date: DateTime.now()),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addTransaction(String title, double amount, DateTime pickedDate) {
    final newTx = Transaction(
        title: title,
        amount: amount,
        date: pickedDate,
        id: DateTime.now().toString());

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  // bottom model cheet
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        builder: (context) {
          return SingleChildScrollView(
              child: Container(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.top),
            child: GestureDetector(
              onTap: () {},
              child: NewTransaction(txHandler: _addTransaction),
              behavior: HitTestBehavior.opaque,
            ),
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    bool _isLandscapMode =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final appBar = AppBar(
      title: const Text('Expense Tracker'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        )
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isLandscapMode)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show Chart'),
                  Switch(
                    value: _showChart,
                    onChanged: (value) {
                      setState(() {
                        _showChart = value;
                      });
                    },
                  ),
                ],
              ),
            if (!_isLandscapMode) ChartWidget(0.3, appBar, _recentTransactions),
            if (!_isLandscapMode)
              ListWidgets(0.661, appBar, _userTransactions, deleteTransaction),
            if (_isLandscapMode)
              _showChart
                  ? ChartWidget(0.7, appBar, _recentTransactions)
                  : ListWidgets(
                      1, appBar, _userTransactions, deleteTransaction),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}

class ListWidgets extends StatelessWidget {
  final double heightPercentage;
  final AppBar appBar;
  final List<Transaction> userTransactions;
  final Function deleteTransaction;

  ListWidgets(
    this.heightPercentage,
    this.appBar,
    this.userTransactions,
    this.deleteTransaction,
  );

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          heightPercentage,
      child: TransactionList(
        userTransactions: userTransactions,
        deleteTransaction: deleteTransaction,
      ),
    );
  }
}

class ChartWidget extends StatelessWidget {
  final AppBar appBar;
  final List<Transaction> recentTransactions;
  final double heightPercentage;

  ChartWidget(this.heightPercentage, this.appBar, this.recentTransactions);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          heightPercentage,
      child: Chart(recentTransactions),
    );
  }
}
