import 'package:expense_tracker/Database/database.dart';
import 'package:expense_tracker/Model.dart';
import 'package:expense_tracker/Screens/AddAmountPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: GoogleFonts.spartanTextTheme(
            Theme.of(context).textTheme,
          ),
          scaffoldBackgroundColor: Color.fromRGBO(17, 23, 23, 1),
          appBarTheme: AppBarTheme(
            color: Color.fromRGBO(17, 23, 23, 1),
            elevation: 0,
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? totalIncome = 0;
  int? totalExpense = 0;
  int? availableBalance = 0;
  int? id;
  List<TrackerModel?> transactionList = [];
  List<TrackerModel?> incomeList = [];
  List<TrackerModel?> expenseList = [];
  int count = 1;
  List<TrackerModel> dataList = [];
  TrackerModel? tracker;

  void addFunction() async {
    transactionList = [];
    final dataList = await DatabaseService.db.getData('Tracker');
    transactionList = dataList.map((e) => TrackerModel.fromMap(e)).toList();

    expenseList =
        expenseList.where((element) => element!.isIncome == 1).toList();
    incomeList = incomeList.where((element) => element!.isIncome == 0).toList();
    totalExpense = expenseList.fold(
        0,
        (previousValue, element) =>
            previousValue! + int.parse(element!.amount ?? ''));
    totalIncome = incomeList.fold(
        0,
        (previousValue, element) =>
            previousValue! + int.parse(element!.amount ?? ''));
    transactionList.forEach((element) {
      if (element!.isIncome == 0) {
        totalIncome = totalIncome! + int.parse(element.amount ?? "0.0");
      } else {
        totalExpense = totalExpense! + int.parse(element.amount ?? '0');
      }
    });
    availableBalance = totalIncome! - totalExpense!;
    print(totalExpense);
    print(totalIncome);
    print(availableBalance);
  }

  @override
  Widget build(BuildContext context) {
    addFunction();
    updateListView();
    return Scaffold(
      backgroundColor: Color.fromRGBO(17, 23, 23, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(17, 23, 23, 1),
        title: Text('Expense Tracker'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddAmountPage();
                }));
                print('Add button clicked');
                updateListView();
                addFunction();
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(35, 47, 47, 0.4),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 1,
                          spreadRadius: 1,
                          offset: Offset(0, 3),
                          color: Color.fromRGBO(17, 23, 23, 1)),
                    ]),
                height: 220,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Available Balance : ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19),
                            ),
                            Text(
                              '$availableBalance PKR',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: availableBalance! >= 99999999 
                                      ? 12
                                      : 19),
                            ),
                            IconButton(
                                onPressed: () {
                                  addFunction();
                                  updateListView();
                                },
                                icon: Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.grey[600],
                                ))
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 15),
                      child: SingleChildScrollView(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: incomeGreen,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 1,
                                        spreadRadius: 1,
                                        offset: Offset(0, 4),
                                        color: Color.fromRGBO(17, 23, 23, 0.3)),
                                  ]),
                              height: 120,
                              width: MediaQuery.of(context).size.width / 2.3,
                              child: Column(
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Total Income ',
                                            style: TextStyle(
                                                fontSize: 19,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            'Rs $totalIncome /-',
                                            style: TextStyle(
                                                fontSize:
                                                    totalIncome! >= 99999999
                                                        ? 12
                                                        : 19,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: expenseRed,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 1,
                                        spreadRadius: 1,
                                        offset: Offset(0, 4),
                                        color: Color.fromRGBO(17, 23, 23, 0.3)),
                                  ]),
                              height: 120,
                              width: MediaQuery.of(context).size.width / 2.3,
                              child: Column(
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Total Expense ',
                                            style: TextStyle(
                                                fontSize: 19,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            'Rs $totalExpense /-',
                                            style: TextStyle(
                                                fontSize:
                                                    totalExpense! >= 99999999
                                                        ? 12
                                                        : 19,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 0),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: amountListView())),
        ],
      ),
    );
  }

  ListView amountListView() {
    return ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return dataList.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 22,
                        color: Colors.white,
                      ),
                      Text('Add your Income/Expense by clicking \n the /'+'/ at the topRight corner!'),
                    ],
                  ),
                )
              : Card(
                  elevation: 0,
                  color: Color.fromRGBO(26, 35, 35, 0.5),
                  child: Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    secondaryActions: [
                      IconSlideAction(
                        onTap: () {
                          delete(dataList[index]);
                          updateListView();
                          print('data deleted:$dataList[index] ');
                          addFunction();
                        },
                        icon: Icons.delete,
                        color: Colors.red.shade900.withOpacity(0.8),
                      )
                    ],
                    child: ListTile(
                      leading: FaIcon(
                        FontAwesomeIcons.chartLine,
                        color: this.dataList[index].isIncome! == 1
                            ? Colors.red
                            : Colors.green,
                      ),
                      title: Text(
                        this.dataList[index].amount! + ' PKR',
                        style: TextStyle(
                            color: this.dataList[index].isIncome! == 1
                                ? Colors.red
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            this.dataList[index].description!,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            this.dataList[index].date!,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        });
  }

  void updateListView() {
    final Future<Database> dbFuture = DatabaseService.db.innitialize();
    dbFuture.then((database) {
      Future<List<TrackerModel>> dataListFuture =
          DatabaseService.db.getDataList();
      dataListFuture.then((dataList) {
        setState(() {
          this.dataList = dataList;
          this.count = dataList.length;
        });
      });
    });
  }

  void pushAddPage() async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddAmountPage()));
    result ? updateListView() : updateListView();
  }

  void delete(TrackerModel tracker) async {
    await DatabaseService.db.deleteDataFromDB(tracker.id!);
  }
}
