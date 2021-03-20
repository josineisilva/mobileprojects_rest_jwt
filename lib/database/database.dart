import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:preferences/preferences.dart';
import 'dart:convert';

// TimeOut para as requicoes
const _TIMEOUT = Duration(seconds: 10);

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper.internal();

  static String _host;
  static String _token;

  static _setHost() {
    _host = PrefService.getString('host').trim();
  }

  static setToken(String _value) {
    _token = _value;
  }

  static Future<bool> initDb() async {
    _setHost();
    return true;
  }

  static String getAuthorization() {
    return "Bearer ${_token}";
  }

  static Future<List<Map>> getAll(String _table) async {
    print("Database getAll");
    List<Map> ret;
    String _errorMsg = "";
    final _response = await http.get(Uri.https("${_host}","/${_table}"),
      headers: {"Authorization": getAuthorization()})
      .timeout(_TIMEOUT)
      .catchError((_error) {_errorMsg = "${_error}";});
    if (_response != null) {
      print("Response ${_response.statusCode} ${_response.body}");
      if (_response.statusCode == 200) {
        final _parsed = json.decode(_response.body);
        ret = List<Map>();
        for (int i = 0; i < _parsed.length; i++)
          ret.add(_parsed[i]);
      } else
        _errorMsg = responseError(_response, null);
    }
    if (ret != null)
      return ret;
    else
      return Future<List<Map>>.error(_errorMsg);
  }

  static Future<Map> getByID(String _table, int _id) async {
    print("Database getByID");
    Map ret;
    String _errorMsg = "";
    final _response = await http.get(Uri.https("${_host}","/${_table}/${_id}"),
      headers: {"Authorization": getAuthorization()})
      .timeout(_TIMEOUT)
      .catchError((_error) {_errorMsg = "${_error}";});
    if (_response != null) {
      print("Response ${_response.statusCode} ${_response.body}");
      if (_response.statusCode == 200)
        ret = json.decode(_response.body);
      else
        _errorMsg = responseError(_response, null);
    }
    if (ret != null)
      return ret;
    else
      return Future<Map>.error(_errorMsg);
  }

  static Future<int> insert(String _table, Map _map) async {
    print("Database insert");
    int ret;
    String _errorMsg = "";
    _map.remove('id');
    final _response = await http.post(Uri.https("${_host}","/${_table}"),
      body: json.encode(_map),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": getAuthorization()
      },
      encoding: Encoding.getByName("utf-8"))
      .timeout(_TIMEOUT)
      .catchError((_error) {_errorMsg = "${_error}";});
    if (_response != null) {
      print("Response ${_response.statusCode} ${_response.body}");
      if (_response.statusCode == 201)
        ret = 1;
      else
        _errorMsg = responseError(_response, null);
    }
    if (ret != null)
      return ret;
    else
      return Future<int>.error(_errorMsg);
  }

  static Future<int> update(String _table, Map _map) async {
    print("Database update");
    int ret;
    String _errorMsg = "";
    final _response = await http.put(Uri.https("${_host}","/${_table}/${_map['id']}"),
      body: json.encode(_map),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": getAuthorization()
      },
      encoding: Encoding.getByName("utf-8"))
      .timeout(_TIMEOUT)
      .catchError((_error) {_errorMsg = "${_error}";});
    if (_response != null) {
      print("Response ${_response.statusCode} ${_response.body}");
      if (_response.statusCode == 200)
          ret = 1;
      else
        _errorMsg = responseError(_response, null);
    }
    if (ret != null)
      return ret;
    else
      return Future<int>.error(_errorMsg);
  }

  static Future<int> delete(String _table, int _id) async {
    print("Database delete");
    int ret;
    String _errorMsg = "";
    final _response = await http.delete(Uri.https("${_host}","/${_table}/${_id}"),
      headers: {"Authorization": getAuthorization()})
      .timeout(_TIMEOUT)
      .catchError((_error) {_errorMsg = "${_error}";});
    if (_response != null) {
      print("Response ${_response.statusCode} ${_response.body}");
      if (_response.statusCode == 200)
          ret = 1;
      else
        _errorMsg = responseError(_response, null);
    }
    if (ret != null)
      return ret;
    else
      return Future<int>.error(_errorMsg);
  }

  static Future<String> signin(Map _map) async {
    print("Database signin");
    String ret;
    String _errorMsg = "";
    final _response = await http.post(Uri.https("${_host}","/auth"),
      body: json.encode(_map),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      encoding: Encoding.getByName("utf-8"))
      .timeout(_TIMEOUT)
      .catchError((_error) {_errorMsg = "${_error}";});
    if (_response != null) {
      print("Response ${_response.statusCode} ${_response.body}");
      if (_response.statusCode == 200) {
        final _parsed = json.decode(_response.body);
        if (_parsed["tipo"].compareTo("Bearer")==0)
          ret = _parsed["token"];
        else
          _errorMsg = "Falha na autenticacao";
      }
      else
        _errorMsg = responseError(_response, null);
    }
    if (ret != null)
      return ret;
    else
      return Future<String>.error(_errorMsg);
  }

  static Future<bool> passwordReset(Map _map) async {
    print("Password Reset");
    bool ret;
    String _errorMsg = "";
    final _response = await http.post(Uri.https("${_host}","/password/forgot"),
      body: json.encode(_map),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      encoding: Encoding.getByName("utf-8"))
      .timeout(_TIMEOUT)
      .catchError((_error) {_errorMsg = "${_error}";});
    if (_response != null) {
      print("Response ${_response.statusCode} ${_response.body}");
      if (_response.statusCode == 200)
        ret = true;
      else
        _errorMsg = responseError(_response, null);
    }
    if (ret != null)
      return ret;
    else
      return Future<bool>.error(_errorMsg);
  }

  static String responseError(var _response, String _body) {
    String ret = 'Bad status code ${_response.statusCode}.';
    _body ??= _response.body;
    if (_body != null )
      ret = ret+'\n${_body}';
    return ret;
  }
}
