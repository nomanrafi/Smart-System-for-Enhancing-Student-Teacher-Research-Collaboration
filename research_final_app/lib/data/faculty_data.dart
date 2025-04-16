import '../models/faculty.dart';
import '../constants/image_paths.dart';
import '../models/research_paper.dart'; // Add this import

final List<Faculty> facultyMembers = [
  // CSE Department Faculty
  Faculty(
    name: 'Professor Dr. Sheak Rashed Haider Noori',
    designation: 'Professor & Head',
    department: 'Department of Computer Science and Engineering',
    faculty: 'Faculty of Science and Information Technology',
    employeeId: '710001060',
    email: 'headcse@daffodilvarsity.edu.bd, drnoori@daffodilvarsity.edu.bd',
    officePhone: '15100',
    cellPhone: '01847140016',
    personalWebpage:
        'https://faculty.daffodilvarsity.edu.bd/profile/cse/rashed-haider-noori.html',
    imageUrl: FacultyImages.noori,
    isOnline: true,
  ),

  Faculty(
    name: 'Professor Dr. Md. Fokhray Hossain',
    designation: 'Professor',
    department: 'Department of Computer Science and Engineering',
    faculty: 'Faculty of Science and Information Technology',
    employeeId: '710000367',
    email:
        'drfokhray@daffodilvarsity.edu.bd, international@daffodilvarsity.edu.bd',
    officePhone: '9138234-5',
    cellPhone: '01713-493250',
    personalWebpage:
        'https://faculty.daffodilvarsity.edu.bd/profile/cse/fokhray.html',
    imageUrl: FacultyImages.fokhray,
    isOnline: true,
  ),

  Faculty(
    name: 'Dr. S. M. Aminul Haque',
    designation: 'Professor & Associate Head',
    department: 'Department of Computer Science and Engineering',
    faculty: 'Faculty of Science and Information Technology',
    employeeId: '710001054',
    email:
        'aheadcse2@daffodilvarsity.edu.bd, aminul.cse@daffodilvarsity.edu.bd',
    officePhone: '15101',
    cellPhone: '01847140129',
    personalWebpage:
        'https://faculty.daffodilvarsity.edu.bd/profile/cse/aminul.html',
    imageUrl: FacultyImages.aminul,
    isOnline: true,
  ),

  // SWE Department Faculty
  Faculty(
    name: 'Dr. Shaikh Muhammad Allayear',
    designation: 'Professor',
    department: 'Department of Software Engineering',
    faculty: 'Faculty of Science and Information Technology',
    employeeId: '710001664',
    email: 'drallayear.mct@diu.edu.bd, proctor@daffodilvarsity.edu.bd',
    officePhone: '40100',
    cellPhone: '01847334900, 01974013732, 01624013732',
    personalWebpage:
        'https://faculty.daffodilvarsity.edu.bd/profile/swe/Allayear.html',
    imageUrl: FacultyImages.allayear,
    isOnline: true,
  ),

  Faculty(
    name: 'Dr. A. H. M. Saifullah Sadi',
    designation: 'Professor',
    department: 'Department of Software Engineering',
    faculty: 'Faculty of Science and Information Technology',
    employeeId: '710003717',
    email: 'sadi.swe@diu.edu.bd',
    officePhone: '',
    cellPhone: '01795379956',
    personalWebpage:
        'https://faculty.daffodilvarsity.edu.bd/profile/swe/saifullahsadi.html',
    imageUrl: FacultyImages.sadi,
    isOnline: true,
  ),

  Faculty(
    name: 'Dr. Imran Mahmud',
    designation: 'Professor & Head',
    department: 'Department of Software Engineering',
    faculty: 'Faculty of Science and Information Technology',
    employeeId: '710000934',
    email: 'imranmahmud@daffodilvarsity.edu.bd',
    officePhone: '35100',
    cellPhone: '01847140117, 01711370502',
    personalWebpage:
        'https://faculty.daffodilvarsity.edu.bd/profile/swe/imahmud.html',
    imageUrl: FacultyImages.imran,
    isOnline: true,
  ),

  // Pharmacy Department Faculty
  Faculty(
    name: 'Dr. Md. Sarowar Hossain',
    designation: 'Associate Dean & Associate Professor',
    department: 'Department of Pharmacy',
    faculty: 'Faculty of Health and Life Sciences',
    employeeId: '710002373',
    email: 'adeanfhls@daffodilvarsity.edu.bd, sarowar.ph@diu.edu.bd',
    officePhone: '',
    cellPhone: '01777845198',
    personalWebpage:
        'https://faculty.daffodilvarsity.edu.bd/profile/pharmacy/drsarowar.html',
    imageUrl: FacultyImages.sarowar,
    isOnline: true,
  ),

  Faculty(
    name: 'Professor Dr. Muniruddin Ahmed',
    designation: 'Professor',
    department: 'Department of Pharmacy',
    faculty: 'Faculty of Health and Life Sciences',
    employeeId: '722900068',
    email: 'drmuniruddin.ph@diu.edu.bd',
    officePhone: '46100',
    cellPhone: '01847334841, 01755587204',
    personalWebpage:
        'https://faculty.daffodilvarsity.edu.bd/profile/pharmacy/muniruddin.html',
    imageUrl: FacultyImages.muniruddin,
    isOnline: true,
  ),

  Faculty(
    name: 'Prof. Dr. Md. Ekramul Haque',
    designation: 'Professor',
    department: 'Department of Pharmacy',
    faculty: 'Faculty of Health and Life Sciences',
    employeeId: '722900054',
    email: 'drekram.pharmacy@diu.edu.bd',
    officePhone: '',
    cellPhone: '01711952286',
    personalWebpage:
        'https://faculty.daffodilvarsity.edu.bd/profile/pharmacy/ekramul.html',
    imageUrl: FacultyImages.ekramul,
    isOnline: true,
  ),

  // EEE Department Faculty
  Faculty(
    name: 'Professor Dr. M. Shamsul Alam',
    designation: 'Dean & Professor',
    department: 'Department of Electrical and Electronic Engineering',
    faculty: 'Faculty of Engineering',
    employeeId: '710000800',
    email: 'deanfe@daffodilvarsity.edu.bd',
    officePhone: '02-9138234-5 Ex-65109',
    cellPhone: '01833102814',
    personalWebpage:
        'https://faculty.daffodilvarsity.edu.bd/profile/eee/msalam.html',
    imageUrl: FacultyImages.shamsul,
    isOnline: true,
  ),
];

final Map<String, List<ResearchPaper>> facultyResearchPapers = {
  'Professor Dr. Sheak Rashed Haider Noori': [
    ResearchPaper(
      id: '1',
      title:
          'A cloud based four-tier architecture for early detection of heart disease with machine learning',
      author: 'Professor Dr. Sheak Rashed Haider Noori',
      journalName: 'Journal of Cloud Computing',
      year: '2023',
      pdfUrl: 'https://example.com/paper1.pdf',
      doi: '10.1234/jcc.2023.001',
      keywords: ['Cloud Computing', 'Machine Learning', 'Healthcare'],
      abstract:
          'This paper presents a novel approach to early detection of heart disease using cloud computing and machine learning techniques. The proposed architecture consists of four tiers that enable efficient data processing and analysis.', // Required abstract
      citations: 12,
    ),
  ],
  'Professor Dr. Md. Fokhray Hossain': [
    ResearchPaper(
      id: '2',
      title: 'Machine Learning Approaches in Smart Healthcare',
      author: 'Professor Dr. Md. Fokhray Hossain',
      journalName: 'IEEE Access',
      year: '2023',
      pdfUrl: 'https://example.com/paper2.pdf',
      doi: '10.1234/ieee.2023.002',
      keywords: ['Machine Learning', 'Healthcare', 'IoT'],
      abstract: 'In this research...',
      citations: 8,
    ),
  ],
  'Dr. S. M. Aminul Haque': [
    ResearchPaper(
      id: '3',
      title: 'Deep Learning in Healthcare Applications',
      author: 'Dr. S. M. Aminul Haque',
      journalName: 'IEEE Healthcare',
      year: '2023',
      pdfUrl: 'https://example.com/paper3.pdf',
      doi: '10.1234/ieee.2023.003',
      keywords: ['Deep Learning', 'Healthcare', 'AI'],
      abstract: 'This research explores...',
      citations: 5,
    ),
  ],
};
