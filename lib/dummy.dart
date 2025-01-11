class AppointmentSchedulingPage extends StatefulWidget {
  @override
  _AppointmentSchedulingPageState createState() => _AppointmentSchedulingPageState();
}

class _AppointmentSchedulingPageState extends State<AppointmentSchedulingPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _patientNameController = TextEditingController();
  final _reasonController = TextEditingController();
  String? _selectedDoctor;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedStatus;
  bool _patientExists = false;

  final List<String> _doctors = ['Doctor 1', 'Doctor 2', 'Doctor 3'];
  final List<String> _statuses = ['Scheduled', 'Completed', 'Cancelled', 'No Show'];

  // Mock patient database
  final Map<String, Map<String, String>> _patients = {
    '1234567890': {'name': 'Patient 1', 'email': 'patient1@example.com'},
    '9876543210': {'name': 'Patient 2', 'email': 'patient2@example.com'},
  };

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _searchPatient() {
    final phoneNumber = _phoneController.text;
    if (_patients.containsKey(phoneNumber)) {
      setState(() {
        _patientExists = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Patient found: ${_patients[phoneNumber]!['name']}')),
      );
    } else {
      setState(() {
        _patientExists = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Patient not found. Please enter patient details.')),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display the data in the console.
      print('Patient Phone: ${_phoneController.text}');
      if (!_patientExists) {
        print('Patient Name: ${_patientNameController.text}');
      }
      print('Doctor: $_selectedDoctor');
      print('Appointment Date: $_selectedDate');
      print('Appointment Time: $_selectedTime');
      print('Reason for Visit: ${_reasonController.text}');
      print('Status: $_selectedStatus');

      // Optionally, you can navigate to another screen or show a success message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment Scheduled Successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Scheduling'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
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
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _searchPatient,
                child: Text('Search Patient'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 16),
              if (!_patientExists)
                TextFormField(
                  controller: _patientNameController,
                  decoration: InputDecoration(
                    labelText: 'Patient Name',
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
                    if (value == null || value.isEmpty) {
                      return 'Please enter the patient name';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDoctor,
                decoration: InputDecoration(
                  labelText: 'Doctor Name',
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
                items: _doctors.map((doctor) {
                  return DropdownMenuItem(
                    value: doctor,
                    child: Text(doctor),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDoctor = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a doctor';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Appointment Date',
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
                  child: Row(
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'Select Date'
                            : '${_selectedDate!.toLocal()}'.split(' ')[0],
                        style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                      ),
                      Spacer(),
                      Icon(Icons.calendar_today, color: Colors.blue),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () => _selectTime(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Appointment Time',
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
                  child: Row(
                    children: [
                      Text(
                        _selectedTime == null
                            ? 'Select Time'
                            : '${_selectedTime!.format(context)}',
                        style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                      ),
                      Spacer(),
                      Icon(Icons.access_time, color: Colors.blue),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(
                  labelText: 'Reason for Visit',
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
                  if (value == null || value.isEmpty) {
                    return 'Please enter the reason for visit';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Status',
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
                items: _statuses.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a status';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Schedule Appointment'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _patientNameController.dispose();
    _reasonController.dispose();
    super.dispose();
  }
}
