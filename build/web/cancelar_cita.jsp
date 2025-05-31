<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, SQL.ConexionBD" %>
<%
    Integer idPaciente = (Integer) session.getAttribute("idUsuario");
    String rol = (String) session.getAttribute("rol");
    if (idPaciente == null || rol == null || !"paciente".equals(rol)) {
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
    <link rel="icon" href="imagenes/Logo.svg" type="image/svg+xml">
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
        // Declarar variables fuera de los bloques try para que estén disponibles en todos los finally
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int limit = 10;
        int pageNum = 1;
        int offset = 0;
        int totalRegistros = 0;
        int totalPaginas = 0;
        try {
            if (request.getParameter("page") != null) {
                try {
                    pageNum = Integer.parseInt(request.getParameter("page"));
                    if (pageNum < 1) pageNum = 1;
                } catch (Exception e) { pageNum = 1; }
            }
            offset = (pageNum - 1) * limit;
            conn = ConexionBD.conectar();
            String countSql = "SELECT COUNT(*) FROM Cita WHERE id_paciente = ? AND estado = 'pendiente' AND fecha_hora >= NOW()";
            PreparedStatement psCount = conn.prepareStatement(countSql);
            psCount.setInt(1, idPaciente);
            ResultSet rsCount = psCount.executeQuery();
            if (rsCount.next()) {
                totalRegistros = rsCount.getInt(1);
            }
            rsCount.close();
            psCount.close();
            totalPaginas = (int) Math.ceil((double) totalRegistros / limit);

            // --- INICIO BLOQUE PRINCIPAL DE CONSULTA Y RENDERIZADO ---
            ps = conn.prepareStatement(
                "SELECT c.id, c.fecha_hora, c.motivo, es.especialidad, u.nombre AS nombre_especialista, u.apellidos AS apellidos_especialista " +
                "FROM Cita c " +
                "JOIN Usuario u ON c.id_especialista = u.id " +
                "JOIN Especialista es ON u.id = es.id_usuario " +
                "WHERE c.id_paciente = ? AND c.estado = 'pendiente' AND c.fecha_hora >= NOW() " +
                "ORDER BY c.fecha_hora ASC LIMIT ? OFFSET ?"
            );
            ps.setInt(1, idPaciente);
            ps.setInt(2, limit);
            ps.setInt(3, offset);
            rs = ps.executeQuery();
            if (!rs.isBeforeFirst()) {
    %>
                <p class="no-citas">No tienes citas pendientes para cancelar.</p>
    <%
            } else {
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
                        <li><p><strong>Motivo:</strong> <%= rs.getString("motivo") %></p></li>
                    </ul>
                    <button type="button" class="btn btn-danger btnCancelar" data-id="<%= rs.getInt("id") %>">Cancelar</button>
                </div>
    <%
                }
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
    <!-- Modal personalizado para cancelar cita -->
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
    <div class="d-flex justify-content-center align-items-center my-3">
        <nav aria-label="Paginación">
            <ul class="pagination">
                <li class="page-item <%= (pageNum <= 1) ? "disabled" : "" %>">
                    <a class="page-link" href="cancelar_cita.jsp?page=<%= (pageNum-1) %>">Anterior</a>
                </li>
                <% for (int i = 1; i <= totalPaginas; i++) { %>
                    <li class="page-item <%= (i == pageNum) ? "active" : "" %>">
                        <a class="page-link" href="cancelar_cita.jsp?page=<%= i %>"><%= i %></a>
                    </li>
                <% } %>
                <li class="page-item <%= (pageNum >= totalPaginas) ? "disabled" : "" %>">
                    <a class="page-link" href="cancelar_cita.jsp?page=<%= (pageNum+1) %>">Siguiente</a>
                </li>
            </ul>
        </nav>
    </div>
    </main>
    <a href="menu_paciente.jsp" class="btn-back" title="Volver al menú de Paciente"></a>
    <!-- Bootstrap JS Bundle CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.querySelectorAll('.btnCancelar').forEach(button => {
            button.addEventListener('click', function() {
                const idCita = this.getAttribute('data-id');
                document.getElementById('btnConfirmarCancelar').setAttribute('data-id', idCita);
                document.getElementById('modalCancelarCita').style.display = 'flex';
            });
        });

        document.getElementById('btnCancelarCancelar').addEventListener('click', function() {
            document.getElementById('modalCancelarCita').style.display = 'none';
        });

        document.getElementById('btnConfirmarCancelar').addEventListener('click', function() {
            const idCita = this.getAttribute('data-id');
            const form = document.createElement('form');
            form.method = 'post';
            form.action = 'CancelarCitaServlet';
            const hiddenField = document.createElement('input');
            hiddenField.type = 'hidden';
            hiddenField.name = 'idCita';
            hiddenField.value = idCita;
            form.appendChild(hiddenField);
            document.body.appendChild(form);
            form.submit();
        });
    </script>
</body>
</html>