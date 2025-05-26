/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlets;

import SQL.ConexionBD;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/GuardarEdicionUsuarioServlet")
public class GuardarEdicionUsuarioServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("rol") == null || !"administrador".equals(session.getAttribute("rol"))) {
            response.sendRedirect("login_admin.jsp");
            return;
        }

        String idUsuario = request.getParameter("id");
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String tipoUsuario = request.getParameter("tipo_usuario");
        String especialidad = request.getParameter("especialidad");
        String nuevaContrasena = request.getParameter("contrasena");
        String telefono = request.getParameter("telefono");
        String direccion = request.getParameter("direccion");
        String correo = request.getParameter("correo");
        String numeroTarjeta = request.getParameter("numero_tarjeta_profesional");
        int id = Integer.parseInt(idUsuario);

        Connection conexion = null;
        PreparedStatement sentencia = null;
        String mensaje = null;

        try {
            conexion = ConexionBD.conectar();
            if (conexion != null) {
                // Si la contraseña está vacía, no la actualices
                String consulta;
                if (nuevaContrasena != null && !nuevaContrasena.trim().isEmpty()) {
                    String hash = org.mindrot.jbcrypt.BCrypt.hashpw(nuevaContrasena, org.mindrot.jbcrypt.BCrypt.gensalt());
                    consulta = "UPDATE Usuario SET nombre = ?, apellidos = ?, tipo_usuario = ?, contrasena = ?, telefono = ?, direccion = ?, correo = ? WHERE id = ?";
                    sentencia = conexion.prepareStatement(consulta);
                    sentencia.setString(1, nombre);
                    sentencia.setString(2, apellido);
                    sentencia.setString(3, tipoUsuario);
                    sentencia.setString(4, hash);
                    sentencia.setString(5, telefono);
                    sentencia.setString(6, direccion);
                    sentencia.setString(7, correo);
                    sentencia.setInt(8, id);
                } else {
                    consulta = "UPDATE Usuario SET nombre = ?, apellidos = ?, tipo_usuario = ?, telefono = ?, direccion = ?, correo = ? WHERE id = ?";
                    sentencia = conexion.prepareStatement(consulta);
                    sentencia.setString(1, nombre);
                    sentencia.setString(2, apellido);
                    sentencia.setString(3, tipoUsuario);
                    sentencia.setString(4, telefono);
                    sentencia.setString(5, direccion);
                    sentencia.setString(6, correo);
                    sentencia.setInt(7, id);
                }
                int filasAfectadas = sentencia.executeUpdate();
                if (filasAfectadas > 0) {
                    mensaje = "Usuario actualizado con éxito.";
                } else {
                    mensaje = "No se pudo actualizar el usuario.";
                }

                // Manejo de especialidad
                if ("especialista".equals(tipoUsuario)) {
                    PreparedStatement psEsp = conexion.prepareStatement(
                        "INSERT INTO Especialista (id_usuario, especialidad, numero_tarjeta_profesional) VALUES (?, ?, ?) " +
                        "ON DUPLICATE KEY UPDATE especialidad = VALUES(especialidad), numero_tarjeta_profesional = VALUES(numero_tarjeta_profesional)"
                    );
                    psEsp.setInt(1, id);
                    psEsp.setString(2, especialidad);
                    psEsp.setString(3, numeroTarjeta);
                    psEsp.executeUpdate();
                    psEsp.close();
                } else {
                    PreparedStatement psDel = conexion.prepareStatement(
                        "DELETE FROM Especialista WHERE id_usuario = ?"
                    );
                    psDel.setInt(1, id);
                    psDel.executeUpdate();
                    psDel.close();
                }
            } else {
                mensaje = "Error al conectar a la base de datos.";
            }
        } catch (SQLException e) {
            mensaje = "Error al actualizar el usuario: " + e.getMessage();
            e.printStackTrace();
        } finally {
            try { if (sentencia != null) sentencia.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conexion != null && !conexion.isClosed()) conexion.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        request.setAttribute("mensaje", mensaje);
        response.sendRedirect("consultar_usuarios.jsp");
    }
}