<!-- filepath: c:\Users\Vargas Cardenas\Desktop\GestionCitasMedicas\web\gestionar_citas.jsp -->
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
    <title>Gestionar Citas</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="imagenes/Logo.png" type="image/png">
    <link rel="stylesheet" href="css/estilos_gestionar_citas.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5 mb-5" style="max-width: 1100px;">
        <h2 class="mb-4 text-center">Gestión de Citas</h2>
        <form method="get" class="mb-4 row g-3">
            <div class="col-md-4">
                <label for="estado" class="form-label">Estado</label>
                <select class="form-select" id="estado" name="estado">
                    <option value="">Todos</option>
                    <option value="pendiente" <%= "pendiente".equals(request.getParameter("estado")) ? "selected" : "" %>>Pendiente</option>
                    <option value="confirmada" <%= "confirmada".equals(request.getParameter("estado")) ? "selected" : "" %>>Confirmada</option>
                    <option value="cancelada" <%= "cancelada".equals(request.getParameter("estado")) ? "selected" : "" %>>Cancelada</option>
                    <option value="realizada" <%= "realizada".equals(request.getParameter("estado")) ? "selected" : "" %>>Realizada</option>
                </select>
            </div>
            <div class="col-md-4">
                <label for="fecha" class="form-label">Fecha</label>
                <input type="date" class="form-control" id="fecha" name="fecha" value="<%= request.getParameter("fecha") != null ? request.getParameter("fecha") : "" %>">
            </div>
            <div class="col-md-4 d-flex align-items-end">
                <button type="submit" class="btn btn-primary w-100">Filtrar</button>
            </div>
        </form>
        <%
            String estado = request.getParameter("estado");
            String fecha = request.getParameter("fecha");
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                conn = ConexionBD.conectar();
                String sql = "SELECT c.id, c.fecha_hora, c.motivo, c.estado, " +
                             "pac.nombre AS nombre_paciente, pac.apellidos AS apellidos_paciente, " +
                             "esp.nombre AS nombre_especialista, esp.apellidos AS apellidos_especialista, es.especialidad " +
                             "FROM Cita c " +
                             "JOIN Usuario pac ON c.id_paciente = pac.id " +
                             "JOIN Usuario esp ON c.id_especialista = esp.id " +
                             "JOIN Especialista es ON esp.id = es.id_usuario WHERE 1=1 ";
                if (estado != null && !estado.isEmpty()) {
                    sql += "AND c.estado = ? ";
                }
                if (fecha != null && !fecha.isEmpty()) {
                    sql += "AND DATE(c.fecha_hora) = ? ";
                }
                sql += "ORDER BY c.fecha_hora DESC";
                ps = conn.prepareStatement(sql);
                int idx = 1;
                if (estado != null && !estado.isEmpty()) {
                    ps.setString(idx++, estado);
                }
                if (fecha != null && !fecha.isEmpty()) {
                    ps.setString(idx++, fecha);
                }
                rs = ps.executeQuery();
        %>
        <div class="table-responsive">
            <table class="table table-bordered table-hover align-middle">
                <thead class="table-primary">
                    <tr>
                        <th>ID</th>
                        <th>Fecha y Hora</th>
                        <th>Paciente</th>
                        <th>Especialista</th>
                        <th>Especialidad</th>
                        <th>Motivo</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    boolean hayResultados = false;
                    while (rs.next()) {
                        hayResultados = true;
                %>
                    <tr>
                        <td><%= rs.getInt("id") %></td>
                        <td><%= rs.getTimestamp("fecha_hora") %></td>
                        <td><%= rs.getString("nombre_paciente") %> <%= rs.getString("apellidos_paciente") %></td>
                        <td><%= rs.getString("nombre_especialista") %> <%= rs.getString("apellidos_especialista") %></td>
                        <td><%= rs.getString("especialidad") %></td>
                        <td><%= rs.getString("motivo") %></td>
                        <td>
                            <span class="badge bg-<%= "realizada".equals(rs.getString("estado")) ? "success" : ("cancelada".equals(rs.getString("estado")) ? "danger" : ("confirmada".equals(rs.getString("estado")) ? "info" : "secondary")) %>">
                                <%= rs.getString("estado") %>
                            </span>
                        </td>
                        <td>
                            <% if (!"cancelada".equals(rs.getString("estado"))) { %>
                                <form method="post" action="GestionarCitasServlet" style="display:inline;">
                                    <input type="hidden" name="idCita" value="<%= rs.getInt("id") %>">
                                    <input type="hidden" name="accion" value="cancelar">
                                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('¿Cancelar esta cita?');">Cancelar</button>
                                </form>
                            <% } %>
                            <% if ("confirmada".equals(rs.getString("estado"))) { %>
                                <form method="post" action="GestionarCitasServlet" style="display:inline;">
                                    <input type="hidden" name="idCita" value="<%= rs.getInt("id") %>">
                                    <input type="hidden" name="accion" value="realizar">
                                    <button type="submit" class="btn btn-success btn-sm" onclick="return confirm('¿Marcar como realizada?');">Realizar</button>
                                </form>
                            <% } %>
                        </td>
                    </tr>
                <%
                    }
                    if (!hayResultados) {
                %>
                    <tr>
                        <td colspan="8" class="text-center">No se encontraron citas.</td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
        <%
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error al consultar citas: " + e.getMessage() + "</div>");
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (ps != null) ps.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        %>
        <a href="menu_admin.jsp" class="btn btn-secondary w-100 mt-3">Volver al menú</a>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>