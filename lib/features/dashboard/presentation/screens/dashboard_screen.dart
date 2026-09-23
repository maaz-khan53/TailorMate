import 'package:flutter/material.dart';
import 'package:tailorx/core/constants/app_colors.dart';
import 'package:tailorx/core/theme/theme_controller.dart';
import 'package:tailorx/features/orders/presentation/screens/orders_screen.dart';
import '../../../customers/presentation/screens/gents_customers_screen.dart';
import '../../../customers/presentation/screens/kids_customers_screen.dart';
import '../../../customers/presentation/screens/ladies_customers_screen.dart';
import '../../../customers/presentation/screens/add_customer_screen.dart';
import '../../../customers/presentation/screens/total_customers_screen.dart';
import '../../../customers/presentation/screens/customer_profile_screen.dart';
import 'package:tailorx/features/menu/presentation/screens/menu_screen.dart';
import 'package:tailorx/features/dashboard/presentation/screens/notifications_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late final AnimationController _pageAnimationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  String _searchQuery = '';
  bool _searchFocused = false;

  bool get _isDarkMode =>
      Theme.of(context).brightness == Brightness.dark;

  final List<_Customer> _customers = const <_Customer>[
    _Customer(
      id: 'TX-0001',
      name: 'Ali Ahmed',
      phone: '0300 1234567',
      category: 'Gents',
      updatedLabel: 'Updated 8 min ago',
      initials: 'AA',
      photoUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
    ),
    _Customer(
      id: 'TX-0002',
      name: 'Hamza Khan',
      phone: '0312 9876543',
      category: 'Gents',
      updatedLabel: 'Added 25 min ago',
      initials: 'HK',
      photoUrl: 'https://randomuser.me/api/portraits/men/46.jpg',
    ),
    _Customer(
      id: 'TX-0003',
      name: 'Ayesha Noor',
      phone: '0333 7766554',
      category: 'Ladies',
      updatedLabel: 'Updated 1 hour ago',
      initials: 'AN',
      photoUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
    ),
    _Customer(
      id: 'TX-0004',
      name: 'Ahmed Raza',
      phone: '0345 1122334',
      category: 'Kids',
      updatedLabel: 'Added 2 hours ago',
      initials: 'AR',
      photoUrl: 'https://randomuser.me/api/portraits/men/52.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _pageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.045),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _pageAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _searchFocusNode.addListener(() {
      if (!mounted) return;
      setState(() {
        _searchFocused = _searchFocusNode.hasFocus;
      });
    });

    _pageAnimationController.forward();
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Color get _backgroundColor => _isDarkMode
      ? const Color(0xFF051510)
      : const Color(0xFFF1F8F5);

  Color get _backgroundSoftColor => _isDarkMode
      ? const Color(0xFF09251D)
      : const Color(0xFFF9FCFB);

  Color get _surfaceColor => _isDarkMode
      ? const Color(0xFF0C211A)
      : Colors.white;

  Color get _surfaceSoftColor => _isDarkMode
      ? const Color(0xFF112B22)
      : const Color(0xFFEAF5F1);

  Color get _primaryTextColor => _isDarkMode
      ? Colors.white
      : AppColors.textPrimary;

  Color get _secondaryTextColor => _isDarkMode
      ? Colors.white70
      : AppColors.textSecondary;

  Color get _borderColor => _isDarkMode
      ? Colors.white.withValues(alpha: 0.07)
      : const Color(0xFFD9E8E1);

  List<_Customer> get _searchResults {
    final String query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return const <_Customer>[];
    }

    return _customers.where((_Customer customer) {
      return customer.name.toLowerCase().contains(query) ||
          customer.phone.toLowerCase().contains(query) ||
          customer.id.toLowerCase().contains(query);
    }).toList();
  }

  void _toggleTheme() {
    ThemeController.instance.toggleTheme(
      currentlyDark: _isDarkMode,
    );
  }

  void _handleSearch(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _searchQuery = '';
    });
  }

  void _openScreen(Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 170),
        reverseTransitionDuration: const Duration(milliseconds: 130),
        pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            ) {
          return screen;
        },
        transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
            ) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
              reverseCurve: Curves.easeIn,
            ),
            child: child,
          );
        },
      ),
    );
  }

  void _openOrders() {
    _openScreen(const OrdersScreen());
  }

  void _openMenu() {
    _openScreen(
      const MenuScreen(
        userName: 'Azeem Khan',
        businessName: 'TailorX Workspace',
      ),
    );
  }

  void _openCustomerProfile(_Customer customer) {
    _openScreen(
      CustomerProfileScreen(
        customer: CustomerProfileData(
          id: customer.id,
          customerCode: customer.id,
          name: customer.name,
          phone: customer.phone,
          category: customer.category,
          photoUrl: customer.photoUrl,
        ),
        orders: const <CustomerOrderSummary>[],
        // Do not override onEditCustomer here.
        // Leaving it null lets CustomerProfileScreen open the real
        // EditCustomerScreen and apply the returned customer changes.
        onAddNewOrder: () {
          _showComingSoon('Add New Order');
        },
        onUpdateOrder: (CustomerOrderSummary order) {
          _showComingSoon('Update Order');
        },
        onShareMeasurements: (CustomerOrderSummary order) {
          _showComingSoon('Share Measurements');
        },
      ),
    );
  }

  void _showComingSoon(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryDark,
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Row(
          children: <Widget>[
            const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              '$title screen will be created next.',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final double width = screenSize.width;

    final bool isCompactPhone = width <= 360;
    final bool isPhone = width < 600;
    final bool isDesktop = width >= 1024;
    final bool isLargeDesktop = width >= 1440;

    final double horizontalPadding = isLargeDesktop
        ? 48
        : isDesktop
        ? 36
        : isPhone
        ? (isCompactPhone ? 12 : 16)
        : 24;

    final double contentMaxWidth = isLargeDesktop
        ? 1280
        : isDesktop
        ? 1180
        : isPhone
        ? 520
        : 900;

    return Scaffold(
      backgroundColor: _backgroundColor,
      floatingActionButton: isPhone ? _buildFloatingAddButton() : null,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  _backgroundColor,
                  _backgroundSoftColor,
                  _backgroundColor,
                ],
                stops: const <double>[0.0, 0.56, 1.0],
              ),
            ),
          ),
          Positioned(
            top: isPhone ? -115 : -150,
            right: isPhone ? -85 : -110,
            child: _GlowCircle(
              size: isPhone ? 300 : 390,
              color: AppColors.primaryLight,
              opacity: _isDarkMode ? 0.12 : 0.09,
            ),
          ),
          Positioned(
            bottom: isPhone ? -160 : -210,
            left: isPhone ? -105 : -140,
            child: _GlowCircle(
              size: isPhone ? 340 : 440,
              color: AppColors.gold,
              opacity: _isDarkMode ? 0.055 : 0.045,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                isPhone ? 12 : 20,
                horizontalPadding,
                isPhone ? 104 : 36,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentMaxWidth),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildTopHeader(),
                          SizedBox(height: isPhone ? 14 : 20),
                          _buildHeroCard(isDesktop),
                          SizedBox(height: isPhone ? 15 : 20),
                          _buildSearchSection(),
                          SizedBox(height: isPhone ? 20 : 26),
                          _buildCategoriesSection(),
                          if (!isPhone) ...<Widget>[
                            const SizedBox(height: 18),
                            _buildAddCustomerButton(),
                          ],
                          SizedBox(height: isPhone ? 21 : 28),
                          _buildRecentCustomersSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth <= 360;
        final bool veryCompact = constraints.maxWidth <= 320;
        final double logoSize = compact ? 44 : 50;
        final double titleSize = compact ? 20 : 23;
        final double actionGap = compact ? 5 : 8;

        return Row(
          children: <Widget>[
            Container(
              width: logoSize,
              height: logoSize,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    AppColors.primaryDark,
                    AppColors.primary,
                    AppColors.primaryLight,
                  ],
                ),
                borderRadius: BorderRadius.circular(compact ? 15 : 17),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.24),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.content_cut_rounded,
                color: Colors.white,
                size: compact ? 22 : 25,
              ),
            ),
            SizedBox(width: compact ? 9 : 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Dashboard',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _primaryTextColor,
                      fontSize: titleSize,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.35,
                    ),
                  ),
                  if (!veryCompact) ...<Widget>[
                    const SizedBox(height: 2),
                    Text(
                      'TailorX business workspace',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _secondaryTextColor,
                        fontSize: compact ? 9 : 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: compact ? 5 : 8),
            _buildNotificationButton(),
            SizedBox(width: actionGap),
            _buildThemeButton(),
            SizedBox(width: actionGap),
            _buildMenuButton(),
          ],
        );
      },
    );
  }

  Widget _buildNotificationButton() {
    return _HeaderActionButton(
      onTap: () => _openScreen(const NotificationsScreen()),
      backgroundColor: _surfaceSoftColor,
      borderColor: _borderColor,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Icon(
            Icons.notifications_none_rounded,
            color: _primaryTextColor,
            size: 21,
          ),
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeButton() {
    return _HeaderActionButton(
      onTap: _toggleTheme,
      backgroundColor: _surfaceSoftColor,
      borderColor: _borderColor,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 240),
        transitionBuilder: (
            Widget child,
            Animation<double> animation,
            ) {
          return RotationTransition(
            turns: Tween<double>(
              begin: 0.65,
              end: 1,
            ).animate(animation),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: Icon(
          _isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          key: ValueKey<bool>(_isDarkMode),
          color: _isDarkMode ? AppColors.gold : AppColors.primaryDark,
          size: 21,
        ),
      ),
    );
  }

  Widget _buildMenuButton() {
    return _HeaderActionButton(
      onTap: _openMenu,
      backgroundColor: _surfaceSoftColor,
      borderColor: AppColors.primary.withValues(alpha: 0.55),
      child: Icon(
        Icons.menu_rounded,
        color: _primaryTextColor,
        size: 23,
      ),
    );
  }

  Widget _buildHeroCard(bool isWide) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool compact = screenWidth <= 360;
    final bool phone = screenWidth < 600;

    final double cardRadius = compact ? 23 : 28;
    final double heroMinHeight = compact
        ? 208
        : phone
        ? 190
        : 200;

    final double decorativeIconSize = compact
        ? 78
        : phone
        ? 105
        : isWide
        ? 150
        : 125;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.97, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      builder: (
          BuildContext context,
          double value,
          Widget? child,
          ) {
        return Transform.scale(
          scale: value,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: heroMinHeight),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              AppColors.primaryDark,
              AppColors.primary,
              AppColors.primaryLight,
            ],
          ),
          borderRadius: BorderRadius.circular(cardRadius),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.26),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(cardRadius),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -70,
                right: -35,
                child: Container(
                  width: phone ? 190 : 230,
                  height: phone ? 190 : 230,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.09),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -75,
                right: phone ? 36 : 90,
                child: Container(
                  width: phone ? 145 : 175,
                  height: phone ? 145 : 175,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: compact ? 8 : (isWide ? 42 : 16),
                bottom: compact ? 12 : (isWide ? 16 : 10),
                child: Icon(
                  Icons.dry_cleaning_rounded,
                  color: Colors.white.withValues(alpha: compact ? 0.11 : 0.18),
                  size: decorativeIconSize,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  compact ? 17 : (isWide ? 28 : 20),
                  compact ? 19 : (isWide ? 27 : 22),
                  compact ? 17 : (isWide ? 230 : 95),
                  compact ? 20 : (isWide ? 25 : 21),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: compact ? 8 : 10,
                        vertical: compact ? 4 : 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Text(
                        'TAILORX WORKSPACE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: compact ? 7 : 8,
                          letterSpacing: 0.9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(height: compact ? 10 : 12),
                    Text(
                      'Good Afternoon,',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: compact ? 11 : 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Azeem Khan',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: compact ? 24 : (isWide ? 30 : 28),
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.4,
                      ),
                    ),
                    SizedBox(height: compact ? 6 : 7),
                    Text(
                      compact
                          ? 'Manage customers, measurements and orders from one smart workspace.'
                          : 'Manage customers, measurements and orders\n'
                          'from one smart workspace.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: compact ? 10 : 11,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: compact ? 12 : 14),
                    _AnimatedOrdersButton(onTap: _openOrders),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    final List<_Customer> results = _searchResults;
    final bool hasSearch = _searchQuery.trim().isNotEmpty;
    final bool focused = _searchFocused;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          height: 54,
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onChanged: _handleSearch,
            textInputAction: TextInputAction.search,
            style: TextStyle(
              color: _primaryTextColor,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: 'Search by ID, phone or name',
              hintStyle: TextStyle(
                color: _secondaryTextColor.withValues(alpha: 0.68),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              prefixIcon: AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: focused ? 1.08 : 1,
                child: Icon(
                  Icons.search_rounded,
                  color: focused
                      ? AppColors.primary
                      : _secondaryTextColor,
                  size: 21,
                ),
              ),
              suffixIcon: AnimatedSwitcher(
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
                child: hasSearch
                    ? IconButton(
                  key: const ValueKey<String>('clear-search'),
                  tooltip: 'Clear search',
                  onPressed: _clearSearch,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.primary,
                    size: 19,
                  ),
                )
                    : const SizedBox(
                  key: ValueKey<String>('empty-search-action'),
                  width: 10,
                ),
              ),
              filled: true,
              fillColor: _surfaceColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: _borderColor, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: _borderColor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: _borderColor, width: 1),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 17,
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: !hasSearch
              ? const SizedBox.shrink()
              : Padding(
            padding: const EdgeInsets.only(top: 8),
            child: results.isEmpty
                ? _buildNotFoundCard()
                : Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
              decoration: BoxDecoration(
                color: _surfaceColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _borderColor),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: _isDarkMode ? 0.10 : 0.04,
                    ),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: List<Widget>.generate(
                  results.length,
                      (int index) {
                    return TweenAnimationBuilder<double>(
                      key: ValueKey<String>(
                        '${results[index].id}-$_searchQuery',
                      ),
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(
                        milliseconds: 170 + (index * 55),
                      ),
                      curve: Curves.easeOutCubic,
                      builder: (
                          BuildContext context,
                          double value,
                          Widget? child,
                          ) {
                        return Opacity(
                          opacity: value.clamp(0, 1),
                          child: Transform.translate(
                            offset: Offset(0, 7 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: _buildSearchResultCard(
                        results[index],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }





  Widget _buildNotFoundCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(
          alpha: _isDarkMode ? 0.11 : 0.10,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.person_search_rounded,
            color: AppColors.warning,
            size: 22,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'Customer not found. Try another ID, phone or name.',
              style: TextStyle(
                color: _primaryTextColor,
                fontSize: 10,
                height: 1.3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultCard(_Customer customer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openCustomerProfile(customer),
          borderRadius: BorderRadius.circular(14),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool compact = constraints.maxWidth <= 340;

              return Container(
                padding: EdgeInsets.all(compact ? 9 : 10),
                decoration: BoxDecoration(
                  color: _surfaceSoftColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: <Widget>[
                    _buildAvatar(customer, size: compact ? 36 : 40),
                    SizedBox(width: compact ? 8 : 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            customer.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: _primaryTextColor,
                              fontSize: compact ? 11.5 : 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${customer.id} • ${customer.phone}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: _secondaryTextColor,
                              fontSize: compact ? 8.3 : 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: compact ? 5 : 8),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final List<_CategoryItem> categories = <_CategoryItem>[
      _CategoryItem(
        title: 'Total Customers',
        count: '248',
        icon: Icons.groups_2_rounded,
        color: const Color(0xFF377DFF),
        onTap: () => _openScreen(const TotalCustomersScreen()),
      ),
      _CategoryItem(
        title: 'Gents',
        count: '126',
        icon: Icons.man_rounded,
        color: AppColors.success,
        onTap: () => _openScreen(const GentsCustomersScreen()),
      ),
      _CategoryItem(
        title: 'Ladies',
        count: '72',
        icon: Icons.woman_rounded,
        color: const Color(0xFFE65F9B),
        onTap: () => _openScreen(const LadiesCustomersScreen()),
      ),
      _CategoryItem(
        title: 'Kids',
        count: '50',
        icon: Icons.child_care_rounded,
        color: AppColors.warning,
        onTap: () => _openScreen(const KidsCustomersScreen()),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionHeading(
          title: 'Customer Categories',
          subtitle: 'View and manage customers by category',
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double availableWidth = constraints.maxWidth;
            final int columns = availableWidth >= 820 ? 4 : 2;
            final double spacing = availableWidth <= 360 ? 9 : 11;
            final double cardWidth =
                (availableWidth - (spacing * (columns - 1))) / columns;

            final double targetHeight = cardWidth < 170
                ? 148
                : cardWidth < 260
                ? 158
                : 170;

            final double aspectRatio = cardWidth / targetHeight;

            return GridView.builder(
              itemCount: categories.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                childAspectRatio: aspectRatio,
              ),
              itemBuilder: (BuildContext context, int index) {
                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(milliseconds: 420 + (index * 90)),
                  curve: Curves.easeOutBack,
                  builder: (
                      BuildContext context,
                      double value,
                      Widget? child,
                      ) {
                    return Opacity(
                      opacity: value.clamp(0, 1),
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Transform.scale(
                          scale: 0.94 + (0.06 * value),
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: _CategoryCard(
                    item: categories[index],
                    isDarkMode: _isDarkMode,
                    surfaceColor: _surfaceColor,
                    borderColor: _borderColor,
                    primaryTextColor: _primaryTextColor,
                    secondaryTextColor: _secondaryTextColor,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildAddCustomerButton() {
    return _PressScale(
      onTap: () => _openScreen(const AddCustomerScreen()),
      borderRadius: BorderRadius.circular(21),
      pressedScale: 0.975,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(15, 14, 15, 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[
              AppColors.primaryDark,
              AppColors.primary,
              AppColors.primaryLight,
            ],
          ),
          borderRadius: BorderRadius.circular(21),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.10),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.23),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.person_add_alt_1_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Add New Customer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Create profile and save dress measurements',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.13),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 19,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildFloatingAddButton() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 720),
      curve: Curves.easeOutBack,
      builder: (
          BuildContext context,
          double value,
          Widget? child,
          ) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: _PressScale(
        onTap: () => _openScreen(const AddCustomerScreen()),
        borderRadius: BorderRadius.circular(18),
        pressedScale: 0.95,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: <Color>[
                AppColors.primaryDark,
                AppColors.primaryLight,
              ],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.30),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: null,
            elevation: 0,
            disabledElevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.person_add_alt_1_rounded),
            label: const Text(
              'Add Customer',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentCustomersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionHeading(
          title: 'Recent Customers',
          subtitle: 'Recently added or updated records',
        ),
        const SizedBox(height: 11),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            color: _surfaceColor,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: AppColors.primary.withValues(
                alpha: _isDarkMode ? 0.16 : 0.09,
              ),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: _isDarkMode ? 0.10 : 0.035,
                ),
                blurRadius: 17,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            children: List<Widget>.generate(
              _customers.length,
                  (int index) {
                final _Customer customer = _customers[index];

                return Column(
                  children: <Widget>[
                    _buildRecentCustomerTile(customer),
                    if (index != _customers.length - 1)
                      Divider(
                        height: 1,
                        indent: 66,
                        endIndent: 12,
                        color: _borderColor,
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentCustomerTile(_Customer customer) {
    return _PressScale(
      onTap: () => _openCustomerProfile(customer),
      borderRadius: BorderRadius.circular(20),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool compact = constraints.maxWidth <= 380;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 10 : 13,
              vertical: compact ? 11 : 12,
            ),
            child: Row(
              children: <Widget>[
                _buildAvatar(customer, size: compact ? 40 : 44),
                SizedBox(width: compact ? 9 : 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (compact)
                        Text(
                          customer.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: _primaryTextColor,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w900,
                          ),
                        )
                      else
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                customer.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _primaryTextColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 7),
                            _CategoryBadge(
                              label: customer.category,
                              isDarkMode: _isDarkMode,
                            ),
                          ],
                        ),
                      const SizedBox(height: 4),
                      Text(
                        '${customer.id} • ${customer.phone}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _secondaryTextColor,
                          fontSize: compact ? 8.3 : 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 7,
                        runSpacing: 4,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Icon(
                                Icons.schedule_rounded,
                                color: AppColors.primary,
                                size: 11,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                customer.updatedLabel,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          if (compact)
                            _CategoryBadge(
                              label: customer.category,
                              isDarkMode: _isDarkMode,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: compact ? 6 : 8),
                Container(
                  width: compact ? 28 : 31,
                  height: compact ? 28 : 31,
                  decoration: BoxDecoration(
                    color: _surfaceSoftColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: _secondaryTextColor,
                    size: compact ? 18 : 20,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar(
      _Customer customer, {
        required double size,
      }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.31),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.16),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.31),
        child: Image.network(
          customer.photoUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
              ) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    AppColors.primary,
                    AppColors.primaryLight,
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                customer.initials,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.27,
                  fontWeight: FontWeight.w900,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeading({
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    final double width = MediaQuery.sizeOf(context).width;
    final bool compact = width <= 360;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 4,
          height: compact ? 35 : 39,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                AppColors.primaryLight,
                AppColors.primaryDark,
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.22),
                blurRadius: 9,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        SizedBox(width: compact ? 8 : 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _primaryTextColor,
                  fontSize: compact ? 16 : 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.28,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _secondaryTextColor,
                  fontSize: compact ? 8.8 : 9.5,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }
}


class _AnimatedOrdersButton extends StatefulWidget {
  const _AnimatedOrdersButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  State<_AnimatedOrdersButton> createState() =>
      _AnimatedOrdersButtonState();
}

class _AnimatedOrdersButtonState extends State<_AnimatedOrdersButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;
  late final Animation<double> _arrowSlide;

  bool _pressed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    )..repeat(reverse: true);

    _pulse = Tween<double>(
      begin: 1,
      end: 1.035,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _arrowSlide = Tween<double>(
      begin: 0,
      end: 4,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulse,
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: (_) {
              setState(() {
                _pressed = true;
              });
            },
            onTapCancel: () {
              setState(() {
                _pressed = false;
              });
            },
            onTapUp: (_) {
              setState(() {
                _pressed = false;
              });
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 170),
              padding: const EdgeInsets.fromLTRB(14, 10, 11, 10),
              decoration: BoxDecoration(
                color: _pressed
                    ? const Color(0xFFF1F8F5)
                    : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _pressed
                      ? AppColors.primaryLight.withValues(alpha: 0.70)
                      : Colors.white.withValues(alpha: 0.78),
                  width: _pressed ? 1.4 : 1,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: _pressed ? 0.07 : 0.14,
                    ),
                    blurRadius: _pressed ? 8 : 16,
                    offset: Offset(0, _pressed ? 3 : 7),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 29,
                    height: 29,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          AppColors.primaryDark,
                          AppColors.primary,
                          AppColors.primaryLight,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(
                      Icons.inventory_2_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 9),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'View Orders',
                        style: TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        'Tap to open',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 7.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  AnimatedBuilder(
                    animation: _arrowSlide,
                    builder: (
                        BuildContext context,
                        Widget? child,
                        ) {
                      return Transform.translate(
                        offset: Offset(_arrowSlide.value, 0),
                        child: child,
                      );
                    },
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.primary,
                      size: 18,
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


class _PressScale extends StatefulWidget {
  const _PressScale({
    required this.onTap,
    required this.child,
    required this.borderRadius,
    this.pressedScale = 0.97,
  });

  final VoidCallback onTap;
  final Widget child;
  final BorderRadius borderRadius;
  final double pressedScale;

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() {
      _pressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? widget.pressedScale : 1,
      duration: const Duration(milliseconds: 135),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: _pressed ? 0.94 : 1,
        duration: const Duration(milliseconds: 110),
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
            hoverColor: Colors.transparent,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  const _HeaderActionButton({
    required this.onTap,
    required this.backgroundColor,
    required this.borderColor,
    required this.child,
  });

  final VoidCallback onTap;
  final Color backgroundColor;
  final Color borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final double size = width <= 360
        ? 38
        : width < 600
        ? 42
        : 44;
    final double radius = size * 0.34;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: borderColor),
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  const _CategoryCard({
    required this.item,
    required this.isDarkMode,
    required this.surfaceColor,
    required this.borderColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
  });

  final _CategoryItem item;
  final bool isDarkMode;
  final Color surfaceColor;
  final Color borderColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.96 : 1,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.item.onTap,
          onTapDown: (_) {
            setState(() {
              _isPressed = true;
            });
          },
          onTapCancel: () {
            setState(() {
              _isPressed = false;
            });
          },
          onTapUp: (_) {
            setState(() {
              _isPressed = false;
            });
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          borderRadius: BorderRadius.circular(21),
          child: Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: widget.surfaceColor,
              borderRadius: BorderRadius.circular(21),
              border: Border.all(
                color: _isPressed
                    ? widget.item.color.withValues(alpha: 0.48)
                    : widget.borderColor,
                width: _isPressed ? 1.4 : 1,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: _isPressed
                      ? widget.item.color.withValues(alpha: 0.12)
                      : Colors.black.withValues(
                    alpha: widget.isDarkMode ? 0.11 : 0.035,
                  ),
                  blurRadius: _isPressed ? 8 : 15,
                  offset: Offset(0, _isPressed ? 3 : 7),
                ),
              ],
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  right: -25,
                  bottom: -30,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: widget.item.color.withValues(alpha: 0.07),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 39,
                          height: 39,
                          decoration: BoxDecoration(
                            color:
                            widget.item.color.withValues(alpha: 0.13),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            widget.item.icon,
                            color: widget.item.color,
                            size: 21,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color:
                            widget.item.color.withValues(alpha: 0.09),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_outward_rounded,
                            color: widget.item.color,
                            size: 15,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      widget.item.count,
                      style: TextStyle(
                        color: widget.primaryTextColor,
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: widget.secondaryTextColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
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
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({
    required this.label,
    required this.isDarkMode,
  });

  final String label;
  final bool isDarkMode;

  Color get _color {
    switch (label.toLowerCase()) {
      case 'gents':
        return AppColors.success;
      case 'ladies':
        return const Color(0xFFE65F9B);
      case 'kids':
        return AppColors.warning;
      default:
        return const Color(0xFF377DFF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(
          alpha: isDarkMode ? 0.16 : 0.11,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _color,
          fontSize: 8,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({
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
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: color.withValues(alpha: opacity),
              blurRadius: 65,
              spreadRadius: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class _Customer {
  const _Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.category,
    required this.updatedLabel,
    required this.initials,
    required this.photoUrl,
  });

  final String id;
  final String name;
  final String phone;
  final String category;
  final String updatedLabel;
  final String initials;

  /// Demo/customer image URL.
  /// Backend can replace this with the real uploaded customer photo URL/path.
  final String photoUrl;
}

class _CategoryItem {
  const _CategoryItem({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}


