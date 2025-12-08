# 🧑‍💻 MyFolio - Flutter Portfolio App

A modern, minimalist, and highly customizable Flutter portfolio website/application to showcase your skills, projects, and professional journey. Designed for fast setup and easy editing—even if you're not a Flutter developer!

<div align="center">
   
[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)
</div>


<img width="1440" height="951" alt="banner1" src="https://github.com/user-attachments/assets/6ff4fc5f-ba30-4cba-8a53-93331bdca8bf" />
<img width="1440" height="951" alt="banner1" src="https://github.com/user-attachments/assets/97fb5887-a0bf-476f-abc9-7b46961ceebe" />

<div align="center">
   
[![Open Source Love svg1](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](#)
[![GitHub Forks](https://img.shields.io/github/forks/ahsxndev/Portfolio.svg?style=social&label=Fork&maxAge=2592000)](https://github.com/ahsxndev/Portfolio/fork)
[![GitHub Issues](https://img.shields.io/github/issues/ahsxndev/Portfolio.svg?style=flat&label=Issues&maxAge=2592000)](https://github.com/ahsxndev/Portfolio/issues)
[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat&label=Contributions&colorA=red&colorB=black)](https://github.com/ahsxndev/Portfolio/pulls)
</div>

---

## 🧑‍💻 MyFolio

A portfolio website for developers built using Flutter. Includes:

- Home
- About
- Services
- Projects (Portfolio)
- Contact

## ✨ Features

- 🖥️ Modern, clean, and minimalist UI
- 📱 Responsive for mobile, tablet, desktop, and web
- 💨 Smooth animations & transitions
- 🛠️ Easy to customize: just edit config files!
- 📦 Cross-platform: Android, iOS, Web, Windows, macOS, Linux
- ⚡ SEO optimized for web
- 🔗 Social media & email/WhatsApp integration
- 🧑‍💼 Business ready: contact forms, service detail modals, project showcase

## 🔗 Useful links

🌐 Website: https://ahsanzaman.dev  
📱 Android APK: [Direct Download](https://github.com/ahsxndev/Portfolio/releases/tag/v1.0.0/app-release.apk)  
🐙 GitHub: [ahsxndev/myfolio](https://github.com/ahsxndev/Portfolio)

## 🏗️ Quick Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/ahsxndev/Portfolio.git
   cd Portfolio
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

4. **Customize config files**
   - `lib/core/config/user_info_config.dart` — your info
   - `lib/core/config/projects_config.dart` — your projects
   - `lib/core/config/social_links_config.dart` — your socials

## ⚙️ Customization

- **Personal Info**: Edit your name, job title, email, phone in `user_info_config.dart`
- **Projects**: Add/edit projects in `projects_config.dart`
- **Social Links**: Update your social profiles in `social_links_config.dart`
- **Images**: Replace profile and project images in `assets/images/`

## 📧 EmailJS Setup (Contact Form)

This portfolio includes a contact form that sends emails via **EmailJS**. Follow these steps to set up email functionality:

### 1️⃣ Create an EmailJS Account
- Go to [emailjs.com](https://www.emailjs.com/) and sign up for a **free account**
- Verify your email

### 2️⃣ Create an Email Service
- In the EmailJS Dashboard, go to **Email Services** (left sidebar)
- Click **Create New Service**
- Choose your provider (Gmail, Outlook, etc.)
- Follow the setup wizard and **Save**
- Copy your **Service ID** (looks like `service_xxxxx`)

### 3️⃣ Create an Email Template
- Go to **Email Templates** (left sidebar)
- Click **Create New Template**
- Use this template structure:

```html
<h2>New Portfolio Contact</h2>

<p><strong>From:</strong> {{name}} ({{email}})</p>
<p><strong>Service:</strong> {{service_type}}</p>

<h3>Message:</h3>
<p>{{message}}</p>

<hr>
<p><em>This message was sent from your portfolio website.</em></p>
```

- Set **To Email** to `{{to_email}}` or your actual email
- Set **Reply-To** to `{{email}}` (so you can reply directly to the sender)
- Click **Save**
- Copy your **Template ID** (looks like `template_xxxxx`)

### 4️⃣ Get Your API Keys
- Go to **Account** (left sidebar) → **API Keys**
- Copy:
  - **Public Key** (User ID)
  - **Private Key** (Access Token)

### 5️⃣ Update Configuration
Edit `lib/core/config/emailjs_config.dart`:

```dart
class EmailJSConfig {
  static const String serviceId = 'service_xxxxx';      // Your Service ID
  static const String templateId = 'template_xxxxx';    // Your Template ID
  static const String userId = 'YOUR_PUBLIC_KEY';       // Your Public Key
  static const String privateKey = 'YOUR_PRIVATE_KEY';  // Your Private Key
}
```

⚠️ **Security Note**: Keep your private key secure! Don't commit it to a public GitHub repository.

### 6️⃣ Test the Contact Form
- Run the app: `flutter run`
- Go to the **Contact** section
- Fill in the form and send
- Check your email!

### Troubleshooting

| Error | Solution |
|-------|----------|
| 403 - API calls disabled | Ensure you have the correct **Private Key** in `emailjs_config.dart` |
| 400 - Parameters invalid | Check that template variable names match (use `{{name}}`, `{{email}}`, `{{message}}`) |
| Email not received | Verify your **Service ID** and **Template ID** are correct |

## ⚡ Deployment

- **Web**: `flutter build web --release`
- **Android**: `flutter build apk --release`
- **iOS**: `flutter build ios --release`

Deploy web app to GitHub Pages or Firebase Hosting easily!


## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Pull requests, issues, and suggestions are welcome!  
Fork, star, and contribute your awesome ideas.

- [Contribute here!](https://github.com/ahsxndev/Portfolio/pulls)

---

## 🙏 Acknowledgments

- Flutter team
- Font Awesome
- Google Fonts
- All open-source contributors

## 👤 Author & Contact

<div align="center">

### **Ahsan Zaman**

[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/ahsxndev)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/ahxanzaman)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:ahsanzaman.dev@gmail.com)

---

### 🌟 **If you found this project helpful, please give it a star!** ⭐

Made with 💙 using Flutter
