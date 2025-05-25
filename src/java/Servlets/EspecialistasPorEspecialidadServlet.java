package Servlets;

import SQL.ConexionBD;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/EspecialistasPorEspecialidad")
public class EspecialistasPorEspecialidadServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String especialidad = request.getParameter("especialidad");
        List<EspecialistaDTO> especialistas = new ArrayList<>();

        try (Connection conexion = ConexionBD.conectar()) {
            String sql = "SELECT u.id, CONCAT(u.nombre, ' ', u.apellidos) AS nombreCompleto FROM Usuario u " +
                         "JOIN Especialista e ON u.id = e.id_usuario " +
                         "WHERE e.especialidad = ?";
            try (PreparedStatement ps = conexion.prepareStatement(sql)) {
                ps.setString(1, especialidad);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        especialistas.add(new EspecialistaDTO(rs.getInt("id"), rs.getString("nombreCompleto")));
                    }
                }
            }
        } catch (Exception e) {
            // Manejo de errores
        }

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(new Gson().toJson(especialistas));
        out.flush();
    }

    // DTO interno
    public static class EspecialistaDTO {
        public int id;
        public String nombre;
        public EspecialistaDTO(int id, String nombre) {
            this.id = id;
            this.nombre = nombre;
        }
    }
}