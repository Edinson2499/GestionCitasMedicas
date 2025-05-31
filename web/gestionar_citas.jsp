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
    <link rel="icon" href="imagenes/Logo.svg" type="image/svg+xml">
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
                conn = ConexionBD.conectar();
                String countSql = "SELECT COUNT(*) FROM Cita c JOIN Usuario pac ON c.id_paciente = pac.id JOIN Usuario esp ON c.id_especialista = esp.id JOIN Especialista es ON esp.id = es.id_usuario WHERE 1=1 ";
                if (estado != null && !estado.isEmpty()) {
                    countSql += "AND c.estado = ? ";
                }
                if (fecha != null && !fecha.isEmpty()) {
                    countSql += "AND DATE(c.fecha_hora) = ? ";
                }
                PreparedStatement psCount = conn.prepareStatement(countSql);
                int idxCount = 1;
                if (estado != null && !estado.isEmpty()) {
                    psCount.setString(idxCount++, estado);
                }
                if (fecha != null && !fecha.isEmpty()) {
                    psCount.setString(idxCount++, fecha);
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
                sql += "ORDER BY c.fecha_hora DESC LIMIT ? OFFSET ?";
                ps = conn.prepareStatement(sql);
                int idx = 1;
                if (estado != null && !estado.isEmpty()) {
                    ps.setString(idx++, estado);
                }
                if (fecha != null && !fecha.isEmpty()) {
                    ps.setString(idx++, fecha);
                }
                ps.setInt(idx++, limit);
                ps.setInt(idx++, offset);
                rs = ps.executeQuery();
        %>
        <div class="table-responsive">
            <table class="tabla-editar-usuario">
                <thead>
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
                        <td data-label="ID"><%= rs.getInt("id") %></td>
                        <td data-label="Fecha"><%= rs.getTimestamp("fecha_hora") %></td>
                        <td data-label="Paciente"><%= rs.getString("nombre_paciente") %> <%= rs.getString("apellidos_paciente") %></td>
                        <td data-label="Especialista"><%= rs.getString("nombre_especialista") %> <%= rs.getString("apellidos_especialista") %></td>
                        <td data-label="Especialidad"><%= rs.getString("especialidad") %></td>
                        <td data-label="Motivo"><%= rs.getString("motivo") %></td>
                        <td data-label="Estado">
                            <span class="badge bg-<%= "realizada".equals(rs.getString("estado")) ? "success" : ("cancelada".equals(rs.getString("estado")) ? "danger" : ("confirmada".equals(rs.getString("estado")) ? "info" : "secondary")) %>">
                                <%= rs.getString("estado") %>
                            </span>
                        </td>
                        <td>
                            <% if (!"cancelada".equals(rs.getString("estado")) && !"realizada".equals(rs.getString("estado"))) { %>
                                <button type="button" class="btn btn-danger btn-sm btn-cancelar-modal" data-id="<%= rs.getInt("id") %>">Cancelar</button>
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
        <!-- Controles de paginación -->
        <div class="d-flex justify-content-center align-items-center my-3">
            <nav aria-label="Paginación">
                <ul class="pagination">
                    <li class="page-item <%= (pageNum <= 1) ? "disabled" : "" %>">
                        <a class="page-link" href="gestionar_citas.jsp?estado=<%= estado != null ? estado : "" %>&fecha=<%= fecha != null ? fecha : "" %>&page=<%= (pageNum-1) %>">Anterior</a>
                    </li>
                    <% for (int i = 1; i <= totalPaginas; i++) { %>
                        <li class="page-item <%= (i == pageNum) ? "active" : "" %>">
                            <a class="page-link" href="gestionar_citas.jsp?estado=<%= estado != null ? estado : "" %>&fecha=<%= fecha != null ? fecha : "" %>&page=<%= i %>"><%= i %></a>
                        </li>
                    <% } %>
                    <li class="page-item <%= (pageNum >= totalPaginas) ? "disabled" : "" %>">
                        <a class="page-link" href="gestionar_citas.jsp?estado=<%= estado != null ? estado : "" %>&fecha=<%= fecha != null ? fecha : "" %>&page=<%= (pageNum+1) %>">Siguiente</a>
                    </li>
                </ul>
            </nav>
        </div>

        <!-- Modal para cancelar cita -->
        <div id="modalCancelarCita" class="modal" style="display:none;">
            <div class="contenido-modal">
                <h2>Confirmar cancelación</h2>
                <p>¿Seguro que deseas cancelar esta cita?</p>
                <div class="buttonGroup">
                    <button class="btn btn-danger" id="btnConfirmarCancelar">Cancelar cita</button>
                    <button class="btn btn-secondary" id="btnCancelarCancelar">No cancelar</button>
                </div>
            </div>
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
        <a href="menu_admin.jsp" class="btn-back" title="Volver al menú de Administrador"></a>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    let idCitaCancelar = null;

    document.addEventListener("DOMContentLoaded", function() {
        document.querySelectorAll('.btn-cancelar-modal').forEach(function(btn) {
            btn.addEventListener('click', function() {
                idCitaCancelar = this.getAttribute('data-id');
                document.getElementById('modalCancelarCita').style.display = 'flex';
            });
        });

        document.getElementById('btnCancelarCancelar').onclick = function() {
            document.getElementById('modalCancelarCita').style.display = 'none';
            idCitaCancelar = null;
        };

        document.getElementById('btnConfirmarCancelar').onclick = function() {
            if (idCitaCancelar) {
                // Crear y enviar el formulario para cancelar la cita
                let form = document.createElement('form');
                form.method = 'post';
                form.action = 'GestionarCitasServlet';

                let inputId = document.createElement('input');
                inputId.type = 'hidden';
                inputId.name = 'idCita';
                inputId.value = idCitaCancelar;
                form.appendChild(inputId);

                let inputAccion = document.createElement('input');
                inputAccion.type = 'hidden';
                inputAccion.name = 'accion';
                inputAccion.value = 'cancelar';
                form.appendChild(inputAccion);

                document.body.appendChild(form);
                form.submit();
            }
        };
    });
    </script>
</body>
</html>