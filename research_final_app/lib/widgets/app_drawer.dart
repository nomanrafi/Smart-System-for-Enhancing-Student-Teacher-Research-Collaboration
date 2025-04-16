import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view/faculty_list_screen.dart';
import '../screens/settings_page.dart';
import '../screens/help_support.dart';
import '../widgets/category_section.dart';
import '../screens/category_screen.dart'; // Add this import
import '../screens/research_projects_screen.dart'; // Add this import

class AppDrawer extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeToggle; // Update type to match main.dart

  const AppDrawer({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 16),
          _buildProfileHeader(context),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _drawerTile(
                  Icons.home_rounded,
                  "Home",
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                    setState(() => _selectedIndex = 0);
                  },
                  isSelected: _selectedIndex == 0,
                ),
                _drawerTile(
                  Icons.category_rounded,
                  "Categories",
                  onTap: () {
                    Navigator.pop(context); // Close drawer first
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const CategoryScreen(), // Now uses the proper class
                      ),
                    );
                    setState(() => _selectedIndex = 1);
                  },
                  isSelected: _selectedIndex == 1,
                ),
                _drawerTile(
                  Icons.people_rounded,
                  "Faculty Members",
                  onTap: () {
                    Navigator.pop(context); // Close drawer first
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FacultyListScreen(),
                      ),
                    );
                    setState(() => _selectedIndex = 2);
                  },
                  isSelected: _selectedIndex == 2,
                ),
                _drawerTile(
                  Icons.school_rounded,
                  "Research Projects",
                  onTap: () {
                    Navigator.pop(context); // Close drawer first
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ResearchProjectsScreen(), // Navigate to ResearchProjectsScreen
                      ),
                    );
                    setState(() => _selectedIndex = 3);
                  },
                  isSelected: _selectedIndex == 3,
                ),
                _drawerTile(
                  Icons.support_agent_outlined,
                  "Support",
                  onTap: () {
                    Navigator.pop(context); // Close drawer first
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SupportScreen(), // Navigate to SupportScreen
                      ),
                    );
                    setState(() => _selectedIndex = 4); // Update selected index
                  },
                  isSelected: _selectedIndex == 4,
                ),
                _drawerTile(
                  Icons.settings_outlined,
                  "Settings",
                  onTap: () {
                    Navigator.pop(context); // Close drawer first
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsScreen(
                          isDarkMode: widget.isDarkMode,
                          onThemeToggle:
                              widget.onThemeToggle, // Now matches the type
                        ),
                      ),
                    );
                    setState(() => _selectedIndex = 5);
                  },
                  isSelected: _selectedIndex == 5,
                ),
                const SizedBox(height: 24),
                const Divider(),
                _buildThemeToggle(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundImage: AssetImage('assets/images/defaults/profile.png'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Shahin",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                Text("shahin5646@gmail.com",
                    style:
                        GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _drawerTile(
    IconData icon,
    String title, {
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.indigo.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.indigo : Colors.grey[700],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isSelected ? Colors.indigo : Colors.grey[800],
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle() {
    return ListTile(
      leading: Icon(
        widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
        color: widget.isDarkMode ? Colors.white : Colors.grey[800],
      ),
      title: Text(
        'Dark Mode',
        style: GoogleFonts.poppins(),
      ),
      trailing: Switch(
        value: widget.isDarkMode,
        onChanged: widget.onThemeToggle, // Now matches the type
      ),
    );
  }
}
