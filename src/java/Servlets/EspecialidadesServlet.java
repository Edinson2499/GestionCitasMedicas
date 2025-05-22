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

@WebServlet("/Especialidades")
public class EspecialidadesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<String> especialidades = new ArrayList<>();
        try (Connection conexion = ConexionBD.conectar()) {
            String sql = "SELECT DISTINCT especialidad FROM Especialista WHERE especialidad IS NOT NULL AND especialidad <> ''";
            try (PreparedStatement ps = conexion.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    especialidades.add(rs.getString("especialidad"));
                }
            }
        } catch (Exception e) {
            // Manejo de errores
        }
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(new Gson().toJson(especialidades));
        out.flush();
    }
}