import 'package:flutter/material.dart';

import 'package:tailorx/core/constants/app_colors.dart';
import 'package:tailorx/features/customers/presentation/screens/customer_profile_screen.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({
    super.key,
    required this.customer,
    this.onOrderSaved,
  });

  final CustomerProfileData customer;
  final ValueChanged<NewOrderData>? onOrderSaved;

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _advanceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final Map<String, TextEditingController> _measurementControllers =
  <String, TextEditingController>{};
  final Map<String, String> _designSelections = <String, String>{};

  String? _selectedKidsGroup;
  String? _selectedDress;

  bool _showKidsGroupOptions = false;
  bool _showDressOptions = false;
  bool _addMeasurements = true;
  bool _isSaving = false;

  DateTime _orderDate = DateTime.now();
  DateTime _deliveryDate = DateTime.now().add(const Duration(days: 7));

  String _priority = 'Normal';
  String _status = 'Pending';
  String _paymentMethod = 'Advance';

  static const List<String> _priorities = <String>[
    'Normal',
    'Urgent',
    'Express',
  ];

  static const List<String> _statuses = <String>[
    'Pending',
    'In Progress',
    'Ready',
    'Delivered',
    'Cancelled',
  ];

  static const Map<String, List<String>> _dressCategories =
  <String, List<String>>{
    'Gents': <String>[
      'Kurta',
      'Shalwar Kameez',
      'Pant / Trousers',
      'Dress Shirt',
      'T-Shirt / Polo Shirt',
      'Sherwani',
      'Waistcoat',
      'Suit Jacket / Blazer',
      'Safari Suit',
      'Shorts / Cargo Shorts',
    ],
    'Ladies': <String>[
      'Shalwar Kameez',
      'Kurti / Tunics',
      'Frock / Maxis',
      'Lehenga Choli',
      'Saree Blouse',
      'Gown',
      'Palazzo / Culottes',
      'Tights / Leggings',
      'Abaya / Burqa',
      'Ladies Shirt / Top',
      'Kafeetan / Kaftan',
    ],
  };

  static const Map<String, List<String>> _kidsDressCategories =
  <String, List<String>>{
    'Boys': <String>[
      'Baba Shalwar Kameez',
      'Baba Kurta Pajama',
      'Kids T-Shirt',
      'Kids Shirt',
      'Jeans / Trousers',
      'Shorts / Half Pants',
      'Sherwani / Waistcoat Suit',
      'Baba Romper / Dungaree',
    ],
    'Girls': <String>[
      'Baby Frock',
      'Lehenga Choli / Ghagra',
      'Baby Shalwar Kameez',
      'Kurti / Tunic',
      'Maxi Dress',
      'Tights / Leggings',
      'Skirt / Skort',
      'Jumpsuit / Romper',
    ],
    'New Born / Infants': <String>[
      'Onesies / Bodysuits',
      'Baby Romper',
      'Jabla / Cloth Bib Set',
    ],
  };

  bool get _isDark =>
      Theme.of(context).brightness == Brightness.dark;

  Color get _background =>
      _isDark ? AppColors.darkScaffold : AppColors.scaffold;

  Color get _surface =>
      _isDark ? AppColors.darkSurface : AppColors.surface;

  Color get _softSurface =>
      _isDark ? AppColors.darkSurfaceSoft : AppColors.surfaceSoft;

  Color get _border =>
      _isDark ? AppColors.darkBorder : AppColors.border;

  Color get _primaryText =>
      _isDark ? AppColors.darkText : AppColors.textPrimary;

  Color get _secondaryText =>
      _isDark ? AppColors.grey400 : AppColors.textSecondary;

  bool get _isKids {
    final String category = widget.customer.category.toLowerCase();
    return category.contains('kid') ||
        category.contains('boy') ||
        category.contains('girl') ||
        category.contains('infant') ||
        category.contains('new born');
  }

  bool get _isLadies =>
      widget.customer.category.toLowerCase().contains('lad');

  List<String> get _availableDresses {
    if (_isKids) {
      if (_selectedKidsGroup == null) {
        return const <String>[];
      }
      return _kidsDressCategories[_selectedKidsGroup] ??
          const <String>[];
    }

    if (_isLadies) {
      return _dressCategories['Ladies']!;
    }

    return _dressCategories['Gents']!;
  }

  List<String> get _currentMeasurementFields {
    if (_selectedDress == null) {
      return const <String>[];
    }
    return _fieldsForDress(_selectedDress!);
  }

  Map<String, List<String>> get _currentDesignOptions {
    if (_selectedDress == null) {
      return const <String, List<String>>{};
    }
    return _designOptionsForDress(_selectedDress!);
  }

  double get _totalAmount =>
      double.tryParse(_totalController.text.trim()) ?? 0;

  double get _advanceAmount {
    if (_paymentMethod == 'Full Payment') {
      return _totalAmount;
    }
    if (_paymentMethod == 'Pay After Delivery') {
      return 0;
    }
    return double.tryParse(_advanceController.text.trim()) ?? 0;
  }

  double get _remainingAmount {
    if (_paymentMethod == 'Full Payment') {
      return 0;
    }
    if (_paymentMethod == 'Pay After Delivery') {
      return _totalAmount;
    }
    return (_totalAmount - _advanceAmount).clamp(0, double.infinity);
  }

  @override
  void dispose() {
    _totalController.dispose();
    _advanceController.dispose();
    _notesController.dispose();

    for (final TextEditingController controller
    in _measurementControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  TextEditingController _measurementController(String field) {
    return _measurementControllers.putIfAbsent(
      field,
          () => TextEditingController(),
    );
  }

  void _clearDressData() {
    for (final TextEditingController controller
    in _measurementControllers.values) {
      controller.clear();
    }
    _designSelections.clear();
    _notesController.clear();
  }

  void _selectKidsGroup(String group) {
    setState(() {
      _selectedKidsGroup = group;
      _selectedDress = null;
      _showKidsGroupOptions = false;
      _showDressOptions = false;
      _clearDressData();
    });
  }

  void _selectDress(String dress) {
    setState(() {
      _selectedDress = dress;
      _showDressOptions = false;
      _clearDressData();
    });
  }

  List<String> _fieldsForDress(String dress) {
    final String value = dress.toLowerCase();

    if (value == 'kurta') {
      return const <String>[
        'Length',
        'Sleeve',
        'Shoulder',
        'Collar',
        'Chest',
        'Waist',
        'Daman',
        'Cuff',
        'Armhole',
      ];
    }

    if (value == 'shalwar kameez') {
      return const <String>[
        'Kameez Length',
        'Sleeve',
        'Shoulder',
        'Collar / Neck',
        'Chest',
        'Waist',
        'Hip',
        'Shalwar Length',
        'Pancha',
        'Cuff',
        'Armhole',
      ];
    }

    if (value.contains('baba shalwar kameez') ||
        value.contains('baby shalwar kameez') ||
        value.contains('kurta pajama')) {
      return const <String>[
        'Kameez / Kurta Length',
        'Sleeve',
        'Shoulder',
        'Collar',
        'Chest',
        'Waist',
        'Shalwar / Pajama Length',
        'Pancha',
        'Cuff',
      ];
    }

    if (value.contains('pant') ||
        value.contains('trouser') ||
        value.contains('jeans') ||
        value.contains('shorts') ||
        value.contains('palazzo') ||
        value.contains('culottes') ||
        value.contains('tights') ||
        value.contains('leggings') ||
        value.contains('skirt') ||
        value.contains('skort')) {
      return const <String>[
        'Waist',
        'Hip',
        'Length',
        'Rise',
        'Thigh',
        'Knee',
        'Bottom',
      ];
    }

    if (value.contains('shirt') ||
        value.contains('top') ||
        value.contains('t-shirt') ||
        value.contains('polo')) {
      return const <String>[
        'Length',
        'Sleeve',
        'Shoulder',
        'Chest',
        'Waist',
        'Hip',
        'Collar / Neck',
        'Cuff',
        'Armhole',
      ];
    }

    if (value.contains('kurti') ||
        value.contains('tunic') ||
        value.contains('jabla')) {
      return const <String>[
        'Length',
        'Sleeve',
        'Shoulder',
        'Chest',
        'Waist',
        'Hip',
        'Neck',
        'Daman',
      ];
    }

    if (value.contains('frock') ||
        value.contains('maxi') ||
        value.contains('gown') ||
        value.contains('lehenga') ||
        value.contains('ghagra')) {
      return const <String>[
        'Full Length',
        'Body Length',
        'Shoulder',
        'Chest / Bust',
        'Waist',
        'Hip',
        'Sleeve',
        'Neck',
        'Ghera',
      ];
    }

    if (value.contains('saree blouse')) {
      return const <String>[
        'Blouse Length',
        'Shoulder',
        'Bust',
        'Under Bust',
        'Waist',
        'Armhole',
        'Sleeve',
        'Sleeve Round',
        'Front Neck Depth',
        'Back Neck Depth',
      ];
    }

    if (value.contains('abaya') ||
        value.contains('burqa') ||
        value.contains('kaftan') ||
        value.contains('kafeetan')) {
      return const <String>[
        'Full Length',
        'Shoulder',
        'Chest / Bust',
        'Waist',
        'Hip',
        'Sleeve',
        'Armhole',
        'Neck',
        'Bottom Width',
      ];
    }

    if (value.contains('sherwani')) {
      return const <String>[
        'Length',
        'Shoulder',
        'Chest',
        'Waist',
        'Hip',
        'Sleeve',
        'Collar',
        'Cuff',
        'Armhole',
      ];
    }

    if (value.contains('waistcoat')) {
      return const <String>[
        'Length',
        'Shoulder',
        'Chest',
        'Waist',
        'Hip',
        'Neck',
      ];
    }

    if (value.contains('blazer') ||
        value.contains('suit jacket')) {
      return const <String>[
        'Jacket Length',
        'Shoulder',
        'Chest',
        'Waist',
        'Hip',
        'Sleeve',
        'Armhole',
        'Collar',
      ];
    }

    if (value.contains('safari suit')) {
      return const <String>[
        'Shirt Length',
        'Sleeve',
        'Shoulder',
        'Chest',
        'Waist',
        'Collar',
        'Trouser Waist',
        'Trouser Length',
        'Bottom',
      ];
    }

    if (value.contains('romper') ||
        value.contains('dungaree') ||
        value.contains('jumpsuit') ||
        value.contains('onesies') ||
        value.contains('bodysuit')) {
      return const <String>[
        'Full Length',
        'Shoulder',
        'Chest',
        'Waist',
        'Hip',
        'Sleeve',
        'Inseam',
      ];
    }

    return const <String>[
      'Length',
      'Shoulder',
      'Chest',
      'Waist',
      'Sleeve',
    ];
  }

  Map<String, List<String>> _designOptionsForDress(String dress) {
    final String value = dress.toLowerCase();

    if (value == 'kurta' ||
        value == 'shalwar kameez' ||
        value.contains('shalwar kameez') ||
        value.contains('kurta pajama')) {
      return const <String, List<String>>{
        'Pocket': <String>[
          'One Side Pocket',
          'Double Side Pocket',
          'No Side Pockets',
        ],
        'Front Pocket': <String>['Yes', 'No'],
        'Collar Style': <String>[
          'Bag Collar',
          'Small Collar',
          'Band Collar',
        ],
        'Daman Style': <String>[
          'Straight Daman',
          'Rounded Daman',
        ],
        'Salahi': <String>[
          'Single Salahi',
          'Double Salahi',
        ],
        'Chamak Patti': <String>[
          'Single Chamak Patti',
          'Double Chamak Patti',
          'No Chamak Patti',
        ],
      };
    }

    if (value.contains('shirt') ||
        value.contains('top') ||
        value.contains('polo')) {
      return const <String, List<String>>{
        'Collar Style': <String>[
          'Classic Collar',
          'Button Down Collar',
          'Band Collar',
        ],
        'Front Pocket': <String>['Yes', 'No'],
        'Cuff Style': <String>[
          'Round Cuff',
          'Square Cuff',
          'Double Cuff',
        ],
        'Fit': <String>[
          'Regular Fit',
          'Slim Fit',
          'Loose Fit',
        ],
      };
    }

    if (value.contains('pant') ||
        value.contains('trouser') ||
        value.contains('jeans') ||
        value.contains('shorts') ||
        value.contains('palazzo') ||
        value.contains('leggings')) {
      return const <String, List<String>>{
        'Belt Style': <String>[
          'Normal Belt',
          'Elastic Belt',
          'Half Elastic',
        ],
        'Front Pleats': <String>[
          'No Pleats',
          'Single Pleat',
          'Double Pleats',
        ],
        'Pocket Style': <String>[
          'Side Pockets',
          'Back Pocket',
          'Both',
          'No Pocket',
        ],
        'Bottom Style': <String>[
          'Straight',
          'Narrow',
          'Cuff',
        ],
      };
    }

    if (value.contains('waistcoat') ||
        value.contains('sherwani') ||
        value.contains('blazer') ||
        value.contains('jacket')) {
      return const <String, List<String>>{
        'Collar Style': <String>[
          'Band Collar',
          'V Neck',
          'Shawl Collar',
          'Notch Collar',
        ],
        'Buttons': <String>[
          '3 Buttons',
          '4 Buttons',
          '5 Buttons',
          '6 Buttons',
        ],
        'Pocket Style': <String>[
          'Welt Pocket',
          'Flap Pocket',
          'No Pocket',
        ],
        'Fit': <String>[
          'Regular Fit',
          'Slim Fit',
          'Loose Fit',
        ],
      };
    }

    if (value.contains('frock') ||
        value.contains('maxi') ||
        value.contains('gown') ||
        value.contains('lehenga')) {
      return const <String, List<String>>{
        'Neck Style': <String>[
          'Round Neck',
          'V Neck',
          'Square Neck',
          'Boat Neck',
        ],
        'Sleeve Style': <String>[
          'Full Sleeve',
          'Half Sleeve',
          'Sleeveless',
        ],
        'Fit': <String>[
          'Regular Fit',
          'Fitted',
          'Loose Fit',
        ],
        'Flare': <String>[
          'Normal Flare',
          'Wide Flare',
          'Extra Wide Flare',
        ],
      };
    }

    return const <String, List<String>>{};
  }

  Future<void> _pickDate({required bool delivery}) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: delivery ? _deliveryDate : _orderDate,
      firstDate: delivery
          ? _orderDate
          : DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      helpText: delivery ? 'Select Delivery Date' : 'Select Order Date',
    );

    if (selected == null || !mounted) {
      return;
    }

    setState(() {
      if (delivery) {
        _deliveryDate = selected;
      } else {
        _orderDate = selected;
        if (_deliveryDate.isBefore(_orderDate)) {
          _deliveryDate = _orderDate.add(const Duration(days: 7));
        }
      }
    });
  }

  bool _validateBeforeSave() {
    FocusScope.of(context).unfocus();

    if (_isKids && _selectedKidsGroup == null) {
      _showMessage(
        'Select Boys, Girls or New Born group.',
        isError: true,
      );
      return false;
    }

    if (_selectedDress == null) {
      _showMessage('Select a dress type.', isError: true);
      return false;
    }

    if (_addMeasurements) {
      for (final String field in _currentMeasurementFields) {
        final String value =
        _measurementController(field).text.trim();

        if (value.isEmpty) {
          _showMessage(
            'Enter $field measurement.',
            isError: true,
          );
          return false;
        }

        final double? number = double.tryParse(value);

        if (number == null || number <= 0) {
          _showMessage(
            'Enter a valid $field measurement.',
            isError: true,
          );
          return false;
        }
      }
    }

    if (!(_formKey.currentState?.validate() ?? false)) {
      return false;
    }

    if (_deliveryDate.isBefore(_orderDate)) {
      _showMessage(
        'Delivery date cannot be before order date.',
        isError: true,
      );
      return false;
    }

    if (_advanceAmount > _totalAmount) {
      _showMessage(
        'Advance cannot be greater than total amount.',
        isError: true,
      );
      return false;
    }

    return true;
  }

  Future<void> _saveOrder() async {
    if (!_validateBeforeSave()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final Map<String, String> measurements = <String, String>{
        if (_addMeasurements)
          for (final String field in _currentMeasurementFields)
            field: _measurementController(field).text.trim(),
      };

      final NewOrderData result = NewOrderData(
        customerId: widget.customer.id,
        customerCode: widget.customer.customerCode,
        customerCategory: widget.customer.category,
        kidsGroup: _selectedKidsGroup,
        dressType: _selectedDress!,
        addMeasurements: _addMeasurements,
        measurements: measurements,
        designDetails:
        Map<String, String>.from(_designSelections),
        notes: _notesController.text.trim(),
        orderDate: _orderDate,
        deliveryDate: _deliveryDate,
        priority: _priority,
        status: _status,
        paymentMethod: _paymentMethod,
        totalAmount: _totalAmount,
        advanceAmount: _advanceAmount,
        remainingAmount: _remainingAmount,
      );

      debugPrint('New order payload: ${result.toJson()}');

      await Future<void>.delayed(
        const Duration(milliseconds: 400),
      );

      if (!mounted) {
        return;
      }

      widget.onOrderSaved?.call(result);
      Navigator.of(context).pop(result);
    } catch (_) {
      if (mounted) {
        _showMessage(
          'Order could not be saved.',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showMessage(
      String message, {
        required bool isError,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor:
        isError ? AppColors.error : AppColors.success,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: AppColors.whiteText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isWide = screenWidth >= 760;
    final double contentMaxWidth = screenWidth >= 1200
        ? 1040
        : screenWidth >= 760
        ? 900
        : 620;

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: _primaryText,
        titleSpacing: 0,
        title: Text(
          'Add New Order',
          style: TextStyle(
            color: _primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: _ResponsiveContent(
          maxWidth: contentMaxWidth,
          child: Form(
            key: _formKey,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 110),
              children: <Widget>[
                _buildCustomerCard(),
                const SizedBox(height: 18),
                _buildSectionCard(
                  title: '1. Select Dress',
                  subtitle:
                  'Tap Select Dress, choose one dress, and the list will close.',
                  icon: Icons.checkroom_rounded,
                  child: Column(
                    children: <Widget>[
                      if (_isKids) ...<Widget>[
                        _buildKidsGroupSelector(),
                        const SizedBox(height: 12),
                      ],
                      _buildDressSelector(),
                    ],
                  ),
                ),
                if (_selectedDress != null) ...<Widget>[
                  const SizedBox(height: 14),
                  _buildSectionCard(
                    title: '2. Measurements',
                    subtitle:
                    'Measurement fields match the selected dress.',
                    icon: Icons.straighten_rounded,
                    child: _buildMeasurements(isWide),
                  ),
                  if (_currentDesignOptions.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 14),
                    _buildSectionCard(
                      title: '3. Design Details',
                      subtitle:
                      'Select stitching and design preferences.',
                      icon: Icons.design_services_rounded,
                      child: _buildDesignDetails(),
                    ),
                  ],
                  const SizedBox(height: 14),
                  _buildSectionCard(
                    title: 'Tailor Notes',
                    subtitle:
                    'Write optional fitting or stitching instructions.',
                    icon: Icons.notes_rounded,
                    child: TextFormField(
                      controller: _notesController,
                      minLines: 3,
                      maxLines: 6,
                      decoration: _inputDecoration(
                        label: 'Tailor Notes',
                        hint:
                        'Loose fitting, extra stitching, urgent delivery...',
                        icon: Icons.edit_note_rounded,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildSectionCard(
                    title: 'Order Details',
                    subtitle:
                    'Set dates, priority, status and payment.',
                    icon: Icons.event_note_rounded,
                    child: _buildOrderAndPayment(isWide),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomSaveArea(),
    );
  }

  Widget _buildCustomerCard() {
    final String initial = widget.customer.name.trim().isEmpty
        ? 'C'
        : widget.customer.name.trim()[0].toUpperCase();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 62,
            height: 62,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: widget.customer.photoUrl != null &&
                widget.customer.photoUrl!.trim().isNotEmpty
                ? Image.network(
              widget.customer.photoUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Center(
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: AppColors.whiteText,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            )
                : Center(
              child: Text(
                initial,
                style: const TextStyle(
                  color: AppColors.whiteText,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.customer.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.whiteText,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${widget.customer.customerCode} • ${widget.customer.category}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.customer.phone,
                  style: const TextStyle(
                    color: AppColors.whiteText,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: _border),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(
              alpha: _isDark ? 0.13 : 0.045,
            ),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: AppColors.whiteText,
                  size: 21,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        color: _primaryText,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: _secondaryText,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildKidsGroupSelector() {
    const List<_SelectorOption> groups = <_SelectorOption>[
      _SelectorOption(
        title: 'Boys',
        icon: Icons.boy_rounded,
      ),
      _SelectorOption(
        title: 'Girls',
        icon: Icons.girl_rounded,
      ),
      _SelectorOption(
        title: 'New Born / Infants',
        icon: Icons.child_friendly_rounded,
      ),
    ];

    return Column(
      children: <Widget>[
        _buildSelectorHeader(
          selectedValue: _selectedKidsGroup,
          placeholder: 'Select Kids Group',
          subtitle: _selectedKidsGroup == null
              ? 'Choose Boys, Girls or New Born'
              : 'Tap to change group',
          icon: Icons.family_restroom_rounded,
          isOpen: _showKidsGroupOptions,
          onTap: () {
            setState(() {
              _showKidsGroupOptions =
              !_showKidsGroupOptions;
              _showDressOptions = false;
            });
          },
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          child: !_showKidsGroupOptions
              ? const SizedBox.shrink()
              : Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: groups
                  .map(
                    (_SelectorOption item) => Padding(
                  padding:
                  const EdgeInsets.only(bottom: 9),
                  child: _buildSelectorTile(
                    title: item.title,
                    icon: item.icon,
                    selected:
                    _selectedKidsGroup == item.title,
                    onTap: () =>
                        _selectKidsGroup(item.title),
                  ),
                ),
              )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDressSelector() {
    final bool enabled =
        !_isKids || _selectedKidsGroup != null;

    return Column(
      children: <Widget>[
        _buildSelectorHeader(
          selectedValue: _selectedDress,
          placeholder: enabled
              ? 'Select Dress Type'
              : 'Select Kids Group First',
          subtitle: _selectedDress == null
              ? enabled
              ? 'Choose one dress for this order'
              : 'Choose Boys, Girls or New Born above'
              : 'Tap to change dress',
          icon: Icons.checkroom_rounded,
          isOpen: _showDressOptions,
          enabled: enabled,
          onTap: () {
            setState(() {
              _showDressOptions = !_showDressOptions;
              _showKidsGroupOptions = false;
            });
          },
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          child: !_showDressOptions || !enabled
              ? const SizedBox.shrink()
              : Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: _availableDresses
                  .map(
                    (String dress) => Padding(
                  padding:
                  const EdgeInsets.only(bottom: 9),
                  child: _buildSelectorTile(
                    title: dress,
                    icon: _dressIcon(dress),
                    selected: _selectedDress == dress,
                    onTap: () => _selectDress(dress),
                  ),
                ),
              )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectorHeader({
    required String? selectedValue,
    required String placeholder,
    required String subtitle,
    required IconData icon,
    required bool isOpen,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    final bool selected = selectedValue != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          decoration: BoxDecoration(
            gradient:
            selected ? AppColors.buttonGradient : null,
            color: selected ? null : _softSurface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? AppColors.primaryLight
                  : _border,
            ),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.16)
                      : AppColors.primary
                      .withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: selected
                      ? AppColors.whiteText
                      : enabled
                      ? AppColors.primary
                      : _secondaryText,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      selectedValue ?? placeholder,
                      style: TextStyle(
                        color: selected
                            ? AppColors.whiteText
                            : _primaryText,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: selected
                            ? Colors.white70
                            : _secondaryText,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedRotation(
                turns: isOpen ? 0.5 : 0,
                duration: const Duration(milliseconds: 220),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: selected
                      ? AppColors.whiteText
                      : enabled
                      ? AppColors.primary
                      : _secondaryText,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectorTile({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            gradient:
            selected ? AppColors.buttonGradient : null,
            color: selected ? null : _softSurface,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: selected
                  ? AppColors.primaryLight
                  : _border,
            ),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                color: selected
                    ? AppColors.whiteText
                    : AppColors.primary,
                size: 21,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: selected
                        ? AppColors.whiteText
                        : _primaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.whiteText,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _dressIcon(String dress) {
    final String value = dress.toLowerCase();

    if (value.contains('frock') ||
        value.contains('maxi') ||
        value.contains('gown') ||
        value.contains('lehenga') ||
        value.contains('abaya')) {
      return Icons.woman_rounded;
    }

    if (value.contains('romper') ||
        value.contains('onesies') ||
        value.contains('jabla')) {
      return Icons.child_friendly_rounded;
    }

    if (value.contains('waistcoat') ||
        value.contains('sherwani') ||
        value.contains('blazer')) {
      return Icons.business_center_rounded;
    }

    if (value.contains('pant') ||
        value.contains('trouser') ||
        value.contains('jeans') ||
        value.contains('shorts')) {
      return Icons.accessibility_new_rounded;
    }

    return Icons.dry_cleaning_rounded;
  }

  Widget _buildMeasurements(bool isWide) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _softSurface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _border),
          ),
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.straighten_rounded,
                color: AppColors.primary,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  _addMeasurements
                      ? 'Add new measurements for this order'
                      : 'Save order without new measurements',
                  style: TextStyle(
                    color: _primaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Switch.adaptive(
                value: _addMeasurements,
                activeTrackColor: AppColors.primary,
                onChanged: (bool value) {
                  setState(() {
                    _addMeasurements = value;
                  });
                },
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 280),
          child: !_addMeasurements
              ? const SizedBox.shrink()
              : Padding(
            padding: const EdgeInsets.only(top: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics:
              const NeverScrollableScrollPhysics(),
              itemCount:
              _currentMeasurementFields.length,
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWide ? 3 : 2,
                crossAxisSpacing: 11,
                mainAxisSpacing: 11,
                childAspectRatio:
                isWide ? 2.9 : 2.15,
              ),
              itemBuilder:
                  (BuildContext context, int index) {
                final String field =
                _currentMeasurementFields[index];

                return TextFormField(
                  controller:
                  _measurementController(field),
                  keyboardType:
                  const TextInputType
                      .numberWithOptions(
                    decimal: true,
                  ),
                  decoration: _inputDecoration(
                    label: field,
                    hint: '0.0',
                    icon:
                    Icons.straighten_rounded,
                    suffixText: 'in',
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesignDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _currentDesignOptions.entries
          .map(
            (MapEntry<String, List<String>> entry) =>
            _buildDesignGroup(
              title: entry.key,
              options: entry.value,
            ),
      )
          .toList(),
    );
  }

  Widget _buildDesignGroup({
    required String title,
    required List<String> options,
  }) {
    final String? selectedValue =
    _designSelections[title];

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: _primaryText,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((String option) {
              final bool selected =
                  selectedValue == option;

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _designSelections[title] = option;
                    });
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration:
                    const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: selected
                          ? AppColors.primaryGradient
                          : null,
                      color: selected ? null : _softSurface,
                      borderRadius:
                      BorderRadius.circular(14),
                      border: Border.all(
                        color: selected
                            ? Colors.transparent
                            : _border,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          selected
                              ? Icons
                              .check_circle_rounded
                              : Icons.circle_outlined,
                          color: selected
                              ? AppColors.whiteText
                              : _secondaryText,
                          size: 16,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          option,
                          style: TextStyle(
                            color: selected
                                ? AppColors.whiteText
                                : _primaryText,
                            fontSize: 10,
                            fontWeight:
                            FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderAndPayment(bool isWide) {
    final Widget orderDate = _buildDateTile(
      title: 'Order Date',
      date: _orderDate,
      icon: Icons.today_rounded,
      onTap: () => _pickDate(delivery: false),
    );

    final Widget deliveryDate = _buildDateTile(
      title: 'Delivery Date',
      date: _deliveryDate,
      icon: Icons.event_available_rounded,
      onTap: () => _pickDate(delivery: true),
    );

    return Column(
      children: <Widget>[
        if (isWide)
          Row(
            children: <Widget>[
              Expanded(child: orderDate),
              const SizedBox(width: 10),
              Expanded(child: deliveryDate),
            ],
          )
        else ...<Widget>[
          orderDate,
          const SizedBox(height: 10),
          deliveryDate,
        ],
        const SizedBox(height: 12),
        _buildDropdown(
          label: 'Priority',
          value: _priority,
          values: _priorities,
          icon: Icons.flag_rounded,
          onChanged: (String value) {
            setState(() {
              _priority = value;
            });
          },
        ),
        const SizedBox(height: 12),
        _buildDropdown(
          label: 'Order Status',
          value: _status,
          values: _statuses,
          icon: Icons.track_changes_rounded,
          onChanged: (String value) {
            setState(() {
              _status = value;
            });
          },
        ),
        const SizedBox(height: 16),
        _buildPaymentSection(),
      ],
    );
  }

  Widget _buildDateTile({
    required String title,
    required DateTime date,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: _softSurface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: _border),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        color: _secondaryText,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _displayDate(date),
                      style: TextStyle(
                        color: _primaryText,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.edit_calendar_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> values,
    required IconData icon,
    required ValueChanged<String> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      dropdownColor: _surface,
      decoration: _inputDecoration(
        label: label,
        icon: icon,
      ),
      items: values
          .map(
            (String item) =>
            DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ),
      )
          .toList(),
      onChanged: (String? selected) {
        if (selected != null) {
          onChanged(selected);
        }
      },
    );
  }

  Widget _buildPaymentSection() {
    const List<String> methods = <String>[
      'Advance',
      'Full Payment',
      'Pay After Delivery',
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _softSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Payment Details',
            style: TextStyle(
              color: _primaryText,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          ...methods.map(_buildPaymentMethod),
          const SizedBox(height: 4),
          TextFormField(
            controller: _totalController,
            keyboardType:
            const TextInputType.numberWithOptions(
              decimal: true,
            ),
            onChanged: (_) => setState(() {}),
            decoration: _inputDecoration(
              label: 'Total Amount',
              hint: '0',
              icon:
              Icons.account_balance_wallet_rounded,
              prefixText: 'Rs ',
            ),
            validator: (String? value) {
              final double? amount =
              double.tryParse(value?.trim() ?? '');

              if (amount == null || amount <= 0) {
                return 'Enter a valid total amount';
              }

              return null;
            },
          ),
          if (_paymentMethod == 'Advance') ...<Widget>[
            const SizedBox(height: 12),
            TextFormField(
              controller: _advanceController,
              keyboardType:
              const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) => setState(() {}),
              decoration: _inputDecoration(
                label: 'Advance Paid',
                hint: '0',
                icon: Icons.price_check_rounded,
                prefixText: 'Rs ',
              ),
              validator: (String? value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return null;
                }

                final double? amount =
                double.tryParse(value.trim());

                if (amount == null || amount < 0) {
                  return 'Enter a valid advance amount';
                }

                return null;
              },
            ),
          ],
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color:
              AppColors.warning.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color:
                AppColors.warning.withValues(alpha: 0.28),
              ),
            ),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.calculate_rounded,
                  color: AppColors.warning,
                  size: 21,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Remaining Balance',
                    style: TextStyle(
                      color: _primaryText,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  'Rs ${_remainingAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColors.secondaryDark,
                    fontSize: 14,
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

  Widget _buildPaymentMethod(String method) {
    final bool selected = _paymentMethod == method;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _paymentMethod = method;

              if (method != 'Advance') {
                _advanceController.clear();
              }
            });
          },
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primary
                  .withValues(alpha: 0.11)
                  : _surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected
                    ? AppColors.primary
                    : _border,
              ),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  selected
                      ? Icons
                      .radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: selected
                      ? AppColors.primary
                      : _secondaryText,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  method,
                  style: TextStyle(
                    color: _primaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    String? hint,
    IconData? icon,
    String? prefixText,
    String? suffixText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixText: prefixText,
      suffixText: suffixText,
      prefixIcon: icon == null
          ? null
          : Icon(
        icon,
        color: AppColors.primary,
        size: 19,
      ),
      filled: true,
      fillColor: _softSurface,
      labelStyle: TextStyle(
        color: _secondaryText,
        fontSize: 10,
        fontWeight: FontWeight.w700,
      ),
      hintStyle: TextStyle(
        color: _secondaryText,
        fontSize: 10,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: _border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildBottomSaveArea() {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double footerMaxWidth = screenWidth >= 1200
        ? 1040
        : screenWidth >= 760
        ? 900
        : 620;

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: _surface,
          border: Border(
            top: BorderSide(color: _border),
          ),
        ),
        child: _ResponsiveFooter(
          maxWidth: footerMaxWidth,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              screenWidth <= 360 ? 12 : 16,
              12,
              screenWidth <= 360 ? 12 : 16,
              14,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: ElevatedButton(
                onPressed:
                _isSaving ? null : _saveOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  disabledBackgroundColor:
                  Colors.transparent,
                  foregroundColor: AppColors.whiteText,
                  shadowColor: Colors.transparent,
                  padding:
                  const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: AppColors.whiteText,
                  ),
                )
                    : const Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.save_rounded,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'SAVE ORDER',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectorOption {
  const _SelectorOption({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;
}

String _displayDate(DateTime date) {
  const List<String> months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final String day =
  date.day.toString().padLeft(2, '0');

  return '$day ${months[date.month - 1]} ${date.year}';
}

String _apiDate(DateTime date) {
  final String month =
  date.month.toString().padLeft(2, '0');
  final String day =
  date.day.toString().padLeft(2, '0');

  return '${date.year}-$month-$day';
}

class NewOrderData {
  const NewOrderData({
    required this.customerId,
    required this.customerCode,
    required this.customerCategory,
    required this.kidsGroup,
    required this.dressType,
    required this.addMeasurements,
    required this.measurements,
    required this.designDetails,
    required this.notes,
    required this.orderDate,
    required this.deliveryDate,
    required this.priority,
    required this.status,
    required this.paymentMethod,
    required this.totalAmount,
    required this.advanceAmount,
    required this.remainingAmount,
  });

  final String customerId;
  final String customerCode;
  final String customerCategory;
  final String? kidsGroup;
  final String dressType;
  final bool addMeasurements;
  final Map<String, String> measurements;
  final Map<String, String> designDetails;
  final String notes;
  final DateTime orderDate;
  final DateTime deliveryDate;
  final String priority;
  final String status;
  final String paymentMethod;
  final double totalAmount;
  final double advanceAmount;
  final double remainingAmount;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'customer_id': customerId,
      'customer_code': customerCode,
      'customer_category': customerCategory,
      'kids_group': kidsGroup,
      'dress_type': dressType,
      'add_measurements': addMeasurements,
      'measurements': measurements,
      'design_details': designDetails,
      'notes': notes,
      'order_date': _apiDate(orderDate),
      'delivery_date': _apiDate(deliveryDate),
      'priority': priority,
      'status': status,
      'payment_method': paymentMethod,
      'total_amount': totalAmount,
      'advance_amount': advanceAmount,
      'remaining_amount': remainingAmount,
    };
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
