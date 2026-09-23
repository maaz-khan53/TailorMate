import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tailorx/core/constants/app_colors.dart';
import 'package:tailorx/features/orders/presentation/models/order_model.dart';

class ReceivePaymentScreen extends StatefulWidget {
  const ReceivePaymentScreen({
    super.key,
    required this.order,
  });

  final TailorOrder order;

  @override
  State<ReceivePaymentScreen> createState() => _ReceivePaymentScreenState();
}

class _ReceivePaymentScreenState extends State<ReceivePaymentScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  bool _saving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  double get _enteredAmount {
    return double.tryParse(_amountController.text.trim()) ?? 0;
  }

  String _money(double value) => 'Rs ${value.toStringAsFixed(0)}';

  void _useFullRemaining() {
    _amountController.text = widget.order.remaining.toStringAsFixed(0);
    setState(() {});
  }

  Future<void> _savePayment() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _saving = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 450));

    final OrderPayment payment = OrderPayment(
      id: 'payment-${DateTime.now().millisecondsSinceEpoch}',
      amount: _enteredAmount,
      receivedAt: DateTime.now(),
      note: _noteController.text.trim(),
    );

    final TailorOrder updatedOrder = widget.order.copyWith(
      payments: <OrderPayment>[
        ...widget.order.payments,
        payment,
      ],
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop<TailorOrder>(updatedOrder);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double contentMaxWidth = screenWidth >= 1100
        ? 820
        : screenWidth >= 700
        ? 740
        : 620;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color background =
    isDark ? AppColors.darkScaffold : AppColors.scaffold;
    final Color card = isDark ? AppColors.darkCard : AppColors.card;
    final Color primaryText =
    isDark ? AppColors.darkText : AppColors.textPrimary;
    final Color secondaryText =
    isDark ? AppColors.grey400 : AppColors.textSecondary;
    final Color border =
    isDark ? AppColors.darkBorder : AppColors.border;

    final double afterPayment =
    (widget.order.remaining - _enteredAmount).clamp(0, double.infinity);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: background,
        foregroundColor: primaryText,
        title: const Text(
          'Receive Payment',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: _ResponsiveContent(
        maxWidth: contentMaxWidth,
        child: Form(
          key: _formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 120),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      widget.order.customerName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.order.orderCode} • ${widget.order.dressName}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 17),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _TopAmount(
                            label: 'Total Bill',
                            value: _money(widget.order.totalBill),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 35,
                          color: Colors.white24,
                        ),
                        Expanded(
                          child: _TopAmount(
                            label: 'Remaining',
                            value: _money(widget.order.remaining),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Payment Amount',
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Enter the amount received from the customer.',
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                      onChanged: (_) => setState(() {}),
                      validator: (String? value) {
                        final double amount =
                            double.tryParse(value?.trim() ?? '') ?? 0;

                        if (amount <= 0) {
                          return 'Enter a valid payment amount.';
                        }

                        if (amount > widget.order.remaining) {
                          return 'Payment cannot exceed the remaining balance.';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        prefixText: 'Rs ',
                        hintText: '0',
                        suffixIcon: IconButton(
                          tooltip: 'Use full remaining amount',
                          onPressed: _useFullRemaining,
                          icon: const Icon(Icons.auto_fix_high_rounded),
                        ),
                        filled: true,
                        fillColor: isDark
                            ? AppColors.darkSurfaceSoft
                            : AppColors.surfaceSoft,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 13),
                    TextFormField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Payment Note (Optional)',
                        hintText: 'Cash, bank transfer, final payment...',
                        filled: true,
                        fillColor: isDark
                            ? AppColors.darkSurfaceSoft
                            : AppColors.surfaceSoft,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: border),
                ),
                child: Column(
                  children: <Widget>[
                    _PreviewRow(
                      label: 'Current Remaining',
                      value: _money(widget.order.remaining),
                      color: primaryText,
                      secondaryText: secondaryText,
                    ),
                    const SizedBox(height: 11),
                    Divider(height: 1, color: border),
                    const SizedBox(height: 11),
                    _PreviewRow(
                      label: 'Receiving Now',
                      value: _money(_enteredAmount),
                      color: AppColors.info,
                      secondaryText: secondaryText,
                    ),
                    const SizedBox(height: 11),
                    Divider(height: 1, color: border),
                    const SizedBox(height: 11),
                    _PreviewRow(
                      label: 'Balance After Payment',
                      value: _money(afterPayment),
                      color: afterPayment <= 0
                          ? AppColors.success
                          : AppColors.error,
                      secondaryText: secondaryText,
                    ),
                  ],
                ),
              ),
              if (widget.order.payments.isNotEmpty) ...<Widget>[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(17),
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Previous Payments',
                        style: TextStyle(
                          color: primaryText,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...widget.order.payments.reversed.map(
                            (OrderPayment payment) => Padding(
                          padding: const EdgeInsets.only(bottom: 9),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: const Icon(
                                  Icons.payments_rounded,
                                  color: AppColors.success,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 9),
                              Expanded(
                                child: Text(
                                  payment.note.trim().isEmpty
                                      ? 'Payment received'
                                      : payment.note,
                                  style: TextStyle(
                                    color: primaryText,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Text(
                                _money(payment.amount),
                                style: const TextStyle(
                                  color: AppColors.success,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: card,
            border: Border(top: BorderSide(color: border)),
          ),
          child: _ResponsiveFooter(
            maxWidth: contentMaxWidth,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth <= 360 ? 12 : 16,
                10,
                screenWidth <= 360 ? 12 : 16,
                12,
              ),
              child: FilledButton.icon(
                onPressed: _saving ? null : _savePayment,
                icon: _saving
                    ? const SizedBox(
                  width: 17,
                  height: 17,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.check_circle_rounded),
                label: Text(_saving ? 'Saving Payment...' : 'Receive Payment'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopAmount extends StatelessWidget {
  const _TopAmount({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({
    required this.label,
    required this.value,
    required this.color,
    required this.secondaryText,
  });

  final String label;
  final String value;
  final Color color;
  final Color secondaryText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: secondaryText,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _ResponsiveContent extends StatelessWidget {
  const _ResponsiveContent({
    required this.maxWidth,
    required this.child,
  });

  final double maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: SizedBox(
          width: double.infinity,
          child: child,
        ),
      ),
    );
  }
}



class _ResponsiveFooter extends StatelessWidget {
  const _ResponsiveFooter({
    required this.maxWidth,
    required this.child,
  });

  final double maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: SizedBox(
          width: double.infinity,
          child: child,
        ),
      ),
    );
  }
}
