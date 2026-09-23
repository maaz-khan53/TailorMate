import 'package:flutter/material.dart';

import 'package:tailorx/core/constants/app_colors.dart';

class AddSavedMeasurementOrderScreen extends StatefulWidget {
  const AddSavedMeasurementOrderScreen({
    super.key,
    required this.customerId,
    required this.customerName,
    required this.customerCode,
    required this.customerCategory,
    required this.customerPhone,
    required this.dressType,
    required this.measurements,
    required this.measurementRecordId,
    this.measurementNotes = '',
  });

  final String customerId;
  final String customerName;
  final String customerCode;
  final String customerCategory;
  final String customerPhone;
  final String dressType;
  final Map<String, String> measurements;
  final String measurementRecordId;
  final String measurementNotes;

  @override
  State<AddSavedMeasurementOrderScreen> createState() =>
      _AddSavedMeasurementOrderScreenState();
}

class _AddSavedMeasurementOrderScreenState
    extends State<AddSavedMeasurementOrderScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _totalController;
  late final TextEditingController _advanceController;
  late final TextEditingController _notesController;

  DateTime _deliveryDate = DateTime.now().add(const Duration(days: 7));
  String _status = 'Pending';
  String _priority = 'Normal';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _totalController = TextEditingController();
    _advanceController = TextEditingController();
    _notesController = TextEditingController(
      text: widget.measurementNotes,
    );
  }

  @override
  void dispose() {
    _totalController.dispose();
    _advanceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  double get _totalAmount =>
      double.tryParse(_totalController.text.trim()) ?? 0;

  double get _advanceAmount =>
      double.tryParse(_advanceController.text.trim()) ?? 0;

  double get _remainingAmount {
    final double remaining = _totalAmount - _advanceAmount;
    return remaining < 0 ? 0 : remaining;
  }

  Future<void> _pickDeliveryDate() async {
    final DateTime now = DateTime.now();

    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _deliveryDate,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 3),
    );

    if (selected != null && mounted) {
      setState(() {
        _deliveryDate = selected;
      });
    }
  }

  String _formatDate(DateTime date) {
    const List<String> months = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return '${date.day.toString().padLeft(2, '0')} '
        '${months[date.month - 1]} ${date.year}';
  }

  Future<void> _saveOrder() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_advanceAmount > _totalAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Advance amount cannot be greater than total amount.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 350));

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop<SavedMeasurementOrderData>(
      SavedMeasurementOrderData(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        customerId: widget.customerId,
        customerName: widget.customerName,
        customerCode: widget.customerCode,
        dressType: widget.dressType,
        measurements: Map<String, String>.from(widget.measurements),
        measurementRecordId: widget.measurementRecordId,
        orderDate: DateTime.now(),
        deliveryDate: _deliveryDate,
        totalAmount: _totalAmount,
        advanceAmount: _advanceAmount,
        remainingAmount: _remainingAmount,
        status: _status,
        priority: _priority,
        notes: _notesController.text.trim(),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color fill =
    isDark ? AppColors.darkSurfaceSoft : AppColors.surfaceSoft;
    final Color border =
    isDark ? AppColors.darkBorder : AppColors.border;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primary),
      filled: true,
      fillColor: fill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double contentMaxWidth = screenWidth >= 1100
        ? 920
        : screenWidth >= 700
        ? 800
        : 620;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color background =
    isDark ? AppColors.darkScaffold : AppColors.scaffold;
    final Color surface =
    isDark ? AppColors.darkSurface : AppColors.surface;
    final Color softSurface =
    isDark ? AppColors.darkSurfaceSoft : AppColors.surfaceSoft;
    final Color border =
    isDark ? AppColors.darkBorder : AppColors.border;
    final Color primaryText =
    isDark ? AppColors.darkText : AppColors.textPrimary;
    final Color secondaryText =
    isDark ? AppColors.grey400 : AppColors.textSecondary;
    final double horizontalPadding = screenWidth <= 360 ? 12 : 16;

    Widget addToOrdersButton() {
      return DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.buttonGradient,
          borderRadius: BorderRadius.circular(17),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.16),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _saving ? null : _saveOrder,
            icon: _saving
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: AppColors.whiteText,
              ),
            )
                : const Icon(Icons.add_task_rounded, size: 20),
            label: Text(_saving ? 'ADDING...' : 'ADD TO ORDERS'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: AppColors.whiteText,
              disabledBackgroundColor: Colors.transparent,
              disabledForegroundColor: AppColors.whiteText,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: primaryText,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
          child: _ScreenBackButton(
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        titleSpacing: 10,
        title: Text(
          'Add To Order',
          style: TextStyle(
            color: primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentMaxWidth),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      10,
                      horizontalPadding,
                      28,
                    ),
                    children: <Widget>[
                      _CustomerCard(
                        customerName: widget.customerName,
                        customerCode: widget.customerCode,
                        category: widget.customerCategory,
                        phone: widget.customerPhone,
                      ),
                      const SizedBox(height: 14),
                      _SavedDressCard(
                        dressType: widget.dressType,
                        measurements: widget.measurements,
                        surface: surface,
                        softSurface: softSurface,
                        border: border,
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Order Setup',
                              style: TextStyle(
                                color: primaryText,
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Set delivery, payment and order status.',
                              style: TextStyle(
                                color: secondaryText,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 15),
                            InkWell(
                              onTap: _pickDeliveryDate,
                              borderRadius: BorderRadius.circular(15),
                              child: InputDecorator(
                                decoration: _inputDecoration(
                                  label: 'Delivery Date',
                                  icon: Icons.event_available_rounded,
                                ),
                                child: Text(
                                  _formatDate(_deliveryDate),
                                  style: TextStyle(
                                    color: primaryText,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            LayoutBuilder(
                              builder: (
                                  BuildContext context,
                                  BoxConstraints fieldConstraints,
                                  ) {
                                final bool stackAmounts =
                                    fieldConstraints.maxWidth < 430;

                                final Widget totalField = TextFormField(
                                  controller: _totalController,
                                  keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  onChanged: (_) => setState(() {}),
                                  validator: (String? value) {
                                    final double? amount = double.tryParse(
                                      value?.trim() ?? '',
                                    );
                                    if (amount == null || amount <= 0) {
                                      return 'Enter total';
                                    }
                                    return null;
                                  },
                                  decoration: _inputDecoration(
                                    label: 'Total Amount',
                                    hint: '0',
                                    icon: Icons.receipt_long_rounded,
                                  ),
                                );

                                final Widget advanceField = TextFormField(
                                  controller: _advanceController,
                                  keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  onChanged: (_) => setState(() {}),
                                  validator: (String? value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return null;
                                    }
                                    final double? amount =
                                    double.tryParse(value.trim());
                                    if (amount == null || amount < 0) {
                                      return 'Invalid';
                                    }
                                    return null;
                                  },
                                  decoration: _inputDecoration(
                                    label: 'Advance',
                                    hint: '0',
                                    icon: Icons.payments_rounded,
                                  ),
                                );

                                if (stackAmounts) {
                                  return Column(
                                    children: <Widget>[
                                      totalField,
                                      const SizedBox(height: 12),
                                      advanceField,
                                    ],
                                  );
                                }

                                return Row(
                                  children: <Widget>[
                                    Expanded(child: totalField),
                                    const SizedBox(width: 10),
                                    Expanded(child: advanceField),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.account_balance_wallet_rounded,
                                    color: AppColors.warning,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Remaining Amount',
                                      style: TextStyle(
                                        color: secondaryText,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Rs ${_remainingAmount.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      color: primaryText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              initialValue: _status,
                              decoration: _inputDecoration(
                                label: 'Order Status',
                                icon: Icons.timelapse_rounded,
                              ),
                              items: const <String>[
                                'Pending',
                                'In Progress',
                                'Ready',
                              ].map(
                                    (String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ),
                              ).toList(),
                              onChanged: (String? value) {
                                if (value != null) {
                                  setState(() => _status = value);
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              initialValue: _priority,
                              decoration: _inputDecoration(
                                label: 'Priority',
                                icon: Icons.flag_rounded,
                              ),
                              items: const <String>[
                                'Normal',
                                'Urgent',
                                'Very Urgent',
                              ].map(
                                    (String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ),
                              ).toList(),
                              onChanged: (String? value) {
                                if (value != null) {
                                  setState(() => _priority = value);
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _notesController,
                              minLines: 3,
                              maxLines: 5,
                              decoration: _inputDecoration(
                                label: 'Order Notes',
                                hint:
                                'Urgent delivery or special instructions...',
                                icon: Icons.notes_rounded,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      addToOrdersButton(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({
    required this.customerName,
    required this.customerCode,
    required this.category,
    required this.phone,
  });

  final String customerName;
  final String customerCode;
  final String category;
  final String phone;

  @override
  Widget build(BuildContext context) {
    final String initial = customerName.trim().isEmpty
        ? 'C'
        : customerName.trim()[0].toUpperCase();

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 68,
            height: 68,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.whiteText.withValues(alpha: 0.17),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              initial,
              style: const TextStyle(
                color: AppColors.whiteText,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  customerName,
                  style: const TextStyle(
                    color: AppColors.whiteText,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$customerCode • $category',
                  style: TextStyle(
                    color: AppColors.whiteText.withValues(alpha: 0.86),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  phone,
                  style: const TextStyle(
                    color: AppColors.whiteText,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedDressCard extends StatelessWidget {
  const _SavedDressCard({
    required this.dressType,
    required this.measurements,
    required this.surface,
    required this.softSurface,
    required this.border,
    required this.primaryText,
    required this.secondaryText,
  });

  final String dressType;
  final Map<String, String> measurements;
  final Color surface;
  final Color softSurface;
  final Color border;
  final Color primaryText;
  final Color secondaryText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.checkroom_rounded,
                  color: AppColors.whiteText,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  dressType,
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Icon(
                Icons.verified_rounded,
                color: AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: softSurface,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: measurements.entries.map(
                    (MapEntry<String, String> entry) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: border),
                    ),
                    child: Text(
                      '${entry.key}: ${entry.value}',
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}


class _ScreenBackButton extends StatelessWidget {
  const _ScreenBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color surface = isDark ? AppColors.darkSurfaceSoft : Colors.white;
    final Color borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.primary.withValues(alpha: 0.18);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: borderColor),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.045),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.primary,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class SavedMeasurementOrderData {
  const SavedMeasurementOrderData({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerCode,
    required this.dressType,
    required this.measurements,
    required this.measurementRecordId,
    required this.orderDate,
    required this.deliveryDate,
    required this.totalAmount,
    required this.advanceAmount,
    required this.remainingAmount,
    required this.status,
    required this.priority,
    required this.notes,
  });

  final String id;
  final String customerId;
  final String customerName;
  final String customerCode;
  final String dressType;
  final Map<String, String> measurements;
  final String measurementRecordId;
  final DateTime orderDate;
  final DateTime deliveryDate;
  final double totalAmount;
  final double advanceAmount;
  final double remainingAmount;
  final String status;
  final String priority;
  final String notes;
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
