import 'package:flutter/material.dart';
import 'package:flutter_app_1/features/transactions/presentation/widgets/transactions_list_widget.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: const Column(
            children: [
              Expanded(child: TransactionsListWidget()),
            ],
          )
        )
    );
  }
}
