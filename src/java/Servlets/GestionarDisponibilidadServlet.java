package Servlets;

import SQL.ConexionBD;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/GestionarDisponibilidadServlet")
public class GestionarDisponibilidadServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idDisponibilidadStr = request.getParameter("idDisponibilidad");
        if (idDisponibilidadStr != null && !idDisponibilidadStr.isEmpty()) {
            int idDisponibilidad = Integer.parseInt(idDisponibilidadStr);
            try (Connection conn = ConexionBD.conectar();
                 PreparedStatement ps = conn.prepareStatement("DELETE FROM DisponibilidadEspecialista WHERE id = ?")) {
                ps.setInt(1, idDisponibilidad);
                ps.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("gestionar_disponibilidad.jsp");
    }
}