import 'dart:async';
import '../models/student.dart';
import '../database/database.dart';

class StudentDao {
  String _errorMsg = "";

  String get errorMsg => _errorMsg;

  Future<List<Student>> getAll() async {
    print("DAO getAll");
    _errorMsg = "";
    List<Map> _maps = await DatabaseHelper.getAll(
      'student'
    ).catchError((_error) {
        _errorMsg = _error;
    });
    if (_maps != null) {
      List<Student> _students = [];
      if (_maps.length > 0) {
        for (int i = 0; i < _maps.length; i++) {
          _students.add(Student.fromJson(_maps[i]));
        }
      }
      return _students;
    } else
      return null;
  }

  Future<Student> getByID(int _id) async {
    print("DAO getByID");
    Student ret;
    _errorMsg = "";
    var response = await DatabaseHelper.getByID(
      "student",
      _id
    ).catchError((_error) {
      _errorMsg = _error;
    });
    if ( _errorMsg == "" ) {
      if (response.isNotEmpty)
        ret = Student.fromJson(response);
      else
        ret = Student.empty();
    }
    return ret;
  }

  Future<int> insert(Student _student) async {
    print("DAO insert");
    int ret;
    _errorMsg = "";
    ret = await DatabaseHelper.insert(
      'student',
      _student.toJson()
    ).catchError((_error) {
      _errorMsg = _error;
    });
    return ret;
  }

  Future<int> update(Student _student) async {
    print("DAO update");
    int ret;
    _errorMsg = "";
    ret = await DatabaseHelper.update(
      'student',
      _student.toJson(),
    ).catchError((_error) {
      _errorMsg = _error;
    });
    return ret;
  }

  Future<int> delete(int _id) async {
    print("DAO delete");
    int ret;
    _errorMsg = "";
    ret = await DatabaseHelper.delete(
      'student',
      _id,
    ).catchError((_error) {
      _errorMsg = _error;
    });
    return ret;
  }
}
