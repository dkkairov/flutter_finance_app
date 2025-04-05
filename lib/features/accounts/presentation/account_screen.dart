import 'package:flutter/material.dart';
import '../../transactions/presentation/widgets/transactions_list_widget.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Счёт',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Действие при нажатии кнопки "Редактировать"
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('800 000 тг'),
                    SizedBox(height: 10),
                    Text('баланс счёта'),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              TransactionsListWidget()
            ],
          ),
        )
    );
  }
}
