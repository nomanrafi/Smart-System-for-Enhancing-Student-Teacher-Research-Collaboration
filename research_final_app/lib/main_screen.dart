import 'package:flutter/material.dart';
import 'view/faculty_list_screen.dart';
import 'common_widgets/faculty_card.dart';
import 'common_widgets/featured_paper_card.dart';
import 'common_widgets/category_tile.dart';
import 'data/faculty_data.dart';
import 'screens/faculty_profile_screen.dart';

class MainScreen extends StatefulWidget {
  final Function() onThemeToggle;
  final bool isDarkMode;

  const MainScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
          title: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.search, color: Colors.grey),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search to explore...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.tune, color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: Colors.black),
              onPressed: widget.onThemeToggle,
            ),
            IconButton(
              icon: Icon(Icons.notifications_outlined, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Featured Papers Section
          Text(
            'Featured Papers',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FeaturedPaperCard(
                  color: Color(0xFF2196F3),
                  title:
                      'A cloud based four-tier architecture for early detection of heart disease with machine...',
                  author: 'Professor Dr. Sheak Rashed Haider Noori',
                  views: '1,378',
                  downloads: '120',
                ),
                SizedBox(width: 16),
                FeaturedPaperCard(
                  color: Color(0xFF9C27B0),
                  title:
                      'A cloud based architecture for early detection of heart...',
                  author: 'Professor Dr. Sheak Rashed Haider Noori',
                  views: '1,378',
                  downloads: '120',
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Category Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Category',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'See More',
                style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              CategoryTile(
                icon: Icons.memory,
                title: 'Artificial\nIntelligent',
                isSelected: _selectedCategoryIndex == 0,
                onTap: () => setState(() => _selectedCategoryIndex = 0),
              ),
              CategoryTile(
                icon: Icons.park,
                title: 'Environmental\nScience',
                isSelected: _selectedCategoryIndex == 1,
                onTap: () => setState(() => _selectedCategoryIndex == 1),
              ),
              CategoryTile(
                icon: Icons.local_hospital,
                title: 'Biomedical\nResearch',
                isSelected: _selectedCategoryIndex == 2,
                onTap: () => setState(() => _selectedCategoryIndex == 2),
              ),
              CategoryTile(
                icon: Icons.attach_money,
                title: 'Economics &\nFinance',
                isSelected: _selectedCategoryIndex == 3,
                onTap: () => setState(() => _selectedCategoryIndex == 3),
              ),
              CategoryTile(
                icon: Icons.eco,
                title: 'Agriculture &\nSustainability',
                isSelected: _selectedCategoryIndex == 4,
                onTap: () => setState(() => _selectedCategoryIndex == 4),
              ),
              CategoryTile(
                icon: Icons.favorite,
                title: 'Nutrition &\nPublic Health',
                isSelected: _selectedCategoryIndex == 5,
                onTap: () => setState(() => _selectedCategoryIndex == 5),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Research Faculty Section
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Research Faculty',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FacultyListScreen()),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.indigo.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'See More',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.indigo,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 210, // Increased height to accommodate content
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: facultyMembers.take(4).length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: FacultyCard(
                        faculty: facultyMembers[index],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FacultyProfileScreen(
                              faculty: facultyMembers[index],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }
}
