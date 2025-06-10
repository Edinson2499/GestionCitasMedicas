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
    <link rel="icon" href="imagenes/Logo.svg" type="image/svg+xml">
    <link rel="stylesheet" href="css/estilos_gestionar_historial.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5 mb-5" style="max-width: 1100px;">
        <h1 class="mb-4 text-center">Historial Médico de Pacientes</h1>
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
            <table class="tabla-gestionar-hitorial">
                <thead class="table-primary">
                    <tr>
                        <th>Paciente</th>
                        <th>Fecha y Hora</th>
                        <th>Especialista</th>
                        <th>Especialidad</th>
                        <th>Motivo</th>
                        <th>Descripción</th>
                        <th>Estado</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    conn = null;
                    ps = null;
                    rs = null;
                    int limit = 10;
                    int pageNum = 1;
                    if (request.getParameter("page") != null) {
                        try {
                            pageNum = Integer.parseInt(request.getParameter("page"));
                            if (pageNum < 1) pageNum = 1;
                        } catch (Exception e) { pageNum = 1; }
                    }
                    int offset = (pageNum - 1) * limit;
                    String idPaciente = request.getParameter("idPaciente");
                    int totalRegistros = 0;
                    try {
                        conn = ConexionBD.conectar();
                        String countSql = "SELECT COUNT(*) FROM Cita c WHERE (c.estado = 'realizada' OR c.estado = 'cancelada') ";
                        if (idPaciente != null && !idPaciente.isEmpty()) {
                            countSql += "AND c.id_paciente = ? ";
                        }
                        PreparedStatement psCount = conn.prepareStatement(countSql);
                        if (idPaciente != null && !idPaciente.isEmpty()) {
                            psCount.setInt(1, Integer.parseInt(idPaciente));
                        }
                        ResultSet rsCount = psCount.executeQuery();
                        if (rsCount.next()) {
                            totalRegistros = rsCount.getInt(1);
                        }
                        rsCount.close();
                        psCount.close();
                    } catch (Exception e) { totalRegistros = 0; }
                    int totalPaginas = (int) Math.ceil((double) totalRegistros / limit);
                    try {
                        conn = ConexionBD.conectar();
                        String sql = "SELECT c.fecha_hora, c.motivo, c.descripcion, c.estado, " +
                                     "pac.nombre AS nombre_paciente, pac.apellidos AS apellidos_paciente, " +
                                     "esp.nombre AS nombre_especialista, esp.apellidos AS apellidos_especialista, es.especialidad " +
                                     "FROM Cita c " +
                                     "JOIN Usuario pac ON c.id_paciente = pac.id " +
                                     "JOIN Usuario esp ON c.id_especialista = esp.id " +
                                     "JOIN Especialista es ON esp.id = es.id_usuario " +
                                     "WHERE (c.estado = 'realizada' OR c.estado = 'cancelada') ";
                        if (idPaciente != null && !idPaciente.isEmpty()) {
                            sql += "AND c.id_paciente = ? ";
                        }
                        sql += "ORDER BY c.fecha_hora DESC LIMIT ? OFFSET ?";
                        ps = conn.prepareStatement(sql);
                        int idx = 1;
                        if (idPaciente != null && !idPaciente.isEmpty()) {
                            ps.setInt(idx++, Integer.parseInt(idPaciente));
                        }
                        ps.setInt(idx++, limit);
                        ps.setInt(idx++, offset);
                        rs = ps.executeQuery();
                        boolean hayResultados = false;
                        while (rs.next()) {
                            hayResultados = true;
                %>
                    <tr>
                        <td><%= rs.getString("nombre_paciente") %> <%= rs.getString("apellidos_paciente") %></td>
                        <td data-label="Fecha"><%= rs.getTimestamp("fecha_hora") %></td>
                        <td data-label="Especialista"><%= rs.getString("nombre_especialista") %> <%= rs.getString("apellidos_especialista") %></td>
                        <td data-label="Especialidad"><%= rs.getString("especialidad") %></td>
                        <td data-label="Motivo"><%= rs.getString("motivo") %></td>
                        <td data-label="Descripción"><%= rs.getString("descripcion") != null ? rs.getString("descripcion") : "-" %></td>
                        <td data-label="Estado">
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
                        <td colspan="7" class="text-center">No hay historial disponible.</td>
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
        <!-- Controles de paginación -->
        <div class="d-flex justify-content-center align-items-center my-3">
            <nav aria-label="Paginación">
                <ul class="pagination">
                    <li class="page-item <%= (pageNum <= 1) ? "disabled" : "" %>">
                        <a class="page-link" href="gestionar_historial.jsp?idPaciente=<%= idPaciente != null ? idPaciente : "" %>&page=<%= (pageNum-1) %>">Anterior</a>
                    </li>
                    <% for (int i = 1; i <= totalPaginas; i++) { %>
                        <li class="page-item <%= (i == pageNum) ? "active" : "" %>">
                            <a class="page-link" href="gestionar_historial.jsp?idPaciente=<%= idPaciente != null ? idPaciente : "" %>&page=<%= i %>"><%= i %></a>
                        </li>
                    <% } %>
                    <li class="page-item <%= (pageNum >= totalPaginas) ? "disabled" : "" %>">
                        <a class="page-link" href="gestionar_historial.jsp?idPaciente=<%= idPaciente != null ? idPaciente : "" %>&page=<%= (pageNum+1) %>">Siguiente</a>
                    </li>
                </ul>
            </nav>
        </div>
        <a href="menu_admin.jsp" class="btn-back" title="Volver al menú de administración"></a>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>