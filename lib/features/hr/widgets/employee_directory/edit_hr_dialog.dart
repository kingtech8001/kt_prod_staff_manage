import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/employee_profile_controller.dart';

class EditHrDialog extends StatefulWidget {
  final Map<dynamic, dynamic> employee;

  const EditHrDialog({super.key, required this.employee});

  @override
  State<EditHrDialog> createState() => _EditHrDialogState();
}

class _EditHrDialogState extends State<EditHrDialog> {
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController designationController;

  bool isActive = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    fullNameController = TextEditingController(
      text: widget.employee['full_name'] ?? '',
    );

    emailController = TextEditingController(
      text: widget.employee['email'] ?? '',
    );

    phoneController = TextEditingController(
      text: widget.employee['phone'] ?? '',
    );

    designationController = TextEditingController(
      text: widget.employee['designation'] ?? '',
    );

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
              const Text(
                'Edit HR Profile',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                'Update HR information',
                style: TextStyle(color: Color(0xFF64748B)),
              ),

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
                title: const Text("Active HR Account"),
                onChanged: (value) {
                  setState(() {
                    isActive = value;
                  });
                },
              ),

              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),

                  const SizedBox(width: 12),

                  ElevatedButton.icon(
                    icon: isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save),

                    label: Text(isSaving ? "Saving..." : "Save Changes"),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B1633),
                      foregroundColor: Colors.white,
                    ),

                    onPressed: isSaving
                        ? null
                        : () async {
                            setState(() {
                              isSaving = true;
                            });

                            /// Temporary.
                            /// Later we'll replace this with updateHr()

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
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }
}
