import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final feedbackController = TextEditingController();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Support",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Support Options Section
          _buildSection(
            "Get in Touch",
            [
              _buildContactTile(
                context,
                icon: Icons.email_outlined,
                title: "Email Support",
                subtitle: "support@researchhub.edu",
                onTap: () => _launchEmail("support@researchhub.edu"),
              ),
              _buildContactTile(
                context,
                icon: Icons.support_agent,
                title: "Live Chat",
                subtitle: "Available 24/7",
                onTap: () => _launchChat(),
              ),
              _buildContactTile(
                context,
                icon: Icons.phone_outlined,
                title: "Call Center",
                subtitle: "+880 1847-140129",
                onTap: () => _launchCall("+8801847140129"),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // FAQ Section
          _buildSection(
            "Frequently Asked Questions",
            [
              _buildFaqTile(
                "How to access research papers?",
                "Navigate to the Faculty profile and click on 'View Research Papers' to access their publications.",
              ),
              _buildFaqTile(
                "Can I download papers for offline reading?",
                "Yes, when viewing a paper, tap the download icon in the top right to save it for offline access.",
              ),
              _buildFaqTile(
                "How to contact faculty members?",
                "Visit the Faculty Members section, select a professor, and you'll find their contact information including email and office phone.",
              ),
              _buildFaqTile(
                "How to change app theme?",
                "Go to Settings > Display & Accessibility > Dark Mode to toggle between light and dark themes.",
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Feedback Section
          _buildSection(
            "Send Feedback",
            [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode 
                      ? Colors.grey[800] 
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: feedbackController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Share your thoughts or report issues...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: isDarkMode 
                            ? Colors.grey[850] 
                            : Colors.white,
                      ),
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _submitFeedback(context, feedbackController),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.send_rounded),
                      label: Text(
                        "Submit Feedback",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildContactTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      elevation: 0,
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.indigo.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.indigo),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  Widget _buildFaqTile(String question, String answer) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(
          question,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Text(
            answer,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _submitFeedback(BuildContext context, TextEditingController controller) {
    if (controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your feedback")),
      );
      return;
    }

    // TODO: Implement feedback submission logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Thank you for your feedback!",
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.green,
      ),
    );
    controller.clear();
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(emailLaunchUri);
  }

  Future<void> _launchCall(String phone) async {
    final Uri callLaunchUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    await launchUrl(callLaunchUri);
  }

  void _launchChat() {
    // TODO: Implement chat functionality
  }
}