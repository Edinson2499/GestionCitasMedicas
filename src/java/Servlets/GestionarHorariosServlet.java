package Servlets;

import SQL.ConexionBD;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/GestionarHorariosServlet")
public class GestionarHorariosServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");
        String mensaje = "";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = ConexionBD.conectar();
            if ("agregar".equals(accion)) {
                int idEspecialista = Integer.parseInt(request.getParameter("idEspecialista"));
                String fecha = request.getParameter("fecha");
                String horaInicio = request.getParameter("hora_inicio");
                String horaFin = request.getParameter("hora_fin");
                String sql = "INSERT INTO DisponibilidadEspecialista (id_especialista, fecha, hora_inicio, hora_fin) VALUES (?, ?, ?, ?)";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, idEspecialista);
                ps.setString(2, fecha);
                ps.setString(3, horaInicio);
                ps.setString(4, horaFin);
                ps.executeUpdate();
                mensaje = "Horario agregado correctamente.";
            } else if ("eliminar".equals(accion)) {
                int idHorario = Integer.parseInt(request.getParameter("idHorario"));
                String sql = "DELETE FROM DisponibilidadEspecialista WHERE id = ?";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, idHorario);
                ps.executeUpdate();
                mensaje = "Horario eliminado correctamente.";
            }
        } catch (Exception e) {
            mensaje = "Error: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        request.setAttribute("mensaje", mensaje);
        request.getRequestDispatcher("gestionar_horarios.jsp").forward(request, response);
    }
}