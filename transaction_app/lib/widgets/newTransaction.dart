import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function txHandler;

  NewTransaction({this.txHandler});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();
  DateTime _pickedDate;

  void submitData() {
    String titleInput = titleController.text;
    double amountInput = double.parse(amountController.text);

    if (titleInput.isNotEmpty && amountInput > 0 && _pickedDate != null) {
      widget.txHandler(titleInput, amountInput, _pickedDate);
      // to clear inputs
      titleController.clear();
      amountController.clear();
      // to distroy sheet model bottom
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: titleController,
              // onChanged: (val) => titleInput = val,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
            TextField(
              controller: amountController,
              // onChanged: (val) => amountInput = val,
              decoration: InputDecoration(
                labelText: 'Amount',
                labelStyle: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _pickedDate == null
                    ? Text('No data chosen')
                    : Text(
                        DateFormat.yMMMd().format(_pickedDate),
                      ),
                // ignore: deprecated_member_use
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    ).then((pickDate) {
                      if (pickDate != null) {
                        setState(() {
                          _pickedDate = pickDate;
                        });
                      }
                    });
                  },
                  child: Text(
                    'Choose Date',
                  ),
                ),
              ],
            ),
            // ignore: deprecated_member_use
            FlatButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                'Add TransAction',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                submitData();
              },
            )
          ],
        ),
      ),
    );
  }
}
