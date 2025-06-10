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

@WebServlet("/CancelarCitaServlet")
public class CancelarCitaServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer idPaciente = (Integer) session.getAttribute("idUsuario");
        String idCitaStr = request.getParameter("idCita");
        String mensaje;

        if (idPaciente == null || idCitaStr == null || idCitaStr.isEmpty()) {
            mensaje = "Datos inválidos para cancelar la cita.";
        } else {
            Connection conn = null;
            PreparedStatement ps = null;
            try {
                conn = ConexionBD.conectar();
                String sql = "UPDATE Cita SET estado = 'cancelada' WHERE id = ? AND id_paciente = ?";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(idCitaStr));
                ps.setInt(2, idPaciente);
                int filas = ps.executeUpdate();
                if (filas > 0) {
                    mensaje = "Cita cancelada correctamente.";
                } else {
                    mensaje = "No se pudo cancelar la cita.";
                }
            } catch (Exception e) {
                mensaje = "Error al cancelar la cita: " + e.getMessage();
            } finally {
                try { if (ps != null) ps.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        }
        request.setAttribute("mensaje", mensaje);
        request.getRequestDispatcher("cancelar_cita.jsp").forward(request, response);
    }
}