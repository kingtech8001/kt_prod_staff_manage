import 'package:flutter/material.dart';

class AddEmployeeDialog extends StatelessWidget {
  const AddEmployeeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 650,
        padding: const EdgeInsets.all(28),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Employee', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),

              const SizedBox(height: 8),

              const Text('Create a new employee profile.', style: TextStyle(color: Color(0xFF64748B))),

              const SizedBox(height: 28),

              Row(
                children: [
                  Expanded(child: _textField(label: 'First Name')),

                  const SizedBox(width: 16),

                  Expanded(child: _textField(label: 'Last Name')),
                ],
              ),

              const SizedBox(height: 20),

              _textField(label: 'Email Address'),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(child: _textField(label: 'Phone Number')),

                  const SizedBox(width: 10),

                  Expanded(child: _textField(label: 'Designation')),
                ],
              ),
              SizedBox(height: 32),

              /*
              Row(
                children: [
                  Expanded(
                    child: _dropdownField(label: 'Role', hint: 'Select Role'),
                  ),

                  const SizedBox(width: 16),

                  Expanded(child: _textField(label: 'Employee ID')),
                ],
              ),
*/
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),

                  const SizedBox(width: 12),

                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.person_add_alt_1),
                    label: const Text('Create Employee'),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B1633), foregroundColor: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),

        const SizedBox(height: 8),

        TextField(
          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
        ),
      ],
    );
  }

  Widget _dropdownField({required String label, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
          items: const [],
          onChanged: (_) {},
          hint: Text(hint),
        ),
      ],
    );
  }
}
