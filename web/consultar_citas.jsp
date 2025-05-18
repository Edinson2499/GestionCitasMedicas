<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="SQL.ConexionBD" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>

<%
    // Verificar si el usuario ha iniciado sesión y obtener su ID (ajusta esto según tu sistema de autenticación)
    Integer idPaciente = (Integer) session.getAttribute("idUsuario");
    String nombrePaciente = (String) session.getAttribute("nombre");

    if (idPaciente == null || nombrePaciente == null) {
        response.sendRedirect("login.jsp"); // Redirigir a la página de login si no hay sesión
        return;
    }

    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Citas</title>
    <link rel="icon" href="imagenes/Logo.png" type="image/png">
    <link rel="stylesheet" href="css/ver_citas.css">
</head>
<body>
    <header>
        <h1>Mis Citas, <%= nombrePaciente %></h1>
    </header>
    <main>
    <%
        try {
            connection = ConexionBD.conectar();
            if (connection != null) {
                String sql = "SELECT c.fecha_hora, es.especialidad, esp_u.nombre AS nombre_especialista, esp_u.apellidos AS apellidos_especialista " +
                            "FROM Cita c " +
                            "JOIN Usuario pac_u ON c.id_paciente = pac_u.id " +
                            "JOIN Usuario esp_u ON c.id_especialista = esp_u.id " +
                            "JOIN Especialista es ON esp_u.id = es.id_usuario " +
                            "WHERE pac_u.id = ? " +
                            "AND c.fecha_hora >= NOW() " + // Mostrar solo citas futuras
                            "ORDER BY c.fecha_hora ASC";

                preparedStatement = connection.prepareStatement(sql);
                preparedStatement.setInt(1, idPaciente);
                resultSet = preparedStatement.executeQuery();

                if (resultSet.isBeforeFirst()) {
                    while (resultSet.next()) {
                        Timestamp fechaHoraCita = resultSet.getTimestamp("fecha_hora");
                        LocalDateTime ldt = fechaHoraCita.toLocalDateTime();
                        String fechaHoraFormateada = ldt.format(formatter);
                        String especialidad = resultSet.getString("especialidad");
                        String nombreEspecialista = resultSet.getString("nombre_especialista");
                        String apellidosEspecialista = resultSet.getString("apellidos_especialista");
    %>
                        <div class="cita-container">
                            <li><p><strong>Fecha y Hora:</strong> <%= fechaHoraFormateada %></p></li>
                            <li><p><strong>Especialidad:</strong> <%= especialidad %></p></li>
                            <li><p><strong>Especialista:</strong> <%= nombreEspecialista %> <%= apellidosEspecialista %></p></li>
                        </div>
    <%
                    }
                } else {
    %>
                    <p class="no-citas">No tienes citas programadas.</p>
    <%
                }
            } else {
    %>
                <p class="error">Error al conectar a la base de datos.</p>
    <%
            }
        } catch (SQLException e) {
            e.printStackTrace();
    %>
        <p class="error">Error al consultar las citas: <%= e.getMessage() %></p>
    <%
        } finally {
            try { if (resultSet != null) resultSet.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (preparedStatement != null) preparedStatement.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (connection != null && !connection.isClosed()) connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
    
    </main>
    <a href="menu_paciente.jsp"></a>
</body>
</html>