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
    <link rel="stylesheet" href="css/estilosCancelarCita.css">
    <link rel="icon" href="imagenes/Logo.png" type="image/png">
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <h1>Cancelar Cita</h1>
    <%
        String mensaje = (String) request.getAttribute("mensaje");
        if (mensaje != null) {
    %>
        <p id="mensaje"><%= mensaje %></p>
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
                <p>No tienes citas pendientes para cancelar.</p>
    <%
            } else {
    %>
    <form method="post" action="CancelarCitaServlet">
        <table>
            <thead>
                <tr>
                    <th>Fecha y Hora</th>
                    <th>Especialidad</th>
                    <th>Especialista</th>
                    <th>Cancelar</th>
                </tr>
            </thead>
            <tbody>
            <%
                while (rs.next()) {
            %>
                <tr>
                    <td><%= rs.getTimestamp("fecha_hora") %></td>
                    <td><%= rs.getString("especialidad") %></td>
                    <td><%= rs.getString("nombre_especialista") %> <%= rs.getString("apellidos_especialista") %></td>
                    <td>
                        <button type="submit" name="idCita" value="<%= rs.getInt("id") %>" onclick="return confirm('¿Seguro que deseas cancelar esta cita?');">Cancelar</button>
                    </td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </form>
    <%
            }
        } catch (Exception e) {
            out.println("<p>Error al cargar las citas: " + e.getMessage() + "</p>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    %>
    <br>
    <a href="menu_paciente.jsp">Volver al menú</a>

    <!-- Bootstrap JS Bundle CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>