import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onThemeToggle;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Settings",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildUserSection(context),
          const SizedBox(height: 24),

          // Display & Accessibility
          _buildSection(
            "Display & Accessibility",
            [
              _buildSwitchTile(
                context,
                title: "Dark Mode",
                subtitle: "Enable dark theme for the app",
                icon: Icons.dark_mode_outlined,
                value: isDarkMode,
                onChanged: onThemeToggle,
              ),
              _buildNavigationTile(
                context,
                title: "Text Size",
                subtitle: "Adjust text size for better readability",
                icon: Icons.text_fields,
                onTap: () => _showTextSizeDialog(context),
              ),
              _buildNavigationTile(
                context,
                title: "Language",
                subtitle: "Change app language",
                icon: Icons.language,
                onTap: () => _showLanguageDialog(context),
              ),
            ],
          ),

          // Research Preferences
          _buildSection(
            "Research Preferences",
            [
              _buildSwitchTile(
                context,
                title: "Paper Notifications",
                subtitle: "Get notified about new research papers",
                icon: Icons.notifications_outlined,
                value: true,
                onChanged: (value) {},
              ),
              _buildNavigationTile(
                context,
                title: "Citation Format",
                subtitle: "Choose default citation format",
                icon: Icons.format_quote,
                onTap: () => _showCitationFormatDialog(context),
              ),
              _buildNavigationTile(
                context,
                title: "Download Location",
                subtitle: "Change default download folder",
                icon: Icons.folder_outlined,
                onTap: () {},
              ),
            ],
          ),

          // Account & Security
          _buildSection(
            "Account & Security",
            [
              _buildNavigationTile(
                context,
                title: "Profile Settings",
                subtitle: "Manage your profile information",
                icon: Icons.person_outline,
                onTap: () {},
              ),
              _buildNavigationTile(
                context,
                title: "Privacy",
                subtitle: "Control your data and privacy settings",
                icon: Icons.security,
                onTap: () {},
              ),
            ],
          ),

          // Support & About
          _buildSection(
            "Support & About",
            [
              _buildNavigationTile(
                context,
                title: "Help Center",
                subtitle: "Get help and support",
                icon: Icons.help_outline,
                onTap: () => _launchHelp(),
              ),
              _buildNavigationTile(
                context,
                title: "About ResearchHub",
                subtitle: "Version 1.0.0",
                icon: Icons.info_outline,
                onTap: () => _showAboutDialog(context),
              ),
              _buildNavigationTile(
                context,
                title: "Share App",
                subtitle: "Share with colleagues",
                icon: Icons.share_outlined,
                onTap: () => _shareApp(),
              ),
            ],
          ),

          // Logout Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.logout),
              label: Text(
                "Sign Out",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
            child: const Icon(Icons.person, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Shahin",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Student",
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ),
        ...children,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      value: value,
      onChanged: onChanged,
      title: Text(title, style: GoogleFonts.poppins(fontSize: 16)),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: Colors.grey[600],
        ),
      ),
      secondary: Icon(icon),
    );
  }

  Widget _buildNavigationTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(icon),
      title: Text(title, style: GoogleFonts.poppins(fontSize: 16)),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // Dialog Methods
  void _showTextSizeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Text Size", style: GoogleFonts.poppins()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextSizeOption(context, "Small", 0.8),
            _buildTextSizeOption(context, "Normal", 1.0),
            _buildTextSizeOption(context, "Large", 1.2),
          ],
        ),
      ),
    );
  }

  Widget _buildTextSizeOption(BuildContext context, String label, double scale) {
    return ListTile(
      title: Text(label, style: GoogleFonts.poppins(fontSize: 16 * scale)),
      onTap: () => Navigator.pop(context),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text("Select Language", style: GoogleFonts.poppins()),
        children: [
          _buildLanguageOption(context, "English", "🇺🇸"),
          _buildLanguageOption(context, "বাংলা", "🇧🇩"),
          _buildLanguageOption(context, "हिंदी", "🇮🇳"),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, String language, String flag) {
    return SimpleDialogOption(
      onPressed: () => Navigator.pop(context),
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 16),
          Text(language, style: GoogleFonts.poppins(fontSize: 16)),
        ],
      ),
    );
  }

  void _showCitationFormatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text("Citation Format", style: GoogleFonts.poppins()),
        children: [
          _buildCitationOption(context, "APA"),
          _buildCitationOption(context, "MLA"),
          _buildCitationOption(context, "Chicago"),
          _buildCitationOption(context, "Harvard"),
        ],
      ),
    );
  }

  Widget _buildCitationOption(BuildContext context, String format) {
    return SimpleDialogOption(
      onPressed: () => Navigator.pop(context),
      child: Text(format, style: GoogleFonts.poppins(fontSize: 16)),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: "ResearchHub",
      applicationVersion: "1.0.0",
      applicationIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.school,
          size: 40,
          color: Theme.of(context).primaryColor,
        ),
      ),
      children: [
        Text(
          "ResearchHub is a smart platform for managing faculty research papers and achievements. It provides an intuitive interface for exploring academic work and connecting with researchers.",
          style: GoogleFonts.poppins(),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sign Out", style: GoogleFonts.poppins()),
        content: Text(
          "Are you sure you want to sign out?",
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement sign out logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Signed out successfully")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text("Sign Out", style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  Future<void> _launchHelp() async {
    const url = 'https://example.com/help';
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _shareApp() async {
    await Share.share(
      'Check out ResearchHub - A smart platform for managing research papers!\nhttps://research-hub.com/app',
      subject: 'ResearchHub App',
    );
  }
}