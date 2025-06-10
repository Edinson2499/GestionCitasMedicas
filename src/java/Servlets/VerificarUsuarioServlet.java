package Servlets;

import SQL.ConexionBD;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.*;
import java.sql.*;

@WebServlet("/VerificarUsuarioServlet")
public class VerificarUsuarioServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String usuario = request.getParameter("usuario");
        boolean existe = false;

        try (Connection conn = ConexionBD.conectar();
             PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM Usuario WHERE usuario_generado = ?")) {

            ps.setString(1, usuario);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                existe = rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            // Aquí podrías loguear el error si deseas
            existe = false;
        }

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(String.valueOf(existe));
    }
}
