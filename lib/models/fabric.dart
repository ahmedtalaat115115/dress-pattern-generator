class FabricType {
  final String id;
  final String name; // اسم النسيج
  final String arabicName;
  final double width; // عرض القماش (سم)
  final double wasteFactor; // نسبة الهدر (النسبة المئوية)

  FabricType({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.width,
    this.wasteFactor = 15, // 15% بشكل افتراضي
  });
}

// أنواع النسيج الشائعة
final List<FabricType> commonFabrics = [
  FabricType(
    id: 'cotton',
    name: 'Cotton',
    arabicName: 'قطن',
    width: 150,
    wasteFactor: 15,
  ),
  FabricType(
    id: 'linen',
    name: 'Linen',
    arabicName: 'كتان',
    width: 150,
    wasteFactor: 15,
  ),
  FabricType(
    id: 'silk',
    name: 'Silk',
    arabicName: 'حرير',
    width: 140,
    wasteFactor: 20,
  ),
  FabricType(
    id: 'chiffon',
    name: 'Chiffon',
    arabicName: 'شيفون',
    width: 150,
    wasteFactor: 25,
  ),
  FabricType(
    id: 'jersey',
    name: 'Jersey',
    arabicName: 'جيرسيه',
    width: 160,
    wasteFactor: 10,
  ),
];

class FabricCalculation {
  final double patternArea; // مساحة الباترون بالسم²
  final double fabricWidth; // عرض القماش بالسم
  final double wasteFactor; // نسبة الهدر
  final double fabricLength; // طول القماش المطلوب بالسم

  FabricCalculation({
    required this.patternArea,
    required this.fabricWidth,
    required this.wasteFactor,
  }) : fabricLength = _calculateFabricLength(patternArea, fabricWidth, wasteFactor);

  static double _calculateFabricLength(
    double patternArea,
    double fabricWidth,
    double wasteFactor,
  ) {
    // احسب الطول الأساسي
    double baseLength = patternArea / fabricWidth;
    // أضف نسبة الهدر
    double totalLength = baseLength * (1 + (wasteFactor / 100));
    return totalLength;
  }

  double getFabricLengthInMeters() {
    return fabricLength / 100;
  }

  double getFabricLengthInYards() {
    return (fabricLength / 100) * 1.09361; // التحويل من متر إلى yard
  }
}
