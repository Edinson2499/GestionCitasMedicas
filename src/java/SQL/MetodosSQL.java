package SQL;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import org.mindrot.jbcrypt.BCrypt;

public class MetodosSQL {

    private Connection conexion;
    private PreparedStatement sentenciaPreparada;

    public boolean registrarUsuario(String id, String nombre, String apellido, String telefono, String direccion, String correo, String contrasena,
                                    String usuarioGeneradoAutomaticamente, String rol,
                                    String especialidad, String numeroTarjetaProfesional) {
        boolean registroExitoso = false;
        Connection conexion = null;
        PreparedStatement sentenciaPreparada = null;

        try {
            conexion = ConexionBD.conectar();
            if (conexion == null) {
                System.err.println("Error: No se pudo establecer la conexión a la base de datos.");
                return false;
            }

            // Hashear la contraseña antes de guardar
            String hash = BCrypt.hashpw(contrasena, BCrypt.gensalt());

            // 1. Insertar datos en la tabla Usuario (ahora con correo)
            String consultaUsuario = "INSERT INTO Usuario (nombre, apellidos, telefono, direccion, correo, contrasena, usuario_generado, tipo_usuario) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            sentenciaPreparada = conexion.prepareStatement(consultaUsuario, PreparedStatement.RETURN_GENERATED_KEYS);
            sentenciaPreparada.setString(1, nombre);
            sentenciaPreparada.setString(2, apellido);
            sentenciaPreparada.setString(3, telefono);
            sentenciaPreparada.setString(4, direccion);
            sentenciaPreparada.setString(5, correo);
            sentenciaPreparada.setString(6, hash); // Guardar el hash en el campo 'contrasena'
            sentenciaPreparada.setString(7, usuarioGeneradoAutomaticamente);
            sentenciaPreparada.setString(8, rol);

            int filasAfectadasUsuario = sentenciaPreparada.executeUpdate();

            if (filasAfectadasUsuario > 0) {
                System.out.println("Usuario registrado en la tabla Usuario.");
                registroExitoso = true;

                // Obtener el ID generado para el usuario recién insertado
                int idUsuario = -1;
                try (ResultSet generatedKeys = sentenciaPreparada.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        idUsuario = generatedKeys.getInt(1);
                    } else {
                        System.err.println("Error: No se pudo obtener el ID del usuario insertado.");
                        registroExitoso = false;
                    }
                }

                if (registroExitoso && idUsuario != -1) {
                    // 2. Insertar datos en la tabla Especialista si corresponde
                    if ("especialista".equals(rol)) {
                        String consultaEspecialista = "INSERT INTO Especialista (id_usuario, especialidad, numero_tarjeta_profesional) VALUES (?, ?, ?)";
                        try (PreparedStatement psEspecialista = conexion.prepareStatement(consultaEspecialista)) {
                            psEspecialista.setInt(1, idUsuario);
                            psEspecialista.setString(2, especialidad);
                            psEspecialista.setString(3, numeroTarjetaProfesional);

                            int filasAfectadasEspecialista = psEspecialista.executeUpdate();
                            if (filasAfectadasEspecialista > 0) {
                                System.out.println("Datos de especialista registrados.");
                            } else {
                                System.err.println("Error al registrar datos de especialista.");
                                registroExitoso = false;
                            }
                        }
                    } else if ("paciente".equals(rol)) {
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
        System.out.println("El valor del usuario Repzetido en el METODO es: " + usuarioRepetido);
        return usuarioRepetido;
    }

    public String buscarUsuarioInicioSesion(String usuario, String contrasena) {
        String rol = null;
        try {
            conexion = ConexionBD.conectar();
            String consulta = "SELECT contrasena, tipo_usuario FROM Usuario WHERE usuario_generado = ?";
            sentenciaPreparada = conexion.prepareStatement(consulta);
            sentenciaPreparada.setString(1, usuario);
            try (ResultSet resultado = sentenciaPreparada.executeQuery()) {
                if (resultado.next()) {
                    String hashAlmacenado = resultado.getString("contrasena");
                    if (BCrypt.checkpw(contrasena, hashAlmacenado)) {
                        rol = resultado.getString("tipo_usuario");
                    }
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
        return rol;
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