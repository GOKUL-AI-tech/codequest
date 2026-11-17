import 'package:flutter/material.dart';

// ─── Delegate ─────────────────────────────────────────────────────────────────

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const supportedLocales = [
    Locale('en'), // English
    Locale('hi'), // Hindi
    Locale('ta'), // Tamil
    Locale('es'), // Spanish
    Locale('fr'), // French
  ];

  // ─── Helper ───────────────────────────────────────────────────────────────

  String _t(String key) {
    final langMap = _strings[locale.languageCode] ?? _strings['en']!;
    return langMap[key] ?? _strings['en']![key] ?? key;
  }

  // ─── App Info ─────────────────────────────────────────────────────────────
  String get appName => _t('appName');
  String get appTagline => _t('appTagline');

  // ─── Navigation ───────────────────────────────────────────────────────────
  String get navHome => _t('navHome');
  String get navLearn => _t('navLearn');
  String get navArena => _t('navArena');
  String get navRanks => _t('navRanks');
  String get navProfile => _t('navProfile');

  // ─── Auth ─────────────────────────────────────────────────────────────────
  String get signIn => _t('signIn');
  String get signOut => _t('signOut');
  String get signUp => _t('signUp');
  String get email => _t('email');
  String get password => _t('password');
  String get username => _t('username');
  String get forgotPassword => _t('forgotPassword');
  String get createAccount => _t('createAccount');
  String get welcomeBack => _t('welcomeBack');
  String get alreadyHaveAccount => _t('alreadyHaveAccount');
  String get dontHaveAccount => _t('dontHaveAccount');

  // ─── Home ─────────────────────────────────────────────────────────────────
  String get dailyMissions => _t('dailyMissions');
  String get learningPaths => _t('learningPaths');
  String get seeAll => _t('seeAll');
  String get goodMorning => _t('goodMorning');
  String get goodAfternoon => _t('goodAfternoon');
  String get goodEvening => _t('goodEvening');
  String get streak => _t('streak');
  String get lives => _t('lives');
  String get coins => _t('coins');
  String get level => _t('level');

  // ─── Learning ─────────────────────────────────────────────────────────────
  String get worlds => _t('worlds');
  String get chapters => _t('chapters');
  String get lessons => _t('lessons');
  String get quiz => _t('quiz');
  String get challenge => _t('challenge');
  String get bossBattle => _t('bossBattle');
  String get startLesson => _t('startLesson');
  String get continueLesson => _t('continueLesson');
  String get completed => _t('completed');
  String get locked => _t('locked');
  String get xpEarned => _t('xpEarned');
  String get lessonComplete => _t('lessonComplete');

  // ─── Arena ────────────────────────────────────────────────────────────────
  String get arena => _t('arena');
  String get battle => _t('battle');
  String get startBattle => _t('startBattle');
  String get opportunities => _t('opportunities');
  String get teamLadder => _t('teamLadder');
  String get mentorReferee => _t('mentorReferee');

  // ─── Leaderboard ──────────────────────────────────────────────────────────
  String get leaderboard => _t('leaderboard');
  String get global => _t('global');
  String get weekly => _t('weekly');
  String get friends => _t('friends');
  String get rank => _t('rank');
  String get yourRank => _t('yourRank');

  // ─── Profile ──────────────────────────────────────────────────────────────
  String get profile => _t('profile');
  String get achievements => _t('achievements');
  String get codeDna => _t('codeDna');
  String get certificates => _t('certificates');
  String get shareMyStreak => _t('shareMyStreak');

  // ─── Settings ─────────────────────────────────────────────────────────────
  String get settings => _t('settings');
  String get notifications => _t('notifications');
  String get notificationSettings => _t('notificationSettings');
  String get soundEffects => _t('soundEffects');
  String get hapticFeedback => _t('hapticFeedback');
  String get appearance => _t('appearance');
  String get darkMode => _t('darkMode');
  String get lightMode => _t('lightMode');
  String get language => _t('language');
  String get subscription => _t('subscription');
  String get goPremium => _t('goPremium');
  String get support => _t('support');
  String get helpFaq => _t('helpFaq');
  String get reportBug => _t('reportBug');
  String get privacyPolicy => _t('privacyPolicy');
  String get account => _t('account');
  String get editProfile => _t('editProfile');
  String get changePassword => _t('changePassword');

  // ─── Common ───────────────────────────────────────────────────────────────
  String get save => _t('save');
  String get cancel => _t('cancel');
  String get continueStr => _t('continueStr');
  String get back => _t('back');
  String get loading => _t('loading');
  String get error => _t('error');
  String get success => _t('success');
  String get submit => _t('submit');
  String get close => _t('close');
  String get yes => _t('yes');
  String get no => _t('no');
  String get or => _t('or');
  String get search => _t('search');
  String get share => _t('share');
  String get copy => _t('copy');
  String get tryAgain => _t('tryAgain');
  String get comingSoon => _t('comingSoon');

  // ─── Features ─────────────────────────────────────────────────────────────
  String get dailyDrop => _t('dailyDrop');
  String get typingRace => _t('typingRace');
  String get codePlayground => _t('codePlayground');
  String get interviewPrep => _t('interviewPrep');
  String get roadmap => _t('roadmap');
  String get aiMentor => _t('aiMentor');
  String get shop => _t('shop');
  String get guilds => _t('guilds');

  // ─── Greeting helper ──────────────────────────────────────────────────────
  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return goodMorning;
    if (hour < 17) return goodAfternoon;
    return goodEvening;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STRING MAPS
  // ═══════════════════════════════════════════════════════════════════════════

  static const Map<String, Map<String, String>> _strings = {
    // ── ENGLISH ─────────────────────────────────────────────────────────────
    'en': {
      'appName': 'CodeQuest',
      'appTagline': 'Code. Level Up. Conquer.',
      'navHome': 'Home',
      'navLearn': 'Learn',
      'navArena': 'Arena',
      'navRanks': 'Ranks',
      'navProfile': 'Profile',
      'signIn': 'Sign In',
      'signOut': 'Sign Out',
      'signUp': 'Sign Up',
      'email': 'Email',
      'password': 'Password',
      'username': 'Username',
      'forgotPassword': 'Forgot Password?',
      'createAccount': 'Create Account',
      'welcomeBack': 'Welcome Back',
      'alreadyHaveAccount': 'Already have an account?',
      'dontHaveAccount': "Don't have an account?",
      'dailyMissions': 'Daily Missions',
      'learningPaths': 'Learning Paths',
      'seeAll': 'SEE ALL →',
      'goodMorning': 'Good Morning',
      'goodAfternoon': 'Good Afternoon',
      'goodEvening': 'Good Evening',
      'streak': 'Streak',
      'lives': 'Lives',
      'coins': 'Coins',
      'level': 'Level',
      'worlds': 'Worlds',
      'chapters': 'Chapters',
      'lessons': 'Lessons',
      'quiz': 'Quiz',
      'challenge': 'Challenge',
      'bossBattle': 'Boss Battle',
      'startLesson': 'Start Lesson',
      'continueLesson': 'Continue',
      'completed': 'Completed',
      'locked': 'Locked',
      'xpEarned': 'XP Earned',
      'lessonComplete': 'Lesson Complete!',
      'arena': 'Arena',
      'battle': 'Battle',
      'startBattle': 'Start Battle',
      'opportunities': 'Opportunities',
      'teamLadder': 'Team Ladder',
      'mentorReferee': 'Mentor Referee',
      'leaderboard': 'Leaderboard',
      'global': 'Global',
      'weekly': 'Weekly',
      'friends': 'Friends',
      'rank': 'Rank',
      'yourRank': 'Your Rank',
      'profile': 'Profile',
      'achievements': 'Achievements',
      'codeDna': 'Code DNA',
      'certificates': 'Certificates',
      'shareMyStreak': 'Share My Streak',
      'settings': 'Settings',
      'notifications': 'Notifications',
      'notificationSettings': 'Notification Settings',
      'soundEffects': 'Sound Effects',
      'hapticFeedback': 'Haptic Feedback',
      'appearance': 'Appearance',
      'darkMode': 'Dark Mode',
      'lightMode': 'Light Mode',
      'language': 'Language',
      'subscription': 'Subscription',
      'goPremium': 'Go Premium',
      'support': 'Support',
      'helpFaq': 'Help & FAQ',
      'reportBug': 'Report a Bug',
      'privacyPolicy': 'Privacy Policy',
      'account': 'Account',
      'editProfile': 'Edit Profile',
      'changePassword': 'Change Password',
      'save': 'Save',
      'cancel': 'Cancel',
      'continueStr': 'Continue',
      'back': 'Back',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'submit': 'Submit',
      'close': 'Close',
      'yes': 'Yes',
      'no': 'No',
      'or': 'or',
      'search': 'Search',
      'share': 'Share',
      'copy': 'Copy',
      'tryAgain': 'Try Again',
      'comingSoon': 'Coming Soon',
      'dailyDrop': 'Daily Code Drop',
      'typingRace': 'Typing Race',
      'codePlayground': 'Code Playground',
      'interviewPrep': 'Interview Prep',
      'roadmap': 'Learning Roadmap',
      'aiMentor': 'AI Mentor',
      'shop': 'Shop',
      'guilds': 'Guilds',
    },

    // ── HINDI ────────────────────────────────────────────────────────────────
    'hi': {
      'appName': 'CodeQuest',
      'appTagline': 'कोड करें। आगे बढ़ें। जीतें।',
      'navHome': 'होम',
      'navLearn': 'सीखें',
      'navArena': 'अखाड़ा',
      'navRanks': 'रैंक',
      'navProfile': 'प्रोफ़ाइल',
      'signIn': 'साइन इन',
      'signOut': 'साइन आउट',
      'signUp': 'साइन अप',
      'email': 'ईमेल',
      'password': 'पासवर्ड',
      'username': 'उपयोगकर्ता नाम',
      'forgotPassword': 'पासवर्ड भूल गए?',
      'createAccount': 'खाता बनाएं',
      'welcomeBack': 'वापसी पर स्वागत है',
      'alreadyHaveAccount': 'पहले से खाता है?',
      'dontHaveAccount': 'खाता नहीं है?',
      'dailyMissions': 'दैनिक मिशन',
      'learningPaths': 'सीखने के रास्ते',
      'seeAll': 'सभी देखें →',
      'goodMorning': 'सुप्रभात',
      'goodAfternoon': 'शुभ दोपहर',
      'goodEvening': 'शुभ संध्या',
      'streak': 'स्ट्रीक',
      'lives': 'जीवन',
      'coins': 'सिक्के',
      'level': 'स्तर',
      'worlds': 'दुनिया',
      'chapters': 'अध्याय',
      'lessons': 'पाठ',
      'quiz': 'क्विज़',
      'challenge': 'चुनौती',
      'bossBattle': 'बॉस युद्ध',
      'startLesson': 'पाठ शुरू करें',
      'continueLesson': 'जारी रखें',
      'completed': 'पूर्ण',
      'locked': 'बंद',
      'xpEarned': 'XP अर्जित',
      'lessonComplete': 'पाठ पूरा हुआ!',
      'arena': 'अखाड़ा',
      'battle': 'युद्ध',
      'startBattle': 'युद्ध शुरू करें',
      'opportunities': 'अवसर',
      'teamLadder': 'टीम सीढ़ी',
      'mentorReferee': 'मेंटर रेफरी',
      'leaderboard': 'लीडरबोर्ड',
      'global': 'वैश्विक',
      'weekly': 'साप्ताहिक',
      'friends': 'मित्र',
      'rank': 'रैंक',
      'yourRank': 'आपकी रैंक',
      'profile': 'प्रोफ़ाइल',
      'achievements': 'उपलब्धियां',
      'codeDna': 'कोड DNA',
      'certificates': 'प्रमाणपत्र',
      'shareMyStreak': 'मेरी स्ट्रीक शेयर करें',
      'settings': 'सेटिंग्स',
      'notifications': 'सूचनाएं',
      'notificationSettings': 'सूचना सेटिंग्स',
      'soundEffects': 'साउंड इफेक्ट्स',
      'hapticFeedback': 'हैप्टिक फीडबैक',
      'appearance': 'रूप-रंग',
      'darkMode': 'डार्क मोड',
      'lightMode': 'लाइट मोड',
      'language': 'भाषा',
      'subscription': 'सदस्यता',
      'goPremium': 'प्रीमियम लें',
      'support': 'सहायता',
      'helpFaq': 'सहायता और FAQ',
      'reportBug': 'बग रिपोर्ट करें',
      'privacyPolicy': 'गोपनीयता नीति',
      'account': 'खाता',
      'editProfile': 'प्रोफ़ाइल संपादित करें',
      'changePassword': 'पासवर्ड बदलें',
      'save': 'सेव करें',
      'cancel': 'रद्द करें',
      'continueStr': 'जारी रखें',
      'back': 'वापस',
      'loading': 'लोड हो रहा है...',
      'error': 'त्रुटि',
      'success': 'सफलता',
      'submit': 'सबमिट करें',
      'close': 'बंद करें',
      'yes': 'हां',
      'no': 'नहीं',
      'or': 'या',
      'search': 'खोजें',
      'share': 'शेयर करें',
      'copy': 'कॉपी करें',
      'tryAgain': 'फिर कोशिश करें',
      'comingSoon': 'जल्द आ रहा है',
      'dailyDrop': 'दैनिक कोड ड्रॉप',
      'typingRace': 'टाइपिंग रेस',
      'codePlayground': 'कोड प्लेग्राउंड',
      'interviewPrep': 'इंटरव्यू तैयारी',
      'roadmap': 'सीखने का रोडमैप',
      'aiMentor': 'AI मेंटर',
      'shop': 'शॉप',
      'guilds': 'गिल्ड्स',
    },

    // ── TAMIL ─────────────────────────────────────────────────────────────────
    'ta': {
      'appName': 'CodeQuest',
      'appTagline': 'குறியிடு. மேலேறு. வெற்றிகொள்.',
      'navHome': 'முகப்பு',
      'navLearn': 'கற்றல்',
      'navArena': 'அரங்கம்',
      'navRanks': 'தரவரிசை',
      'navProfile': 'சுயவிவரம்',
      'signIn': 'உள்நுழை',
      'signOut': 'வெளியேறு',
      'signUp': 'பதிவுசெய்',
      'email': 'மின்னஞ்சல்',
      'password': 'கடவுச்சொல்',
      'username': 'பயனர் பெயர்',
      'forgotPassword': 'கடவுச்சொல் மறந்தீர்களா?',
      'createAccount': 'கணக்கு உருவாக்கு',
      'welcomeBack': 'மீண்டும் வரவேற்கிறோம்',
      'alreadyHaveAccount': 'ஏற்கனவே கணக்கு உள்ளதா?',
      'dontHaveAccount': 'கணக்கு இல்லையா?',
      'dailyMissions': 'தினசரி பணிகள்',
      'learningPaths': 'கற்றல் பாதைகள்',
      'seeAll': 'அனைத்தும் காண →',
      'goodMorning': 'காலை வணக்கம்',
      'goodAfternoon': 'மதிய வணக்கம்',
      'goodEvening': 'மாலை வணக்கம்',
      'streak': 'தொடர்ச்சி',
      'lives': 'உயிர்கள்',
      'coins': 'நாணயங்கள்',
      'level': 'நிலை',
      'worlds': 'உலகங்கள்',
      'chapters': 'அத்தியாயங்கள்',
      'lessons': 'பாடங்கள்',
      'quiz': 'வினாடிவினா',
      'challenge': 'சவால்',
      'bossBattle': 'பாஸ் போர்',
      'startLesson': 'பாடம் தொடங்கு',
      'continueLesson': 'தொடரவும்',
      'completed': 'முடிந்தது',
      'locked': 'பூட்டப்பட்டது',
      'xpEarned': 'XP சம்பாதித்தது',
      'lessonComplete': 'பாடம் முடிந்தது!',
      'arena': 'அரங்கம்',
      'battle': 'போர்',
      'startBattle': 'போர் தொடங்கு',
      'opportunities': 'வாய்ப்புகள்',
      'teamLadder': 'குழு ஏணி',
      'mentorReferee': 'வழிகாட்டி நடுவர்',
      'leaderboard': 'தரவரிசை பலகை',
      'global': 'உலகளாவிய',
      'weekly': 'வாராந்திர',
      'friends': 'நண்பர்கள்',
      'rank': 'தரம்',
      'yourRank': 'உங்கள் தரம்',
      'profile': 'சுயவிவரம்',
      'achievements': 'சாதனைகள்',
      'codeDna': 'குறியீடு DNA',
      'certificates': 'சான்றிதழ்கள்',
      'shareMyStreak': 'என் தொடர்ச்சியை பகிர்',
      'settings': 'அமைப்புகள்',
      'notifications': 'அறிவிப்புகள்',
      'notificationSettings': 'அறிவிப்பு அமைப்புகள்',
      'soundEffects': 'ஒலி விளைவுகள்',
      'hapticFeedback': 'ஹாப்டிக் பின்னூட்டம்',
      'appearance': 'தோற்றம்',
      'darkMode': 'இருண்ட முறை',
      'lightMode': 'ஒளி முறை',
      'language': 'மொழி',
      'subscription': 'சந்தா',
      'goPremium': 'பிரீமியம் பெறு',
      'support': 'ஆதரவு',
      'helpFaq': 'உதவி & FAQ',
      'reportBug': 'பிழை தெரிவிக்க',
      'privacyPolicy': 'தனியுரிமை கொள்கை',
      'account': 'கணக்கு',
      'editProfile': 'சுயவிவரம் திருத்து',
      'changePassword': 'கடவுச்சொல் மாற்று',
      'save': 'சேமி',
      'cancel': 'ரத்துசெய்',
      'continueStr': 'தொடரவும்',
      'back': 'திரும்பு',
      'loading': 'ஏற்றுகிறது...',
      'error': 'பிழை',
      'success': 'வெற்றி',
      'submit': 'சமர்ப்பி',
      'close': 'மூடு',
      'yes': 'ஆம்',
      'no': 'இல்லை',
      'or': 'அல்லது',
      'search': 'தேடு',
      'share': 'பகிர்',
      'copy': 'நகலெடு',
      'tryAgain': 'மீண்டும் முயற்சி',
      'comingSoon': 'விரைவில் வருகிறது',
      'dailyDrop': 'தினசரி குறியீடு சொட்டு',
      'typingRace': 'தட்டச்சு பந்தயம்',
      'codePlayground': 'குறியீடு விளையாட்டு மைதானம்',
      'interviewPrep': 'நேர்காணல் தயாரிப்பு',
      'roadmap': 'கற்றல் வரைபடம்',
      'aiMentor': 'AI வழிகாட்டி',
      'shop': 'கடை',
      'guilds': 'குழுக்கள்',
    },

    // ── SPANISH ───────────────────────────────────────────────────────────────
    'es': {
      'appName': 'CodeQuest',
      'appTagline': 'Programa. Sube de nivel. Conquista.',
      'navHome': 'Inicio',
      'navLearn': 'Aprender',
      'navArena': 'Arena',
      'navRanks': 'Rangos',
      'navProfile': 'Perfil',
      'signIn': 'Iniciar sesión',
      'signOut': 'Cerrar sesión',
      'signUp': 'Registrarse',
      'email': 'Correo electrónico',
      'password': 'Contraseña',
      'username': 'Nombre de usuario',
      'forgotPassword': '¿Olvidaste tu contraseña?',
      'createAccount': 'Crear cuenta',
      'welcomeBack': 'Bienvenido de vuelta',
      'alreadyHaveAccount': '¿Ya tienes una cuenta?',
      'dontHaveAccount': '¿No tienes cuenta?',
      'dailyMissions': 'Misiones Diarias',
      'learningPaths': 'Rutas de Aprendizaje',
      'seeAll': 'VER TODO →',
      'goodMorning': 'Buenos días',
      'goodAfternoon': 'Buenas tardes',
      'goodEvening': 'Buenas noches',
      'streak': 'Racha',
      'lives': 'Vidas',
      'coins': 'Monedas',
      'level': 'Nivel',
      'worlds': 'Mundos',
      'chapters': 'Capítulos',
      'lessons': 'Lecciones',
      'quiz': 'Prueba',
      'challenge': 'Desafío',
      'bossBattle': 'Batalla Final',
      'startLesson': 'Iniciar lección',
      'continueLesson': 'Continuar',
      'completed': 'Completado',
      'locked': 'Bloqueado',
      'xpEarned': 'XP ganado',
      'lessonComplete': '¡Lección completa!',
      'arena': 'Arena',
      'battle': 'Batalla',
      'startBattle': 'Iniciar batalla',
      'opportunities': 'Oportunidades',
      'teamLadder': 'Escalera de equipos',
      'mentorReferee': 'Árbitro mentor',
      'leaderboard': 'Clasificación',
      'global': 'Global',
      'weekly': 'Semanal',
      'friends': 'Amigos',
      'rank': 'Rango',
      'yourRank': 'Tu rango',
      'profile': 'Perfil',
      'achievements': 'Logros',
      'codeDna': 'ADN del código',
      'certificates': 'Certificados',
      'shareMyStreak': 'Compartir mi racha',
      'settings': 'Ajustes',
      'notifications': 'Notificaciones',
      'notificationSettings': 'Ajustes de notificaciones',
      'soundEffects': 'Efectos de sonido',
      'hapticFeedback': 'Retroalimentación háptica',
      'appearance': 'Apariencia',
      'darkMode': 'Modo oscuro',
      'lightMode': 'Modo claro',
      'language': 'Idioma',
      'subscription': 'Suscripción',
      'goPremium': 'Ir a Premium',
      'support': 'Soporte',
      'helpFaq': 'Ayuda y FAQ',
      'reportBug': 'Reportar un error',
      'privacyPolicy': 'Política de privacidad',
      'account': 'Cuenta',
      'editProfile': 'Editar perfil',
      'changePassword': 'Cambiar contraseña',
      'save': 'Guardar',
      'cancel': 'Cancelar',
      'continueStr': 'Continuar',
      'back': 'Volver',
      'loading': 'Cargando...',
      'error': 'Error',
      'success': 'Éxito',
      'submit': 'Enviar',
      'close': 'Cerrar',
      'yes': 'Sí',
      'no': 'No',
      'or': 'o',
      'search': 'Buscar',
      'share': 'Compartir',
      'copy': 'Copiar',
      'tryAgain': 'Intentar de nuevo',
      'comingSoon': 'Próximamente',
      'dailyDrop': 'Desafío diario',
      'typingRace': 'Carrera de escritura',
      'codePlayground': 'Área de código',
      'interviewPrep': 'Prep. de entrevistas',
      'roadmap': 'Hoja de ruta',
      'aiMentor': 'Mentor IA',
      'shop': 'Tienda',
      'guilds': 'Gremios',
    },

    // ── FRENCH ────────────────────────────────────────────────────────────────
    'fr': {
      'appName': 'CodeQuest',
      'appTagline': 'Codez. Montez de niveau. Conquérez.',
      'navHome': 'Accueil',
      'navLearn': 'Apprendre',
      'navArena': 'Arène',
      'navRanks': 'Classement',
      'navProfile': 'Profil',
      'signIn': 'Se connecter',
      'signOut': 'Se déconnecter',
      'signUp': "S'inscrire",
      'email': 'E-mail',
      'password': 'Mot de passe',
      'username': "Nom d'utilisateur",
      'forgotPassword': 'Mot de passe oublié ?',
      'createAccount': 'Créer un compte',
      'welcomeBack': 'Bon retour',
      'alreadyHaveAccount': 'Vous avez déjà un compte ?',
      'dontHaveAccount': "Pas de compte ?",
      'dailyMissions': 'Missions quotidiennes',
      'learningPaths': "Parcours d'apprentissage",
      'seeAll': 'TOUT VOIR →',
      'goodMorning': 'Bonjour',
      'goodAfternoon': 'Bon après-midi',
      'goodEvening': 'Bonsoir',
      'streak': 'Série',
      'lives': 'Vies',
      'coins': 'Pièces',
      'level': 'Niveau',
      'worlds': 'Mondes',
      'chapters': 'Chapitres',
      'lessons': 'Leçons',
      'quiz': 'Quiz',
      'challenge': 'Défi',
      'bossBattle': 'Combat de boss',
      'startLesson': 'Commencer la leçon',
      'continueLesson': 'Continuer',
      'completed': 'Terminé',
      'locked': 'Verrouillé',
      'xpEarned': 'XP gagné',
      'lessonComplete': 'Leçon terminée !',
      'arena': 'Arène',
      'battle': 'Combat',
      'startBattle': 'Commencer le combat',
      'opportunities': 'Opportunités',
      'teamLadder': "Échelle d'équipe",
      'mentorReferee': 'Arbitre mentor',
      'leaderboard': 'Classement',
      'global': 'Mondial',
      'weekly': 'Hebdomadaire',
      'friends': 'Amis',
      'rank': 'Rang',
      'yourRank': 'Votre rang',
      'profile': 'Profil',
      'achievements': 'Succès',
      'codeDna': 'ADN du code',
      'certificates': 'Certificats',
      'shareMyStreak': 'Partager ma série',
      'settings': 'Paramètres',
      'notifications': 'Notifications',
      'notificationSettings': 'Paramètres de notification',
      'soundEffects': 'Effets sonores',
      'hapticFeedback': 'Retour haptique',
      'appearance': 'Apparence',
      'darkMode': 'Mode sombre',
      'lightMode': 'Mode clair',
      'language': 'Langue',
      'subscription': 'Abonnement',
      'goPremium': 'Passer Premium',
      'support': 'Support',
      'helpFaq': 'Aide et FAQ',
      'reportBug': 'Signaler un bug',
      'privacyPolicy': 'Politique de confidentialité',
      'account': 'Compte',
      'editProfile': 'Modifier le profil',
      'changePassword': 'Changer le mot de passe',
      'save': 'Enregistrer',
      'cancel': 'Annuler',
      'continueStr': 'Continuer',
      'back': 'Retour',
      'loading': 'Chargement...',
      'error': 'Erreur',
      'success': 'Succès',
      'submit': 'Soumettre',
      'close': 'Fermer',
      'yes': 'Oui',
      'no': 'Non',
      'or': 'ou',
      'search': 'Rechercher',
      'share': 'Partager',
      'copy': 'Copier',
      'tryAgain': 'Réessayer',
      'comingSoon': 'Bientôt disponible',
      'dailyDrop': 'Défi quotidien',
      'typingRace': 'Course de frappe',
      'codePlayground': 'Terrain de jeu',
      'interviewPrep': "Prep. d'entretien",
      'roadmap': "Feuille de route",
      'aiMentor': 'Mentor IA',
      'shop': 'Boutique',
      'guilds': 'Guildes',
    },
  };
}

// ─── Delegate ─────────────────────────────────────────────────────────────────

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales
          .map((l) => l.languageCode)
          .contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
