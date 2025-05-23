package Servlets;

import SQL.ConexionBD;
import Utils.EmailSender;
import Utils.SMSSender;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/AgendarCitaServlet")
public class AgendarCitaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer idPaciente = (Integer) session.getAttribute("idUsuario");

        String fechaStr = request.getParameter("fecha");
        String horaStr = request.getParameter("hora");
        String especialidad = request.getParameter("especialidad");
        String especialistaSeleccionadoStr = request.getParameter("especialistaSeleccionado");

        LocalDate fechaCita = LocalDate.parse(fechaStr);
        LocalTime horaCita = LocalTime.parse(horaStr);
        java.sql.Timestamp fechaHoraCita = java.sql.Timestamp.valueOf(fechaCita.atTime(horaCita));

        Connection conexion = null;
        PreparedStatement sentenciaInsertar = null;
        PreparedStatement sentenciaObtenerContacto = null;
        PreparedStatement sentenciaObtenerInfoCita = null;
        ResultSet resultadoContacto = null;
        ResultSet resultadoInfoCita = null;
        String mensaje = "";
        int idCitaGenerada = -1;

        try {
            conexion = ConexionBD.conectar();
            if (conexion != null) {
                Integer idEspecialista = null;
                // Obtener el ID del especialista seleccionado
                if (especialistaSeleccionadoStr != null && !especialistaSeleccionadoStr.isEmpty()) {
                    String sqlObtenerIdEspecialista = "SELECT u.id FROM Usuario u " +
                        "JOIN Especialista e ON u.id = e.id_usuario " +
                        "JOIN DisponibilidadEspecialista d ON u.id = d.id_especialista " +
                        "WHERE CONCAT(u.nombre, ' ', u.apellidos) = ? " +
                        "AND e.especialidad = ? " +
                        "AND d.fecha = ? " +
                        "AND d.hora_inicio <= ? " +
                        "AND d.hora_fin >= ? " +
                        "LIMIT 1";
                    try (PreparedStatement sentenciaIdEspecialista = conexion.prepareStatement(sqlObtenerIdEspecialista)) {
                        sentenciaIdEspecialista.setString(1, especialistaSeleccionadoStr);
                        sentenciaIdEspecialista.setString(2, especialidad);
                        sentenciaIdEspecialista.setDate(3, java.sql.Date.valueOf(fechaCita));
                        sentenciaIdEspecialista.setTime(4, java.sql.Time.valueOf(horaCita));
                        sentenciaIdEspecialista.setTime(5, java.sql.Time.valueOf(horaCita));
                        try (ResultSet resultadoIdEspecialista = sentenciaIdEspecialista.executeQuery()) {
                            if (resultadoIdEspecialista.next()) {
                                idEspecialista = resultadoIdEspecialista.getInt("id");
                            }
                        }
                    }
                } else {
                    String sqlBuscarEspecialistaDisponible = "SELECT u.id FROM Usuario u " +
    "JOIN Especialista e ON u.id = e.id_usuario " +
    "JOIN DisponibilidadEspecialista d ON u.id = d.id_especialista " +
    "WHERE e.especialidad = ? AND d.fecha = ? AND d.hora_inicio <= ? AND d.hora_fin >= ? LIMIT 1";
                    try (PreparedStatement sentenciaBuscarEspecialista = conexion.prepareStatement(sqlBuscarEspecialistaDisponible)) {
                        sentenciaBuscarEspecialista.setString(1, especialidad);
                        sentenciaBuscarEspecialista.setDate(2, java.sql.Date.valueOf(fechaCita));
                        sentenciaBuscarEspecialista.setTime(3, java.sql.Time.valueOf(horaCita));
                        sentenciaBuscarEspecialista.setTime(4, java.sql.Time.valueOf(horaCita));
                        try (ResultSet resultadoBuscarEspecialista = sentenciaBuscarEspecialista.executeQuery()) {
                            if (resultadoBuscarEspecialista.next()) {
                                idEspecialista = resultadoBuscarEspecialista.getInt("id");
                            }
                        }
                    }
                }

                if (idPaciente != null && idEspecialista != null) {
                    // Insertar la nueva cita
                    String sqlInsertarCita = "INSERT INTO Cita (id_paciente, id_especialista, fecha_hora, estado) VALUES (?, ?, ?, 'pendiente')";
                    sentenciaInsertar = conexion.prepareStatement(sqlInsertarCita, PreparedStatement.RETURN_GENERATED_KEYS);
                    sentenciaInsertar.setInt(1, idPaciente);
                    sentenciaInsertar.setInt(2, idEspecialista);
                    sentenciaInsertar.setTimestamp(3, fechaHoraCita);
                    int filasAfectadas = sentenciaInsertar.executeUpdate();

                    if (filasAfectadas > 0) {
                        mensaje = "Cita agendada con éxito.";
                        // Obtener el ID de la cita recién insertada
                        try (ResultSet generatedKeys = sentenciaInsertar.getGeneratedKeys()) {
                            if (generatedKeys.next()) {
                                idCitaGenerada = generatedKeys.getInt(1);

                                // Obtener email y teléfono del paciente
                                String sqlObtenerContacto = "SELECT u.correo AS email, u.telefono AS telefono1, u.nombre AS nombre_paciente FROM Usuario u WHERE u.id = ? AND u.tipo_usuario = 'paciente'";
                                sentenciaObtenerContacto = conexion.prepareStatement(sqlObtenerContacto);
                                sentenciaObtenerContacto.setInt(1, idPaciente);
                                resultadoContacto = sentenciaObtenerContacto.executeQuery();

                                if (resultadoContacto.next()) {
                                    String emailPaciente = resultadoContacto.getString("email");
                                    String telefonoPaciente = resultadoContacto.getString("telefono1");
                                    String nombrePaciente = resultadoContacto.getString("nombre_paciente");

                                    // Obtener información de la cita para el mensaje
                                    String sqlObtenerInfo = "SELECT es_u.nombre AS nombre_especialista, esp.especialidad FROM Cita c " +
                                            "JOIN Usuario es_u ON c.id_especialista = es_u.id " +
                                            "JOIN Especialista esp ON es_u.id = esp.id_usuario " +
                                            "WHERE c.id = ?";
                                    sentenciaObtenerInfoCita = conexion.prepareStatement(sqlObtenerInfo);
                                    sentenciaObtenerInfoCita.setInt(1, idCitaGenerada);
                                    resultadoInfoCita = sentenciaObtenerInfoCita.executeQuery();

                                    if (resultadoInfoCita.next()) {
                                        String nombreEspecialista = resultadoInfoCita.getString("nombre_especialista");
                                        String especialidadCita = resultadoInfoCita.getString("especialidad");

                                        // Enviar correo de confirmación
                                        String asuntoEmail = "Confirmación de Cita Médica";
                                        String contenidoEmail = "Hola " + nombrePaciente + ",\n\n" +
                                                "Tu cita ha sido agendada exitosamente para el día " + fechaCita + " a las " + horaCita +
                                                " con el especialista " + nombreEspecialista + " de la especialidad de " + especialidadCita + ".\n\n" +
                                                "¡Gracias por usar nuestro servicio!";
                                        EmailSender.enviarEmail(emailPaciente, asuntoEmail, contenidoEmail);
                                        mensaje += " Se ha enviado un correo a " + emailPaciente + ".";

                                        // Enviar SMS de confirmación
                                        String mensajeSMS = "Cita agendada: " + fechaCita + " " + horaCita + " con " + nombreEspecialista + " (" + especialidadCita + ").";
                                        if (telefonoPaciente != null && !telefonoPaciente.isEmpty()) {
                                            SMSSender.enviarSMS(telefonoPaciente, mensajeSMS);
                                            mensaje += " Se ha enviado un SMS al " + telefonoPaciente + ".";
                                        } else {
                                            mensaje += " (No se pudo enviar SMS, teléfono no registrado).";
                                        }
                                    } else {
                                        mensaje += " (No se pudo obtener info del especialista para el mensaje).";
                                    }
                                } else {
                                    mensaje += " (No se pudo obtener contacto del paciente).";
                                }
                            } else {
                                mensaje += " (No se pudo obtener ID de cita para confirmación).";
                            }
                        }
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
            Logger.getLogger(AgendarCitaServlet.class.getName()).log(Level.SEVERE, null, e);
        } finally {
            try { if (resultadoContacto != null) resultadoContacto.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (resultadoInfoCita != null) resultadoInfoCita.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (sentenciaObtenerContacto != null) sentenciaObtenerContacto.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (sentenciaObtenerInfoCita != null) sentenciaObtenerInfoCita.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (sentenciaInsertar != null) sentenciaInsertar.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conexion != null && !conexion.isClosed()) conexion.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        request.setAttribute("mensaje", mensaje);
        request.getRequestDispatcher("agendar_cita.jsp").forward(request, response);
    }
}