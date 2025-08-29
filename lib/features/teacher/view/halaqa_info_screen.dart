
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/data/datasources/teacher_local_datasource.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/features/teacher/bloc/halaqa_info/halaqa_info_bloc.dart';

class HalaqaInfoScreen extends StatefulWidget {
  const HalaqaInfoScreen({super.key});

  @override
  State<HalaqaInfoScreen> createState() => _HalaqaInfoScreenState();
}

class _HalaqaInfoScreenState extends State<HalaqaInfoScreen> {
  int? halaqaId;

  // سنستخدم FutureBuilder لضمان أن الـ halaqaId متاح قبل بناء الـ BlocProvider
  late Future<int?> _halaqaIdFuture;

  @override
  void initState() {
    super.initState();
    // بدأ عملية جلب الـ ID من الذاكرة المؤقتة
    _halaqaIdFuture = _loadHalaqaId();
  }

  Future<int?> _loadHalaqaId() async {
    final localDatasource = TeacherLocalDatasource();
    final halaqa = await localDatasource.getCachedHalaqaData();
    print("📌 HalaqaId from cache = ${halaqa?.idhalaqa}");
    return halaqa?.idhalaqa;
  }

  @override
  Widget build(BuildContext context) {
    // نستخدم FutureBuilder لانتظار تحميل الـ halaqaId
    return FutureBuilder<int?>(
      future: _halaqaIdFuture,
      builder: (context, snapshot) {
        // حالة الانتظار: إذا كان الـ Future لم ينته بعد
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // حالة الخطأ: إذا فشل تحميل الـ ID
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'فشل في تحميل بيانات الحلقة الأساسية.',
                style: GoogleFonts.tajawal(),
              ),
            ),
          );
        }

        // حالة النجاح: الـ ID أصبح متاحًا (قد يكون null)
        final int? id = snapshot.data;
        if (id == null) {
          // إذا كان الـ ID فارغًا، نعرض رسالة مناسبة
          return Scaffold(
            body: Center(
              child: Text(
                'لم يتم العثور على حلقة لهذا المعلم.',
                style: GoogleFonts.tajawal(),
              ),
            ),
          );
        }
        
        // إذا كان الـ ID موجودًا، نقوم ببناء الـ BlocProvider و Widget الرئيسي
        halaqaId = id; // تخزين الـ ID في متغير الحالة

        return BlocProvider<HalaqaInfoBloc>(
          create: (context) => HalaqaInfoBloc(
            halaqaRepository: context.read<TeacherRepository>(),
          )..add(FetchHalaqaInfo(halaqaId: halaqaId!)),
          child: Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              title: Text(
                'بيانات الحلقة',
                style: GoogleFonts.tajawal(fontWeight: FontWeight.bold),
              ),
              backgroundColor: AppColors.steel_blue,
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
            body: BlocBuilder<HalaqaInfoBloc, HalaqaInfoState>(
              builder: (context, state) {
                if (state is HalaqaInfoLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is HalaqaInfoSuccess) {
                  final halaqa = state.halaqaData;
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<HalaqaInfoBloc>().add(
                        FetchHalaqaInfo(halaqaId: halaqaId!),
                      );
                    },
                    child: ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        _buildInfoCard(
                          title: 'اسم الحلقة',
                          content: halaqa.name,
                          icon: Icons.bookmark,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          title: 'المسجد',
                          content: halaqa.mosqueName,
                          icon: Icons.mosque,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          title: 'عدد الطلاب المسجلين',
                          content: '${halaqa.studentCount} طالباً',
                          icon: Icons.group,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          title: 'الأوقات',
                          content: halaqa.timings,
                          icon: Icons.access_time_filled,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          title: 'وصف الحلقة',
                          content: halaqa.description,
                          icon: Icons.description,
                        ),
                      ],
                    ),
                  );
                } else if (state is HalaqaInfoFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.errorMessage, style: GoogleFonts.tajawal()),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            context.read<HalaqaInfoBloc>().add(
                              FetchHalaqaInfo(halaqaId: halaqaId!),
                            );
                          },
                          child: Text(
                            'إعادة المحاولة',
                            style: GoogleFonts.tajawal(),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(child: Text('جارٍ تهيئة الشاشة...'));
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    // (الكود هنا لم يتغير، وهو جيد كما هو)
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.steel_blue, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.tajawal(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: GoogleFonts.tajawal(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.night_blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}