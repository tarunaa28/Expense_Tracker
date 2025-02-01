import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddExpense extends StatefulWidget {
  @override
  AddExpenseState createState() => AddExpenseState();
}

class AddExpenseState extends State<AddExpense> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();

  String _selectedCategory = "Needs";
  final List<String> _categories = ["Needs", "Savings", "Wants"];
  double _needs = 0, _wants = 0, _savings = 0;
  bool _isBudgetExceeded = false;

  // Function to calculate 50-30-20 budget split
  void _calculateBudget() {
    double budget = double.tryParse(_budgetController.text) ?? 0;
    setState(() {
      _needs = budget * 0.50;
      _wants = budget * 0.30;
      _savings = budget * 0.20;
    });
  }

  // Check if entered amount exceeds allocated budget
  void _validateAmount(String value) {
    double enteredAmount = double.tryParse(value) ?? 0;
    bool isExceeded = false;

    if ((_selectedCategory == "Needs" && enteredAmount > _needs) ||
        (_selectedCategory == "Wants" && enteredAmount > _wants) ||
        (_selectedCategory == "Savings" && enteredAmount > _savings)) {
      isExceeded = true;
    }

    setState(() {
      _isBudgetExceeded = isExceeded;
    });
  }

  // Date Picker Function
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        _dateController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'Add Expense',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Monthly Budget Card
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Monthly Budget',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _budgetController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter Total Budget',
                        prefixIcon:
                            Icon(Icons.attach_money, color: Colors.deepPurple),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: (_) => _calculateBudget(),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _budgetCategory('Needs', _needs, Colors.blueAccent),
                        _budgetCategory('Wants', _wants, Colors.orangeAccent),
                        _budgetCategory('Savings', _savings, Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildTextField(
                _itemNameController, 'Item Name', Icons.shopping_bag),
            SizedBox(height: 12),
            // Amount Field with Budget Validation
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.attach_money, color: Colors.deepPurple),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                errorText: _isBudgetExceeded
                    ? '⚠ Exceeds allocated budget for $_selectedCategory!'
                    : null,
              ),
              onChanged: _validateAmount,
            ),
            SizedBox(height: 12),
            // Date Field
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Date',
                prefixIcon:
                    Icon(Icons.calendar_today, color: Colors.deepPurple),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 12),
            _buildTextField(
                _descriptionController, 'Description', Icons.note_alt),
            SizedBox(height: 12),
            // Category Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories.map((String category) {
                return DropdownMenuItem(
                  value: category,
                  child:
                      Text(category, style: GoogleFonts.poppins(fontSize: 16)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                  _validateAmount(_amountController.text);
                });
              },
              decoration: InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category, color: Colors.deepPurple),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 20),
            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildButton('Cancel', Colors.grey, () {
                  _itemNameController.clear();
                  _amountController.clear();
                  _dateController.clear();
                  _descriptionController.clear();
                  setState(() {
                    _selectedCategory = "Needs";
                    _isBudgetExceeded = false;
                  });
                }),
                _buildButton(
                  'Add',
                  Colors.deepPurple,
                  _isBudgetExceeded
                      ? null
                      : () {
                          print('Expense Added Successfully');
                        },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _budgetCategory(String label, double amount, Color color) {
    return Column(
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w500, color: color)),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '₹${amount.toStringAsFixed(0)}',
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.w600, color: color),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text, style: GoogleFonts.poppins(fontSize: 16)),
    );
  }
}
