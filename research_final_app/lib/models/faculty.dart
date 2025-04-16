class Faculty {
  final String name;
  final String designation;
  final String department;
  final String faculty;
  final String employeeId;
  final String email;
  final String officePhone;
  final String cellPhone;
  final String personalWebpage;
  final String imageUrl;
  final bool isOnline;
  final List<String>? researchPapers; // Added for research papers

  Faculty({
    required this.name,
    required this.designation,
    required this.department,
    required this.faculty,
    required this.employeeId,
    required this.email,
    required this.officePhone,
    required this.cellPhone,
    required this.personalWebpage,
    required this.imageUrl,
    this.isOnline = false,
    this.researchPapers,
  });

  // Add factory method to create from JSON
  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      name: json['name'] as String,
      designation: json['designation'] as String,
      department: json['department'] as String,
      faculty: json['faculty'] as String,
      employeeId: json['employeeId'] as String,
      email: json['email'] as String,
      officePhone: json['officePhone'] as String,
      cellPhone: json['cellPhone'] as String,
      personalWebpage: json['personalWebpage'] as String,
      imageUrl: json['imageUrl'] as String,
      isOnline: json['isOnline'] as bool? ?? false,
      researchPapers: (json['researchPapers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  // Add method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'designation': designation,
      'department': department,
      'faculty': faculty,
      'employeeId': employeeId,
      'email': email,
      'officePhone': officePhone,
      'cellPhone': cellPhone,
      'personalWebpage': personalWebpage,
      'imageUrl': imageUrl,
      'isOnline': isOnline,
      'researchPapers': researchPapers,
    };
  }
}
