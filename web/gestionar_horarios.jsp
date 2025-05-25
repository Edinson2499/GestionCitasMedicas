<!-- filepath: c:\Users\Vargas Cardenas\Desktop\GestionCitasMedicas\web\gestionar_horarios.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, SQL.ConexionBD" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    if (session.getAttribute("rol") == null || !"administrador".equals(session.getAttribute("rol"))) {
        response.sendRedirect("login_admin.jsp");
        return;
    }
    SimpleDateFormat sdfHora = new SimpleDateFormat("HH:mm");
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
        <h1 class="mb-4 text-center">Gestión de Horarios de Especialistas</h1>
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
            <table class="table-gestionar-horarios">
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
                        <td data-label="Nombre"><%= rs.getString("nombre") %> <%= rs.getString("apellidos") %></td>
                        <td data-label="Especialidad"><%= rs.getString("especialidad") %></td>
                        <td data-label="Fecha"><%= rs.getDate("fecha") %></td>
                        <td data-label="Hora Inicio"><%= sdfHora.format(rs.getTime("hora_inicio")) %></td>
                        <td data-label="Hora Fin"><%= sdfHora.format(rs.getTime("hora_fin")) %></td>
                        <td>
                            <button type="button" class="btn btn-danger btn-sm btn-eliminar-horario" data-id="<%= rs.getInt("id") %>">Eliminar</button>
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
        <a href="menu_admin.jsp" class="btn-back" title="Volver al menú de administración"></a>
    </div>
    <div id="modalEliminarHorario" class="modal" style="display:none;">
        <div class="contenido-modal">
            <h2>Confirmar eliminación</h2>
            <p>¿Seguro que deseas eliminar este horario?</p>
            <div class="buttonGroup">
                <button class="btn btn-danger" id="btnConfirmarEliminar">Eliminar</button>
                <button class="btn btn-secondary" id="btnCancelarEliminar">Cancelar</button>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
let idHorarioEliminar = null;

document.addEventListener("DOMContentLoaded", function() {
    document.querySelectorAll('.btn-eliminar-horario').forEach(function(btn) {
        btn.addEventListener('click', function() {
            idHorarioEliminar = this.getAttribute('data-id');
            document.getElementById('modalEliminarHorario').style.display = 'flex';
        });
    });

    document.getElementById('btnCancelarEliminar').onclick = function() {
        document.getElementById('modalEliminarHorario').style.display = 'none';
        idHorarioEliminar = null;
    };

    document.getElementById('btnConfirmarEliminar').onclick = function() {
        if (idHorarioEliminar) {
            let form = document.createElement('form');
            form.method = 'post';
            form.action = 'GestionarHorariosServlet';

            let inputId = document.createElement('input');
            inputId.type = 'hidden';
            inputId.name = 'idHorario';
            inputId.value = idHorarioEliminar;
            form.appendChild(inputId);

            let inputAccion = document.createElement('input');
            inputAccion.type = 'hidden';
            inputAccion.name = 'accion';
            inputAccion.value = 'eliminar';
            form.appendChild(inputAccion);

            document.body.appendChild(form);
            form.submit();
        }
    };
});
</script>
</body>
</html>