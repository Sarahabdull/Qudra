import 'package:get/get.dart';
class LoginModel {
  LoginModel({
    String? localId,
    String? email,
    String? name,
    String? displayName,
    String? idToken,
    bool? registered,
    String? refreshToken,
    String? expiresIn,
    Error? error

  }) {
    _localId = localId;
    _email = email;
    _name = name;
    _displayName = displayName;
    _idToken = idToken;
    _registered = registered;
    _refreshToken = refreshToken;
    _expiresIn = expiresIn;
    _error=error;
  }

  LoginModel.fromJson(dynamic json) {
    _localId = json['localId'];
    _email = json['email'];
    _name = json['displayName'];
    _displayName = json['displayName'];
    _idToken = json['idToken'];
    _registered = json['registered'];
    _refreshToken = json['refreshToken'];
    _expiresIn = json['expiresIn'];
    _error = json['error'] != null ? Error.fromJson(json['error']) : null;
    Get.log('err==  3 '+_error.toString());
  }

  String? _localId;
  String? _email;
  String? _name;
  String? _displayName;
  String? _idToken;
  bool? _registered;
  String? _refreshToken;
  String? _expiresIn;
  Error? _error;

  LoginModel copyWith({
    String? localId,
    String? email,
    String? name,
    String? displayName,
    String? idToken,
    bool? registered,
    String? refreshToken,
    String? expiresIn,
    Error? error,
  }) =>
      LoginModel(
        localId: localId ?? _localId,
        email: email ?? _email,
        name: name ?? _name,
        displayName: displayName ?? _displayName,
        idToken: idToken ?? _idToken,
        registered: registered ?? _registered,
        refreshToken: refreshToken ?? _refreshToken,
        expiresIn: expiresIn ?? _expiresIn,
        error: error??_error
      );

  String? get localId => _localId;

  String? get email => _email;

  String? get name => _name;

  String? get displayName => _displayName;

  String? get idToken => _idToken;

  bool? get registered => _registered;

  String? get refreshToken => _refreshToken;

  String? get expiresIn => _expiresIn;
  Error? get error => _error;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['localId'] = _localId;
    map['email'] = _email;
    map['displayName'] = _name;
    map['displayName'] = _displayName;
    map['idToken'] = _idToken;
    map['registered'] = _registered;
    map['refreshToken'] = _refreshToken;
    map['expiresIn'] = _expiresIn;
    if (_error != null) {
      map['error'] = _error?.toJson();
    }
    return map;
  }
}

class Error {
  Error({
    this.code,
    this.message,
    this.errors,
  });

  Error.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    if (json['errors'] != null) {
      errors = [];
      json['errors'].forEach((v) {
        errors?.add(Errors.fromJson(v));
      });
    }
  }

  int? code;
  String? message;
  List<Errors>? errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    if (errors != null) {
      map['errors'] = errors?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Errors {
  Errors({
    this.message,
    this.domain,
    this.reason,
  });

  Errors.fromJson(dynamic json) {
    message = json['message'];
    domain = json['domain'];
    reason = json['reason'];
  }

  String? message;
  String? domain;
  String? reason;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['domain'] = domain;
    map['reason'] = reason;
    return map;
  }
}
