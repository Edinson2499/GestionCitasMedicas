<!-- filepath: c:\Users\Vargas Cardenas\Desktop\GestionCitasMedicas\web\historial_medico.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, SQL.ConexionBD" %>
<%
    Integer idPaciente = (Integer) session.getAttribute("idUsuario");
    String nombrePaciente = (String) session.getAttribute("nombre");
    if (idPaciente == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Historial Médico</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="imagenes/Logo.svg" type="image/svg+xml">
    <link rel="stylesheet" href="css/estilos_historial_medico.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5 mb-5" style="max-width: 900px;">
        <h2 class="mb-4 text-center">Historial Médico de <%= nombrePaciente %></h2>
        <%
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                conn = ConexionBD.conectar();
                String sql = "SELECT c.fecha_hora, c.motivo, c.descripcion, c.estado, es.especialidad, u.nombre AS nombre_especialista, u.apellidos AS apellidos_especialista " +
                             "FROM Cita c " +
                             "JOIN Usuario u ON c.id_especialista = u.id " +
                             "JOIN Especialista es ON u.id = es.id_usuario " +
                             "WHERE c.id_paciente = ? AND (c.estado = 'realizada' OR c.estado = 'cancelada') " +
                             "ORDER BY c.fecha_hora DESC";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, idPaciente);
                rs = ps.executeQuery();
                if (!rs.isBeforeFirst()) {
        %>
                    <div class="alert alert-info text-center">No hay historial médico disponible.</div>
        <%
                } else {
        %>
        <div class="table-responsive">
            <table class="table-historial-medico">
                <thead class="table-primary">
                    <tr>
                        <th>Fecha y Hora</th>
                        <th>Especialidad</th>
                        <th>Especialista</th>
                        <th>Motivo</th>
                        <th>Descripción</th>
                        <th>Estado</th>
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
                        <td><%= rs.getString("motivo") %></td>
                        <td><%= rs.getString("descripcion") != null ? rs.getString("descripcion") : "-" %></td>
                        <td>
                            <span class="badge bg-<%= "realizada".equals(rs.getString("estado")) ? "success" : "secondary" %>">
                                <%= rs.getString("estado") %>
                            </span>
                        </td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
        <%
                }
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error al cargar el historial: " + e.getMessage() + "</div>");
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (ps != null) ps.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        %>
        <a href="menu_paciente.jsp" class="btn-back " title="Volver al menu de paciete"></a>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>