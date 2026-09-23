import 'package:flutter/material.dart';
import 'package:tailorx/core/constants/app_colors.dart';
import 'customer_profile_screen.dart';
import 'responsive_layout.dart';
class GentsCustomersScreen extends StatefulWidget {
  const GentsCustomersScreen({super.key});

  @override
  State<GentsCustomersScreen> createState() => _GentsCustomersScreenState();
}

class _GentsCustomersScreenState extends State<GentsCustomersScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  String _query = '';

// Use shared TailorX colors
  static const Color _primary = AppColors.primary;
  static const Color _primaryDark = AppColors.primaryDark;
  static const Color _primaryLight = AppColors.primaryLight;
  static const Color _gold = AppColors.gold;

  final List<_CustomerItem> _customers = const [
    _CustomerItem(
      customerId: 'TX-0001',
      name: 'Ali Ahmed',
      phone: '0300 1234567',
      category: 'Gents',
      updatedLabel: '8 min ago',
      initials: 'AA',
      photoUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
    ),
    _CustomerItem(
      customerId: 'TX-0004',
      name: 'Usman Tariq',
      phone: '0301 4455667',
      category: 'Gents',
      updatedLabel: 'Yesterday',
      initials: 'UT',
      photoUrl: 'https://randomuser.me/api/portraits/men/41.jpg',
    ),
    _CustomerItem(
      customerId: 'TX-0005',
      name: 'Hamza Khan',
      phone: '0312 9876543',
      category: 'Gents',
      updatedLabel: '2 days ago',
      initials: 'HK',
      photoUrl: 'https://randomuser.me/api/portraits/men/46.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.045),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<_CustomerItem> get _filteredCustomers {
    final String q = _query.trim().toLowerCase();

    if (q.isEmpty) {
      return _customers;
    }

    return _customers.where((_CustomerItem customer) {
      return customer.name.toLowerCase().contains(q) ||
          customer.phone.toLowerCase().contains(q) ||
          customer.customerId.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color background =
    isDark ? const Color(0xFF06130F) : const Color(0xFFF3F8F6);
    final Color surface =
    isDark ? const Color(0xFF0D211A) : Colors.white;
    final Color softSurface =
    isDark ? const Color(0xFF122B22) : const Color(0xFFEAF5F1);
    final Color primaryText =
    isDark ? Colors.white : const Color(0xFF10271F);
    final Color secondaryText =
    isDark ? Colors.white70 : const Color(0xFF64746D);

    final List<_CustomerItem> visibleCustomers = _filteredCustomers;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned(
              top: -110,
              right: -80,
              child: _GlowCircle(
                size: 290,
                color: _primaryLight,
                opacity: 0.10,
              ),
            ),
            const Positioned(
              bottom: -150,
              left: -100,
              child: _GlowCircle(
                size: 330,
                color: _gold,
                opacity: 0.05,
              ),
            ),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double pagePadding =
                ResponsiveLayout.horizontalPadding(constraints.maxWidth);
                final double maxWidth =
                ResponsiveLayout.contentMaxWidth(constraints.maxWidth);

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    pagePadding,
                    16,
                    pagePadding,
                    28,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeader(
                                context: context,
                                isDark: isDark,
                                surface: surface,
                                primaryText: primaryText,
                                secondaryText: secondaryText,
                              ),
                              const SizedBox(height: 18),
                              _buildHeroCard(),
                              const SizedBox(height: 18),
                              _buildSearchCard(
                                isDark: isDark,
                                surface: surface,
                                softSurface: softSurface,
                                primaryText: primaryText,
                                secondaryText: secondaryText,
                              ),
                              const SizedBox(height: 18),
                              _buildSectionTitle(
                                primaryText: primaryText,
                                secondaryText: secondaryText,
                                count: visibleCustomers.length,
                              ),
                              const SizedBox(height: 12),
                              if (visibleCustomers.isEmpty)
                                _buildEmptyState(
                                  isDark: isDark,
                                  surface: surface,
                                  primaryText: primaryText,
                                  secondaryText: secondaryText,
                                )
                              else
                                LayoutBuilder(
                                  builder: (
                                      BuildContext context,
                                      BoxConstraints listConstraints,
                                      ) {
                                    final int columns = ResponsiveLayout
                                        .gridColumns(listConstraints.maxWidth);
                                    final double gap = ResponsiveLayout
                                        .cardGap(listConstraints.maxWidth);

                                    if (columns == 1) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          for (int index = 0;
                                          index < visibleCustomers.length;
                                          index++) ...[
                                            _buildCustomerCard(
                                              customer: visibleCustomers[index],
                                              isDark: isDark,
                                              surface: surface,
                                              primaryText: primaryText,
                                              secondaryText: secondaryText,
                                            ),
                                            if (index != visibleCustomers.length - 1)
                                              SizedBox(height: gap),
                                          ],
                                        ],
                                      );
                                    }

                                    final double itemWidth =
                                        (listConstraints.maxWidth -
                                            (gap * (columns - 1))) /
                                            columns;

                                    return Wrap(
                                      spacing: gap,
                                      runSpacing: gap,
                                      children: visibleCustomers
                                          .map(
                                            (_CustomerItem customer) => SizedBox(
                                          width: itemWidth,
                                          child: _buildCustomerCard(
                                            customer: customer,
                                            isDark: isDark,
                                            surface: surface,
                                            primaryText: primaryText,
                                            secondaryText: secondaryText,
                                          ),
                                        ),
                                      )
                                          .toList(),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader({
    required BuildContext context,
    required bool isDark,
    required Color surface,
    required Color primaryText,
    required Color secondaryText,
  }) {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.07)
                      : const Color(0xFFDCE9E3),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: _primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gents Customers',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Manage all gents tailoring profiles',
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                _primaryDark,
                _primaryLight,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _primary.withValues(alpha: 0.22),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.man_rounded,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 19),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _primaryDark,
            _primary,
            _primaryLight,
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: _primary.withValues(alpha: 0.24),
            blurRadius: 26,
            offset: const Offset(0, 13),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -25,
            top: -34,
            child: Container(
              width: 145,
              height: 145,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            right: 4,
            bottom: -10,
            child: Icon(
              Icons.man_rounded,
              size: 86,
              color: Colors.white.withValues(alpha: 0.16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 88),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'GENTS CUSTOMERS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${_customers.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Quickly access measurements and details for gents.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard({
    required bool isDark,
    required Color surface,
    required Color softSurface,
    required Color primaryText,
    required Color secondaryText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.07)
              : const Color(0xFFDCE9E3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.14 : 0.045,
            ),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (String value) {
          setState(() {
            _query = value;
          });
        },
        style: TextStyle(
          color: primaryText,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: 'Search by ID, name or phone',
          hintStyle: TextStyle(
            color: secondaryText.withValues(alpha: 0.72),
            fontSize: 12,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: _primary,
          ),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _query = '';
              });
            },
            icon: const Icon(
              Icons.close_rounded,
              color: _primary,
            ),
          ),
          filled: true,
          fillColor: softSurface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : const Color(0xFFD8E6E0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: _primaryLight,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle({
    required Color primaryText,
    required Color secondaryText,
    required int count,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer List',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '$count customer${count == 1 ? '' : 's'} found',
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: _primary.withValues(alpha: 0.11),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: _primary,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerCard({
    required _CustomerItem customer,
    required bool isDark,
    required Color surface,
    required Color primaryText,
    required Color secondaryText,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder<void>(
              transitionDuration: const Duration(milliseconds: 170),
              reverseTransitionDuration: const Duration(milliseconds: 130),
              pageBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  ) => CustomerProfileScreen(
                customer: CustomerProfileData(
                  id: customer.customerId,
                  customerCode: customer.customerId,
                  name: customer.name,
                  phone: customer.phone,
                  category: customer.category,
                  photoUrl: customer.photoUrl,
                ),
                orders: const <CustomerOrderSummary>[],
              ),
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
        },
        borderRadius: BorderRadius.circular(21),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(21),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.07)
                  : const Color(0xFFDCE8E3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isDark ? 0.13 : 0.04,
                ),
                blurRadius: 18,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Row(
            children: [
// Fixed-size avatar: release APK must never allow a failed or
// loading network image to expand the customer card.
              SizedBox(
                width: 52,
                height: 52,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    boxShadow: [
                      BoxShadow(
                        color: _primary.withValues(alpha: 0.18),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: _buildCustomerAvatar(customer),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${customer.customerId}  •  ${customer.phone}',
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 7,
                      runSpacing: 6,
                      children: [
                        _InfoBadge(
                          icon: Icons.category_rounded,
                          label: customer.category,
                        ),
                        _InfoBadge(
                          icon: Icons.schedule_rounded,
                          label: customer.updatedLabel,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: secondaryText,
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildCustomerAvatar(_CustomerItem customer) {
    final String imageUrl = customer.photoUrl.trim();

    if (imageUrl.isEmpty) {
      return _avatarFallback(customer.initials);
    }

    return Image.network(
      imageUrl,
      width: 52,
      height: 52,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
      loadingBuilder: (
          BuildContext context,
          Widget child,
          ImageChunkEvent? loadingProgress,
          ) {
        if (loadingProgress == null) {
          return child;
        }

        return _avatarFallback(customer.initials);
      },
      errorBuilder: (
          BuildContext context,
          Object error,
          StackTrace? stackTrace,
          ) {
        return _avatarFallback(customer.initials);
      },
    );
  }

  Widget _avatarFallback(String initials) {
    return Container(
      width: 52,
      height: 52,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_primary, _primaryLight],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required bool isDark,
    required Color surface,
    required Color primaryText,
    required Color secondaryText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 34,
      ),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.07)
              : const Color(0xFFDCE8E3),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: _primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_search_rounded,
              color: _primary,
              size: 34,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'No customer found',
            style: TextStyle(
              color: primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Try searching with another customer ID, name or phone number.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondaryText,
              fontSize: 11,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoBadge({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 11,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 8,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
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
          color: color.withValues(alpha: opacity),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: opacity),
              blurRadius: 65,
              spreadRadius: 12,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerItem {
  final String customerId;
  final String name;
  final String phone;
  final String category;
  final String updatedLabel;
  final String initials;

  /// Demo/customer profile image URL.
  /// Replace this with the photo URL/path returned by the backend API.
  final String photoUrl;

  const _CustomerItem({
    required this.customerId,
    required this.name,
    required this.phone,
    required this.category,
    required this.updatedLabel,
    required this.initials,
    required this.photoUrl,
  });
}
