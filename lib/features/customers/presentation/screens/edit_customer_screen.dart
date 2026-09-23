import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailorx/core/constants/app_colors.dart';

class EditCustomerScreen extends StatefulWidget {
  const EditCustomerScreen({
    super.key,
    required this.customerId,
    required this.customerCode,
    required this.name,
    required this.phone,
    required this.category,
    this.photoUrl,
    this.address = '',
    this.notes = '',
  });

  final String customerId;
  final String customerCode;
  final String name;
  final String phone;
  final String category;
  final String? photoUrl;
  final String address;
  final String notes;

  @override
  State<EditCustomerScreen> createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;

  late String _category;
  File? _selectedPhoto;
  bool _removeExistingPhoto = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _phoneController = TextEditingController(text: widget.phone);
    _addressController = TextEditingController(text: widget.address);
    _notesController = TextEditingController(text: widget.notes);
    _category = widget.category.trim().isEmpty ? 'Gents' : widget.category;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 82,
        maxWidth: 1400,
        maxHeight: 1400,
      );

      if (image == null || !mounted) return;

      setState(() {
        _selectedPhoto = File(image.path);
        _removeExistingPhoto = false;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open camera or gallery.')),
      );
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext sheetContext) {
        final bool hasPhoto = _selectedPhoto != null ||
            (!_removeExistingPhoto && (widget.photoUrl?.trim().isNotEmpty ?? false));

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 6, 18, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Customer Photo',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                          _pickPhoto(ImageSource.camera);
                        },
                        icon: const Icon(Icons.camera_alt_rounded),
                        label: const Text('Camera'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                          _pickPhoto(ImageSource.gallery);
                        },
                        icon: const Icon(Icons.photo_library_rounded),
                        label: const Text('Gallery'),
                      ),
                    ),
                  ],
                ),
                if (hasPhoto) ...<Widget>[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.of(sheetContext).pop();
                        setState(() {
                          _selectedPhoto = null;
                          _removeExistingPhoto = true;
                        });
                      },
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: const Text('Remove Photo'),
                      style: TextButton.styleFrom(foregroundColor: AppColors.error),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter $label';
    }
    return null;
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;

    final String? photoPath = _selectedPhoto?.path ??
        (_removeExistingPhoto ? '' : widget.photoUrl);

    Navigator.of(context).pop<EditedCustomerData>(
      EditedCustomerData(
        customerId: widget.customerId,
        customerCode: widget.customerCode,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        category: _category,
        photoUrl: photoPath,
        address: _addressController.text.trim(),
        notes: _notesController.text.trim(),
      ),
    );
  }

  Widget _photoPreview() {
    Widget fallback() {
      final String initial = _nameController.text.trim().isEmpty
          ? 'C'
          : _nameController.text.trim()[0].toUpperCase();
      return Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: AppColors.whiteText,
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
    }

    if (_selectedPhoto != null) {
      return Image.file(
        _selectedPhoto!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback(),
      );
    }

    if (_removeExistingPhoto) return fallback();

    final String path = widget.photoUrl?.trim() ?? '';
    if (path.isEmpty) return fallback();

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback(),
      );
    }

    final File file = File(path);
    if (!file.existsSync()) return fallback();
    return Image.file(
      file,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => fallback(),
    );
  }

  InputDecoration _decoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color fill = isDark ? AppColors.darkSurfaceSoft : AppColors.surfaceSoft;
    final Color border = isDark ? AppColors.darkBorder : AppColors.border;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primary),
      filled: true,
      fillColor: fill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color background = isDark ? AppColors.darkScaffold : AppColors.scaffold;
    final Color surface = isDark ? AppColors.darkSurface : AppColors.surface;
    final Color border = isDark ? AppColors.darkBorder : AppColors.border;
    final Color primaryText = isDark ? AppColors.darkText : AppColors.textPrimary;
    final Color secondaryText = isDark ? AppColors.grey400 : AppColors.textSecondary;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double pagePadding = screenWidth <= 360 ? 12 : screenWidth < 600 ? 16 : 24;
    final double maxWidth = screenWidth >= 1100 ? 760 : screenWidth >= 700 ? 680 : 620;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: primaryText,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
          child: _ScreenBackButton(onTap: () => Navigator.of(context).pop()),
        ),
        title: Text(
          'Edit Customer',
          style: TextStyle(
            color: primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Form(
              key: _formKey,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(pagePadding, 10, pagePadding, 30),
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: border),
                    ),
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: _showPhotoOptions,
                          borderRadius: BorderRadius.circular(24),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(alpha: 0.25),
                                    width: 2,
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: _photoPreview(),
                              ),
                              Positioned(
                                right: -5,
                                bottom: -5,
                                child: Container(
                                  width: 34,
                                  height: 34,
                                  decoration: const BoxDecoration(
                                    gradient: AppColors.buttonGradient,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: AppColors.whiteText,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 13),
                        Text(
                          'Customer Profile Image',
                          style: TextStyle(
                            color: primaryText,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap the photo to choose Camera or Gallery',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Customer Information',
                          style: TextStyle(
                            color: primaryText,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          onChanged: (_) => setState(() {}),
                          validator: (String? value) => _required(value, 'customer name'),
                          decoration: _decoration(
                            label: 'Customer Name',
                            icon: Icons.person_outline_rounded,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          validator: (String? value) => _required(value, 'phone number'),
                          decoration: _decoration(
                            label: 'Phone Number',
                            icon: Icons.phone_rounded,
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: <String>['Gents', 'Ladies', 'Kids'].contains(_category)
                              ? _category
                              : 'Gents',
                          decoration: _decoration(
                            label: 'Category',
                            icon: Icons.category_rounded,
                          ),
                          items: const <String>['Gents', 'Ladies', 'Kids']
                              .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                              .toList(),
                          onChanged: (String? value) {
                            if (value != null) setState(() => _category = value);
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _addressController,
                          minLines: 2,
                          maxLines: 3,
                          decoration: _decoration(
                            label: 'Address',
                            icon: Icons.location_on_outlined,
                            hint: 'Optional customer address',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _notesController,
                          minLines: 3,
                          maxLines: 5,
                          decoration: _decoration(
                            label: 'Notes',
                            icon: Icons.notes_rounded,
                            hint: 'Optional customer notes',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
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
                        onPressed: _saving ? null : _save,
                        icon: _saving
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: AppColors.whiteText,
                          ),
                        )
                            : const Icon(Icons.save_rounded),
                        label: Text(_saving ? 'SAVING...' : 'SAVE CHANGES'),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EditedCustomerData {
  const EditedCustomerData({
    required this.customerId,
    required this.customerCode,
    required this.name,
    required this.phone,
    required this.category,
    required this.photoUrl,
    required this.address,
    required this.notes,
  });

  final String customerId;
  final String customerCode;
  final String name;
  final String phone;
  final String category;
  final String? photoUrl;
  final String address;
  final String notes;
}

class _ScreenBackButton extends StatelessWidget {
  const _ScreenBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color surface = isDark ? AppColors.darkSurfaceSoft : Colors.white;
    final Color border = isDark
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
            border: Border.all(color: border),
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
