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
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/AgendarCitaServlet")
public class AgendarCitaServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AgendarCitaServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mensaje = "";
        HttpSession session = request.getSession();
        Integer idPaciente = (Integer) session.getAttribute("idUsuario");

        String fechaStr = request.getParameter("fecha");
        String horaStr = request.getParameter("hora");
        String especialidad = request.getParameter("especialidad");
        String especialistaSeleccionadoStr = request.getParameter("especialistaSeleccionado");
        String motivo = request.getParameter("motivo");

        if (idPaciente == null) {
            mensaje = "Debe iniciar sesión para agendar una cita.";
            forwardMensaje(request, response, mensaje);
            return;
        }

        if (fechaStr == null || fechaStr.isEmpty() ||
            horaStr == null || horaStr.isEmpty() ||
            especialidad == null || especialidad.isEmpty()) {
            mensaje = "Fecha, hora y especialidad son campos obligatorios.";
            forwardMensaje(request, response, mensaje);
            return;
        }

        LocalDate fechaCita;
        LocalTime horaCita;
        try {
            fechaCita = LocalDate.parse(fechaStr);
            horaCita = LocalTime.parse(horaStr);
        } catch (Exception e) {
            mensaje = "Formato de fecha u hora inválido.";
            forwardMensaje(request, response, mensaje);
            return;
        }

        Timestamp fechaHoraCita = Timestamp.valueOf(fechaCita.atTime(horaCita));

        try (Connection conexion = ConexionBD.conectar()) {
            if (conexion == null) {
                mensaje = "No se pudo conectar a la base de datos.";
                forwardMensaje(request, response, mensaje);
                return;
            }

            Integer idEspecialista = obtenerIdEspecialista(conexion, especialistaSeleccionadoStr, especialidad, fechaCita, horaCita);

            if (idEspecialista == null) {
                mensaje = "No se encontró especialista disponible para esa fecha, hora y especialidad.";
                forwardMensaje(request, response, mensaje);
                return;
            }

            // Insertar cita
            int idCitaGenerada = insertarCita(conexion, idPaciente, idEspecialista, fechaHoraCita, motivo);
            if (idCitaGenerada == -1) {
                mensaje = "Error al agendar la cita.";
                forwardMensaje(request, response, mensaje);
                return;
            }

            // Obtener datos para notificaciones
            DatosPaciente datosPaciente = obtenerDatosPaciente(conexion, idPaciente);
            DatosEspecialista datosEspecialista = obtenerDatosEspecialista(conexion, idEspecialista);

            if (datosPaciente == null || datosEspecialista == null) {
                mensaje = "Cita agendada, pero no se pudo obtener información para notificaciones.";
                forwardMensaje(request, response, mensaje);
                return;
            }

            // Enviar notificaciones
            enviarNotificaciones(datosPaciente, datosEspecialista, fechaCita, horaCita);
            mensaje = "Cita agendada exitosamente. Se enviaron las notificaciones correspondientes.";

        } catch (SQLException e) {
            mensaje = "Error al agendar la cita: " + e.getMessage();
            LOGGER.log(Level.SEVERE, null, e);
        }

        forwardMensaje(request, response, mensaje);
    }

    private Integer obtenerIdEspecialista(Connection conexion, String especialistaSeleccionadoStr, String especialidad, LocalDate fechaCita, LocalTime horaCita) throws SQLException {
        String sql;
        PreparedStatement ps;

        if (especialistaSeleccionadoStr != null && !especialistaSeleccionadoStr.trim().isEmpty()) {
            sql = "SELECT u.id FROM Usuario u " +
                  "JOIN Especialista e ON u.id = e.id_usuario " +
                  "JOIN DisponibilidadEspecialista d ON u.id = d.id_especialista " +
                  "WHERE CONCAT(u.nombre, ' ', u.apellidos) = ? " +
                  "AND e.especialidad = ? " +
                  "AND d.fecha = ? " +
                  "AND d.hora_inicio <= ? " +
                  "AND d.hora_fin >= ? " +
                  "LIMIT 1";
            ps = conexion.prepareStatement(sql);
            ps.setString(1, especialistaSeleccionadoStr);
            ps.setString(2, especialidad);
            ps.setDate(3, Date.valueOf(fechaCita));
            ps.setTime(4, Time.valueOf(horaCita));
            ps.setTime(5, Time.valueOf(horaCita));
        } else {
            sql = "SELECT u.id FROM Usuario u " +
                  "JOIN Especialista e ON u.id = e.id_usuario " +
                  "JOIN DisponibilidadEspecialista d ON u.id = d.id_especialista " +
                  "WHERE e.especialidad = ? " +
                  "AND d.fecha = ? " +
                  "AND d.hora_inicio <= ? " +
                  "AND d.hora_fin >= ? " +
                  "LIMIT 1";
            ps = conexion.prepareStatement(sql);
            ps.setString(1, especialidad);
            ps.setDate(2, Date.valueOf(fechaCita));
            ps.setTime(3, Time.valueOf(horaCita));
            ps.setTime(4, Time.valueOf(horaCita));
        }

        try (ps) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        }
        return null;
    }

    private int insertarCita(Connection conexion, int idPaciente, int idEspecialista, Timestamp fechaHora, String motivo) throws SQLException {
        String sqlInsertar = "INSERT INTO Cita (id_paciente, id_especialista, fecha_hora, motivo, estado) VALUES (?, ?, ?, ?, 'pendiente')";
        try (PreparedStatement ps = conexion.prepareStatement(sqlInsertar, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, idPaciente);
            ps.setInt(2, idEspecialista);
            ps.setTimestamp(3, fechaHora);
            ps.setString(4, motivo);
            int filas = ps.executeUpdate();
            if (filas > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        return keys.getInt(1);
                    }
                }
            }
        }
        return -1;
    }

    private DatosPaciente obtenerDatosPaciente(Connection conexion, int idPaciente) throws SQLException {
        String sql = "SELECT correo, telefono, nombre FROM Usuario WHERE id = ? AND tipo_usuario = 'paciente'";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setInt(1, idPaciente);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new DatosPaciente(
                            rs.getString("correo"),
                            rs.getString("telefono"),
                            rs.getString("nombre")
                    );
                }
            }
        }
        return null;
    }

    private DatosEspecialista obtenerDatosEspecialista(Connection conexion, int idEspecialista) throws SQLException {
        String sql = "SELECT u.nombre, u.apellidos, e.especialidad FROM Usuario u " +
                     "JOIN Especialista e ON u.id = e.id_usuario WHERE u.id = ?";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setInt(1, idEspecialista);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new DatosEspecialista(
                            rs.getString("nombre") + " " + rs.getString("apellidos"),
                            rs.getString("especialidad")
                    );
                }
            }
        }
        return null;
    }

    private void enviarNotificaciones(DatosPaciente paciente, DatosEspecialista especialista, LocalDate fecha, LocalTime hora) {
        try {
            if (paciente.email != null && !paciente.email.isEmpty()) {
                String asunto = "Confirmación de Cita Médica";
                String cuerpo = String.format("Hola %s,\n\nTu cita ha sido agendada para el %s a las %s con %s (%s).\nGracias por usar nuestro servicio.",
                        paciente.nombre, fecha, hora, especialista.nombre, especialista.especialidad);
                EmailSender.enviarEmail(paciente.email, asunto, cuerpo);
            }
            if (paciente.telefono != null && !paciente.telefono.isEmpty()) {
                String sms = String.format("Cita agendada: %s %s con %s (%s).", fecha, hora, especialista.nombre, especialista.especialidad);
                SMSSender.enviarSMS(paciente.telefono, sms);
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error enviando notificaciones", e);
        }
    }

    private void forwardMensaje(HttpServletRequest request, HttpServletResponse response, String mensaje) throws ServletException, IOException {
        request.setAttribute("mensaje", mensaje);
        request.getRequestDispatcher("agendar_cita.jsp").forward(request, response);
    }

    // Clases auxiliares para agrupar datos
    private static class DatosPaciente {
        String email;
        String telefono;
        String nombre;
        DatosPaciente(String email, String telefono, String nombre) {
            this.email = email;
            this.telefono = telefono;
            this.nombre = nombre;
        }
    }

    private static class DatosEspecialista {
        String nombre;
        String especialidad;
        DatosEspecialista(String nombre, String especialidad) {
            this.nombre = nombre;
            this.especialidad = especialidad;
        }
    }
}
