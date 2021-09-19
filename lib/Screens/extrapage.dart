
import 'package:flutter/material.dart';

class ExtraPage extends StatefulWidget {
  const ExtraPage({ Key? key }) : super(key: key);

  @override
  _ExtraPageState createState() => _ExtraPageState();
}

class _ExtraPageState extends State<ExtraPage> {
  List <String> incomes = [];
  List <String> expenses = [];
  List subtitle = [];
  @override
  Widget build(BuildContext context) {
    return 
DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Container(
              padding: EdgeInsets.only(left: 40),
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  alertDialog(context);
                },
              ),
            ),
          ],
          centerTitle: true,
          title: Text('Finance Manager'),
          backgroundColor: Colors.blueGrey.shade900,
          bottom: TabBar(
            tabs: [
              Text(
                'Incomes',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Expenses',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: Center(
                child: incomeList(),
              ),
            ),
            Container(
              child: Center(
                child: expenseList(),
              ),
            ),
          ],
        ),
        bottomSheet: bottomSheet(),
      ),
    );
  }

  alertDialog(BuildContext context) {
    TextEditingController incomeController = new TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
              title: Column(
                children: [
                  Text('What Do you want to Add ? '),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return Scaffold(
                            appBar: AppBar(
                              backgroundColor: Colors.blueGrey.shade900,
                              title: Text('Add your Income'),
                              centerTitle: true,
                              leading: IconButton(
                                icon: Icon(Icons.home),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            body: Container(
                              child: Column(
                                children: [
                                  TextField(
                                    controller: incomeController,
                                    autofocus: true,
                                    onSubmitted: (val) {
                                      addIncomeFunction(val);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(20),
                                        hintText: 'Enter your Income...',
                                        border: InputBorder.none),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextField(
                                    autofocus: false,
                                    onSubmitted: (title) {
                                      addIncomeTitlesFunction(title);
                                      Navigator.pop(context);
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(20),
                                        hintText: 'Description...',
                                        border: InputBorder.none),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Income',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))
                        ],
                      )),
                  Divider(
                    indent: 80,
                    endIndent: 80,
                  ),
                  Text('Or'),
                  Divider(
                    indent: 80,
                    endIndent: 80,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return Scaffold(
                            appBar: AppBar(
                              backgroundColor: Colors.blueGrey.shade900,
                              title: Text('Add your Expense'),
                              centerTitle: true,
                              leading: IconButton(
                                icon: Icon(Icons.home),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            body: Container(
                              child: Column(
                                children: [
                                  TextField(
                                    autofocus: true,
                                    onSubmitted: (val) {
                                      addExpenseFunction(val);
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(20),
                                        hintText: 'Enter your Income...',
                                        border: InputBorder.none),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextField(
                                    autofocus: false,
                                    onSubmitted: (val) {
                                      addExpenseFunction(val);
                                      Navigator.pop(context);
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(20),
                                        hintText: 'Description...',
                                        border: InputBorder.none),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Expense',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))
                        ],
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700),
                    ),
                  ),
                ],
              ),
            ));
  }

  void addIncomeFunction(String income) {
    setState(() {
      incomes.add( income);
    });
  }

  void addIncomeTitlesFunction(String title) {
    setState(() {
      subtitle.add(title);
    });
  }

  void addExpenseFunction(String expense) {
    setState(() {
      expenses.add(expense);
    });
  }

  ListView incomeList() {
    return ListView.separated(
        itemBuilder: (BuildContext context, index) {
          return ListTile(
            title: Text(
              'PKR ' + incomes[index],
              style: TextStyle(color: Colors.green),
            ),
            subtitle: Text(subtitle[index]),
          );
        },
        separatorBuilder: (BuildContext context, index) {
          return Divider();
        },
        itemCount: incomes.length);
  }

  ListView expenseList() {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              'PKR ' + expenses[index],
              style: TextStyle(color: Colors.red.shade600),
            ),
            subtitle: Text('Expense'),
          );
        },
        separatorBuilder: (BuildContext context, index) {
          return Divider();
        },
        itemCount: expenses.length);
  }

  Widget bottomSheet() {
    List<int> incomeInteger = incomes.map(int.parse).toList();
    int incomeSum =
        incomeInteger.fold(0, (previous, current) => previous + current);
    List<int> expenseInteger = expenses.map(int.parse).toList();
    int expenseSum =
        expenseInteger.fold(0, (previous, current) => previous + current);

    return Container(
      color: Colors.blueGrey.shade900,
      height: 70,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
            child: Row(
              children: [
                Text(
                  'Available Balance :',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      letterSpacing: 1),
                ),
                Text(
                  '${incomeSum - expenseSum} /- PKR',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      letterSpacing: 1),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  
}
