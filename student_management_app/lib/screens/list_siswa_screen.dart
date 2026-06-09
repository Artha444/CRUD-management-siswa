import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/student_viewmodel.dart';
import '../theme/app_theme.dart';
import '../widgets/student_card.dart';
import 'tambah_siswa_screen.dart';

class ListSiswaScreen extends StatefulWidget {
  const ListSiswaScreen({Key? key}) : super(key: key);

  @override
  State<ListSiswaScreen> createState() => _ListSiswaScreenState();
}

class _ListSiswaScreenState extends State<ListSiswaScreen> {
  int _currentIndex = 0;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentViewModel>().fetchStudents();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _hapusSiswa(int id) async {
    final viewModel = context.read<StudentViewModel>();
    final success = await viewModel.deleteStudent(id);
    if (success) {
      _showSnackBar('Siswa berhasil dihapus');
    } else {
      _showSnackBar('Gagal menghapus siswa');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: Consumer<StudentViewModel>(
                    builder: (context, viewModel, child) {
                      if (viewModel.isLoading && viewModel.students.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      if (viewModel.errorMessage != null && viewModel.students.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(viewModel.errorMessage!),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: viewModel.fetchStudents,
                                child: const Text('Coba Lagi'),
                              )
                            ],
                          ),
                        );
                      }
                      
                      if (_currentIndex == 1) {
                        return _buildReportsContent(viewModel);
                      }
                      
                      return RefreshIndicator(
                        onRefresh: viewModel.fetchStudents,
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
                          children: [
                            _buildEditorialHeader(viewModel.students.length),
                            const SizedBox(height: 48),
                            ...viewModel.students.asMap().entries.map((entry) {
                              return StudentCard(
                                index: entry.key,
                                siswa: entry.value,
                                onDelete: () => _hapusSiswa(entry.value.id!),
                                onEdit: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TambahSiswaScreen(siswa: entry.value),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Gradient FAB
          if (_currentIndex == 0)
            Positioned(
            right: 32,
            bottom: 120, // above bottom navbar
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryContainer],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(32),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TambahSiswaScreen()),
                    );
                  },
                  child: const Icon(Icons.add, color: Colors.white, size: 32),
                ),
              ),
            ),
          ),
          
          // Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surface.withOpacity(0.8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A191B23),
                        blurRadius: 24,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(Icons.group, 'STUDENTS', _currentIndex == 0, onTap: () {
                          setState(() {
                            _currentIndex = 0;
                          });
                        }),
                        _buildNavItem(Icons.add_circle, 'ADD', false, onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TambahSiswaScreen()),
                          );
                        }),
                        _buildNavItem(Icons.analytics, 'REPORTS', _currentIndex == 1, onTap: () {
                          setState(() {
                            _currentIndex = 1;
                            _isSearching = false;
                            _searchController.clear();
                            context.read<StudentViewModel>().search('');
                          });
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceContainer,
      ),
      child: _isSearching
          ? Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: AppTheme.textTheme.bodyLarge,
                    decoration: InputDecoration(
                      hintText: 'Cari nama siswa...',
                      border: InputBorder.none,
                      hintStyle: AppTheme.textTheme.bodyLarge?.copyWith(color: AppTheme.secondary),
                    ),
                    onChanged: (value) {
                      context.read<StudentViewModel>().search(value);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppTheme.primary),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchController.clear();
                      context.read<StudentViewModel>().search('');
                    });
                  },
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppTheme.secondaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: AppTheme.primary),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Academic Atelier',
                      style: AppTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                if (_currentIndex == 0)
                  IconButton(
                    icon: const Icon(Icons.search, color: AppTheme.primary),
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                  ),
              ],
            ),
    );
  }

  Widget _buildEditorialHeader(int totalStudents) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daftar Siswa',
          style: AppTheme.textTheme.displayLarge?.copyWith(
            height: 1.1,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'A curated overview of our student community. Manage enrollments, track progress, and foster academic growth within our atelier.',
          style: AppTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.secondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Total: $totalStudents Students',
                style: AppTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.secondary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Semester 1',
                style: AppTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.onPrimary : AppTheme.secondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTheme.textTheme.labelSmall?.copyWith(
                color: isSelected ? AppTheme.onPrimary : AppTheme.secondary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsContent(StudentViewModel viewModel) {
    // Calculate statistics
    int totalStudents = viewModel.students.length;
    Map<String, int> kelasDistribution = {};
    for (var siswa in viewModel.students) {
      kelasDistribution[siswa.kelas] = (kelasDistribution[siswa.kelas] ?? 0) + 1;
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
      children: [
        Text(
          'Laporan & Analitik',
          style: AppTheme.textTheme.displayLarge?.copyWith(
            height: 1.1,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Sebuah ringkasan komprehensif mengenai demografi siswa dan distribusinya di berbagai kelas.',
          style: AppTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.secondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),
        // Total Students Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.primary.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.school, color: AppTheme.primary, size: 32),
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Siswa',
                    style: AppTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$totalStudents',
                    style: AppTheme.textTheme.displayLarge?.copyWith(
                      color: AppTheme.primary,
                      fontSize: 48,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Distribusi Kelas',
          style: AppTheme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        if (kelasDistribution.isEmpty)
          Text(
            'Belum ada data siswa.',
            style: AppTheme.textTheme.bodyLarge?.copyWith(color: AppTheme.secondary),
          ),
        ...kelasDistribution.entries.map((entry) {
          final percentage = totalStudents > 0 ? (entry.value / totalStudents) : 0.0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kelas ${entry.key}',
                        style: AppTheme.textTheme.titleMedium,
                      ),
                      Text(
                        '${entry.value} Siswa',
                        style: AppTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: percentage,
                      backgroundColor: AppTheme.primary.withOpacity(0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
