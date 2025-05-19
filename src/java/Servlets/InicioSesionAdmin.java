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
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/InicioSesionAdmin")
public class InicioSesionAdmin extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String usuario = request.getParameter("txtUsuario");
        String contrasena = request.getParameter("txtContrasena");
        String mensajeError = null;

        Connection conexion = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conexion = ConexionBD.conectar();
            String sql = "SELECT nombre, tipo_usuario FROM Usuario WHERE usuario_generado = ? AND contrasena = ?";
            ps = conexion.prepareStatement(sql);
            ps.setString(1, usuario);
            ps.setString(2, contrasena);
            rs = ps.executeQuery();

            if (rs.next()) {
                String tipoUsuario = rs.getString("tipo_usuario");
                String nombre = rs.getString("nombre");
                if ("administrador".equalsIgnoreCase(tipoUsuario)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("rol", tipoUsuario);
                    session.setAttribute("nombre", nombre);
                    session.setAttribute("usuario_generado", usuario);
                    response.sendRedirect("menu_admin.jsp");
                    return;
                } else {
                    mensajeError = "El usuario no tiene permisos de administrador.";
                }
            } else {
                mensajeError = "Credenciales incorrectas.";
            }
        } catch (SQLException e) {
            mensajeError = "Error al conectar con la base de datos.";
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conexion != null) conexion.close(); } catch (SQLException e) {}
        }

        request.setAttribute("error", mensajeError);
        request.getRequestDispatcher("login_admin.jsp").forward(request, response);
    }
}