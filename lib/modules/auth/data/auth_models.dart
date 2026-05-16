class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password
  };
}

class RegisterRequest {
  final String name;
  final String email;
  final String password;

  RegisterRequest({required this.name, required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password
  };
}

class TokenResponse{
  final String accessToken;

  TokenResponse({required this.accessToken});

  factory TokenResponse.fromJson(Map<String, dynamic> json) => TokenResponse(
    accessToken: json['access_token']
  );
}
class UpdateAccountTypeRequest {
  final String accountType;

  UpdateAccountTypeRequest({required this.accountType});

  Map<String, dynamic> toJson() => {
    'account_type': accountType,
  };
}

class UserResponse {
  final String id;
  final String name;
  final String email;
  final String accountType;
  final String? fcmToken;
  final List<double> notificationDaysBefore;
  final DateTime createdAt;

  UserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.accountType,
    this.fcmToken,
    required this.notificationDaysBefore,
    required this.createdAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    accountType: json['account_type'] ?? 'personal',
    fcmToken: json['fcm_token'],
    notificationDaysBefore: (json['notification_days_before'] as List).map((e) => (e as num).toDouble()).toList(),
    createdAt: DateTime.parse(json['created_at']),
  );

  UserResponse copyWith({String? accountType}) => UserResponse(
    id: id,
    name: name,
    email: email,
    accountType: accountType ?? this.accountType,
    fcmToken: fcmToken,
    notificationDaysBefore: notificationDaysBefore,
    createdAt: createdAt,
  );
}