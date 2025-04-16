class _BasePaths {
  static const String base = 'assets/images/';
  static const String faculty = '${base}faculty/';
  static const String research = '${base}research/';
  static const String campus = '${base}campus/';
  static const String defaults = '${base}defaults/';
}

class DefaultImages {
  static const String profile = '${_BasePaths.defaults}default_profile.png';
  static const String paper = '${_BasePaths.defaults}default_paper.jpg';
}

class FacultyImages {
  static const String _basePath = 'assets/images/faculty/';

  // CSE Department
  static const String noori = '${_basePath}noori_siRk.jpg';
  static const String fokhray = '${_basePath}FokhrayHossain.png';
  static const String aminul = '${_basePath}AminulHaque.webp';

  // SWE Department
  static const String allayear = '${_basePath}MuhammadAllayear.jpg';
  static const String sadi = '${_basePath}SaifullahSadi.jpeg';
  static const String imran = '${_basePath}ImranMahmud.jpg';

  // Pharmacy Department
  static const String sarowar = '${_basePath}SarowarHossain.jpg';
  static const String muniruddin = '${_basePath}MuniruddinAhmed.png';
  static const String ekramul = '${_basePath}EkramulHaque.jpg';

  // EEE Department
  static const String shamsul = '${_basePath}ShamsulAlam.jpg';

  static String getById(String facultyId) =>
      '${_BasePaths.faculty}$facultyId.jpg';

  static String getByName(String name) {
    final sanitizedName = ImageUtils.sanitizeFileName(name);
    return '${_BasePaths.faculty}$sanitizedName.jpg';
  }
}

class ResearchImages {
  static const String heartDisease = '${_BasePaths.research}heart_disease.jpg';
  static const String cloudArchitecture =
      '${_BasePaths.research}cloud_architecture.jpg';

  static String getById(String paperId) => '${_BasePaths.research}$paperId.jpg';
}

class CampusImages {
  static const String mainBuilding = '${_BasePaths.campus}main_building.jpg';
  static const String library = '${_BasePaths.campus}library.jpg';
  static const String laboratory = '${_BasePaths.campus}laboratory.jpg';

  static String getByLocation(String location) {
    final sanitizedLocation = ImageUtils.sanitizeFileName(location);
    return '${_BasePaths.campus}$sanitizedLocation.jpg';
  }
}

class ImageUtils {
  static String sanitizeFileName(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .trim();
  }
}
