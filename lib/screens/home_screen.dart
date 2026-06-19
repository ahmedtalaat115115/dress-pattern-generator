import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pattern_provider.dart';
import 'patterns_list_screen.dart';
import 'new_pattern_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PatternProvider>().initializeDatabase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مولّد باترونات الفساتين'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // البطاقة الرئيسية
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.design_services,
                        size: 64,
                        color: Colors.purple,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'أنشئ باترونات احترافية',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'صمم باترونات الفساتين بمقاسات مخصصة واطبعها بسهولة',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // الأزرار الرئيسية
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NewPatternScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('إنشاء باترون جديد'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PatternsListScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.list),
                label: const Text('الباترونات المحفوظة'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 32),
              // الميزات
              Text(
                'الميزات الرئيسية',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              _buildFeatureItem(
                icon: Icons.straighten,
                title: 'مقاسات شاملة',
                description: 'أدخل جميع المقاسات اللازمة',
              ),
              _buildFeatureItem(
                icon: Icons.picture_as_pdf,
                title: 'طباعة احترافية',
                description: 'اطبع الباترونات بصيغة PDF',
              ),
              _buildFeatureItem(
                icon: Icons.save,
                title: 'حفظ وتحميل',
                description: 'احفظ باترونك للاستخدام لاحقاً',
              ),
              _buildFeatureItem(
                icon: Icons.fabric,
                title: 'حساب الخامة',
                description: 'احسب كمية النسيج المطلوبة',
              ),
              _buildFeatureItem(
                icon: Icons.dashboard_customize,
                title: 'قوالب جاهزة',
                description: 'استخدم قوالب محضرة مسبقاً',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
