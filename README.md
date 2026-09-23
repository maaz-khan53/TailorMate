# TailorX — Flutter Tailoring Management App

## 1. Project Overview

TailorX is a Flutter-based tailoring management application designed to manage:

- Tailor/shop authentication
- Dashboard
- Customer profiles
- Customer categories
- Dress measurements
- Dress/design details
- Orders
- Order status
- Payments
- Customer profile editing
- Notifications
- Tailor/shop profile
- Backup & Restore UI
- Language selection UI
- Theme switching
- About / Logout / Menu screens

The current source package is primarily a **Flutter UI/prototype application**. The code contains demo data and callback hooks for future backend/database integration.

---

## 2. Important Architecture Note — Screen Code Organization

### Widgets are NOT separated into individual files for every screen.

The current project intentionally keeps most screen-specific UI widgets inside the same screen `.dart` file.

For example:

`customer_profile_screen.dart`

contains:

- `CustomerProfileScreen`
- screen state
- measurement UI
- dress cards
- measurement editor UI
- history UI
- detail rows
- buttons
- small/private helper widgets
- supporting UI classes used only by that screen

The same approach is used in many other screens.

This means a developer should **not assume that every private widget has its own Dart file**.

### Why this was done

The current project was built as a compact UI/prototype structure where each screen can be understood and modified from one main Dart file.

This is acceptable for the current prototype and makes screen-level editing easier.

### Existing reusable/shared widgets

Some genuinely reusable components are separate, for example:

- `core/widgets/premium_stepper.dart`
- `responsive_layout.dart`
- theme files
- color constants
- customer profile models
- order model

So the architecture is a **mixed approach**:

1. Screen-specific widgets → mostly inside the screen file
2. Shared/reusable components → separate files

---

# 3. Main Entry Point

## `main.dart`

Application starts from:

`TailorXApp`

Responsibilities:

- Initializes Flutter
- Loads TailorX theme
- Loads dark/light theme
- Uses `ThemeController`
- Opens `LoginScreen` as the initial screen
- Disables Flutter debug banner

Current home:

`LoginScreen`

---

# 4. Core System

## `core/constants/app_colors.dart`

Contains the central TailorX color system.

Used for:

- Primary colors
- Dark/light variations
- Gold/accent colors
- Text colors
- Borders
- Success/error states

The purpose is to keep the app's visual identity consistent.

---

## `core/theme/app_theme.dart`

Contains:

- Light theme
- Dark theme
- Text styling
- Input styling
- Button styling
- Card styling
- General Material theme configuration

---

## `core/theme/theme_controller.dart`

Controls the application's theme mode.

Used for:

- Light mode
- Dark mode
- System/theme state changes

`main.dart` listens to this controller through `AnimatedBuilder`.

---

## `core/widgets/premium_stepper.dart`

Reusable stepper widget.

This is one of the components that is intentionally separated because it can be reused outside a single screen.

---

# 5. Authentication Module

Location:

`features/auth/presentation/screens/`

## `login_screen.dart`

Login UI.

Includes:

- Login fields
- Authentication UI
- Validation/presentation
- Navigation toward the app

---

## `create_account_screen.dart`

Create-account UI.

Includes:

- Account fields
- User registration presentation
- Validation
- Account creation flow UI

---

## `forgot_password_screen.dart`

Forgot-password UI.

Includes:

- Email/recovery field
- Recovery interaction
- Success/error presentation

---

## `auth_ui.dart`

Contains reusable authentication UI components/classes used by authentication screens.

Examples include:

- Auth field
- Primary button
- Section heading
- Success card
- Auth page shell
- Auth visual components

---

# 6. Dashboard Module

Location:

`features/dashboard/presentation/screens/`

## `dashboard_screen.dart`

Main dashboard.

Contains UI for:

- Dashboard overview
- Customer summary
- Order summary
- Quick actions
- Recent/summary information
- Customer category presentation
- Responsive dashboard layout

Demo customer data is currently used for preview.

---

## `notifications_screen.dart`

Notifications screen.

Handles the notification UI and notification items.

---

# 7. Customer Management Module

Location:

`features/customers/presentation/screens/`

This is one of the main parts of TailorX.

---

## `add_customer_screen.dart`

Used to add a new customer.

Customer information includes UI for details such as:

- Name
- Phone
- Category
- Address
- Notes
- Photo/profile image
- Customer information

Image picker support is present through Flutter's image picker package.

---

## `edit_customer_screen.dart`

Used to edit an existing customer.

Allows customer information to be updated.

---

## `customer_type.dart`

Contains customer category/type definitions used by the customer module.

Main customer categories:

- Gents
- Ladies
- Kids

---

# 8. Customer Categories

## Gents

File:

`gents_customers_screen.dart`

Current demo customers include:

- Ali Ahmed
- Usman Tariq
- Hamza Khan

The screen provides:

- Customer list
- Search
- Customer cards
- Customer category
- Customer profile navigation
- Responsive layout

---

## Ladies

File:

`ladies_customers_screen.dart`

Current demo customers include:

- Ayesha Noor
- Sana Khan
- Fatima Ali

The screen provides:

- Customer list
- Search
- Customer cards
- Customer category
- Customer profile navigation
- Responsive layout

---

## Kids

File:

`kids_customers_screen.dart`

Current demo customers include:

- Ahmed Raza
- Zain Ali
- Hassan Noor

The screen provides:

- Customer list
- Search
- Customer cards
- Customer category
- Customer profile navigation
- Responsive layout

### Kids category rule

The app's current requirement is:

**Kids is one category with Boys and Girls dress types.**

New Born / Infants is NOT intended as a separate customer category.

Removed New Born/Infant dress group:

- Onesies / Bodysuits
- Baby Romper
- Jabla / Cloth Bib Set

---

## `total_customers_screen.dart`

Shows the combined customer list.

Current demo data includes customers from:

- Gents
- Ladies
- Kids

Provides:

- Search
- Customer cards
- Category information
- View/profile navigation
- Responsive grid/list behavior

---

# 9. Customer Profile Module

## `customer_profile_screen.dart`

This is one of the most important screens in the application.

It is responsible for displaying a customer's complete tailoring profile.

The screen supports:

- Customer information
- Customer category
- Customer photo
- Address
- Notes
- Dress measurement history
- Multiple dress types for one customer
- Latest measurement per dress
- Measurement editing
- Add new dress measurement
- Use measurements for an order
- Share measurement callback hooks
- Update measurement callback hooks
- Order history presentation
- Customer editing
- New order navigation

### Important demo behavior

If a demo customer does not already have measurement history, the screen creates preview/demo measurement records according to the customer's category.

Gents demo records include examples such as:

- Shalwar Kameez
- Dress Shirt
- Waistcoat

Ladies demo records include examples such as:

- Shalwar Kameez
- Kurti
- Frock

Kids demo records include examples such as:

- Boys Shalwar Kameez
- Boys Kurta
- Boys Waistcoat

### Measurements + Design

A customer dress record is intended to contain:

1. Dress name/type
2. Measurements
3. Design details
4. Notes
5. Updated date/time

This is important for the demo workflow.

Example:

Customer:

Ali Ahmed

Dress:

Shalwar Kameez

Measurements:

- Length
- Chest
- Waist
- Shoulder
- Sleeve
- Collar
- Shalwar
- Cuff

Design:

- Collar style
- Pocket style
- Daman style
- Chamak Patti
- Cuff style

Notes:

- Fitting instructions
- Tailor instructions

The design details are stored with the measurement record so that when the user opens **View Customer**, the dress's measurements and design can be shown together.

---

# 10. Customer Profile Models

## `customer_profile_models.dart`

Contains the customer-profile data structures used by the customer profile screen.

Important classes include:

- `CustomerProfileData`
- `CustomerMeasurementRecord`
- `CustomerOrderSummary`

### CustomerMeasurementRecord

Represents a saved dress measurement record.

It supports:

- Record ID
- Customer ID
- Dress type
- Measurement values
- Design details
- Notes
- Updated timestamp

This allows one customer to have multiple saved dress measurements.

Example:

Customer → Ali Ahmed

Can have:

- Shalwar Kameez measurement
- Dress Shirt measurement
- Waistcoat measurement

Each dress keeps its own measurement/design data.

---

# 11. Responsive Layout

## `responsive_layout.dart`

Provides responsive helpers for:

- Horizontal page padding
- Maximum content width
- Grid columns
- Card gaps

Used by customer screens and other screens to support:

- Mobile
- Tablet
- Desktop/web-style layouts

---

# 12. Orders Module

Location:

`features/orders/presentation/`

Orders are another major part of the application.

---

## `orders_screen.dart`

Main orders list.

Provides UI for:

- Orders
- Customer information
- Dress/order information
- Status
- Amount/payment information
- Order cards
- Search/filter-style presentation
- Responsive layout

---

## `add_order_screen.dart`

Used to create a new order.

Supports order information and customer/dress workflow.

The screen also creates a `NewOrderData` result and contains order payload conversion through `toJson()`.

---

## `add_saved_measurement_order_screen.dart`

Used to create an order using an existing saved customer measurement.

This connects the customer profile measurement workflow with the order workflow.

Flow:

Customer Profile

↓

Saved Dress Measurement

↓

Use Latest Measurement

↓

Add Order

---

## `order_details_screen.dart`

Shows details of an individual order.

---

## `update_order_status_screen.dart`

Used to update the order's progress/status.

---

## `receive_payment_screen.dart`

Used for receiving/recording an order payment.

Includes payment summary UI.

---

## `order_model.dart`

Contains order-related data structures.

Important classes include:

- `TailorOrder`
- `OrderPayment`

The order model is separate because it is shared by multiple order screens.

---

# 13. Menu Module

Location:

`features/menu/presentation/screens/`

---

## `menu_screen.dart`

Main application menu.

Provides access to:

- Profile
- Backup & Restore
- Language
- About TailorX
- Logout

---

## `profile_screen.dart`

Tailor/shop profile screen.

Contains fields such as:

- Name/profile information
- Email
- Shop address
- Profile image-related UI

---

## `backup_restore_screen.dart`

Backup & Restore UI.

Purpose:

- Provide a place for customer/data backup controls
- Provide restore controls

Important:

The current source is UI/prototype-oriented. A real cloud/database backup implementation is not present in this `lib` package.

---

## `language_screen.dart`

Language selection UI.

Contains:

- Language options
- Selection UI
- Language controller/presentation

---

## `about_tailorx_screen.dart`

About page for TailorX.

Provides app/company information UI.

---

## `logout_screen.dart`

Logout confirmation and logout presentation.

---

# 14. Theme Support

TailorX currently supports:

- Light theme
- Dark theme

Theme state is controlled centrally through:

`ThemeController`

The app uses:

`AppTheme.lightTheme`

and:

`AppTheme.darkTheme`

---

# 15. Image Support

The project uses:

`image_picker`

for image-selection related UI.

Customer/profile screens can work with:

- Local image paths
- Network image URLs
- Fallback avatars

The current demo customer data uses network avatar URLs.

These are demo/preview images, not permanent customer assets.

---

# 16. Current Demo Customers

## Gents

1. Ali Ahmed
2. Usman Tariq
3. Hamza Khan

## Ladies

1. Ayesha Noor
2. Sana Khan
3. Fatima Ali

## Kids

1. Ahmed Raza
2. Zain Ali
3. Hassan Noor

The customer category screens contain these demo records.

---

# 17. Current Demo Dress/Measurement Concept

### Gents

Example dress records:

- Shalwar Kameez
- Dress Shirt
- Waistcoat

### Ladies

Example dress records:

- Shalwar Kameez
- Kurti
- Frock

### Kids

Example dress records:

- Boys Shalwar Kameez
- Boys Kurta
- Boys Waistcoat

The purpose is to demonstrate that one customer can have multiple saved dress measurements.

---

# 18. Important Development Principle

When adding a new screen-specific widget:

### Current project style

Prefer:

`screen_name.dart`

containing:

- Main screen
- Screen state
- Private helper widgets
- Screen-specific cards
- Screen-specific buttons
- Screen-specific dialogs
- Screen-specific UI helpers

instead of creating many tiny files for every widget.

### Create a separate file when:

The component is genuinely shared by multiple screens.

Examples:

- Theme controller
- App colors
- Order model
- Customer profile models
- Responsive layout
- Reusable premium stepper

This keeps the project manageable without creating hundreds of tiny Dart files.

---

# 19. Backend / Database Status

The current source package does NOT contain a complete backend implementation.

There are comments/hooks indicating future integration, including:

- PHP API
- MySQL
- Backend save callbacks

For example, customer profile code contains callback hooks intended for future backend/database integration.

Therefore, before production deployment, the following need to be connected to a real backend/database:

- Customer CRUD
- Measurements CRUD
- Design details CRUD
- Orders CRUD
- Payments
- Authentication
- Notifications
- Backup/restore
- User/shop data
- Image storage

The current demo data should not be treated as permanent database data.

---

# 20. Recommended Future Data Structure

For the production backend, the logical relationship should be:

Shop/User

↓

Customers

↓

Customer Dress Measurements

↓

Dress Design Details

↓

Orders

↓

Payments

A customer can have multiple dress records.

Example:

Ali Ahmed

├── Shalwar Kameez
│   ├── Measurements
│   ├── Design
│   └── Notes
│
├── Dress Shirt
│   ├── Measurements
│   ├── Design
│   └── Notes
│
└── Waistcoat
    ├── Measurements
    ├── Design
    └── Notes

This structure should be preserved when connecting the backend.

---

# 21. Developer Notes

When modifying the app:

1. Do not remove existing customer measurement fields without checking dependencies.
2. Do not remove design details from measurement records.
3. Keep each dress's measurements separate.
4. Keep each dress's design details separate.
5. Keep customer category separate from dress type.
6. Kids remains a single customer category.
7. Do not reintroduce New Born / Infants as a separate category unless specifically requested.
8. Keep screen-specific widgets inside their screen file unless they are genuinely reusable.
9. Keep shared models/components in their dedicated files.
10. Preserve light/dark theme support.
11. Preserve responsive layout behavior.
12. When backend is connected, replace demo data with API/database data rather than duplicating demo records.

---

# 22. Current Source Structure

```text
lib/
├── main.dart
│
├── core/
│   ├── constants/
│   │   └── app_colors.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── theme_controller.dart
│   └── widgets/
│       └── premium_stepper.dart
│
└── features/
    ├── auth/
    │   └── presentation/screens/
    │       ├── auth_ui.dart
    │       ├── create_account_screen.dart
    │       ├── forgot_password_screen.dart
    │       └── login_screen.dart
    │
    ├── customers/
    │   └── presentation/screens/
    │       ├── add_customer_screen.dart
    │       ├── customer_profile_models.dart
    │       ├── customer_profile_screen.dart
    │       ├── customer_type.dart
    │       ├── edit_customer_screen.dart
    │       ├── gents_customers_screen.dart
    │       ├── kids_customers_screen.dart
    │       ├── ladies_customers_screen.dart
    │       ├── responsive_layout.dart
    │       └── total_customers_screen.dart
    │
    ├── dashboard/
    │   └── presentation/screens/
    │       ├── dashboard_screen.dart
    │       └── notifications_screen.dart
    │
    ├── menu/
    │   └── presentation/screens/
    │       ├── about_tailorx_screen.dart
    │       ├── backup_restore_screen.dart
    │       ├── language_screen.dart
    │       ├── logout_screen.dart
    │       ├── menu_screen.dart
    │       └── profile_screen.dart
    │
    └── orders/
        └── presentation/
            ├── models/
            │   └── order_model.dart
            └── screens/
                ├── add_order_screen.dart
                ├── add_saved_measurement_order_screen.dart
                ├── order_details_screen.dart
                ├── orders_screen.dart
                ├── receive_payment_screen.dart
                └── update_order_status_screen.dart
```

---

# 23. Summary

TailorX currently has a strong UI foundation for a tailoring management application.

The main implemented areas are:

- Authentication UI
- Dashboard
- Customer management
- Gents/Ladies/Kids categories
- Customer profiles
- Multiple dress measurements
- Dress design information
- Orders
- Order details
- Order status
- Payments UI
- Notifications
- Profile
- Backup/Restore UI
- Language UI
- About
- Logout
- Responsive layouts
- Light/Dark themes

The main remaining production step is connecting the UI/demo data to a real backend/database and persistent storage.

**Important:** The source intentionally does not create a separate Dart file for every widget. Most screen-specific widgets are kept inside the corresponding screen file. Shared/reusable components and models are separated where appropriate.
