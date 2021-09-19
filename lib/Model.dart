import 'package:flutter/cupertino.dart';

class TrackerModel {
  int? id;
  String? amount;
  String? description;
  int? isIncome;
  String? date;

  TrackerModel(
      this.amount, this.description, this.isIncome, this.id, this.date);

  TrackerModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.description = map['description'];
    this.isIncome = map['isIncome'];
    this.amount = map['amount'];
    this.date = map['date'];
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
      'description': this.description,
      'isIncome': this.isIncome,
      'amount': this.amount,
      'date': this.date,
    };
  }
}

const Color incomeGreen = Color.fromRGBO(38, 105, 60, 0.8);
const Color expenseRed = Color.fromRGBO(247, 45, 38, 0.65);
