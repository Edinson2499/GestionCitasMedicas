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
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
@WebServlet("/AgendarCitaServlet")
public class AgendarCitaServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        // Asumiendo que el ID del paciente está guardado en la sesión
        Integer idPaciente = (Integer) session.getAttribute("idUsuario"); // Ajusta el nombre del atributo según tu lógica de sesión

        String fechaStr = request.getParameter("fecha");
        String horaStr = request.getParameter("hora");
        String especialidad = request.getParameter("especialidad");
        String especialistaSeleccionadoStr = request.getParameter("especialistaSeleccionado");

        LocalDate fechaCita = LocalDate.parse(fechaStr);
        LocalTime horaCita = LocalTime.parse(horaStr);
        java.sql.Timestamp fechaHoraCita = java.sql.Timestamp.valueOf(fechaCita.atTime(horaCita));

        Connection conexion = null;
        PreparedStatement sentencia = null;
        String mensaje = "";

        try {
            conexion = ConexionBD.conectar();
            if (conexion != null) {
                // Obtener el ID del especialista seleccionado (si lo hay)
                Integer idEspecialista = null;
                if (especialistaSeleccionadoStr != null && !especialistaSeleccionadoStr.isEmpty()) {
                    String sqlObtenerIdEspecialista = "SELECT u.id FROM Usuario u JOIN Especialista e ON u.id = e.id_usuario WHERE CONCAT(u.nombre, ' ', u.apellidos) = ? AND e.especialidad = ?";
                    PreparedStatement sentenciaIdEspecialista = conexion.prepareStatement(sqlObtenerIdEspecialista);
                    sentenciaIdEspecialista.setString(1, especialistaSeleccionadoStr);
                    sentenciaIdEspecialista.setString(2, especialidad);
                    java.sql.ResultSet resultadoIdEspecialista = sentenciaIdEspecialista.executeQuery();
                    if (resultadoIdEspecialista.next()) {
                        idEspecialista = resultadoIdEspecialista.getInt("id");
                    }
                    resultadoIdEspecialista.close();
                    sentenciaIdEspecialista.close();
                } else {
                    // Si no se seleccionó un especialista, buscar uno disponible (podrías implementar una lógica más compleja aquí)
                    String sqlBuscarEspecialistaDisponible = "SELECT u.id FROM Usuario u JOIN Especialista e ON u.id = e.id_usuario WHERE e.especialidad = ? LIMIT 1";
                    PreparedStatement sentenciaBuscarEspecialista = conexion.prepareStatement(sqlBuscarEspecialistaDisponible);
                    sentenciaBuscarEspecialista.setString(1, especialidad);
                    java.sql.ResultSet resultadoBuscarEspecialista = sentenciaBuscarEspecialista.executeQuery();
                    if (resultadoBuscarEspecialista.next()) {
                        idEspecialista = resultadoBuscarEspecialista.getInt("id");
                    }
                    resultadoBuscarEspecialista.close();
                    sentenciaBuscarEspecialista.close();
                }

                if (idPaciente != null && idEspecialista != null) {
                    // Insertar la nueva cita
                    String sqlInsertarCita = "INSERT INTO Cita (id_paciente, id_especialista, fecha_hora, estado) VALUES (?, ?, ?, 'pendiente')";
                    sentencia = conexion.prepareStatement(sqlInsertarCita);
                    sentencia.setInt(1, idPaciente);
                    sentencia.setInt(2, idEspecialista);
                    sentencia.setTimestamp(3, fechaHoraCita);
                    int filasAfectadas = sentencia.executeUpdate();
                    if (filasAfectadas > 0) {
                        mensaje = "Cita agendada con éxito.";
                    } else {
                        mensaje = "Error al agendar la cita.";
                    }
                } else {
                    mensaje = "No se pudo encontrar un especialista disponible.";
                }

            } else {
                mensaje = "Error al conectar a la base de datos.";
            }

        } catch (SQLException e) {
            mensaje = "Error al agendar la cita: " + e.getMessage();
            e.printStackTrace();
        } finally {
            try {
                if (sentencia != null) sentencia.close();
                if (conexion != null && !conexion.isClosed()) conexion.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("mensaje", mensaje);
        request.getRequestDispatcher("agendar_cita.jsp").forward(request, response);
    }
}