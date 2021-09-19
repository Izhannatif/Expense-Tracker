import 'dart:math';

import 'package:expense_tracker/Database/database.dart';
import 'package:expense_tracker/Model.dart';
import 'package:expense_tracker/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddAmountPage extends StatefulWidget {
  const AddAmountPage({Key? key}) : super(key: key);

  @override
  _AddAmountPageState createState() => _AddAmountPageState();
}

class _AddAmountPageState extends State<AddAmountPage> {
  List<TrackerModel?> dataList = [];
  TextEditingController descriptionContrller = new TextEditingController();
  TextEditingController amountContrller = new TextEditingController();
  int? id;
  bool switchValue = false;
  TrackerModel? tracker;
  int? isIncomeSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              saveData();
            },
            child: Container(
              color: expenseRed,
              height: 50,
              width: 80,
              child: Center(
                child: Text(
                  'Save',
                  style: GoogleFonts.montserratAlternates(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
          )
        ],
        title: Text(''),
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            child: switchValue
                ? Center(
                  child: Text(
                      'ADD EXPENSE',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          letterSpacing: 2),
                    ),
                )
                : Center(
                  child: Text(
                      'ADD INCOME',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          letterSpacing: 2),
                    ),
                ),
          ),
          Expanded(child: listView()),
        ],
      ),
    );
  }

  Widget listView() {
    return Container(
        height: MediaQuery.of(context).size.height - 100,
        decoration: BoxDecoration(
            color: Color.fromRGBO(55, 57, 46, 0.2),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50))),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 0, top: 40, bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Income',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: switchValue ? Colors.grey : Colors.white,
                        decoration:
                            switchValue ? TextDecoration.lineThrough : null),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CupertinoSwitch(
                      activeColor: Colors.red,
                      trackColor: Colors.green,
                      onChanged: (value) {
                        setState(() {
                          switchValue = value;
                        });
                      },
                      value: switchValue,
                    ),
                  ),
                  Text(
                    'Expense',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: switchValue ? Colors.white : Colors.grey,
                        decoration:
                            switchValue ? null : TextDecoration.lineThrough),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                style: TextStyle(color: Colors.white,fontSize: 17),
                decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(top: 13.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            amountContrller.clear();
                          });
                        },
                        child: FaIcon(
                          FontAwesomeIcons.times,
                          color: expenseRed,
                          size: 18,
                        ),
                      ),
                    ),
                    hintText: switchValue ? 'Enter Expense' : 'Enter Income',
                    hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold, fontSize: 15)),
                keyboardType: TextInputType.number,
                controller: amountContrller,
                onChanged: (value) {
                  print('amount saved : ${amountContrller.text} PKR');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                style: TextStyle(color: Colors.white,fontSize: 17),
                decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(top: 13.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            descriptionContrller.clear();
                          });
                        },
                        child: FaIcon(
                          FontAwesomeIcons.times,
                          color: expenseRed,
                          size: 18,
                        ),
                      ),
                    ),
                    hintText: switchValue
                        ? 'Description (ie: Fees, Medical etc)'
                        : 'Description (ie: Job, Stocks etc)',
                    hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold, fontSize: 15)),
                keyboardType: TextInputType.text,
                controller: descriptionContrller,
                onChanged: (value) {
                  print('description saved : ${descriptionContrller.text} ');
                },
              ),
            ),
          ],
        ));
  }

  void saveData() async {
    await DatabaseService.db.addDataIntoDB(TrackerModel(
        amountContrller.text,
        descriptionContrller.text,
        switchValue ? 1 : 0,
        id,
        DateFormat.yMMMd().format(DateTime.now())));

    Navigator.pop(context);
  }
}
