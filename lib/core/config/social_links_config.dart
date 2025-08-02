/// ============================================
/// 🔗 SOCIAL LINKS CONFIGURATION
/// ============================================
///
/// ⚠️ IMPORTANT: Update this file with your own social media links!
///
/// 📝 Instructions:
/// 1. Replace all URLs below with your actual social media profiles
/// 2. Update email and phone number with your contact information
/// 3. Update CV download URL with your hosted resume link
/// 4. Customize email template for hire me button
///
/// 🔗 Social Media URL Examples:
/// - Instagram: https://instagram.com/your_username
/// - Twitter: https://twitter.com/your_username
/// - LinkedIn: https://linkedin.com/in/your_profile
/// - GitHub: https://github.com/your_username
/// - Medium: https://medium.com/@your_username
///
/// 📄 CV Hosting Options:
/// - Google Drive: Share file publicly and get link
/// - Dropbox: Share file and get public link
/// - Your website: Direct link to PDF file
///
/// ============================================

class SocialLinksConfig {
  // ============================================
  // 🌐 SOCIAL MEDIA LINKS
  // ============================================

  /// Instagram profile URL
  static const String instagram = 'https://instagram.com/_ahsanzaman';

  /// Twitter/X profile URL
  static const String twitter = 'https://x.com/ahsxn_dev';

  /// LinkedIn profile URL
  static const String linkedin = 'https://www.linkedin.com/in/ahxanzaman/';

  /// GitHub profile URL
  static const String github = 'https://github.com/ahsxndev';

  /// Medium profile URL
  static const String medium = 'https://medium.com/@ahsxn';

  // ============================================
  // 📞 CONTACT INFORMATION
  // ============================================

  /// Email address for contact
  static const String email = 'ahsanzaman.dev@gmail.com';

  /// Phone number for WhatsApp contact (include country code)
  static const String phoneWhatsApp = '+923424083570';

  // ============================================
  // 📄 CV/RESUME CONFIGURATION
  // ============================================

  /// CV/Resume download URL
  ///
  /// For Google Drive:
  /// 1. Upload your CV to Google Drive
  /// 2. Right-click and select "Share"
  /// 3. Change access to "Anyone with the link"
  /// 4. Copy the link and replace YOUR_CV_FILE_ID below
  ///
  /// Example: https://drive.google.com/file/d/1ABC123def456GHI789jkl/view
  static const String cvDownloadUrl =
      'https://drive.google.com/drive/folders/1AaJt4-oVzAYCNm-3YRW8fD9aBVQOQFWE';

  /// 🔗 APK Download URL for your Portfolio App
  ///
  /// ➤ To host on GitHub Releases:
  ///   1. Run `flutter build apk` or `flutter build apk --release`
  ///   2. Go to your GitHub repo > Releases
  ///   3. Create a new release and upload the generated `.apk` file
  ///   4. Copy the direct download URL and paste it below
  ///
  /// ➤ To host on Google Drive:
  ///   1. Upload the APK to Google Drive
  ///   2. Right-click > Share > Change access to "Anyone with the link"
  ///   3. Copy the shareable link and paste it below
  ///
  /// 💡 Notes:
  /// - If you want to use the portfolio app:
  ///     • First, update all relevant configuration files inside the `/config` folder
  ///     • Then build the release using `flutter build apk --release`
  ///     • Upload and replace the URL below
  ///
  /// - If you don’t want the portfolio app:
  ///     • Simply remove or comment out the code referencing it (e.g., from the footer section)
  ///
  /// Example:
  /// https://github.com/username/myfolio/releases/download/v1.0.0/myfolio-v1.0.0.apk
  static const String apkDownloadUrl =
      'https://github.com/ahsxndev/Portfolio/releases/download/v1.0.0/app-release.apk';

  // ============================================
  // 📧 EMAIL TEMPLATE CONFIGURATION
  // ============================================

  /// Email subject for hire me button
  static const String emailSubject = 'Job Opportunity Inquiry';

  /// Email body template for hire me button
  /// You can customize this message as needed
  static const String emailBody = '''Hi Ahsan,

I would like to discuss a potential job opportunity with you.

Best regards,''';
}
