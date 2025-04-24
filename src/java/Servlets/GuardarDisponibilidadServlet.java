/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
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


@WebServlet("/GuardarDisponibilidadServlet")
public class GuardarDisponibilidadServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer idEspecialista = (Integer) session.getAttribute("idUsuario");

        if (idEspecialista == null) {
            response.sendRedirect("login.jsp"); // Redirigir si no hay sesión
            return;
        }

        String diaStr = request.getParameter("dia");
        String horaInicioStr = request.getParameter("hora_inicio");
        String horaFinStr = request.getParameter("hora_fin");

        if (diaStr == null || diaStr.isEmpty() || horaInicioStr == null || horaInicioStr.isEmpty() || horaFinStr == null || horaFinStr.isEmpty()) {
            request.setAttribute("mensaje", "Por favor, complete todos los campos de disponibilidad.");
            request.getRequestDispatcher("actualizar_disponibilidad.jsp").forward(request, response);
            return;
        }

        LocalDate dia = LocalDate.parse(diaStr);
        LocalTime horaInicio = LocalTime.parse(horaInicioStr);
        LocalTime horaFin = LocalTime.parse(horaFinStr);

        java.sql.Date fechaSql = java.sql.Date.valueOf(dia);
        java.sql.Time horaInicioSql = java.sql.Time.valueOf(horaInicio);
        java.sql.Time horaFinSql = java.sql.Time.valueOf(horaFin);

        Connection conexion = null;
        PreparedStatement sentencia = null;
        String mensaje = "";

        try {
            conexion = ConexionBD.conectar();
            if (conexion != null) {
                String consulta = "INSERT INTO DisponibilidadEspecialista (id_especialista, fecha, hora_inicio, hora_fin) VALUES (?, ?, ?, ?)";
                sentencia = conexion.prepareStatement(consulta);
                sentencia.setInt(1, idEspecialista);
                sentencia.setDate(2, fechaSql);
                sentencia.setTime(3, horaInicioSql);
                sentencia.setTime(4, horaFinSql);

                int filasAfectadas = sentencia.executeUpdate();
                if (filasAfectadas > 0) {
                    mensaje = "Disponibilidad guardada con éxito.";
                } else {
                    mensaje = "Error al guardar la disponibilidad.";
                }
            } else {
                mensaje = "Error al conectar a la base de datos.";
            }
        } catch (SQLException e) {
            mensaje = "Error al guardar la disponibilidad: " + e.getMessage();
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
        request.getRequestDispatcher("actualizar_disponibilidad.jsp").forward(request, response);
    }
}