<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, SQL.ConexionBD" %>
<%
    Integer idPaciente = (Integer) session.getAttribute("idUsuario");
    if (idPaciente == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Cancelar Cita</title>
    <link rel="stylesheet" href="css/ver_citas.css">
    <link rel="icon" href="imagenes/Logo.png" type="image/png">
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <header>
        <h1>Cancelar Cita</h1>
    </header>
    <main>
    <%
        String mensaje = (String) request.getAttribute("mensaje");
        if (mensaje != null) {
    %>
        <div class="alert alert-info text-center my-3"><%= mensaje %></div>
    <%
        }
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = ConexionBD.conectar();
            String sql = "SELECT c.id, c.fecha_hora, es.especialidad, u.nombre AS nombre_especialista, u.apellidos AS apellidos_especialista " +
                         "FROM Cita c " +
                         "JOIN Usuario u ON c.id_especialista = u.id " +
                         "JOIN Especialista es ON u.id = es.id_usuario " +
                         "WHERE c.id_paciente = ? AND c.estado = 'pendiente' AND c.fecha_hora >= NOW() " +
                         "ORDER BY c.fecha_hora ASC";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idPaciente);
            rs = ps.executeQuery();
            if (!rs.isBeforeFirst()) {
    %>
                <p class="no-citas">No tienes citas pendientes para cancelar.</p>
    <%
            } else {
    %>
        <form method="post" action="CancelarCitaServlet" style="width:100%;max-width:100%;">
            <div class="container-fluid px-0">
                <div class="row justify-content-center">
                    <div class="col-12 col-md-10">
                        <%
                            while (rs.next()) {
                                java.sql.Timestamp fechaHoraCita = rs.getTimestamp("fecha_hora");
                                java.time.LocalDateTime ldt = fechaHoraCita.toLocalDateTime();
                                java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                                String fechaHoraFormateada = ldt.format(formatter);
                        %>
                        <div class="cita-container mb-3">
                            <ul class="list-unstyled mb-2">
                                <li><p><strong>Fecha y Hora:</strong> <%= fechaHoraFormateada %></p></li>
                                <li><p><strong>Especialidad:</strong> <%= rs.getString("especialidad") %></p></li>
                                <li><p><strong>Especialista:</strong> <%= rs.getString("nombre_especialista") %> <%= rs.getString("apellidos_especialista") %></p></li>
                            </ul>
                            <button type="submit" class="btn btn-danger" name="idCita" value="<%= rs.getInt("id") %>" onclick="return confirm('¿Seguro que deseas cancelar esta cita?');">Cancelar</button>
                        </div>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
        </form>
    <%
            }
        } catch (Exception e) {
    %>
        <div class='alert alert-danger'>Error al cargar las citas: <%= e.getMessage() %></div>
    <%
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    %>
    </main>
    <a href="menu_paciente.jsp" class="btn-back" title="Volver al menú de Paciente"></a>
    <!-- Bootstrap JS Bundle CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>