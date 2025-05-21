<!-- filepath: c:\Users\Vargas Cardenas\Desktop\GestionCitasMedicas\web\gestionar_horarios.jsp -->
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
    <title>Gestionar Horarios</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="imagenes/Logo.png" type="image/png">
    <link rel="stylesheet" href="css/estilos_gestionar_horarios.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5 mb-5" style="max-width: 900px;">
        <h2 class="mb-4 text-center">Gestión de Horarios de Especialistas</h2>
        <% if (request.getAttribute("mensaje") != null) { %>
            <div class="alert alert-info text-center"><%= request.getAttribute("mensaje") %></div>
        <% } %>
        <!-- Formulario para agregar horario -->
        <form method="post" action="GestionarHorariosServlet" class="mb-4 row g-3">
            <div class="col-md-4">
                <label class="form-label">Especialista</label>
                <select class="form-select" name="idEspecialista" required>
                    <option value="">Seleccione...</option>
                    <%
                        Connection conn = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;
                        try {
                            conn = ConexionBD.conectar();
                            String sql = "SELECT u.id, u.nombre, u.apellidos, es.especialidad FROM Usuario u JOIN Especialista es ON u.id = es.id_usuario ORDER BY u.nombre";
                            ps = conn.prepareStatement(sql);
                            rs = ps.executeQuery();
                            while (rs.next()) {
                    %>
                    <option value="<%= rs.getInt("id") %>"><%= rs.getString("nombre") %> <%= rs.getString("apellidos") %> - <%= rs.getString("especialidad") %></option>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("<option disabled>Error al cargar especialistas</option>");
                        } finally {
                            try { if (rs != null) rs.close(); } catch (Exception e) {}
                            try { if (ps != null) ps.close(); } catch (Exception e) {}
                            try { if (conn != null) conn.close(); } catch (Exception e) {}
                        }
                    %>
                </select>
            </div>
            <div class="col-md-2">
                <label class="form-label">Fecha</label>
                <input type="date" class="form-control" name="fecha" required>
            </div>
            <div class="col-md-2">
                <label class="form-label">Hora Inicio</label>
                <input type="time" class="form-control" name="hora_inicio" required>
            </div>
            <div class="col-md-2">
                <label class="form-label">Hora Fin</label>
                <input type="time" class="form-control" name="hora_fin" required>
            </div>
            <div class="col-md-2 d-flex align-items-end">
                <button type="submit" name="accion" value="agregar" class="btn btn-primary w-100">Agregar</button>
            </div>
        </form>
        <!-- Tabla de horarios -->
        <div class="table-responsive">
            <table class="table table-bordered table-hover align-middle">
                <thead class="table-primary">
                    <tr>
                        <th>Especialista</th>
                        <th>Especialidad</th>
                        <th>Fecha</th>
                        <th>Hora Inicio</th>
                        <th>Hora Fin</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    conn = null;
                    ps = null;
                    rs = null;
                    try {
                        conn = ConexionBD.conectar();
                        String sql = "SELECT d.id, d.fecha, d.hora_inicio, d.hora_fin, u.nombre, u.apellidos, es.especialidad " +
                                     "FROM DisponibilidadEspecialista d " +
                                     "JOIN Usuario u ON d.id_especialista = u.id " +
                                     "JOIN Especialista es ON u.id = es.id_usuario " +
                                     "ORDER BY d.fecha DESC, d.hora_inicio ASC";
                        ps = conn.prepareStatement(sql);
                        rs = ps.executeQuery();
                        boolean hayResultados = false;
                        while (rs.next()) {
                            hayResultados = true;
                %>
                    <tr>
                        <td><%= rs.getString("nombre") %> <%= rs.getString("apellidos") %></td>
                        <td><%= rs.getString("especialidad") %></td>
                        <td><%= rs.getDate("fecha") %></td>
                        <td><%= rs.getTime("hora_inicio") %></td>
                        <td><%= rs.getTime("hora_fin") %></td>
                        <td>
                            <form method="post" action="GestionarHorariosServlet" style="display:inline;">
                                <input type="hidden" name="idHorario" value="<%= rs.getInt("id") %>">
                                <button type="submit" name="accion" value="eliminar" class="btn btn-danger btn-sm" onclick="return confirm('¿Eliminar este horario?');">Eliminar</button>
                            </form>
                        </td>
                    </tr>
                <%
                        }
                        if (!hayResultados) {
                %>
                    <tr>
                        <td colspan="6" class="text-center">No hay horarios registrados.</td>
                    </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<div class='alert alert-danger'>Error al consultar horarios: " + e.getMessage() + "</div>");
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