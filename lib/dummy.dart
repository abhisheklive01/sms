class RevenueReportScreen extends StatefulWidget {
  @override
  _RevenueReportScreenState createState() => _RevenueReportScreenState();
}

class _RevenueReportScreenState extends State<RevenueReportScreen> {
  final List<Map<String, dynamic>> _revenueData = [
    {'month': '2023-09', 'revenue': 5000, 'paymentMethod': 'Cash'},
    {'month': '2023-09', 'revenue': 3000, 'paymentMethod': 'Card'},
    {'month': '2023-09', 'revenue': 2000, 'paymentMethod': 'UPI'},
    {'month': '2023-10', 'revenue': 6000, 'paymentMethod': 'Cash'},
    {'month': '2023-10', 'revenue': 4000, 'paymentMethod': 'Card'},
    {'month': '2023-10', 'revenue': 1000, 'paymentMethod': 'UPI'},
  ];

  final List<String> _clinics = ['Clinic A', 'Clinic B', 'Clinic C'];
  final List<String> _paymentMethods = ['Cash', 'Card', 'UPI'];

  String? _selectedClinic;
  String? _selectedPaymentMethod;
  DateTime? _startDate;
  DateTime? _endDate;

  List<Map<String, dynamic>> get _filteredRevenueData {
    return _revenueData.where((data) {
      final matchesClinic = _selectedClinic == null || true; // Replace with actual clinic filter logic
      final matchesPaymentMethod = _selectedPaymentMethod == null || data['paymentMethod'] == _selectedPaymentMethod;
      final month = DateFormat('yyyy-MM').parse(data['month']);
      final matchesDateRange = _startDate == null || _endDate == null ||
          (month.isAfter(_startDate!) && month.isBefore(_endDate!));
      return matchesClinic && matchesPaymentMethod && matchesDateRange;
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
    final revenueByMonth = _filteredRevenueData
        .groupBy((data) => data['month'])
        .map((month, data) => MapEntry(
              month,
              data.fold(0.0, (sum, item) => sum + item['revenue']),
            ))
        .entries
        .toList();

    final revenueByPaymentMethod = _filteredRevenueData
        .groupBy((data) => data['paymentMethod'])
        .map((method, data) => MapEntry(
              method,
              data.fold(0.0, (sum, item) => sum + item['revenue']),
            ))
        .entries
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Revenue Report'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filters
            DropdownButtonFormField<String>(
              value: _selectedClinic,
              decoration: InputDecoration(
                labelText: 'Clinic',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: _clinics.map((clinic) {
                return DropdownMenuItem(
                  value: clinic,
                  child: Text(clinic),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedClinic = value;
                });
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
              ),
              items: _paymentMethods.map((method) {
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
            SizedBox(height: 16),
            Row(
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
            SizedBox(height: 32),

            // Charts
            Text(
              'Revenue by Month',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries>[
                  ColumnSeries<MapEntry<String, double>, String>(
                    dataSource: revenueByMonth,
                    xValueMapper: (entry, _) => entry.key,
                    yValueMapper: (entry, _) => entry.value,
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Text(
              'Revenue by Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries>[
                  PieSeries<MapEntry<String, double>, String>(
                    dataSource: revenueByPaymentMethod,
                    xValueMapper: (entry, _) => entry.key,
                    yValueMapper: (entry, _) => entry.value,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on List<Map<String, dynamic>> {
  Map<K, List<Map<String, dynamic>>> groupBy<K>(K Function(Map<String, dynamic>) keyFunction) {
    return fold({}, (map, item) {
      final key = keyFunction(item);
      map.putIfAbsent(key, () => []).add(item);
      return map;
    });
  }
}
