/// ============================================
/// ✉️ EMAILJS CONFIGURATION
/// ============================================
///
/// ⚠️ IMPORTANT: Update this file with your own EmailJS credentials!
///
/// 📝 Instructions:
/// 1. Sign up for a free account at https://www.emailjs.com/
/// 2. Create a new email service (e.g., Gmail)
/// 3. Create a new email template
/// 4. Find your Service ID, Template ID, and User ID (Public Key)
/// 5. Replace the placeholder values below with your actual credentials
///
/// ============================================
library;

class EmailJSConfig {
  /// 🔑 EmailJS Service ID
  /// Found in your EmailJS account under Email Services > [Your Service] > Service ID
  static const String serviceId = 'YOUR-SERVICE-ID';

  /// 模板 🔑 EmailJS Template ID
  /// Found in your EmailJS account under Email Templates > [Your Template] > Template ID
  static const String templateId = 'YOUR-TEMPLATE-ID';

  /// 🔑 EmailJS User ID (Public Key)
  /// Found in your EmailJS account under Account > API Keys > Public Key
  static const String userId = 'YOUR-USER-ID';

  /// 🔑 EmailJS Private Key (Access Token) - REQUIRED for non-browser apps
  /// Found in your EmailJS account under Account > API Keys > Private Key
  /// ⚠️ Keep this secure! Do not commit to public repositories
  static const String privateKey = 'YOUR-PRIVATE-KEY';
}
