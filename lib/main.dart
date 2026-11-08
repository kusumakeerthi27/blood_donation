// BloodConnect - a responsive blood donation web app built with Flutter.
//
// Needs one extra package:   flutter pub add google_fonts
//
// Pages (named routes): /  /donors  /register  /request  /info

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const BloodConnectApp());
}

// ============================================================
//  DESIGN TOKENS
//  Hospital-signage palette: white, deep navy, one signal red.
// ============================================================

const Color kInk = Color(0xFF0E1B3D); // deep navy, main text and dark panels
const Color kInkSoft = Color(0xFF4F5D78); // secondary text
const Color kSoft = Color(0xFFF2F4F8); // quiet section background
const Color kLine = Color(0xFFDCE1EA); // hairlines and borders
const Color kRed = Color(0xFFD0112B); // the one brand colour
const Color kRedDeep = Color(0xFF8E0B1F);
const Color kPlasma = Color(0xFFFDE8EB); // pale red tint
const Color kGreen = Color(0xFF0F766E);
const Color kAmber = Color(0xFFA15C07);

/// Headlines: Bricolage Grotesque, heavy and slightly tight.
TextStyle display(double size, {Color color = kInk, double height = 1.1}) {
  return GoogleFonts.bricolageGrotesque(
    fontSize: size,
    fontWeight: FontWeight.w800,
    color: color,
    height: height,
    letterSpacing: size >= 40 ? -size * 0.03 : -size * 0.01,
  );
}

/// Body text: Public Sans, plain and very readable.
TextStyle body(
  double size, {
  FontWeight weight = FontWeight.w400,
  Color color = kInkSoft,
  double height = 1.55,
}) {
  return GoogleFonts.publicSans(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
  );
}

// ============================================================
//  DATA (kept in memory; sample people are fictional)
// ============================================================

const List<String> bloodGroups = ['O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+'];

/// Which recipient groups each donor group can give to.
const Map<String, List<String>> canDonateTo = {
  'O-': ['O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+'],
  'O+': ['O+', 'A+', 'B+', 'AB+'],
  'A-': ['A-', 'A+', 'AB-', 'AB+'],
  'A+': ['A+', 'AB+'],
  'B-': ['B-', 'B+', 'AB-', 'AB+'],
  'B+': ['B+', 'AB+'],
  'AB-': ['AB-', 'AB+'],
  'AB+': ['AB+'],
};

/// Shows a real minus sign instead of a hyphen: O- becomes O−.
String pretty(String group) => group.replaceAll('-', '−');

bool compatible(String donorGroup, String patientGroup) {
  return canDonateTo[donorGroup]!.contains(patientGroup);
}

List<String> receivesFrom(String group) {
  return bloodGroups.where((d) => compatible(d, group)).toList();
}

String unitsLabel(int units) => units == 1 ? '1 unit' : '$units units';

enum Urgency {
  critical('Critical', kRed),
  soon('Within 24 hours', kAmber),
  planned('Planned', kGreen);

  const Urgency(this.label, this.color);
  final String label;
  final Color color;
}

class Donor {
  final String name;
  final String bloodGroup;
  final String city;
  final String phone;

  const Donor({
    required this.name,
    required this.bloodGroup,
    required this.city,
    required this.phone,
  });
}

class BloodRequest {
  final String patient;
  final String bloodGroup;
  final int units;
  final String city;
  final String contact;
  final Urgency urgency;

  const BloodRequest({
    required this.patient,
    required this.bloodGroup,
    required this.units,
    required this.city,
    required this.contact,
    required this.urgency,
  });
}

final List<Donor> donors = [
  const Donor(name: 'Ravi Kumar', bloodGroup: 'O+', city: 'Hyderabad', phone: '9000000001'),
  const Donor(name: 'Anita Sharma', bloodGroup: 'A+', city: 'Delhi', phone: '9000000002'),
  const Donor(name: 'Suresh Reddy', bloodGroup: 'B+', city: 'Bengaluru', phone: '9000000003'),
  const Donor(name: 'Priya Nair', bloodGroup: 'O-', city: 'Chennai', phone: '9000000004'),
  const Donor(name: 'Imran Khan', bloodGroup: 'AB+', city: 'Mumbai', phone: '9000000005'),
  const Donor(name: 'Meena Iyer', bloodGroup: 'A-', city: 'Hyderabad', phone: '9000000006'),
  const Donor(name: 'Karthik Rao', bloodGroup: 'B-', city: 'Bengaluru', phone: '9000000007'),
  const Donor(name: 'Divya Menon', bloodGroup: 'O+', city: 'Chennai', phone: '9000000008'),
  const Donor(name: 'Aman Verma', bloodGroup: 'A+', city: 'Delhi', phone: '9000000009'),
  const Donor(name: 'Lakshmi Devi', bloodGroup: 'AB-', city: 'Hyderabad', phone: '9000000010'),
];

final List<BloodRequest> requests = [
  const BloodRequest(
    patient: 'Rahul M.',
    bloodGroup: 'O-',
    units: 2,
    city: 'Hyderabad',
    contact: '9000000101',
    urgency: Urgency.critical,
  ),
  const BloodRequest(
    patient: 'Sneha P.',
    bloodGroup: 'B+',
    units: 1,
    city: 'Bengaluru',
    contact: '9000000102',
    urgency: Urgency.soon,
  ),
  const BloodRequest(
    patient: 'Fatima S.',
    bloodGroup: 'AB-',
    units: 1,
    city: 'Chennai',
    contact: '9000000104',
    urgency: Urgency.soon,
  ),
  const BloodRequest(
    patient: 'Arjun K.',
    bloodGroup: 'A+',
    units: 3,
    city: 'Delhi',
    contact: '9000000103',
    urgency: Urgency.planned,
  ),
];

// ============================================================
//  APP AND NAMED ROUTES
// ============================================================

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const HomePage(),
  '/donors': (context) => const DonorsPage(),
  '/register': (context) => const RegisterPage(),
  '/request': (context) => const RequestPage(),
  '/info': (context) => const InfoPage(),
};

class BloodConnectApp extends StatelessWidget {
  const BloodConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BloodConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kRed,
          primary: kRed,
          surface: Colors.white,
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final builder = appRoutes[settings.name] ?? appRoutes['/']!;
        return PageRouteBuilder<void>(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 220),
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    );
  }
}

/// Moves to another page. Optional arguments (like a blood group) travel along.
void go(BuildContext context, String route, {Object? arguments}) {
  Navigator.of(context).pushReplacementNamed(route, arguments: arguments);
}

// ============================================================
//  RESPONSIVE HELPERS
// ============================================================

bool isWide(BuildContext context) => MediaQuery.sizeOf(context).width >= 960;
bool isPhone(BuildContext context) => MediaQuery.sizeOf(context).width < 640;

/// Centres content and limits it to 1180 px so wide screens stay readable.
class Section extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double? vertical;

  const Section({super.key, required this.child, this.color, this.vertical});

  @override
  Widget build(BuildContext context) {
    final phone = isPhone(context);
    return Container(
      width: double.infinity,
      color: color,
      padding: EdgeInsets.symmetric(
        horizontal: phone ? 20 : 32,
        vertical: vertical ?? (phone ? 44.0 : 72.0),
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: SizedBox(width: double.infinity, child: child),
        ),
      ),
    );
  }
}

/// Lays children out in as many equal-height columns as fit the width.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double minItemWidth;
  final double columnGap;
  final double rowGap;
  final int maxColumns;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.minItemWidth = 320,
    this.columnGap = 24,
    this.rowGap = 24,
    this.maxColumns = 4,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var cols = ((constraints.maxWidth + columnGap) / (minItemWidth + columnGap)).floor();
        if (cols < 1) cols = 1;
        if (cols > maxColumns) cols = maxColumns;

        final rows = <Widget>[];
        for (var i = 0; i < children.length; i += cols) {
          final end = i + cols > children.length ? children.length : i + cols;
          final slice = children.sublist(i, end);
          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var j = 0; j < cols; j++) ...[
                    if (j > 0) SizedBox(width: columnGap),
                    Expanded(child: j < slice.length ? slice[j] : const SizedBox.shrink()),
                  ],
                ],
              ),
            ),
          );
          if (end < children.length) rows.add(SizedBox(height: rowGap));
        }
        return Column(children: rows);
      },
    );
  }
}

// ============================================================
//  LOGO
// ============================================================

/// A blood drop with a heartbeat line inside it.
class DropPainter extends CustomPainter {
  final Color fill;
  final Color pulse;

  const DropPainter(this.fill, this.pulse);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = w * 0.45; // radius of the round bottom
    final cy = h - r; // centre of the round bottom

    final drop = Path()
      ..moveTo(w / 2, 0)
      ..cubicTo(w * 0.58, cy * 0.30, w * 0.95, cy * 0.55, w * 0.95, cy)
      ..arcToPoint(Offset(w * 0.05, cy), radius: Radius.circular(r), clockwise: true)
      ..cubicTo(w * 0.05, cy * 0.55, w * 0.42, cy * 0.30, w / 2, 0)
      ..close();
    canvas.drawPath(drop, Paint()..color = fill);

    final my = cy + r * 0.15;
    final beat = Path()
      ..moveTo(w * 0.20, my)
      ..lineTo(w * 0.38, my)
      ..lineTo(w * 0.46, my - r * 0.45)
      ..lineTo(w * 0.55, my + r * 0.45)
      ..lineTo(w * 0.62, my)
      ..lineTo(w * 0.80, my);
    canvas.drawPath(
      beat,
      Paint()
        ..color = pulse
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.07
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant DropPainter oldDelegate) {
    return oldDelegate.fill != fill || oldDelegate.pulse != pulse;
  }
}

class BrandLogo extends StatelessWidget {
  final bool onDark;

  const BrandLogo({super.key, this.onDark = false});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => go(context, '/'),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 26,
              height: 33,
              child: CustomPaint(
                painter: DropPainter(
                  onDark ? Colors.white : kRed,
                  onDark ? kInk : Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 9),
            Text('Blood', style: display(23, color: onDark ? Colors.white : kInk)),
            Text('Connect', style: display(23, color: onDark ? const Color(0xFFFF9AA8) : kRed)),
          ],
        ),
      ),
    );
  }
}

// ============================================================
//  BUTTONS AND SMALL PIECES
// ============================================================

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool onDark;
  final bool expand;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.onDark = false,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: onDark ? Colors.white : kRed,
        foregroundColor: onDark ? kRedDeep : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 19),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: GoogleFonts.publicSans(fontSize: 15.5, fontWeight: FontWeight.w700),
      ),
      child: Text(label),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool onDark;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.onDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: onDark ? Colors.white : kInk,
        side: BorderSide(color: onDark ? Colors.white70 : kInk, width: 1.4),
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 19),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: GoogleFonts.publicSans(fontSize: 15.5, fontWeight: FontWeight.w700),
      ),
      child: Text(label),
    );
  }
}

/// Compact outlined button used inside list rows.
class SmallButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const SmallButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: kInk,
        side: const BorderSide(color: kInk, width: 1.2),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: GoogleFonts.publicSans(fontSize: 14, fontWeight: FontWeight.w700),
      ),
      child: Text(label),
    );
  }
}

/// A selectable chip used for filters and urgency.
class Pill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const Pill({super.key, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? kInk : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: selected ? kInk : kLine, width: 1.4),
            ),
            child: Text(
              label,
              style: body(14.5, weight: FontWeight.w700, color: selected ? Colors.white : kInk),
            ),
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? text;
  final Color titleColor;
  final Color textColor;

  const SectionTitle({
    super.key,
    required this.title,
    this.text,
    this.titleColor = kInk,
    this.textColor = kInkSoft,
  });

  @override
  Widget build(BuildContext context) {
    final phone = isPhone(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Text(title, style: display(phone ? 30 : 40, color: titleColor, height: 1.08)),
        ),
        if (text != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Text(text!, style: body(phone ? 16 : 17.5, color: textColor)),
            ),
          ),
      ],
    );
  }
}

InputDecoration fieldDecoration(String label, {IconData? icon, Color fill = Colors.white}) {
  OutlineInputBorder border(Color color, [double width = 1.2]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  return InputDecoration(
    labelText: label,
    labelStyle: body(15),
    floatingLabelStyle: body(14, weight: FontWeight.w700, color: kInk),
    prefixIcon: icon == null ? null : Icon(icon, color: kInkSoft, size: 20),
    filled: true,
    fillColor: fill,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    border: border(kLine),
    enabledBorder: border(kLine),
    focusedBorder: border(kInk, 1.8),
    errorBorder: border(kRed),
    focusedErrorBorder: border(kRed, 1.8),
    errorStyle: body(13, weight: FontWeight.w600, color: kRed, height: 1.3),
  );
}

void showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: body(15, weight: FontWeight.w600, color: Colors.white)),
      backgroundColor: kInk,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void showContactDialog(
  BuildContext context, {
  required String title,
  required String detail,
  required String phone,
}) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(title, style: display(26)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(detail, style: body(15.5)),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: kSoft, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(Icons.call_outlined, color: kRed),
                const SizedBox(width: 12),
                Text(phone, style: display(24)),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: phone));
            Navigator.pop(dialogContext);
            showToast(context, 'Number copied');
          },
          child: Text('Copy number', style: body(14.5, weight: FontWeight.w700, color: kInk)),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext),
          style: FilledButton.styleFrom(backgroundColor: kRed),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

// ============================================================
//  PAGE SHELL: top bar, drawer, footer
// ============================================================

class NavItem {
  final String label;
  final String route;

  const NavItem(this.label, this.route);
}

const List<NavItem> navItems = [
  NavItem('Home', '/'),
  NavItem('Find a donor', '/donors'),
  NavItem('Request blood', '/request'),
  NavItem('Learn', '/info'),
];

class SiteShell extends StatelessWidget {
  final String current;
  final Widget child;

  const SiteShell({super.key, required this.current, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: TopBar(current: current),
      ),
      endDrawer: isWide(context) ? null : NavDrawer(current: current),
      body: SingleChildScrollView(
        child: Column(children: [child, const Footer()]),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  final String current;

  const TopBar({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    final wide = isWide(context);
    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(horizontal: isPhone(context) ? 16 : 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: kLine)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Row(
            children: [
              const BrandLogo(),
              const Spacer(),
              if (wide) ...[
                for (final item in navItems)
                  NavLink(item: item, active: item.route == current),
                const SizedBox(width: 16),
                PrimaryButton(
                  label: 'Register as a donor',
                  onPressed: () => go(context, '/register'),
                ),
              ] else
                Builder(
                  builder: (ctx) => IconButton(
                    tooltip: 'Open menu',
                    icon: const Icon(Icons.menu_rounded, color: kInk),
                    onPressed: () => Scaffold.of(ctx).openEndDrawer(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavLink extends StatelessWidget {
  final NavItem item;
  final bool active;

  const NavLink({super.key, required this.item, required this.active});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: () => go(context, item.route),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.label,
              style: body(
                15.5,
                weight: active ? FontWeight.w700 : FontWeight.w500,
                color: active ? kRed : kInk,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2.5,
              width: active ? 24 : 0,
              color: kRed,
            ),
          ],
        ),
      ),
    );
  }
}

class NavDrawer extends StatelessWidget {
  final String current;

  const NavDrawer({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BrandLogo(),
              const SizedBox(height: 28),
              for (final item in navItems)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item.label,
                    style: display(26, color: item.route == current ? kRed : kInk),
                  ),
                  onTap: () => go(context, item.route),
                ),
              const Spacer(),
              PrimaryButton(
                label: 'Register as a donor',
                expand: true,
                onPressed: () => go(context, '/register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  Widget _link(BuildContext context, String label, String route) {
    return TextButton(
      onPressed: () => go(context, route),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.centerLeft,
      ),
      child: Text(label, style: body(15, color: Colors.white70)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = isWide(context);

    final about = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BrandLogo(onDark: true),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Text(
            'BloodConnect is a student project built with Flutter. The donors and requests '
            'shown are sample data. In an emergency, call your local emergency number or '
            'contact the nearest blood bank.',
            style: body(14.5, color: Colors.white70),
          ),
        ),
      ],
    );

    Widget column(String heading, List<Widget> links) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading, style: body(15, weight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 8),
          ...links,
        ],
      );
    }

    final explore = column('Explore', [
      _link(context, 'Home', '/'),
      _link(context, 'Find a donor', '/donors'),
      _link(context, 'Learn', '/info'),
    ]);
    final takePart = column('Take part', [
      _link(context, 'Register as a donor', '/register'),
      _link(context, 'Request blood', '/request'),
    ]);

    return Section(
      color: kInk,
      vertical: wide ? 56 : 40,
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: about),
                Expanded(flex: 2, child: explore),
                Expanded(flex: 2, child: takePart),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                about,
                const SizedBox(height: 28),
                explore,
                const SizedBox(height: 20),
                takePart,
              ],
            ),
    );
  }
}

// ============================================================
//  BLOOD GROUP PICKER AND SPOTLIGHT
// ============================================================

class GroupTile extends StatelessWidget {
  final String group;
  final bool selected;
  final VoidCallback onTap;

  const GroupTile({super.key, required this.group, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: 'Blood group ${pretty(group)}',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            height: 58,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? kRed : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: selected ? kRed : kLine, width: 1.5),
            ),
            child: Text(
              pretty(group),
              style: display(22, color: selected ? Colors.white : kInk, height: 1),
            ),
          ),
        ),
      ),
    );
  }
}

/// Eight blood groups in two rows of four.
class GroupPicker extends StatelessWidget {
  final String? value;
  final ValueChanged<String> onChanged;
  final String? errorText;

  const GroupPicker({super.key, required this.value, required this.onChanged, this.errorText});

  @override
  Widget build(BuildContext context) {
    Widget row(List<String> groups) {
      return Row(
        children: [
          for (var i = 0; i < groups.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(
              child: GroupTile(
                group: groups[i],
                selected: value == groups[i],
                onTap: () => onChanged(groups[i]),
              ),
            ),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        row(bloodGroups.sublist(0, 4)),
        const SizedBox(height: 8),
        row(bloodGroups.sublist(4, 8)),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(errorText!, style: body(13, weight: FontWeight.w600, color: kRed)),
          ),
      ],
    );
  }
}

class CompatChips extends StatelessWidget {
  final List<String> groups;
  final bool onDark;

  const CompatChips({super.key, required this.groups, this.onDark = false});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final g in groups)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: onDark ? Colors.white.withValues(alpha: 0.14) : Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              pretty(g),
              style: body(14, weight: FontWeight.w700, color: onDark ? Colors.white : kRedDeep, height: 1.3),
            ),
          ),
      ],
    );
  }
}

/// The big navy panel on the home page: one giant blood group and what it means.
class GroupSpotlight extends StatelessWidget {
  final String group;

  const GroupSpotlight({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final phone = isPhone(context);
    final usable = donors.where((d) => compatible(d.bloodGroup, group)).length;

    return Container(
      padding: EdgeInsets.all(phone ? 24 : 36),
      decoration: BoxDecoration(color: kInk, borderRadius: BorderRadius.circular(28)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Selected blood group', style: body(14.5, color: Colors.white70)),
          const SizedBox(height: 4),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            layoutBuilder: (current, previous) {
              return Stack(
                alignment: Alignment.centerLeft,
                children: [...previous, if (current != null) current],
              );
            },
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.9, end: 1).animate(animation),
                  child: child,
                ),
              );
            },
            child: FittedBox(
              key: ValueKey(group),
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                pretty(group),
                style: display(phone ? 120 : 176, color: Colors.white, height: 1.0),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: Colors.white24),
          const SizedBox(height: 18),
          Text('Can receive from', style: body(14, color: Colors.white70)),
          const SizedBox(height: 8),
          CompatChips(groups: receivesFrom(group), onDark: true),
          const SizedBox(height: 18),
          Text('Can give to', style: body(14, color: Colors.white70)),
          const SizedBox(height: 8),
          CompatChips(groups: canDonateTo[group]!, onDark: true),
          const SizedBox(height: 22),
          Text(
            '$usable of ${donors.length} registered donors can give to ${pretty(group)}.',
            style: body(15, weight: FontWeight.w600, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// ============================================================
//  HOME PAGE
// ============================================================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SiteShell(
      current: '/',
      child: Column(
        children: [
          HeroSection(),
          OpenRequests(),
          HowItWorks(),
          CtaBand(),
        ],
      ),
    );
  }
}

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  String _group = 'O-';

  @override
  Widget build(BuildContext context) {
    final wide = isWide(context);
    final phone = isPhone(context);

    final left = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Every patient has a blood group. Every group has donors.',
          style: display(wide ? 58 : (phone ? 38 : 48), height: 1.04),
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            'BloodConnect lists donors by blood group and city and keeps a live board of '
            'open requests. Choose a group to see who can give it and who can receive it.',
            style: body(phone ? 16 : 18),
          ),
        ),
        const SizedBox(height: 32),
        Text('Choose a blood group', style: body(14.5, weight: FontWeight.w700, color: kInk)),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: GroupPicker(
            value: _group,
            onChanged: (g) => setState(() => _group = g),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            PrimaryButton(
              label: 'See donors for ${pretty(_group)}',
              onPressed: () => go(context, '/donors', arguments: _group),
            ),
            SecondaryButton(
              label: 'Post a request',
              onPressed: () => go(context, '/request', arguments: _group),
            ),
          ],
        ),
      ],
    );

    final right = GroupSpotlight(group: _group);

    return Section(
      vertical: wide ? 72 : 40,
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 6, child: left),
                const SizedBox(width: 56),
                Expanded(flex: 5, child: right),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [left, const SizedBox(height: 36), right],
            ),
    );
  }
}

class OpenRequests extends StatelessWidget {
  const OpenRequests({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = isWide(context);
    final list = requests.take(8).toList();

    final heading = const SectionTitle(
      title: 'Open requests',
      text: 'Patients and families looking for a donor right now. '
          'If your blood group fits, you can contact them directly.',
    );
    final postButton = PrimaryButton(
      label: 'Post a request',
      onPressed: () => go(context, '/request'),
    );

    return Section(
      color: kSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (wide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [Expanded(child: heading), postButton],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [heading, const SizedBox(height: 20), postButton],
            ),
          const SizedBox(height: 28),
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: kInk, width: 2)),
            ),
            child: Column(
              children: [for (final r in list) RequestRow(request: r)],
            ),
          ),
        ],
      ),
    );
  }
}

class RequestRow extends StatelessWidget {
  final BloodRequest request;

  const RequestRow({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final phone = isPhone(context);

    final help = SmallButton(
      label: 'I can help',
      onPressed: () => showContactDialog(
        context,
        title: 'Contact ${request.patient}',
        detail: '${pretty(request.bloodGroup)} is needed in ${request.city}.',
        phone: request.contact,
      ),
    );

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(request.patient, style: body(18, weight: FontWeight.w700, color: kInk)),
        Text(request.city, style: body(15)),
      ],
    );

    final status = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: request.urgency.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          request.urgency.label,
          style: body(14.5, weight: FontWeight.w700, color: request.urgency.color),
        ),
      ],
    );

    final units = Text(
      unitsLabel(request.units),
      style: body(15, weight: FontWeight.w600, color: kInk),
    );

    final glyph = Text(
      pretty(request.bloodGroup),
      style: display(phone ? 36 : 44, color: kRed, height: 1),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kLine)),
      ),
      child: phone
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 84, child: glyph),
                    Expanded(child: info),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 18,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [status, units, help],
                ),
              ],
            )
          : Row(
              children: [
                SizedBox(width: 120, child: glyph),
                Expanded(flex: 3, child: info),
                Expanded(flex: 2, child: status),
                SizedBox(width: 110, child: units),
                help,
              ],
            ),
    );
  }
}

class HowItWorks extends StatelessWidget {
  const HowItWorks({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'How BloodConnect works',
            text: 'Three steps from wanting to help to giving blood.',
          ),
          const SizedBox(height: 36),
          ResponsiveGrid(
            minItemWidth: 280,
            columnGap: 40,
            rowGap: 32,
            maxColumns: 3,
            children: const [
              StepItem(
                number: '1',
                title: 'Register',
                text: 'Add your name, blood group and city. It takes about a minute and needs no account.',
              ),
              StepItem(
                number: '2',
                title: 'Get matched',
                text: 'Requests are matched to donors in the same city, including compatible blood groups.',
              ),
              StepItem(
                number: '3',
                title: 'Connect',
                text: 'Call the person directly, then arrange the donation with the hospital or blood bank.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StepItem extends StatelessWidget {
  final String number;
  final String title;
  final String text;

  const StepItem({super.key, required this.number, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: kRed, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(number, style: display(48, color: kRed, height: 1)),
          const SizedBox(height: 14),
          Text(title, style: display(24)),
          const SizedBox(height: 8),
          Text(text, style: body(16)),
        ],
      ),
    );
  }
}

/// Full-width red band that closes most pages.
class CtaBand extends StatelessWidget {
  const CtaBand({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = isWide(context);

    final message = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Someone is waiting for a match.',
          style: display(wide ? 44 : 32, color: Colors.white, height: 1.08),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            'Register in a minute and become the donor a nearby patient is looking for.',
            style: body(17, color: Colors.white.withValues(alpha: 0.9)),
          ),
        ),
      ],
    );

    final buttons = Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        PrimaryButton(
          label: 'Register as a donor',
          onDark: true,
          onPressed: () => go(context, '/register'),
        ),
        SecondaryButton(
          label: 'Post a request',
          onDark: true,
          onPressed: () => go(context, '/request'),
        ),
      ],
    );

    return Section(
      color: kRed,
      vertical: wide ? 64 : 44,
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Expanded(child: message), const SizedBox(width: 32), buttons],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [message, const SizedBox(height: 24), buttons],
            ),
    );
  }
}

// ============================================================
//  FIND A DONOR
// ============================================================

class DonorsPage extends StatefulWidget {
  const DonorsPage({super.key});

  @override
  State<DonorsPage> createState() => _DonorsPageState();
}

class _DonorsPageState extends State<DonorsPage> {
  String? _group;
  bool _includeCompatible = false;
  String _query = '';
  bool _argumentsRead = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_argumentsRead) {
      _argumentsRead = true;
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg is String) {
        _group = arg;
        _includeCompatible = true;
      }
    }
  }

  List<Donor> _results() {
    final q = _query.trim().toLowerCase();
    bool matchesQuery(Donor d) {
      return q.isEmpty || d.name.toLowerCase().contains(q) || d.city.toLowerCase().contains(q);
    }

    final group = _group;
    if (group == null) return donors.where(matchesQuery).toList();

    final exact = donors.where((d) => d.bloodGroup == group && matchesQuery(d)).toList();
    if (!_includeCompatible) return exact;

    final others = donors
        .where((d) => d.bloodGroup != group && compatible(d.bloodGroup, group) && matchesQuery(d))
        .toList();
    return [...exact, ...others];
  }

  @override
  Widget build(BuildContext context) {
    final results = _results();
    final group = _group;

    final String summary;
    if (group == null) {
      summary = '${results.length} registered donors';
    } else if (_includeCompatible) {
      summary = '${results.length} donors can give to ${pretty(group)}';
    } else {
      summary = '${results.length} donors with ${pretty(group)}';
    }

    return SiteShell(
      current: '/donors',
      child: Column(
        children: [
          Section(
            color: kSoft,
            vertical: isPhone(context) ? 36 : 56,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(
                  title: 'Find a donor',
                  text: 'Search by name or city, or filter by blood group.',
                ),
                const SizedBox(height: 24),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: TextField(
                    decoration: fieldDecoration('Search by name or city', icon: Icons.search_rounded),
                    onChanged: (value) => setState(() => _query = value),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Pill(
                      label: 'All groups',
                      selected: group == null,
                      onTap: () => setState(() => _group = null),
                    ),
                    for (final g in bloodGroups)
                      Pill(
                        label: pretty(g),
                        selected: group == g,
                        onTap: () => setState(() => _group = g),
                      ),
                  ],
                ),
                if (group != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: _includeCompatible,
                          activeColor: kRed,
                          onChanged: (v) => setState(() => _includeCompatible = v ?? false),
                        ),
                        Flexible(
                          child: Text(
                            'Include donors with compatible blood groups',
                            style: body(15, color: kInk),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Section(
            vertical: isPhone(context) ? 32 : 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(summary, style: body(15.5, weight: FontWeight.w700, color: kInk)),
                const SizedBox(height: 8),
                if (results.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('No donors match yet', style: display(28)),
                        const SizedBox(height: 8),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 480),
                          child: Text(
                            'Try another blood group, include compatible groups, or clear the search.',
                            style: body(16),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SmallButton(
                          label: 'Clear filters',
                          onPressed: () => setState(() {
                            _group = null;
                            _query = '';
                            _includeCompatible = false;
                          }),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: kInk, width: 2)),
                    ),
                    child: ResponsiveGrid(
                      minItemWidth: 460,
                      columnGap: 56,
                      rowGap: 0,
                      maxColumns: 2,
                      children: [for (final d in results) DonorRow(donor: d)],
                    ),
                  ),
              ],
            ),
          ),
          const CtaBand(),
        ],
      ),
    );
  }
}

class DonorRow extends StatelessWidget {
  final Donor donor;

  const DonorRow({super.key, required this.donor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kLine)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(
              pretty(donor.bloodGroup),
              style: display(36, color: kRed, height: 1),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(donor.name, style: body(18, weight: FontWeight.w700, color: kInk)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: kInkSoft),
                    const SizedBox(width: 4),
                    Flexible(child: Text(donor.city, style: body(15))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SmallButton(
            label: 'Contact',
            onPressed: () => showContactDialog(
              context,
              title: 'Contact ${donor.name}',
              detail: '${pretty(donor.bloodGroup)} donor in ${donor.city}.',
              phone: donor.phone,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
//  REGISTER AS A DONOR
// ============================================================

Widget twoColumns(BuildContext context, Widget a, Widget b) {
  if (isPhone(context)) {
    return Column(children: [a, const SizedBox(height: 16), b]);
  }
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [Expanded(child: a), const SizedBox(width: 16), Expanded(child: b)],
  );
}

/// A navy donor card that fills in live as the form is typed.
class DonorCardPreview extends StatelessWidget {
  final String name;
  final String city;
  final String? group;

  const DonorCardPreview({super.key, required this.name, required this.city, required this.group});

  @override
  Widget build(BuildContext context) {
    final shownName = name.trim().isEmpty ? 'Your name' : name.trim();
    final shownCity = city.trim().isEmpty ? 'Your city' : city.trim();
    final shownGroup = group == null ? '–' : pretty(group!);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: kInk, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 23,
                  child: CustomPaint(painter: DropPainter(Colors.white, kInk)),
                ),
                const SizedBox(width: 8),
                Text('BloodConnect donor card', style: body(13.5, weight: FontWeight.w600, color: Colors.white70)),
              ],
            ),
            const SizedBox(height: 18),
            Text(shownGroup, style: display(96, color: Colors.white, height: 1)),
            const SizedBox(height: 14),
            Container(height: 4, width: 48, color: kRed),
            const SizedBox(height: 14),
            Text(
              shownName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: body(19, weight: FontWeight.w700, color: Colors.white),
            ),
            Text(
              shownCity,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: body(15, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckLine extends StatelessWidget {
  final String text;

  const CheckLine(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.check_circle_outline_rounded, size: 20, color: kGreen),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: body(16, color: kInk))),
        ],
      ),
    );
  }
}

class FormCard extends StatelessWidget {
  final Widget child;

  const FormCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isPhone(context) ? 20 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kLine),
      ),
      child: child,
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _city = TextEditingController();
  final _phone = TextEditingController();
  String? _group;
  bool _groupMissing = false;
  bool _agree = false;

  @override
  void initState() {
    super.initState();
    _name.addListener(_refresh);
    _city.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    _city.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _submit() {
    final valid = _formKey.currentState!.validate();
    if (_group == null) setState(() => _groupMissing = true);
    if (!valid || _group == null) return;
    if (!_agree) {
      showToast(context, 'Please confirm that you meet the eligibility points.');
      return;
    }

    final name = _name.text.trim();
    donors.insert(
      0,
      Donor(
        name: name,
        bloodGroup: _group!,
        city: _city.text.trim(),
        phone: _phone.text.trim(),
      ),
    );
    showToast(context, "You're registered, $name.");
    go(context, '/donors', arguments: _group);
  }

  @override
  Widget build(BuildContext context) {
    final wide = isWide(context);

    final intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Register as a donor', style: display(wide ? 50 : 36, height: 1.05)),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Text(
            'It takes one minute and needs no account. Your name, blood group and city go on '
            'the donor list so patients nearby can reach you.',
            style: body(17),
          ),
        ),
      ],
    );

    final preview = Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: DonorCardPreview(name: _name.text, city: _city.text, group: _group),
    );

    final checklist = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Before you register', style: display(22)),
        const SizedBox(height: 12),
        const CheckLine('You are between 18 and 65 years old.'),
        const CheckLine('You weigh at least 50 kg.'),
        const CheckLine('You feel well, with no fever or infection.'),
      ],
    );

    final form = FormCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Your details', style: display(26)),
            const SizedBox(height: 20),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: fieldDecoration('Full name', icon: Icons.person_outline_rounded, fill: kSoft),
              validator: (v) =>
                  (v == null || v.trim().length < 2) ? 'Enter your full name.' : null,
            ),
            const SizedBox(height: 16),
            twoColumns(
              context,
              TextFormField(
                controller: _age,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: fieldDecoration('Age', icon: Icons.cake_outlined, fill: kSoft),
                validator: (v) {
                  final age = int.tryParse(v ?? '');
                  if (age == null) return 'Enter your age.';
                  if (age < 18 || age > 65) return 'Donors must be 18 to 65 years old.';
                  return null;
                },
              ),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: fieldDecoration('Phone number', icon: Icons.phone_outlined, fill: kSoft),
                validator: (v) =>
                    (v == null || v.trim().length != 10) ? 'Enter a 10-digit number.' : null,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _city,
              textCapitalization: TextCapitalization.words,
              decoration: fieldDecoration('City', icon: Icons.location_city_outlined, fill: kSoft),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter your city.' : null,
            ),
            const SizedBox(height: 22),
            Text('Blood group', style: body(14.5, weight: FontWeight.w700, color: kInk)),
            const SizedBox(height: 8),
            GroupPicker(
              value: _group,
              errorText: _groupMissing && _group == null ? 'Choose your blood group.' : null,
              onChanged: (g) => setState(() {
                _group = g;
                _groupMissing = false;
              }),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              value: _agree,
              onChanged: (v) => setState(() => _agree = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: kRed,
              title: Text(
                'I am 18 to 65 years old, weigh at least 50 kg and feel well.',
                style: body(14.5, color: kInk),
              ),
            ),
            const SizedBox(height: 12),
            PrimaryButton(label: 'Register as a donor', expand: true, onPressed: _submit),
          ],
        ),
      ),
    );

    return SiteShell(
      current: '/register',
      child: Section(
        color: kSoft,
        vertical: wide ? 64 : 36,
        child: wide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [intro, preview, checklist],
                    ),
                  ),
                  const SizedBox(width: 56),
                  Expanded(flex: 6, child: form),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [intro, preview, form, const SizedBox(height: 28), checklist],
              ),
      ),
    );
  }
}

// ============================================================
//  REQUEST BLOOD
// ============================================================

/// Donors in the same city who can give to the requested group (exact group first).
List<Donor> findMatches(String group, String place) {
  final p = place.toLowerCase().trim();
  final found = donors.where((d) {
    final c = d.city.toLowerCase();
    final sameCity = p.contains(c) || c.contains(p);
    return sameCity && compatible(d.bloodGroup, group);
  }).toList();

  final exact = found.where((d) => d.bloodGroup == group).toList();
  final others = found.where((d) => d.bloodGroup != group).toList();
  return [...exact, ...others];
}

class MatchDialog extends StatelessWidget {
  final BloodRequest request;
  final List<Donor> matches;
  final VoidCallback onViewBoard;

  const MatchDialog({
    super.key,
    required this.request,
    required this.matches,
    required this.onViewBoard,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Request posted', style: display(26)),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${unitsLabel(request.units)} of ${pretty(request.bloodGroup)} in '
                '${request.city} is now on the open requests board.',
                style: body(15.5),
              ),
              const SizedBox(height: 16),
              if (matches.isEmpty)
                Text(
                  'No registered donor in this city can give to ${pretty(request.bloodGroup)} yet. '
                  'Try the donor list for other cities.',
                  style: body(15.5, color: kInk),
                )
              else ...[
                Text(
                  '${matches.length} compatible ${matches.length == 1 ? 'donor' : 'donors'} in your city',
                  style: body(15, weight: FontWeight.w700, color: kInk),
                ),
                const SizedBox(height: 8),
                for (final d in matches.take(5))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(pretty(d.bloodGroup), style: display(26, color: kRed, height: 1)),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(d.name, style: body(16, weight: FontWeight.w700, color: kInk)),
                              Text(d.phone, style: body(14.5)),
                            ],
                          ),
                        ),
                        Text(
                          d.bloodGroup == request.bloodGroup ? 'Same group' : 'Compatible',
                          style: body(
                            13.5,
                            weight: FontWeight.w600,
                            color: d.bloodGroup == request.bloodGroup ? kGreen : kInkSoft,
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close', style: body(14.5, weight: FontWeight.w700, color: kInk)),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            onViewBoard();
          },
          style: FilledButton.styleFrom(backgroundColor: kRed),
          child: const Text('See open requests'),
        ),
      ],
    );
  }
}

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _patient = TextEditingController();
  final _units = TextEditingController(text: '1');
  final _city = TextEditingController();
  final _contact = TextEditingController();
  String? _group;
  bool _groupMissing = false;
  Urgency _urgency = Urgency.soon;
  bool _argumentsRead = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_argumentsRead) {
      _argumentsRead = true;
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg is String) _group = arg;
    }
  }

  @override
  void dispose() {
    _patient.dispose();
    _units.dispose();
    _city.dispose();
    _contact.dispose();
    super.dispose();
  }

  void _submit() {
    final valid = _formKey.currentState!.validate();
    if (_group == null) setState(() => _groupMissing = true);
    if (!valid || _group == null) return;

    final city = _city.text.trim();
    final request = BloodRequest(
      patient: _patient.text.trim(),
      bloodGroup: _group!,
      units: int.parse(_units.text.trim()),
      city: city,
      contact: _contact.text.trim(),
      urgency: _urgency,
    );
    requests.insert(0, request);

    final matches = findMatches(request.bloodGroup, city);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => MatchDialog(
        request: request,
        matches: matches,
        onViewBoard: () => go(context, '/'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = isWide(context);
    final group = _group;

    final intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Post a blood request', style: display(wide ? 50 : 36, height: 1.05)),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Text(
            'Tell us who needs blood and where. The request goes on the open requests board, '
            'and you see registered donors in the same city who can give to that group.',
            style: body(17),
          ),
        ),
      ],
    );

    final next = Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What happens next', style: display(22)),
          const SizedBox(height: 12),
          const CheckLine('Your request appears on the home page.'),
          const CheckLine('You see compatible donors in your city straight away.'),
          const CheckLine('You call them directly and arrange the donation with the hospital or blood bank.'),
        ],
      ),
    );

    final form = FormCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Request details', style: display(26)),
            const SizedBox(height: 20),
            TextFormField(
              controller: _patient,
              textCapitalization: TextCapitalization.words,
              decoration: fieldDecoration('Patient name', icon: Icons.person_outline_rounded, fill: kSoft),
              validator: (v) =>
                  (v == null || v.trim().length < 2) ? "Enter the patient's name." : null,
            ),
            const SizedBox(height: 16),
            twoColumns(
              context,
              TextFormField(
                controller: _units,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: fieldDecoration('Units needed', icon: Icons.water_drop_outlined, fill: kSoft),
                validator: (v) {
                  final units = int.tryParse(v ?? '');
                  if (units == null || units < 1 || units > 10) return 'Enter 1 to 10 units.';
                  return null;
                },
              ),
              TextFormField(
                controller: _contact,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: fieldDecoration('Contact number', icon: Icons.phone_outlined, fill: kSoft),
                validator: (v) =>
                    (v == null || v.trim().length != 10) ? 'Enter a 10-digit number.' : null,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _city,
              textCapitalization: TextCapitalization.words,
              decoration: fieldDecoration('City or hospital area', icon: Icons.local_hospital_outlined, fill: kSoft),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter a city.' : null,
            ),
            const SizedBox(height: 22),
            Text('Blood group needed', style: body(14.5, weight: FontWeight.w700, color: kInk)),
            const SizedBox(height: 8),
            GroupPicker(
              value: group,
              errorText: _groupMissing && group == null ? 'Choose the blood group needed.' : null,
              onChanged: (g) => setState(() {
                _group = g;
                _groupMissing = false;
              }),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: kPlasma, borderRadius: BorderRadius.circular(12)),
              child: group == null
                  ? Text(
                      'Choose a blood group to see which donors can give to it.',
                      style: body(15, color: kInk),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Donors who can give to ${pretty(group)}',
                          style: body(14.5, weight: FontWeight.w700, color: kInk),
                        ),
                        const SizedBox(height: 8),
                        CompatChips(groups: receivesFrom(group)),
                      ],
                    ),
            ),
            const SizedBox(height: 22),
            Text('How urgent is it?', style: body(14.5, weight: FontWeight.w700, color: kInk)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final u in Urgency.values)
                  Pill(
                    label: u.label,
                    selected: _urgency == u,
                    onTap: () => setState(() => _urgency = u),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            PrimaryButton(label: 'Post a request', expand: true, onPressed: _submit),
          ],
        ),
      ),
    );

    return SiteShell(
      current: '/request',
      child: Section(
        color: kSoft,
        vertical: wide ? 64 : 36,
        child: wide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [intro, next],
                    ),
                  ),
                  const SizedBox(width: 56),
                  Expanded(flex: 6, child: form),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [intro, const SizedBox(height: 28), form, next],
              ),
      ),
    );
  }
}

// ============================================================
//  LEARN
// ============================================================

/// Donor groups down the side, recipient groups across the top.
class CompatibilityMatrix extends StatelessWidget {
  const CompatibilityMatrix({super.key});

  @override
  Widget build(BuildContext context) {
    final phone = isPhone(context);

    Widget headerCell(String text) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Text(text, style: body(phone ? 13 : 15, weight: FontWeight.w700, color: kInk)),
        ),
      );
    }

    final header = TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text('Donor', style: body(13, weight: FontWeight.w600)),
        ),
        for (final g in bloodGroups) headerCell(pretty(g)),
      ],
    );

    final rows = [
      for (final donor in bloodGroups)
        TableRow(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: kLine)),
          ),
          children: [
            SizedBox(
              height: 46,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  pretty(donor),
                  style: display(phone ? 17 : 20, color: kRed, height: 1),
                ),
              ),
            ),
            for (final recipient in bloodGroups)
              SizedBox(
                height: 46,
                child: Center(
                  child: compatible(donor, recipient)
                      ? Container(
                          width: 14,
                          height: 14,
                          decoration: const BoxDecoration(color: kRed, shape: BoxShape.circle),
                        )
                      : Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(color: kLine, shape: BoxShape.circle),
                        ),
                ),
              ),
          ],
        ),
    ];

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 780),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: phone ? 52 : 70),
            child: Text('Recipient', style: body(13, weight: FontWeight.w600)),
          ),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: <int, TableColumnWidth>{
              0: FixedColumnWidth(phone ? 52 : 70),
              for (var i = 1; i <= 8; i++) i: const FlexColumnWidth(),
            },
            children: [header, ...rows],
          ),
        ],
      ),
    );
  }
}

class EligibilityList extends StatelessWidget {
  const EligibilityList({super.key});

  static const List<List<String>> items = [
    ['Age', 'Between 18 and 65 years old.'],
    ['Weight', 'At least 50 kg.'],
    ['Health', 'Feeling well on the day, with no fever, cold or infection.'],
    ['Gap between donations', 'About 3 to 4 months between whole-blood donations.'],
    ['Before you go', 'Eat a proper meal, drink plenty of water and carry a photo ID.'],
  ];

  @override
  Widget build(BuildContext context) {
    final phone = isPhone(context);
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: kInk, width: 2)),
      ),
      child: Column(
        children: [
          for (final item in items)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: kLine)),
              ),
              child: phone
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item[0], style: display(21)),
                        const SizedBox(height: 4),
                        Text(item[1], style: body(16)),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 280, child: Text(item[0], style: display(22))),
                        Expanded(child: Text(item[1], style: body(17))),
                      ],
                    ),
            ),
        ],
      ),
    );
  }
}

class FaqList extends StatelessWidget {
  const FaqList({super.key});

  static const List<List<String>> faqs = [
    [
      'How long does a donation take?',
      'The donation itself usually takes 10 to 15 minutes. With registration, a quick health '
          'check and a rest afterwards, plan for about an hour.',
    ],
    [
      'Is donating blood safe?',
      'Yes. Blood banks use sterile, single-use equipment for every donor, and staff check '
          'your health before you donate.',
    ],
    [
      'How often can I donate?',
      'Whole-blood donors usually wait around 3 to 4 months between donations. Your blood '
          'bank will tell you what applies to you.',
    ],
    [
      'What should I do before donating?',
      'Eat a healthy meal, drink plenty of water, get a good night of sleep and carry a valid '
          'photo ID.',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: kInk, width: 2)),
        ),
        child: Column(
          children: [
            for (final faq in faqs)
              Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: kLine)),
                ),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: const EdgeInsets.only(bottom: 18, right: 24),
                  expandedAlignment: Alignment.centerLeft,
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  iconColor: kRed,
                  collapsedIconColor: kInk,
                  title: Text(faq[0], style: display(20, height: 1.25)),
                  children: [Text(faq[1], style: body(16.5))],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SiteShell(
      current: '/info',
      child: Column(
        children: [
          Section(
            color: kSoft,
            vertical: isPhone(context) ? 36 : 56,
            child: const SectionTitle(
              title: 'Know your blood group',
              text: 'Who can give to whom, who can donate, and what to expect on the day.',
            ),
          ),
          Section(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(
                  title: 'Who can give to whom',
                  text: 'A red dot means the donor group on the left can give to the recipient '
                      'group along the top.',
                ),
                const SizedBox(height: 28),
                const CompatibilityMatrix(),
                const SizedBox(height: 18),
                Text(
                  'O− can give to every group. AB+ can receive from every group.',
                  style: body(16, weight: FontWeight.w600, color: kInk),
                ),
              ],
            ),
          ),
          Section(
            color: kSoft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(title: 'Who can donate'),
                const SizedBox(height: 24),
                const EligibilityList(),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Text(
                    "These are general guidelines. The blood bank's medical team makes the final "
                    'decision on the day.',
                    style: body(14.5),
                  ),
                ),
              ],
            ),
          ),
          const Section(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(title: 'Common questions'),
                SizedBox(height: 24),
                FaqList(),
              ],
            ),
          ),
          const CtaBand(),
        ],
      ),
    );
  }
}