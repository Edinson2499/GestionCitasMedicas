package Servlets;

import SQL.ConexionBD;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BuscarPacienteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nombrePaciente = request.getParameter("nombre_paciente");
        List<Map<String, Object>> pacientes = new ArrayList<>();

        try (Connection conexion = ConexionBD.conectar()) {
            if (conexion != null && nombrePaciente != null && !nombrePaciente.trim().isEmpty()) {
                String sql = "SELECT id, nombre, apellidos FROM Usuario WHERE tipo_usuario = 'paciente' AND (nombre LIKE ? OR apellidos LIKE ?)";
                try (PreparedStatement ps = conexion.prepareStatement(sql)) {
                    ps.setString(1, "%" + nombrePaciente + "%");
                    ps.setString(2, "%" + nombrePaciente + "%");
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            Map<String, Object> paciente = new HashMap<>();
                            paciente.put("id", rs.getInt("id"));
                            paciente.put("nombre", rs.getString("nombre"));
                            paciente.put("apellidos", rs.getString("apellidos"));
                            pacientes.add(paciente);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("pacientes", pacientes);
        request.getRequestDispatcher("historial_pacientes.jsp").forward(request, response);
    }
}