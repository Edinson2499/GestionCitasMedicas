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
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/VerCitasAsignadasServlet")
public class VerCitasAsignadasServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer idEspecialista = (Integer) session.getAttribute("idUsuario");

        if (idEspecialista == null) {
            response.sendRedirect("login.jsp"); // Redirigir si no hay sesión
            return;
        }

        Connection conexion = null;
        PreparedStatement sentencia = null;
        ResultSet resultado = null;
        List<CitaAsignada> citas = new ArrayList<>();

        try {
            conexion = ConexionBD.conectar();
            if (conexion != null) {
                String consulta = "SELECT c.fecha_hora, p.nombre AS nombre_paciente, p.apellidos AS apellidos_paciente, e.especialidad, c.estado " +
                                  "FROM Cita c " +
                                  "JOIN Usuario p ON c.id_paciente = p.id " +
                                  "JOIN Usuario es ON c.id_especialista = es.id " +
                                  "JOIN Especialista e ON es.id = e.id_usuario " +
                                  "WHERE c.id_especialista = ?";
                sentencia = conexion.prepareStatement(consulta);
                sentencia.setInt(1, idEspecialista);
                resultado = sentencia.executeQuery();

                while (resultado.next()) {
                    CitaAsignada cita = new CitaAsignada();
                    cita.setFechaHora(resultado.getTimestamp("fecha_hora"));
                    cita.setNombrePaciente(resultado.getString("nombre_paciente") + " " + resultado.getString("apellidos_paciente"));
                    cita.setEspecialidad(resultado.getString("especialidad"));
                    cita.setEstado(resultado.getString("estado"));
                    citas.add(cita);
                }
            } else {
                request.setAttribute("error", "Error al conectar a la base de datos.");
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Error al consultar las citas: " + e.getMessage());
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

        request.setAttribute("citasAsignadas", citas);
        request.getRequestDispatcher("ver_citas_asignadas.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    // Clase auxiliar para representar una cita asignada
    public static class CitaAsignada {
        private java.sql.Timestamp fechaHora;
        private String nombrePaciente;
        private String especialidad;
        private String estado;

        public java.sql.Timestamp getFechaHora() {
            return fechaHora;
        }

        public void setFechaHora(java.sql.Timestamp fechaHora) {
            this.fechaHora = fechaHora;
        }

        public String getNombrePaciente() {
            return nombrePaciente;
        }

        public void setNombrePaciente(String nombrePaciente) {
            this.nombrePaciente = nombrePaciente;
        }

        public String getEspecialidad() {
            return especialidad;
        }

        public void setEspecialidad(String especialidad) {
            this.especialidad = especialidad;
        }

        public String getEstado() {
            return estado;
        }

        public void setEstado(String estado) {
            this.estado = estado;
        }
    }
}