// ADD_CUSTOMER_COMPLETE_AUTO_SCROLL_V5
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import 'responsive_layout.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Used to automatically bring the measurement form to the top
  // immediately after a dress is selected.
  final GlobalKey _measurementFormKey = GlobalKey();

  final ImagePicker _imagePicker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _advanceAmountController = TextEditingController();
  final TextEditingController _tailorNotesController = TextEditingController();

  final Map<String, TextEditingController> _measurementControllers =
  <String, TextEditingController>{};
  final Map<String, String> _designSelections = <String, String>{};

  String? _selectedCategory;
  String? _selectedKidsGroup;
  String? _selectedDress;
  File? _profileImage;

  bool _addMeasurementsNow = false;
  bool _isSaving = false;
  bool _addOrderNow = false;
  DateTime? _orderDate;
  DateTime? _deliveryDate;
  String _paymentMethod = 'Advance';
  double _remainingAmount = 0;
  bool _showCategoryOptions = false;
  bool _showKidsGroupOptions = false;
  bool _showDressOptions = false;

  bool get _isDarkMode =>
      Theme.of(context).brightness == Brightness.dark;

  Color get _scaffoldColor =>
      _isDarkMode ? AppColors.darkScaffold : AppColors.scaffold;

  Color get _surfaceColor =>
      _isDarkMode ? AppColors.darkSurface : AppColors.surface;

  Color get _surfaceSoftColor =>
      _isDarkMode ? AppColors.darkSurfaceSoft : AppColors.surfaceSoft;

  Color get _primaryTextColor =>
      _isDarkMode ? AppColors.darkText : AppColors.textPrimary;

  Color get _secondaryTextColor =>
      _isDarkMode ? AppColors.grey400 : AppColors.textSecondary;

  Color get _borderColor =>
      _isDarkMode ? AppColors.darkBorder : AppColors.border;

  final Map<String, List<String>> _dressCategories =
  const <String, List<String>>{
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

  final Map<String, List<String>> _kidsDressCategories =
  const <String, List<String>>{
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
  };

  final Map<String, List<String>> _measurementFields =
  const <String, List<String>>{
    'Shalwar Kameez': <String>[
      'Length',
      'Sleeve',
      'Shoulder',
      'Collar',
      'Chest',
      'Waist',
      'Shalwar',
      'Pancha',
      'Cuff',
      'Armhole',
    ],
    'Kurta': <String>[
      'Length',
      'Sleeve',
      'Shoulder',
      'Collar',
      'Chest',
      'Waist',
      'Shalwar',
      'Pancha',
      'Cuff',
      'Armhole',
    ],
    'Pant / Trousers': <String>[
      'Waist (Round)',
      'Hip (Round)',
      'Thigh (Round)',
      'Rise',
      'Leg Opening (Round)',
      'Outseam',
      'Inseam',
    ],
    'Dress Shirt': <String>[
      'Collar',
      'Shoulder',
      'Bust / Chest',
      'Sleeve Length',
      'Waist',
      'Bottom Hem',
      'Back Length',
      'Front Length',
      'Cuff',
      'Armhole',
    ],
    'T-Shirt / Polo Shirt': <String>[
      'Shoulder',
      'Collar',
      'Chest',
      'Sleeve',
      'Cuff',
      'Length',
      'Hem',
      'Armhole',
    ],
    'Sherwani': <String>[
      'Shoulder',
      'Neck Collar',
      'Sleeve',
      'Chest',
      'Waist',
      'Length',
      'Bottom Length',
      'Armhole',
    ],
    'Waistcoat': <String>[
      'Collar',
      'Shoulder',
      'Chest',
      'Waist',
      'Length',
      'Hip',
    ],
    'Suit Jacket / Blazer': <String>[
      'Jacket Length',
      'Shoulder',
      'Chest',
      'Waist',
      'Hip',
      'Sleeve',
      'Armhole',
    ],
  };



  Map<String, List<String>> _designOptionsForDress(String dress) {
    if (dress == 'Shalwar Kameez' || dress == 'Kurta') {
      return const <String, List<String>>{
        'Pocket': <String>[
          'One Side Pocket',
          'Double Side Pocket',
          'No Side Pockets',
        ],
        'Front Pocket': <String>[
          'Yes',
          'No',
        ],
        'Collar Style': <String>[
          'Bag Collar',
          'Small Collar',
        ],
        'Daman Style': <String>[
          'Straight Daman',
          'Rounded Daman',
        ],
        'Salahi': <String>[
          'Double Salahi',
          'Single Salahi',
        ],
        'Chamak Patti': <String>[
          'Single Chamak Patti',
          'Double Chamak Patti',
        ],
      };
    }

    if (dress == 'Dress Shirt') {
      return const <String, List<String>>{
        'Front Pocket': <String>[
          'Yes',
          'No',
        ],
      };
    }

    return const <String, List<String>>{};
  }

  Map<String, List<String>> get _currentDesignOptions {
    if (_selectedDress == null) {
      return const <String, List<String>>{};
    }

    return _designOptionsForDress(_selectedDress!);
  }

  List<String> _fieldsForDress(String dress) {
    final List<String>? exact = _measurementFields[dress];

    if (exact != null) {
      return exact;
    }

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
      ];
    }

    if (value.contains('pant') ||
        value.contains('trousers') ||
        value.contains('jeans') ||
        value.contains('shorts') ||
        value.contains('cargo shorts') ||
        value.contains('palazzo') ||
        value.contains('culottes') ||
        value.contains('tights') ||
        value.contains('leggings')) {
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

    if (value.contains('dress shirt') ||
        value.contains('kids shirt') ||
        value.contains('ladies shirt') ||
        value.contains('top') ||
        value.contains('t-shirt') ||
        value.contains('polo shirt')) {
      return const <String>[
        'Length',
        'Sleeve',
        'Shoulder',
        'Chest',
        'Waist',
        'Hip',
        'Collar / Neck',
        'Cuff',
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

    if (value.contains('suit jacket') ||
        value.contains('blazer')) {
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

    return const <String>[
      'Length',
      'Shoulder',
      'Chest',
      'Waist',
      'Sleeve',
    ];
  }

  List<String> get _availableDresses {
    if (_selectedCategory == null) {
      return const <String>[];
    }

    if (_selectedCategory == 'Kids') {
      return <String>[
        ...?_kidsDressCategories['Boys'],
        ...?_kidsDressCategories['Girls'],
        ...?_kidsDressCategories['Kids'],
      ];
    }

    return _dressCategories[_selectedCategory] ?? const <String>[];
  }

  List<String> get _currentMeasurementFields {
    if (_selectedDress == null) {
      return const <String>[];
    }

    return _fieldsForDress(_selectedDress!);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _totalAmountController.dispose();
    _advanceAmountController.dispose();
    _tailorNotesController.dispose();

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

  double _parseAmount(String value) {
    return double.tryParse(value.trim()) ?? 0;
  }

  void _calculateRemainingAmount() {
    final double total = _parseAmount(_totalAmountController.text);
    final double advance = _parseAmount(_advanceAmountController.text);

    setState(() {
      if (_paymentMethod == 'Full Payment') {
        _remainingAmount = 0;
      } else if (_paymentMethod == 'Pay After Delivery') {
        _remainingAmount = total;
      } else {
        _remainingAmount = (total - advance).clamp(0, double.infinity);
      }
    });
  }

  void _selectPaymentMethod(String value) {
    setState(() {
      _paymentMethod = value;

      if (value == 'Full Payment') {
        _advanceAmountController.text = _totalAmountController.text;
      } else if (value == 'Pay After Delivery') {
        _advanceAmountController.clear();
      }
    });

    _calculateRemainingAmount();
  }

  String _formatDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> _selectDeliveryDate() async {
    final DateTime today = DateTime.now();
    final DateTime firstDate = DateTime(
      today.year,
      today.month,
      today.day,
    );

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _deliveryDate ??
          firstDate.add(const Duration(days: 7)),
      firstDate: firstDate,
      lastDate: DateTime(today.year + 5),
      helpText: 'Select Delivery Date',
      cancelText: 'Cancel',
      confirmText: 'Select',
      builder: (
          BuildContext context,
          Widget? child,
          ) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
              secondary: AppColors.primaryLight,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    setState(() {
      _deliveryDate = selectedDate;
    });
  }

  void _toggleOrderSection() {
    setState(() {
      _addOrderNow = !_addOrderNow;

      if (_addOrderNow) {
        final DateTime now = DateTime.now();
        _orderDate = DateTime(now.year, now.month, now.day);
      } else {
        _orderDate = null;
        _deliveryDate = null;
        _paymentMethod = 'Advance';
        _totalAmountController.clear();
        _advanceAmountController.clear();
        _remainingAmount = 0;
      }
    });
  }

  Future<void> _pickProfileImage(ImageSource source) async {
    try {
      final XFile? pickedImage = await _imagePicker.pickImage(
        source: source,
        imageQuality: 78,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (pickedImage == null || !mounted) {
        return;
      }

      setState(() {
        _profileImage = File(pickedImage.path);
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Unable to open ${source == ImageSource.camera ? 'camera' : 'gallery'}. '
            'You can still save the customer without a photo.',
        isError: true,
      );
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _surfaceColor,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (BuildContext sheetContext) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Customer Photo',
                      style: TextStyle(
                        color: _primaryTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Choose camera or gallery. You may skip this if permission is not available.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _secondaryTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _ImageSourceButton(
                            icon: Icons.camera_alt_rounded,
                            title: 'Camera',
                            onTap: () {
                              Navigator.of(sheetContext).pop();
                              _pickProfileImage(ImageSource.camera);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ImageSourceButton(
                            icon: Icons.photo_library_rounded,
                            title: 'Gallery',
                            onTap: () {
                              Navigator.of(sheetContext).pop();
                              _pickProfileImage(ImageSource.gallery);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _selectedKidsGroup = null;
      _selectedDress = null;
      _showCategoryOptions = false;
      _showKidsGroupOptions = false;
      _showDressOptions = false;
      _clearMeasurementValues();
    });
  }

  void _selectKidsGroup(String group) {
    setState(() {
      _selectedKidsGroup = group;
      _selectedDress = null;
      _showKidsGroupOptions = false;
      _showDressOptions = false;
      _clearMeasurementValues();
    });
  }

  void _selectDress(String? dress) {
    setState(() {
      _selectedDress = dress;
      _showDressOptions = false;

      // Important: every new dress starts with NO design selected.
      // The tailor will choose design details manually while taking measurements.
      _clearMeasurementValues();
    });

    if (dress == null) {
      return;
    }

    // Let the dress-options AnimatedSize collapse and the measurement
    // form finish building first. Then bring the form smoothly to the
    // top of the visible scroll area.
    Future<void>.delayed(
      const Duration(milliseconds: 280),
          () {
        if (!mounted) {
          return;
        }

        final BuildContext? formContext =
            _measurementFormKey.currentContext;

        if (formContext == null) {
          return;
        }

        Scrollable.ensureVisible(
          formContext,
          duration: const Duration(milliseconds: 480),
          curve: Curves.easeOutCubic,
          alignment: 0.04,
          alignmentPolicy:
          ScrollPositionAlignmentPolicy.explicit,
        );
      },
    );
  }

  void _clearMeasurementValues() {
    for (final TextEditingController controller
    in _measurementControllers.values) {
      controller.clear();
    }

    _designSelections.clear();
    _tailorNotesController.clear();
  }

  String? _requiredTextValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter $fieldName';
    }

    return null;
  }

  String? _phoneValidator(String? value) {
    final String phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return 'Enter phone number';
    }

    if (phone.length < 8) {
      return 'Enter a valid phone number';
    }

    return null;
  }

  bool _validateBeforeSave() {
    FocusScope.of(context).unfocus();

    final bool basicFormIsValid =
        _formKey.currentState?.validate() ?? false;

    if (_selectedCategory == null) {
      _showMessage('Select customer category.', isError: true);
      return false;
    }

    if (!basicFormIsValid) {
      return false;
    }

    // Customer-only mode:
    // Name, phone and category are enough to save the profile.
    // Customer photo is optional and may remain empty when permission is denied.
    if (!_addMeasurementsNow) {
      return true;
    }

    if (_selectedDress == null) {
      _showMessage('Select a dress type.', isError: true);
      return false;
    }

    if (_addMeasurementsNow) {
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
      }
    }

    if (_addOrderNow && _deliveryDate == null) {
      _showMessage(
        'Select order delivery date.',
        isError: true,
      );
      return false;
    }

    if (_addOrderNow) {
      final double total =
      _parseAmount(_totalAmountController.text);
      final double advance =
      _parseAmount(_advanceAmountController.text);

      if (total <= 0) {
        _showMessage(
          'Enter total order amount.',
          isError: true,
        );
        return false;
      }

      if (_paymentMethod == 'Advance' && advance > total) {
        _showMessage(
          'Advance cannot be greater than total amount.',
          isError: true,
        );
        return false;
      }
    }

    return true;
  }

  Future<void> _saveCustomer() async {
    if (!_validateBeforeSave()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final Map<String, String> measurements = <String, String>{
        if (_addMeasurementsNow)
          for (final String field in _currentMeasurementFields)
            if (_measurementController(field).text.trim().isNotEmpty)
              field: _measurementController(field).text.trim(),
      };

      final Map<String, dynamic> customerPayload =
      <String, dynamic>{
        'category': _selectedCategory,
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'photoPath': _profileImage?.path,
        'dressType': _addMeasurementsNow ? _selectedDress : null,
        'measurements':
        _addMeasurementsNow ? measurements : <String, String>{},
        'designDetails': _addMeasurementsNow
            ? Map<String, String>.from(_designSelections)
            : <String, String>{},
        'tailorNotes': _addMeasurementsNow
            ? _tailorNotesController.text.trim()
            : null,
        'createOrder': _addOrderNow,
        'orderDate': _addOrderNow && _orderDate != null
            ? _formatDate(_orderDate!)
            : null,
        'deliveryDate': _addOrderNow && _deliveryDate != null
            ? _formatDate(_deliveryDate!)
            : null,
        'paymentMethod': _addOrderNow ? _paymentMethod : null,
        'totalAmount': _addOrderNow
            ? _parseAmount(_totalAmountController.text)
            : null,
        'advanceAmount': _addOrderNow
            ? _parseAmount(_advanceAmountController.text)
            : null,
        'remainingAmount':
        _addOrderNow ? _remainingAmount : null,
      };

      // TODO: Send customerPayload to your backend API.
      debugPrint('Customer payload: $customerPayload');

      await Future<void>.delayed(
        const Duration(milliseconds: 500),
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        _addOrderNow
            ? 'Customer, measurements and order saved.'
            : _addMeasurementsNow
            ? 'Customer and measurements saved.'
            : 'Customer saved successfully.',
      );

      Navigator.of(context).pop(customerPayload);
    } catch (_) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Customer could not be saved.',
        isError: true,
      );
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
        bool isError = false,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor:
        isError ? AppColors.error : AppColors.primaryDark,
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
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
    final bool isWide = screenWidth >= 900;
    final double pagePadding = ResponsiveLayout.horizontalPadding(screenWidth);
    final double formMaxWidth = ResponsiveLayout.formMaxWidth(screenWidth);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: _scaffoldColor,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _isDarkMode
                      ? <Color>[
                    _scaffoldColor,
                    _surfaceSoftColor.withValues(alpha: 0.72),
                  ]
                      : <Color>[
                    _scaffoldColor,
                    AppColors.primaryLight.withValues(alpha: 0.055),
                    AppColors.secondaryLight.withValues(alpha: 0.055),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 76,
            right: -78,
            child: _GlowCircle(
              size: 195,
              color: AppColors.primaryLight,
              opacity: _isDarkMode ? 0.10 : 0.14,
            ),
          ),
          Positioned(
            top: 520,
            left: -88,
            child: _GlowCircle(
              size: 225,
              color: AppColors.gold,
              opacity: _isDarkMode ? 0.06 : 0.09,
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: <Widget>[
                _buildTopHeader(),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      padding: EdgeInsets.fromLTRB(
                        pagePadding,
                        12,
                        pagePadding,
                        28,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: formMaxWidth),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              _buildSectionCard(
                                title: '1. Customer Category',
                                subtitle:
                                'Select the type of customer you are adding.',
                                child: _buildCategorySelector(),
                              ),
                              const SizedBox(height: 12),
                              _buildSectionCard(
                                title: '2. Customer Information',
                                subtitle:
                                'Add name and phone number. Customer photo is optional.',
                                child: Column(
                                  children: <Widget>[
                                    _buildPhotoPicker(),
                                    const SizedBox(height: 14),
                                    _buildCustomerFields(),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildSectionCard(
                                title: '3. Measurements',
                                subtitle:
                                'Save only the customer or add measurements now.',
                                child: _buildMeasurementSection(isWide),
                              ),
                              const SizedBox(height: 18),
                              _buildSaveCustomerButton(),
                              SizedBox(
                                height: MediaQuery.paddingOf(context).bottom + 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 12, 5),
      child: Row(
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isSaving ? null : () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(15),
              child: Ink(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: _isDarkMode
                      ? AppColors.darkSurfaceSoft
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: _isDarkMode
                        ? AppColors.darkBorder
                        : AppColors.primary.withValues(alpha: 0.18),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: _isDarkMode ? 0.08 : 0.045,
                      ),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 24,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Add Customer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.25,
                    color: _primaryTextColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Add profile, measurements and order details',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: _secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 46, height: 46),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    final int separatorIndex = title.indexOf('.');
    final String number = separatorIndex > 0 ? title.substring(0, separatorIndex) : '';
    final String cleanTitle =
    separatorIndex > 0 ? title.substring(separatorIndex + 1).trim() : title;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _borderColor),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(
              alpha: _isDarkMode ? 0.13 : 0.045,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: AppColors.buttonGradient,
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.20),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  number,
                  style: const TextStyle(
                    color: AppColors.whiteText,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      cleanTitle,
                      style: TextStyle(
                        color: _primaryTextColor,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: _secondaryTextColor,
                        fontSize: 10.5,
                        height: 1.35,
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

  Widget _buildCategorySelector() {
    const List<_CategoryOption> categories = <_CategoryOption>[
      _CategoryOption(
        title: 'Gents',
        icon: Icons.man_rounded,
      ),
      _CategoryOption(
        title: 'Ladies',
        icon: Icons.woman_rounded,
      ),
      _CategoryOption(
        title: 'Kids',
        icon: Icons.child_care_rounded,
      ),
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 390;
        final double gap = compact ? 7 : 10;
        final double height = compact ? 86 : 94;

        return SizedBox(
          height: height,
          child: Row(
            children: <Widget>[
              for (int index = 0; index < categories.length; index++) ...<Widget>[
                Expanded(
                  child: _buildHorizontalCategoryTile(
                    categories[index],
                    compact: compact,
                  ),
                ),
                if (index != categories.length - 1) SizedBox(width: gap),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHorizontalCategoryTile(
      _CategoryOption item, {
        required bool compact,
      }) {
    final bool selected = _selectedCategory == item.title;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: () => _selectCategory(item.title),
        borderRadius: BorderRadius.circular(17),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 6 : 9,
            vertical: compact ? 9 : 11,
          ),
          decoration: BoxDecoration(
            gradient: selected ? AppColors.buttonGradient : null,
            color: selected ? null : _surfaceSoftColor,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: selected ? AppColors.primaryLight : _borderColor,
              width: selected ? 1.4 : 1,
            ),
            boxShadow: selected
                ? <BoxShadow>[
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ]
                : const <BoxShadow>[],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Container(
                    width: compact ? 33 : 37,
                    height: compact ? 33 : 37,
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.white.withValues(alpha: 0.16)
                          : AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(
                      item.icon,
                      color: selected
                          ? AppColors.whiteText
                          : AppColors.primary,
                      size: compact ? 19 : 21,
                    ),
                  ),
                  if (selected)
                    const Positioned(
                      right: -5,
                      top: -5,
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.whiteText,
                        size: 15,
                      ),
                    ),
                ],
              ),
              SizedBox(height: compact ? 6 : 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  item.title,
                  maxLines: 1,
                  style: TextStyle(
                    color: selected
                        ? AppColors.whiteText
                        : _primaryTextColor,
                    fontSize: compact ? 10.5 : 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTile(_CategoryOption item) {
    final bool selected = _selectedCategory == item.title;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectCategory(item.title),
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 15,
          ),
          decoration: BoxDecoration(
            gradient: selected ? AppColors.buttonGradient : null,
            color: selected ? null : _surfaceSoftColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? AppColors.primaryLight
                  : _borderColor,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                item.icon,
                color: selected
                    ? AppColors.whiteText
                    : AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 9),
              Text(
                item.title,
                style: TextStyle(
                  color: selected
                      ? AppColors.whiteText
                      : _primaryTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (selected) ...<Widget>[
                const SizedBox(width: 8),
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.whiteText,
                  size: 17,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: _showImageSourceSheet,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.52),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: _profileImage == null
                      ? const Icon(
                    Icons.person_rounded,
                    size: 38,
                    color: AppColors.primary,
                  )
                      : Image.file(_profileImage!, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                right: -2,
                bottom: -2,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    gradient: AppColors.buttonGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.whiteText,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Customer Photo',
                style: TextStyle(
                  color: _primaryTextColor,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _profileImage == null
                    ? 'Optional • Tap to choose camera or gallery'
                    : 'Photo selected • Tap to change it',
                style: TextStyle(
                  color: _secondaryTextColor,
                  fontSize: 11,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (_profileImage != null)
          IconButton(
            tooltip: 'Remove photo',
            onPressed: () => setState(() => _profileImage = null),
            icon: const Icon(Icons.delete_outline_rounded),
            color: AppColors.error,
          ),
      ],
    );
  }

  Widget _buildCustomerFields() {
    return Column(
      children: <Widget>[
        _buildTextField(
          controller: _nameController,
          label: 'Customer Name',
          hint: 'Enter full name',
          icon: Icons.person_outline_rounded,
          textInputAction: TextInputAction.next,
          validator: (String? value) =>
              _requiredTextValidator(value, 'customer name'),
        ),
        const SizedBox(height: 13),
        _buildTextField(
          controller: _phoneController,
          label: 'Phone Number',
          hint: 'Enter phone number',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          validator: _phoneValidator,
        ),
      ],
    );
  }

  Widget _buildMeasurementSection(bool isWide) {
    void setMeasurementsEnabled(bool value) {
      setState(() {
        _addMeasurementsNow = value;

        if (!value) {
          _selectedDress = null;
          _addOrderNow = false;
          _orderDate = null;
          _deliveryDate = null;
          _clearMeasurementValues();
        }
      });
    }

    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            color: _surfaceSoftColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _addMeasurementsNow
                  ? AppColors.primary.withValues(alpha: 0.42)
                  : _borderColor,
              width: _addMeasurementsNow ? 1.2 : 1,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: _isDarkMode ? 0.07 : 0.025,
                ),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _addMeasurementsNow
                      ? AppColors.primary.withValues(alpha: 0.14)
                      : AppColors.primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.straighten_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            'Add Measurements',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: _primaryTextColor,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.09),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'OPTIONAL',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 6.8,
                              letterSpacing: 0.35,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _addMeasurementsNow
                          ? 'Select a dress and enter measurements.'
                          : 'Save customer details only.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _secondaryTextColor,
                        fontSize: 8.5,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Semantics(
                button: true,
                toggled: _addMeasurementsNow,
                label: 'Add measurements',
                child: InkWell(
                  onTap: () =>
                      setMeasurementsEnabled(!_addMeasurementsNow),
                  borderRadius: BorderRadius.circular(999),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 4,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 160),
                          child: Text(
                            _addMeasurementsNow ? 'ON' : 'OFF',
                            key: ValueKey<bool>(_addMeasurementsNow),
                            style: TextStyle(
                              color: _addMeasurementsNow
                                  ? AppColors.primary
                                  : _secondaryTextColor,
                              fontSize: 7.2,
                              letterSpacing: 0.4,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutCubic,
                          width: 46,
                          height: 26,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: _addMeasurementsNow
                                ? AppColors.primary
                                : (_isDarkMode
                                ? AppColors.darkBorder
                                : AppColors.grey200),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: _addMeasurementsNow
                                  ? AppColors.primaryLight
                                  .withValues(alpha: 0.65)
                                  : _borderColor,
                            ),
                          ),
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOutCubic,
                            alignment: _addMeasurementsNow
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.13),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 150),
                                child: _addMeasurementsNow
                                    ? const Icon(
                                  Icons.check_rounded,
                                  key: ValueKey<String>('measure-on'),
                                  color: AppColors.primary,
                                  size: 13,
                                )
                                    : const SizedBox(
                                  key: ValueKey<String>('measure-off'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          child: !_addMeasurementsNow
              ? const SizedBox.shrink()
              : Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildDressDropdown(),
                if (_selectedDress != null) ...<Widget>[
                  const SizedBox(height: 18),
                  KeyedSubtree(
                    key: _measurementFormKey,
                    child: _buildMeasurementForm(isWide),
                  ),
                  if (_currentDesignOptions.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 18),
                    _buildDesignDetailsSection(),
                  ],
                  const SizedBox(height: 18),
                  _buildTailorNotesSection(),
                  const SizedBox(height: 18),
                  _buildOrderSection(),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKidsGroupSelector() {
    const List<_CategoryOption> groups = <_CategoryOption>[
      _CategoryOption(
        title: 'Boys',
        icon: Icons.boy_rounded,
      ),
      _CategoryOption(
        title: 'Girls',
        icon: Icons.girl_rounded,
      ),
    ];

    final _CategoryOption? selectedItem = _selectedKidsGroup == null
        ? null
        : groups.firstWhere(
          (_CategoryOption item) =>
      item.title == _selectedKidsGroup,
    );

    return Column(
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _showKidsGroupOptions =
                !_showKidsGroupOptions;
              });
            },
            borderRadius: BorderRadius.circular(18),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                gradient: selectedItem != null
                    ? AppColors.buttonGradient
                    : null,
                color: selectedItem == null
                    ? _surfaceSoftColor
                    : null,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selectedItem != null
                      ? AppColors.primaryLight
                      : _borderColor,
                ),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: selectedItem != null
                          ? Colors.white.withValues(alpha: 0.16)
                          : AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      selectedItem?.icon ??
                          Icons.family_restroom_rounded,
                      color: selectedItem != null
                          ? AppColors.whiteText
                          : AppColors.primary,
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
                          selectedItem?.title ??
                              'Select Kids Group',
                          style: TextStyle(
                            color: selectedItem != null
                                ? AppColors.whiteText
                                : _primaryTextColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          selectedItem != null
                              ? 'Tap to change group'
                              : 'Choose Boys, Girls or New Born',
                          style: TextStyle(
                            color: selectedItem != null
                                ? Colors.white70
                                : _secondaryTextColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns:
                    _showKidsGroupOptions ? 0.5 : 0,
                    duration:
                    const Duration(milliseconds: 220),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: selectedItem != null
                          ? AppColors.whiteText
                          : AppColors.primary,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          child: !_showKidsGroupOptions
              ? const SizedBox.shrink()
              : Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: groups
                  .map(
                    (_CategoryOption item) => Padding(
                  padding:
                  const EdgeInsets.only(bottom: 9),
                  child: _buildKidsGroupTile(item),
                ),
              )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKidsGroupTile(_CategoryOption item) {
    final bool selected =
        _selectedKidsGroup == item.title;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectKidsGroup(item.title),
        borderRadius: BorderRadius.circular(17),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            gradient: selected ? AppColors.buttonGradient : null,
            color: selected ? null : _surfaceSoftColor,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: selected
                  ? AppColors.primaryLight
                  : _borderColor,
            ),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                item.icon,
                color: selected
                    ? AppColors.whiteText
                    : AppColors.primary,
                size: 21,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    color: selected
                        ? AppColors.whiteText
                        : _primaryTextColor,
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

  Widget _buildDressDropdown() {
    final bool categorySelected = _selectedCategory != null;
    final bool dressSelectionEnabled = categorySelected;

    return Column(
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: !dressSelectionEnabled
                ? null
                : () {
              setState(() {
                _showDressOptions = !_showDressOptions;
              });
            },
            borderRadius: BorderRadius.circular(14),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                gradient: _selectedDress != null
                    ? AppColors.buttonGradient
                    : null,
                color: _selectedDress == null
                    ? _surfaceSoftColor
                    : null,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _selectedDress != null
                      ? AppColors.primaryLight
                      : _borderColor,
                  width: _selectedDress != null ? 1.2 : 1,
                ),
                boxShadow: _selectedDress != null
                    ? <BoxShadow>[
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
                    : const <BoxShadow>[],
              ),
              child: Row(
                children: <Widget>[
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _selectedDress != null
                          ? Colors.white.withValues(alpha: 0.16)
                          : AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      Icons.checkroom_rounded,
                      color: _selectedDress != null
                          ? AppColors.whiteText
                          : dressSelectionEnabled
                          ? AppColors.primary
                          : _secondaryTextColor,
                      size: 17,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _selectedDress ??
                              (!categorySelected
                                  ? 'Select Customer Category'
                                  : 'Select Dress Type'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: _selectedDress != null
                                ? AppColors.whiteText
                                : _primaryTextColor,
                            fontSize: 11.2,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          _selectedDress != null
                              ? 'Tap to change'
                              : !categorySelected
                              ? 'Choose Gents, Ladies or Kids above'
                              : 'Choose a dress for $_selectedCategory',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: _selectedDress != null
                                ? Colors.white70
                                : _secondaryTextColor,
                            fontSize: 7.8,
                            height: 1.25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  AnimatedRotation(
                    turns: _showDressOptions ? 0.5 : 0,
                    duration: const Duration(milliseconds: 190),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: _selectedDress != null
                          ? AppColors.whiteText
                          : dressSelectionEnabled
                          ? AppColors.primary
                          : _secondaryTextColor,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 230),
          curve: Curves.easeOutCubic,
          child: !_showDressOptions || !dressSelectionEnabled
              ? const SizedBox.shrink()
              : Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Column(
              children: _availableDresses
                  .map(
                    (String dress) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: _buildDressOptionTile(dress),
                ),
              )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDressOptionTile(String dress) {
    final bool selected = _selectedDress == dress;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectDress(dress),
        borderRadius: BorderRadius.circular(13),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            gradient: selected ? AppColors.buttonGradient : null,
            color: selected ? null : _surfaceSoftColor,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: selected
                  ? AppColors.primaryLight
                  : _borderColor,
              width: selected ? 1.2 : 1,
            ),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.15)
                      : AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  dress == 'Shalwar Kameez'
                      ? Icons.accessibility_new_rounded
                      : Icons.dry_cleaning_rounded,
                  color: selected
                      ? AppColors.whiteText
                      : AppColors.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  dress,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected
                        ? AppColors.whiteText
                        : _primaryTextColor,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.whiteText,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeasurementForm(bool isWide) {
    final List<String> fields = _currentMeasurementFields;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _borderColor),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(
              alpha: _isDarkMode ? 0.16 : 0.045,
            ),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.straighten_rounded,
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
                      '$_selectedDress Measurements',
                      style: TextStyle(
                        color: _primaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Enter all measurements in inches.',
                      style: TextStyle(
                        color: _secondaryTextColor,
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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: fields.length,
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isWide ? 3 : 2,
              crossAxisSpacing: 11,
              mainAxisSpacing: 11,
              childAspectRatio: isWide ? 2.9 : 2.15,
            ),
            itemBuilder: (
                BuildContext context,
                int index,
                ) {
              final String field = fields[index];

              return TextFormField(
                controller: _measurementController(field),
                keyboardType:
                const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: TextStyle(
                  color: _primaryTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
                decoration: _inputDecoration(
                  label: field,
                  hint: '0.0',
                  icon: Icons.straighten_rounded,
                  suffixText: 'in',
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDesignDetailsSection() {
    final Map<String, List<String>> options = _currentDesignOptions;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: _borderColor),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(
              alpha: _isDarkMode ? 0.12 : 0.035,
            ),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: AppColors.whiteText,
                  size: 18,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Design Details',
                      style: TextStyle(
                        color: _primaryTextColor,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tailor selects the design manually while taking measurements.',
                      style: TextStyle(
                        color: _secondaryTextColor,
                        fontSize: 8.5,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...options.entries.map(
                (MapEntry<String, List<String>> entry) =>
                _buildDesignOptionGroup(
                  title: entry.key,
                  options: entry.value,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesignOptionGroup({
    required String title,
    required List<String> options,
  }) {
    final String? selectedValue = _designSelections[title];

    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: _primaryTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (selectedValue == null)
                Text(
                  'Not selected',
                  style: TextStyle(
                    color: _secondaryTextColor,
                    fontSize: 7.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 7),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: options.map((String option) {
              final bool selected = selectedValue == option;

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (_designSelections[title] == option) {
                        _designSelections.remove(title);
                      } else {
                        _designSelections[title] = option;
                      }
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 170),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient:
                      selected ? AppColors.primaryGradient : null,
                      color: selected ? null : _surfaceSoftColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? Colors.transparent
                            : _borderColor,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          selected
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          color: selected
                              ? AppColors.whiteText
                              : _secondaryTextColor,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          option,
                          style: TextStyle(
                            color: selected
                                ? AppColors.whiteText
                                : _primaryTextColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
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

  Widget _buildTailorNotesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _borderColor),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(
              alpha: _isDarkMode ? 0.16 : 0.045,
            ),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.edit_note_rounded,
                  color: AppColors.secondaryDark,
                  size: 23,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Tailor Notes',
                      style: TextStyle(
                        color: _primaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Optional notes for fitting, stitching or delivery.',
                      style: TextStyle(
                        color: _secondaryTextColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _tailorNotesController,
            minLines: 4,
            maxLines: 7,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(
              color: _primaryTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            decoration: _inputDecoration(
              label: 'Notes',
              hint:
              'Example: Loose fitting, extra stitching, urgent delivery...',
              icon: Icons.notes_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSection() {
    return Column(
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _toggleOrderSection,
            borderRadius: BorderRadius.circular(17),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(13, 11, 11, 11),
              decoration: BoxDecoration(
                color: _addOrderNow
                    ? AppColors.secondary.withValues(
                  alpha: _isDarkMode ? 0.15 : 0.10,
                )
                    : _surfaceSoftColor,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: _addOrderNow
                      ? AppColors.secondary.withValues(alpha: 0.55)
                      : _borderColor,
                  width: _addOrderNow ? 1.4 : 1,
                ),
                boxShadow: _addOrderNow
                    ? <BoxShadow>[
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.10),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ]
                    : const <BoxShadow>[],
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: AppColors.secondary.withValues(alpha: 0.18),
                          blurRadius: 9,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.shopping_bag_rounded,
                      color: AppColors.grey900,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                _addOrderNow
                                    ? 'Order Setup'
                                    : 'Create Order',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _primaryTextColor,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 7),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withValues(
                                  alpha: _isDarkMode ? 0.18 : 0.12,
                                ),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                'DIRECT',
                                style: TextStyle(
                                  color: AppColors.secondaryDark,
                                  fontSize: 7,
                                  letterSpacing: 0.35,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _addOrderNow
                              ? 'Complete delivery and payment details below.'
                              : 'Use this customer and current dress measurements.',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: _secondaryTextColor,
                            fontSize: 8.8,
                            height: 1.3,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 9),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: _addOrderNow
                          ? AppColors.error.withValues(alpha: 0.10)
                          : AppColors.secondary.withValues(alpha: 0.13),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _addOrderNow
                            ? AppColors.error.withValues(alpha: 0.32)
                            : AppColors.secondary.withValues(alpha: 0.35),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      transitionBuilder: (
                          Widget child,
                          Animation<double> animation,
                          ) {
                        return ScaleTransition(
                          scale: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Icon(
                        _addOrderNow
                            ? Icons.close_rounded
                            : Icons.add_rounded,
                        key: ValueKey<bool>(_addOrderNow),
                        color: _addOrderNow
                            ? AppColors.error
                            : AppColors.secondaryDark,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          child: !_addOrderNow
              ? const SizedBox.shrink()
              : Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _surfaceSoftColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _borderColor),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Order Details',
                          style: TextStyle(
                            color: _primaryTextColor,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _toggleOrderSection,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(
                                alpha: 0.09,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.error.withValues(
                                  alpha: 0.22,
                                ),
                              ),
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: AppColors.error,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildOrderDateTile(
                    icon: Icons.today_rounded,
                    title: 'Order Date',
                    value: _orderDate == null
                        ? 'Today'
                        : _formatDate(_orderDate!),
                    isAutomatic: true,
                  ),
                  const SizedBox(height: 10),
                  _buildOrderDateTile(
                    icon: Icons.event_available_rounded,
                    title: 'Delivery Date',
                    value: _deliveryDate == null
                        ? 'Select delivery date'
                        : _formatDate(_deliveryDate!),
                    onTap: _selectDeliveryDate,
                  ),
                  const SizedBox(height: 14),
                  _buildPaymentSection(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSection() {
    const List<String> methods = <String>[
      'Advance',
      'Full Payment',
      'Pay After Delivery',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(
                Icons.payments_rounded,
                color: AppColors.secondaryDark,
                size: 21,
              ),
              const SizedBox(width: 8),
              Text(
                'Payment Details',
                style: TextStyle(
                  color: _primaryTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: methods
                .map(
                  (String method) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildPaymentMethodTile(method),
              ),
            )
                .toList(),
          ),
          const SizedBox(height: 5),
          _buildAmountField(
            controller: _totalAmountController,
            label: 'Total Amount',
            hint: 'Enter total amount',
            icon: Icons.receipt_long_rounded,
            onChanged: (_) {
              if (_paymentMethod == 'Full Payment') {
                _advanceAmountController.text =
                    _totalAmountController.text;
              }
              _calculateRemainingAmount();
            },
          ),
          if (_paymentMethod == 'Advance') ...<Widget>[
            const SizedBox(height: 11),
            _buildAmountField(
              controller: _advanceAmountController,
              label: 'Advance Paid',
              hint: 'Enter advance amount',
              icon: Icons.account_balance_wallet_rounded,
              onChanged: (_) => _calculateRemainingAmount(),
            ),
          ],
          const SizedBox(height: 11),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.28),
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
                    _paymentMethod == 'Full Payment'
                        ? 'Remaining Balance'
                        : _paymentMethod == 'Pay After Delivery'
                        ? 'Amount Due After Delivery'
                        : 'Remaining Balance',
                    style: TextStyle(
                      color: _primaryTextColor,
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

  Widget _buildPaymentMethodTile(String method) {
    final bool selected = _paymentMethod == method;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectPaymentMethod(method),
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
                ? AppColors.primary.withValues(alpha: 0.11)
                : _surfaceSoftColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : _borderColor,
            ),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: selected
                    ? AppColors.primary
                    : _secondaryTextColor,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  method,
                  style: TextStyle(
                    color: _primaryTextColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      onChanged: onChanged,
      style: TextStyle(
        color: _primaryTextColor,
        fontSize: 12,
        fontWeight: FontWeight.w800,
      ),
      decoration: _inputDecoration(
        label: label,
        hint: hint,
        icon: icon,
        suffixText: 'Rs',
      ),
    );
  }

  Widget _buildOrderDateTile({
    required IconData icon,
    required String title,
    required String value,
    bool isAutomatic = false,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: _surfaceColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: _borderColor),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 39,
                height: 39,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        color: _secondaryTextColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      style: TextStyle(
                        color: _primaryTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              if (isAutomatic)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                    AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'AUTO',
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                )
              else
                const Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      style: TextStyle(
        color: _primaryTextColor,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
      decoration: _inputDecoration(
        label: label,
        hint: hint,
        icon: icon,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    String? suffixText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffixText: suffixText,
      labelStyle: TextStyle(
        color: _secondaryTextColor,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
      hintStyle: TextStyle(
        color: _secondaryTextColor.withValues(alpha: 0.65),
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(
        icon,
        color: AppColors.primary,
        size: 20,
      ),
      filled: true,
      fillColor: _surfaceSoftColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: _borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: _borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.primaryLight,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.error,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildSaveCustomerButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.buttonGradient,
          borderRadius: BorderRadius.circular(17),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.28),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: _isSaving ? null : _saveCustomer,
          icon: _isSaving
              ? const SizedBox(
            width: 19,
            height: 19,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.whiteText,
              ),
            ),
          )
              : Icon(
            _addOrderNow
                ? Icons.inventory_2_rounded
                : _addMeasurementsNow
                ? Icons.save_as_rounded
                : Icons.person_add_alt_1_rounded,
            color: AppColors.whiteText,
          ),
          label: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _isSaving
                  ? 'Saving...'
                  : _addOrderNow
                  ? 'Save Customer, Measurements & Order'
                  : _addMeasurementsNow
                  ? 'Save Customer & Measurements'
                  : 'Save Customer',
              style: const TextStyle(
                color: AppColors.whiteText,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
          ),
        ),
      ),
    );
  }

}

class _ImageSourceButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ImageSourceButton({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 18,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.18),
            ),
          ),
          child: Column(
            children: <Widget>[
              Icon(
                icon,
                color: AppColors.primary,
                size: 27,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _GlowCircle({
    required this.size,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Keep the decorative glow lightweight. A very large blurred
          // BoxShadow here was expensive while the route was animating.
          color: color.withValues(alpha: opacity * 0.72),
        ),
      ),
    );
  }
}

class _CategoryOption {
  final String title;
  final IconData icon;

  const _CategoryOption({
    required this.title,
    required this.icon,
  });
}

