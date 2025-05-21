<!-- filepath: c:\Users\Vargas Cardenas\Desktop\GestionCitasMedicas\web\gestionar_historial.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, SQL.ConexionBD" %>
<%
    if (session.getAttribute("rol") == null || !"administrador".equals(session.getAttribute("rol"))) {
        response.sendRedirect("login_admin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestionar Historial Médico</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="imagenes/Logo.png" type="image/png">
    <link rel="stylesheet" href="css/estilos_gestionar_historial.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5 mb-5" style="max-width: 1100px;">
        <h2 class="mb-4 text-center">Historial Médico de Pacientes</h2>
        <!-- Filtro por paciente -->
        <form method="get" class="mb-4 row g-3">
            <div class="col-md-8">
                <label for="idPaciente" class="form-label">Filtrar por paciente</label>
                <select class="form-select" id="idPaciente" name="idPaciente">
                    <option value="">Todos</option>
                    <%
                        Connection conn = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;
                        try {
                            conn = ConexionBD.conectar();
                            String sql = "SELECT id, nombre, apellidos FROM Usuario WHERE tipo_usuario = 'paciente' ORDER BY nombre";
                            ps = conn.prepareStatement(sql);
                            rs = ps.executeQuery();
                            while (rs.next()) {
                                String selected = (request.getParameter("idPaciente") != null && request.getParameter("idPaciente").equals(String.valueOf(rs.getInt("id")))) ? "selected" : "";
                    %>
                    <option value="<%= rs.getInt("id") %>" <%= selected %>><%= rs.getString("nombre") %> <%= rs.getString("apellidos") %></option>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("<option disabled>Error al cargar pacientes</option>");
                        } finally {
                            try { if (rs != null) rs.close(); } catch (Exception e) {}
                            try { if (ps != null) ps.close(); } catch (Exception e) {}
                            try { if (conn != null) conn.close(); } catch (Exception e) {}
                        }
                    %>
                </select>
            </div>
            <div class="col-md-4 d-flex align-items-end">
                <button type="submit" class="btn btn-primary w-100">Filtrar</button>
            </div>
        </form>
        <!-- Tabla de historial -->
        <div class="table-responsive">
            <table class="table table-bordered table-hover align-middle">
                <thead class="table-primary">
                    <tr>
                        <th>Paciente</th>
                        <th>Fecha y Hora</th>
                        <th>Especialista</th>
                        <th>Especialidad</th>
                        <th>Motivo</th>
                        <th>Estado</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    conn = null;
                    ps = null;
                    rs = null;
                    try {
                        conn = ConexionBD.conectar();
                        String sql = "SELECT c.fecha_hora, c.motivo, c.estado, " +
                                     "pac.nombre AS nombre_paciente, pac.apellidos AS apellidos_paciente, " +
                                     "esp.nombre AS nombre_especialista, esp.apellidos AS apellidos_especialista, es.especialidad " +
                                     "FROM Cita c " +
                                     "JOIN Usuario pac ON c.id_paciente = pac.id " +
                                     "JOIN Usuario esp ON c.id_especialista = esp.id " +
                                     "JOIN Especialista es ON esp.id = es.id_usuario " +
                                     "WHERE (c.estado = 'realizada' OR c.estado = 'cancelada') ";
                        String idPaciente = request.getParameter("idPaciente");
                        if (idPaciente != null && !idPaciente.isEmpty()) {
                            sql += "AND c.id_paciente = ? ";
                        }
                        sql += "ORDER BY c.fecha_hora DESC";
                        ps = conn.prepareStatement(sql);
                        if (idPaciente != null && !idPaciente.isEmpty()) {
                            ps.setInt(1, Integer.parseInt(idPaciente));
                        }
                        rs = ps.executeQuery();
                        boolean hayResultados = false;
                        while (rs.next()) {
                            hayResultados = true;
                %>
                    <tr>
                        <td><%= rs.getString("nombre_paciente") %> <%= rs.getString("apellidos_paciente") %></td>
                        <td><%= rs.getTimestamp("fecha_hora") %></td>
                        <td><%= rs.getString("nombre_especialista") %> <%= rs.getString("apellidos_especialista") %></td>
                        <td><%= rs.getString("especialidad") %></td>
                        <td><%= rs.getString("motivo") %></td>
                        <td>
                            <span class="badge bg-<%= "realizada".equals(rs.getString("estado")) ? "success" : "danger" %>">
                                <%= rs.getString("estado") %>
                            </span>
                        </td>
                    </tr>
                <%
                        }
                        if (!hayResultados) {
                %>
                    <tr>
                        <td colspan="6" class="text-center">No hay historial disponible.</td>
                    </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<div class='alert alert-danger'>Error al consultar historial: " + e.getMessage() + "</div>");
                    } finally {
                        try { if (rs != null) rs.close(); } catch (Exception e) {}
                        try { if (ps != null) ps.close(); } catch (Exception e) {}
                        try { if (conn != null) conn.close(); } catch (Exception e) {}
                    }
                %>
                </tbody>
            </table>
        </div>
        <a href="menu_admin.jsp" class="btn btn-secondary w-100 mt-3">Volver al menú</a>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>