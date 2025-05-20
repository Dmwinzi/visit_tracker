import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Domain/Entities/VisitingEntity.dart';
import '../Viewmodels/VisitViewmodel.dart';

class AddVisitScreen extends StatefulWidget {
  const AddVisitScreen({super.key});

  @override
  State<AddVisitScreen> createState() => _AddVisitScreenState();
}

class _AddVisitScreenState extends State<AddVisitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerIdController = TextEditingController();
  final _locationController = TextEditingController();
  final _visitDateController = TextEditingController();
  final _notesController = TextEditingController();

  String _status = 'Pending';
  final List<String> _statusOptions = [
    'Completed',
    'Pending',
    'Cancelled'
  ];

  final VisitController visitController = Get.find<VisitController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      visitController.loadActivities();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _visitDateController.text = picked.toIso8601String().split('T')[0];
    }
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final visit = VisitEntity(
        customerId: int.parse(_customerIdController.text),
        visitDate: DateTime.parse(_visitDateController.text),
        location: _locationController.text,
        notes: _notesController.text,
        status: _status,
        activitiesDone: visitController.selectedActivityId.value != null
            ? [visitController.selectedActivityId.value!]
            : [],
        createdAt: DateTime.now(),
      );

      print(visit);
      await visitController.submitVisit(visit);

      if (visitController.errorMessage.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Visit added successfully'),
              backgroundColor: Colors.green),
        );

        _formKey.currentState!.reset();
        _visitDateController.clear();
        _notesController.clear();
        _locationController.clear();
        _customerIdController.clear();
        setState(() => _status = 'Scheduled');

        if (visitController.activities.isNotEmpty) {
          visitController.selectedActivityId.value =
              visitController.activities.first.id;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(visitController.errorMessage.value),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        title: const Text('Add Visit', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _customerIdController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('Customer ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Customer ID';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Must be a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _locationController,
                  decoration: _inputDecoration('Location'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter location' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _visitDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: _inputDecoration('Visit Date').copyWith(
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please select a date' : null,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _status,
                  onChanged: (val) => setState(() => _status = val!),
                  decoration: _inputDecoration('Status'),
                  items: _statusOptions
                      .map((status) =>
                      DropdownMenuItem(value: status, child: Text(status)))
                      .toList(),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _notesController,
                  decoration: _inputDecoration('Notes'),
                  maxLines: 3,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter notes' : null,
                ),
                const SizedBox(height: 20),
                Obx(() {
                  if (visitController.isLoading.value &&
                      visitController.activities.isEmpty) {
                    return const CircularProgressIndicator();
                  }
                  if (visitController.activities.isEmpty) {
                    return const Text('No activities found.');
                  }

                  return DropdownButtonFormField<int>(
                    value: visitController.selectedActivityId.value,
                    decoration: _inputDecoration('Activity Done'),
                    onChanged: (val) => visitController.selectedActivityId.value = val,
                    items: visitController.activities
                        .map((activity) => DropdownMenuItem<int>(
                      value: activity.id,
                      child: Text(activity.description),
                    ))
                        .toList(),
                    validator: (value) =>
                    value == null ? 'Please select an activity' : null,
                  );
                }),
                const SizedBox(height: 30),
                Obx(() {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: visitController.submitLoading.value
                          ? null
                          : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003366),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: visitController.submitLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Add Visit', style: TextStyle(color: Colors.white,fontSize: 18)),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    );
  }
}
