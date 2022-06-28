import 'package:shared_preferences/shared_preferences.dart';

class ArabicAndEnglish {
  static bool isArabic;

  static Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var arabic = sharedPreferences.getBool("isArabic");
    isArabic = arabic;
  }

  static List welcomeEnglish = [
    "Welcome",
    "needier",
    "helper",
    "Wanna know more?",
    "About us"
  ];

  static List welcomeArabic = [
    "مرحبًا",
    "محتاج",
    "مساعد",
    "هل تريد معرفة المزيد؟",
    "معلومات عنا"
  ];

  static List englishLogIn = [
    "Sign In",
    "Email",
    "Enter your E.mail",
    "E.mail is Required",
    "Please enter a valid email Address",
    "Password",
    "Enter your password",
    "Password is required",
    "Should be at least 6 characters",
    "Should have special characters, numbers and Capital letters",
    "Forget Password",
    "Remember me",
    "LOGIN",
    "Don't have an Account?",
    "Sign Up",
    "Don't have an account, Create an account",
    "Login successful"
  ];
  static List arabicLogIn = [
    "تسجيل الدخول",
    "البريد الالكتروني",
    "ادخل بريدك الالكتروني",
    "البريد الالكتروني مطلوب",
    "من فضلك ادخل بريد الكتروني صحيح",
    "كلمة السر",
    "ادخل كلمة السر",
    "كلمة السر مطلوبة",
    "يجب أن تكون اكثر من 6 حروف",
    "يجب أن تتكون من رموز وأرقام و حروف كبيرة",
    "نسيت كلمة السر",
    "تذكرني",
    "تسجيل الدخول",
    "ليست لديك حساب؟",
    "تسجيل",
    "ليس لديك حساب ، قم بإنشاء حساب",
    "تم تسجيل الدخول بنجاح"
  ];

  static List englishForget = [
    "Forget Password",
    "Email",
    "Enter your E.mail",
    "E.mail is Required",
    "Please enter a valid email Address",
    "Click email",
    "Verify password",
    "Click verify button to reset password",
    "This account not in our database",
    "Your password has been reset:",
  ];

  static List arabicForget = [
    "نسيت كلمة السر",
    "البريد الالكتروني",
    "ادخل بريدك الالكتروني",
    "البريد الالكتروني مطلوب",
    "من فضلك ادخل بريد الكتروني صحيح",
    "التحقق من البريد الالكتروني",
    "اعادة كلمة السر",
    "انقر فوق زر التحقق لإعادة تعيين كلمة المرور",
    "هذا الحساب ليس في قاعدة بياناتنا",
    "تم إعادة تعيين كلمة المرور الخاصة بك:"
  ];

  static List englishDrawer = [
    "Account",
    "History",
    "Settings",
    "Language",
    "Help Center",
    "Log Out",
    "Are you sure you want to log out?",
    "Yes",
    "No",
    "One Hour",
    "Have time to help?",
    "Wanna help?",
    "accepted to Help you",
    "Arabic",
    "English",
    "Awards",
    "Information helper"
  ];

  static List arabicDrawer = [
    "حسابي",
    "السجل",
    "اعدادات",
    "اللغة",
    "مركز المساعدة",
    "تسجيل خروج",
    "هل بالتأكيد انت تريد تسجيل الخروج؟",
    "نعم",
    "لا",
    "One Hour",
    "لديك وقت للمساعدة؟",
    "اريد المساعدة",
    "قبل المساعدة",
    "عربي",
    "انجليزي",
    "الجوائز",
    "بيانات المساعد"
  ];

  static List signUpHelperEnglish = [
    'New helper account',
    'First name',
    'Enter your first name',
    "first Name is required",
    'Middle name',
    'Enter your Middle name',
    "Middle Name is required",
    'last name',
    'Enter your last name',
    "last Name is required",
    'Address',
    'Enter your Address',
    'Address is required',
    'SSN',
    'Enter your SSN',
    'SSN is Required',
    'SSN must be 14 characters long.',
    'SSN must be 14 characters long.',
    'Phone number',
    'Enter your phone number',
    'Phone number is Required',
    'phone number must be 11 characters long.',
    'phone number must be 11 characters long.',
    'Phone number 2',
    'Enter your phone number 2',
    'Phone number is Required',
    'phone number must be 11 characters long.',
    'phone number must be 11 characters long.',
    'E.mail',
    'Enter your E.mail',
    'E.mail is Required',
    'Please enter a valid email Address',
    "Password",
    "Enter your password",
    "Password is required",
    "Should be at least 6 characters",
    "Should have special characters, numbers and Capital letters",
    'Confirm Password',
    'Enter confirm password',
    'Confirm Password is required',
    "Password does not match",
    "Available Time:",
    "City:",
    "Select your city",
    "Gender:",
    "Female",
    "Male",
    "Sign UP",
    "Service Type",
    "Service Name",
    "Accept",
    "points:",
    "My Profile",
    "Update",
    "Edit Profile",
    "account already exists",
    "Registration successful",
    "Review",
    "Select review",
    "Please select review",
    "Accept",
    "Refusal",
    "One Hour",
    "Have time to help?",
    "Wanna help?",
    "accepted to Help you",
    "Delete",
    "Name",
    "My review",
    "helper information"
  ];

  static List signUpHelperArabic = [
    'حساب مساعد جديد',
    'الاسم الاول',
    'ادخل اسمك الاول',
    "الاسم الاول مطلوب",
    'الاسم الاوسط',
    'ادخل اسمك الاوسط',
    'اسمك الاوسط مطلوب',
    'الاسم الاخير',
    'ادخل اسمك الاخير',
    'اسمك الاخير مطلوب',
    'العنوان',
    'ادخل عنوانك',
    'العنوان مطلوب',
    'الرقم القومي',
    'ادخل رقمك القومي',
    'الرقم القومي مطلوب',
    'يجب أن يتكون الرقم القومي من 13 حرفًا',
    'يجب أن يتكون الرقم القومي من 13 حرفًا',
    'رقم الموبايل',
    'ادخل رقم موبايل',
    'رقم الموبايل مطلوب',
    'يجب أن يتكون رقم الموبايل من 11 حرفًا',
    'يجب أن يتكون رقم الموبايل من 11 حرفًا',
    'رقم الموبايل 2',
    'ادخل رقم موبايل 2',
    'رقم الموبايل مطلوب',
    'يجب أن يتكون رقم الموبايل من 11 حرفًا',
    'يجب أن يتكون رقم الموبايل من 11 حرفًا',
    "البريد الالكتروني",
    "ادخل بريدك الالكتروني",
    "البريد الالكتروني مطلوب",
    "من فضلك ادخل بريد الكتروني صحيح",
    "كلمة السر",
    "ادخل كلمة السر",
    "كلمة السر مطلوبة",
    "يجب أن تكون اكثر من 6 حروف",
    "يجب أن تتكون من رموز وأرقام و حروف كبيرة",
    "تأكيد كلمة السر",
    "ادخل تأكيد كلمة السر",
    "تأكيد كلمة السر مطلوب",
    "كلمة السر غير مطابقة",
    "الوقت المتاح:",
    "المدينة:",
    "اختر مدينتك",
    "النوع:",
    "أنثى",
    "ذكر",
    "تسجيل",
    "نوع الخدمة",
    "اسم الخدمة",
    "قبول",
    "نقاط:",
    "حسابي",
    "تحديث",
    "تعديل حسابي",
    "البريد موجود بالفعل",
    "تم التسجيل بنجاح",
    "تقييم",
    "اختار تقييم",
    "من فضلك اختر تقييم",
    "موافق",
    "غير موافق",
    "One Hour",
    "لديك وقت للمساعدة؟",
    "اريد المساعدة",
    "قبل المساعدة",
    "حذف",
    "الاسم",
    "تقييمي",
    "معلومات المساعد"
  ];

  static List formEnglish = [
    "Help Form",
    "Day you want to Help",
    "Time you want to Help",
    "Service Type:",
    "Service Name:",
    "City:",
    "Update Form",
    "Select service type",
    "Select service name",
    "Select your city",
    "Done",
    "Address",
    'Enter your Address',
    "Address is required",
    'Add comment',
    'Add more details about service',
    'Comment',
    "Comment is required",
  ];

  static List formArabic = [
    "نموذج المساعدة",
    "اليوم الذي تريد المساعدة فيه",
    "الوقت الذي تريد المساعدة فيه",
    "نوع الخدمة:",
    "اسم الخدمة",
    "المدينة:",
    "تحديث النموذج",
    "اختر نوع الخدمة",
    "اختر اسم الخدمة",
    "اختر مدينتك",
    "تم",
    "العنوان",
    "ادخل عنوانك",
    "العنوان مطلوب",
    "اضافة تعليق",
    "أضف المزيد من التفاصيل حول الخدمة",
  ];

  static List settingsEnglish = [
    "Settings",
    'Account',
    'Edit Password',
    'Are you sure you want to delete account?',
    "No",
    "Yes",
    'Notifications',
    'Accept Request For You',
    'Reviews',
    'Dark Mode',
    "Delete Account",
    "New request for you",
    "Reviews",
    "Points of you"
  ];

  static List settingsArabic = [
    "الاعدادات",
    'حسابي',
    'تعديل كلمة السر',
    'هل انت متأكد انك تريد حذف الحساب؟',
    "لا",
    "نعم",
    'الاشعارات',
    'قبول الطلب لك',
    'المراجعات',
    'الوضع المظلم',
    "حذف الحساب",
    "طلب جديد لك",
    "المراجعات",
    "نقاطك"
  ];

  static List editPasswordEnglish = [
    "Edit Password",
    'Old Password',
    'Enter your old password',
    'Password is required',
    'Should be at least 6 characters',
    'Should have special characters, numbers and Capital letters',
    "This password is field",
    'New Password',
    'Enter your new password',
    'Confirm new Password',
    'Enter confirm new password',
    'Confirm Password is required',
    "Password does not match",
    'Update Password'
  ];

  static List editPasswordArabic = [
    "تعديل كلمة السر",
    'كلمة السر القديمة',
    'ادخل كلمة السر القديمة',
    'كلمة السر مطلوبة',
    "يجب أن تكون اكثر من 6 حروف",
    "يجب أن تتكون من رموز وأرقام و حروف كبيرة",
    "كلمة السر خطأ",
    "كلمة السر الجديدة",
    "ادخل كلمة السر الجديدة",
    "تأكيد كلمة السر الجديدة",
    "ادخل تأكيد كلمة السر الجديدة",
    "تأكيد كلمة السر مطلوب",
    "كلمة السر غير مطابقة",
    'تحديث كلمة السر'
  ];
}
