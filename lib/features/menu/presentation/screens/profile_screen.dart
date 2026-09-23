import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailorx/core/constants/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    this.initialName = 'Azeem Khan',
    this.initialBusinessName = 'TailorX Workspace',
    this.initialPhone = '0300 1234567',
    this.initialEmail = 'azeem@tailorx.com',
    this.initialAddress = 'Your shop address',
  });

  final String initialName;
  final String initialBusinessName;
  final String initialPhone;
  final String initialEmail;
  final String initialAddress;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  File? _profileImage;

  late final TextEditingController _nameController;
  late final TextEditingController _businessController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;

  bool _editing = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _businessController = TextEditingController(text: widget.initialBusinessName);
    _phoneController = TextEditingController(text: widget.initialPhone);
    _emailController = TextEditingController(text: widget.initialEmail);
    _addressController = TextEditingController(text: widget.initialAddress);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _businessController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _background =>
      _isDark ? AppColors.darkScaffold : AppColors.scaffold;
  Color get _surface => _isDark ? AppColors.darkSurface : AppColors.surface;
  Color get _softSurface =>
      _isDark ? AppColors.darkSurfaceSoft : AppColors.surfaceSoft;
  Color get _border => _isDark ? AppColors.darkBorder : AppColors.border;
  Color get _primaryText =>
      _isDark ? AppColors.darkText : AppColors.textPrimary;
  Color get _secondaryText =>
      _isDark ? AppColors.grey400 : AppColors.textSecondary;

  String get _initials {
    final List<String> parts = _nameController.text
        .trim()
        .split(RegExp(r'\s+'))
        .where((String value) => value.isNotEmpty)
        .toList();

    if (parts.isEmpty) return 'TX';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  Future<void> _pickProfileImage(ImageSource source) async {
    try {
      final XFile? picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 82,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (picked == null || !mounted) return;

      setState(() {
        _profileImage = File(picked.path);
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: const Text(
            'Unable to open camera or gallery.',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Profile Photo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Choose a photo from camera or gallery.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _secondaryText,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _ProfileImageSourceButton(
                            icon: Icons.camera_alt_rounded,
                            label: 'Camera',
                            onTap: () {
                              Navigator.of(sheetContext).pop();
                              _pickProfileImage(ImageSource.camera);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ProfileImageSourceButton(
                            icon: Icons.photo_library_rounded,
                            label: 'Gallery',
                            onTap: () {
                              Navigator.of(sheetContext).pop();
                              _pickProfileImage(ImageSource.gallery);
                            },
                          ),
                        ),
                      ],
                    ),
                    if (_profileImage != null) ...<Widget>[
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                          setState(() => _profileImage = null);
                        },
                        icon: const Icon(Icons.delete_outline_rounded),
                        label: const Text('Remove Photo'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _cancelEditing() {
    FocusScope.of(context).unfocus();
    setState(() {
      _editing = false;
    });
  }

  Future<void> _saveProfile() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 350));

    if (!mounted) return;

    setState(() {
      _saving = false;
      _editing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: const Text(
          'Profile updated successfully.',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  String? _required(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter $label';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final String email = value?.trim() ?? '';
    if (email.isEmpty) return 'Enter email address';
    if (!email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final bool isSmallMobile = width <= 360;
    final bool isTablet = width >= 600;
    final bool isDesktop = width >= 1000;

    final double horizontalPadding = isSmallMobile
        ? 12
        : width < 600
        ? 16
        : width < 1000
        ? 24
        : 32;

    final double contentMaxWidth = isDesktop ? 860 : isTablet ? 700 : 500;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: _background,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  _background,
                  _isDark
                      ? const Color(0xFF0A211B)
                      : const Color(0xFFF8FCFA),
                  _background,
                ],
              ),
            ),
          ),
          Positioned(
            top: -90,
            right: -65,
            child: _ProfileGlow(
              size: isDesktop ? 310 : 250,
              color: AppColors.primaryLight,
              opacity: _isDark ? 0.10 : 0.07,
            ),
          ),
          SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  isTablet ? 20 : 14,
                  horizontalPadding,
                  32,
                ),
                children: <Widget>[
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: contentMaxWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          _buildTopBar(),
                          const SizedBox(height: 18),
                          _buildHeroCard(isTablet: isTablet),
                          const SizedBox(height: 16),
                          _buildPersonalCard(isDesktop: isDesktop),
                          const SizedBox(height: 14),
                          _buildBusinessCard(),
                          if (_editing) ...<Widget>[
                            const SizedBox(height: 18),
                            _buildSaveActions(isSmallMobile: isSmallMobile),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: <Widget>[
        _PressScale(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: _border,
                width: 1.2,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: _isDark ? 0.18 : 0.06,
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.primary,
              size: 29,
            ),
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'My Profile',
                style: TextStyle(
                  color: _primaryText,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.35,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Manage your personal and business information',
                maxLines: 2,
                style: TextStyle(
                  color: _secondaryText,
                  fontSize: 10,
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (!_editing)
          _PressScale(
            onTap: () => setState(() => _editing = true),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.20),
                ),
              ),
              child: const Icon(
                Icons.edit_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeroCard({required bool isTablet}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 22 : 18),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(26),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -58,
            right: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: _showImageSourceSheet,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Container(
                      width: isTablet ? 84 : 72,
                      height: isTablet ? 84 : 72,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(isTablet ? 24 : 21),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.24),
                          width: 1.4,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(isTablet ? 23 : 20),
                        child: _profileImage == null
                            ? Center(
                          child: Text(
                            _initials,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 27 : 23,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        )
                            : Image.file(
                          _profileImage!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          cacheWidth: 400,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -5,
                      bottom: -5,
                      child: Container(
                        width: isTablet ? 31 : 28,
                        height: isTablet ? 31 : 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.20),
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.14),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: AppColors.primary,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'TAILOR PROFILE',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 8,
                        letterSpacing: 0.9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _nameController.text.trim().isEmpty
                          ? 'Your Name'
                          : _nameController.text.trim(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _businessController.text.trim().isEmpty
                          ? 'Your Business'
                          : _businessController.text.trim(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalCard({required bool isDesktop}) {
    final Widget nameField = _ProfileField(
      controller: _nameController,
      label: 'Owner Name',
      icon: Icons.person_outline_rounded,
      enabled: _editing,
      surface: _softSurface,
      border: _border,
      primaryText: _primaryText,
      secondaryText: _secondaryText,
      validator: (String? value) => _required(value, 'owner name'),
      onChanged: (_) => setState(() {}),
    );

    final Widget phoneField = _ProfileField(
      controller: _phoneController,
      label: 'Phone Number',
      icon: Icons.phone_outlined,
      enabled: _editing,
      keyboardType: TextInputType.phone,
      surface: _softSurface,
      border: _border,
      primaryText: _primaryText,
      secondaryText: _secondaryText,
      validator: (String? value) => _required(value, 'phone number'),
    );

    final Widget emailField = _ProfileField(
      controller: _emailController,
      label: 'Email Address',
      icon: Icons.mail_outline_rounded,
      enabled: _editing,
      keyboardType: TextInputType.emailAddress,
      surface: _softSurface,
      border: _border,
      primaryText: _primaryText,
      secondaryText: _secondaryText,
      validator: _validateEmail,
    );

    return _ProfileSection(
      title: 'Personal Information',
      subtitle: 'Your account contact details',
      icon: Icons.badge_outlined,
      surface: _surface,
      border: _border,
      primaryText: _primaryText,
      secondaryText: _secondaryText,
      child: isDesktop
          ? Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(child: nameField),
              const SizedBox(width: 14),
              Expanded(child: phoneField),
            ],
          ),
          const SizedBox(height: 13),
          emailField,
        ],
      )
          : Column(
        children: <Widget>[
          nameField,
          const SizedBox(height: 13),
          phoneField,
          const SizedBox(height: 13),
          emailField,
        ],
      ),
    );
  }

  Widget _buildBusinessCard() {
    return _ProfileSection(
      title: 'Business Information',
      subtitle: 'Details shown for your tailoring workspace',
      icon: Icons.storefront_outlined,
      surface: _surface,
      border: _border,
      primaryText: _primaryText,
      secondaryText: _secondaryText,
      child: Column(
        children: <Widget>[
          _ProfileField(
            controller: _businessController,
            label: 'Business Name',
            icon: Icons.business_rounded,
            enabled: _editing,
            surface: _softSurface,
            border: _border,
            primaryText: _primaryText,
            secondaryText: _secondaryText,
            validator: (String? value) => _required(value, 'business name'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 13),
          _ProfileField(
            controller: _addressController,
            label: 'Shop Address',
            icon: Icons.location_on_outlined,
            enabled: _editing,
            maxLines: 2,
            surface: _softSurface,
            border: _border,
            primaryText: _primaryText,
            secondaryText: _secondaryText,
            validator: (String? value) => _required(value, 'shop address'),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveActions({required bool isSmallMobile}) {
    final Widget cancelButton = SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: _saving ? null : _cancelEditing,
        icon: const Icon(Icons.close_rounded),
        label: const Text('Cancel'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.28),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );

    final Widget saveButton = Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[
            AppColors.primaryDark,
            AppColors.primaryLight,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ElevatedButton.icon(
        onPressed: _saving ? null : _saveProfile,
        icon: _saving
            ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
            color: Colors.white,
          ),
        )
            : const Icon(Icons.save_rounded),
        label: Text(_saving ? 'Saving...' : 'Save Changes'),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
    );

    if (isSmallMobile) {
      return Column(
        children: <Widget>[
          SizedBox(width: double.infinity, child: saveButton),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity, child: cancelButton),
        ],
      );
    }

    return Row(
      children: <Widget>[
        Expanded(child: cancelButton),
        const SizedBox(width: 12),
        Expanded(child: saveButton),
      ],
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.surface,
    required this.border,
    required this.primaryText,
    required this.secondaryText,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color surface;
  final Color border;
  final Color primaryText;
  final Color secondaryText;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: AppColors.primary, size: 21),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 9,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          child,
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.enabled,
    required this.surface,
    required this.border,
    required this.primaryText,
    required this.secondaryText,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool enabled;
  final Color surface;
  final Color border;
  final Color primaryText;
  final Color secondaryText;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
      style: TextStyle(
        color: primaryText,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: secondaryText,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 21),
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.4,
          ),
        ),
      ),
    );
  }
}

class _ProfileImageSourceButton extends StatelessWidget {
  const _ProfileImageSourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color surface =
    isDark ? AppColors.darkSurfaceSoft : AppColors.surfaceSoft;
    final Color border = isDark ? AppColors.darkBorder : AppColors.border;
    final Color text = isDark ? AppColors.darkText : AppColors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: AppColors.primary, size: 21),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: text,
                    fontSize: 12,
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
}

class _PressScale extends StatefulWidget {
  const _PressScale({
    required this.onTap,
    required this.child,
    required this.borderRadius,
  });

  final VoidCallback onTap;
  final Widget child;
  final BorderRadius borderRadius;

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.96 : 1,
      duration: const Duration(milliseconds: 125),
      curve: Curves.easeOutCubic,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: (_) => _setPressed(true),
          onTapCancel: () => _setPressed(false),
          onTapUp: (_) => _setPressed(false),
          borderRadius: widget.borderRadius,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: widget.child,
        ),
      ),
    );
  }
}

class _ProfileGlow extends StatelessWidget {
  const _ProfileGlow({
    required this.size,
    required this.color,
    required this.opacity,
  });

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: opacity),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
