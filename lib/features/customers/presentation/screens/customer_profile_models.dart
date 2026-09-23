// import 'dart:io';
//
// import 'package:flutter/material.dart';
//
// import 'package:tailorx/core/constants/app_colors.dart';
// import 'package:tailorx/features/orders/presentation/screens/add_saved_measurement_order_screen.dart';
// import 'package:tailorx/features/customers/presentation/screens/edit_customer_screen.dart';
// import 'responsive_layout.dart';
//
// class CustomerProfileScreen extends StatefulWidget {
//   const CustomerProfileScreen({
//     super.key,
//     this.customer,
//     this.orders = const <CustomerOrderSummary>[],
//     this.onEditCustomer,
//     this.onAddNewOrder,
//     this.onUpdateOrder,
//     this.onShareMeasurements,
//     this.onUseLatestMeasurements,
//     this.onMeasurementsUpdated,
//     this.onShareLatestMeasurements,
//     this.onAddDressMeasurement,
//   });
//
//   final CustomerProfileData? customer;
//   final List<CustomerOrderSummary> orders;
//   final VoidCallback? onEditCustomer;
//   final VoidCallback? onAddNewOrder;
//   final ValueChanged<CustomerOrderSummary>? onUpdateOrder;
//   final ValueChanged<CustomerOrderSummary>? onShareMeasurements;
//
//   /// Optional backend/navigation hook.
//   ///
//   /// When supplied, the parent can open Add Order with these measurements
//   /// already filled. When omitted, this screen opens AddOrderScreen normally.
//   final ValueChanged<CustomerMeasurementRecord>? onUseLatestMeasurements;
//
//   /// Called when the tailor taps Share on the latest measurements.
//   /// Connect this later to WhatsApp/PDF sharing.
//   final ValueChanged<CustomerMeasurementRecord>? onShareLatestMeasurements;
//
//   /// Opens the form for adding a completely new dress measurement record.
//   final VoidCallback? onAddDressMeasurement;
//
//   /// Called after measurements are updated from the profile screen.
//   /// Use this later to connect the PHP API / MySQL save request.
//   final ValueChanged<CustomerMeasurementRecord>? onMeasurementsUpdated;
//
//   @override
//   State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
// }
//
// class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
//   CustomerProfileData? _currentCustomer;
//   late List<CustomerMeasurementRecord> _measurementHistory;
//
//   CustomerProfileData get _customer =>
//       _currentCustomer ??
//           widget.customer ??
//           CustomerProfileData.demo();
//
//   @override
//   void initState() {
//     super.initState();
//
//     _currentCustomer =
//         widget.customer ?? CustomerProfileData.demo();
//
//     _measurementHistory = List<CustomerMeasurementRecord>.from(
//       _customer.measurementHistory,
//     );
//
//     // UI preview:
//     // If the opened customer does not have saved measurements yet,
//     // add multiple demo dress records so the client can clearly understand
//     // that one customer can keep separate permanent measurements for
//     // different dress types.
//     if (_measurementHistory.isEmpty) {
//       final String category = _customer.category.trim().toLowerCase();
//
//       if (category.contains('lad')) {
//         _measurementHistory.addAll(
//           <CustomerMeasurementRecord>[
//             CustomerMeasurementRecord(
//               id: 'preview-ladies-shalwar-${_customer.id}',
//               customerId: _customer.id,
//               dressType: 'Shalwar Kameez',
//               values: const <String, String>{
//                 'Shirt Length': '42',
//                 'Chest': '38',
//                 'Waist': '34',
//                 'Hip': '40',
//                 'Shoulder': '15',
//                 'Sleeve': '22',
//                 'Trouser Length': '39',
//                 'Bottom': '7',
//               },
//               notes: 'Comfort fit with straight shirt and regular trouser.',
//               updatedAt: DateTime(2026, 7, 24),
//             ),
//             CustomerMeasurementRecord(
//               id: 'preview-kurti-${_customer.id}',
//               customerId: _customer.id,
//               dressType: 'Kurti',
//               values: const <String, String>{
//                 'Kurti Length': '36',
//                 'Chest': '38',
//                 'Waist': '34',
//                 'Hip': '40',
//                 'Shoulder': '15',
//                 'Sleeve': '20',
//                 'Armhole': '18',
//                 'Front Neck': '7',
//               },
//               notes: 'Slightly loose fitting with round neck.',
//               updatedAt: DateTime(2026, 7, 20),
//             ),
//             CustomerMeasurementRecord(
//               id: 'preview-frock-${_customer.id}',
//               customerId: _customer.id,
//               dressType: 'Frock',
//               values: const <String, String>{
//                 'Frock Length': '52',
//                 'Chest': '38',
//                 'Waist': '33',
//                 'Shoulder': '15',
//                 'Sleeve': '21',
//                 'Upper Body Length': '15',
//                 'Flare': '85',
//               },
//               notes: 'Full flare with soft fitting at waist.',
//               updatedAt: DateTime(2026, 7, 15),
//             ),
//           ],
//         );
//       } else if (category.contains('kid') ||
//           category.contains('child') ||
//           category.contains('boy') ||
//           category.contains('girl')) {
//         _measurementHistory.addAll(
//           <CustomerMeasurementRecord>[
//             CustomerMeasurementRecord(
//               id: 'preview-kids-shalwar-${_customer.id}',
//               customerId: _customer.id,
//               dressType: 'Boys Shalwar Kameez',
//               values: const <String, String>{
//                 'Shirt Length': '26',
//                 'Chest': '28',
//                 'Waist': '26',
//                 'Shoulder': '12',
//                 'Sleeve': '16',
//                 'Collar': '11',
//                 'Shalwar Length': '27',
//                 'Bottom': '6',
//               },
//               notes: 'Comfortable fitting for daily wear.',
//               updatedAt: DateTime(2026, 7, 24),
//             ),
//             CustomerMeasurementRecord(
//               id: 'preview-kids-kurta-${_customer.id}',
//               customerId: _customer.id,
//               dressType: 'Boys Kurta',
//               values: const <String, String>{
//                 'Kurta Length': '25',
//                 'Chest': '28',
//                 'Waist': '26',
//                 'Shoulder': '12',
//                 'Sleeve': '16',
//                 'Collar': '11',
//                 'Cuff': '7',
//               },
//               notes: 'Straight kurta with normal collar fitting.',
//               updatedAt: DateTime(2026, 7, 20),
//             ),
//             CustomerMeasurementRecord(
//               id: 'preview-kids-waistcoat-${_customer.id}',
//               customerId: _customer.id,
//               dressType: 'Boys Waistcoat',
//               values: const <String, String>{
//                 'Length': '17',
//                 'Chest': '29',
//                 'Waist': '27',
//                 'Shoulder': '11.5',
//                 'Armhole': '14',
//                 'Front Neck': '6',
//               },
//               notes: 'Close fitting waistcoat for formal wear.',
//               updatedAt: DateTime(2026, 7, 14),
//             ),
//           ],
//         );
//       } else {
//         _measurementHistory.addAll(
//           <CustomerMeasurementRecord>[
//             CustomerMeasurementRecord(
//               id: 'preview-shalwar-kameez-${_customer.id}',
//               customerId: _customer.id,
//               dressType: 'Shalwar Kameez',
//               values: const <String, String>{
//                 'Length': '43',
//                 'Chest': '43',
//                 'Waist': '44',
//                 'Shoulder': '18',
//                 'Sleeve': '24',
//                 'Collar': '15.5',
//                 'Shalwar': '40',
//                 'Cuff': '9',
//               },
//               notes: 'Normal fitting. Keep the previous neck and shoulder fitting.',
//               updatedAt: DateTime(2026, 7, 24),
//             ),
//             CustomerMeasurementRecord(
//               id: 'preview-dress-shirt-${_customer.id}',
//               customerId: _customer.id,
//               dressType: 'Dress Shirt',
//               values: const <String, String>{
//                 'Collar': '15.5',
//                 'Shoulder': '18',
//                 'Bust / Chest': '42',
//                 'Sleeve Length': '24',
//                 'Waist': '40',
//                 'Back Length': '30',
//                 'Cuff': '9',
//                 'Armhole': '20',
//               },
//               notes: 'Slim formal fitting with full sleeves.',
//               updatedAt: DateTime(2026, 7, 20),
//             ),
//             CustomerMeasurementRecord(
//               id: 'preview-waistcoat-${_customer.id}',
//               customerId: _customer.id,
//               dressType: 'Waistcoat',
//               values: const <String, String>{
//                 'Collar': '15.5',
//                 'Shoulder': '17.5',
//                 'Chest': '42',
//                 'Waist': '39',
//                 'Length': '27',
//                 'Hip': '41',
//               },
//               notes: 'Close fitting waistcoat for formal events.',
//               updatedAt: DateTime(2026, 7, 15),
//             ),
//           ],
//         );
//       }
//     }
//   }
//
//   List<CustomerMeasurementRecord> get _latestDressMeasurements {
//     final Map<String, CustomerMeasurementRecord> latestByDress =
//     <String, CustomerMeasurementRecord>{};
//
//     for (final CustomerMeasurementRecord record in _measurementHistory) {
//       final String key = record.dressType.trim().toLowerCase();
//       final CustomerMeasurementRecord? current = latestByDress[key];
//
//       if (current == null || record.updatedAt.isAfter(current.updatedAt)) {
//         latestByDress[key] = record;
//       }
//     }
//
//     final List<CustomerMeasurementRecord> result =
//     latestByDress.values.toList()
//       ..sort(
//             (CustomerMeasurementRecord a, CustomerMeasurementRecord b) =>
//             b.updatedAt.compareTo(a.updatedAt),
//       );
//
//     return result;
//   }
//
//   Set<String> get _savedDressTypeKeys {
//     return _measurementHistory
//         .map(
//           (CustomerMeasurementRecord record) =>
//           record.dressType.trim().toLowerCase(),
//     )
//         .where((String value) => value.isNotEmpty)
//         .toSet();
//   }
//
//
//
//   Future<void> _openEditCustomer() async {
//     if (widget.onEditCustomer != null) {
//       widget.onEditCustomer!.call();
//       return;
//     }
//
//     final EditedCustomerData? result =
//     await Navigator.of(context).push<EditedCustomerData>(
//       MaterialPageRoute<EditedCustomerData>(
//         builder: (BuildContext context) {
//           return EditCustomerScreen(
//             customerId: _customer.id,
//             customerCode: _customer.customerCode,
//             name: _customer.name,
//             phone: _customer.phone,
//             category: _customer.category,
//             photoUrl: _customer.photoUrl,
//             address: _customer.address,
//             notes: _customer.notes,
//           );
//         },
//       ),
//     );
//
//     if (result == null || !mounted) {
//       return;
//     }
//
//     setState(() {
//       _currentCustomer = _customer.copyWith(
//         name: result.name,
//         phone: result.phone,
//         category: result.category,
//         photoUrl: result.photoUrl,
//         address: result.address,
//         notes: result.notes,
//       );
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: AppColors.success,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(14),
//         ),
//         content: const Text(
//           'Customer details updated successfully.',
//           style: TextStyle(
//             color: AppColors.whiteText,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _openAddToOrder({
//     required CustomerMeasurementRecord savedMeasurements,
//   }) async {
//     if (widget.onUseLatestMeasurements != null) {
//       widget.onUseLatestMeasurements!.call(savedMeasurements);
//       return;
//     }
//
//     final SavedMeasurementOrderData? result =
//     await Navigator.of(context).push<SavedMeasurementOrderData>(
//       MaterialPageRoute<SavedMeasurementOrderData>(
//         builder: (BuildContext context) {
//           return AddSavedMeasurementOrderScreen(
//             customerId: _customer.id,
//             customerName: _customer.name,
//             customerCode: _customer.customerCode,
//             customerCategory: _customer.category,
//             customerPhone: _customer.phone,
//             dressType: savedMeasurements.dressType,
//             measurements:
//             Map<String, String>.from(savedMeasurements.values),
//             measurementRecordId: savedMeasurements.id,
//             measurementNotes: savedMeasurements.notes,
//           );
//         },
//       ),
//     );
//
//     if (result == null || !mounted) {
//       return;
//     }
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: AppColors.success,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(14),
//         ),
//         content: Text(
//           '${result.dressType} added to orders successfully.',
//           style: const TextStyle(
//             color: AppColors.whiteText,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _showMeasurementEditor({
//     CustomerMeasurementRecord? existing,
//   }) async {
//     if (existing == null) {
//       final List<String> availableDresses =
//       _MeasurementEditorSheet.availableDressesForCategory(
//         _customer.category,
//       ).where((String dress) {
//         return !_savedDressTypeKeys.contains(
//           dress.trim().toLowerCase(),
//         );
//       }).toList();
//
//       if (availableDresses.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             behavior: SnackBarBehavior.floating,
//             backgroundColor: AppColors.primaryDark,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(14),
//             ),
//             content: const Text(
//               'All available dress types are already saved for this customer.',
//               style: TextStyle(
//                 color: AppColors.whiteText,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ),
//         );
//         return;
//       }
//     }
//
//     final CustomerMeasurementRecord? result =
//     await showModalBottomSheet<CustomerMeasurementRecord>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return _MeasurementEditorSheet(
//           customerId: _customer.id,
//           customerCategory: _customer.category,
//           existing: existing,
//           savedDressTypes: _savedDressTypeKeys,
//         );
//       },
//     );
//
//     if (result == null || !mounted) {
//       return;
//     }
//
//     setState(() {
//       _measurementHistory.add(result);
//     });
//
//     widget.onMeasurementsUpdated?.call(result);
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: AppColors.success,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(14),
//         ),
//         content: const Text(
//           'Latest measurements updated successfully.',
//           style: TextStyle(
//             color: AppColors.whiteText,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showLatestMeasurements(
//       CustomerMeasurementRecord record,
//       ) {
//     showModalBottomSheet<void>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return _SingleMeasurementViewSheet(record: record);
//       },
//     );
//   }
//
//   void _shareLatestMeasurements(
//       CustomerMeasurementRecord record,
//       ) {
//     if (widget.onShareLatestMeasurements != null) {
//       widget.onShareLatestMeasurements!.call(record);
//       return;
//     }
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(14),
//         ),
//         content: const Text(
//           'Measurement sharing will be connected to WhatsApp/PDF next.',
//         ),
//       ),
//     );
//   }
//
//   Future<void> _addNewDressMeasurement() async {
//     if (widget.onAddDressMeasurement != null) {
//       widget.onAddDressMeasurement!.call();
//       return;
//     }
//
//     await _showMeasurementEditor();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isDark = Theme.of(context).brightness == Brightness.dark;
//     final Color bg =
//     isDark ? AppColors.darkScaffold : AppColors.scaffold;
//     final Color surface =
//     isDark ? AppColors.darkSurface : AppColors.surface;
//     final Color border =
//     isDark ? AppColors.darkBorder : AppColors.border;
//     final Color primaryText =
//     isDark ? AppColors.darkText : AppColors.textPrimary;
//     final Color secondaryText =
//     isDark ? AppColors.grey400 : AppColors.textSecondary;
//     final List<CustomerMeasurementRecord> dressMeasurements =
//         _latestDressMeasurements;
//
//     return Scaffold(
//       backgroundColor: bg,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         foregroundColor: primaryText,
//         titleSpacing: 0,
//         title: Text(
//           'Customer Profile',
//           style: TextStyle(
//             color: primaryText,
//             fontSize: 18,
//             fontWeight: FontWeight.w900,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         top: false,
//         child: LayoutBuilder(
//           builder: (BuildContext context, BoxConstraints constraints) {
//             final double pagePadding =
//             ResponsiveLayout.horizontalPadding(constraints.maxWidth);
//             final double maxWidth =
//             ResponsiveLayout.contentMaxWidth(constraints.maxWidth);
//
//             return Align(
//               alignment: Alignment.topCenter,
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(maxWidth: maxWidth),
//                 child: ListView(
//                   physics: const BouncingScrollPhysics(),
//                   keyboardDismissBehavior:
//                   ScrollViewKeyboardDismissBehavior.onDrag,
//                   padding: EdgeInsets.fromLTRB(
//                     pagePadding,
//                     10,
//                     pagePadding,
//                     24,
//                   ),
//                   children: <Widget>[
//                     _CustomerCard(
//                       customer: _customer,
//                       isDark: isDark,
//                       surface: surface,
//                       border: border,
//                       primaryText: primaryText,
//                       secondaryText: secondaryText,
//                       onEdit: _openEditCustomer,
//                     ),
//                     const SizedBox(height: 20),
//                     _SectionTitle(
//                       title: 'Saved Dress Measurements',
//                       subtitle: dressMeasurements.isEmpty
//                           ? 'No dress measurements saved yet'
//                           : '${dressMeasurements.length} ${dressMeasurements.length == 1 ? 'dress' : 'dresses'} available',
//                       primaryText: primaryText,
//                       secondaryText: secondaryText,
//                       icon: Icons.straighten_rounded,
//                     ),
//                     const SizedBox(height: 12),
//                     if (dressMeasurements.isEmpty)
//                       _EmptyDressMeasurementsCard(
//                         surface: surface,
//                         border: border,
//                         primaryText: primaryText,
//                         secondaryText: secondaryText,
//                         onAdd: _addNewDressMeasurement,
//                       )
//                     else ...<Widget>[
//                       ...List<Widget>.generate(
//                         dressMeasurements.length,
//                             (int index) {
//                           final CustomerMeasurementRecord record =
//                           dressMeasurements[index];
//
//                           return Padding(
//                             padding: const EdgeInsets.only(bottom: 12),
//                             child: _AnimatedDressMeasurementCard(
//                               index: index,
//                               child: _DressMeasurementCard(
//                                 record: record,
//                                 isDark: isDark,
//                                 surface: surface,
//                                 border: border,
//                                 primaryText: primaryText,
//                                 secondaryText: secondaryText,
//                                 onView: () => _showLatestMeasurements(record),
//                                 onUpdate: () =>
//                                     _showMeasurementEditor(existing: record),
//                                 onShare: () =>
//                                     _shareLatestMeasurements(record),
//                                 onAddToOrder: () =>
//                                     _openAddToOrder(savedMeasurements: record),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                       const SizedBox(height: 2),
//                       _AddAnotherDressButton(
//                         onPressed: _addNewDressMeasurement,
//                       ),
//                     ],
//                     const SizedBox(height: 18),
//                     _ProfileInfoNote(
//                       isDark: isDark,
//                       primaryText: primaryText,
//                       secondaryText: secondaryText,
//                       border: border,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class _AnimatedDressMeasurementCard extends StatelessWidget {
//   const _AnimatedDressMeasurementCard({
//     required this.index,
//     required this.child,
//   });
//
//   final int index;
//   final Widget child;
//
//   @override
//   Widget build(BuildContext context) {
//     return TweenAnimationBuilder<double>(
//       duration: Duration(milliseconds: 420 + (index * 90)),
//       curve: Curves.easeOutCubic,
//       tween: Tween<double>(begin: 0, end: 1),
//       builder: (
//           BuildContext context,
//           double value,
//           Widget? child,
//           ) {
//         return Opacity(
//           opacity: value,
//           child: Transform.translate(
//             offset: Offset(0, 22 * (1 - value)),
//             child: Transform.scale(
//               scale: 0.97 + (0.03 * value),
//               child: child,
//             ),
//           ),
//         );
//       },
//       child: child,
//     );
//   }
// }
//
// class _DressMeasurementCard extends StatelessWidget {
//   const _DressMeasurementCard({
//     required this.record,
//     required this.isDark,
//     required this.surface,
//     required this.border,
//     required this.primaryText,
//     required this.secondaryText,
//     required this.onView,
//     required this.onUpdate,
//     required this.onShare,
//     required this.onAddToOrder,
//   });
//
//   final CustomerMeasurementRecord record;
//   final bool isDark;
//   final Color surface;
//   final Color border;
//   final Color primaryText;
//   final Color secondaryText;
//   final VoidCallback onView;
//   final VoidCallback onUpdate;
//   final VoidCallback onShare;
//   final VoidCallback onAddToOrder;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: surface,
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: border),
//         boxShadow: <BoxShadow>[
//           BoxShadow(
//             color: Colors.black.withValues(alpha: isDark ? 0.16 : 0.055),
//             blurRadius: 24,
//             offset: const Offset(0, 11),
//           ),
//         ],
//       ),
//       child: Column(
//         children: <Widget>[
//           Row(
//             children: <Widget>[
//               Hero(
//                 tag: 'dress-${record.id}',
//                 child: Container(
//                   width: 52,
//                   height: 52,
//                   decoration: BoxDecoration(
//                     gradient: AppColors.primaryGradient,
//                     borderRadius: BorderRadius.circular(17),
//                     boxShadow: <BoxShadow>[
//                       BoxShadow(
//                         color: AppColors.primary.withValues(alpha: 0.22),
//                         blurRadius: 14,
//                         offset: const Offset(0, 7),
//                       ),
//                     ],
//                   ),
//                   child: const Icon(
//                     Icons.checkroom_rounded,
//                     color: AppColors.whiteText,
//                     size: 25,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       record.dressType,
//                       style: TextStyle(
//                         color: primaryText,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w900,
//                       ),
//                     ),
//                     const SizedBox(height: 3),
//                     Text(
//                       'Saved ${record.updatedDateLabel}',
//                       style: TextStyle(
//                         color: secondaryText,
//                         fontSize: 9,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: AppColors.success.withValues(alpha: 0.13),
//                   borderRadius: BorderRadius.circular(999),
//                 ),
//                 child: const Text(
//                   'SAVED',
//                   style: TextStyle(
//                     color: AppColors.success,
//                     fontSize: 8,
//                     fontWeight: FontWeight.w900,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 280),
//             width: double.infinity,
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color:
//               isDark ? AppColors.darkSurfaceSoft : AppColors.surfaceSoft,
//               borderRadius: BorderRadius.circular(18),
//             ),
//             child: Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: record.values.entries.take(6).map(
//                     (MapEntry<String, String> entry) {
//                   return _MeasurementValueChip(
//                     label: entry.key,
//                     value: entry.value,
//                     primaryText: primaryText,
//                     secondaryText: secondaryText,
//                     border: border,
//                     isDark: isDark,
//                   );
//                 },
//               ).toList(),
//             ),
//           ),
//           const SizedBox(height: 15),
//           LayoutBuilder(
//             builder: (BuildContext context, BoxConstraints constraints) {
//               final bool compact = constraints.maxWidth < 560;
//               final int columns = compact ? 2 : 4;
//               const double gap = 8;
//               final double buttonWidth =
//                   (constraints.maxWidth - (gap * (columns - 1))) / columns;
//
//               Widget action({
//                 required IconData icon,
//                 required String label,
//                 required VoidCallback onPressed,
//                 required Color background,
//                 required Color foreground,
//                 required Color borderColor,
//                 bool elevated = false,
//               }) {
//                 return SizedBox(
//                   width: buttonWidth,
//                   child: _PremiumActionButton(
//                     icon: icon,
//                     label: label,
//                     onPressed: onPressed,
//                     background: background,
//                     foreground: foreground,
//                     borderColor: borderColor,
//                     elevated: elevated,
//                   ),
//                 );
//               }
//
//               return Wrap(
//                 spacing: gap,
//                 runSpacing: gap,
//                 children: <Widget>[
//                   action(
//                     icon: Icons.visibility_rounded,
//                     label: 'View',
//                     onPressed: onView,
//                     background: AppColors.info.withValues(alpha: 0.13),
//                     foreground: AppColors.info,
//                     borderColor: AppColors.info.withValues(alpha: 0.32),
//                   ),
//                   action(
//                     icon: Icons.edit_rounded,
//                     label: 'Update',
//                     onPressed: onUpdate,
//                     background: AppColors.success.withValues(alpha: 0.12),
//                     foreground: AppColors.success,
//                     borderColor: AppColors.success.withValues(alpha: 0.30),
//                   ),
//                   action(
//                     icon: Icons.share_rounded,
//                     label: 'Share',
//                     onPressed: onShare,
//                     background: isDark
//                         ? AppColors.darkSurfaceSoft
//                         : AppColors.grey50,
//                     foreground: primaryText,
//                     borderColor: border,
//                   ),
//                   action(
//                     icon: Icons.add_shopping_cart_rounded,
//                     label: 'Add To Order',
//                     onPressed: onAddToOrder,
//                     background: AppColors.secondary.withValues(alpha: 0.17),
//                     foreground: AppColors.secondaryDark,
//                     borderColor: AppColors.secondary.withValues(alpha: 0.48),
//                     elevated: true,
//                   ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _PremiumActionButton extends StatefulWidget {
//   const _PremiumActionButton({
//     required this.icon,
//     required this.label,
//     required this.onPressed,
//     required this.background,
//     required this.foreground,
//     required this.borderColor,
//     this.elevated = false,
//   });
//
//   final IconData icon;
//   final String label;
//   final VoidCallback onPressed;
//   final Color background;
//   final Color foreground;
//   final Color borderColor;
//   final bool elevated;
//
//   @override
//   State<_PremiumActionButton> createState() =>
//       _PremiumActionButtonState();
// }
//
// class _PremiumActionButtonState extends State<_PremiumActionButton> {
//   bool _pressed = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedScale(
//       scale: _pressed ? 0.94 : 1,
//       duration: const Duration(milliseconds: 110),
//       curve: Curves.easeOut,
//       child: Material(
//         color: widget.background,
//         borderRadius: BorderRadius.circular(15),
//         child: InkWell(
//           onTap: widget.onPressed,
//           onTapDown: (_) => setState(() => _pressed = true),
//           onTapCancel: () => setState(() => _pressed = false),
//           onTapUp: (_) => setState(() => _pressed = false),
//           borderRadius: BorderRadius.circular(15),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 160),
//             height: 70,
//             padding: const EdgeInsets.symmetric(
//               horizontal: 4,
//               vertical: 8,
//             ),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15),
//               border: Border.all(color: widget.borderColor),
//               boxShadow: widget.elevated
//                   ? <BoxShadow>[
//                 BoxShadow(
//                   color: AppColors.secondary.withValues(alpha: 0.20),
//                   blurRadius: 13,
//                   offset: const Offset(0, 7),
//                 ),
//               ]
//                   : const <BoxShadow>[],
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Icon(
//                   widget.icon,
//                   color: widget.foreground,
//                   size: 18,
//                 ),
//                 const SizedBox(height: 5),
//                 FittedBox(
//                   fit: BoxFit.scaleDown,
//                   child: Text(
//                     widget.label,
//                     maxLines: 1,
//                     style: TextStyle(
//                       color: widget.foreground,
//                       fontSize: 8,
//                       fontWeight: FontWeight.w900,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _EmptyDressMeasurementsCard extends StatelessWidget {
//   const _EmptyDressMeasurementsCard({
//     required this.surface,
//     required this.border,
//     required this.primaryText,
//     required this.secondaryText,
//     required this.onAdd,
//   });
//
//   final Color surface;
//   final Color border;
//   final Color primaryText;
//   final Color secondaryText;
//   final VoidCallback onAdd;
//
//   @override
//   Widget build(BuildContext context) {
//     return TweenAnimationBuilder<double>(
//       duration: const Duration(milliseconds: 450),
//       curve: Curves.easeOutCubic,
//       tween: Tween<double>(begin: 0, end: 1),
//       builder: (
//           BuildContext context,
//           double value,
//           Widget? child,
//           ) {
//         return Opacity(
//           opacity: value,
//           child: Transform.translate(
//             offset: Offset(0, 18 * (1 - value)),
//             child: child,
//           ),
//         );
//       },
//       child: Container(
//         padding: const EdgeInsets.all(22),
//         decoration: BoxDecoration(
//           color: surface,
//           borderRadius: BorderRadius.circular(24),
//           border: Border.all(color: border),
//         ),
//         child: Column(
//           children: <Widget>[
//             Container(
//               width: 66,
//               height: 66,
//               decoration: BoxDecoration(
//                 gradient: AppColors.primaryGradient,
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.checkroom_rounded,
//                 color: AppColors.whiteText,
//                 size: 30,
//               ),
//             ),
//             const SizedBox(height: 14),
//             Text(
//               'No Dress Measurements Saved',
//               style: TextStyle(
//                 color: primaryText,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w900,
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               'Add the customer’s first dress measurements. Every dress will keep its own permanent record.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: secondaryText,
//                 fontSize: 10,
//                 height: 1.45,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               child: FilledButton.icon(
//                 onPressed: onAdd,
//                 icon: const Icon(Icons.add_rounded, size: 18),
//                 label: const Text('Add Dress Measurements'),
//                 style: FilledButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   foregroundColor: AppColors.whiteText,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   textStyle: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w900,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _AddAnotherDressButton extends StatelessWidget {
//   const _AddAnotherDressButton({required this.onPressed});
//
//   final VoidCallback onPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: OutlinedButton.icon(
//         onPressed: onPressed,
//         icon: const Icon(Icons.add_rounded, size: 18),
//         label: const Text('Add Another Dress'),
//         style: OutlinedButton.styleFrom(
//           foregroundColor: AppColors.primary,
//           side: BorderSide(
//             color: AppColors.primary.withValues(alpha: 0.34),
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           textStyle: const TextStyle(
//             fontSize: 11,
//             fontWeight: FontWeight.w900,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// class _ProfileInfoNote extends StatelessWidget {
//   const _ProfileInfoNote({
//     required this.isDark,
//     required this.primaryText,
//     required this.secondaryText,
//     required this.border,
//   });
//
//   final bool isDark;
//   final Color primaryText;
//   final Color secondaryText;
//   final Color border;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: isDark ? AppColors.darkSurface : AppColors.surface,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: border),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Container(
//             width: 38,
//             height: 38,
//             decoration: BoxDecoration(
//               color: AppColors.info.withValues(alpha: 0.12),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(
//               Icons.info_outline_rounded,
//               color: AppColors.info,
//               size: 19,
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   'How Add To Order works',
//                   style: TextStyle(
//                     color: primaryText,
//                     fontSize: 11,
//                     fontWeight: FontWeight.w900,
//                   ),
//                 ),
//                 const SizedBox(height: 3),
//                 Text(
//                   'Add To Order sends only the selected dress and its saved measurements to the order setup screen. The tailor then sets delivery date, total payment, advance and notes. After saving, the order appears in Dashboard Orders.',
//                   style: TextStyle(
//                     color: secondaryText,
//                     fontSize: 9,
//                     height: 1.45,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _SingleMeasurementViewSheet extends StatelessWidget {
//   const _SingleMeasurementViewSheet({required this.record});
//
//   final CustomerMeasurementRecord record;
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isDark = Theme.of(context).brightness == Brightness.dark;
//     final Color surface =
//     isDark ? AppColors.darkSurface : AppColors.surface;
//     final Color soft =
//     isDark ? AppColors.darkSurfaceSoft : AppColors.surfaceSoft;
//     final Color primaryText =
//     isDark ? AppColors.darkText : AppColors.textPrimary;
//     final Color secondaryText =
//     isDark ? AppColors.grey400 : AppColors.textSecondary;
//     final Color border =
//     isDark ? AppColors.darkBorder : AppColors.border;
//
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: ConstrainedBox(
//         constraints: const BoxConstraints(maxWidth: 720),
//         child: Container(
//           constraints: BoxConstraints(
//             maxHeight: MediaQuery.sizeOf(context).height * 0.84,
//           ),
//           decoration: BoxDecoration(
//             color: surface,
//             borderRadius: const BorderRadius.vertical(
//               top: Radius.circular(28),
//             ),
//           ),
//           child: SafeArea(
//             top: false,
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(16, 11, 16, 22),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Container(
//                     width: 44,
//                     height: 5,
//                     decoration: BoxDecoration(
//                       color: border,
//                       borderRadius: BorderRadius.circular(999),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: <Widget>[
//                       Container(
//                         width: 46,
//                         height: 46,
//                         decoration: BoxDecoration(
//                           gradient: AppColors.primaryGradient,
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: const Icon(
//                           Icons.straighten_rounded,
//                           color: AppColors.whiteText,
//                         ),
//                       ),
//                       const SizedBox(width: 11),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Text(
//                               record.dressType,
//                               style: TextStyle(
//                                 color: primaryText,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w900,
//                               ),
//                             ),
//                             Text(
//                               'Updated ${record.updatedDateLabel}',
//                               style: TextStyle(
//                                 color: secondaryText,
//                                 fontSize: 9,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Flexible(
//                     child: ListView(
//                       shrinkWrap: true,
//                       physics: const BouncingScrollPhysics(),
//                       children: <Widget>[
//                         ...record.values.entries.map(
//                               (MapEntry<String, String> entry) {
//                             return Container(
//                               margin: const EdgeInsets.only(bottom: 9),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 13,
//                                 vertical: 12,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: soft,
//                                 borderRadius: BorderRadius.circular(14),
//                               ),
//                               child: Row(
//                                 children: <Widget>[
//                                   Expanded(
//                                     child: Text(
//                                       entry.key,
//                                       style: TextStyle(
//                                         color: secondaryText,
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                   ),
//                                   Text(
//                                     entry.value,
//                                     style: TextStyle(
//                                       color: primaryText,
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w900,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                         if (record.designDetails.isNotEmpty) ...<Widget>[
//                           const SizedBox(height: 8),
//                           Text(
//                             'Design Details',
//                             style: TextStyle(
//                               color: primaryText,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w900,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           ...record.designDetails.entries.map(
//                                 (MapEntry<String, String> entry) {
//                               return Container(
//                                 margin: const EdgeInsets.only(bottom: 9),
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 13,
//                                   vertical: 12,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: AppColors.primary
//                                       .withValues(alpha: 0.08),
//                                   borderRadius: BorderRadius.circular(14),
//                                 ),
//                                 child: Row(
//                                   children: <Widget>[
//                                     Expanded(
//                                       child: Text(
//                                         entry.key,
//                                         style: TextStyle(
//                                           color: secondaryText,
//                                           fontSize: 10,
//                                           fontWeight: FontWeight.w700,
//                                         ),
//                                       ),
//                                     ),
//                                     Flexible(
//                                       child: Text(
//                                         entry.value,
//                                         textAlign: TextAlign.end,
//                                         style: TextStyle(
//                                           color: primaryText,
//                                           fontSize: 10,
//                                           fontWeight: FontWeight.w900,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                         if (record.notes.trim().isNotEmpty)
//                           Container(
//                             margin: const EdgeInsets.only(top: 4),
//                             padding: const EdgeInsets.all(13),
//                             decoration: BoxDecoration(
//                               color: AppColors.warning.withValues(alpha: 0.10),
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                             child: Text(
//                               record.notes,
//                               style: TextStyle(
//                                 color: primaryText,
//                                 fontSize: 10,
//                                 height: 1.45,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _MeasurementValueChip extends StatelessWidget {
//   const _MeasurementValueChip({
//     required this.label,
//     required this.value,
//     required this.primaryText,
//     required this.secondaryText,
//     required this.border,
//     required this.isDark,
//   });
//
//   final String label;
//   final String value;
//   final Color primaryText;
//   final Color secondaryText;
//   final Color border;
//   final bool isDark;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: const BoxConstraints(minWidth: 92),
//       padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
//       decoration: BoxDecoration(
//         color: isDark ? AppColors.darkSurface : AppColors.surface,
//         borderRadius: BorderRadius.circular(13),
//         border: Border.all(color: border),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             label,
//             style: TextStyle(
//               color: secondaryText,
//               fontSize: 8,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const SizedBox(height: 2),
//           Text(
//             value,
//             style: TextStyle(
//               color: primaryText,
//               fontSize: 11,
//               fontWeight: FontWeight.w900,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _MeasurementEditorSheet extends StatefulWidget {
//   const _MeasurementEditorSheet({
//     required this.customerId,
//     required this.customerCategory,
//     required this.savedDressTypes,
//     this.existing,
//   });
//
//   final String customerId;
//   final String customerCategory;
//   final Set<String> savedDressTypes;
//   final CustomerMeasurementRecord? existing;
//
//   static List<String> availableDressesForCategory(String customerCategory) {
//     final String category = customerCategory.trim().toLowerCase();
//
//     if (category.contains('lad')) {
//       return _MeasurementEditorSheetState._ladiesDresses;
//     }
//
//     if (category.contains('kid') ||
//         category.contains('child') ||
//         category.contains('boy') ||
//         category.contains('girl')) {
//       return _MeasurementEditorSheetState._kidsDresses;
//     }
//
//     return _MeasurementEditorSheetState._gentsDresses;
//   }
//
//   @override
//   State<_MeasurementEditorSheet> createState() =>
//       _MeasurementEditorSheetState();
// }
//
// class _MeasurementEditorSheetState extends State<_MeasurementEditorSheet> {
//   static const List<String> _gentsDresses = <String>[
//     'Shalwar Kameez',
//     'Kurta',
//     'Pant / Trouser',
//     'Dress Shirt',
//     'T-Shirt / Polo Shirt',
//     'Sherwani',
//     'Waistcoat',
//     'Suit / Blazer',
//   ];
//
//   static const List<String> _ladiesDresses = <String>[
//     'Shalwar Kameez',
//     'Kurti',
//     'Frock',
//     'Maxi',
//     'Lehenga',
//     'Gown',
//     'Trouser',
//     'Blouse',
//   ];
//
//   static const List<String> _kidsDresses = <String>[
//     'Boys Shalwar Kameez',
//     'Boys Kurta',
//     'Boys Waistcoat',
//     'Girls Frock',
//     'Girls Shalwar Kameez',
//     'Girls Maxi',
//     'New Born Suit',
//   ];
//
//   static const Map<String, List<String>> _gentsMeasurementFields =
//   <String, List<String>>{
//     'Shalwar Kameez': <String>[
//       'Length',
//       'Sleeve',
//       'Shoulder',
//       'Collar',
//       'Chest',
//       'Waist',
//       'Shalwar',
//       'Pancha',
//       'Cuff',
//       'Armhole',
//     ],
//     'Kurta': <String>[
//       'Length',
//       'Sleeve',
//       'Shoulder',
//       'Collar',
//       'Chest',
//       'Waist',
//       'Shalwar',
//       'Pancha',
//       'Cuff',
//       'Armhole',
//     ],
//     'Pant / Trouser': <String>[
//       'Waist (Round)',
//       'Hip (Round)',
//       'Thigh (Round)',
//       'Rise',
//       'Leg Opening (Round)',
//       'Outseam',
//       'Inseam',
//     ],
//     'Dress Shirt': <String>[
//       'Collar',
//       'Shoulder',
//       'Bust / Chest',
//       'Sleeve Length',
//       'Waist',
//       'Bottom Hem',
//       'Back Length',
//       'Front Length',
//       'Cuff',
//       'Armhole',
//     ],
//     'T-Shirt / Polo Shirt': <String>[
//       'Shoulder',
//       'Collar',
//       'Chest',
//       'Sleeve',
//       'Cuff',
//       'Length',
//       'Hem',
//       'Armhole',
//     ],
//     'Sherwani': <String>[
//       'Shoulder',
//       'Neck Collar',
//       'Sleeve',
//       'Chest',
//       'Waist',
//       'Length',
//       'Bottom Length',
//       'Armhole',
//     ],
//     'Waistcoat': <String>[
//       'Collar',
//       'Shoulder',
//       'Chest',
//       'Waist',
//       'Length',
//       'Hip',
//     ],
//     'Suit / Blazer': <String>[
//       'Jacket Length',
//       'Shoulder',
//       'Chest',
//       'Waist',
//       'Hip',
//       'Sleeve',
//       'Armhole',
//     ],
//   };
//
//   // Temporary Ladies fields.
//   // These stay separate and will be replaced when you provide Ladies forms.
//   static const Map<String, List<String>> _ladiesMeasurementFields =
//   <String, List<String>>{
//     'Shalwar Kameez': <String>[
//       'Shirt Length',
//       'Chest',
//       'Waist',
//       'Hip',
//       'Shoulder',
//       'Sleeve',
//       'Armhole',
//       'Neck Width',
//       'Front Neck',
//       'Back Neck',
//       'Trouser Length',
//       'Trouser Waist',
//       'Bottom',
//     ],
//     'Kurti': <String>[
//       'Kurti Length',
//       'Chest',
//       'Waist',
//       'Hip',
//       'Shoulder',
//       'Sleeve',
//       'Armhole',
//       'Neck Width',
//       'Front Neck',
//       'Back Neck',
//       'Cuff',
//     ],
//     'Frock': <String>[
//       'Frock Length',
//       'Chest',
//       'Waist',
//       'Hip',
//       'Shoulder',
//       'Sleeve',
//       'Armhole',
//       'Upper Body Length',
//       'Flare',
//     ],
//     'Maxi': <String>[
//       'Maxi Length',
//       'Chest',
//       'Waist',
//       'Hip',
//       'Shoulder',
//       'Sleeve',
//       'Armhole',
//       'Upper Body Length',
//       'Flare',
//     ],
//     'Lehenga': <String>[
//       'Blouse Length',
//       'Chest',
//       'Waist',
//       'Shoulder',
//       'Sleeve',
//       'Armhole',
//       'Lehenga Length',
//       'Lehenga Waist',
//       'Hip',
//       'Flare',
//     ],
//     'Gown': <String>[
//       'Gown Length',
//       'Chest',
//       'Waist',
//       'Hip',
//       'Shoulder',
//       'Sleeve',
//       'Armhole',
//       'Upper Body Length',
//       'Flare',
//     ],
//     'Trouser': <String>[
//       'Length',
//       'Waist',
//       'Hip',
//       'Thigh',
//       'Knee',
//       'Bottom',
//       'Rise',
//       'Inseam',
//     ],
//     'Blouse': <String>[
//       'Blouse Length',
//       'Chest',
//       'Waist',
//       'Shoulder',
//       'Sleeve',
//       'Armhole',
//       'Front Neck',
//       'Back Neck',
//     ],
//   };
//
//   // Temporary Kids fields.
//   // These stay separate and will be replaced when you provide Kids forms.
//   static const Map<String, List<String>> _kidsMeasurementFields =
//   <String, List<String>>{
//     'Boys Shalwar Kameez': <String>[
//       'Shirt Length',
//       'Chest',
//       'Waist',
//       'Shoulder',
//       'Sleeve',
//       'Collar',
//       'Cuff',
//       'Shalwar Length',
//       'Shalwar Waist',
//       'Bottom',
//     ],
//     'Boys Kurta': <String>[
//       'Kurta Length',
//       'Chest',
//       'Waist',
//       'Shoulder',
//       'Sleeve',
//       'Collar',
//       'Cuff',
//     ],
//     'Boys Waistcoat': <String>[
//       'Length',
//       'Chest',
//       'Waist',
//       'Shoulder',
//       'Armhole',
//       'Front Neck',
//       'Back Neck',
//     ],
//     'Girls Frock': <String>[
//       'Frock Length',
//       'Chest',
//       'Waist',
//       'Shoulder',
//       'Sleeve',
//       'Armhole',
//       'Upper Body Length',
//       'Flare',
//     ],
//     'Girls Shalwar Kameez': <String>[
//       'Shirt Length',
//       'Chest',
//       'Waist',
//       'Hip',
//       'Shoulder',
//       'Sleeve',
//       'Armhole',
//       'Shalwar Length',
//       'Shalwar Waist',
//       'Bottom',
//     ],
//     'Girls Maxi': <String>[
//       'Maxi Length',
//       'Chest',
//       'Waist',
//       'Hip',
//       'Shoulder',
//       'Sleeve',
//       'Armhole',
//       'Upper Body Length',
//       'Flare',
//     ],
//     'New Born Suit': <String>[
//       'Top Length',
//       'Chest',
//       'Shoulder',
//       'Sleeve',
//       'Trouser Length',
//       'Waist',
//       'Bottom',
//     ],
//   };
//
//   Map<String, List<String>> get _activeMeasurementMap {
//     final String category = widget.customerCategory.trim().toLowerCase();
//
//     if (category.contains('lad')) {
//       return _ladiesMeasurementFields;
//     }
//
//     if (category.contains('kid') ||
//         category.contains('child') ||
//         category.contains('boy') ||
//         category.contains('girl')) {
//       return _kidsMeasurementFields;
//     }
//
//     return _gentsMeasurementFields;
//   }
//
//   static const List<String> _fallbackFields = <String>[
//     'Length',
//     'Chest',
//     'Waist',
//     'Hip',
//     'Shoulder',
//     'Sleeve',
//   ];
//
//   static const Map<String, Map<String, List<String>>>
//   _dressDesignOptions =
//   <String, Map<String, List<String>>>{
//     'Shalwar Kameez': <String, List<String>>{
//       'Side Pocket': <String>[
//         'One Side Pocket',
//         'Double Side Pocket',
//         'No Side Pockets',
//       ],
//       'Front Pocket': <String>['Yes', 'No'],
//       'Collar Style': <String>['Bag', 'Small'],
//       'Daman Style': <String>['Straight Daman', 'Rounded'],
//       'Salahi': <String>['Double Salahi', 'Single Salahi'],
//       'Chamak': <String>[
//         'Single Chamak Patti',
//         'Double Chamak Patti',
//       ],
//     },
//     'Kurta': <String, List<String>>{
//       'Side Pocket': <String>[
//         'One Side Pocket',
//         'Double Side Pocket',
//         'No Side Pockets',
//       ],
//       'Front Pocket': <String>['Yes', 'No'],
//       'Collar Style': <String>['Bag', 'Small'],
//       'Daman Style': <String>['Straight Daman', 'Rounded'],
//       'Salahi': <String>['Double Salahi', 'Single Salahi'],
//       'Chamak': <String>[
//         'Single Chamak Patti',
//         'Double Chamak Patti',
//       ],
//     },
//     'Dress Shirt': <String, List<String>>{
//       'Front Pocket': <String>['Yes', 'No'],
//     },
//   };
//
//   bool get _isGentsCategory {
//     final String category = widget.customerCategory.trim().toLowerCase();
//     return !category.contains('lad') &&
//         !category.contains('kid') &&
//         !category.contains('child') &&
//         !category.contains('boy') &&
//         !category.contains('girl');
//   }
//
//   Map<String, List<String>> get _currentDesignOptions {
//     if (!_isGentsCategory) {
//       return const <String, List<String>>{};
//     }
//
//     return _dressDesignOptions[_selectedDress] ??
//         const <String, List<String>>{};
//   }
//
//   List<String> get _currentMeasurementFields =>
//       _activeMeasurementMap[_selectedDress] ?? _fallbackFields;
//
//   List<String> get _availableDresses {
//     final List<String> allDresses =
//     _MeasurementEditorSheet.availableDressesForCategory(
//       widget.customerCategory,
//     );
//
//     final String existingDressKey =
//         widget.existing?.dressType.trim().toLowerCase() ?? '';
//
//     return allDresses.where((String dress) {
//       final String dressKey = dress.trim().toLowerCase();
//
//       // While updating, keep the currently selected dress available.
//       if (existingDressKey.isNotEmpty && dressKey == existingDressKey) {
//         return true;
//       }
//
//       // While adding a new dress, hide dresses already saved.
//       return !widget.savedDressTypes.contains(dressKey);
//     }).toList();
//   }
//
//   late String _selectedDress;
//   late final TextEditingController _notesController;
//   late Map<String, TextEditingController> _controllers;
//   late Map<String, String> _selectedDesignDetails;
//
//   String? _validationMessage;
//
//   @override
//   void initState() {
//     super.initState();
//
//     final List<String> dresses = _availableDresses;
//     final String existingDress = widget.existing?.dressType.trim() ?? '';
//
//     _selectedDress = existingDress.isNotEmpty
//         ? existingDress
//         : (dresses.isNotEmpty ? dresses.first : '');
//
//     _notesController = TextEditingController(
//       text: widget.existing?.notes ?? '',
//     );
//
//     final Set<String> fieldNames = <String>{
//       ..._currentMeasurementFields,
//       ...?widget.existing?.values.keys,
//     };
//
//     _controllers = <String, TextEditingController>{
//       for (final String field in fieldNames)
//         field: TextEditingController(
//           text: widget.existing?.values[field] ?? '',
//         ),
//     };
//
//     _selectedDesignDetails = <String, String>{
//       for (final MapEntry<String, List<String>> entry
//       in _currentDesignOptions.entries)
//         entry.key:
//         widget.existing?.designDetails[entry.key] ??
//             entry.value.first,
//     };
//   }
//
//   void _resetMeasurementControllersForDress(String dress) {
//     for (final TextEditingController controller in _controllers.values) {
//       controller.dispose();
//     }
//
//     _controllers = <String, TextEditingController>{
//       for (final String field
//       in (_activeMeasurementMap[dress] ?? _fallbackFields))
//         field: TextEditingController(),
//     };
//
//     _selectedDesignDetails = <String, String>{
//       for (final MapEntry<String, List<String>> entry
//       in (_dressDesignOptions[dress] ??
//           const <String, List<String>>{}).entries)
//         entry.key: entry.value.first,
//     };
//   }
//
//   @override
//   void dispose() {
//     _notesController.dispose();
//     for (final TextEditingController controller in _controllers.values) {
//       controller.dispose();
//     }
//     super.dispose();
//   }
//
//   void _save() {
//     final String dress = _selectedDress.trim();
//     final Map<String, String> values = <String, String>{
//       for (final MapEntry<String, TextEditingController> entry
//       in _controllers.entries)
//         if (entry.value.text.trim().isNotEmpty)
//           entry.key: entry.value.text.trim(),
//     };
//
//     if (dress.isEmpty) {
//       setState(() {
//         _validationMessage = 'Please select a dress type before saving.';
//       });
//       return;
//     }
//
//     if (values.isEmpty) {
//       setState(() {
//         _validationMessage =
//         'Please enter at least one measurement before saving.';
//       });
//       return;
//     }
//
//     setState(() {
//       _validationMessage = null;
//     });
//
//     Navigator.of(context).pop(
//       CustomerMeasurementRecord(
//         id: DateTime.now().microsecondsSinceEpoch.toString(),
//         customerId: widget.customerId,
//         dressType: dress,
//         values: values,
//         designDetails:
//         Map<String, String>.from(_selectedDesignDetails),
//         notes: _notesController.text.trim(),
//         updatedAt: DateTime.now(),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isDark = Theme.of(context).brightness == Brightness.dark;
//     final Color surface =
//     isDark ? AppColors.darkSurface : AppColors.surface;
//     final Color primaryText =
//     isDark ? AppColors.darkText : AppColors.textPrimary;
//     final Color secondaryText =
//     isDark ? AppColors.grey400 : AppColors.textSecondary;
//     final Color border =
//     isDark ? AppColors.darkBorder : AppColors.border;
//
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: ConstrainedBox(
//         constraints: const BoxConstraints(maxWidth: 860),
//         child: Container(
//           constraints: BoxConstraints(
//             maxHeight: MediaQuery.sizeOf(context).height * 0.92,
//           ),
//           decoration: BoxDecoration(
//             color: surface,
//             borderRadius: const BorderRadius.vertical(
//               top: Radius.circular(28),
//             ),
//           ),
//           child: SafeArea(
//             top: false,
//             child: Padding(
//               padding: EdgeInsets.only(
//                 left: 16,
//                 right: 16,
//                 top: 12,
//                 bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Container(
//                     width: 44,
//                     height: 5,
//                     decoration: BoxDecoration(
//                       color: border,
//                       borderRadius: BorderRadius.circular(999),
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   Row(
//                     children: <Widget>[
//                       Container(
//                         width: 44,
//                         height: 44,
//                         decoration: BoxDecoration(
//                           gradient: AppColors.primaryGradient,
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         child: const Icon(
//                           Icons.straighten_rounded,
//                           color: AppColors.whiteText,
//                         ),
//                       ),
//                       const SizedBox(width: 11),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Text(
//                               widget.existing == null
//                                   ? 'Add Measurements'
//                                   : 'Update Measurements',
//                               style: TextStyle(
//                                 color: primaryText,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w900,
//                               ),
//                             ),
//                             Text(
//                               'Old records will remain safe in history.',
//                               style: TextStyle(
//                                 color: secondaryText,
//                                 fontSize: 9,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           onTap: () => Navigator.of(context).pop(),
//                           borderRadius: BorderRadius.circular(14),
//                           splashColor: Colors.transparent,
//                           highlightColor: Colors.transparent,
//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               color: isDark
//                                   ? AppColors.darkSurfaceSoft
//                                   : AppColors.surfaceSoft,
//                               borderRadius: BorderRadius.circular(14),
//                               border: Border.all(color: border),
//                             ),
//                             child: Icon(
//                               Icons.close_rounded,
//                               color: secondaryText,
//                               size: 21,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Flexible(
//                     child: ListView(
//                       shrinkWrap: true,
//                       physics: const BouncingScrollPhysics(),
//                       children: <Widget>[
//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 10,
//                           ),
//                           decoration: BoxDecoration(
//                             color: AppColors.primary.withValues(alpha: 0.08),
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                           child: Row(
//                             children: <Widget>[
//                               const Icon(
//                                 Icons.category_rounded,
//                                 color: AppColors.primary,
//                                 size: 18,
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 'Customer Category: ${widget.customerCategory}',
//                                 style: TextStyle(
//                                   color: primaryText,
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w900,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         DropdownButtonFormField<String>(
//                           initialValue:
//                           _availableDresses.contains(_selectedDress)
//                               ? _selectedDress
//                               : null,
//                           isExpanded: true,
//                           decoration: InputDecoration(
//                             labelText: 'Dress Type',
//                             prefixIcon: const Icon(
//                               Icons.checkroom_rounded,
//                               color: AppColors.primary,
//                             ),
//                             filled: true,
//                             fillColor: isDark
//                                 ? AppColors.darkSurfaceSoft
//                                 : AppColors.surfaceSoft,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(15),
//                               borderSide: BorderSide(color: border),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(15),
//                               borderSide: BorderSide(color: border),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(15),
//                               borderSide: const BorderSide(
//                                 color: AppColors.primary,
//                                 width: 1.4,
//                               ),
//                             ),
//                           ),
//                           items: _availableDresses.map(
//                                 (String dress) {
//                               return DropdownMenuItem<String>(
//                                 value: dress,
//                                 child: Text(dress),
//                               );
//                             },
//                           ).toList(),
//                           onChanged: widget.existing != null
//                               ? null
//                               : (String? value) {
//                             if (value != null) {
//                               setState(() {
//                                 _selectedDress = value;
//                                 _resetMeasurementControllersForDress(value);
//                               });
//                             }
//                           },
//                         ),
//                         const SizedBox(height: 13),
//                         Text(
//                           'Measurements',
//                           style: TextStyle(
//                             color: primaryText,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w900,
//                           ),
//                         ),
//                         const SizedBox(height: 9),
//                         GridView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: _controllers.length,
//                           gridDelegate:
//                           const SliverGridDelegateWithMaxCrossAxisExtent(
//                             maxCrossAxisExtent: 360,
//                             mainAxisSpacing: 10,
//                             crossAxisSpacing: 10,
//                             childAspectRatio: 3.0,
//                           ),
//                           itemBuilder: (BuildContext context, int index) {
//                             final String key =
//                             _controllers.keys.elementAt(index);
//                             return _EditorTextField(
//                               controller: _controllers[key]!,
//                               label: key,
//                               hint: '0',
//                               keyboardType:
//                               const TextInputType.numberWithOptions(
//                                 decimal: true,
//                               ),
//                             );
//                           },
//                         ),
//                         if (_currentDesignOptions.isNotEmpty) ...<Widget>[
//                           const SizedBox(height: 18),
//                           Container(
//                             width: double.infinity,
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: isDark
//                                   ? AppColors.darkSurface
//                                   : AppColors.surface,
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(color: border),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Row(
//                                   children: <Widget>[
//                                     Container(
//                                       width: 42,
//                                       height: 42,
//                                       decoration: BoxDecoration(
//                                         gradient: AppColors.primaryGradient,
//                                         borderRadius: BorderRadius.circular(13),
//                                       ),
//                                       child: const Icon(
//                                         Icons.design_services_rounded,
//                                         color: AppColors.whiteText,
//                                         size: 21,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 11),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           Text(
//                                             'Design Details',
//                                             style: TextStyle(
//                                               color: primaryText,
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.w900,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 2),
//                                           Text(
//                                             'Select design preferences for $_selectedDress.',
//                                             style: TextStyle(
//                                               color: secondaryText,
//                                               fontSize: 9,
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 16),
//                                 ..._currentDesignOptions.entries.map(
//                                       (MapEntry<String, List<String>> entry) {
//                                     final String selected =
//                                         _selectedDesignDetails[entry.key] ??
//                                             entry.value.first;
//
//                                     return Padding(
//                                       padding:
//                                       const EdgeInsets.only(bottom: 15),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           Text(
//                                             entry.key,
//                                             style: TextStyle(
//                                               color: primaryText,
//                                               fontSize: 10,
//                                               fontWeight: FontWeight.w900,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 8),
//                                           Wrap(
//                                             spacing: 8,
//                                             runSpacing: 8,
//                                             children: entry.value.map(
//                                                   (String option) {
//                                                 final bool isSelected =
//                                                     selected == option;
//
//                                                 return InkWell(
//                                                   onTap: () {
//                                                     setState(() {
//                                                       _selectedDesignDetails[
//                                                       entry.key] = option;
//                                                     });
//                                                   },
//                                                   borderRadius:
//                                                   BorderRadius.circular(14),
//                                                   child: AnimatedContainer(
//                                                     duration: const Duration(
//                                                       milliseconds: 180,
//                                                     ),
//                                                     curve: Curves.easeOut,
//                                                     padding:
//                                                     const EdgeInsets.symmetric(
//                                                       horizontal: 12,
//                                                       vertical: 10,
//                                                     ),
//                                                     decoration: BoxDecoration(
//                                                       color: isSelected
//                                                           ? AppColors.primary
//                                                           .withValues(
//                                                         alpha: 0.14,
//                                                       )
//                                                           : (isDark
//                                                           ? AppColors
//                                                           .darkSurfaceSoft
//                                                           : AppColors
//                                                           .surfaceSoft),
//                                                       borderRadius:
//                                                       BorderRadius.circular(
//                                                         14,
//                                                       ),
//                                                       border: Border.all(
//                                                         color: isSelected
//                                                             ? AppColors.primary
//                                                             : border,
//                                                         width: isSelected
//                                                             ? 1.4
//                                                             : 1,
//                                                       ),
//                                                     ),
//                                                     child: Row(
//                                                       mainAxisSize:
//                                                       MainAxisSize.min,
//                                                       children: <Widget>[
//                                                         AnimatedContainer(
//                                                           duration:
//                                                           const Duration(
//                                                             milliseconds: 180,
//                                                           ),
//                                                           width: 16,
//                                                           height: 16,
//                                                           decoration:
//                                                           BoxDecoration(
//                                                             shape:
//                                                             BoxShape.circle,
//                                                             color: isSelected
//                                                                 ? AppColors.primary
//                                                                 : Colors
//                                                                 .transparent,
//                                                             border: Border.all(
//                                                               color: isSelected
//                                                                   ? AppColors
//                                                                   .primary
//                                                                   : secondaryText,
//                                                               width: 1.3,
//                                                             ),
//                                                           ),
//                                                           child: isSelected
//                                                               ? const Icon(
//                                                             Icons.check,
//                                                             size: 11,
//                                                             color: AppColors
//                                                                 .whiteText,
//                                                           )
//                                                               : null,
//                                                         ),
//                                                         const SizedBox(width: 7),
//                                                         Text(
//                                                           option,
//                                                           style: TextStyle(
//                                                             color: isSelected
//                                                                 ? AppColors.primary
//                                                                 : primaryText,
//                                                             fontSize: 9,
//                                                             fontWeight:
//                                                             FontWeight.w800,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                             ).toList(),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                         const SizedBox(height: 16),
//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: isDark
//                                 ? AppColors.darkSurface
//                                 : AppColors.surface,
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(color: border),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Row(
//                                 children: <Widget>[
//                                   Container(
//                                     width: 42,
//                                     height: 42,
//                                     decoration: BoxDecoration(
//                                       color: AppColors.secondary.withValues(
//                                         alpha: 0.16,
//                                       ),
//                                       borderRadius: BorderRadius.circular(13),
//                                     ),
//                                     child: const Icon(
//                                       Icons.edit_note_rounded,
//                                       color: AppColors.secondaryDark,
//                                       size: 22,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 11),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: <Widget>[
//                                         Text(
//                                           'Tailor Notes',
//                                           style: TextStyle(
//                                             color: primaryText,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w900,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 2),
//                                         Text(
//                                           'Optional notes for fitting, stitching or delivery.',
//                                           style: TextStyle(
//                                             color: secondaryText,
//                                             fontSize: 9,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 13),
//                               _EditorTextField(
//                                 controller: _notesController,
//                                 label: 'Notes',
//                                 hint:
//                                 'Write fitting, stitching or delivery notes...',
//                                 icon: Icons.notes_rounded,
//                                 maxLines: 4,
//                               ),
//                             ],
//                           ),
//                         ),
//
//
//                       ],
//                     ),
//                   ),
//                   AnimatedSize(
//                     duration: const Duration(milliseconds: 220),
//                     curve: Curves.easeOutCubic,
//                     child: _validationMessage == null
//                         ? const SizedBox.shrink()
//                         : Container(
//                       width: double.infinity,
//                       margin: const EdgeInsets.only(top: 12),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 13,
//                         vertical: 11,
//                       ),
//                       decoration: BoxDecoration(
//                         color: AppColors.error.withValues(
//                           alpha: isDark ? 0.16 : 0.10,
//                         ),
//                         borderRadius: BorderRadius.circular(14),
//                         border: Border.all(
//                           color: AppColors.error.withValues(alpha: 0.35),
//                         ),
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           const Icon(
//                             Icons.error_outline_rounded,
//                             color: AppColors.error,
//                             size: 19,
//                           ),
//                           const SizedBox(width: 9),
//                           Expanded(
//                             child: Text(
//                               _validationMessage!,
//                               style: TextStyle(
//                                 color: isDark
//                                     ? AppColors.grey100
//                                     : AppColors.textPrimary,
//                                 fontSize: 10,
//                                 height: 1.35,
//                                 fontWeight: FontWeight.w800,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   SizedBox(
//                     width: double.infinity,
//                     child: FilledButton.icon(
//                       onPressed: _save,
//                       icon: const Icon(Icons.save_rounded, size: 18),
//                       label: const Text('Save Measurements'),
//                       style: FilledButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         foregroundColor: AppColors.whiteText,
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         textStyle: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w900,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _EditorTextField extends StatelessWidget {
//   const _EditorTextField({
//     required this.controller,
//     required this.label,
//     required this.hint,
//     this.icon,
//     this.keyboardType,
//     this.maxLines = 1,
//   });
//
//   final TextEditingController controller;
//   final String label;
//   final String hint;
//   final IconData? icon;
//   final TextInputType? keyboardType;
//   final int maxLines;
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isDark = Theme.of(context).brightness == Brightness.dark;
//     final Color fill =
//     isDark ? AppColors.darkSurfaceSoft : AppColors.surfaceSoft;
//     final Color primaryText =
//     isDark ? AppColors.darkText : AppColors.textPrimary;
//     final Color border =
//     isDark ? AppColors.darkBorder : AppColors.border;
//
//     return TextField(
//       controller: controller,
//       keyboardType: keyboardType,
//       maxLines: maxLines,
//       style: TextStyle(
//         color: primaryText,
//         fontSize: 12,
//         fontWeight: FontWeight.w800,
//       ),
//       decoration: InputDecoration(
//         labelText: label,
//         hintText: hint,
//         prefixIcon:
//         icon == null ? null : Icon(icon, color: AppColors.primary),
//         filled: true,
//         fillColor: fill,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//           borderSide: BorderSide(color: border),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//           borderSide: BorderSide(color: border),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//           borderSide: const BorderSide(
//             color: AppColors.primary,
//             width: 1.4,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _MeasurementHistorySheet extends StatelessWidget {
//   const _MeasurementHistorySheet({
//     required this.records,
//     required this.onUseRecord,
//   });
//
//   final List<CustomerMeasurementRecord> records;
//   final ValueChanged<CustomerMeasurementRecord> onUseRecord;
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isDark = Theme.of(context).brightness == Brightness.dark;
//     final Color surface =
//     isDark ? AppColors.darkSurface : AppColors.surface;
//     final Color primaryText =
//     isDark ? AppColors.darkText : AppColors.textPrimary;
//     final Color secondaryText =
//     isDark ? AppColors.grey400 : AppColors.textSecondary;
//     final Color border =
//     isDark ? AppColors.darkBorder : AppColors.border;
//     final List<CustomerMeasurementRecord> sorted =
//     List<CustomerMeasurementRecord>.from(records)
//       ..sort(
//             (CustomerMeasurementRecord a, CustomerMeasurementRecord b) =>
//             b.updatedAt.compareTo(a.updatedAt),
//       );
//
//     return Container(
//       height: MediaQuery.sizeOf(context).height * 0.82,
//       decoration: BoxDecoration(
//         color: surface,
//         borderRadius: const BorderRadius.vertical(
//           top: Radius.circular(28),
//         ),
//       ),
//       child: SafeArea(
//         top: false,
//         child: Column(
//           children: <Widget>[
//             const SizedBox(height: 11),
//             Container(
//               width: 44,
//               height: 5,
//               decoration: BoxDecoration(
//                 color: border,
//                 borderRadius: BorderRadius.circular(999),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
//               child: Row(
//                 children: <Widget>[
//                   Container(
//                     width: 44,
//                     height: 44,
//                     decoration: BoxDecoration(
//                       gradient: AppColors.primaryGradient,
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     child: const Icon(
//                       Icons.history_rounded,
//                       color: AppColors.whiteText,
//                     ),
//                   ),
//                   const SizedBox(width: 11),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           'Measurement History',
//                           style: TextStyle(
//                             color: primaryText,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w900,
//                           ),
//                         ),
//                         Text(
//                           '${sorted.length} permanent records',
//                           style: TextStyle(
//                             color: secondaryText,
//                             fontSize: 9,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: ListView.separated(
//                 padding: const EdgeInsets.fromLTRB(16, 4, 16, 22),
//                 physics: const BouncingScrollPhysics(),
//                 itemCount: sorted.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: 11),
//                 itemBuilder: (BuildContext context, int index) {
//                   final CustomerMeasurementRecord record = sorted[index];
//
//                   return Container(
//                     padding: const EdgeInsets.all(14),
//                     decoration: BoxDecoration(
//                       color: isDark
//                           ? AppColors.darkSurfaceSoft
//                           : AppColors.surfaceSoft,
//                       borderRadius: BorderRadius.circular(18),
//                       border: Border.all(color: border),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Row(
//                           children: <Widget>[
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   Text(
//                                     record.dressType,
//                                     style: TextStyle(
//                                       color: primaryText,
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.w900,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 2),
//                                   Text(
//                                     record.updatedDateLabel,
//                                     style: TextStyle(
//                                       color: secondaryText,
//                                       fontSize: 9,
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             TextButton.icon(
//                               onPressed: () => onUseRecord(record),
//                               icon:
//                               const Icon(Icons.replay_rounded, size: 15),
//                               label: const Text('Use'),
//                               style: TextButton.styleFrom(
//                                 foregroundColor: AppColors.primary,
//                                 textStyle: const TextStyle(
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w900,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Wrap(
//                           spacing: 7,
//                           runSpacing: 7,
//                           children: record.values.entries.map(
//                                 (MapEntry<String, String> entry) {
//                               return Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 9,
//                                   vertical: 7,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: surface,
//                                   borderRadius: BorderRadius.circular(11),
//                                 ),
//                                 child: Text(
//                                   '${entry.key}: ${entry.value}',
//                                   style: TextStyle(
//                                     color: primaryText,
//                                     fontSize: 9,
//                                     fontWeight: FontWeight.w800,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ).toList(),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _CustomerCard extends StatelessWidget {
//   const _CustomerCard({
//     required this.customer,
//     required this.isDark,
//     required this.surface,
//     required this.border,
//     required this.primaryText,
//     required this.secondaryText,
//     required this.onEdit,
//   });
//
//   final CustomerProfileData customer;
//   final bool isDark;
//   final Color surface;
//   final Color border;
//   final Color primaryText;
//   final Color secondaryText;
//   final VoidCallback? onEdit;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: surface,
//         borderRadius: BorderRadius.circular(26),
//         border: Border.all(color: border),
//         boxShadow: <BoxShadow>[
//           BoxShadow(
//             color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.06),
//             blurRadius: 26,
//             offset: const Offset(0, 12),
//           ),
//         ],
//       ),
//       child: Column(
//         children: <Widget>[
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               _CustomerAvatar(photoUrl: customer.photoUrl, name: customer.name),
//               const SizedBox(width: 14),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       customer.name,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: primaryText,
//                         fontSize: 20,
//                         fontWeight: FontWeight.w900,
//                       ),
//                     ),
//                     const SizedBox(height: 7),
//                     Wrap(
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: <Widget>[
//                         _Chip(
//                           icon: Icons.badge_rounded,
//                           label: customer.customerCode,
//                           background: AppColors.primary.withValues(alpha: 0.11),
//                           foreground: AppColors.primary,
//                         ),
//                         _Chip(
//                           icon: Icons.category_rounded,
//                           label: customer.category,
//                           background: AppColors.secondary.withValues(alpha: 0.12),
//                           foreground: AppColors.secondaryDark,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 18),
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
//             decoration: BoxDecoration(
//               color: isDark ? AppColors.darkSurfaceSoft : AppColors.surfaceSoft,
//               borderRadius: BorderRadius.circular(18),
//             ),
//             child: Row(
//               children: <Widget>[
//                 Container(
//                   width: 38,
//                   height: 38,
//                   decoration: BoxDecoration(
//                     gradient: AppColors.primaryGradient,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(
//                     Icons.phone_rounded,
//                     color: AppColors.whiteText,
//                     size: 19,
//                   ),
//                 ),
//                 const SizedBox(width: 11),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         'Phone Number',
//                         style: TextStyle(
//                           color: secondaryText,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         customer.phone,
//                         style: TextStyle(
//                           color: primaryText,
//                           fontSize: 13,
//                           fontWeight: FontWeight.w900,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 14),
//           SizedBox(
//             width: double.infinity,
//             child: OutlinedButton.icon(
//               onPressed: onEdit,
//               icon: const Icon(Icons.edit_rounded, size: 18),
//               label: const Text('Edit Customer'),
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: AppColors.primary,
//                 side: BorderSide(color: AppColors.primary.withValues(alpha: 0.34)),
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 textStyle: const TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _CustomerAvatar extends StatelessWidget {
//   const _CustomerAvatar({required this.photoUrl, required this.name});
//
//   final String? photoUrl;
//   final String name;
//
//   Widget _buildCustomerImage(String initial) {
//     final String? path = photoUrl?.trim();
//
//     if (path == null || path.isEmpty) {
//       return _AvatarFallback(initial: initial);
//     }
//
//     final bool isNetworkImage =
//         path.startsWith('http://') || path.startsWith('https://');
//
//     if (isNetworkImage) {
//       return Image.network(
//         path,
//         fit: BoxFit.cover,
//         errorBuilder: (_, __, ___) {
//           return _AvatarFallback(initial: initial);
//         },
//       );
//     }
//
//     return Image.file(
//       File(path),
//       fit: BoxFit.cover,
//       errorBuilder: (_, __, ___) {
//         return _AvatarFallback(initial: initial);
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final String initial = name.trim().isEmpty ? 'C' : name.trim()[0].toUpperCase();
//
//     return Container(
//       width: 78,
//       height: 78,
//       padding: const EdgeInsets.all(3),
//       decoration: BoxDecoration(
//         gradient: AppColors.primaryGradient,
//         borderRadius: BorderRadius.circular(22),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(19),
//         child: _buildCustomerImage(initial),
//       ),
//     );
//   }
// }
//
// class _AvatarFallback extends StatelessWidget {
//   const _AvatarFallback({required this.initial});
//
//   final String initial;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppColors.primaryDark,
//       alignment: Alignment.center,
//       child: Text(
//         initial,
//         style: const TextStyle(
//           color: AppColors.whiteText,
//           fontSize: 28,
//           fontWeight: FontWeight.w900,
//         ),
//       ),
//     );
//   }
// }
//
// class _Chip extends StatelessWidget {
//   const _Chip({
//     required this.icon,
//     required this.label,
//     required this.background,
//     required this.foreground,
//   });
//
//   final IconData icon;
//   final String label;
//   final Color background;
//   final Color foreground;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
//       decoration: BoxDecoration(
//         color: background,
//         borderRadius: BorderRadius.circular(999),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Icon(icon, size: 14, color: foreground),
//           const SizedBox(width: 5),
//           Text(
//             label,
//             style: TextStyle(
//               color: foreground,
//               fontSize: 10,
//               fontWeight: FontWeight.w900,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _SectionTitle extends StatelessWidget {
//   const _SectionTitle({
//     required this.title,
//     required this.subtitle,
//     required this.primaryText,
//     required this.secondaryText,
//     this.icon = Icons.receipt_long_rounded,
//   });
//
//   final String title;
//   final String subtitle;
//   final Color primaryText;
//   final Color secondaryText;
//   final IconData icon;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         Container(
//           width: 42,
//           height: 42,
//           decoration: BoxDecoration(
//             gradient: AppColors.primaryGradient,
//             borderRadius: BorderRadius.circular(13),
//           ),
//           child: Icon(
//             icon,
//             color: AppColors.whiteText,
//             size: 21,
//           ),
//         ),
//         const SizedBox(width: 11),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 title,
//                 style: TextStyle(
//                   color: primaryText,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 subtitle,
//                 style: TextStyle(
//                   color: secondaryText,
//                   fontSize: 10,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class CustomerProfileData {
//   const CustomerProfileData({
//     required this.id,
//     required this.customerCode,
//     required this.name,
//     required this.phone,
//     required this.category,
//     this.photoUrl,
//     this.address = '',
//     this.notes = '',
//     this.measurementHistory = const <CustomerMeasurementRecord>[],
//   });
//
//   /// Ready-made customer used for UI testing when no customer is passed.
//   factory CustomerProfileData.demo() {
//     return CustomerProfileData(
//       id: 'customer-demo-001',
//       customerCode: 'TX-0001',
//       name: 'Ali Ahmed',
//       phone: '0300 1234567',
//       category: 'Gents',
//       measurementHistory: <CustomerMeasurementRecord>[
//         CustomerMeasurementRecord(
//           id: 'measurement-demo-sk-001',
//           customerId: 'customer-demo-001',
//           dressType: 'Shalwar Kameez',
//           values: <String, String>{
//             'Length': '43',
//             'Chest': '43',
//             'Waist': '44',
//             'Hip': '34',
//             'Shoulder': '18',
//             'Sleeve': '24',
//             'Collar': '15.5',
//             'Cuff': '9',
//           },
//           notes: 'Normal fitting. Keep the previous neck and shoulder fitting.',
//           updatedAt: DateTime(2026, 7, 24),
//         ),
//       ],
//     );
//   }
//
//   final String id;
//   final String customerCode;
//   final String name;
//   final String phone;
//   final String category;
//   final String? photoUrl;
//   final String address;
//   final String notes;
//
//   /// Permanent customer measurement records.
//   ///
//   /// The newest record becomes "Latest Measurements", while every older
//   /// record remains available in Measurement History.
//   final List<CustomerMeasurementRecord> measurementHistory;
//
//   CustomerProfileData copyWith({
//     String? id,
//     String? customerCode,
//     String? name,
//     String? phone,
//     String? category,
//     String? photoUrl,
//     String? address,
//     String? notes,
//     List<CustomerMeasurementRecord>? measurementHistory,
//   }) {
//     return CustomerProfileData(
//       id: id ?? this.id,
//       customerCode: customerCode ?? this.customerCode,
//       name: name ?? this.name,
//       phone: phone ?? this.phone,
//       category: category ?? this.category,
//       photoUrl: photoUrl ?? this.photoUrl,
//       address: address ?? this.address,
//       notes: notes ?? this.notes,
//       measurementHistory:
//       measurementHistory ?? this.measurementHistory,
//     );
//   }
// }
//
// class CustomerMeasurementRecord {
//   const CustomerMeasurementRecord({
//     required this.id,
//     required this.customerId,
//     required this.dressType,
//     required this.values,
//     required this.updatedAt,
//     this.designDetails = const <String, String>{},
//     this.notes = '',
//   });
//
//   final String id;
//   final String customerId;
//   final String dressType;
//   final Map<String, String> values;
//   final Map<String, String> designDetails;
//   final String notes;
//   final DateTime updatedAt;
//
//   String get updatedDateLabel {
//     const List<String> months = <String>[
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec',
//     ];
//
//     final String day = updatedAt.day.toString().padLeft(2, '0');
//     final String month = months[updatedAt.month - 1];
//
//     return '$day $month ${updatedAt.year}';
//   }
//
//   CustomerMeasurementRecord copyWith({
//     String? id,
//     String? customerId,
//     String? dressType,
//     Map<String, String>? values,
//     Map<String, String>? designDetails,
//     String? notes,
//     DateTime? updatedAt,
//   }) {
//     return CustomerMeasurementRecord(
//       id: id ?? this.id,
//       customerId: customerId ?? this.customerId,
//       dressType: dressType ?? this.dressType,
//       values: values ?? this.values,
//       designDetails: designDetails ?? this.designDetails,
//       notes: notes ?? this.notes,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }
// }
//
// class CustomerOrderSummary {
//   const CustomerOrderSummary({
//     required this.id,
//     required this.orderCode,
//     required this.dressName,
//     required this.orderDateLabel,
//     required this.deliveryDateLabel,
//     required this.status,
//     required this.totalAmount,
//     required this.remainingAmount,
//     this.paidAmount = 0,
//     this.isPreview = false,
//   });
//
//   factory CustomerOrderSummary.preview() {
//     return const CustomerOrderSummary(
//       id: 'preview-order',
//       orderCode: 'TX-1025',
//       dressName: 'Shalwar Kameez',
//       orderDateLabel: '24 Jul 2026',
//       deliveryDateLabel: '30 Jul 2026',
//       status: CustomerOrderStatus.inProgress,
//       totalAmount: 4500,
//       paidAmount: 2500,
//       remainingAmount: 2000,
//       isPreview: true,
//     );
//   }
//
//   final String id;
//   final String orderCode;
//   final String dressName;
//   final String orderDateLabel;
//   final String deliveryDateLabel;
//   final CustomerOrderStatus status;
//   final double totalAmount;
//   final double paidAmount;
//   final double remainingAmount;
//
//   /// True only for the temporary design card shown when there are no orders.
//   final bool isPreview;
// }
//
// enum CustomerOrderStatus {
//   pending,
//   inProgress,
//   ready,
//   delivered,
//   cancelled,
// }
//
// extension CustomerOrderStatusLabel on CustomerOrderStatus {
//   String get label {
//     switch (this) {
//       case CustomerOrderStatus.pending:
//         return 'Pending';
//       case CustomerOrderStatus.inProgress:
//         return 'In Progress';
//       case CustomerOrderStatus.ready:
//         return 'Ready';
//       case CustomerOrderStatus.delivered:
//         return 'Delivered';
//       case CustomerOrderStatus.cancelled:
//         return 'Cancelled';
//     }
//   }
// }
//
// class _StatusStyle {
//   const _StatusStyle({required this.background, required this.foreground});
//
//   final Color background;
//   final Color foreground;
// }
//
// _StatusStyle _statusStyleFor(CustomerOrderStatus status) {
//   switch (status) {
//     case CustomerOrderStatus.pending:
//       return _StatusStyle(
//         background: AppColors.warning.withValues(alpha: 0.14),
//         foreground: AppColors.secondaryDark,
//       );
//     case CustomerOrderStatus.inProgress:
//       return _StatusStyle(
//         background: AppColors.info.withValues(alpha: 0.13),
//         foreground: AppColors.info,
//       );
//     case CustomerOrderStatus.ready:
//       return _StatusStyle(
//         background: AppColors.primary.withValues(alpha: 0.12),
//         foreground: AppColors.primary,
//       );
//     case CustomerOrderStatus.delivered:
//       return _StatusStyle(
//         background: AppColors.success.withValues(alpha: 0.13),
//         foreground: AppColors.success,
//       );
//     case CustomerOrderStatus.cancelled:
//       return _StatusStyle(
//         background: AppColors.error.withValues(alpha: 0.12),
//         foreground: AppColors.error,
//       );
//   }
// }
