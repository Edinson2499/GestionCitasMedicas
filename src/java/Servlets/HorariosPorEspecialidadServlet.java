package Servlets;

import SQL.ConexionBD;
import com.google.gson.Gson;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/HorariosPorEspecialidad")
public class HorariosPorEspecialidadServlet extends HttpServlet {
    public static class HorarioDTO {
        public String fecha;
        public String hora_inicio;
        public String hora_fin;
        public HorarioDTO(String fecha, String hora_inicio, String hora_fin) {
            this.fecha = fecha;
            this.hora_inicio = hora_inicio;
            this.hora_fin = hora_fin;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String especialidad = request.getParameter("especialidad");
        List<HorarioDTO> horarios = new ArrayList<>();
        try (Connection conexion = ConexionBD.conectar()) {
            String sql = "SELECT d.fecha, d.hora_inicio, d.hora_fin " +
                         "FROM DisponibilidadEspecialista d " +
                         "JOIN Especialista e ON d.id_especialista = e.id_usuario " +
                         "WHERE e.especialidad = ?";
            try (PreparedStatement ps = conexion.prepareStatement(sql)) {
                ps.setString(1, especialidad);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        horarios.add(new HorarioDTO(
                            rs.getString("fecha"),
                            rs.getString("hora_inicio"),
                            rs.getString("hora_fin")
                        ));
                    }
                }
            }
        } catch (Exception e) {
            // Manejo de errores
        }
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(new Gson().toJson(horarios));
        out.flush();
    }
}