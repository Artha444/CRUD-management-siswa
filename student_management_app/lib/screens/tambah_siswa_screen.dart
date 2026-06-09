import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/siswa.dart';
import '../viewmodels/student_viewmodel.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class TambahSiswaScreen extends StatefulWidget {
  final Siswa? siswa;

  const TambahSiswaScreen({Key? key, this.siswa}) : super(key: key);

  @override
  State<TambahSiswaScreen> createState() => _TambahSiswaScreenState();
}

class _TambahSiswaScreenState extends State<TambahSiswaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _kelasController = TextEditingController();
  final _nisController = TextEditingController();

  bool get isEditMode => widget.siswa != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _namaController.text = widget.siswa!.nama;
      _kelasController.text = widget.siswa!.kelas;
      _nisController.text = widget.siswa!.nis;
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final siswaData = Siswa(
        id: isEditMode ? widget.siswa!.id : null,
        nama: _namaController.text,
        kelas: _kelasController.text,
        nis: _nisController.text,
      );

      final viewModel = context.read<StudentViewModel>();
      
      final success = isEditMode 
          ? await viewModel.updateStudent(siswaData)
          : await viewModel.addStudent(siswaData);

      if (success) {
        if (!mounted) return;
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEditMode ? 'Siswa berhasil diperbarui' : 'Siswa berhasil ditambahkan')),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEditMode ? 'Gagal memperbarui siswa' : 'Gagal menambahkan siswa')),
        );
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _kelasController.dispose();
    _nisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoPanel(),
                    const SizedBox(height: 32),
                    _buildFormCanvas(),
                    const SizedBox(height: 48),
                    _buildContextualDetails(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceContainer,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppTheme.surfaceContainerLowest,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: AppTheme.primary),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                isEditMode ? 'Edit Siswa' : 'Tambah Siswa',
                style: AppTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          Text(
            'Academic Atelier',
            style: AppTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPanel() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.tertiaryFixed,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info, color: AppTheme.tertiary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Penting',
                  style: AppTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.onTertiaryFixed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Nomor Induk Siswa (NIS) harus bersifat unik dan tidak boleh duplikat dalam sistem.',
                  style: AppTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.onTertiaryFixedVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCanvas() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A191B23),
            blurRadius: 64,
            offset: Offset(0, 32),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FORMULIR PENDAFTARAN',
              style: AppTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Data Identitas Siswa',
              style: AppTheme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 48),
            CustomTextField(
              label: 'Nama Lengkap',
              hint: 'Contoh: Budi Santoso',
              controller: _namaController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),
            CustomTextField(
              label: 'Nomor Induk Siswa (NIS)',
              hint: '8 Digit Angka',
              controller: _nisController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NIS tidak boleh kosong';
                }
                return null;
              },
            ),
            CustomTextField(
              label: 'Kelas',
              hint: 'Pilih Kelas',
              controller: _kelasController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kelas tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Consumer<StudentViewModel>(
              builder: (context, viewModel, child) {
                return CustomButton(
                  text: isEditMode ? 'Update Data Siswa' : 'Simpan Data Siswa',
                  onPressed: _submit,
                  isLoading: viewModel.isLoading,
                );
              },
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Batal',
              onPressed: () => Navigator.pop(context),
              isPrimary: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextualDetails() {
    return Column(
      children: [
        _buildDetailBox(
          icon: Icons.verified_user,
          title: 'Privasi Data',
          description: 'Data yang disimpan akan dienkripsi secara otomatis dan hanya dapat diakses oleh staf administrasi yang berwenang.',
        ),
        const SizedBox(height: 24),
        _buildDetailBox(
          icon: Icons.sync,
          title: 'Sinkronisasi',
          description: 'Setelah disimpan, profil siswa akan langsung tersedia di dashboard guru dan laporan absensi harian.',
        ),
      ],
    );
  }

  Widget _buildDetailBox({required IconData icon, required String title, required String description}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.outlineVariant.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primary, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTheme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
