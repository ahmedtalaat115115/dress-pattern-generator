enum FabricType {
  cotton,
  linen,
  silk,
  chiffon,
  jersey,
}

class Fabric {
  final FabricType type;
  final String arabicName;
  final double width; // in cm
  final double wasteFactor; // percentage

  Fabric({
    required this.type,
    required this.arabicName,
    required this.width,
    required this.wasteFactor,
  });
}

final List<FabricType> commonFabrics = [
  FabricType.cotton,
  FabricType.linen,
  FabricType.silk,
  FabricType.chiffon,
  FabricType.jersey,
];

final Map<FabricType, Fabric> fabricDetails = {
  FabricType.cotton: Fabric(
    type: FabricType.cotton,
    arabicName: 'القطن',
    width: 150,
    wasteFactor: 15,
  ),
  FabricType.linen: Fabric(
    type: FabricType.linen,
    arabicName: 'الكتان',
    width: 140,
    wasteFactor: 18,
  ),
  FabricType.silk: Fabric(
    type: FabricType.silk,
    arabicName: 'الحرير',
    width: 140,
    wasteFactor: 20,
  ),
  FabricType.chiffon: Fabric(
    type: FabricType.chiffon,
    arabicName: 'الشيفون',
    width: 140,
    wasteFactor: 25,
  ),
  FabricType.jersey: Fabric(
    type: FabricType.jersey,
    arabicName: 'الجيرسيه',
    width: 160,
    wasteFactor: 12,
  ),
};

class FabricCalculation {
  final double patternArea; // in cm²
  final double fabricWidth; // in cm
  final double wasteFactor; // percentage

  FabricCalculation({
    required this.patternArea,
    required this.fabricWidth,
    required this.wasteFactor,
  });

  double getFabricLengthInCm() {
    final baseLength = patternArea / fabricWidth;
    final wasteLength = baseLength * (wasteFactor / 100);
    return baseLength + wasteLength;
  }

  double getFabricLengthInMeters() {
    return getFabricLengthInCm() / 100;
  }
}
