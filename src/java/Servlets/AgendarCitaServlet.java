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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/AgendarCitaServlet")
public class AgendarCitaServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AgendarCitaServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");
        String mensaje = "";
        HttpSession session = request.getSession();
        Integer idPaciente = (Integer) session.getAttribute("idUsuario");

        if (idPaciente == null) {
            mensaje = "Debe iniciar sesión para agendar una cita.";
            forwardMensaje(request, response, mensaje);
            return;
        }

        String fechaStr = request.getParameter("fecha");
        String especialidad = request.getParameter("especialidad");
        String motivo = request.getParameter("motivo");

        if ("consultar".equals(accion)) {
            // Mostrar disponibilidad
            if (fechaStr == null || fechaStr.isEmpty() || especialidad == null || especialidad.isEmpty()) {
                mensaje = "Debe seleccionar fecha y especialidad.";
                forwardMensaje(request, response, mensaje);
                return;
            }
            try (Connection conexion = ConexionBD.conectar()) {
                if (conexion == null) {
                    mensaje = "No se pudo conectar a la base de datos.";
                    forwardMensaje(request, response, mensaje);
                    return;
                }
                LocalDate fecha = LocalDate.parse(fechaStr);
                Map<String, List<String>> disponibilidad = obtenerDisponibilidad(conexion, especialidad, fecha);
                if (disponibilidad.isEmpty()) {
                    mensaje = "No hay especialistas disponibles para esa fecha y especialidad.";
                }
                request.setAttribute("disponibilidadEspecialistas", disponibilidad);
                request.setAttribute("mensaje", mensaje);
                request.getRequestDispatcher("agendar_cita.jsp").forward(request, response);
            } catch (Exception e) {
                mensaje = "Error al consultar disponibilidad: " + e.getMessage();
                forwardMensaje(request, response, mensaje);
            }
            return;
        }

        if ("agendar".equals(accion)) {
            String especialistaSeleccionadoStr = request.getParameter("especialistaSeleccionado");
            String horarioSeleccionado = request.getParameter("horarioSeleccionado");

            if (fechaStr == null || fechaStr.isEmpty() ||
                especialidad == null || especialidad.isEmpty() ||
                especialistaSeleccionadoStr == null || especialistaSeleccionadoStr.isEmpty() ||
                horarioSeleccionado == null || horarioSeleccionado.isEmpty()) {
                mensaje = "Debe seleccionar fecha, especialidad, especialista y horario.";
                forwardMensaje(request, response, mensaje);
                return;
            }

            // Parsear hora de inicio del slot seleccionado
            String horaInicioStr = horarioSeleccionado.split(" - ")[0];
            LocalDate fechaCita = LocalDate.parse(fechaStr);
            LocalTime horaCita = LocalTime.parse(horaInicioStr);
            Timestamp fechaHoraCita = Timestamp.valueOf(fechaCita.atTime(horaCita));

            // Validación: No permitir agendar en el pasado
            java.time.LocalDateTime ahora = java.time.LocalDateTime.now();
            if (fechaHoraCita.toLocalDateTime().isBefore(ahora)) {
                mensaje = "No se puede agendar una cita en una fecha u hora pasada.";
                forwardMensaje(request, response, mensaje);
                return;
            }

            try (Connection conexion = ConexionBD.conectar()) {
                if (conexion == null) {
                    mensaje = "No se pudo conectar a la base de datos.";
                    forwardMensaje(request, response, mensaje);
                    return;
                }

                Integer idEspecialista = obtenerIdEspecialistaPorNombre(conexion, especialistaSeleccionadoStr, especialidad, fechaCita, horaCita);
                if (idEspecialista == null) {
                    mensaje = "No se encontró especialista disponible para ese horario.";
                    forwardMensaje(request, response, mensaje);
                    return;
                }

                // Verificar traslape
                if (existeTraslape(conexion, idEspecialista, fechaHoraCita)) {
                    mensaje = "El especialista ya tiene una cita agendada en un lapso de 20 minutos. Por favor, elija otro horario.";
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

                // Notificaciones
                DatosPaciente datosPaciente = obtenerDatosPaciente(conexion, idPaciente);
                DatosEspecialista datosEspecialista = obtenerDatosEspecialista(conexion, idEspecialista);
                if (datosPaciente == null || datosEspecialista == null) {
                    mensaje = "Cita agendada, pero no se pudo obtener información para notificaciones.";
                    forwardMensaje(request, response, mensaje);
                    return;
                }
                enviarNotificaciones(datosPaciente, datosEspecialista, fechaCita, horaCita);
                mensaje = "Cita agendada exitosamente. Se enviaron las notificaciones correspondientes.";
                forwardMensaje(request, response, mensaje);
            } catch (Exception e) {
                mensaje = "Error al agendar la cita: " + e.getMessage();
                forwardMensaje(request, response, mensaje);
            }
            return;
        }

        // Si no hay acción válida
        mensaje = "Acción no válida.";
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
                String cuerpo = "<html><body style='font-family: Arial, sans-serif; color: #333;'>"
                        + "<h2 style='color:#0069d9;'>Confirmación de su cita médica</h2>"
                        + "<p>Estimado/a <strong>" + paciente.nombre + "</strong>,</p>"
                        + "<p>Su cita ha sido agendada exitosamente con la siguiente información:</p>"
                        + "<table style='border-collapse:collapse; margin-bottom: 15px;'>"
                        + "<tr><td style='padding:4px 8px;'><b>Fecha:</b></td><td style='padding:4px 8px;'>" + fecha + "</td></tr>"
                        + "<tr><td style='padding:4px 8px;'><b>Hora:</b></td><td style='padding:4px 8px;'>" + hora + "</td></tr>"
                        + "<tr><td style='padding:4px 8px;'><b>Especialista:</b></td><td style='padding:4px 8px;'>" + especialista.nombre + "</td></tr>"
                        + "<tr><td style='padding:4px 8px;'><b>Especialidad:</b></td><td style='padding:4px 8px;'>" + especialista.especialidad + "</td></tr>"
                        + "</table>"
                        + "<p>Le recomendamos presentarse al menos <b>10 minutos antes</b> de la hora programada.</p>"
                        + "<p>Si necesita cancelar o reprogramar su cita, puede responder a este correo o comunicarse con nuestro centro de atención.</p>"
                        + "<hr style='margin:20px 0;'>"
                        + "<p style='color:#888;'>Gracias por confiar en nuestro sistema de gestión de citas médicas.</p>"
                        + "<br><hr style='margin:20px 0;'>"
                        + "<div style='font-size:14px; color:#222;'>"
                        + "<b>Business Health</b><br>"
                        + "Centro de Salud<br>"
                        + "<img src='https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png' alt='github icon' style='width:20px;vertical-align:middle;'>"
                        + " <span style='color:#555;'>E: <a href='mailto:BusinessHealth@gmail.com'>BusinessHealth@gmail.com</a></span><br>"
                        + "A: Business Health<br>"
                        + "<a href='https://github.com/Shadowfiend2504/GestionCitasMedicas' style='color:#0069d9;'>www.BusynessHealth.com</a><br>"
                        + "<img src='https://raw.githubusercontent.com/Shadowfiend2504/GestionCitasMedicas/refs/heads/main/web/imagenes/Banner%20(1).png' alt='Banner' style='width:100%; max-width:400px; height:auto;'>"
                        + "</div>"
                        + "</body></html>";
                EmailSender.enviarEmailHTML(paciente.email, asunto, cuerpo);
            }
            if (paciente.telefono != null && !paciente.telefono.isEmpty()) {
                LOGGER.info("Enviando SMS a: " + paciente.telefono);
                String sms = String.format(
                    "Estimado/a %s, su cita médica ha sido agendada para el %s a las %s con el especialista %s (%s). Por favor, preséntese 10 minutos antes. Si requiere cancelar o reprogramar, contáctenos. Atentamente, Business Health.",
                    paciente.nombre, fecha, hora, especialista.nombre, especialista.especialidad
                );
                boolean enviado = SMSSender.enviarSMS(paciente.telefono, sms);
                if (!enviado) {
                    LOGGER.warning("No se pudo enviar el SMS a " + paciente.telefono);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error enviando notificaciones", e);
        }
    }

    private void forwardMensaje(HttpServletRequest request, HttpServletResponse response, String mensaje) throws ServletException, IOException {
        request.setAttribute("mensaje", mensaje);
        request.getRequestDispatcher("agendar_cita.jsp").forward(request, response);
    }

    private boolean existeTraslape(Connection conexion, int idEspecialista, Timestamp fechaHora) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Cita " +
                     "WHERE id_especialista = ? " +
                     "AND estado IN ('pendiente', 'confirmada', 'realizada') " +
                     "AND ABS(TIMESTAMPDIFF(MINUTE, fecha_hora, ?)) < 20";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setInt(1, idEspecialista);
            ps.setTimestamp(2, fechaHora);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    private Map<String, List<String>> obtenerDisponibilidad(Connection conexion, String especialidad, LocalDate fecha) throws SQLException {
        Map<String, List<String>> disponibilidad = new LinkedHashMap<>();
        String sql = "SELECT u.id, u.nombre, u.apellidos, d.hora_inicio, d.hora_fin " +
                     "FROM Usuario u " +
                     "JOIN Especialista e ON u.id = e.id_usuario " +
                     "JOIN DisponibilidadEspecialista d ON u.id = d.id_especialista " +
                     "WHERE e.especialidad = ? AND d.fecha = ?";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setString(1, especialidad);
            ps.setDate(2, Date.valueOf(fecha));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int idEspecialista = rs.getInt("id");
                    String nombreCompleto = rs.getString("nombre") + " " + rs.getString("apellidos");
                    Time horaInicio = rs.getTime("hora_inicio");
                    Time horaFin = rs.getTime("hora_fin");
                    List<String> slots = calcularSlotsDisponibles(conexion, idEspecialista, fecha, horaInicio, horaFin);
                    disponibilidad.put(nombreCompleto, slots);
                }
            }
        }
        return disponibilidad;
    }

    private List<String> calcularSlotsDisponibles(Connection conexion, int idEspecialista, LocalDate fecha, Time horaInicio, Time horaFin) throws SQLException {
        List<String> disponibles = new java.util.ArrayList<>();
        LocalTime inicio = horaInicio.toLocalTime();
        LocalTime fin = horaFin.toLocalTime();
        while (!inicio.plusMinutes(20).isAfter(fin)) {
            LocalTime slotFin = inicio.plusMinutes(20);
            Timestamp slotInicioTs = Timestamp.valueOf(fecha.atTime(inicio));
            Timestamp slotFinTs = Timestamp.valueOf(fecha.atTime(slotFin));
            // Verifica si hay cita en ese slot
            String sql = "SELECT COUNT(*) FROM Cita WHERE id_especialista = ? AND fecha_hora >= ? AND fecha_hora < ? AND estado IN ('pendiente','confirmada','realizada')";
            try (PreparedStatement ps = conexion.prepareStatement(sql)) {
                ps.setInt(1, idEspecialista);
                ps.setTimestamp(2, slotInicioTs);
                ps.setTimestamp(3, slotFinTs);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) == 0) {
                        disponibles.add(inicio + " - " + slotFin);
                    }
                }
            }
            inicio = inicio.plusMinutes(20);
        }
        return disponibles;
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

    // Agrega este método auxiliar:
    private Integer obtenerIdEspecialistaPorNombre(Connection conexion, String nombreCompleto, String especialidad, LocalDate fechaCita, LocalTime horaCita) throws SQLException {
        String sql = "SELECT u.id FROM Usuario u " +
                     "JOIN Especialista e ON u.id = e.id_usuario " +
                     "JOIN DisponibilidadEspecialista d ON u.id = d.id_especialista " +
                     "WHERE CONCAT(u.nombre, ' ', u.apellidos) = ? " +
                     "AND e.especialidad = ? " +
                     "AND d.fecha = ? " +
                     "AND d.hora_inicio <= ? " +
                     "AND d.hora_fin >= ? " +
                     "LIMIT 1";
        try (PreparedStatement ps = conexion.prepareStatement(sql)) {
            ps.setString(1, nombreCompleto);
            ps.setString(2, especialidad);
            ps.setDate(3, Date.valueOf(fechaCita));
            ps.setTime(4, Time.valueOf(horaCita));
            ps.setTime(5, Time.valueOf(horaCita));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        }
        return null;
    }
}

