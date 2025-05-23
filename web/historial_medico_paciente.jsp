<!-- filepath: c:\Users\Vargas Cardenas\Desktop\GestionCitasMedicas\web\historial_medico_paciente.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*,SQL.ConexionBD" %>
<%
    String idParam = request.getParameter("id");
    Integer idPaciente = null;
    try {
        idPaciente = Integer.parseInt(idParam);
    } catch (Exception e) {
        idPaciente = null;
    }
    if (idPaciente == null) {
        out.println("<div class='alert alert-danger'>ID de paciente inválido.</div>");
        return;
    }

    String nombrePaciente = "";
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        conn = ConexionBD.conectar();
        // Obtener nombre del paciente
        ps = conn.prepareStatement("SELECT nombre, apellidos FROM Usuario WHERE id = ?");
        ps.setInt(1, idPaciente);
        rs = ps.executeQuery();
        if (rs.next()) {
            nombrePaciente = rs.getString("nombre") + " " + rs.getString("apellidos");
        }
        rs.close();
        ps.close();

        // Obtener historial médico
        String sql = "SELECT c.fecha_hora, c.motivo, c.estado, es.especialidad, u.nombre AS nombre_especialista, u.apellidos AS apellidos_especialista " +
                     "FROM Cita c " +
                     "JOIN Usuario u ON c.id_especialista = u.id " +
                     "JOIN Especialista es ON u.id = es.id_usuario " +
                     "WHERE c.id_paciente = ? AND (c.estado = 'realizada' OR c.estado = 'cancelada') " +
                     "ORDER BY c.fecha_hora DESC";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, idPaciente);
        rs = ps.executeQuery();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Historial Médico de <%= nombrePaciente %></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="imagenes/Logo.png" type="image/png">
    <link rel="stylesheet" href="css/estilos_historial_medico.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5 mb-5" style="max-width: 900px;">
        <h2 class="mb-4 text-center">Historial Médico de <%= nombrePaciente %></h2>
        <%
            if (!rs.isBeforeFirst()) {
        %>
            <div class="alert alert-info text-center">No hay historial médico disponible para este paciente.</div>
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
        <a href="historial_pacientes.jsp" class="btn-back" title="Volver a la búsqueda de pacientes"></a>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>