import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this for SystemUiOverlayStyle
import 'package:google_fonts/google_fonts.dart'; // Add this for GoogleFonts
import 'package:url_launcher/url_launcher.dart';
import '../models/faculty.dart';
import '../data/faculty_data.dart';
import '../common_widgets/faculty_card.dart';
import '../screens/faculty_profile_screen.dart';

class FacultyListScreen extends StatefulWidget {
  const FacultyListScreen({super.key});

  @override
  State<FacultyListScreen> createState() => _FacultyListScreenState();
}

class _FacultyListScreenState extends State<FacultyListScreen> {
  String _selectedDepartment = 'All';

  // Add this getter to filter faculty members
  List<Faculty> get _filteredFaculty {
    if (_selectedDepartment == 'All') {
      return facultyMembers;
    }
    return facultyMembers.where((faculty) {
      String department = faculty.department.toUpperCase();
      if (_selectedDepartment == 'CSE') {
        return department.contains('COMPUTER SCIENCE');
      } else if (_selectedDepartment == 'SWE') {
        return department.contains('SOFTWARE');
      } else if (_selectedDepartment == 'PHARMACY') {
        return department.contains('PHARMACY');
      } else if (_selectedDepartment == 'EEE') {
        return department.contains('ELECTRICAL');
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(child: _buildFacultyGrid()),
        ],
      ),
    );
  }

  // Update your AppBar title to show filtered count
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Research Faculty',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Text(
            '${_filteredFaculty.length} Members', // Show filtered count
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black87),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black87),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildChip('All'),
          _buildChip('CSE'),
          _buildChip('SWE'),
          _buildChip('PHARMACY'),
          _buildChip('EEE'),
        ],
      ),
    );
  }

  // Update your _buildChip method
  Widget _buildChip(String label) {
    final isSelected = _selectedDepartment == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontSize: 13,
        ),
        backgroundColor: Colors.white,
        selectedColor: Colors.indigo,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.transparent : Colors.grey[300]!,
          ),
        ),
        onSelected: (bool selected) {
          setState(() => _selectedDepartment = label);
        },
      ),
    );
  }

  // Update your _buildFacultyGrid method
  Widget _buildFacultyGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _filteredFaculty.length, // Use filtered list length
      itemBuilder: (context, index) {
        final faculty = _filteredFaculty[index]; // Use filtered list
        return _buildFacultyCard(faculty);
      },
    );
  }

  Widget _buildFacultyCard(Faculty faculty) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FacultyProfileScreen(faculty: faculty),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundImage: AssetImage(faculty.imageUrl),
              ),
              SizedBox(height: 12),
              Text(
                faculty.name,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                faculty.designation,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(color: Colors.grey[300]!),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                ),
                child: Text(
                  'View Profile',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
