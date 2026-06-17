import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/employee_profile_controller.dart';

class EditEmployeeDialog extends StatefulWidget {
  final Map<dynamic, dynamic> employee;

  const EditEmployeeDialog({super.key, required this.employee});

  @override
  State<EditEmployeeDialog> createState() => _EditEmployeeDialogState();
}

class _EditEmployeeDialogState extends State<EditEmployeeDialog> {
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController designationController;

  bool isActive = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    fullNameController = TextEditingController(text: widget.employee['full_name'] ?? '');

    emailController = TextEditingController(text: widget.employee['email'] ?? '');

    phoneController = TextEditingController(text: widget.employee['phone'] ?? '');

    designationController = TextEditingController(text: widget.employee['designation'] ?? '');

    isActive = widget.employee['is_active'] ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeProfileController>();

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 650,
        padding: const EdgeInsets.all(28),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Edit Employee', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),

              const SizedBox(height: 8),

              const Text('Update employee information', style: TextStyle(color: Color(0xFF64748B))),

              const SizedBox(height: 28),

              _field('Full Name', fullNameController),

              const SizedBox(height: 18),

              _field('Email', emailController),

              const SizedBox(height: 18),

              _field('Phone', phoneController),

              const SizedBox(height: 18),

              _field('Designation', designationController),

              const SizedBox(height: 18),

              SwitchListTile(
                value: isActive,
                onChanged: (value) {
                  setState(() {
                    isActive = value;
                  });
                },
                title: const Text('Active Employee'),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),

                  const SizedBox(width: 12),

                  ElevatedButton.icon(
                    onPressed: isSaving
                        ? null
                        : () async {
                            setState(() {
                              isSaving = true;
                            });

                            await controller.updateEmployee(
                              fullName: fullNameController.text.trim(),
                              email: emailController.text.trim(),
                              phone: phoneController.text.trim(),
                              designation: designationController.text.trim(),
                              isActive: isActive,
                            );

                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                    icon: const Icon(Icons.save),
                    label: const Text('Save Changes'),
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

  Widget _field(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
        ),
      ],
    );
  }
}
