import 'package:flutter/material.dart';

class AdminSearchTile extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback onTap;

  const AdminSearchTile({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFE2E8F0),
              foregroundColor: const Color(0xFF334155),
              child: Text(
                user['full_name']
                    .toString()
                    .split(' ')
                    .map((e) => e[0])
                    .take(2)
                    .join(),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['full_name'],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: (user['role'] == 'HR')
                              ? const Color(0xFFE0F2FE)
                              : const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          user['role'],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: (user['role'] == 'HR')
                                ? const Color(0xFF0369A1)
                                : const Color(0xFF15803D),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          user['designation'] ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Color(0xFF64748B)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }
}
