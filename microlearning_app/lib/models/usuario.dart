/// Modelo de Usuario
class Usuario {
  final int idUsuario;
  final String nombre;
  final String correo;
  final String? fechaRegistro;

  Usuario({
    required this.idUsuario,
    required this.nombre,
    required this.correo,
    this.fechaRegistro,
  });

  /// Crear Usuario desde JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json['id_usuario'] as int,
      nombre: json['nombre'] as String,
      correo: json['correo'] as String,
      fechaRegistro: json['fecha_registro'] as String?,
    );
  }

  /// Convertir Usuario a JSON
  Map<String, dynamic> toJson() {
    return {
      'id_usuario': idUsuario,
      'nombre': nombre,
      'correo': correo,
      'fecha_registro': fechaRegistro,
    };
  }

  /// Copiar con modificaciones
  Usuario copyWith({
    int? idUsuario,
    String? nombre,
    String? correo,
    String? fechaRegistro,
  }) {
    return Usuario(
      idUsuario: idUsuario ?? this.idUsuario,
      nombre: nombre ?? this.nombre,
      correo: correo ?? this.correo,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
    );
  }
}

/// Request de Login
class LoginRequest {
  final String correo;
  final String contrasena;

  LoginRequest({
    required this.correo,
    required this.contrasena,
  });

  Map<String, dynamic> toJson() {
    return {
      'correo': correo,
      'contrasena': contrasena,
    };
  }
}

/// Response de Login
class LoginResponse {
  final String message;
  final int idUsuario;
  final String nombre;

  LoginResponse({
    required this.message,
    required this.idUsuario,
    required this.nombre,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] as String,
      idUsuario: json['id_usuario'] as int,
      nombre: json['nombre'] as String,
    );
  }
}

/// Request de Registro
class RegistroRequest {
  final String nombre;
  final String correo;
  final String contrasena;

  RegistroRequest({
    required this.nombre,
    required this.correo,
    required this.contrasena,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'correo': correo,
      'contrasena': contrasena,
    };
  }
}
