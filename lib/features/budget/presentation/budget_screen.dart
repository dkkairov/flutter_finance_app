import 'package:flutter/material.dart';

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final Map<String, double> categoryBudgets = {
    'Groceries': 8000,
    'Transport': 0,
    'Payments': 0,
    'Cafes': 0,
    'Clothes': 0,
    'Entertainment': 0,
    'Health': 0,
    'Gifts': 0,
    'Family': 0,
  };
  final Map<String, double> categoryLimits = {
    'Groceries': 500000,
    'Transport': 200000,
    'Payments': 300000,
    'Cafes': 150000,
    'Clothes': 100000,
    'Entertainment': 180000,
    'Health': 120000,
    'Gifts': 80000,
    'Family': 250000,
  };

  void _setBudget(String category) {
    showDialog(
      context: context,
      builder: (context) {
        double newLimit = categoryLimits[category] ?? 0;
        return AlertDialog(
          title: Text('Set Budget for $category'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              newLimit = double.tryParse(value) ?? newLimit;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  categoryLimits[category] = newLimit;
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalSpent = categoryBudgets.values.reduce((a, b) => a + b);
    double totalBudget = categoryLimits.values.reduce((a, b) => a + b);
    double progress = totalSpent / totalBudget;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Budget', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: Icon(Icons.settings), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('March 2025', style: TextStyle(fontSize: 16, color: Colors.grey)),
              SizedBox(height: 8),
              Text('${totalSpent.toInt()} ₸', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              LinearProgressIndicator(value: progress, minHeight: 10),
              Text('Total budget for a month: ${totalBudget.toInt()} ₸', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.9),
                itemCount: categoryBudgets.length,
                itemBuilder: (context, index) {
                  String category = categoryBudgets.keys.elementAt(index);
                  double spent = categoryBudgets[category] ?? 0;
                  double limit = categoryLimits[category] ?? 1;
                  double progress = spent / limit;
                  return CategoryWidget(
                    category: category,
                    spent: spent,
                    limit: limit,
                    progress: progress,
                    onSetBudget: () => _setBudget(category),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final String category;
  final double spent;
  final double limit;
  final double progress;
  final VoidCallback onSetBudget;

  const CategoryWidget({
    required this.category,
    required this.spent,
    required this.limit,
    required this.progress,
    required this.onSetBudget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 5,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              ),
            ),
            Icon(Icons.shopping_cart, size: 32),
          ],
        ),
        SizedBox(height: 4),
        Text(category, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        Text('${spent.toInt()} / ${limit.toInt()} ₸', style: TextStyle(fontSize: 12, color: Colors.black54)),
        ElevatedButton(
          onPressed: onSetBudget,
          child: Text('Set'),
          style: ElevatedButton.styleFrom(minimumSize: Size(50, 30)),
        ),
      ],
    );
  }
}
