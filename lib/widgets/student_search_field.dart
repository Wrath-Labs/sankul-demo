import 'package:flutter/material.dart';

import '../models/student.dart';
import '../theme/tokens.dart';
import 'common.dart';

/// Type-ahead student picker (name, class or admission number).
class StudentSearchField extends StatelessWidget {
  const StudentSearchField({
    super.key,
    required this.students,
    required this.onSelected,
    this.initial,
    this.optionsWidth = 460,
    this.hint = 'Search by name, class or admission no.',
  });

  final List<Student> students;
  final ValueChanged<Student> onSelected;
  final Student? initial;
  final double optionsWidth;
  final String hint;

  static String label(Student s) => '${s.name} · ${s.classId}';

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Student>(
      initialValue:
          initial == null ? null : TextEditingValue(text: label(initial!)),
      displayStringForOption: label,
      optionsBuilder: (value) {
        final q = value.text.trim().toLowerCase();
        if (q.isEmpty) return const Iterable<Student>.empty();
        return students
            .where((s) =>
                s.name.toLowerCase().contains(q) ||
                s.admissionNo.toLowerCase().contains(q) ||
                s.classId.toLowerCase() == q)
            .take(8);
      },
      onSelected: onSelected,
      fieldViewBuilder: (context, controller, focusNode, onSubmit) =>
          TextField(
        controller: controller,
        focusNode: focusNode,
        onSubmitted: (_) => onSubmit(),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search_rounded, size: 18),
        ),
      ),
      optionsViewBuilder: (context, onSelect, options) => Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Material(
            elevation: 10,
            shadowColor: const Color(0x330F172A),
            color: AppColors.surface,
            borderRadius: AppRadius.mdAll,
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: 320, maxWidth: optionsWidth),
              child: ListView.builder(
                padding: const EdgeInsets.all(6),
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, i) {
                  final s = options.elementAt(i);
                  return InkWell(
                    onTap: () => onSelect(s),
                    borderRadius: AppRadius.smAll,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      child: Row(
                        children: [
                          InitialsAvatar(s.name, size: 30),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(s.name, style: AppText.title),
                                Text('Class ${s.classId} · ${s.admissionNo}',
                                    style: AppText.caption),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
