/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlets;

import SQL.ConexionBD;
import Utils.EmailSender;
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
                        // 2. Obtener la información del paciente y la cita para el correo electrónico
                        String sqlObtenerInfo = "SELECT u.nombre AS nombre_paciente, u.apellidos AS apellidos_paciente, p.email AS email_paciente, c.fecha_hora, esp.especialidad " +
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
                            String fechaHoraCita = resultadoInfo.getTimestamp("fecha_hora").toString();
                            String especialidadCita = resultadoInfo.getString("especialidad");

                            // 3. Enviar el correo electrónico de confirmación
                            if (emailPaciente != null) {
                                boolean emailEnviado = EmailSender.enviarEmailConfirmacionCita(emailPaciente, nombrePaciente, fechaHoraCita, especialidadCita);
                                if (emailEnviado) {
                                    request.setAttribute("mensaje", "Cita confirmada y correo electrónico enviado a " + nombrePaciente + ".");
                                } else {
                                    request.setAttribute("mensaje", "Cita confirmada, pero hubo un error al enviar el correo electrónico.");
                                }
                            } else {
                                request.setAttribute("mensaje", "Cita confirmada, pero no se pudo obtener el correo electrónico del paciente.");
                            }
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
        response.sendRedirect("ver_citas_asignadas.jsp"); // Ejemplo de redirección
    }
}