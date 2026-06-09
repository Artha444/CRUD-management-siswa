import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/siswa.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.baseUrl = kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
    _dio.options.headers['Content-Type'] = 'application/json; charset=UTF-8';
  }

  Future<List<Siswa>> getSiswa() async {
    try {
      final response = await _dio.get('/siswa');
      if (response.statusCode == 200) {
        List jsonResponse = response.data;
        return jsonResponse.map((data) => Siswa.fromJson(data)).toList();
      } else {
        throw Exception('Gagal memuat data siswa');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> tambahSiswa(Siswa siswa) async {
    try {
      final response = await _dio.post(
        '/siswa',
        data: siswa.toJson(),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> hapusSiswa(int id) async {
    try {
      final response = await _dio.delete('/siswa/$id');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editSiswa(Siswa siswa) async {
    if (siswa.id == null) return false;
    try {
      final response = await _dio.put(
        '/siswa/${siswa.id}',
        data: siswa.toJson(),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
