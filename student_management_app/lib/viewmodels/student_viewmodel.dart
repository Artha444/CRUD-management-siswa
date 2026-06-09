import 'package:flutter/material.dart';
import '../models/siswa.dart';
import '../services/api_service.dart';

class StudentViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  String _searchQuery = '';
  
  List<Siswa> _students = [];
  List<Siswa> get students {
    if (_searchQuery.isEmpty) {
      return _students;
    }
    return _students
        .where((s) => s.nama.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchStudents() async {
    _setLoading(true);
    _clearError();
    try {
      _students = await _apiService.getSiswa();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addStudent(Siswa student) async {
    _setLoading(true);
    bool success = await _apiService.tambahSiswa(student);
    if (success) {
      await fetchStudents();
    } else {
      _errorMessage = 'Gagal menambah siswa';
      _setLoading(false);
    }
    return success;
  }

  Future<bool> updateStudent(Siswa student) async {
    _setLoading(true);
    bool success = await _apiService.editSiswa(student);
    if (success) {
      await fetchStudents();
    } else {
      _errorMessage = 'Gagal memperbarui siswa';
      _setLoading(false);
    }
    return success;
  }

  Future<bool> deleteStudent(int id) async {
    _setLoading(true);
    bool success = await _apiService.hapusSiswa(id);
    if (success) {
      await fetchStudents();
    } else {
      _errorMessage = 'Gagal menghapus siswa';
      _setLoading(false);
    }
    return success;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
