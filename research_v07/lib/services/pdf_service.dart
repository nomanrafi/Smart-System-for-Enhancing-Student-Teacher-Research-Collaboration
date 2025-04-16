import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import '../screens/pdf_viewer_screen.dart';
import '../common_widgets/featured_paper_card.dart';
import '../models/trending_paper.dart';

class PdfService {
  static final PdfService _instance = PdfService._internal();

  factory PdfService() {
    return _instance;
  }

  PdfService._internal() {
    // Initialize trending papers when service is created
    loadTrendingPapers();
  }

  final _logger = Logger('PdfService');
  String? basePath; // Make nullable
  final Map<String, TrendingPaper> _trendingPapers = {};

  Future<void> initializePapers() async {
    if (kIsWeb) {
      _logger
          .info('Running on web platform - using web-specific paper handling');
      basePath = path.join('assets', 'papers'); // Set a web-specific base path
      return;
    }

    try {
      final appDir = await getApplicationDocumentsDirectory();
      // Set the base path to the papers folder in the asset directory
      basePath = path.join(appDir.path, 'assets', 'papers');
      _logger.info('Base path: $basePath');

      final baseDir = Directory(basePath!);
      if (!await baseDir.exists()) {
        await baseDir.create(recursive: true);
        _logger.info('Created base directory: $basePath');
      }

      final professorFolders = [
        'Dr_Imran_Mahmud',
        'Dr_A_H_M_SaifullahSadi',
        'Dr_Md_Sarowar_Hossain',
        'Dr_S_M_Aminul_Haque',
        'Dr_Shaikh_Muhammad_Allayear',
        'Professor_Dr_Md_FokhrayHossain',
        'ProfessorDrSheakRashedHaiderNoori'
      ];

      for (final folderName in professorFolders) {
        final professorDir = Directory(path.join(basePath!, folderName));
        if (!await professorDir.exists()) {
          await professorDir.create();
          _logger.info('Created directory: ${professorDir.path}');
        }
      }
    } catch (e) {
      _logger.severe('Error initializing PDF service: $e');
    }
  }

  Future<List<File>> getProfessorPapers(String professorName) async {
    if (kIsWeb) {
      // Return web-specific papers
      final webPapers = getWebPapers(professorName);
      _logger.info('Web papers found: ${webPapers.length}');
      return []; // For web, return empty list since we can't use File class
    }

    if (basePath == null) {
      _logger.warning('Base path not initialized');
      return [];
    }

    try {
      final folderName = _getFolderName(professorName);
      final directory = Directory(path.join(basePath!, folderName));
      _logger.info('Looking for papers in: ${directory.path}');

      if (!await directory.exists()) {
        _logger.warning('Directory not found: ${directory.path}');
        return [];
      }

      final List<File> pdfFiles = [];
      await for (var entity in directory.list()) {
        if (entity is File &&
            path.extension(entity.path).toLowerCase() == '.pdf') {
          _logger.info('Found PDF: ${entity.path}');
          pdfFiles.add(entity);
        }
      }

      _logger.info('Total PDFs found: ${pdfFiles.length}');
      return pdfFiles;
    } catch (e) {
      _logger.severe('Error loading PDFs: $e');
      return [];
    }
  }

  List<Map<String, String>> getWebPapers(String professorName) {
    final webPapers = {
      'Dr. Imran Mahmud': [
        {
          'title':
              'A Novel Front Door Security FDS Algorithm Using GoogleNet BiLSTM Hybridization',
          'path':
              'papers/DrImran_Mahmud/A_Novel_Front_Door_Security_FDS_Algorithm_Using_GoogleNet-BiLSTM_Hybridization.pdf'
        },
        {
          'title':
              'DOORMOR A Functional Prototype of a Manual Search and Rescue Robot',
          'path':
              'papers/DrImran_Mahmud/DOORMOR_A_Functional_Prototype_of_a_Manual_Search_and_Rescue_Robot.pdf'
        },
        {
          'title':
              'DPMS Data Driven Promotional Management System of Universities Using Deep Learning on Social Media',
          'path':
              'papers/DrImran_Mahmud/DPMS_Data_Driven_Promotional_Management_System_of_Universities_Using_Deep_Learning_on_Social_Media.pdf'
        },
        {
          'title':
              'Innovation and the Sustainable Competitive Advantage of Young Firms A Strategy Implementation Approach',
          'path':
              'papers/DrImran_Mahmud/Innovation_and_the_Sustainable_Competitive_Advantage_of_Young_Firms_A_Strategy_Implementation_Approach.pdf'
        },
        {
          'title': 'IoT Based Remote Medical Diagnosis System Using NodeMCU',
          'path':
              'papers/DrImran_Mahmud/IoT_Based_Remote_Medical_Diagnosis_System_Using_NodeMCU.pdf'
        },
        {
          'title':
              'Machine Learning Based Approach for Predicting Diabetes Employing Socio Demographic Characteristics',
          'path':
              'papers/DrImran_Mahmud/Machine_Learning_Based_Approach_for_Predicting_Diabetes_Employing_Socio_Demographic_Characteristics.pdf'
        },
        {
          'title': 'ONGULANKO An IoT Based Biometric Attendance Logger',
          'path':
              'papers/DrImran_Mahmud/ONGULANKO_An_IoT_Based_Biometric_Attendance_Logger.pdf'
        },
        {
          'title':
              'Smart Security System Using Face Recognition on Raspberry Pi',
          'path':
              'papers/DrImran_Mahmud/Smart_Security_System_Using_Face_Recognition_on_Raspberry_Pi.pdf'
        },
        {
          'title':
              'Trackez An IoT Based 3D Object Tracking From 2D Pixel Matrix Using Mez and FSL Algorithm',
          'path':
              'papers/DrImran_Mahmud/Trackez_An_IoT_Based_3D_Object_Tracking_From_2D_Pixel_Matrix_Using_Mez_and_FSL_Algorithm.pdf'
        }
      ],
      'Professor Dr. Sheak Rashed Haider Noori': [
        {
          'title':
              'A_Collaborative_Platform_to_Collect_Data_for_Developing_Machine_Translation_Systems',
          'path':
              'papers/ProfessorDrSheakRashedHaiderNoori/A_Collaborative_Platform_to_Collect_Data_for_Developing_Machine_Translation_Systems.pdf'
        },
        {
          'title':
              'Appliance_of_Agile_Methodology_at_Software_Industry_in_Developing_Countries_Perspective_in_Bangladesh',
          'path':
              'papers/ProfessorDrSheakRashedHaiderNoori/Appliance_of_Agile_Methodology_at_Software_Industry_in_Developing_Countries_Perspective_in_Bangladesh.pdf'
        },
        {
          'title':
              'Bengali_Named_Entity_Recognition_A_survey_with_deep_learning_benchmark',
          'path':
              'papers/ProfessorDrSheakRashedHaiderNoori/Bengali_Named_Entity_Recognition_A_survey_with_deep_learning_benchmark.pdf'
        },
        {
          'title':
              'Machine_Learning_Based_Unified_Framework_for_Diabetes_Prediction',
          'path':
              'papers/ProfessorDrSheakRashedHaiderNoori/Machine_Learning_Based_Unified_Framework_for_Diabetes_Prediction.pdf'
        },
        {
          'title':
              'Regularized_Weighted_Circular_Complex_Valued_Extreme_Learning_Machine_for_Imbalanced_Learning',
          'path':
              'papers/ProfessorDrSheakRashedHaiderNoori/Regularized_Weighted_Circular_Complex_Valued_Extreme_Learning_Machine_for_Imbalanced_Learning.pdf'
        },
        {
          'title':
              'Suffix_Based_Automated_Parts_of_Speech_Tagging_for_Bangla_Language',
          'path':
              'papers/ProfessorDrSheakRashedHaiderNoori/Suffix_Based_Automated_Parts_of_Speech_Tagging_for_Bangla_Language.pdf'
        }
      ],
      'Professor Dr. Md. Fokhray Hossain': [
        {
          'title':
              'A_Case_Study_on_Customer_Satisfaction_Towards_Online_Banking_inBangladesh',
          'path':
              'papers/Professor_Dr_Md_FokhrayHossain/A_Case_Study_on_Customer_Satisfaction_Towards_Online_Banking_inBangladesh.pdf'
        },
        {
          'title':
              'A_Collaborative_Platform_to_Collect_Data_for_Developing_Machine_Translation_Systems',
          'path':
              'papers/Professor_Dr_Md_FokhrayHossain/A_Collaborative_Platform_to_Collect_Data_for_Developing_Machine_Translation_Systems.pdf'
        },
        {
          'title':
              'Automation_System_to_Find_Out_Plasma_Donors_for_Corona_Patients',
          'path':
              'papers/Professor_Dr_Md_FokhrayHossain/Automation_System_to_Find_Out_Plasma_Donors_for_Corona_Patients.pdf'
        },
        {
          'title': 'Early_Detection_of_Brain_Tumor_Using_Capsule_Network',
          'path':
              'papers/Professor_Dr_Md_FokhrayHossain/Early_Detection_of_Brain_Tumor_Using_Capsule_Network.pdf'
        },
        {
          'title':
              'THE_IMPACT_OF_INTERNATIONALIZATION_TO_IMPROVE_AND_ENSURE_QUALITY_DUCATION_A_CASE_STUDY_OF_DAFFODIL_INTERNATIONAL_UNIVERSITY_(BANGLADESH)',
          'path':
              'papers/Professor_Dr_Md_FokhrayHossain/THE_IMPACT_OF_INTERNATIONALIZATION_TO_IMPROVE_AND_ENSURE_QUALITY_DUCATION_A_CASE_STUDY_OF_DAFFODIL_INTERNATIONAL_UNIVERSITY_(BANGLADESH).pdf'
        },
        {
          'title':
              'The_Impact_of_Online_Education_in_BangladeshA_Case_Study_during_Covid19',
          'path':
              'papers/Professor_Dr_Md_FokhrayHossain/The_Impact_of_Online_Education_in_BangladeshA_Case_Study_during_Covid19.pdf'
        },
        {
          'title':
              'To_Design_&_Develop_Mobile_Based_Birth_Registration_System_for_New_Born_Baby_in_Bangladesh',
          'path':
              'papers/Professor_Dr_Md_FokhrayHossain/To_Design_&_Develop_Mobile_Based_Birth_Registration_System_for_New_Born_Baby_in_Bangladesh.pdf'
        }
      ],
      'Dr. Shaikh Muhammad Allayear': [
        {
          'title': 'A Location Based Time and Attendance System',
          'path':
              'papers/Dr_Shaikh_Muhammad_Allayear/A_Location_Based_Time_and_Attendance_Sys.pdf'
        },
        {
          'title':
              'Adaptation Mechanism of iSCSI Protocol for NAS Storage Solution in Wireless Environment',
          'path':
              'papers/Dr_Shaikh_Muhammad_Allayear/Adaptation_Mechanism_of_iSCSI_Protocol_for_NAS_Storage_Solution_in_Wireless_Environment.pdf'
        },
        {
          'title': 'AR & VR Based Child Education in Context of Bangladesh',
          'path':
              'papers/Dr_Shaikh_Muhammad_Allayear/AR_&_VR_Based_Child_Education_in_Context_of_Bangladesh.pdf'
        },
        {
          'title':
              'Creating awareness about traffic jam through engaged use of stop motion animation boomerang',
          'path':
              'papers/Dr_Shaikh_Muhammad_Allayear/Creating_awareness_about_traffic_jam_through_engaged_use_of_stop_motion_animation_boomerang.pdf'
        },
        {
          'title':
              'Human Face Detection in Excessive Dark Image by Using Contrast Stretching Histogram Equalization and Adaptive Equalization',
          'path':
              'papers/Dr_Shaikh_Muhammad_Allayear/Human_Face_Detection_in_Excessive_Dark_Image_by_Using_Contrast_Stretching_Histogram_Equalization_and_Adaptive_Equalization.pdf'
        },
        {
          'title': 'Implementation of a Smart AC Automation',
          'path':
              'papers/Dr_Shaikh_Muhammad_Allayear/Implementation_of_a_Smart_AC_Automation.pdf'
        },
        {
          'title':
              'iSCSI Multi Connection and Error Recovery Method for Remote Storage System in Mobile Appliance',
          'path':
              'papers/Dr_Shaikh_Muhammad_Allayear/iSCSI_Multi_Connection_and_Error_Recovery_Method_for_Remote_Storage_System_in_Mobile_Appliance.pdf'
        },
        {
          'title': 'Simplified Mapreduce Mechanism for Large',
          'path':
              'papers/Dr_Shaikh_Muhammad_Allayear/Simplified_Mapreduce_Mechanism_for_Large.pdf'
        },
        {
          'title': 'The Architectural Design of Healthcare S',
          'path':
              'papers/Dr_Shaikh_Muhammad_Allayear/The_Architectural_Design_of_Healthcare_S.pdf'
        },
        {
          'title': 'Towards Adapting NAS Mechanism over Sol',
          'path':
              'papers/Dr_Shaikh_Muhammad_Allayear/Towards_Adapting_NAS_Mechanism_over_Sol.pdf'
        }
      ],
      'Dr. S. M. Aminul Haque': [
        {
          'title':
              'An Agent based Grouping Strategy for Federated Grid Computing',
          'path':
              'papers/Dr_S_M_Aminul_Haque/An_Agent_based_Grouping_Strategy_for_Federated_Grid_Computing_F_An_Agent_based_Grouping_Strategy_for_Federated_Grid_Computing.pdf'
        },
        {
          'title':
              'Efficient Resource Provisioning by Means of Sub Domain Based Ontology and Dynamic Pricing in Grid Computing',
          'path':
              'papers/Dr_S_M_Aminul_Haque/Efficient_Resource_Provisioning_by_Means_of_Sub_Domain_Based_Ontology_and_Dynamic_Pricing_in_Grid_Computing.pdf'
        },
        {
          'title':
              'Identifying and Modeling the Strengths and Weaknesses of Major Economic Models in Grid Resource Management',
          'path':
              'papers/Dr_S_M_Aminul_Haque/Identifying_and_Modeling_the_Strengths_and_Weaknesses_of_Major_Economic_Models_in_Grid_Resource_Management.pdf'
        },
        {
          'title':
              'Improved vision based diagnosis of multi plant disease using an ensemble of deep learning methods',
          'path':
              'papers/Dr_S_M_Aminul_Haque/Improved_vision_based_diagnosis_of_multi_plant_disease_using_an_ensemble_of_deep_learning_methods.pdf'
        },
        {
          'title':
              'Iterative Combinatorial Auction for Two Sided Grid Markets Multiple users and Multiple Providers',
          'path':
              'papers/Dr_S_M_Aminul_Haque/Iterative_Combinatorial_Auction_for_Two_Sided_Grid_Markets_Multiple_users_and_Multiple_Providers.pdf'
        },
        {
          'title':
              'Mathematical Problems in Engineering 2023 Pandey Trajectory Planning and Collision Control of a Mobile Robot A',
          'path':
              'papers/Dr_S_M_Aminul_Haque/Mathematical_Problems_in_Engineering_2023_Pandey_Trajectory_Planning_and_Collision_Control_of_a_Mobile_Robot_A.pdf'
        },
        {
          'title':
              'PithaNet a transfer learning based approach for traditional pitha classification',
          'path':
              'papers/Dr_S_M_Aminul_Haque/PithaNet_a_transfer_learning_based_approach_for_traditional_pitha_classification.pdf'
        },
        {
          'title':
              'Recognition Bangladeshi Sign Language BdSL Words using Deep convolutional Neural Networks DCNNs',
          'path':
              'papers/Dr_S_M_Aminul_Haque/recognition_Bangladeshi_Sign_Language_BdSL_Words_using_Deep_convolutional_Neural_Networks_(DCNNs).pdf'
        },
        {
          'title':
              'SkinNet 14 a deep learning framework for accurate skin cancer classification using low resolution dermoscopy images with optimized training time',
          'path':
              'papers/Dr_S_M_Aminul_Haque/SkinNet_14_a_deep_learning_framework_for_accurate_skin_cancer_classification_using_low_resolution_dermoscopy_images_with_optimized_training_time.pdf'
        },
        {
          'title':
              'Survival Analysis of Thyroid Cancer Patients Using Machine Learning Algorithms',
          'path':
              'papers/Dr_S_M_Aminul_Haque/Survival_Analysis_of_Thyroid_Cancer_Patients_Using_Machine_Learning_Algorithms.pdf'
        }
      ],
      'Dr. Md. Sarowar Hossain': [
        {
          'title':
              'Investigation of analgesic anti inflammatory and antidiabetic effects of Phyllanthus beillei leaves',
          'path':
              'papers/Dr_Md_Sarowar_Hossain/Investigation_of_analgesic_anti_inflammatory_and_antidiabetic_effects_of_Phyllanthus_beillei_leaves_H.pdf'
        }
      ],
      'Dr. A. H. M. Saifullah Sadi': [
        {
          'title':
              'Adaptive Secure and Efficient Routing Protocol to Enhance the Performance of Mobile Ad Hoc Network (MANET)',
          'path':
              'papers/Dr_A_H_M_SaifullahSadi/Adaptive_Secure_and_Efficient_Routing_Protocol_to_Enhance_the_Performance_of_Mobile_Ad_Hoc_Network_(MANET).pdf'
        },
        {
          'title':
              'Design and Development of a Bipedal Robot with Adaptive Locomotion Control for Uneven Terrain',
          'path':
              'papers/Dr_A_H_M_SaifullahSadi/Design_and_Development_of_a_Bipedal_Robot_with_Adaptive_Locomotion_Control_for_Uneven_Terrain.pdf'
        },
        {
          'title':
              'ML ASPA A Contemplation of Machine Learning based Acoustic Signal Processing Analysis for Sounds & Strains Emerging Technology',
          'path':
              'papers/Dr_A_H_M_SaifullahSadi/ML_ASPA_A_Contemplation_of_Machine_Learning_based_Acoustic_Signal_Processing_Analysis_for_Sounds_&_Strains_Emerging_Technology.pdf'
        },
        {
          'title':
              'Multiclass blood cancer classification using deep CNN with optimized features',
          'path':
              'papers/Dr_A_H_M_SaifullahSadi/Multiclass_blood_cancer_classification_using_deep_CNN_with_optimized_features.pdf'
        },
        {
          'title':
              'Paddy Insect Identification using Deep Features with Lion Optimization Algorithm',
          'path':
              'papers/Dr_A_H_M_SaifullahSadi/Paddy_Insect_Identification_using_Deep_Features_with_Lion_Optimization_Algorithm.pdf'
        },
        {
          'title':
              'Users Perceptions on the Usage of M commerce in Bangladesh A SWOT Analysis',
          'path':
              'papers/Dr_A_H_M_SaifullahSadi/Users_Perceptions_on_the_Usage_of_M_commerce_in_Bangladesh_A_SWOT_Analysis.pdf'
        }
      ],
    };
    return webPapers[professorName] ?? [];
  }

  String _getFolderName(String professorName) {
    final Map<String, String> folderMapping = {
      'Dr. Imran Mahmud': 'Dr_Imran_Mahmud',
      'Dr. A. H. M. Saifullah Sadi': 'Dr_A_H_M_SaifullahSadi',
      'Dr. Md. Sarowar Hossain': 'Dr_Md_Sarowar_Hossain',
      'Dr. S. M. Aminul Haque': 'Dr_S_M_Aminul_Haque',
      'Dr. Shaikh Muhammad Allayear': 'Dr_Shaikh_Muhammad_Allayear',
      'Professor Dr. Md. Fokhray Hossain': 'Professor_Dr_Md_FokhrayHossain',
      'Professor Dr. Sheak Rashed Haider Noori':
          'ProfessorDrSheakRashedHaiderNoori',
    };

    return folderMapping[professorName] ??
        professorName
            .replaceAll(RegExp(r'[^\w\s]'), '_')
            .replaceAll(RegExp(r'\s+'), '_');
  }

  String sanitizeName(String name) {
    final sanitized = name
        .trim()
        .replaceAll(RegExp(r'Dr\.|Professor|Prof\.'), '') // Remove titles
        .trim()
        .replaceAll(' ', '_')
        .replaceAll('.', '_')
        .replaceAll(RegExp(r'[^\w\s]'), '') // Remove special characters
        .replaceAll(
            RegExp(r'_+'), '_'); // Replace multiple underscores with single
    _logger.info('Sanitized name: $sanitized');
    return sanitized;
  }

  Map<String, List<Map<String, String>>> getCategorizedPapers() {
    // Define paper categories with their papers
    final categories = {
      'Computer Science': [
        _createPaper(
            'A Novel Front Door Security FDS Algorithm Using GoogleNet BiLSTM Hybridization',
            'Dr. Imran Mahmud'),
        _createPaper(
            'DOORMOR A Functional Prototype of a Manual Search and Rescue Robot',
            'Dr. Imran Mahmud'),
        _createPaper(
            'DPMS Data Driven Promotional Management System of Universities Using Deep Learning on Social Media',
            'Dr. Imran Mahmud'),
        _createPaper(
            'Innovation and the Sustainable Competitive Advantage of Young Firms A Strategy Implementation Approach',
            'Dr. Imran Mahmud'),
        _createPaper('ONGULANKO An IoT Based Biometric Attendance Logger',
            'Dr. Imran Mahmud'),
        _createPaper(
            'Smart Security System Using Face Recognition on Raspberry Pi',
            'Dr. Imran Mahmud'),
        _createPaper(
            'Trackez An IoT Based 3D Object Tracking From 2D Pixel Matrix Using Mez and FSL Algorithm',
            'Dr. Imran Mahmud'),
        _createPaper('A Location Based Time and Attendance System',
            'Dr. Shaikh Muhammad Allayear'),
        _createPaper(
            'Adaptation Mechanism of iSCSI Protocol for NAS Storage Solution in Wireless Environment',
            'Dr. Shaikh Muhammad Allayear'),
        _createPaper('AR & VR Based Child Education in Context of Bangladesh',
            'Dr. Shaikh Muhammad Allayear'),
        _createPaper('Implementation of a Smart AC Automation',
            'Dr. Shaikh Muhammad Allayear'),
        _createPaper(
            'iSCSI Multi Connection and Error Recovery Method for Remote Storage System in Mobile Appliance',
            'Dr. Shaikh Muhammad Allayear'),
        _createPaper('Simplified Mapreduce Mechanism for Large',
            'Dr. Shaikh Muhammad Allayear'),
        _createPaper('Appliance of Agile Methodology at Software Industry',
            'Professor Dr. Sheak Rashed Haider Noori'),
        _createPaper(
            'Suffix Based Automated Parts of Speech Tagging for Bangla Language',
            'Professor Dr. Sheak Rashed Haider Noori')
      ],
      'Biotechnology': [
        _createPaper(
            'Improved vision based diagnosis of multi plant disease using an ensemble of deep learning methods',
            'Dr. S. M. Aminul Haque')
      ],
      'Machine Learning': [
        _createPaper('Machine Learning Based Approach for Predicting Diabetes',
            'Dr. Imran Mahmud'),
        _createPaper(
            'Bengali Named Entity Recognition A survey with deep learning benchmark',
            'Professor Dr. Sheak Rashed Haider Noori'),
        _createPaper(
            'Machine Learning Based Unified Framework for Diabetes Prediction',
            'Professor Dr. Sheak Rashed Haider Noori'),
        _createPaper(
            'Regularized Weighted Circular Complex Valued Extreme Learning Machine',
            'Professor Dr. Sheak Rashed Haider Noori'),
        _createPaper('PithaNet a transfer learning based approach',
            'Dr. S. M. Aminul Haque'),
        _createPaper('Recognition Bangladeshi Sign Language BdSL Words',
            'Dr. S. M. Aminul Haque'),
        _createPaper('Survival Analysis of Thyroid Cancer Patients',
            'Dr. S. M. Aminul Haque')
      ],
      'Medical Science': [
        _createPaper(
            'IoT Based Remote Medical Diagnosis System', 'Dr. Imran Mahmud'),
        _createPaper(
            'Automation System to Find Out Plasma Donors for Corona Patients',
            'Professor Dr. Md. Fokhray Hossain'),
        _createPaper('Early Detection of Brain Tumor Using Capsule Network',
            'Professor Dr. Md. Fokhray Hossain'),
        _createPaper(
            'SkinNet 14 a deep learning framework for skin cancer classification',
            'Dr. S. M. Aminul Haque'),
        _createPaper('The Architectural Design of Healthcare S',
            'Dr. Shaikh Muhammad Allayear')
      ],
      'Engineering': [
        _createPaper(
            'An Agent based Grouping Strategy for Federated Grid Computing',
            'Dr. S. M. Aminul Haque'),
        _createPaper(
            'Efficient Resource Provisioning by Means of Sub Domain Based Ontology',
            'Dr. S. M. Aminul Haque'),
        _createPaper(
            'Identifying and Modeling the Strengths and Weaknesses of Major Economic Models',
            'Dr. S. M. Aminul Haque'),
        _createPaper(
            'Iterative Combinatorial Auction for Two Sided Grid Markets',
            'Dr. S. M. Aminul Haque'),
        _createPaper(
            'Mathematical Problems in Engineering 2023 Trajectory Planning',
            'Dr. S. M. Aminul Haque'),
        _createPaper('Towards Adapting NAS Mechanism over Sol',
            'Dr. Shaikh Muhammad Allayear')
      ],
      'Mathematics': [
        _createPaper(
            'Mathematical Problems in Engineering 2023 Trajectory Planning',
            'Dr. S. M. Aminul Haque')
      ]
    };

    return categories;
  }

  // Helper method to create paper entries (DRY principle)
  Map<String, String> _createPaper(String title, String author) {
    final sanitizedTitle = title.replaceAll(RegExp(r'[^\w\s]'), '_');
    return {
      'title': title,
      'path': 'papers/${_getFolderNameFromAuthor(author)}/$sanitizedTitle.pdf',
      'author': author
    };
  }

  // Helper method to get folder name from author (DRY principle)
  String _getFolderNameFromAuthor(String author) {
    return author
        .replaceAll(RegExp(r'Dr\.|Professor|Prof\.|\s+'), '_')
        .replaceAll(RegExp(r'[^\w]'), '')
        .replaceAll(RegExp(r'_+'), '_');
  }

  // Update paper counts
  Map<String, int> getCategoryPaperCounts() {
    final papers = getCategorizedPapers();
    return {
      'Computer Science': papers['Computer Science']?.length ?? 0,
      'Biotechnology': papers['Biotechnology']?.length ?? 0,
      'Machine Learning': papers['Machine Learning']?.length ?? 0,
      'Medical Science': papers['Medical Science']?.length ?? 0,
      'Engineering': papers['Engineering']?.length ?? 0,
      'Mathematics': papers['Mathematics']?.length ?? 0,
    };
  }

  List<Map<String, String>> getPapersByCategory(String category) {
    final categories = getCategorizedPapers();
    final papers = categories[category] ?? [];

    // Convert the papers to the expected format
    return papers
        .map((paper) => {
              'title': paper['title'] ?? '',
              'path': paper['path'] ?? '',
              'author': paper['author'] ?? '',
            })
        .toList();
  }

  // Track paper view
  Future<void> trackPaperView(String title, String author, String path) async {
    final paper = _trendingPapers[path] ??
        TrendingPaper(
          title: title,
          author: author,
          path: path,
          viewCount: 0,
          downloadCount: 0,
          lastViewed: DateTime.now(),
        );

    _trendingPapers[path] = TrendingPaper(
      title: paper.title,
      author: paper.author,
      path: paper.path,
      viewCount: paper.viewCount + 1,
      downloadCount: paper.downloadCount,
      lastViewed: DateTime.now(),
    );

    await _saveTrendingPapers();
  }

  // Track paper download
  Future<void> trackPaperDownload(
      String title, String author, String path) async {
    final paper = _trendingPapers[path] ??
        TrendingPaper(
          title: title,
          author: author,
          path: path,
          viewCount: 0,
          downloadCount: 0,
          lastViewed: DateTime.now(),
        );

    _trendingPapers[path] = TrendingPaper(
      title: paper.title,
      author: paper.author,
      path: paper.path,
      viewCount: paper.viewCount,
      downloadCount: paper.downloadCount + 1,
      lastViewed: DateTime.now(),
    );

    await _saveTrendingPapers();
  }

  // Get trending papers sorted by views
  List<TrendingPaper> getTrendingPapers({int limit = 10}) {
    final papers = _trendingPapers.values.toList();
    papers.sort((a, b) => b.viewCount.compareTo(a.viewCount));
    return papers.take(limit).toList();
  }

  // Save trending papers data
  Future<void> _saveTrendingPapers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = _trendingPapers.values.map((p) => p.toJson()).toList();
      await prefs.setString('trending_papers', jsonEncode(data));
    } catch (e) {
      _logger.severe('Error saving trending papers: $e');
    }
  }

  // Load trending papers data
  Future<void> loadTrendingPapers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('trending_papers');
      if (data != null) {
        final List<dynamic> jsonData = jsonDecode(data);
        _trendingPapers.clear();
        for (var item in jsonData) {
          final paper = TrendingPaper.fromJson(item);
          _trendingPapers[paper.path] = paper;
        }
        _logger.info('Loaded ${_trendingPapers.length} trending papers');
      } else {
        // Add some default papers for testing
        _trendingPapers['default_path_1'] = TrendingPaper(
          title: 'Sample Research Paper 1',
          author: 'Dr. John Doe',
          path: 'assets/papers/sample1.pdf',
          viewCount: 100,
          downloadCount: 50,
          lastViewed: DateTime.now(),
        );
        // Add more sample papers as needed
        _logger.info('No saved trending papers found, using defaults');
      }
    } catch (e) {
      _logger.severe('Error loading trending papers: $e');
    }
  }
}

class TrendingPaper {
  final String title;
  final String author;
  final String path;
  final int viewCount;
  final int downloadCount;
  final DateTime lastViewed;

  TrendingPaper({
    required this.title,
    required this.author,
    required this.path,
    required this.viewCount,
    required this.downloadCount,
    required this.lastViewed,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'path': path,
      'viewCount': viewCount,
      'downloadCount': downloadCount,
      'lastViewed': lastViewed.toIso8601String(),
    };
  }

  factory TrendingPaper.fromJson(Map<String, dynamic> json) {
    return TrendingPaper(
      title: json['title'],
      author: json['author'],
      path: json['path'],
      viewCount: json['viewCount'],
      downloadCount: json['downloadCount'],
      lastViewed: DateTime.parse(json['lastViewed']),
    );
  }
}
