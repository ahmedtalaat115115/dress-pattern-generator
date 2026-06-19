import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pattern_provider.dart';
import 'pattern_display_screen.dart';

class PatternsListScreen extends StatelessWidget {
  const PatternsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الباترونات المحفوظة'),
        centerTitle: true,
      ),
      body: Consumer<PatternProvider>(
        builder: (context, provider, _) {
          if (provider.patterns.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.folder_open,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد باترونات محفوظة',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ابدأ بإنشاء باترون جديد',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: provider.patterns.length,
            itemBuilder: (context, index) {
              final pattern = provider.patterns[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(pattern.name),
                  subtitle: Text(
                    provider.getDressTypeName(pattern.type),
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text('عرض'),
                        onTap: () {
                          Future.delayed(const Duration(milliseconds: 200), () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PatternDisplayScreen(
                                  pattern: pattern,
                                ),
                              ),
                            );
                          });
                        },
                      ),
                      PopupMenuItem(
                        child: const Text('حذف'),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('تأكيد الحذف'),
                              content: Text(
                                'هل تريد حذف باترون "${pattern.name}"؟',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('إلغاء'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    provider.deletePattern(pattern.id);
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('تم حذف الباترون'),
                                      ),
                                    );
                                  },
                                  child: const Text('حذف'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PatternDisplayScreen(
                          pattern: pattern,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
