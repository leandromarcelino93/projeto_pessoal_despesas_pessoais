import '../models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) onRemove;

  const TransactionList(this.transactions, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
          //Ajustes para layout na orientação paisagem
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                  SizedBox(
                    height: constraints.maxHeight * 0.1,
                ),
                const Text('Nenhuma transação foi cadastrada até o momento.',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center),
                  SizedBox(
                  height: constraints.maxHeight * 0.1,
                ),
                Container(
                  height: constraints.maxHeight * 0.4,
                  child: Image.asset(
                    'assets/images/aguardando_registro.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              final tr = transactions[index];
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(child: Text('R\$${tr.value}'))),
                  ),
                  title: Text(
                    tr.title,
                  ),
                  subtitle: Text(
                    DateFormat('d MMM y').format(tr.date),
                  ),
                  trailing: MediaQuery.of(context).size.width > 350
                  //Condicional para aproveitar situações em que o dispositivo possui larguras maiores
                      ? TextButton.icon(
                          onPressed: () => onRemove(tr.id),
                          icon: Icon(Icons.delete),
                          label: Text('Excluir'),
                        )
                      : IconButton(
                          onPressed: () => onRemove(tr.id),
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).errorColor,
                        ),
                ),
              );
            },
          );
  }
}
