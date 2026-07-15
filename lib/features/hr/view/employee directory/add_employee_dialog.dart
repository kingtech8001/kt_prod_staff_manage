import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/add_employee_controller.dart';

class AddEmployeeDialog extends StatelessWidget {
  final String role;

  const AddEmployeeDialog({super.key, this.role = "Employee"});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddEmployeeController());

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
              Text(
                role == "HR" ? "Add HR Staff" : "Add Employee",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                role == "HR"
                    ? "Create a new HR profile."
                    : "Create a new employee profile.",
                style: TextStyle(color: Color(0xFF64748B)),
              ),

              const SizedBox(height: 28),

              _textField(
                label: 'Full Name',
                controller: controller.fullNameController,
              ),

              const SizedBox(height: 20),

              _textField(
                label: 'Email',
                controller: controller.emailController,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => _textField(
                        label: 'Password',
                        controller: controller.passwordController,
                        obscureText: controller.obscurePassword.value,
                        suffixIcon: IconButton(
                          onPressed: controller.togglePasswordVisibility,
                          icon: Icon(
                            controller.obscurePassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _textField(
                      label: 'Phone Number',
                      controller: controller.phoneController,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _textField(
                label: 'Designation',
                controller: controller.designationController,
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

                  Obx(
                    () => ElevatedButton.icon(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.createEmployee(role),
                      icon: controller.isLoading.value
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.person_add_alt_1),
                      label: Text(
                        controller.isLoading.value
                            ? 'Creating...'
                            : role == "HR"
                            ? "Create HR"
                            : "Create Employee",
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B1633),
                        foregroundColor: Colors.white,
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

  Widget _textField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            suffixIcon: suffixIcon,
          ),
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
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
          items: const [],
          onChanged: (_) {},
          hint: Text(hint),
        ),
      ],
    );
  }
}
