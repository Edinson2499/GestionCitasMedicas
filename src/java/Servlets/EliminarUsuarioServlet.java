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

@WebServlet("/EliminarUsuarioServlet")
public class EliminarUsuarioServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("rol") == null || !"administrador".equals(session.getAttribute("rol"))) {
            response.sendRedirect("login_admin.jsp");
            return;
        }

        String idUsuarioStr = request.getParameter("id");
        if (idUsuarioStr == null || idUsuarioStr.isEmpty()) {
            response.sendRedirect("consultar_usuarios.jsp");
            return;
        }

        int idUsuario = -1;
        try {
            idUsuario = Integer.parseInt(idUsuarioStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID de usuario inválido.");
            request.getRequestDispatcher("consultar_usuarios.jsp").forward(request, response);
            return;
        }

        Connection conexion = null;
        PreparedStatement sentencia = null;
        String mensaje = null;

        try {
            conexion = ConexionBD.conectar();
            if (conexion != null) {
                // Primero, desactivar las restricciones de clave foránea temporalmente
                try (PreparedStatement desactivarFK = conexion.prepareStatement("SET FOREIGN_KEY_CHECKS=0")) {
                    desactivarFK.executeUpdate();
                }

                String consulta = "DELETE FROM Usuario WHERE id = ?";
                sentencia = conexion.prepareStatement(consulta);
                sentencia.setInt(1, idUsuario);
                int filasAfectadas = sentencia.executeUpdate();

                // Luego, reactivar las restricciones de clave foránea
                try (PreparedStatement activarFK = conexion.prepareStatement("SET FOREIGN_KEY_CHECKS=1")) {
                    activarFK.executeUpdate();
                }

                if (filasAfectadas > 0) {
                    mensaje = "Usuario eliminado con éxito.";
                } else {
                    mensaje = "No se encontró el usuario con ID: " + idUsuario;
                }
            } else {
                mensaje = "Error al conectar a la base de datos.";
            }
        } catch (SQLException e) {
            mensaje = "Error al eliminar el usuario: " + e.getMessage();
            e.printStackTrace();
        } finally {
            try { if (sentencia != null) sentencia.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conexion != null && !conexion.isClosed()) conexion.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        request.setAttribute("mensaje", mensaje);
        response.sendRedirect("consultar_usuarios.jsp");
    }

   
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}