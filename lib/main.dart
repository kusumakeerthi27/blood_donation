import 'package:flutter/material.dart';

void main() {
  runApp(const BloodDonationApp());
}

// ======================= DATA =======================

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

  const BloodRequest({
    required this.patient,
    required this.bloodGroup,
    required this.units,
    required this.city,
    required this.contact,
  });
}

const List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

// In-memory storage shared by all pages (sample data, not real people)
final List<Donor> donors = [
  const Donor(name: 'Ravi Kumar', bloodGroup: 'O+', city: 'Hyderabad', phone: '9000000001'),
  const Donor(name: 'Anita Sharma', bloodGroup: 'A+', city: 'Delhi', phone: '9000000002'),
  const Donor(name: 'Suresh Reddy', bloodGroup: 'B+', city: 'Bengaluru', phone: '9000000003'),
  const Donor(name: 'Priya Nair', bloodGroup: 'O-', city: 'Chennai', phone: '9000000004'),
  const Donor(name: 'Imran Khan', bloodGroup: 'AB+', city: 'Mumbai', phone: '9000000005'),
  const Donor(name: 'Meena Iyer', bloodGroup: 'A-', city: 'Hyderabad', phone: '9000000006'),
];

final List<BloodRequest> requests = [];

// ======================= APP =======================

class BloodDonationApp extends StatelessWidget {
  const BloodDonationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeFlow Blood Donation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/donors': (context) => const DonorsPage(),
        '/register': (context) => const RegisterPage(),
        '/request': (context) => const RequestPage(),
        '/info': (context) => const InfoPage(),
      },
    );
  }
}

// ======================= SHARED WIDGETS =======================

/// Centers content and limits its width so the layout looks good on
/// phones, tablets and wide browser windows.
class PageBody extends StatelessWidget {
  final Widget child;
  const PageBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: child,
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Widget _item(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // close the drawer
        Navigator.pushNamedAndRemoveUntil(
          context,
          route,
          (r) => route == '/' ? false : r.isFirst,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.red.shade600),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.bloodtype, color: Colors.white, size: 44),
                SizedBox(height: 8),
                Text(
                  'LifeFlow',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Blood Donation Network',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          _item(context, Icons.home, 'Home', '/'),
          _item(context, Icons.people, 'Find Donors', '/donors'),
          _item(context, Icons.favorite, 'Become a Donor', '/register'),
          _item(context, Icons.emergency, 'Request Blood', '/request'),
          _item(context, Icons.info, 'Blood Facts', '/info'),
        ],
      ),
    );
  }
}

/// A form field that lets the user pick one blood group using chips.
class BloodGroupField extends FormField<String> {
  BloodGroupField({super.key, required FormFieldSetter<String> onSaved})
      : super(
          onSaved: onSaved,
          validator: (value) => value == null ? 'Please select a blood group' : null,
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Blood group',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: bloodGroups
                      .map(
                        (g) => ChoiceChip(
                          label: Text(g),
                          selected: state.value == g,
                          onSelected: (_) => state.didChange(g),
                        ),
                      )
                      .toList(),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      state.errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        );
}

// ======================= HOME PAGE =======================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LifeFlow')),
      drawer: const AppDrawer(),
      body: PageBody(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Hero banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade700, Colors.red.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.bloodtype, size: 72, color: Colors.white),
                    const SizedBox(height: 12),
                    const Text(
                      'Donate Blood, Save Lives',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Connect blood donors with people who urgently need them.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.white70),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/register'),
                          icon: const Icon(Icons.favorite),
                          label: const Text('Become a Donor'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.red.shade700,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/request'),
                          icon: const Icon(Icons.emergency),
                          label: const Text('Request Blood'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Stats row
              Row(
                children: [
                  Expanded(child: _StatTile(value: '${donors.length}', label: 'Registered Donors')),
                  const SizedBox(width: 10),
                  Expanded(child: _StatTile(value: '${bloodGroups.length}', label: 'Blood Groups')),
                  const SizedBox(width: 10),
                  const Expanded(child: _StatTile(value: '3', label: 'Lives per Donation')),
                ],
              ),
              const SizedBox(height: 24),

              // Action cards
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'What would you like to do?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              const Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  _ActionCard(
                    icon: Icons.people,
                    title: 'Find Donors',
                    subtitle: 'Search donors by blood group and city.',
                    route: '/donors',
                  ),
                  _ActionCard(
                    icon: Icons.favorite,
                    title: 'Become a Donor',
                    subtitle: 'Register in under a minute.',
                    route: '/register',
                  ),
                  _ActionCard(
                    icon: Icons.emergency,
                    title: 'Request Blood',
                    subtitle: 'Post an urgent blood requirement.',
                    route: '/request',
                  ),
                  _ActionCard(
                    icon: Icons.info,
                    title: 'Blood Facts',
                    subtitle: 'Eligibility and compatibility chart.',
                    route: '/info',
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  const _StatTile({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Navigator.pushNamed(context, route),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 34, color: Colors.red),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ======================= DONORS PAGE =======================

class DonorsPage extends StatefulWidget {
  const DonorsPage({super.key});

  @override
  State<DonorsPage> createState() => _DonorsPageState();
}

class _DonorsPageState extends State<DonorsPage> {
  String? _group; // null means "All"
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.toLowerCase();
    final results = donors.where((d) {
      final matchGroup = _group == null || d.bloodGroup == _group;
      final matchQuery = q.isEmpty ||
          d.name.toLowerCase().contains(q) ||
          d.city.toLowerCase().contains(q);
      return matchGroup && matchQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Find Donors')),
      drawer: const AppDrawer(),
      body: PageBody(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search by name or city',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => setState(() => _query = value),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('All'),
                        selected: _group == null,
                        onSelected: (_) => setState(() => _group = null),
                      ),
                      ...bloodGroups.map(
                        (g) => ChoiceChip(
                          label: Text(g),
                          selected: _group == g,
                          onSelected: (_) => setState(() => _group = g),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: results.isEmpty
                  ? const Center(child: Text('No donors found'))
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final d = results[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Text(
                                d.bloodGroup,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            title: Text(d.name),
                            subtitle: Text('${d.city}  •  ${d.phone}'),
                            trailing: const Icon(Icons.phone, color: Colors.green),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================= REGISTER PAGE =======================

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String? _group;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _cityCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    donors.add(
      Donor(
        name: _nameCtrl.text.trim(),
        bloodGroup: _group!,
        city: _cityCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thank you! You are now a registered donor.')),
    );
    Navigator.pushReplacementNamed(context, '/donors');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Become a Donor')),
      drawer: const AppDrawer(),
      body: PageBody(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Register as a donor',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Full name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _ageCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    prefixIcon: Icon(Icons.cake),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final age = int.tryParse(v ?? '');
                    if (age == null) return 'Enter a valid age';
                    if (age < 18 || age > 65) return 'Donors must be 18-65 years old';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                BloodGroupField(onSaved: (value) => _group = value),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _cityCtrl,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Enter your city' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final phone = (v ?? '').trim();
                    if (phone.length != 10 || int.tryParse(phone) == null) {
                      return 'Enter a 10-digit phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.favorite),
                    label: const Text('Register'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ======================= REQUEST PAGE =======================

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _patientCtrl = TextEditingController();
  final _unitsCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  String? _group;

  @override
  void dispose() {
    _patientCtrl.dispose();
    _unitsCtrl.dispose();
    _cityCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final city = _cityCtrl.text.trim();
    requests.add(
      BloodRequest(
        patient: _patientCtrl.text.trim(),
        bloodGroup: _group!,
        units: int.parse(_unitsCtrl.text.trim()),
        city: city,
        contact: _contactCtrl.text.trim(),
      ),
    );

    final matches = donors
        .where((d) =>
            d.bloodGroup == _group &&
            d.city.toLowerCase().contains(city.toLowerCase()))
        .toList();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Request submitted'),
        content: matches.isEmpty
            ? const Text(
                'No matching donors in this city yet. Try searching all donors by blood group.')
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${matches.length} matching donor(s) found:'),
                  const SizedBox(height: 10),
                  ...matches.map((d) => Text('• ${d.name} - ${d.phone}')),
                ],
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Blood')),
      drawer: const AppDrawer(),
      body: PageBody(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Post a blood requirement',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _patientCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Patient name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Enter patient name' : null,
                ),
                const SizedBox(height: 14),
                BloodGroupField(onSaved: (value) => _group = value),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _unitsCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Units required',
                    prefixIcon: Icon(Icons.water_drop),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final units = int.tryParse(v ?? '');
                    if (units == null || units < 1) return 'Enter at least 1 unit';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _cityCtrl,
                  decoration: const InputDecoration(
                    labelText: 'City / Hospital location',
                    prefixIcon: Icon(Icons.local_hospital),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Enter a city' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _contactCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Contact number',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final phone = (v ?? '').trim();
                    if (phone.length != 10 || int.tryParse(phone) == null) {
                      return 'Enter a 10-digit phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.send),
                    label: const Text('Submit Request'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ======================= INFO PAGE =======================

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  static const List<List<String>> _compatibility = [
    ['O-', 'All groups'],
    ['O+', 'O+, A+, B+, AB+'],
    ['A-', 'A-, A+, AB-, AB+'],
    ['A+', 'A+, AB+'],
    ['B-', 'B-, B+, AB-, AB+'],
    ['B+', 'B+, AB+'],
    ['AB-', 'AB-, AB+'],
    ['AB+', 'AB+'],
  ];

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.red, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blood Facts')),
      drawer: const AppDrawer(),
      body: PageBody(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Who can donate?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _bullet('Age between 18 and 65 years'),
              _bullet('Weight of at least 50 kg'),
              _bullet('Good general health on the day of donation'),
              _bullet('A gap of at least 3 months between whole-blood donations'),
              const SizedBox(height: 6),
              const Text(
                'Guidelines can vary, so always confirm with your local blood bank.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              const Text(
                'Who can donate to whom?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Card(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStatePropertyAll(Colors.red.shade50),
                    columns: const [
                      DataColumn(label: Text('Donor group')),
                      DataColumn(label: Text('Can donate to')),
                    ],
                    rows: _compatibility
                        .map(
                          (row) => DataRow(
                            cells: [
                              DataCell(Text(
                                row[0],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              )),
                              DataCell(Text(row[1])),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  icon: const Icon(Icons.favorite),
                  label: const Text('Become a Donor'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}