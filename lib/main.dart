import 'package:projeto_pessoal_despesas_pessoais/components/chart.dart';
import 'package:projeto_pessoal_despesas_pessoais/components/transaction_form.dart';
import 'package:projeto_pessoal_despesas_pessoais/models/transaction.dart';
import 'package:flutter/material.dart';
import './components/transaction_list.dart';
import 'dart:math';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.light(
                primary: Colors.indigo,
                secondary: Colors.green.shade400)),
        home: MyHomePage());
  }
}

///MyHomePage convertido de Stateless para Stateful
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];

///Função para abrir o formulário apenas quando houver clique no botão de add
  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return TransactionForm(_addTransaction);
        });
  }

///Função getter utilizando where para filtrar as transações salvas
  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

///Função para adicionarmos uma nova transação na lista
  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });
    Navigator.of(context).pop();
  }

///Função para remover uma transação da lista
  _deleteTransactions(String id) {
    setState(() {
      _transactions.removeWhere((tr) {
        return tr.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final appBar = AppBar(
      title: const Text('Despesas Pessoais'),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _openTransactionFormModal(context),
        )
      ],
    );

    ///MediaQuery
    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: availableHeight * (isLandscape ? 0.65 : 0.24),
              //Se tiver em paisagem, exibir 65% da tela, caso contrário, 24%
              child: Chart(_recentTransactions),
            ),
            Container(
                height: availableHeight * 0.65,
                child: TransactionList(_transactions, _deleteTransactions)),
            Padding(
              padding: isLandscape
                  ? EdgeInsets.only(
                      bottom: 10 + MediaQuery.of(context).viewInsets.bottom)
                  : EdgeInsets.only(bottom: 0),
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () => _openTransactionFormModal(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
