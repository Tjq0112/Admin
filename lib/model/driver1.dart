class Driver1{
  String id;
  final String d_name;
  final String d_username;
  final String d_password;

  Driver1({
    this.id = "",
    required this.d_name,
    required this.d_username,
    required this.d_password,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': d_name,
    'username': d_username,
    'password': d_password,
  };
}