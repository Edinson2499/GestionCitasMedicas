<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection,java.sql.PreparedStatement,java.sql.ResultSet" %>
<%
    if (session.getAttribute("idUsuario") == null || !"especialista".equals(session.getAttribute("rol"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    Integer idEspecialista = (Integer) session.getAttribute("idUsuario");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Generar Reportes de Citas</title>
    <link rel="stylesheet" href="css/estilos_generar_reportes.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>

<div class="reporte-container container my-5">

    <!-- Título -->
    <h1 class="text-center mb-4">Generar Reportes de Citas</h1>

    <!-- Formulario para seleccionar fechas y estado -->
    <form method="get" class="mb-5">
        <div class="row g-3 align-items-end">
            <div class="col-md-4">
                <label for="fecha_inicio" class="form-label">Fecha Inicio:</label>
                <input type="date" class="form-control" id="fecha_inicio" name="fecha_inicio"
                    value="<%= request.getParameter("fecha_inicio") != null ? request.getParameter("fecha_inicio") : "" %>" required />
            </div>
            <div class="col-md-4">
                <label for="fecha_fin" class="form-label">Fecha Fin:</label>
                <input type="date" class="form-control" id="fecha_fin" name="fecha_fin"
                    value="<%= request.getParameter("fecha_fin") != null ? request.getParameter("fecha_fin") : "" %>" required />
            </div>
            <div class="col-md-4">
                <label for="estado" class="form-label">Estado de la cita:</label>
                <select class="form-select" id="estado" name="estado" required>
                    <option value="" <%= "".equals(request.getParameter("estado")) ? "selected" : "" %>>Todos</option>
                    <option value="pendiente" <%= "pendiente".equals(request.getParameter("estado")) ? "selected" : "" %>>Pendiente</option>
                    <option value="confirmada" <%= "confirmada".equals(request.getParameter("estado")) ? "selected" : "" %>>Confirmada</option>
                    <option value="cancelada" <%= "cancelada".equals(request.getParameter("estado")) ? "selected" : "" %>>Cancelada</option>
                    <option value="realizada" <%= "realizada".equals(request.getParameter("estado")) ? "selected" : "" %>>Realizada</option>
                </select>
            </div>
        </div>
        <div class="mt-4 text-center">
            <button type="submit" class="btn btn-primary w-100">Generar Reporte</button>
        </div>
    </form>

    <!-- Sección para mostrar resultados -->
    <%
        String fechaInicio = request.getParameter("fecha_inicio");
        String fechaFin = request.getParameter("fecha_fin");
        String estado = request.getParameter("estado");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean mostrarTabla = fechaInicio != null && fechaFin != null && !fechaInicio.isEmpty() && !fechaFin.isEmpty();
        if (mostrarTabla) {
            try {
                conn = SQL.ConexionBD.conectar();
                String sql = "SELECT c.fecha_hora, c.motivo, c.estado, u.nombre AS nombre_paciente, u.apellidos AS apellidos_paciente " +
                             "FROM Cita c " +
                             "JOIN Usuario u ON c.id_paciente = u.id " +
                             "WHERE c.id_especialista = ? AND DATE(c.fecha_hora) BETWEEN ? AND ? ";
                if (estado != null && !estado.isEmpty()) {
                    sql += "AND c.estado = ? ";
                }
                sql += "ORDER BY c.fecha_hora DESC";
                ps = conn.prepareStatement(sql);
                ps.setInt(1, idEspecialista);
                ps.setString(2, fechaInicio);
                ps.setString(3, fechaFin);
                if (estado != null && !estado.isEmpty()) {
                    ps.setString(4, estado);
                }
                rs = ps.executeQuery();
    %>
    <div id="resultado_reporte" class="mb-5">
        <h2 class="mb-3">Reporte de Citas</h2>
        <div class="table-responsive">
            <table class="table-reporte-citas">
                <thead class="table-primary">
                    <tr>
                        <th>Fecha</th>
                        <th>Hora</th>
                        <th>Paciente</th>
                        <th>Motivo</th>
                        <th>Estado</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        boolean hayResultados = false;
                        while (rs.next()) {
                            hayResultados = true;
                            java.sql.Timestamp ts = rs.getTimestamp("fecha_hora");
                            String fecha = new java.text.SimpleDateFormat("dd/MM/yyyy").format(ts);
                            String hora = new java.text.SimpleDateFormat("HH:mm").format(ts);
                    %>
                    <tr>
                        <td data-label="Fecha"><%= fecha %></td>
                        <td data-label="Hora"><%= hora %></td>
                        <td data-label="Paciente"><%= rs.getString("nombre_paciente") %> <%= rs.getString("apellidos_paciente") %></td>
                        <td data-label="Motivo"><%= rs.getString("motivo") %></td>
                        <td data-label="Estado">
                            <span class="badge bg-<%= "realizada".equals(rs.getString("estado")) ? "success" : ("cancelada".equals(rs.getString("estado")) ? "danger" : ("confirmada".equals(rs.getString("estado")) ? "primary" : "secondary")) %> text-capitalize">
                                <%= rs.getString("estado") %>
                            </span>
                        </td>
                    </tr>
                    <%
                        }
                        if (!hayResultados) {
                    %>
                    <tr>
                        <td colspan="5" class="text-center fst-italic text-muted">No hay citas que mostrar para este rango de fechas y estado.</td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
    <%
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error al generar el reporte: " + e.getMessage() + "</div>");
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (ps != null) ps.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        }
    %>

    <!-- Procesar actualización de cita si se envió el formulario -->
    <%
        String accion = request.getParameter("accion");
        if ("actualizar".equals(accion)) {
            String idCita = request.getParameter("id_cita");
            String descripcion = request.getParameter("descripcion");
            String nuevoEstado = request.getParameter("nuevo_estado");
            if (idCita != null && ( "cancelada".equals(nuevoEstado) || "realizada".equals(nuevoEstado) )) {
                Connection conn2 = null;
                PreparedStatement ps2 = null;
                try {
                    conn2 = SQL.ConexionBD.conectar();
                    String sqlUpdate = "UPDATE Cita SET estado = ?, descripcion = ? WHERE id = ?";
                    ps2 = conn2.prepareStatement(sqlUpdate);
                    ps2.setString(1, nuevoEstado);
                    ps2.setString(2, descripcion);
                    ps2.setInt(3, Integer.parseInt(idCita));
                    ps2.executeUpdate();
                    out.println("<div class='alert alert-success'>Cita actualizada correctamente.</div>");
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger'>Error al actualizar la cita: " + e.getMessage() + "</div>");
                } finally {
                    try { if (ps2 != null) ps2.close(); } catch (Exception e) {}
                    try { if (conn2 != null) conn2.close(); } catch (Exception e) {}
                }
            }
        }
    %>
    <!-- Sección para mostrar solo citas pendientes y permitir actualizar -->
    <%
        // Solo mostrar citas pendientes
        Connection connPend = null;
        PreparedStatement psPend = null;
        ResultSet rsPend = null;
        try {
            connPend = SQL.ConexionBD.conectar();
            String sql = "SELECT c.id, c.fecha_hora, c.motivo, c.descripcion, u.nombre AS nombre_paciente, u.apellidos AS apellidos_paciente " +
                         "FROM Cita c " +
                         "JOIN Usuario u ON c.id_paciente = u.id " +
                         "WHERE c.id_especialista = ? AND c.estado = 'pendiente' " +
                         "ORDER BY c.fecha_hora ASC";
            psPend = connPend.prepareStatement(sql);
            psPend.setInt(1, idEspecialista);
            rsPend = psPend.executeQuery();
    %>
<div id="citas_pendientes" class="mb-5">
    <h2 class="mb-3">Citas Pendientes</h2>
    <div class="table-responsive">
        <table class="table-reporte-citas">
            <thead class="table-warning">
                <tr>
                    <th>Fecha</th>
                    <th>Hora</th>
                    <th>Paciente</th>
                    <th>Motivo</th>
                    <th>Descripción</th>
                    <th>Acción</th>
                </tr>
            </thead>
            <tbody>
                <%
                    boolean hayPendientes = false;
                    while (rsPend.next()) {
                        hayPendientes = true;
                        java.sql.Timestamp ts = rsPend.getTimestamp("fecha_hora");
                        String fecha = new java.text.SimpleDateFormat("dd/MM/yyyy").format(ts);
                        String hora = new java.text.SimpleDateFormat("HH:mm").format(ts);
                %>
                <tr>
                    <form method="post">
                        <td><%= fecha %></td>
                        <td><%= hora %></td>
                        <td><%= rsPend.getString("nombre_paciente") %> <%= rsPend.getString("apellidos_paciente") %></td>
                        <td><%= rsPend.getString("motivo") %></td>
                        <td>
                            <textarea name="descripcion" class="form-control" rows="2" required><%= rsPend.getString("descripcion") != null ? rsPend.getString("descripcion") : "" %></textarea>
                        </td>
                        <td>
                            <input type="hidden" name="id_cita" value="<%= rsPend.getInt("id") %>"/>
                            <input type="hidden" name="accion" value="actualizar"/>
                            <select name="nuevo_estado" class="form-select mb-2" required>
                                <option value="">Seleccionar</option>
                                <option value="realizada">Marcar como Realizada</option>
                                <option value="cancelada">Marcar como Cancelada</option>
                            </select>
                            <button type="submit" class="btn btn-success btn-sm w-100">Actualizar</button>
                        </td>
                    </form>
                </tr>
                <%
                    }
                    if (!hayPendientes) {
                %>
                <tr>
                    <td colspan="6" class="text-center fst-italic text-muted">No hay citas pendientes.</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</div>
<%
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error al mostrar citas pendientes: " + e.getMessage() + "</div>");
        } finally {
            try { if (rsPend != null) rsPend.close(); } catch (Exception e) {}
            try { if (psPend != null) psPend.close(); } catch (Exception e) {}
            try { if (connPend != null) connPend.close(); } catch (Exception e) {}
        }
    %>

</div>

<!-- Botón Volver -->
<div class="container mb-5">
    <a href="menu_especialista.jsp" class="btn-back" title="Volver al menú de Especialista"></a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
