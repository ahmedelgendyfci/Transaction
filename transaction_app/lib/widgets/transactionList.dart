import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function deleteTransaction;
  TransactionList({this.userTransactions, this.deleteTransaction});

  @override
  Widget build(BuildContext context) {
    return userTransactions.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Text(
                'No transaction !',
                // ignore: deprecated_member_use
                style: Theme.of(context).textTheme.title,
              )),
            ],
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text('\$${userTransactions[index].amount}'),
                      ),
                    ),
                  ),
                  title: Text(
                    userTransactions[index].title,
                    // ignore: deprecated_member_use
                    style: Theme.of(context).textTheme.title,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().format(userTransactions[index].date),
                  ),
                  trailing: MediaQuery.of(context).size.width > 460
                      // ignore: deprecated_member_use
                      ? FlatButton.icon(
                          onPressed: () =>
                              deleteTransaction(userTransactions[index].id),
                          icon: Icon(Icons.delete),
                          label: Text('Delete'),
                          textColor: Colors.red,
                        )
                      : IconButton(
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).errorColor,
                          onPressed: () =>
                              deleteTransaction(userTransactions[index].id),
                        ),
                ),
              );
            },
            itemCount: userTransactions.length,
          );
  }
}
