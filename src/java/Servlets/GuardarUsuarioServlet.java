package Servlets;

import SQL.ConexionBD;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/GuardarUsuarioServlet")
public class GuardarUsuarioServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nombre = request.getParameter("nombre");
        String apellidos = request.getParameter("apellidos");
        String telefono = request.getParameter("telefono");
        String direccion = request.getParameter("direccion");
        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");
        String tipoUsuario = request.getParameter("tipo_usuario");
        String especialidad = request.getParameter("txtEspecialidad");
        String tarjeta = request.getParameter("tarjeta");
        String mensaje = "";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = ConexionBD.conectar();
            // Insertar en Usuario
            String usuarioGenerado = request.getParameter("usuario_generado"); // Asegúrate de que el formulario lo envía

            String sql = "INSERT INTO Usuario (nombre, apellidos, telefono, direccion, correo, contrasena, usuario_generado, tipo_usuario) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, nombre);
            ps.setString(2, apellidos);
            ps.setString(3, telefono);
            ps.setString(4, direccion);
            ps.setString(5, correo);
            ps.setString(6, contrasena);
            ps.setString(7, usuarioGenerado);
            ps.setString(8, tipoUsuario);
            int filas = ps.executeUpdate();
            int idUsuario = -1;
            if (filas > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    idUsuario = rs.getInt(1);
                }
                // Si es especialista, insertar en tabla Especialista
                if ("especialista".equals(tipoUsuario) && idUsuario != -1) {
                    String sqlEsp = "INSERT INTO Especialista (id_usuario, especialidad, numero_tarjeta_profesional) VALUES (?, ?, ?)";
                    try (PreparedStatement psEsp = conn.prepareStatement(sqlEsp)) {
                        psEsp.setInt(1, idUsuario);
                        psEsp.setString(2, especialidad);
                        psEsp.setString(3, tarjeta);
                        psEsp.executeUpdate();
                    }
                }
                mensaje = "Usuario registrado correctamente.";
            } else {
                mensaje = "No se pudo registrar el usuario.";
            }
        } catch (Exception e) {
            mensaje = "Error al registrar usuario: " + e.getMessage();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        request.setAttribute("mensaje", mensaje);
        request.getRequestDispatcher("registrar_usuario.jsp").forward(request, response);
    }
}