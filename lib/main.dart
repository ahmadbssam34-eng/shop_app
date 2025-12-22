import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/* =========================
   CONFIG
   ========================= */

// ✅ Logo
const String kHerzLogoPath = 'assets/images/herz_logo_v2.png';
const double kLogoHeight = 240;

// ✅ Realtime Database URL
const String kDatabaseUrl =
    'https://herz-210384-default-rtdb.europe-west1.firebasedatabase.app';

// ✅ Paths
const String kProductsPath = 'products';
const String kOrdersPath = 'orders';
const String kPurchasesPath = 'purchases';
const String kRolesPath = 'roles';
const String kUsersPath = 'users';
const String kUsersByEmailPath = 'usersByEmail';
const String kUsersByPhonePath = 'usersByPhone';
const String kMailQueuePath = 'mailQueue';

/* =========================
   GLOBAL SNACKBAR (fix unmounted context)
   ========================= */

final GlobalKey<ScaffoldMessengerState> kMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void snackMsg(String msg) {
  final ms = kMessengerKey.currentState;
  if (ms == null) return;
  ms.hideCurrentSnackBar();
  ms.showSnackBar(SnackBar(content: Text(msg)));
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartModel()),
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: const MyApp(),
    ),
  );
}

/* =========================
   APP STATE + LOCALIZATION
   ========================= */

class AppState extends ChangeNotifier {
  Locale _locale = const Locale('ar');
  bool _isAdmin = false;

  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';
  bool get isAdmin => _isAdmin;

  void toggleLocale() {
    _locale = isArabic ? const Locale('en') : const Locale('ar');
    notifyListeners();
  }

  void setAdmin(bool v) {
    _isAdmin = v;
    notifyListeners();
  }

  String t(String key) => AppStrings.t(_locale.languageCode, key);
}

class AppStrings {
  static const Map<String, Map<String, String>> _m = {
    'ar': {
      'app_title': 'Shop',
      'login': 'تسجيل الدخول',
      'register': 'إنشاء حساب',
      'email': 'البريد الإلكتروني (Email)',
      'password': 'كلمة السر (Password)',
      'confirm_password': 'إعادة كلمة السر',
      'first_name': 'الاسم الأول',
      'last_name': 'الاسم الأخير',
      'phone': 'رقم الهاتف',
      'login_btn': 'دخول',
      'create_btn': 'إنشاء الحساب',
      'forgot': 'نسيت كلمة السر؟',
      'google': 'التسجيل باستخدام Google',
      'phone_login': 'الدخول باستخدام رقم الهاتف',
      'send_otp': 'إرسال OTP',
      'enter_otp': 'أدخل OTP',
      'confirm': 'تأكيد',
      'cancel': 'إلغاء',
      'products': 'المنتجات',
      'cart': 'السلة',
      'checkout': 'الدفع',
      'total': 'الإجمالي',
      'add_to_cart': 'إضافة إلى السلة',
      'go_checkout': 'الانتقال للدفع',
      'support': 'الدعم',
      'remaining': 'المتبقي',
      'admin_login': 'دخول الأدمن',
      'admin_panel': 'إدارة المنتجات',
      'save': 'حفظ',
      'delete': 'حذف',
      'edit': 'تعديل',
      'add_product': 'إضافة منتج',
      'price': 'السعر',
      'desc_short': 'وصف مختصر',
      'desc_extra': 'وصف إضافي',
      'stock': 'المتبقي (Stock)',
      'gallery': 'معرض الصور',
      'before': 'قبل',
      'after': 'بعد',
      'logout': 'تسجيل الخروج',
      'already_registered': 'أنت مسجّل مسبقًا. سيتم تحويلك لتسجيل الدخول.',
      'not_registered_email': 'الإيميل غير مسجّل. سيتم تحويلك لإنشاء حساب.',
      'not_registered_phone': 'رقم الهاتف غير مسجّل. سيتم تحويلك لإنشاء حساب.',
      'otp_wrong_register': 'OTP خاطئ. سيتم تحويلك لإنشاء حساب جديد.',
      'delivery_address': 'عنوان التوصيل',
      'zone': 'رقم المنطقة (zone) *',
      'street': 'رقم الشارع *',
      'building': 'رقم المبنى *',
      'apartment': 'رقم الشقة (اختياري)',
      'cod': 'الدفع عند الاستلام',
      'confirm_order': 'تأكيد الطلب',
      'paid_mock': 'إتمام عملية الشراء',
      'hello': 'مرحبًا',
      'no_products': 'لا توجد منتجات بعد.',
      'fix_stock': 'إصلاح stock للمنتجات القديمة',
      'translate_hint': 'لترجمة أفضل، أدخل حقول EN من الأدمن.',
      'order_success': 'تم الطلب بنجاح ✅',
      'order_details': 'تفاصيل الطلب',
      'order_id': 'رقم الطلب',
      'email_queued': 'تم تجهيز الإيميل للإرسال ✅',
      'email_not_available': 'لا يوجد بريد للحساب لإرسال الإيميل.',
      'loading': 'جاري التحميل...',
      'bad_phone': 'اكتب الرقم بصيغة دولية مثل +974...',
      'bad_email': 'اكتب بريدًا صحيحًا.',
      'bad_pass': 'كلمة السر يجب ألا تقل عن 6 أحرف.',
      'cart_empty': 'السلة فارغة.',
      'added_cart': 'تمت الإضافة إلى السلة ✅',
      'no_desc': 'بدون وصف',
      'product_details': 'تفاصيل المنتج',
      'reviews': 'آراء الزبائن',
      'add_review': 'أضف رأيك',
      'no_reviews': 'لا توجد تقييمات بعد.',
      'review_added': 'تم إضافة التقييم ✅',
      'need_login': 'سجّل دخول أولاً.',
      'need_purchase': 'لا يمكنك التعليق إلا بعد إتمام الشراء.',
      'not_enough_stock': 'لا يوجد مخزون كافي لمنتج:',
      'cannot_checkout_stock': 'لا يمكن الشراء لأن المخزون غير محدد لمنتج:',
      'processing': 'جاري التنفيذ...',
    },
    'en': {
      'app_title': 'Shop',
      'login': 'Login',
      'register': 'Create account',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm password',
      'first_name': 'First name',
      'last_name': 'Last name',
      'phone': 'Phone number',
      'login_btn': 'Sign in',
      'create_btn': 'Create account',
      'forgot': 'Forgot password?',
      'google': 'Continue with Google',
      'phone_login': 'Sign in with phone',
      'send_otp': 'Send OTP',
      'enter_otp': 'Enter OTP',
      'confirm': 'Confirm',
      'cancel': 'Cancel',
      'products': 'Products',
      'cart': 'Cart',
      'checkout': 'Checkout',
      'total': 'Total',
      'add_to_cart': 'Add to cart',
      'go_checkout': 'Go to checkout',
      'support': 'Support',
      'remaining': 'Remaining',
      'admin_login': 'Admin login',
      'admin_panel': 'Manage products',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'add_product': 'Add product',
      'price': 'Price',
      'desc_short': 'Short description',
      'desc_extra': 'Extra description',
      'stock': 'Stock',
      'gallery': 'Gallery',
      'before': 'Before',
      'after': 'After',
      'logout': 'Logout',
      'already_registered': 'Already registered. Redirecting to login.',
      'not_registered_email': 'Email not registered. Redirecting to sign up.',
      'not_registered_phone': 'Phone not registered. Redirecting to sign up.',
      'otp_wrong_register': 'Wrong OTP. Redirecting to sign up.',
      'delivery_address': 'Delivery address',
      'zone': 'Zone number *',
      'street': 'Street number *',
      'building': 'Building number *',
      'apartment': 'Apartment (optional)',
      'cod': 'Cash on delivery',
      'confirm_order': 'Confirm order',
      'paid_mock': 'Place order',
      'hello': 'Hello',
      'no_products': 'No products yet.',
      'fix_stock': 'Fix old products stock',
      'translate_hint': 'For best translation, fill EN fields from admin.',
      'order_success': 'Order placed ✅',
      'order_details': 'Order details',
      'order_id': 'Order ID',
      'email_queued': 'Email queued ✅',
      'email_not_available': 'No email on this account.',
      'loading': 'Loading...',
      'bad_phone': 'Use E.164 like +974...',
      'bad_email': 'Enter a valid email.',
      'bad_pass': 'Password must be 6+ chars.',
      'cart_empty': 'Cart is empty.',
      'added_cart': 'Added to cart ✅',
      'no_desc': 'No description',
      'product_details': 'Product details',
      'reviews': 'Customer reviews',
      'add_review': 'Add review',
      'no_reviews': 'No reviews yet.',
      'review_added': 'Review added ✅',
      'need_login': 'Please sign in first.',
      'need_purchase': 'Reviews require a purchase.',
      'not_enough_stock': 'Not enough stock for:',
      'cannot_checkout_stock': 'Cannot checkout: stock is not set for',
      'processing': 'Processing...',
    }
  };

  static String t(String lang, String key) =>
      _m[lang]?[key] ?? _m['en']?[key] ?? key;
}

/* =========================
   DB HELPERS
   ========================= */

FirebaseDatabase db() => FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: kDatabaseUrl,
    );

DatabaseReference productsRef() => db().ref(kProductsPath);
DatabaseReference ordersRef() => db().ref(kOrdersPath);
DatabaseReference purchasesRef() => db().ref(kPurchasesPath);
DatabaseReference rolesRef() => db().ref(kRolesPath);
DatabaseReference usersRef() => db().ref(kUsersPath);
DatabaseReference usersByEmailRef() => db().ref(kUsersByEmailPath);
DatabaseReference usersByPhoneRef() => db().ref(kUsersByPhonePath);
DatabaseReference mailQueueRef() => db().ref(kMailQueuePath);

String emailKey(String email) => email.trim().toLowerCase().replaceAll('.', ',');
String phoneKey(String phone) => phone
    .trim()
    .replaceAll('.', ',')
    .replaceAll('#', '_')
    .replaceAll('\$', '_')
    .replaceAll('[', '_')
    .replaceAll(']', '_')
    .replaceAll('/', '_');

/* =========================
   APP
   ========================= */

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop App',
      theme: ThemeData(useMaterial3: true),
      locale: app.locale,
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      scaffoldMessengerKey: kMessengerKey, // ✅ fix red screen on unmounted context
      home: const AuthGate(),
    );
  }
}

/* =========================
   AUTH GATE (also loads admin role)
   ========================= */

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  StreamSubscription<User?>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = FirebaseAuth.instance.authStateChanges().listen((u) async {
      if (!mounted) return;
      final app = context.read<AppState>();
      if (u == null) {
        app.setAdmin(false);
        return;
      }
      try {
        final snap = await rolesRef().child(u.uid).child('isAdmin').get();
        final isAdmin =
            (snap.value == true) || (snap.value?.toString() == 'true');
        app.setAdmin(isAdmin);
      } catch (_) {
        app.setAdmin(false);
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final dir = app.isArabic ? TextDirection.rtl : TextDirection.ltr;

    return Directionality(
      textDirection: dir,
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
          if (snap.data == null) return const AuthPage();
          return const ProductsPage();
        },
      ),
    );
  }
}

/* =========================
   CART MODEL
   ========================= */

class CartItem {
  final String productId;
  final String name;
  final String desc;
  final double price;
  final String imageUrl;
  int qty;
  int? stock;

  CartItem({
    required this.productId,
    required this.name,
    required this.desc,
    required this.price,
    required this.imageUrl,
    required this.qty,
    required this.stock,
  });
}

class CartModel extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  int get totalQty => _items.values.fold(0, (a, b) => a + b.qty);

  double get totalPrice =>
      _items.values.fold(0.0, (a, b) => a + (b.price * b.qty));

  void clear() {
    _items.clear();
    notifyListeners();
  }

  void addOrIncrease({
    required String productId,
    required String name,
    required String desc,
    required double price,
    required String imageUrl,
    required int? stock,
    int addQty = 1,
  }) {
    if (addQty <= 0) return;

    final existing = _items[productId];
    final maxStock = stock;

    if (existing == null) {
      if (maxStock != null && maxStock <= 0) return;
      final qty = (maxStock == null) ? addQty : min(addQty, max(maxStock, 0));
      if (qty <= 0) return;

      _items[productId] = CartItem(
        productId: productId,
        name: name,
        desc: desc,
        price: price,
        imageUrl: imageUrl,
        qty: qty,
        stock: stock,
      );
    } else {
      existing.stock = stock;
      if (maxStock == null) {
        existing.qty = existing.qty + addQty;
      } else {
        existing.qty = min(existing.qty + addQty, max(maxStock, 0));
      }
    }
    notifyListeners();
  }

  void decrease(String productId) {
    final existing = _items[productId];
    if (existing == null) return;
    existing.qty -= 1;
    if (existing.qty <= 0) _items.remove(productId);
    notifyListeners();
  }

  void remove(String productId) {
    _items.remove(productId);
    notifyListeners();
  }
}

/* =========================
   AI-ish Translation (offline fallback)
   ========================= */

String _offlineAiTranslateArToEn(String input) {
  final t = input.trim();
  if (t.isEmpty) return t;

  final map = <String, String>{
    'سماعة': 'Headset',
    'سماعات': 'Headsets',
    'ذكية': 'Smart',
    'نظارة': 'Glasses',
    'نظارات': 'Glasses',
    'ترجمة': 'Translation',
    'ساعة': 'Watch',
    'ساعة ذكية': 'Smart Watch',
    'جهاز': 'Device',
    'لابتوب': 'Laptop',
    'شاشة': 'Screen',
    'لمس': 'Touch',
    'مزيل': 'Remover',
    'كربون': 'Carbon',
    'زيت': 'Oil',
    'فلتر': 'Filter',
  };

  String out = t;
  map.forEach((k, v) {
    out = out.replaceAll(k, v);
  });

  final hasArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(out);
  if (!hasArabic) return out;

  const tr = {
    'ا': 'a',
    'أ': 'a',
    'إ': 'i',
    'آ': 'aa',
    'ب': 'b',
    'ت': 't',
    'ث': 'th',
    'ج': 'j',
    'ح': 'h',
    'خ': 'kh',
    'د': 'd',
    'ذ': 'dh',
    'ر': 'r',
    'ز': 'z',
    'س': 's',
    'ش': 'sh',
    'ص': 's',
    'ض': 'd',
    'ط': 't',
    'ظ': 'z',
    'ع': 'a',
    'غ': 'gh',
    'ف': 'f',
    'ق': 'q',
    'ك': 'k',
    'ل': 'l',
    'م': 'm',
    'ن': 'n',
    'ه': 'h',
    'و': 'w',
    'ي': 'y',
    'ى': 'a',
    'ة': 'a',
    'ء': '',
    'ئ': 'e',
    'ؤ': 'o',
    ' ': ' ',
  };

  final sb = StringBuffer();
  for (final ch in out.characters) {
    sb.write(tr[ch] ?? ch);
  }
  return sb.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
}

/* =========================
   UI HELPERS
   ========================= */

class LangToggleButton extends StatelessWidget {
  const LangToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final isAr = app.isArabic;

    // ✅ المطلوب: لو بتروح للعربي اكتب "عربي" / لو بتروح للإنجليزي اكتب "EN"
    final label = isAr ? 'EN' : 'عربي';

    return TextButton.icon(
      onPressed: () => context.read<AppState>().toggleLocale(),
      icon: const Icon(Icons.language),
      label: Text(label),
    );
  }
}

class _CartIcon extends StatelessWidget {
  final int count;
  const _CartIcon({required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.shopping_cart_outlined),
        if (count > 0)
          Positioned(
            top: -6,
            right: -8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
      ],
    );
  }
}

class _NetImg extends StatelessWidget {
  final String url;
  final double w;
  final double h;
  final double r;
  final BoxFit fit;

  const _NetImg({
    required this.url,
    required this.w,
    required this.h,
    this.r = 12,
    this.fit = BoxFit.cover,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (url.trim().isEmpty) {
      return Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.04),
          borderRadius: BorderRadius.circular(r),
        ),
        child: const Center(child: Icon(Icons.image, size: 18)),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(r),
      child: Image.network(
        url,
        width: w,
        height: h,
        fit: fit,
        errorBuilder: (_, __, ___) => Container(
          width: w,
          height: h,
          color: Colors.black.withOpacity(0.04),
          child: const Center(child: Icon(Icons.image_not_supported, size: 18)),
        ),
      ),
    );
  }
}

/* =========================
   AUTH PAGE (Login) + Hidden Admin Login
   ========================= */

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  int _logoTapCount = 0;
  Timer? _logoTimer;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _logoTimer?.cancel();
    super.dispose();
  }

  String _normalizeEmail(String v) => v.trim().toLowerCase();

  String _mapAuthError(FirebaseAuthException e, AppState app) {
    switch (e.code) {
      case 'invalid-email':
        return app.isArabic ? 'البريد غير صحيح.' : 'Invalid email.';
      case 'user-disabled':
        return app.isArabic ? 'هذا الحساب موقوف.' : 'User disabled.';
      case 'user-not-found':
        return app.isArabic ? 'لا يوجد حساب بهذا البريد.' : 'User not found.';
      case 'wrong-password':
        return app.isArabic ? 'كلمة السر غير صحيحة.' : 'Wrong password.';
      case 'email-already-in-use':
        return app.isArabic ? 'هذا البريد مستخدم بالفعل.' : 'Email already used.';
      case 'weak-password':
        return app.isArabic ? 'كلمة السر ضعيفة.' : 'Weak password.';
      case 'too-many-requests':
        return app.isArabic
            ? 'محاولات كثيرة. انتظر ثم أعد المحاولة.'
            : 'Too many requests.';
      default:
        return 'Firebase: ${e.code}\n${e.message ?? ""}';
    }
  }

  // ✅ بديل آمن بدون usersByEmail (لكن لو تبغى شرطك قبل تسجيل الدخول لازم rules تسمح بالقراءة)
  Future<bool> _emailExistsByAuth(String email) async {
    try {
      final methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> _loginEmailPassword() async {
    final app = context.read<AppState>();
    final email = _normalizeEmail(_emailCtrl.text);
    final pass = _passCtrl.text;

    if (email.isEmpty || !email.contains('@')) {
      snackMsg(app.t('bad_email'));
      return;
    }
    if (pass.length < 6) {
      snackMsg(app.t('bad_pass'));
      return;
    }

    setState(() => _loading = true);
    try {
      // ✅ شرطك: لو الإيميل غير مسجل -> تحويل لإنشاء حساب
      final exists = await _emailExistsByAuth(email);
      if (!exists) {
        snackMsg(app.t('not_registered_email'));
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RegisterPage(prefillEmail: email)),
        );
        return;
      }

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        snackMsg(app.t('not_registered_email'));
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RegisterPage(prefillEmail: email)),
        );
        return;
      }
      snackMsg(_mapAuthError(e, app));
    } catch (e) {
      snackMsg('Error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final app = context.read<AppState>();
    final controller = TextEditingController(text: _normalizeEmail(_emailCtrl.text));

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => Directionality(
        textDirection: app.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          scrollable: true,
          title: Text(app.t('forgot')),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.left,
            decoration: InputDecoration(labelText: app.t('email')),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(_, false), child: Text(app.t('cancel'))),
            FilledButton(onPressed: () => Navigator.pop(_, true), child: Text(app.t('send_otp'))),
          ],
        ),
      ),
    );

    final email = _normalizeEmail(controller.text);
    controller.dispose();

    if (ok != true) return;

    if (email.isEmpty || !email.contains('@')) {
      snackMsg(app.t('bad_email'));
      return;
    }

    try {
      setState(() => _loading = true);
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      snackMsg(app.isArabic ? 'تم إرسال رابط إعادة التعيين.' : 'Reset email sent.');
    } on FirebaseAuthException catch (e) {
      snackMsg(_mapAuthError(e, app));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    final app = context.read<AppState>();
    try {
      setState(() => _loading = true);
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        snackMsg(app.isArabic ? 'تم الإلغاء.' : 'Cancelled.');
        return;
      }

      final googleAuth = await googleUser.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(cred);

      // ⚠️ لا تكتب في /users هنا لأن rules عندك تمنع غالبًا
      // وإذا كتبت وصار Permission denied كان يسبب crash + unmounted context.
    } on FirebaseAuthException catch (e) {
      snackMsg(_mapAuthError(e, app));
    } catch (e) {
      snackMsg('Error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onLogoTap() {
    _logoTimer?.cancel();
    _logoTapCount++;
    _logoTimer = Timer(const Duration(seconds: 2), () => _logoTapCount = 0);

    if (_logoTapCount >= 7) {
      _logoTapCount = 0;
      _openAdminLogin();
    }
  }

  Future<void> _openAdminLogin() async {
    final app = context.read<AppState>();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => Directionality(
        textDirection: app.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          scrollable: true,
          title: Text(app.t('admin_login')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailCtrl,
                decoration: InputDecoration(labelText: app.t('email')),
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passCtrl,
                decoration: InputDecoration(labelText: app.t('password')),
                obscureText: true,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.left,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(_, false), child: Text(app.t('cancel'))),
            FilledButton(onPressed: () => Navigator.pop(_, true), child: Text(app.t('login_btn'))),
          ],
        ),
      ),
    );

    final email = emailCtrl.text.trim();
    final pass = passCtrl.text;
    emailCtrl.dispose();
    passCtrl.dispose();

    if (ok != true) return;

    try {
      setState(() => _loading = true);
      final res = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      final u = res.user;
      if (u == null) {
        snackMsg('Auth failed.');
        return;
      }
      final snap = await rolesRef().child(u.uid).child('isAdmin').get();
      final isAdmin = (snap.value == true) || (snap.value?.toString() == 'true');
      if (!isAdmin) {
        snackMsg(app.isArabic ? 'هذا الحساب ليس أدمن.' : 'Not an admin.');
        await FirebaseAuth.instance.signOut();
        return;
      }
      snackMsg(app.isArabic ? 'تم دخول الأدمن ✅' : 'Admin logged in ✅');
    } catch (e) {
      snackMsg('Error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _socialButton({
    required VoidCallback? onPressed,
    required Widget leading,
    required String text,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading,
            const SizedBox(width: 10),
            Text(text),
          ],
        ),
      ),
    );
  }

  Future<void> _openPhoneLoginFlow() async {
    final app = context.read<AppState>();
    final phoneCtrl = TextEditingController(text: '+974');

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => Directionality(
        textDirection: app.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          scrollable: true,
          title: Text(app.t('phone_login')),
          content: TextField(
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              hintText: '+9745xxxxxxx',
              labelText: app.t('phone'),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(_, false), child: Text(app.t('cancel'))),
            FilledButton(onPressed: () => Navigator.pop(_, true), child: Text(app.t('send_otp'))),
          ],
        ),
      ),
    );

    final phone = phoneCtrl.text.trim();
    phoneCtrl.dispose();

    if (ok != true) return;
    if (phone.isEmpty || !phone.startsWith('+')) {
      snackMsg(app.t('bad_phone'));
      return;
    }

    // ✅ شرطك: لو الرقم غير مسجّل -> تحويل لإنشاء حساب
    // ملاحظة: هذا يحتاج rules تسمح بقراءة usersByPhone لغير المسجل.
    try {
      final snap = await usersByPhoneRef().child(phoneKey(phone)).get();
      final exists = snap.exists;

      if (!exists) {
        snackMsg(app.t('not_registered_phone'));
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RegisterPage(prefillPhone: phone)),
        );
        return;
      }
    } catch (_) {
      // لو rules تمنع القراءة، ما نخلي التطبيق ينهار.
      // نكمل OTP عادي وبعدها نتحقق من وجود profile من داخل التطبيق.
    }

    await _phoneOtpSignIn(phone);
  }

  // ✅ FIX: لا تستخدم Controller خارج توقيت dialog ولا تعمل dispose مبكر
  Future<void> _phoneOtpSignIn(String phone) async {
    final app = context.read<AppState>();

    try {
      setState(() => _loading = true);

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),

        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await FirebaseAuth.instance.signInWithCredential(credential);
          } catch (_) {}
        },

        verificationFailed: (FirebaseAuthException e) {
          snackMsg('Phone verify failed: ${e.code}\n${e.message ?? ""}');
        },

        codeSent: (String vid, int? resendToken) async {
          if (!mounted) return;

          final otpCtrl = TextEditingController();
          final ok = await showDialog<bool>(
            context: context,
            builder: (_) => Directionality(
              textDirection: app.isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: AlertDialog(
                scrollable: true,
                title: Text(app.t('enter_otp')),
                content: TextField(
                  controller: otpCtrl,
                  keyboardType: TextInputType.number,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  decoration: const InputDecoration(labelText: 'OTP', hintText: '123456'),
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(_, false), child: Text(app.t('cancel'))),
                  FilledButton(onPressed: () => Navigator.pop(_, true), child: Text(app.t('confirm'))),
                ],
              ),
            ),
          );

          final code = otpCtrl.text.trim();
          otpCtrl.dispose();

          if (ok != true || code.length < 4) {
            snackMsg(app.t('otp_wrong_register'));
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => RegisterPage(prefillPhone: phone)),
            );
            return;
          }

          try {
            final credential = PhoneAuthProvider.credential(
              verificationId: vid,
              smsCode: code,
            );
            await FirebaseAuth.instance.signInWithCredential(credential);
          } on FirebaseAuthException catch (_) {
            snackMsg(app.t('otp_wrong_register'));
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => RegisterPage(prefillPhone: phone)),
            );
          }
        },

        codeAutoRetrievalTimeout: (_) {},
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Directionality(
      textDirection: app.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(app.t('login')),
          actions: const [LangToggleButton()],
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _onLogoTap,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 6, bottom: 12),
                              child: Image.asset(
                                kHerzLogoPath,
                                height: kLogoHeight,
                                width: double.infinity,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: kLogoHeight,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.03),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'HERZ',
                                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          TextField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              labelText: app.t('email'),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _passCtrl,
                            obscureText: true,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              labelText: app.t('password'),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: FilledButton(
                              onPressed: _loading ? null : _loginEmailPassword,
                              child: _loading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : Text(app.t('login_btn')),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: app.isArabic ? Alignment.centerLeft : Alignment.centerRight,
                            child: TextButton(
                              onPressed: _loading ? null : _forgotPassword,
                              child: Text(app.t('forgot')),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Divider(),
                          const SizedBox(height: 8),
                          _socialButton(
                            onPressed: _loading ? null : _signInWithGoogle,
                            leading: CircleAvatar(
                              radius: 12,
                              child: Text(
                                'G',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            text: app.t('google'),
                          ),
                          const SizedBox(height: 10),
                          _socialButton(
                            onPressed: _loading ? null : _openPhoneLoginFlow,
                            leading: const Icon(Icons.phone_android),
                            text: app.t('phone_login'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _loading
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RegisterPage(
                                    prefillEmail: _normalizeEmail(_emailCtrl.text),
                                  ),
                                ),
                              );
                            },
                      child: Text(app.t('register')),
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

/* =========================
   REGISTER PAGE
   ========================= */

class RegisterPage extends StatefulWidget {
  final String? prefillEmail;
  final String? prefillPhone;

  const RegisterPage({super.key, this.prefillEmail, this.prefillPhone});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firstCtrl = TextEditingController();
  final _lastCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  final _phoneCtrl = TextEditingController(text: '+974');

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if ((widget.prefillEmail ?? '').trim().isNotEmpty) {
      _emailCtrl.text = widget.prefillEmail!.trim();
    }
    if ((widget.prefillPhone ?? '').trim().isNotEmpty) {
      _phoneCtrl.text = widget.prefillPhone!.trim();
    }
  }

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  String _normalizeEmail(String v) => v.trim().toLowerCase();

  Future<void> _goToLoginWithMsg(String msg) async {
    snackMsg(msg);
    if (!mounted) return;
    Navigator.popUntil(context, (r) => r.isFirst);
  }

  Future<void> _createAccount() async {
    final app = context.read<AppState>();

    final first = _firstCtrl.text.trim();
    final last = _lastCtrl.text.trim();
    final email = _normalizeEmail(_emailCtrl.text);
    final pass = _passCtrl.text;
    final pass2 = _pass2Ctrl.text;
    final phone = _phoneCtrl.text.trim();

    if (first.isEmpty ||
        last.isEmpty ||
        email.isEmpty ||
        pass.isEmpty ||
        pass2.isEmpty ||
        phone.isEmpty) {
      snackMsg(app.isArabic ? 'كل الخانات إجبارية.' : 'All fields are required.');
      return;
    }
    if (!email.contains('@')) {
      snackMsg(app.t('bad_email'));
      return;
    }
    if (pass.length < 6) {
      snackMsg(app.t('bad_pass'));
      return;
    }
    if (pass != pass2) {
      snackMsg(app.isArabic ? 'كلمتا السر غير متطابقتين.' : 'Passwords do not match.');
      return;
    }
    if (!phone.startsWith('+')) {
      snackMsg(app.t('bad_phone'));
      return;
    }

    setState(() => _loading = true);
    try {
      // لو هذا الإيميل موجود في FirebaseAuth
      final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.isNotEmpty) {
        await _goToLoginWithMsg(app.t('already_registered'));
        return;
      }

      final res = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);
      final user = res.user;
      if (user == null) {
        snackMsg('Create failed.');
        return;
      }

      // نحاول نحفظ profile (قد يحتاج rules)
      try {
        await usersRef().child(user.uid).set({
          'firstName': first,
          'lastName': last,
          'email': email,
          'phone': phone,
          'createdAt': ServerValue.timestamp,
        });
        await usersByEmailRef().child(emailKey(email)).set(user.uid);
        await usersByPhoneRef().child(phoneKey(phone)).set(user.uid);
      } catch (_) {
        // لو Permission denied لا نخلي التطبيق ينهار
      }

      snackMsg(app.isArabic ? 'تم إنشاء الحساب ✅' : 'Account created ✅');
      if (!mounted) return;
      Navigator.popUntil(context, (r) => r.isFirst);
    } on FirebaseAuthException catch (e) {
      snackMsg('Firebase: ${e.code}\n${e.message ?? ""}');
    } catch (e) {
      snackMsg('Error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Directionality(
      textDirection: app.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(app.t('register')),
          actions: const [LangToggleButton()],
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _firstCtrl,
                              decoration: InputDecoration(labelText: app.t('first_name')),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _lastCtrl,
                              decoration: InputDecoration(labelText: app.t('last_name')),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(labelText: app.t('email')),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _passCtrl,
                        obscureText: true,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(labelText: app.t('password')),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _pass2Ctrl,
                        obscureText: true,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(labelText: app.t('confirm_password')),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          labelText: app.t('phone'),
                          hintText: '+9745xxxxxxx',
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FilledButton(
                          onPressed: _loading ? null : _createAccount,
                          child: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(app.t('create_btn')),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: OutlinedButton(
                          onPressed: _loading ? null : () => Navigator.pop(context),
                          child: Text(app.t('login')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* =========================
   PRODUCTS PAGE
   ========================= */

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late final DatabaseReference _ref;
  final Set<String> _fixedOnce = {};

  @override
  void initState() {
    super.initState();
    _ref = productsRef();
  }

  Future<void> _signOut() async {
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    context.read<AppState>().setAdmin(false);
  }

  Future<void> _fixMissingStockTo3() async {
    final app = context.read<AppState>();
    try {
      final snap = await _ref.get();
      final v = snap.value;
      if (v is! Map) {
        snackMsg(app.isArabic ? 'لا يوجد منتجات لإصلاحها.' : 'No products to fix.');
        return;
      }

      int fixed = 0;
      for (final entry in v.entries) {
        final id = entry.key.toString();
        final data = entry.value;
        if (data is Map) {
          final hasStock = data.containsKey('stock');
          if (!hasStock) {
            await _ref.child(id).update({'stock': 3});
            fixed++;
          }
        }
      }
      snackMsg(
        fixed == 0
            ? (app.isArabic ? 'لا توجد منتجات ناقصة stock.' : 'No missing stock.')
            : (app.isArabic
                ? 'تم إصلاح $fixed منتجات (stock=3).'
                : 'Fixed $fixed products (stock=3).'),
      );
    } catch (e) {
      snackMsg('Error: $e');
    }
  }

  List<_ProductRow> _parseProducts(dynamic raw) {
    if (raw == null) return [];
    final List<_ProductRow> out = [];

    if (raw is Map) {
      raw.forEach((k, v) {
        final key = k.toString();
        if (v is Map) out.add(_ProductRow.fromMap(key, v));
      });
    } else if (raw is List) {
      for (int i = 0; i < raw.length; i++) {
        final v = raw[i];
        final key = i.toString();
        if (v is Map) out.add(_ProductRow.fromMap(key, v));
      }
    }

    out.removeWhere((p) => p.name.trim().isEmpty);
    out.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    for (final p in out) {
      if (p.stock == null && !_fixedOnce.contains(p.id)) {
        _fixedOnce.add(p.id);
        Future.microtask(() async {
          try {
            await _ref.child(p.id).update({'stock': 3});
          } catch (_) {}
        });
      }
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final cart = context.watch<CartModel>();
    final app = context.watch<AppState>();

    return Directionality(
      textDirection: app.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(app.t('products')),
          actions: [
            const LangToggleButton(),
            IconButton(
              onPressed: _fixMissingStockTo3,
              icon: const Icon(Icons.build_circle_outlined),
              tooltip: app.t('fix_stock'),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
              icon: _CartIcon(count: cart.totalQty),
              tooltip: app.t('cart'),
            ),
            IconButton(
              onPressed: _signOut,
              icon: const Icon(Icons.logout),
              tooltip: app.t('logout'),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${app.t('hello')}: ${user?.email ?? user?.phoneNumber ?? user?.displayName ?? "User"}',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: app.isArabic ? TextAlign.right : TextAlign.left,
                      ),
                    ),
                    if (app.isAdmin)
                      IconButton(
                        tooltip: app.t('admin_panel'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AdminProductsPanelPage()),
                          );
                        },
                        icon: const Icon(Icons.admin_panel_settings_outlined),
                      ),
                  ],
                ),
              ),
            ),
            const Divider(height: 0),
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: _ref.onValue,
                builder: (context, snap) {
                  if (snap.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.cloud_off, size: 44),
                            const SizedBox(height: 10),
                            Text(app.isArabic ? 'تعذر الاتصال بقاعدة البيانات.' : 'Database connection failed.'),
                            const SizedBox(height: 8),
                            Text('Details: ${snap.error}', textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    );
                  }

                  if (snap.connectionState == ConnectionState.waiting && !snap.hasData) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 12),
                          Text(app.t('loading')),
                        ],
                      ),
                    );
                  }

                  final raw = snap.data?.snapshot.value;
                  final products = _parseProducts(raw);

                  if (products.isEmpty) {
                    return Center(child: Text(app.t('no_products')));
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: products.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final p = products[i];

                      final nameToShow = app.isArabic
                          ? p.name
                          : (p.nameEn.trim().isNotEmpty ? p.nameEn : _offlineAiTranslateArToEn(p.name));

                      final descToShow = app.isArabic
                          ? (p.desc.isEmpty ? app.t('no_desc') : p.desc)
                          : (p.descEn.trim().isNotEmpty
                              ? p.descEn
                              : (p.desc.isEmpty ? app.t('no_desc') : _offlineAiTranslateArToEn(p.desc)));

                      final stockText = (p.stock == null) ? (app.isArabic ? 'غير محدد' : 'N/A') : p.stock.toString();

                      return Card(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ProductDetailsPage(productId: p.id)),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    _NetImg(url: p.imageUrl, w: 54, h: 54, r: 10),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        _NetImg(url: p.beforeUrl, w: 24, h: 24, r: 6),
                                        const SizedBox(width: 6),
                                        _NetImg(url: p.afterUrl, w: 24, h: 24, r: 6),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        nameToShow,
                                        textAlign: app.isArabic ? TextAlign.right : TextAlign.left,
                                        style: const TextStyle(fontWeight: FontWeight.w800),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        descToShow,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: app.isArabic ? TextAlign.right : TextAlign.left,
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${p.price.toStringAsFixed(2)} QAR',
                                              textAlign: app.isArabic ? TextAlign.right : TextAlign.left,
                                              style: const TextStyle(fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.04),
                                              borderRadius: BorderRadius.circular(999),
                                            ),
                                            child: Text(
                                              '${app.t('remaining')}: $stockText',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: (p.stock != null && p.stock! <= 0) ? Colors.red : null,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (!app.isArabic && p.nameEn.trim().isEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 6),
                                          child: Text(
                                            app.t('translate_hint'),
                                            style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.55)),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportPage())),
          icon: const Icon(Icons.support_agent),
          label: Text(app.t('support')),
        ),
      ),
    );
  }
}

class _ProductRow {
  final String id;
  final String name;
  final String nameEn;
  final String desc;
  final String descEn;
  final String descExtra;
  final String descExtraEn;
  final String imageUrl;

  final List<String> gallery;
  final String beforeUrl;
  final String afterUrl;

  final double price;
  final int? stock;
  final int createdAt;

  _ProductRow({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.desc,
    required this.descEn,
    required this.descExtra,
    required this.descExtraEn,
    required this.imageUrl,
    required this.gallery,
    required this.beforeUrl,
    required this.afterUrl,
    required this.price,
    required this.stock,
    required this.createdAt,
  });

  factory _ProductRow.fromMap(String id, Map m) {
    final name = (m['name'] ?? '').toString();
    final nameEn = (m['name_en'] ?? '').toString();

    final desc = (m['desc'] ?? '').toString();
    final descEn = (m['desc_en'] ?? '').toString();

    final descExtra = (m['descExtra'] ?? '').toString();
    final descExtraEn = (m['descExtra_en'] ?? '').toString();

    final imageUrl = (m['imageUrl'] ?? '').toString();

    final priceRaw = m['price'];
    final price = (priceRaw is num)
        ? priceRaw.toDouble()
        : double.tryParse(priceRaw?.toString() ?? '') ?? 0.0;

    int? stock;
    if (m.containsKey('stock')) {
      final stockRaw = m['stock'];
      stock = (stockRaw is num) ? stockRaw.toInt() : int.tryParse(stockRaw?.toString() ?? '');
    } else {
      stock = null;
    }

    final createdAtRaw = m['createdAt'];
    final createdAt = (createdAtRaw is num)
        ? createdAtRaw.toInt()
        : int.tryParse(createdAtRaw?.toString() ?? '') ?? 0;

    final gRaw = m['gallery'];
    final List<String> gallery = [];
    if (gRaw is List) {
      for (final x in gRaw) {
        if (x != null && x.toString().trim().isNotEmpty) gallery.add(x.toString());
      }
    }

    final ba = m['beforeAfter'];
    String beforeUrl = '';
    String afterUrl = '';
    if (ba is Map) {
      beforeUrl = (ba['beforeUrl'] ?? '').toString();
      afterUrl = (ba['afterUrl'] ?? '').toString();
    }

    return _ProductRow(
      id: id,
      name: name,
      nameEn: nameEn,
      desc: desc,
      descEn: descEn,
      descExtra: descExtra,
      descExtraEn: descExtraEn,
      imageUrl: imageUrl,
      gallery: gallery,
      beforeUrl: beforeUrl,
      afterUrl: afterUrl,
      price: price,
      stock: stock,
      createdAt: createdAt,
    );
  }
}

/* =========================
   PRODUCT DETAILS
   ========================= */

class ProductDetailsPage extends StatefulWidget {
  final String productId;
  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  DatabaseReference get _pRef => productsRef().child(widget.productId);

  final PageController _page = PageController();

  Future<Map<String, dynamic>?> _loadProduct() async {
    final snap = await _pRef.get();
    final v = snap.value;
    if (v is Map) {
      return v.map((k, val) => MapEntry(k.toString(), val));
    }
    return null;
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();
    final app = context.watch<AppState>();

    return Directionality(
      textDirection: app.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(app.t('product_details')),
          actions: [
            const LangToggleButton(),
            IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage())),
              icon: _CartIcon(count: cart.totalQty),
              tooltip: app.t('cart'),
            ),
          ],
        ),
        body: FutureBuilder<Map<String, dynamic>?>(
          future: _loadProduct(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final p = snap.data;
            if (p == null) {
              return Center(child: Text(app.isArabic ? 'المنتج غير موجود.' : 'Product not found.'));
            }

            final nameAr = (p['name'] ?? '').toString();
            final nameEn = (p['name_en'] ?? '').toString();
            final descAr = (p['desc'] ?? '').toString();
            final descEn = (p['desc_en'] ?? '').toString();

            final descExtraAr = (p['descExtra'] ?? '').toString();
            final descExtraEn = (p['descExtra_en'] ?? '').toString();

            final imageUrl = (p['imageUrl'] ?? '').toString();

            final ba = p['beforeAfter'];
            String beforeUrl = '';
            String afterUrl = '';
            if (ba is Map) {
              beforeUrl = (ba['beforeUrl'] ?? '').toString();
              afterUrl = (ba['afterUrl'] ?? '').toString();
            }

            final gRaw = p['gallery'];
            final List<String> gallery = [];
            if (gRaw is List) {
              for (final x in gRaw) {
                if (x != null && x.toString().trim().isNotEmpty) gallery.add(x.toString());
              }
            }

            final pages = <String>[
              if (imageUrl.trim().isNotEmpty) imageUrl,
              ...gallery.where((x) => x.trim().isNotEmpty && x != imageUrl),
            ];

            final priceRaw = p['price'];
            final price = (priceRaw is num)
                ? priceRaw.toDouble()
                : double.tryParse(priceRaw?.toString() ?? '') ?? 0.0;

            int? stock;
            if (p.containsKey('stock')) {
              final stockRaw = p['stock'];
              stock = (stockRaw is num) ? stockRaw.toInt() : int.tryParse(stockRaw?.toString() ?? '');
            } else {
              stock = null;
            }

            final canAdd = (stock == null) ? true : (stock > 0);

            final nameToShow = app.isArabic
                ? (nameAr.isEmpty ? 'بدون اسم' : nameAr)
                : (nameEn.trim().isNotEmpty ? nameEn : _offlineAiTranslateArToEn(nameAr));

            final descToShow = app.isArabic
                ? (descAr.isEmpty ? app.t('no_desc') : descAr)
                : (descEn.trim().isNotEmpty
                    ? descEn
                    : (descAr.isEmpty ? app.t('no_desc') : _offlineAiTranslateArToEn(descAr)));

            final descExtraToShow = app.isArabic
                ? descExtraAr
                : (descExtraEn.trim().isNotEmpty ? descExtraEn : _offlineAiTranslateArToEn(descExtraAr));

            return ListView(
              padding: const EdgeInsets.all(14),
              children: [
                if (pages.isNotEmpty) ...[
                  SizedBox(
                    height: 230,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: PageView.builder(
                        controller: _page,
                        itemCount: pages.length,
                        itemBuilder: (_, i) => Image.network(
                          pages[i],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.black.withOpacity(0.04),
                            child: const Center(child: Icon(Icons.image_not_supported, size: 44)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (pages.length > 1)
                    Center(
                      child: SmoothPageIndicator(
                        controller: _page,
                        count: pages.length,
                        effect: const WormEffect(dotHeight: 8, dotWidth: 8),
                      ),
                    ),
                ] else ...[
                  Container(
                    height: 230,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Center(child: Icon(Icons.image, size: 48)),
                  ),
                ],
                const SizedBox(height: 14),

                if (beforeUrl.trim().isNotEmpty || afterUrl.trim().isNotEmpty) ...[
                  Text(
                    app.isArabic ? 'قبل / بعد' : 'Before / After',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                    textAlign: app.isArabic ? TextAlign.right : TextAlign.left,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(app.t('before')),
                            const SizedBox(height: 6),
                            _NetImg(url: beforeUrl, w: double.infinity, h: 140, r: 14),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          children: [
                            Text(app.t('after')),
                            const SizedBox(height: 6),
                            _NetImg(url: afterUrl, w: double.infinity, h: 140, r: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                ],

                Text(
                  nameToShow,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                  textAlign: app.isArabic ? TextAlign.right : TextAlign.left,
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${price.toStringAsFixed(2)} QAR',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                        textAlign: app.isArabic ? TextAlign.right : TextAlign.left,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${app.t('remaining')}: ${stock?.toString() ?? (app.isArabic ? "غير محدد" : "N/A")}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: (stock != null && stock <= 0) ? Colors.red : null,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Text(descToShow, textAlign: app.isArabic ? TextAlign.right : TextAlign.left),

                if (descExtraToShow.trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    descExtraToShow,
                    textAlign: app.isArabic ? TextAlign.right : TextAlign.left,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],

                const SizedBox(height: 16),

                SizedBox(
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: canAdd
                        ? () {
                            cart.addOrIncrease(
                              productId: widget.productId,
                              name: nameToShow,
                              desc: descToShow,
                              price: price,
                              imageUrl: imageUrl,
                              stock: stock,
                              addQty: 1,
                            );
                            snackMsg(app.t('added_cart'));
                          }
                        : null,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: Text(app.t('add_to_cart')),
                  ),
                ),

                const SizedBox(height: 10),

                // ✅ زر الانتقال للدفع داخل صفحة المنتج
                SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutPage()));
                    },
                    icon: const Icon(Icons.payments_outlined),
                    label: Text(app.t('go_checkout')),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/* =========================
   CART PAGE + CHECKOUT + ORDER SUCCESS + EMAIL QUEUE
   ========================= */

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();
    final app = context.watch<AppState>();

    return Directionality(
      textDirection: app.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(app.t('cart')),
          actions: const [LangToggleButton()],
        ),
        body: cart.items.isEmpty
            ? Center(child: Text(app.t('cart_empty')))
            : ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  ...cart.items.map((it) => Card(
                        child: ListTile(
                          leading: _NetImg(url: it.imageUrl, w: 54, h: 54, r: 10),
                          title: Text(it.name, textAlign: app.isArabic ? TextAlign.right : TextAlign.left),
                          subtitle: Text(
                            '${it.price.toStringAsFixed(2)} QAR',
                            textAlign: app.isArabic ? TextAlign.right : TextAlign.left,
                          ),
                          trailing: Wrap(
                            spacing: 2,
                            children: [
                              IconButton(
                                onPressed: () => cart.decrease(it.productId),
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                              IconButton(
                                onPressed: () => cart.addOrIncrease(
                                  productId: it.productId,
                                  name: it.name,
                                  desc: it.desc,
                                  price: it.price,
                                  imageUrl: it.imageUrl,
                                  stock: it.stock,
                                  addQty: 1,
                                ),
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                              IconButton(
                                onPressed: () => cart.remove(it.productId),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                        ),
                      )),
                  const SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '${app.t('total')}: ${cart.totalPrice.toStringAsFixed(2)} QAR',
                            textAlign: app.isArabic ? TextAlign.right : TextAlign.left,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 48,
                            child: FilledButton.icon(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const CheckoutPage()),
                              ),
                              icon: const Icon(Icons.payments_outlined),
                              label: Text(app.t('checkout')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _loading = false;

  DatabaseReference stockRef(String productId) => productsRef().child(productId).child('stock');

  Future<bool> _reserveStock(String productId, int qty) async {
    final ref = stockRef(productId);

    final res = await ref.runTransaction((Object? currentData) {
      final current = (currentData is num)
          ? currentData.toInt()
          : int.tryParse(currentData?.toString() ?? '') ?? 0;

      if (current < qty) {
        return Transaction.abort();
      }
      return Transaction.success(current - qty);
    });

    return res.committed;
  }

  Future<void> _restoreStock(String productId, int qty) async {
    final ref = stockRef(productId);
    await ref.runTransaction((Object? currentData) {
      final current = (currentData is num)
          ? currentData.toInt()
          : int.tryParse(currentData?.toString() ?? '') ?? 0;

      return Transaction.success(current + qty);
    });
  }

  Future<Map<String, String>?> _askDeliveryAddress() async {
    final app = context.read<AppState>();

    final zoneCtrl = TextEditingController();
    final streetCtrl = TextEditingController();
    final buildingCtrl = TextEditingController();
    final aptCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => Directionality(
        textDirection: app.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          scrollable: true,
          title: Text(app.t('delivery_address')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: zoneCtrl,
                decoration: InputDecoration(labelText: app.t('zone')),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: streetCtrl,
                decoration: InputDecoration(labelText: app.t('street')),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: buildingCtrl,
                decoration: InputDecoration(labelText: app.t('building')),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 8),
              TextField(controller: aptCtrl, decoration: InputDecoration(labelText: app.t('apartment'))),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(_, false), child: Text(app.t('cancel'))),
            FilledButton(onPressed: () => Navigator.pop(_, true), child: Text(app.t('confirm_order'))),
          ],
        ),
      ),
    );

    final zone = zoneCtrl.text.trim();
    final street = streetCtrl.text.trim();
    final building = buildingCtrl.text.trim();
    final apt = aptCtrl.text.trim();

    zoneCtrl.dispose();
    streetCtrl.dispose();
    buildingCtrl.dispose();
    aptCtrl.dispose();

    if (ok != true) return null;

    if (zone.isEmpty || street.isEmpty || building.isEmpty) {
      snackMsg(app.isArabic ? 'zone / street / building إجبارية.' : 'Zone / Street / Building are required.');
      return null;
    }

    return {'zone': zone, 'street': street, 'building': building, 'apartment': apt};
  }

  Future<void> _queueOrderEmail({
    required AppState app,
    required String to,
    required String orderId,
    required double total,
    required List<Map<String, dynamic>> items,
    required Map<String, dynamic> deliveryAddress,
  }) async {
    if (to.trim().isEmpty) {
      snackMsg(app.t('email_not_available'));
      return;
    }

    final subject = "HERZ - Order #$orderId";

    final itemsText = items.map((it) {
      return "- ${(it['name'] ?? '')} × ${(it['qty'] ?? 0)} @ ${(it['price'] ?? 0)} QAR";
    }).join("\n");

    final addressText = deliveryAddress.isEmpty
        ? ""
        : "\n\nDelivery address:\nZone: ${deliveryAddress['zone'] ?? ''}\nStreet: ${deliveryAddress['street'] ?? ''}\nBuilding: ${deliveryAddress['building'] ?? ''}\nApartment: ${deliveryAddress['apartment'] ?? ''}";

    final text = """
Hello,
Your order has been placed ✅

Order ID: $orderId
Total: ${total.toStringAsFixed(2)} QAR

Items:
$itemsText
$addressText

Thank you.
""";

    try {
      await mailQueueRef().push().set({
        "to": to,
        "subject": subject,
        "text": text,
        "createdAt": ServerValue.timestamp,
        "orderId": orderId,
      });
      snackMsg(app.t('email_queued'));
    } catch (_) {
      // لو rules تمنع mailQueue ما نخلي التطبيق ينهار
    }
  }

  Future<void> _completeCheckout({required String paymentMethod, Map<String, String>? deliveryAddress}) async {
    final app = context.read<AppState>();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      snackMsg(app.t('need_login'));
      return;
    }

    final cart = context.read<CartModel>();
    if (cart.items.isEmpty) {
      snackMsg(app.t('cart_empty'));
      return;
    }

    for (final it in cart.items) {
      if (it.stock == null) {
        snackMsg('${app.t('cannot_checkout_stock')} ${it.name}.');
        return;
      }
    }

    setState(() => _loading = true);

    final reserved = <String, int>{};
    final itemsSnapshot = cart.items
        .map((it) => {
              'productId': it.productId,
              'name': it.name,
              'qty': it.qty,
              'price': it.price,
            })
        .toList();
    final total = cart.totalPrice;

    try {
      // 1) reserve stock (needs rules to allow stock write)
      for (final it in cart.items) {
        final ok = await _reserveStock(it.productId, it.qty);
        if (!ok) {
          snackMsg('${app.t('not_enough_stock')} ${it.name}');
          for (final e in reserved.entries) {
            await _restoreStock(e.key, e.value);
          }
          setState(() => _loading = false);
          return;
        }
        reserved[it.productId] = it.qty;
      }

      // 2) create order
      final orderRef = ordersRef().child(user.uid).push();
      await orderRef.set({
        'createdAt': ServerValue.timestamp,
        'status': paymentMethod,
        'total': total,
        'deliveryAddress': deliveryAddress ?? {},
        'items': itemsSnapshot,
      });

      final orderId = orderRef.key ?? '';

      // 3) purchases to unlock reviews (needs rules to allow purchases/$uid write)
      try {
        final purchasesUserRef = purchasesRef().child(user.uid);
        for (final it in cart.items) {
          await purchasesUserRef.child(it.productId).set(true);
        }
      } catch (_) {}

      cart.clear();

      // 4) show success page
      if (!mounted) return;

      // 5) queue email (optional)
      await _queueOrderEmail(
        app: app,
        to: user.email ?? '',
        orderId: orderId,
        total: total,
        items: itemsSnapshot,
        deliveryAddress: (deliveryAddress ?? {}),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderSuccessPage(
            orderId: orderId,
            total: total,
            items: itemsSnapshot,
            deliveryAddress: (deliveryAddress ?? {}),
            customerEmail: user.email ?? '',
          ),
        ),
      );
    } catch (e) {
      for (final e2 in reserved.entries) {
        try {
          await _restoreStock(e2.key, e2.value);
        } catch (_) {}
      }
      snackMsg(app.isArabic ? 'حدث خطأ: $e' : 'Error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();
    final app = context.watch<AppState>();

    return Directionality(
      textDirection: app.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(app.t('checkout')),
          actions: const [LangToggleButton()],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        app.isArabic ? 'ملخص الطلب' : 'Order summary',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      ...cart.items.map((it) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              '${it.name}  × ${it.qty}  = ${(it.price * it.qty).toStringAsFixed(2)} QAR',
                              textAlign: app.isArabic ? TextAlign.right : TextAlign.left,
                            ),
                          )),
                      const Divider(),
                      Text(
                        '${app.t('total')}: ${cart.totalPrice.toStringAsFixed(2)} QAR',
                        textAlign: app.isArabic ? TextAlign.right : TextAlign.left,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: _loading ? null : () => _completeCheckout(paymentMethod: 'paid_mock', deliveryAddress: {}),
                  icon: _loading
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.check_circle_outline),
                  label: Text(_loading ? app.t('processing') : app.t('paid_mock')),
                ),
              ),
              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: _loading
                      ? null
                      : () async {
                          final addr = await _askDeliveryAddress();
                          if (addr == null) return;
                          await _completeCheckout(paymentMethod: 'cod', deliveryAddress: addr);
                        },
                  icon: const Icon(Icons.local_shipping_outlined),
                  label: Text(app.t('cod')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderSuccessPage extends StatelessWidget {
  final String orderId;
  final double total;
  final List<Map<String, dynamic>> items;
  final Map<String, dynamic> deliveryAddress;
  final String customerEmail;

  const OrderSuccessPage({
    super.key,
    required this.orderId,
    required this.total,
    required this.items,
    required this.deliveryAddress,
    required this.customerEmail,
  });

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Directionality(
      textDirection: app.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(app.t('order_success')),
          actions: const [LangToggleButton()],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${app.t('order_id')}: $orderId", style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text("${app.t('total')}: ${total.toStringAsFixed(2)} QAR",
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    if (customerEmail.trim().isNotEmpty) Text("${app.t('email')}: $customerEmail"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            Text(app.t('order_details'), style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),

            ...items.map((it) {
              final name = (it['name'] ?? '').toString();
              final qty = (it['qty'] ?? 0).toString();
              final price = (it['price'] ?? 0).toString();
              return Card(
                child: ListTile(
                  title: Text(name),
                  subtitle: Text(app.isArabic ? "الكمية: $qty" : "Qty: $qty"),
                  trailing: Text("$price QAR"),
                ),
              );
            }),

            const SizedBox(height: 12),
            if (deliveryAddress.isNotEmpty) ...[
              Text(app.t('delivery_address'), style: const TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Zone: ${deliveryAddress['zone'] ?? ''}"),
                      Text("Street: ${deliveryAddress['street'] ?? ''}"),
                      Text("Building: ${deliveryAddress['building'] ?? ''}"),
                      if ((deliveryAddress['apartment'] ?? '').toString().trim().isNotEmpty)
                        Text("Apartment: ${deliveryAddress['apartment']}"),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 14),
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                icon: const Icon(Icons.home_outlined),
                label: Text(app.isArabic ? 'العودة للرئيسية' : 'Back to home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* =========================
   SUPPORT (Placeholder)
   ========================= */

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final _ctrl = TextEditingController();
  final List<Map<String, String>> _chat = [];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _send() {
    final t = _ctrl.text.trim();
    if (t.isEmpty) return;
    setState(() {
      _chat.add({'role': 'user', 'text': t});
      _chat.add({'role': 'bot', 'text': 'تم استلام رسالتك. (واجهة فقط الآن)\n$t'});
    });
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Directionality(
      textDirection: app.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(app.t('support')),
          actions: const [LangToggleButton()],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _chat.length,
                itemBuilder: (context, i) {
                  final m = _chat[i];
                  final isUser = m['role'] == 'user';
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      constraints: const BoxConstraints(maxWidth: 320),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.black.withOpacity(0.06) : Colors.blue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(m['text'] ?? ''),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      decoration: InputDecoration(
                        hintText: app.isArabic ? 'اكتب سؤالك...' : 'Type your message...',
                        border: const OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed: _send,
                      child: Text(app.isArabic ? 'إرسال' : 'Send'),
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
   ADMIN PRODUCTS PANEL + EDITOR
   (كما هو عندك تقريبًا — بدون تغيير كبير)
   ========================= */

class AdminProductsPanelPage extends StatelessWidget {
  const AdminProductsPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final isAdmin = app.isAdmin;

    if (!isAdmin) {
      return Directionality(
        textDirection: app.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(title: Text(app.t('admin_panel'))),
          body: Center(child: Text(app.isArabic ? 'غير مصرح.' : 'Not allowed.')),
        ),
      );
    }

    return Directionality(
      textDirection: app.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(app.t('admin_panel')),
          actions: const [LangToggleButton()],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminProductEditorPage()),
            );
          },
          icon: const Icon(Icons.add),
          label: Text(app.t('add_product')),
        ),
        body: StreamBuilder<DatabaseEvent>(
          stream: productsRef().onValue,
          builder: (context, snap) {
            final raw = snap.data?.snapshot.value;
            final items = <_ProductRow>[];
            if (raw is Map) {
              raw.forEach((k, v) {
                if (v is Map) items.add(_ProductRow.fromMap(k.toString(), v));
              });
            }
            items.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            if (items.isEmpty) {
              return Center(child: Text(app.t('no_products')));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final p = items[i];
                final title = app.isArabic
                    ? p.name
                    : (p.nameEn.isNotEmpty ? p.nameEn : _offlineAiTranslateArToEn(p.name));
                return Card(
                  child: ListTile(
                    leading: _NetImg(url: p.imageUrl, w: 54, h: 54, r: 10),
                    title: Text(title),
                    subtitle: Text('${p.price.toStringAsFixed(2)} QAR  •  ${app.t('stock')}: ${p.stock ?? "N/A"}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AdminProductEditorPage(productId: p.id)),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class AdminProductEditorPage extends StatefulWidget {
  final String? productId;
  const AdminProductEditorPage({super.key, this.productId});

  @override
  State<AdminProductEditorPage> createState() => _AdminProductEditorPageState();
}

class _AdminProductEditorPageState extends State<AdminProductEditorPage> {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final _nameCtrl = TextEditingController();
  final _nameEnCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _stockCtrl = TextEditingController(text: '3');
  final _descCtrl = TextEditingController();
  final _descEnCtrl = TextEditingController();
  final _descExtraCtrl = TextEditingController();
  final _descExtraEnCtrl = TextEditingController();

  String _imageUrl = '';
  String _beforeUrl = '';
  String _afterUrl = '';
  final List<String> _gallery = [];

  bool _loading = false;

  DatabaseReference get _ref =>
      widget.productId == null ? productsRef() : productsRef().child(widget.productId!);

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      _load();
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameEnCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    _descCtrl.dispose();
    _descEnCtrl.dispose();
    _descExtraCtrl.dispose();
    _descExtraEnCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final snap = await _ref.get();
      final v = snap.value;
      if (v is Map) {
        _nameCtrl.text = (v['name'] ?? '').toString();
        _nameEnCtrl.text = (v['name_en'] ?? '').toString();
        _descCtrl.text = (v['desc'] ?? '').toString();
        _descEnCtrl.text = (v['desc_en'] ?? '').toString();
        _descExtraCtrl.text = (v['descExtra'] ?? '').toString();
        _descExtraEnCtrl.text = (v['descExtra_en'] ?? '').toString();

        final price = v['price'];
        _priceCtrl.text = (price is num) ? price.toString() : (price?.toString() ?? '');
        final stock = v['stock'];
        _stockCtrl.text = (stock is num) ? stock.toInt().toString() : (stock?.toString() ?? '3');

        _imageUrl = (v['imageUrl'] ?? '').toString();

        final gRaw = v['gallery'];
        _gallery.clear();
        if (gRaw is List) {
          for (final x in gRaw) {
            if (x != null && x.toString().trim().isNotEmpty) _gallery.add(x.toString());
          }
        }

        final ba = v['beforeAfter'];
        if (ba is Map) {
          _beforeUrl = (ba['beforeUrl'] ?? '').toString();
          _afterUrl = (ba['afterUrl'] ?? '').toString();
        }
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<String?> _pickAndUpload({required String folder, required String fileName}) async {
    final app = context.read<AppState>();
    final picker = ImagePicker();
    final x = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (x == null) return null;

    final file = File(x.path);
    final path = '$folder/$fileName';
    try {
      setState(() => _loading = true);
      final ref = _storage.ref().child(path);
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      snackMsg(app.isArabic ? 'خطأ رفع الصورة: $e' : 'Upload error: $e');
      return null;
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _setMainImage() async {
    final pid = widget.productId ?? 'new_${DateTime.now().millisecondsSinceEpoch}';
    final url = await _pickAndUpload(folder: 'products/$pid', fileName: 'thumb_${DateTime.now().millisecondsSinceEpoch}.jpg');
    if (url == null) return;
    setState(() => _imageUrl = url);
  }

  Future<void> _addGalleryImage() async {
    final pid = widget.productId ?? 'new_${DateTime.now().millisecondsSinceEpoch}';
    final url = await _pickAndUpload(folder: 'products/$pid', fileName: 'gallery_${DateTime.now().millisecondsSinceEpoch}.jpg');
    if (url == null) return;
    setState(() => _gallery.add(url));
  }

  Future<void> _setBefore() async {
    final pid = widget.productId ?? 'new_${DateTime.now().millisecondsSinceEpoch}';
    final url = await _pickAndUpload(folder: 'products/$pid', fileName: 'before_${DateTime.now().millisecondsSinceEpoch}.jpg');
    if (url == null) return;
    setState(() => _beforeUrl = url);
  }

  Future<void> _setAfter() async {
    final pid = widget.productId ?? 'new_${DateTime.now().millisecondsSinceEpoch}';
    final url = await _pickAndUpload(folder: 'products/$pid', fileName: 'after_${DateTime.now().millisecondsSinceEpoch}.jpg');
    if (url == null) return;
    setState(() => _afterUrl = url);
  }

  Future<void> _save() async {
    final app = context.read<AppState>();

    final name = _nameCtrl.text.trim();
    final nameEn = _nameEnCtrl.text.trim();
    final desc = _descCtrl.text.trim();
    final descEn = _descEnCtrl.text.trim();
    final descExtra = _descExtraCtrl.text.trim();
    final descExtraEn = _descExtraEnCtrl.text.trim();

    final price = double.tryParse(_priceCtrl.text.trim());
    final stock = int.tryParse(_stockCtrl.text.trim());

    if (name.isEmpty) {
      snackMsg(app.isArabic ? 'اكتب اسم المنتج.' : 'Enter product name.');
      return;
    }
    if (price == null) {
      snackMsg(app.isArabic ? 'اكتب سعر صحيح.' : 'Enter a valid price.');
      return;
    }
    if (stock == null || stock < 0) {
      snackMsg(app.isArabic ? 'اكتب رقم صحيح للمخزون.' : 'Enter a valid stock.');
      return;
    }

    setState(() => _loading = true);
    try {
      final isNew = widget.productId == null;
      final DatabaseReference target = isNew ? productsRef().push() : _ref;

      final createdAtExisting = isNew ? null : (await target.child('createdAt').get()).value;

      await target.set({
        'name': name,
        'name_en': nameEn,
        'desc': desc,
        'desc_en': descEn,
        'descExtra': descExtra,
        'descExtra_en': descExtraEn,
        'price': price,
        'stock': stock,
        'imageUrl': _imageUrl,
        'gallery': _gallery,
        'beforeAfter': {
          'beforeUrl': _beforeUrl,
          'afterUrl': _afterUrl,
        },
        'createdAt': isNew ? ServerValue.timestamp : (createdAtExisting ?? ServerValue.timestamp),
        'updatedAt': ServerValue.timestamp,
      });

      snackMsg(app.isArabic ? 'تم الحفظ ✅' : 'Saved ✅');
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      snackMsg('Error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _delete() async {
    final app = context.read<AppState>();
    if (widget.productId == null) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => Directionality(
        textDirection: app.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          scrollable: true,
          title: Text(app.isArabic ? 'حذف المنتج' : 'Delete product'),
          content: Text(app.isArabic ? 'متأكد؟' : 'Are you sure?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(_, false), child: Text(app.t('cancel'))),
            FilledButton(onPressed: () => Navigator.pop(_, true), child: Text(app.t('delete'))),
          ],
        ),
      ),
    );

    if (ok != true) return;

    setState(() => _loading = true);
    try {
      await _ref.remove();
      snackMsg(app.isArabic ? 'تم الحذف ✅' : 'Deleted ✅');
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      snackMsg('Error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Directionality(
      textDirection: app.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.productId == null ? app.t('add_product') : app.t('edit')),
          actions: [
            const LangToggleButton(),
            if (widget.productId != null)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: _loading ? null : _delete,
                tooltip: app.t('delete'),
              ),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  Text(app.isArabic ? 'الصورة الرئيسية' : 'Main image', style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _NetImg(url: _imageUrl, w: 90, h: 90, r: 14),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _setMainImage,
                          icon: const Icon(Icons.upload),
                          label: Text(app.isArabic ? 'رفع صورة' : 'Upload'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  TextField(controller: _nameCtrl, decoration: InputDecoration(labelText: app.isArabic ? 'اسم المنتج (AR)' : 'Name (AR)')),
                  const SizedBox(height: 10),
                  TextField(controller: _nameEnCtrl, decoration: InputDecoration(labelText: app.isArabic ? 'اسم المنتج (EN)' : 'Name (EN)')),

                  const SizedBox(height: 10),
                  TextField(
                    controller: _priceCtrl,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(labelText: app.t('price')),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _stockCtrl,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(labelText: app.t('stock')),
                  ),
                  const SizedBox(height: 10),

                  TextField(controller: _descCtrl, maxLines: 2, decoration: InputDecoration(labelText: app.isArabic ? 'وصف مختصر (AR)' : 'Short desc (AR)')),
                  const SizedBox(height: 10),
                  TextField(controller: _descEnCtrl, maxLines: 2, decoration: InputDecoration(labelText: app.isArabic ? 'وصف مختصر (EN)' : 'Short desc (EN)')),

                  const SizedBox(height: 10),
                  TextField(controller: _descExtraCtrl, maxLines: 3, decoration: InputDecoration(labelText: app.isArabic ? 'وصف إضافي (AR)' : 'Extra desc (AR)')),
                  const SizedBox(height: 10),
                  TextField(controller: _descExtraEnCtrl, maxLines: 3, decoration: InputDecoration(labelText: app.isArabic ? 'وصف إضافي (EN)' : 'Extra desc (EN)')),

                  const SizedBox(height: 14),
                  Text(app.isArabic ? 'قبل / بعد' : 'Before / After', style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(app.t('before')),
                            const SizedBox(height: 6),
                            _NetImg(url: _beforeUrl, w: double.infinity, h: 120, r: 14),
                            const SizedBox(height: 6),
                            OutlinedButton.icon(
                              onPressed: _setBefore,
                              icon: const Icon(Icons.upload),
                              label: Text(app.isArabic ? 'رفع قبل' : 'Upload before'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          children: [
                            Text(app.t('after')),
                            const SizedBox(height: 6),
                            _NetImg(url: _afterUrl, w: double.infinity, h: 120, r: 14),
                            const SizedBox(height: 6),
                            OutlinedButton.icon(
                              onPressed: _setAfter,
                              icon: const Icon(Icons.upload),
                              label: Text(app.isArabic ? 'رفع بعد' : 'Upload after'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Text(app.t('gallery'), style: const TextStyle(fontWeight: FontWeight.w800)),
                      ),
                      OutlinedButton.icon(
                        onPressed: _addGalleryImage,
                        icon: const Icon(Icons.add_photo_alternate_outlined),
                        label: Text(app.isArabic ? 'إضافة' : 'Add'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_gallery.isEmpty)
                    Text(app.isArabic ? 'لا توجد صور.' : 'No images.')
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(_gallery.length, (i) {
                        final url = _gallery[i];
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _NetImg(url: url, w: 92, h: 92, r: 14),
                            Positioned(
                              top: -8,
                              right: -8,
                              child: IconButton(
                                onPressed: () => setState(() => _gallery.removeAt(i)),
                                icon: const Icon(Icons.cancel, size: 20),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),

                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.save_outlined),
                      label: Text(app.t('save')),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
