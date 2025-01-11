class PaymentEntryPage extends StatefulWidget {
  @override
  _PaymentEntryPageState createState() => _PaymentEntryPageState();
}

class _PaymentEntryPageState extends State<PaymentEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _transactionIdController = TextEditingController();
  String? _selectedAppointmentId;
  String? _selectedPaymentMethod;

  final List<String> _appointmentIds = ['Appointment 1', 'Appointment 2', 'Appointment 3'];
  final List<String> _paymentMethods = ['Cash', 'Card', 'Google Pay', 'UPI'];

  void _submitPayment() {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display the data in the console.
      print('Appointment ID: $_selectedAppointmentId');
      print('Payment Method: $_selectedPaymentMethod');
      print('Amount: ${_amountController.text}');
      print('Transaction ID: ${_transactionIdController.text}');

      // Optionally, you can navigate to another screen or show a success message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Submitted Successfully')),
      );
    }
  }

  void _generateReceipt() {
    if (_formKey.currentState!.validate()) {
      // Generate a receipt and display it in the console.
      print('Generating Receipt...');
      print('Appointment ID: $_selectedAppointmentId');
      print('Payment Method: $_selectedPaymentMethod');
      print('Amount: ${_amountController.text}');
      print('Transaction ID: ${_transactionIdController.text}');

      // Optionally, you can navigate to another screen or show a success message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Receipt Generated Successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Entry Form'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedAppointmentId,
                decoration: InputDecoration(
                  labelText: 'Appointment ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                items: _appointmentIds.map((appointmentId) {
                  return DropdownMenuItem(
                    value: appointmentId,
                    child: Text(appointmentId),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAppointmentId = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an appointment ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPaymentMethod,
                decoration: InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                items: _paymentMethods.map((paymentMethod) {
                  return DropdownMenuItem(
                    value: paymentMethod,
                    child: Text(paymentMethod),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a payment method';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              if (_selectedPaymentMethod != 'Cash')
                TextFormField(
                  controller: _transactionIdController,
                  decoration: InputDecoration(
                    labelText: 'Transaction ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                    labelStyle: TextStyle(color: Colors.blueGrey),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  validator: (value) {
                    if (_selectedPaymentMethod != 'Cash' && (value == null || value.isEmpty)) {
                      return 'Please enter the transaction ID';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _submitPayment,
                    child: Text('Submit Payment'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _generateReceipt,
                    child: Text('Generate Receipt'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _transactionIdController.dispose();
    super.dispose();
  }
}
