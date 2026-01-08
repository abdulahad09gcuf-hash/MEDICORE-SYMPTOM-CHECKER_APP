import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MediCoreApp());
}

/* =========================
   LANGUAGE STRINGS
========================= */
class AppStrings {
  static Map<String, String> english = {
    'app_title': 'MediCore',
    'welcome': 'Welcome',
    'login': 'Login',
    'signup': 'Sign Up',
    'email': 'Email',
    'password': 'Password',
    'name': 'Name',
    'age': 'Age',
    'weight': 'Weight (kg)',
    'height': 'Height (cm)',
    'gender': 'Gender',
    'male': 'Male',
    'female': 'Female',
    'other': 'Other',
    'create_account': 'Create Account',
    'account_created': 'Account Created! Login Now',
    'invalid_credentials': 'Invalid email or password',
    'home': 'Home',
    'symptoms': 'Symptoms',
    'diagnosis': 'Diagnosis',
    'records': 'Records',
    'checkup': 'Checkup',
    'profile': 'Profile',
    'stats': 'Stats',
    'select_symptoms': 'Select Symptoms',
    'risk_level': 'Risk Level',
    'next_step': 'Next Step',
    'prescription': 'Prescription',
    'meal_plan': 'Meal Plan',
    'medical_records': 'Medical Records',
    'no_records': 'No records available',
    'delete': 'Delete',
    'delete_all': 'Delete All',
    'confirm_delete': 'Delete this record?',
    'confirm_delete_all': 'Delete ALL records?',
    'cancel': 'Cancel',
    'logout': 'Logout',
    'bmi_calculator': 'BMI Calculator',
    'blood_pressure': 'Blood Pressure',
    'heart_rate': 'Heart Rate',
    'temperature': 'Temperature',
    'calculate': 'Calculate BMI',
    'check_bp': 'Check BP',
    'check_hr': 'Check Heart Rate',
    'check_temp': 'Check Temperature',
    'result': 'Result',
    'health_stats': 'Health Stats',
    'no_data': 'No data available',
    'symptoms_over_time': 'Symptoms Count Over Time',
    'risk_distribution': 'Risk Level Distribution',
    'recent_timeline': 'Recent Diagnosis Timeline',
    'language': 'Language',
    'clear_all_records': 'Clear All Records',
    'records_cleared': 'All records cleared',
    'english': 'English',
    'urdu': 'Urdu',
  };

  static Map<String, String> urdu = {
    'app_title': 'میڈی کور',
    'welcome': 'خوش آمدید',
    'login': 'لاگ ان',
    'signup': 'سائن اپ',
    'email': 'ای میل',
    'password': 'پاس ورڈ',
    'name': 'نام',
    'age': 'عمر',
    'weight': 'وزن (کلوگرام)',
    'height': 'قد (سینٹی میٹر)',
    'gender': 'جنس',
    'male': 'مرد',
    'female': 'عورت',
    'other': 'دیگر',
    'create_account': 'اکاؤنٹ بنائیں',
    'account_created': 'اکاؤنٹ بن گیا! اب لاگ ان کریں',
    'invalid_credentials': 'غلط ای میل یا پاس ورڈ',
    'home': 'ہوم',
    'symptoms': 'علامات',
    'diagnosis': 'تشخیص',
    'records': 'ریکارڈ',
    'checkup': 'چیک اپ',
    'profile': 'پروفائل',
    'stats': 'اعداد و شمار',
    'select_symptoms': 'علامات منتخب کریں',
    'risk_level': 'خطرے کی سطح',
    'next_step': 'اگلا قدم',
    'prescription': 'نسخہ',
    'meal_plan': 'کھانے کا منصوبہ',
    'medical_records': 'طبی ریکارڈ',
    'no_records': 'کوئی ریکارڈ دستیاب نہیں',
    'delete': 'حذف کریں',
    'delete_all': 'سب حذف کریں',
    'confirm_delete': 'یہ ریکارڈ حذف کریں؟',
    'confirm_delete_all': 'سب ریکارڈ حذف کریں؟',
    'cancel': 'منسوخ کریں',
    'logout': 'لاگ آؤٹ',
    'bmi_calculator': 'بی ایم آئی کیلکولیٹر',
    'blood_pressure': 'بلڈ پریشر',
    'heart_rate': 'دل کی دھڑکن',
    'temperature': 'درجہ حرارت',
    'calculate': 'بی ایم آئی کا حساب لگائیں',
    'check_bp': 'بی پی چیک کریں',
    'check_hr': 'دل کی دھڑکن چیک کریں',
    'check_temp': 'درجہ حرارت چیک کریں',
    'result': 'نتیجہ',
    'health_stats': 'صحت کے اعداد و شمار',
    'no_data': 'کوئی ڈیٹا دستیاب نہیں',
    'symptoms_over_time': 'وقت کے ساتھ علامات کی تعداد',
    'risk_distribution': 'خطرے کی سطح کی تقسیم',
    'recent_timeline': 'حالیہ تشخیص کی ٹائم لائن',
    'language': 'زبان',
    'clear_all_records': 'تمام ریکارڈ صاف کریں',
    'records_cleared': 'تمام ریکارڈ صاف ہو گئے',
    'english': 'انگریزی',
    'urdu': 'اردو',
  };

  static String get(String key, bool isUrdu) {
    return isUrdu ? (urdu[key] ?? key) : (english[key] ?? key);
  }
}

/* =========================
   APP ROOT - UPDATED COLORS
========================= */
class MediCoreApp extends StatefulWidget {
  const MediCoreApp({super.key});

  @override
  State<MediCoreApp> createState() => _MediCoreAppState();
}

class _MediCoreAppState extends State<MediCoreApp> {
  bool isUrdu = false;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => isUrdu = prefs.getBool('isUrdu') ?? false);
  }

  void toggleLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => isUrdu = !isUrdu);
    await prefs.setBool('isUrdu', isUrdu);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediCore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // CHANGED: Updated to indigo-blue gradient theme
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          primary: Colors.indigo,
          secondary: Colors.blueAccent,
          background: const Color(0xFFF5F7FA),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ),
      home: AuthGate(isUrdu: isUrdu, onLanguageToggle: toggleLanguage),
    );
  }
}

/* =========================
   AUTH GATE
========================= */
class AuthGate extends StatefulWidget {
  final bool isUrdu;
  final VoidCallback onLanguageToggle;

  const AuthGate({super.key, required this.isUrdu, required this.onLanguageToggle});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool loggedIn = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => loggedIn = prefs.getBool('loggedIn') ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return loggedIn 
        ? Dashboard(isUrdu: widget.isUrdu, onLanguageToggle: widget.onLanguageToggle) 
        : LoginScreen(isUrdu: widget.isUrdu, onLanguageToggle: widget.onLanguageToggle);
  }
}

/* =========================
   SIGNUP - UPDATED COLORS
========================= */
class SignupScreen extends StatefulWidget {
  final bool isUrdu;

  const SignupScreen({super.key, required this.isUrdu});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final age = TextEditingController();
  final weight = TextEditingController();
  final height = TextEditingController();
  String gender = 'Male';
  String? imagePath;

  final picker = ImagePicker();

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => imagePath = picked.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.get('create_account', widget.isUrdu))),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade50, Colors.blue.shade50],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.indigo, Colors.blueAccent],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: imagePath != null 
                    ? ClipOval(
                        child: Image.file(File(imagePath!), fit: BoxFit.cover),
                      )
                    : Icon(Icons.add_a_photo, size: 40, color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),
              _field(name, AppStrings.get('name', widget.isUrdu)),
              _field(email, AppStrings.get('email', widget.isUrdu)),
              _field(password, AppStrings.get('password', widget.isUrdu), obscure: true),
              _field(age, AppStrings.get('age', widget.isUrdu), inputType: TextInputType.number),
              _field(weight, AppStrings.get('weight', widget.isUrdu), inputType: TextInputType.number),
              _field(height, AppStrings.get('height', widget.isUrdu), inputType: TextInputType.number),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonFormField<String>(
                    value: gender,
                    items: ['Male', 'Female', 'Other']
                        .map((g) => DropdownMenuItem(
                            value: g,
                            child: Text(g == 'Male'
                                ? AppStrings.get('male', widget.isUrdu)
                                : g == 'Female'
                                    ? AppStrings.get('female', widget.isUrdu)
                                    : AppStrings.get('other', widget.isUrdu))))
                        .toList(),
                    onChanged: (v) => setState(() => gender = v!),
                    decoration: InputDecoration(
                      labelText: AppStrings.get('gender', widget.isUrdu),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.indigo),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo, Colors.blueAccent],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('name', name.text);
                    await prefs.setString('email', email.text);
                    await prefs.setString('password', password.text);
                    await prefs.setString('age', age.text);
                    await prefs.setString('weight', weight.text);
                    await prefs.setString('height', height.text);
                    await prefs.setString('gender', gender);
                    if (imagePath != null) {
                      await prefs.setString('profilePic', imagePath!);
                    }
                    await prefs.setBool('loggedIn', false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.indigo,
                        content: Text(
                          AppStrings.get('account_created', widget.isUrdu),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => LoginScreen(isUrdu: widget.isUrdu, onLanguageToggle: () {})));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppStrings.get('signup', widget.isUrdu),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/* =========================
   LOGIN - UPDATED COLORS & IMPROVED TOGGLE
========================= */
class LoginScreen extends StatefulWidget {
  final bool isUrdu;
  final VoidCallback onLanguageToggle;

  const LoginScreen({super.key, required this.isUrdu, required this.onLanguageToggle});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(24),
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${AppStrings.get('app_title', widget.isUrdu)}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                      // IMPROVED: Better language toggle button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.language, color: Colors.white),
                              onPressed: widget.onLanguageToggle,
                              tooltip: AppStrings.get('language', widget.isUrdu),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                widget.isUrdu ? 'اردو' : 'ENG',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.get('login', widget.isUrdu),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _field(email, AppStrings.get('email', widget.isUrdu)),
                  _field(password, AppStrings.get('password', widget.isUrdu), obscure: true),
                  if (error.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(error, style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo, Colors.blueAccent],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final savedEmail = prefs.getString('email');
                        final savedPassword = prefs.getString('password');
                        if (email.text == savedEmail && password.text == savedPassword) {
                          await prefs.setBool('loggedIn', true);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Dashboard(
                                      isUrdu: widget.isUrdu,
                                      onLanguageToggle: widget.onLanguageToggle)));
                        } else {
                          setState(() {
                            error = AppStrings.get('invalid_credentials', widget.isUrdu);
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppStrings.get('login', widget.isUrdu),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SignupScreen(isUrdu: widget.isUrdu)),
                      );
                    },
                    child: Text(
                      AppStrings.get('create_account', widget.isUrdu),
                      style: TextStyle(color: Colors.indigo),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* =========================
   DASHBOARD - UPDATED COLORS
========================= */
class Dashboard extends StatefulWidget {
  final bool isUrdu;
  final VoidCallback onLanguageToggle;

  const Dashboard({super.key, required this.isUrdu, required this.onLanguageToggle});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(isUrdu: widget.isUrdu),
      SymptomScreen(isUrdu: widget.isUrdu),
      DiagnosisScreen(isUrdu: widget.isUrdu),
      RecordsScreen(isUrdu: widget.isUrdu),
      MedicalCheckupScreen(isUrdu: widget.isUrdu),
      ProfileScreen(isUrdu: widget.isUrdu, onLanguageToggle: widget.onLanguageToggle),
      HealthStatsScreen(isUrdu: widget.isUrdu),
    ];

    return Scaffold(
      body: screens[index],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) => setState(() => index = i),
          backgroundColor: Colors.white,
          indicatorColor: Colors.indigo.shade100,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
                icon: Icon(Icons.home, color: index == 0 ? Colors.indigo : Colors.grey),
                label: AppStrings.get('home', widget.isUrdu)),
            NavigationDestination(
                icon: Icon(Icons.healing, color: index == 1 ? Colors.indigo : Colors.grey),
                label: AppStrings.get('symptoms', widget.isUrdu)),
            NavigationDestination(
                icon: Icon(Icons.analytics, color: index == 2 ? Colors.indigo : Colors.grey),
                label: AppStrings.get('diagnosis', widget.isUrdu)),
            NavigationDestination(
                icon: Icon(Icons.folder, color: index == 3 ? Colors.indigo : Colors.grey),
                label: AppStrings.get('records', widget.isUrdu)),
            NavigationDestination(
                icon: Icon(Icons.medical_services, color: index == 4 ? Colors.indigo : Colors.grey),
                label: AppStrings.get('checkup', widget.isUrdu)),
            NavigationDestination(
                icon: Icon(Icons.person, color: index == 5 ? Colors.indigo : Colors.grey),
                label: AppStrings.get('profile', widget.isUrdu)),
            NavigationDestination(
                icon: Icon(Icons.show_chart, color: index == 6 ? Colors.indigo : Colors.grey),
                label: AppStrings.get('stats', widget.isUrdu)),
          ],
        ),
      ),
    );
  }
}

/* =========================
   HOME - UPDATED COLORS
========================= */
class HomeScreen extends StatelessWidget {
  final bool isUrdu;

  const HomeScreen({super.key, required this.isUrdu});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (_, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator(color: Colors.indigo));
        final prefs = snap.data as SharedPreferences;
        final name = prefs.getString('name') ?? '';
        return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.get('app_title', isUrdu)),
            centerTitle: true,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade50, Colors.blue.shade50],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.indigo, Colors.blueAccent],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(Icons.medical_services, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    '${AppStrings.get('welcome', isUrdu)}, $name!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Your Health Companion',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/* =========================
   SYMPTOMS - UPDATED COLORS
========================= */
class SymptomScreen extends StatefulWidget {
  final bool isUrdu;

  const SymptomScreen({super.key, required this.isUrdu});

  @override
  State<SymptomScreen> createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen> {
  final symptoms = [
    'Fever', 'Cough', 'Headache', 'Fatigue', 'Body Pain',
    'Chest Pain', 'Shortness of Breath', 'Vomiting', 'Diarrhea',
    'Dizziness', 'Sore Throat', 'Cold', 'Loss of Taste', 'Loss of Smell',
    'Back Pain', 'Joint Pain', 'Anxiety', 'Depression', 'High BP', 'Low BP'
  ];
  final selected = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.get('select_symptoms', widget.isUrdu))),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade50, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            itemCount: symptoms.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.5,
            ),
            itemBuilder: (_, i) {
              final s = symptoms[i];
              final selectedFlag = selected.contains(s);
              return GestureDetector(
                onTap: () async {
                  setState(() => selectedFlag ? selected.remove(s) : selected.add(s));
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setStringList('symptoms', selected);
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    gradient: selectedFlag
                        ? LinearGradient(
                            colors: [Colors.indigo, Colors.blueAccent],
                          )
                        : LinearGradient(
                            colors: [Colors.white, Colors.grey.shade100],
                          ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: selectedFlag ? Colors.indigo : Colors.grey.shade300, width: 2),
                    boxShadow: selectedFlag
                        ? [
                            BoxShadow(
                              color: Colors.indigo.withOpacity(0.3),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    s,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedFlag ? Colors.white : Colors.indigo),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/* =========================
   HEALTH RISK ENGINE
========================= */
class HealthRiskEngine {
  static String riskLevel(List<String> symptoms) {
    if (symptoms.contains('Chest Pain') || symptoms.contains('Shortness of Breath')) {
      return 'HIGH RISK';
    }
    if (symptoms.length >= 5) {
      return 'MEDIUM RISK';
    }
    return 'LOW RISK';
  }

  static String nextStep(String risk) {
    switch (risk) {
      case 'HIGH RISK':
        return 'Seek medical help immediately';
      case 'MEDIUM RISK':
        return 'Consult a doctor within 24 hours';
      default:
        return 'Home care & observation advised';
    }
  }
}

/* =========================
   DIAGNOSIS - UPDATED COLORS
========================= */
class DiagnosisScreen extends StatelessWidget {
  final bool isUrdu;

  const DiagnosisScreen({super.key, required this.isUrdu});

  String diagnose(List<String> s) {
    if (s.contains('Fever') && s.contains('Cough')) return 'Flu / Viral Infection';
    if (s.contains('Chest Pain')) return 'Heart-related issue';
    if (s.contains('High BP')) return 'Hypertension';
    if (s.contains('Low BP')) return 'Low Blood Pressure';
    if (s.contains('Anxiety')) return 'Mental Stress';
    return 'General Illness';
  }

  static const Map<String, Map<String, String>> prescriptionMeals = {
    'Flu / Viral Infection': {
      'Prescription': 'Paracetamol, Vitamin C',
      'Meal': 'Soup, Fruits, Hydration',
    },
    'Heart-related issue': {
      'Prescription': 'Consult Doctor Immediately',
      'Meal': 'Low Sodium Diet',
    },
    'Hypertension': {
      'Prescription': 'BP Medicine, Consult Doctor',
      'Meal': 'Low Salt, Vegetables',
    },
    'Low Blood Pressure': {
      'Prescription': 'Fluids, Salt Intake',
      'Meal': 'Light Meals, Hydration',
    },
    'Mental Stress': {
      'Prescription': 'Relaxation, Meditation',
      'Meal': 'Healthy Snacks, Hydration',
    },
    'General Illness': {
      'Prescription': 'Rest, Hydration',
      'Meal': 'Fruits, Soup',
    },
  };

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (_, snap) {
        if (!snap.hasData) return Center(child: CircularProgressIndicator(color: Colors.indigo));
        final prefs = snap.data as SharedPreferences;
        final s = prefs.getStringList('symptoms') ?? [];
        final result = diagnose(s);
        prefs.setString('diagnosis', result);

        final prescription = prescriptionMeals[result]?['Prescription'] ?? '';
        final meal = prescriptionMeals[result]?['Meal'] ?? '';

        final risk = HealthRiskEngine.riskLevel(s);
        final next = HealthRiskEngine.nextStep(risk);

        final history = prefs.getStringList('history') ?? [];
        history.add('${DateTime.now()} | ${s.join(", ")} | $result | $risk');
        prefs.setStringList('history', history);

        return Scaffold(
          appBar: AppBar(title: Text(AppStrings.get('diagnosis', isUrdu))),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade50, Colors.blue.shade50],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _infoCard(AppStrings.get('diagnosis', isUrdu), result,
                      icon: Icons.medical_services),
                  _infoCard(AppStrings.get('risk_level', isUrdu), risk,
                      color: risk == 'HIGH RISK'
                          ? Colors.red.shade50
                          : risk == 'MEDIUM RISK'
                              ? Colors.orange.shade50
                              : Colors.green.shade50,
                      icon: Icons.warning),
                  _infoCard(AppStrings.get('next_step', isUrdu), next,
                      icon: Icons.navigate_next),
                  _infoCard(AppStrings.get('prescription', isUrdu), prescription,
                      icon: Icons.description),
                  _infoCard(AppStrings.get('meal_plan', isUrdu), meal,
                      icon: Icons.restaurant),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _infoCard(String title, String content, {Color? color, IconData? icon}) {
    return Card(
      color: color ?? Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.indigo),
              ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo)),
                  const SizedBox(height: 6),
                  Text(content,
                      style: TextStyle(fontSize: 16, color: Colors.grey[800])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* =========================
   RECORDS WITH DELETE & CLEAR ALL - UPDATED COLORS
========================= */
class RecordsScreen extends StatefulWidget {
  final bool isUrdu;

  const RecordsScreen({super.key, required this.isUrdu});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      history = prefs.getStringList('history') ?? [];
    });
  }

  Future<void> _deleteRecord(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.get('confirm_delete', widget.isUrdu)),
        icon: Icon(Icons.delete, color: Colors.red),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppStrings.get('cancel', widget.isUrdu)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.shade50,
            ),
            child: Text(
              AppStrings.get('delete', widget.isUrdu),
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        history.removeAt(index);
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('history', history);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Record deleted'),
        ),
      );
    }
  }

  Future<void> _clearAllRecords() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.get('confirm_delete_all', widget.isUrdu)),
        content: Text('This will delete ALL your medical records.'),
        icon: Icon(Icons.warning, color: Colors.orange),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppStrings.get('cancel', widget.isUrdu)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.shade50,
            ),
            child: Text(
              AppStrings.get('delete_all', widget.isUrdu),
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        history.clear();
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('history', []);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(AppStrings.get('records_cleared', widget.isUrdu)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get('medical_records', widget.isUrdu)),
        actions: [
          if (history.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_sweep),
              onPressed: _clearAllRecords,
              tooltip: AppStrings.get('clear_all_records', widget.isUrdu),
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade50, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: history.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.folder_open, size: 80, color: Colors.indigo.shade300),
                    SizedBox(height: 20),
                    Text(
                      AppStrings.get('no_records', widget.isUrdu),
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: history.length,
                itemBuilder: (_, i) {
                  return Card(
                    margin: EdgeInsets.only(bottom: 12),
                    elevation: 3,
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.medical_services, color: Colors.indigo),
                      ),
                      title: Text(
                        history[i].split('|')[2].trim(),
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                      subtitle: Text(history[i].split('|')[0].trim()),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteRecord(i),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

/* =========================
   PROFILE - UPDATED COLORS & IMPROVED TOGGLE
========================= */
class ProfileScreen extends StatelessWidget {
  final bool isUrdu;
  final VoidCallback onLanguageToggle;

  const ProfileScreen({super.key, required this.isUrdu, required this.onLanguageToggle});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (_, snap) {
        if (!snap.hasData) return Center(child: CircularProgressIndicator(color: Colors.indigo));
        final prefs = snap.data as SharedPreferences;
        final name = prefs.getString('name') ?? '';
        final email = prefs.getString('email') ?? '';
        final age = prefs.getString('age') ?? '';
        final weight = prefs.getString('weight') ?? '';
        final height = prefs.getString('height') ?? '';
        final gender = prefs.getString('gender') ?? '';
        final profilePic = prefs.getString('profilePic');

        return Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.get('profile', isUrdu)),
            actions: [
              // IMPROVED: Better language toggle
              Container(
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.indigo),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.language, color: Colors.indigo),
                      onPressed: onLanguageToggle,
                      tooltip: AppStrings.get('language', isUrdu),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        isUrdu ? 'اردو' : 'ENG',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade50, Colors.blue.shade50],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (profilePic != null)
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.indigo, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.file(File(profilePic!), fit: BoxFit.cover),
                      ),
                    ),
                  if (profilePic == null)
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.indigo, Colors.blueAccent],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                  const SizedBox(height: 20),
                  _infoCard(AppStrings.get('name', isUrdu), name, icon: Icons.person),
                  _infoCard(AppStrings.get('email', isUrdu), email, icon: Icons.email),
                  _infoCard(AppStrings.get('age', isUrdu), age, icon: Icons.calendar_today),
                  _infoCard(AppStrings.get('gender', isUrdu), gender, icon: Icons.transgender),
                  _infoCard(AppStrings.get('weight', isUrdu), weight, icon: Icons.monitor_weight),
                  _infoCard(AppStrings.get('height', isUrdu), height, icon: Icons.height),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red, Colors.orange],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => LoginScreen(
                                    isUrdu: isUrdu, onLanguageToggle: () {})));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppStrings.get('logout', isUrdu),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _infoCard(String title, String content, {IconData? icon}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      elevation: 4,
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (icon != null)
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.indigo, size: 20),
              ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* =========================
   MEDICAL CHECKUP TOOLS - UPDATED COLORS
========================= */
class MedicalCheckupScreen extends StatefulWidget {
  final bool isUrdu;

  const MedicalCheckupScreen({super.key, required this.isUrdu});

  @override
  State<MedicalCheckupScreen> createState() => _MedicalCheckupScreenState();
}

class _MedicalCheckupScreenState extends State<MedicalCheckupScreen> {
  final weight = TextEditingController();
  final height = TextEditingController();
  final systolic = TextEditingController();
  final diastolic = TextEditingController();
  final bpm = TextEditingController();
  final temp = TextEditingController();

  String bmiResult = '';
  String bpResult = '';
  String hrResult = '';
  String tempResult = '';

  void calculateBMI() {
    final w = double.tryParse(weight.text);
    final h = double.tryParse(height.text);
    if (w != null && h != null && h > 0) {
      final bmi = w / ((h / 100) * (h / 100));
      bmiResult = bmi < 18.5
          ? 'Underweight'
          : bmi < 25
              ? 'Normal'
              : bmi < 30
                  ? 'Overweight'
                  : 'Obese';
    }
  }

  void checkBP() {
    final s = int.tryParse(systolic.text);
    final d = int.tryParse(diastolic.text);
    if (s != null && d != null) {
      bpResult = s >= 140 || d >= 90
          ? 'High BP'
          : s <= 90 || d <= 60
              ? 'Low BP'
              : 'Normal BP';
    }
  }

  void checkHR() {
    final h = int.tryParse(bpm.text);
    if (h != null) {
      hrResult = h < 60
          ? 'Low Heart Rate'
          : h > 100
              ? 'High Heart Rate'
              : 'Normal Heart Rate';
    }
  }

  void checkTemp() {
    final t = double.tryParse(temp.text);
    if (t != null) {
      tempResult = t >= 38
          ? 'Fever'
          : t < 36
              ? 'Low Temperature'
              : 'Normal Temperature';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.get('checkup', widget.isUrdu))),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade50, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _toolCard(
                title: AppStrings.get('bmi_calculator', widget.isUrdu),
                icon: Icons.monitor_weight,
                color: Colors.purple.shade50,
                children: [
                  _field(weight, AppStrings.get('weight', widget.isUrdu),
                      inputType: TextInputType.number),
                  _field(height, AppStrings.get('height', widget.isUrdu),
                      inputType: TextInputType.number),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () => setState(() => calculateBMI()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                    child: Text(AppStrings.get('calculate', widget.isUrdu)),
                  ),
                  if (bmiResult.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${AppStrings.get('result', widget.isUrdu)}: $bmiResult',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              _toolCard(
                title: AppStrings.get('blood_pressure', widget.isUrdu),
                icon: Icons.heart_broken,
                color: Colors.red.shade50,
                children: [
                  _field(systolic, 'Systolic', inputType: TextInputType.number),
                  _field(diastolic, 'Diastolic', inputType: TextInputType.number),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () => setState(() => checkBP()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                    child: Text(AppStrings.get('check_bp', widget.isUrdu)),
                  ),
                  if (bpResult.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${AppStrings.get('result', widget.isUrdu)}: $bpResult',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              _toolCard(
                title: AppStrings.get('heart_rate', widget.isUrdu),
                icon: Icons.favorite,
                color: Colors.pink.shade50,
                children: [
                  _field(bpm, 'BPM', inputType: TextInputType.number),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () => setState(() => checkHR()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                    child: Text(AppStrings.get('check_hr', widget.isUrdu)),
                  ),
                  if (hrResult.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${AppStrings.get('result', widget.isUrdu)}: $hrResult',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              _toolCard(
                title: AppStrings.get('temperature', widget.isUrdu),
                icon: Icons.thermostat,
                color: Colors.orange.shade50,
                children: [
                  _field(temp, '°C', inputType: TextInputType.number),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () => setState(() => checkTemp()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                    child: Text(AppStrings.get('check_temp', widget.isUrdu)),
                  ),
                  if (tempResult.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${AppStrings.get('result', widget.isUrdu)}: $tempResult',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toolCard({required String title, required List<Widget> children, required IconData icon, required Color color}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: color,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.indigo),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo)),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ...children,
          ],
        ),
      ),
    );
  }
}

/* =========================
   HEALTH STATS SCREEN - UPDATED COLORS
========================= */
class HealthStatsScreen extends StatefulWidget {
  final bool isUrdu;

  const HealthStatsScreen({super.key, required this.isUrdu});

  @override
  State<HealthStatsScreen> createState() => _HealthStatsScreenState();
}

class _HealthStatsScreenState extends State<HealthStatsScreen> {
  List<String> history = [];
  List<Map<String, dynamic>> parsedHistory = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    history = prefs.getStringList('history') ?? [];

    parsedHistory = history.map((entry) {
      final parts = entry.split('|').map((e) => e.trim()).toList();
      return {
        'date': DateTime.tryParse(parts[0]) ?? DateTime.now(),
        'symptoms': parts.length > 1
            ? parts[1].split(',').map((e) => e.trim()).toList()
            : [],
        'diagnosis': parts.length > 2 ? parts[2] : 'Unknown',
        'risk': parts.length > 3 ? parts[3] : 'LOW RISK',
        'symptomCount': parts.length > 1 ? parts[1].split(',').length : 0
      };
    }).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (parsedHistory.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(AppStrings.get('health_stats', widget.isUrdu))),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo.shade50, Colors.blue.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.analytics, size: 80, color: Colors.indigo.shade300),
                SizedBox(height: 20),
                Text(
                  AppStrings.get('no_data', widget.isUrdu),
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.get('health_stats', widget.isUrdu))),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade50, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(AppStrings.get('symptoms_over_time', widget.isUrdu),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 250,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: true),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                 // ...existing code...
getTitlesWidget: (double value, TitleMeta meta) {
  int index = value.toInt();
  if (index >= parsedHistory.length) return const Text('');
  final date = parsedHistory[index]['date'] as DateTime;
  return SideTitleWidget(
    meta: meta,
    child: Text('${date.month}/${date.day}'),
  );
},
// ...existing code...
                                ),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(
                                  parsedHistory.length,
                                  (index) => FlSpot(
                                      index.toDouble(),
                                      (parsedHistory[index]['symptomCount'] as int)
                                          .toDouble()),
                                ),
                                isCurved: true,
                                color: Colors.indigo,
                                barWidth: 3,
                                dotData: FlDotData(show: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(AppStrings.get('risk_distribution', widget.isUrdu),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 250,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: parsedHistory.length.toDouble(),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  // ...existing code...
getTitlesWidget: (double value, TitleMeta meta) {
  final labels = ['LOW', 'MEDIUM', 'HIGH'];
  if (value.toInt() < labels.length) {
    return SideTitleWidget(
      meta: meta,
      child: Text(labels[value.toInt()]),
    );
  }
  return const Text('');
},
// ...existing code...
                                ),
                              ),
                            ),
                            barGroups: [
                              BarChartGroupData(x: 0, barRods: [
                                BarChartRodData(
                                  toY: parsedHistory
                                      .where((e) => e['risk'] == 'LOW RISK')
                                      .length
                                      .toDouble(),
                                  color: Colors.green,
                                )
                              ]),
                              BarChartGroupData(x: 1, barRods: [
                                BarChartRodData(
                                  toY: parsedHistory
                                      .where((e) => e['risk'] == 'MEDIUM RISK')
                                      .length
                                      .toDouble(),
                                  color: Colors.orange,
                                )
                              ]),
                              BarChartGroupData(x: 2, barRods: [
                                BarChartRodData(
                                  toY: parsedHistory
                                      .where((e) => e['risk'] == 'HIGH RISK')
                                      .length
                                      .toDouble(),
                                  color: Colors.red,
                                )
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.get('recent_timeline', widget.isUrdu),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
                      const SizedBox(height: 12),
                      ...parsedHistory.reversed.map((entry) => Card(
                            margin: EdgeInsets.only(bottom: 8),
                            color: entry['risk'] == 'HIGH RISK'
                                ? Colors.red.shade50
                                : entry['risk'] == 'MEDIUM RISK'
                                    ? Colors.orange.shade50
                                    : Colors.green.shade50,
                            child: ListTile(
                              leading: Icon(
                                Icons.medical_services,
                                color: Colors.indigo,
                              ),
                              title: Text(
                                entry['diagnosis'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  '${entry['date'].toString().split(' ')[0]} | Risk: ${entry['risk']}'),
                            ),
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/* =========================
   INPUT FIELD HELPER - UPDATED COLORS
========================= */
Widget _field(TextEditingController c, String label,
    {bool obscure = false, TextInputType inputType = TextInputType.text}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: c,
      obscureText: obscure,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.indigo.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.indigo, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    ),
  );
}