package Servlets;

import SQL.ConexionBD;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/GestionarCitasServlet")
public class GestionarCitasServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idCitaStr = request.getParameter("idCita");
        String accion = request.getParameter("accion");
        if (idCitaStr == null || accion == null) {
            response.sendRedirect("gestionar_citas.jsp");
            return;
        }
        int idCita = Integer.parseInt(idCitaStr);
        String sql = "";
        if ("cancelar".equals(accion)) {
            sql = "UPDATE Cita SET estado = 'cancelada' WHERE id = ?";
        } else if ("realizar".equals(accion)) {
            sql = "UPDATE Cita SET estado = 'realizada' WHERE id = ?";
        }
        try (Connection conn = ConexionBD.conectar();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idCita);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("gestionar_citas.jsp");
    }
}