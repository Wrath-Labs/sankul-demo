import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/fees.dart';
import '../../../data/students.dart';
import '../../../models/fee.dart';
import '../../../models/student.dart';
import '../../../providers/fee_provider.dart';
import '../../../providers/school_providers.dart';
import '../../../theme/tokens.dart';
import '../../../utils/formatters.dart';
import '../../../widgets/common.dart';
import '../../../widgets/student_search_field.dart';

/// Opens the Record Payment flow and, on success, the confirmation dialog.
/// [onViewReceipt] is offered on the confirmation when provided.
Future<Payment?> showRecordPaymentDialog(
  BuildContext context, {
  Student? student,
  void Function(BuildContext context, Payment payment)? onViewReceipt,
}) async {
  final payment = await showDialog<Payment>(
    context: context,
    builder: (_) => RecordPaymentDialog(initialStudent: student),
  );
  if (payment != null && context.mounted) {
    await showDialog<void>(
      context: context,
      builder: (_) =>
          PaymentSuccessDialog(payment: payment, onViewReceipt: onViewReceipt),
    );
  }
  return payment;
}

class RecordPaymentDialog extends ConsumerStatefulWidget {
  const RecordPaymentDialog({super.key, this.initialStudent});

  final Student? initialStudent;

  @override
  ConsumerState<RecordPaymentDialog> createState() =>
      _RecordPaymentDialogState();
}

class _RecordPaymentDialogState extends ConsumerState<RecordPaymentDialog> {
  Student? _student;
  FeeHead _head = feeHeads.first;
  PaymentMode _mode = PaymentMode.cash;
  final _amount = TextEditingController();
  final _reference = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialStudent != null) _select(widget.initialStudent!);
  }

  @override
  void dispose() {
    _amount.dispose();
    _reference.dispose();
    super.dispose();
  }

  void _select(Student s) {
    final account = ref.read(feeProvider).accounts[s.id];
    setState(() {
      _student = s;
      _head = s.usesTransport ? feeHeads[0] : feeHeads[1];
      final due = account != null && account.balance > 0
          ? account.balance
          : monthlyFeeFor(s);
      _amount.text = '$due';
    });
  }

  int get _amountValue => int.tryParse(_amount.text.replaceAll(',', '')) ?? 0;

  Future<void> _submit() async {
    if (_student == null || _amountValue <= 0) return;
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    final payment = ref.read(feeProvider.notifier).recordPayment(
          studentId: _student!.id,
          head: _head.name,
          amount: _amountValue,
          mode: _mode,
          reference: _reference.text.trim().isEmpty
              ? null
              : '${_mode == PaymentMode.cheque ? 'Chq' : 'UPI Ref'} ${_reference.text.trim()}',
        );
    Navigator.of(context).pop(payment);
  }

  @override
  Widget build(BuildContext context) {
    final students = ref.watch(activeStudentsProvider);
    final nextReceipt = ref.read(feeProvider.notifier).nextReceiptNo;
    final account =
        _student == null ? null : ref.watch(feeProvider).accounts[_student!.id];

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const IconBadge(
                      icon: Icons.receipt_long_outlined,
                      color: AppColors.success,
                      size: 42),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Record Payment', style: AppText.h2),
                        Text('Receipt No. $nextReceipt',
                            style: AppText.caption),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Close',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Student', style: AppText.label),
              const SizedBox(height: 6),
              StudentSearchField(
                students: students,
                initial: widget.initialStudent,
                optionsWidth: 484,
                onSelected: _select,
              ),
              if (_student != null && account != null) ...[
                const SizedBox(height: 12),
                _StudentFeeSummary(student: _student!, account: account),
              ],
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Fee head', style: AppText.label),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<FeeHead>(
                          key: ValueKey(_head.id),
                          initialValue: _head,
                          isExpanded: true,
                          borderRadius: AppRadius.mdAll,
                          style: AppText.body,
                          items: [
                            for (final h in feeHeads)
                              DropdownMenuItem(value: h, child: Text(h.name)),
                          ],
                          onChanged: (h) => setState(() => _head = h!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Amount (₹)', style: AppText.label),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _amount,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: AppText.body.copyWith(
                              fontWeight: FontWeight.w600,
                              fontFeatures: const [
                                FontFeature.tabularFigures()
                              ]),
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            prefixText: '₹ ',
                            hintText: '0',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text('Payment mode', style: AppText.label),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final m in const [
                    (PaymentMode.cash, Icons.payments_outlined),
                    (PaymentMode.upi, Icons.qr_code_2_rounded),
                    (PaymentMode.cheque, Icons.account_balance_outlined),
                  ])
                    ChoiceChip(
                      avatar: Icon(m.$2, size: 16),
                      label: Text(m.$1.label),
                      selected: _mode == m.$1,
                      showCheckmark: false,
                      onSelected: (_) => setState(() => _mode = m.$1),
                      selectedColor: AppColors.tint(AppColors.primary, 0.12),
                      side: BorderSide(
                          color: _mode == m.$1
                              ? AppColors.primary
                              : AppColors.borderStrong),
                      labelStyle: AppText.title.copyWith(
                          color: _mode == m.$1
                              ? AppColors.primary
                              : AppColors.textSecondary),
                      shape: const RoundedRectangleBorder(
                          borderRadius: AppRadius.mdAll),
                    ),
                ],
              ),
              if (_mode != PaymentMode.cash) ...[
                const SizedBox(height: 14),
                TextField(
                  controller: _reference,
                  decoration: InputDecoration(
                    hintText: _mode == PaymentMode.cheque
                        ? 'Cheque number (optional)'
                        : 'UPI transaction ID (optional)',
                    prefixIcon: const Icon(Icons.tag_rounded, size: 18),
                  ),
                ),
              ],
              if (_amountValue > 0) ...[
                const SizedBox(height: 14),
                Text(Fmt.amountInWords(_amountValue),
                    style: AppText.caption.copyWith(fontStyle: FontStyle.italic)),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: _student == null || _amountValue <= 0 || _saving
                        ? null
                        : _submit,
                    icon: _saving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.check_rounded, size: 18),
                    label: Text(_amountValue > 0
                        ? 'Record ${Fmt.rupee(_amountValue)}'
                        : 'Record Payment'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StudentFeeSummary extends StatelessWidget {
  const _StudentFeeSummary({required this.student, required this.account});

  final Student student;
  final FeeAccount account;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          InitialsAvatar(student.name, size: 38),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.name, style: AppText.title),
                Text(
                  'Class ${student.classId} · ${student.admissionNo} · Mr. ${student.fatherName}',
                  style: AppText.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StatusChip.fee(account.status),
              const SizedBox(height: 4),
              Text(
                account.balance > 0
                    ? 'Balance ${Fmt.rupee(account.balance)}'
                    : 'No dues',
                style: AppText.caption.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PaymentSuccessDialog extends StatelessWidget {
  const PaymentSuccessDialog({
    super.key,
    required this.payment,
    this.onViewReceipt,
  });

  final Payment payment;
  final void Function(BuildContext context, Payment payment)? onViewReceipt;

  @override
  Widget build(BuildContext context) {
    final s = studentById[payment.studentId]!;
    Widget row(String k, String v) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              SizedBox(width: 110, child: Text(k, style: AppText.bodySm)),
              Expanded(
                child: Text(v,
                    style: AppText.title, textAlign: TextAlign.right),
              ),
            ],
          ),
        );

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.6, end: 1),
                duration: const Duration(milliseconds: 420),
                curve: Curves.elasticOut,
                builder: (context, v, child) =>
                    Transform.scale(scale: v, child: child),
                child: Container(
                  width: 68,
                  height: 68,
                  decoration: const BoxDecoration(
                      color: AppColors.successBg, shape: BoxShape.circle),
                  child: const Icon(Icons.check_rounded,
                      color: AppColors.success, size: 38),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Payment Recorded', style: AppText.h2),
              const SizedBox(height: 6),
              Text(Fmt.rupee(payment.amount), style: AppText.kpi),
              const SizedBox(height: 4),
              Text(Fmt.amountInWords(payment.amount),
                  style: AppText.caption, textAlign: TextAlign.center),
              const SizedBox(height: 18),
              const Divider(),
              const SizedBox(height: 8),
              row('Receipt No.', payment.receiptNo),
              row('Student', '${s.name} (${s.classId})'),
              row('Fee head', payment.head),
              row('Mode', payment.mode.label),
              row('Date', Fmt.dateTime(payment.date)),
              const SizedBox(height: 12),
              InfoStrip(
                icon: Icons.chat_rounded,
                color: const Color(0xFF16A34A),
                text:
                    'Receipt sent to Mr. ${s.fatherName} on WhatsApp (${Fmt.maskPhone(s.phone)})',
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Done'),
                    ),
                  ),
                  if (onViewReceipt != null) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onViewReceipt!(context, payment);
                        },
                        icon: const Icon(Icons.print_outlined, size: 18),
                        label: const Text('View Receipt'),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
