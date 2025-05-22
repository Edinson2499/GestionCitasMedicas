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

@WebServlet("/GuardarEdicionUsuarioServlet")
public class GuardarEdicionUsuarioServlet extends HttpServlet {

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
        int id = Integer.parseInt(request.getParameter("id"));

        Connection conexion = null;
        PreparedStatement sentencia = null;
        String mensaje = null;

        try {
            conexion = ConexionBD.conectar();
            if (conexion != null) {
                String consulta = "UPDATE Usuario SET nombre = ?, apellidos = ? WHERE id = ?";
                sentencia = conexion.prepareStatement(consulta);
                sentencia.setString(1, nombre);
                sentencia.setString(2, apellido);
                sentencia.setInt(3, Integer.parseInt(idUsuario));
                int filasAfectadas = sentencia.executeUpdate();
                if (filasAfectadas > 0) {
                    mensaje = "Usuario actualizado con éxito.";
                } else {
                    mensaje = "No se pudo actualizar el usuario.";
                }

                // Actualiza especialidad solo si es especialista
                if ("especialista".equals(tipoUsuario)) {
                    // Si ya existe, actualiza; si no, inserta
                    PreparedStatement psEsp = conexion.prepareStatement(
                        "INSERT INTO Especialista (id_usuario, especialidad) VALUES (?, ?) " +
                        "ON DUPLICATE KEY UPDATE especialidad = ?"
                    );
                    psEsp.setInt(1, id);
                    psEsp.setString(2, especialidad);
                    psEsp.setString(3, especialidad);
                    psEsp.executeUpdate();
                    psEsp.close();
                } else {
                    // Si cambió a otro tipo, elimina la especialidad si existe
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