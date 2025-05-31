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
    int limit = 10;
    int pageNum = 1;
    if (request.getParameter("page") != null) {
        try {
            pageNum = Integer.parseInt(request.getParameter("page"));
            if (pageNum < 1) pageNum = 1;
        } catch (Exception e) { pageNum = 1; }
    }
    int offset = (pageNum - 1) * limit;
    int totalRegistros = 0;
    try {
        connection = ConexionBD.conectar();
        String countSql = "SELECT COUNT(*) FROM Cita WHERE id_paciente = ? AND fecha_hora >= NOW()";
        PreparedStatement psCount = connection.prepareStatement(countSql);
        psCount.setInt(1, idPaciente);
        ResultSet rsCount = psCount.executeQuery();
        if (rsCount.next()) {
            totalRegistros = rsCount.getInt(1);
        }
        rsCount.close();
        psCount.close();
    } catch (Exception e) { totalRegistros = 0; }
    int totalPaginas = (int) Math.ceil((double) totalRegistros / limit);
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Citas</title>
    <link rel="icon" href="imagenes/Logo.svg" type="image/svg+xml">
    <link rel="stylesheet" href="css/ver_citas.css">
        <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
                String sql = "SELECT c.fecha_hora, es.especialidad, esp_u.nombre AS nombre_especialista, esp_u.apellidos AS apellidos_especialista, c.estado " +
                            "FROM Cita c " +
                            "JOIN Usuario pac_u ON c.id_paciente = pac_u.id " +
                            "JOIN Usuario esp_u ON c.id_especialista = esp_u.id " +
                            "JOIN Especialista es ON esp_u.id = es.id_usuario " +
                            "WHERE pac_u.id = ? " +
                            "AND c.fecha_hora >= NOW() " +
                            "ORDER BY c.fecha_hora ASC LIMIT ? OFFSET ?";
                preparedStatement = connection.prepareStatement(sql);
                preparedStatement.setInt(1, idPaciente);
                preparedStatement.setInt(2, limit);
                preparedStatement.setInt(3, offset);
                resultSet = preparedStatement.executeQuery();

                if (resultSet.isBeforeFirst()) {
                    while (resultSet.next()) {
                        Timestamp fechaHoraCita = resultSet.getTimestamp("fecha_hora");
                        LocalDateTime ldt = fechaHoraCita.toLocalDateTime();
                        String fechaHoraFormateada = ldt.format(formatter);
                        String especialidad = resultSet.getString("especialidad");
                        String nombreEspecialista = resultSet.getString("nombre_especialista");
                        String apellidosEspecialista = resultSet.getString("apellidos_especialista");
                        String estado = resultSet.getString("estado");
    %>
                        <div class="cita-container">
                            <li><p><strong>Fecha y Hora:</strong> <%= fechaHoraFormateada %></p></li>
                            <li><p><strong>Especialidad:</strong> <%= especialidad %></p></li>
                            <li><p><strong>Especialista:</strong> <%= nombreEspecialista %> <%= apellidosEspecialista %></p></li>
                            <li><p><strong>Estado:</strong> <%= estado.substring(0,1).toUpperCase() + estado.substring(1).toLowerCase() %></p></li>
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
                <div class='alert alert-danger'>Error al conectar a la base de datos</div>
    <%
            }
        } catch (SQLException e) {
            e.printStackTrace();
    %>
        <div class='alert alert-danger'>Error al consultar las citas: " + e.getMessage() + "</div>
    <%
        } finally {
            try { if (resultSet != null) resultSet.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (preparedStatement != null) preparedStatement.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (connection != null && !connection.isClosed()) connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
    <div class="d-flex justify-content-center align-items-center my-3">
        <nav aria-label="Paginación">
            <ul class="pagination">
                <li class="page-item <%= (pageNum <= 1) ? "disabled" : "" %>">
                    <a class="page-link" href="consultar_citas.jsp?page=<%= (pageNum-1) %>">Anterior</a>
                </li>
                <% for (int i = 1; i <= totalPaginas; i++) { %>
                    <li class="page-item <%= (i == pageNum) ? "active" : "" %>">
                        <a class="page-link" href="consultar_citas.jsp?page=<%= i %>"><%= i %></a>
                    </li>
                <% } %>
                <li class="page-item <%= (pageNum >= totalPaginas) ? "disabled" : "" %>">
                    <a class="page-link" href="consultar_citas.jsp?page=<%= (pageNum+1) %>">Siguiente</a>
                </li>
            </ul>
        </nav>
    </div>
    </main>
    <a class="btn-back" href="menu_paciente.jsp" title="Volver al menú paciente"></a>
    
    <!-- Bootstrap JS Bundle CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>