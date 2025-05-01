package Servlets;

import SQL.ConexionBD;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
@WebServlet("/VerificarDisponibilidadServlet")
public class VerificarDisponibilidadServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fechaStr = request.getParameter("fecha");
        String horaStr = request.getParameter("hora");
        String especialidadSeleccionada = request.getParameter("especialidad");

        LocalDate fechaCita = LocalDate.parse(fechaStr);
        LocalTime horaCita = LocalTime.parse(horaStr);
        java.sql.Timestamp fechaHoraCita = java.sql.Timestamp.valueOf(fechaCita.atTime(horaCita));

        Connection conexion = null;
        PreparedStatement sentencia = null;
        ResultSet resultado = null;
        List<String> especialistasDisponibles = new ArrayList<>();
        String mensaje = "";

        try {
            conexion = ConexionBD.conectar();
            if (conexion != null) {
                // 1. Obtener todos los especialistas con la especialidad seleccionada
                String sqlEspecialistas = "SELECT u.id, u.nombre, u.apellidos " +
                                           "FROM Usuario u " +
                                           "JOIN Especialista e ON u.id = e.id_usuario " +
                                           "WHERE e.especialidad = ?";
                sentencia = conexion.prepareStatement(sqlEspecialistas);
                sentencia.setString(1, especialidadSeleccionada);
                resultado = sentencia.executeQuery();

                List<Integer> idsEspecialistas = new ArrayList<>();
                List<String> nombresEspecialistas = new ArrayList<>();
                while (resultado.next()) {
                    idsEspecialistas.add(resultado.getInt("id"));
                    nombresEspecialistas.add(resultado.getString("nombre") + " " + resultado.getString("apellidos"));
                }
                resultado.close();
                sentencia.close();

                // 2. Verificar la disponibilidad de cada especialista en la fecha y hora solicitadas
                for (int i = 0; i < idsEspecialistas.size(); i++) {
                    int idEspecialista = idsEspecialistas.get(i);
                    boolean disponible = verificarDisponibilidadEspecialista(conexion, idEspecialista, fechaHoraCita);
                    if (disponible) {
                        especialistasDisponibles.add(nombresEspecialistas.get(i));
                    }
                }

                if (especialistasDisponibles.isEmpty()) {
                    mensaje = "No hay especialistas disponibles para la especialidad, fecha y hora seleccionadas.";
                } else {
                    mensaje = "Especialistas disponibles. Puede seleccionar uno (opcional) y agendar la cita.";
                    request.setAttribute("especialistasDisponibles", especialistasDisponibles);
                }

            } else {
                mensaje = "Error al conectar a la base de datos.";
            }

        } catch (SQLException e) {
            mensaje = "Error al verificar la disponibilidad: " + e.getMessage();
            e.printStackTrace();
        } finally {
            try {
                if (resultado != null) resultado.close();
                if (sentencia != null) sentencia.close();
                if (conexion != null && !conexion.isClosed()) conexion.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("mensaje", mensaje);
        request.getRequestDispatcher("agendar_cita.jsp").forward(request, response);
    }

    private boolean verificarDisponibilidadEspecialista(Connection conexion, int idEspecialista, java.sql.Timestamp fechaHoraCita) throws SQLException {
        PreparedStatement sentenciaCitas = null;
        ResultSet resultadoCitas = null;
        boolean disponible = true;

        try {
            // Consulta para verificar si el especialista tiene una cita existente que se superpone
            String sqlCitas = "SELECT 1 FROM Cita " +
                              "WHERE id_especialista = ? " +
                              "AND fecha_hora = ?"; // Ajusta la lógica de superposición si es necesario (rangos de tiempo)
            sentenciaCitas = conexion.prepareStatement(sqlCitas);
            sentenciaCitas.setInt(1, idEspecialista);
            sentenciaCitas.setTimestamp(2, fechaHoraCita);
            resultadoCitas = sentenciaCitas.executeQuery();

            if (resultadoCitas.next()) {
                disponible = false; // El especialista ya tiene una cita en ese horario
            }

        } finally {
            if (resultadoCitas != null) resultadoCitas.close();
            if (sentenciaCitas != null) sentenciaCitas.close();
        }

        return disponible;
    }
}