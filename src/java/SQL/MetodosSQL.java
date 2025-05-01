package SQL;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class MetodosSQL {

    private Connection conexion;
    private PreparedStatement sentenciaPreparada;

    public boolean registrarUsuario(String id, String nombre, String apellido, String telefono, String direccion, String contrasena,
                                    String usuarioGeneradoAutomaticamente, String rol,
                                    String especialidad, String numeroTarjetaProfesional) {
        boolean registroExitoso = false;

        try {
            conexion = ConexionBD.conectar();
            if (conexion == null) {
                System.err.println("Error: No se pudo establecer la conexión a la base de datos.");
                return false;
            }

            // 1. Insertar datos en la tabla Usuario
            String consultaUsuario = "INSERT INTO Usuario (nombre, apellidos, telefono, direccion, contrasena, usuario_generado, tipo_usuario) VALUES (?, ?, ?, ?, ?, ?, ?)";
            sentenciaPreparada = conexion.prepareStatement(consultaUsuario, PreparedStatement.RETURN_GENERATED_KEYS);
            sentenciaPreparada.setString(1, nombre);
            sentenciaPreparada.setString(2, apellido);
            sentenciaPreparada.setString(3, telefono);
            sentenciaPreparada.setString(4, direccion);
            sentenciaPreparada.setString(5, contrasena); // Considera usar hashing para la contraseña
            sentenciaPreparada.setString(6, usuarioGeneradoAutomaticamente);
            sentenciaPreparada.setString(7, rol);

            int filasAfectadasUsuario = sentenciaPreparada.executeUpdate();

            if (filasAfectadasUsuario > 0) {
                System.out.println("Usuario registrado en la tabla Usuario.");
                registroExitoso = true;

                // Obtener el ID generado para el usuario recién insertado
                int idUsuario = -1;
                try (java.sql.ResultSet generatedKeys = sentenciaPreparada.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        idUsuario = generatedKeys.getInt(1);
                    } else {
                        System.err.println("Error: No se pudo obtener el ID del usuario insertado.");
                        registroExitoso = false; // No se pudo obtener el ID, así que el registro no es completamente exitoso
                    }
                }

                if (registroExitoso && idUsuario != -1) {
                    // 2. Insertar datos en la tabla específica según el rol
                    if ("especialista".equals(rol)) {
                        String consultaEspecialista = "INSERT INTO Especialista (id_usuario, especialidad, numero_tarjeta_profesional) VALUES (?, ?, ?)";
                        sentenciaPreparada = conexion.prepareStatement(consultaEspecialista);
                        sentenciaPreparada.setInt(1, idUsuario);
                        sentenciaPreparada.setString(2, especialidad);
                        sentenciaPreparada.setString(3, numeroTarjetaProfesional);

                        int filasAfectadasEspecialista = sentenciaPreparada.executeUpdate();
                        if (filasAfectadasEspecialista > 0) {
                            System.out.println("Datos de especialista registrados.");
                        } else {
                            System.err.println("Error al registrar datos de especialista.");
                            registroExitoso = false; // Falló la inserción en Especialista
                            // Considera hacer un rollback de la transacción aquí si es importante la integridad total
                        }
                    } else if ("paciente".equals(rol)) {
                        // No hay campos adicionales específicos para la tabla Paciente según tu diseño inicial.
                        // Si en el futuro agregas campos a la tabla Paciente, aquí iría la lógica de inserción.
                        System.out.println("Paciente registrado.");
                    }
                }
            } else {
                System.err.println("Error al registrar el usuario en la tabla Usuario.");
                registroExitoso = false;
            }

        } catch (SQLException e) {
            System.err.println("Error SQL: " + e.getMessage());
            registroExitoso = false;
        } finally {
            try {
                if (sentenciaPreparada != null) sentenciaPreparada.close();
                if (conexion != null && !conexion.isClosed()) conexion.close();
            } catch (SQLException e) {
                System.err.println("Error al cerrar la conexión: " + e.getMessage());
            }
        }

        System.out.println("Resultado del registro: " + registroExitoso);
        return registroExitoso;
    }

    public boolean buscarUsuarioRepetidoBD(String usuarioGenerado) {
        boolean usuarioRepetido = false;
        try {
            conexion = ConexionBD.conectar();
            String consulta = "SELECT usuario_generado FROM Usuario WHERE usuario_generado = ?";
            sentenciaPreparada = conexion.prepareStatement(consulta);
            sentenciaPreparada.setString(1, usuarioGenerado);
            try (java.sql.ResultSet resultado = sentenciaPreparada.executeQuery()) {
                if (resultado.next()) {
                    usuarioRepetido = true; // El usuario está registrado en la BD
                }
            }
        } catch (SQLException e) {
            System.err.println("Error SQL al buscar usuario repetido: " + e.getMessage());
        } finally {
            try {
                if (sentenciaPreparada != null) sentenciaPreparada.close();
                if (conexion != null && !conexion.isClosed()) conexion.close();
            } catch (SQLException e) {
                System.err.println("Error al cerrar la conexión: " + e.getMessage());
            }
        }
        System.out.println("El valor del usuario Repetido en el METODO es: " + usuarioRepetido);
        return usuarioRepetido;
    }

    public String buscarUsuarioInicioSesion(String usuario, String contrasena) {
        String rol = null; // Inicializamos el rol como null (indicando fallo de autenticación)
        try {
            conexion = ConexionBD.conectar();
            String consulta = "SELECT usuario_generado, contrasena, tipo_usuario FROM Usuario WHERE usuario_generado = ? AND contrasena = ?";
            sentenciaPreparada = conexion.prepareStatement(consulta);
            sentenciaPreparada.setString(1, usuario);
            sentenciaPreparada.setString(2, contrasena);
            try (java.sql.ResultSet resultado = sentenciaPreparada.executeQuery()) {
                if (resultado.next()) {
                    rol = resultado.getString("tipo_usuario"); // Obtenemos el rol del usuario
                }
            }
        } catch (SQLException e) {
            System.err.println("Error SQL al iniciar sesión: " + e.getMessage());
        } finally {
            try {
                if (sentenciaPreparada != null) sentenciaPreparada.close();
                if (conexion != null && !conexion.isClosed()) conexion.close();
            } catch (SQLException e) {
                System.err.println("Error al cerrar la conexión: " + e.getMessage());
            }
        }
        System.out.println("El valor del rol en el metodo es: " + rol);
        return rol; // Ahora retornamos el rol (o null si falla la autenticación)
    }

    public String buscarNombre(String usuario) {
        String nombre = null;
        try {
            conexion = ConexionBD.conectar();
            String consulta = "SELECT nombre FROM Usuario WHERE usuario_generado = ?";
            sentenciaPreparada = conexion.prepareStatement(consulta);
            sentenciaPreparada.setString(1, usuario);
            try (java.sql.ResultSet resultado = sentenciaPreparada.executeQuery()) {
                if (resultado.next()) {// El usuario fue encontrado y obtenemos el nombre
                    nombre = resultado.getString("nombre");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error SQL al buscar nombre: " + e.getMessage());
        } finally {
            try {
                if (sentenciaPreparada != null) sentenciaPreparada.close();
                if (conexion != null && !conexion.isClosed()) conexion.close();
            } catch (SQLException e) {
                System.err.println("Error al cerrar la conexión: " + e.getMessage());
            }
        }
        System.out.println("El valor del nombre en los Metodos SQL es : " + nombre);
        return nombre;
    }

    public int buscarIdUsuario(String usuario) {
        int idUsuario = -1; // Valor por defecto si no se encuentra el usuario
        Connection conexion = null;
        PreparedStatement sentenciaPreparada = null;
        ResultSet resultado = null;
        try {
            conexion = ConexionBD.conectar();
            String consulta = "SELECT id FROM Usuario WHERE usuario_generado = ?";
            sentenciaPreparada = conexion.prepareStatement(consulta);
            sentenciaPreparada.setString(1, usuario);
            resultado = sentenciaPreparada.executeQuery();
            if (resultado.next()) {
                idUsuario = resultado.getInt("id");
            }
        } catch (SQLException e) {
            System.err.println("Error SQL al buscar ID de usuario: " + e.getMessage());
        } finally {
            try {
                if (resultado != null) resultado.close();
                if (sentenciaPreparada != null) sentenciaPreparada.close();
                if (conexion != null && !conexion.isClosed()) conexion.close();
            } catch (SQLException e) {
                System.err.println("Error al cerrar la conexión: " + e.getMessage());
            }
        }
        System.out.println("El ID del usuario " + usuario + " es: " + idUsuario);
        return idUsuario;
    }
}