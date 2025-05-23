/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlets;

import SQL.ConexionBD;
import Utils.EmailSender;
import Utils.SMSSender;
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

@WebServlet("/ConfirmarCitaServlet")
public class ConfirmarCitaServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idCitaStr = request.getParameter("idCita");
        if (idCitaStr != null && !idCitaStr.isEmpty()) {
            int idCita = Integer.parseInt(idCitaStr);
            Connection conexion = null;
            PreparedStatement sentenciaActualizar = null;
            PreparedStatement sentenciaObtenerInfo = null;
            ResultSet resultadoInfo = null;

            try {
                conexion = ConexionBD.conectar();
                if (conexion != null) {
                    // 1. Actualizar el estado de la cita a 'confirmada'
                    String sqlActualizarCita = "UPDATE Cita SET estado = 'confirmada' WHERE id = ?";
                    sentenciaActualizar = conexion.prepareStatement(sqlActualizarCita);
                    sentenciaActualizar.setInt(1, idCita);
                    int filasAfectadas = sentenciaActualizar.executeUpdate();

                    if (filasAfectadas > 0) {
                        // 2. Obtener la información del paciente y la cita para notificaciones
                        String sqlObtenerInfo = "SELECT u.nombre AS nombre_paciente, u.apellidos AS apellidos_paciente, p.email AS email_paciente, u.telefono1, c.fecha_hora, esp.especialidad, es_u.nombre AS nombre_especialista " +
                                "FROM Cita c " +
                                "JOIN Usuario u ON c.id_paciente = u.id " +
                                "JOIN Paciente p ON u.id = p.id_usuario " +
                                "JOIN Usuario es_u ON c.id_especialista = es_u.id " +
                                "JOIN Especialista esp ON es_u.id = esp.id_usuario " +
                                "WHERE c.id = ?";
                        sentenciaObtenerInfo = conexion.prepareStatement(sqlObtenerInfo);
                        sentenciaObtenerInfo.setInt(1, idCita);
                        resultadoInfo = sentenciaObtenerInfo.executeQuery();

                        if (resultadoInfo.next()) {
                            String nombrePaciente = resultadoInfo.getString("nombre_paciente") + " " + resultadoInfo.getString("apellidos_paciente");
                            String emailPaciente = resultadoInfo.getString("email_paciente");
                            String telefonoPaciente = resultadoInfo.getString("telefono1");
                            String fechaHoraCita = resultadoInfo.getTimestamp("fecha_hora").toString();
                            String especialidadCita = resultadoInfo.getString("especialidad");
                            String nombreEspecialista = resultadoInfo.getString("nombre_especialista");

                            // 3. Enviar el correo electrónico de confirmación
                            boolean emailEnviado = false;
                            if (emailPaciente != null && !emailPaciente.isEmpty()) {
                                emailEnviado = EmailSender.enviarEmailConfirmacionCita(
                                    emailPaciente,
                                    nombrePaciente,
                                    fechaHoraCita,
                                    especialidadCita
                                );
                            }

                            // 4. Enviar SMS de confirmación si hay teléfono
                            boolean smsEnviado = false;
                            if (telefonoPaciente != null && !telefonoPaciente.isEmpty()) {
                                String mensajeSMS = "Cita confirmada: " + fechaHoraCita + " con " + nombreEspecialista + " (" + especialidadCita + ").";
                                smsEnviado = SMSSender.enviarSMS(telefonoPaciente, mensajeSMS);
                            }

                            // 5. Mensaje de resultado
                            StringBuilder mensaje = new StringBuilder("Cita confirmada.");
                            if (emailEnviado) {
                                mensaje.append(" Correo enviado a ").append(emailPaciente).append(".");
                            } else {
                                mensaje.append(" (No se pudo enviar correo electrónico).");
                            }
                            if (telefonoPaciente != null && !telefonoPaciente.isEmpty()) {
                                if (smsEnviado) {
                                    mensaje.append(" SMS enviado a ").append(telefonoPaciente).append(".");
                                } else {
                                    mensaje.append(" (No se pudo enviar SMS).");
                                }
                            } else {
                                mensaje.append(" (Paciente sin teléfono registrado).");
                            }
                            request.setAttribute("mensaje", mensaje.toString());
                        } else {
                            request.setAttribute("error", "Error al obtener la información de la cita.");
                        }
                    } else {
                        request.setAttribute("error", "No se pudo confirmar la cita con ID: " + idCita);
                    }
                } else {
                    request.setAttribute("error", "Error al conectar a la base de datos.");
                }
            } catch (SQLException e) {
                request.setAttribute("error", "Error al confirmar la cita: " + e.getMessage());
                e.printStackTrace();
            } finally {
                try { if (resultadoInfo != null) resultadoInfo.close(); } catch (SQLException e) { e.printStackTrace(); }
                try { if (sentenciaObtenerInfo != null) sentenciaObtenerInfo.close(); } catch (SQLException e) { e.printStackTrace(); }
                try { if (sentenciaActualizar != null) sentenciaActualizar.close(); } catch (SQLException e) { e.printStackTrace(); }
                try { if (conexion != null && !conexion.isClosed()) conexion.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        } else {
            request.setAttribute("error", "ID de cita inválido.");
        }
        // Decide a dónde redirigir después de la confirmación
        response.sendRedirect("ver_citas_asignadas.jsp");
    }
}