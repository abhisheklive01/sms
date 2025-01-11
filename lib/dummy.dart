class PaymentHistoryDashboard extends StatefulWidget {
  @override
  _PaymentHistoryDashboardState createState() => _PaymentHistoryDashboardState();
}

class _PaymentHistoryDashboardState extends State<PaymentHistoryDashboard> {
  final List<Map<String, dynamic>> _payments = [
    {
      'paymentId': 'P001',
      'appointmentId': 'A001',
      'patientName': 'John Doe',
      'phone': '1234567890',
      'paymentMethod': 'Cash',
      'amount': 100.0,
      'paymentDate': '2023-10-01',
    },
    {
      'paymentId': 'P002',
      'appointmentId': 'A002',
      'patientName': 'Jane Smith',
      'phone': '9876543210',
      'paymentMethod': 'Card',
      'amount': 200.0,
      'paymentDate': '2023-10-05',
    },
    {
      'paymentId': 'P003',
      'appointmentId': 'A003',
      'patientName': 'Alice Johnson',
      'phone': '5555555555',
      'paymentMethod': 'UPI',
      'amount': 150.0,
      'paymentDate': '2023-10-10',
    },
  ];

  String? _selectedPaymentMethod;
  DateTime? _startDate;
  DateTime? _endDate;
  String _searchQuery = '';

  List<Map<String, dynamic>> get _filteredPayments {
    return _payments.where((payment) {
      final matchesName = payment['patientName'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesPaymentMethod = _selectedPaymentMethod == null || payment['paymentMethod'] == _selectedPaymentMethod;
      final paymentDate = DateTime.parse(payment['paymentDate']);
      final matchesDateRange = _startDate == null || _endDate == null ||
          (paymentDate.isAfter(_startDate!) && paymentDate.isBefore(_endDate!));
      return matchesName && matchesPaymentMethod && matchesDateRange;
    }).toList();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History Dashboard'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by Patient Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              decoration: InputDecoration(
                labelText: 'Filter by Payment Method',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: ['Cash', 'Card', 'UPI', 'Google Pay'].map((method) {
                return DropdownMenuItem(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, true),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Start Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _startDate == null
                                ? 'Select Start Date'
                                : '${_startDate!.toLocal()}'.split(' ')[0],
                          ),
                          Spacer(),
                          Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, false),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'End Date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _endDate == null
                                ? 'Select End Date'
                                : '${_endDate!.toLocal()}'.split(' ')[0],
                          ),
                          Spacer(),
                          Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: _filteredPayments.length,
              itemBuilder: (context, index) {
                final payment = _filteredPayments[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    title: Text('Patient: ${payment['patientName']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Phone: ${payment['phone']}'),
                        Text('Appointment ID: ${payment['appointmentId']}'),
                        Text('Payment Method: ${payment['paymentMethod']}'),
                        Text('Amount: \$${payment['amount']}'),
                        Text('Date: ${payment['paymentDate']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
