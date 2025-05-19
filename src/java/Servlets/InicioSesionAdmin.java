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

        if ("admin".equals(usuario) && "12345".equals(contrasena)) {
            HttpSession session = request.getSession();
            session.setAttribute("rol", "administrador");
            session.setAttribute("nombre", "Administrador"); // Puedes personalizar esto
            response.sendRedirect("menu_admin.jsp");
        } else {
            mensajeError = "Credenciales de administrador incorrectas.";
            request.setAttribute("error", mensajeError);
            request.getRequestDispatcher("login_admin.jsp").forward(request, response);
        }
    }
}