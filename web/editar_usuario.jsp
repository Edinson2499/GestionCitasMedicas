<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("rol") == null || !"administrador".equals(session.getAttribute("rol"))) {
        response.sendRedirect("login_admin.jsp");
        return;
    }

    String filtroNombre = request.getParameter("filtroNombre") != null ? request.getParameter("filtroNombre") : "";
    String filtroApellido = request.getParameter("filtroApellido") != null ? request.getParameter("filtroApellido") : "";
    String filtroTipo = request.getParameter("filtroTipo") != null ? request.getParameter("filtroTipo") : "";

    Connection conexion = null;
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
        conexion = SQL.ConexionBD.conectar();
        String countSql = "SELECT COUNT(*) FROM Usuario u LEFT JOIN Especialista e ON u.id = e.id_usuario WHERE 1=1";
        if (!filtroNombre.isEmpty()) {
            countSql += " AND u.nombre LIKE ?";
        }
        if (!filtroApellido.isEmpty()) {
            countSql += " AND u.apellidos LIKE ?";
        }
        if (!filtroTipo.isEmpty()) {
            countSql += " AND u.tipo_usuario = ?";
        }
        PreparedStatement psCount = conexion.prepareStatement(countSql);
        int idxCount = 1;
        if (!filtroNombre.isEmpty()) {
            psCount.setString(idxCount++, "%" + filtroNombre + "%");
        }
        if (!filtroApellido.isEmpty()) {
            psCount.setString(idxCount++, "%" + filtroApellido + "%");
        }
        if (!filtroTipo.isEmpty()) {
            psCount.setString(idxCount++, filtroTipo);
        }
        ResultSet rsCount = psCount.executeQuery();
        if (rsCount.next()) {
            totalRegistros = rsCount.getInt(1);
        }
        rsCount.close();
        psCount.close();
    } catch (Exception e) { totalRegistros = 0; }
    int totalPaginas = (int) Math.ceil((double) totalRegistros / limit);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Editar Usuario</title>
    <link rel="stylesheet" href="css/estilos_editar_usuario.css">
    <link rel="icon" href="imagenes/Logo.svg" type="image/svg+xml">
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <h1>Editar Usuario</h1>
    <form method="get" action="editar_usuario.jsp" class="mb-4">
        <div class="form-group mb-2">
            <label for="filtroNombre">Nombre:</label>
            <input type="text" id="filtroNombre" name="filtroNombre" value="<%= filtroNombre %>">
        </div>
        <div class="form-group mb-2">
            <label for="filtroApellido">Apellido:</label>
            <input type="text" id="filtroApellido" name="filtroApellido" value="<%= filtroApellido %>">
        </div>
        <div class="form-group mb-2">
            <label for="filtroTipo">Tipo de Usuario:</label>
            <select id="filtroTipo" name="filtroTipo">
                <option value="" <%= filtroTipo.equals("") ? "selected" : "" %>>Todos</option>
                <option value="paciente" <%= filtroTipo.equals("paciente") ? "selected" : "" %>>Paciente</option>
                <option value="especialista" <%= filtroTipo.equals("especialista") ? "selected" : "" %>>Especialista</option>
                <option value="administrador" <%= filtroTipo.equals("administrador") ? "selected" : "" %>>Administrador</option>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Buscar</button>
    </form>

    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conexion = SQL.ConexionBD.conectar();
            String sql = "SELECT u.id, u.nombre, u.apellidos, u.tipo_usuario, u.contrasena, u.telefono, u.direccion, u.correo, u.usuario_generado, e.especialidad " +
                         "FROM Usuario u LEFT JOIN Especialista e ON u.id = e.id_usuario WHERE 1=1";
            if (!filtroNombre.isEmpty()) {
                sql += " AND u.nombre LIKE ?";
            }
            if (!filtroApellido.isEmpty()) {
                sql += " AND u.apellidos LIKE ?";
            }
            if (!filtroTipo.isEmpty()) {
                sql += " AND u.tipo_usuario = ?";
            }
            sql += " LIMIT ? OFFSET ?";
            ps = conexion.prepareStatement(sql);
            int idx = 1;
            if (!filtroNombre.isEmpty()) {
                ps.setString(idx++, "%" + filtroNombre + "%");
            }
            if (!filtroApellido.isEmpty()) {
                ps.setString(idx++, "%" + filtroApellido + "%");
            }
            if (!filtroTipo.isEmpty()) {
                ps.setString(idx++, filtroTipo);
            }
            ps.setInt(idx++, limit);
            ps.setInt(idx++, offset);
            rs = ps.executeQuery();
            if (rs.next()) { // Cambia aquí: usamos rs.next() para el do-while
    %>
    <h2>Resultados de la Búsqueda</h2>
    <div class="table-responsive">
        <table class="tabla-editar-usuario">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Apellido</th>
                    <th>Tipo de Usuario</th>
                    <th>Contraseña</th>
                    <th>Especialidad</th>
                    <th>Teléfono</th>
                    <th>Dirección</th>
                    <th>Correo</th>
                    <th>Usuario Generado</th>
                    <th>Acción</th>
                </tr>
            </thead>
            <tbody>
<%
    do {
%>
    <tr>
        <td data-label="ID"><%= rs.getInt("id") %></td>
        <td data-label="Nombre"><%= rs.getString("nombre") %></td>
        <td data-label="Apellido"><%= rs.getString("apellidos") %></td>
        <td data-label="Tipo de Usuario"><%= rs.getString("tipo_usuario") %></td>
        <td data-label="Contraseña">********</td>
        <td data-label="Especialidad"><%= rs.getString("especialidad") != null ? rs.getString("especialidad") : "-" %></td>
        <td data-label="Teléfono"><%= rs.getString("telefono") != null ? rs.getString("telefono") : "-" %></td>
        <td data-label="Dirección"><%= rs.getString("direccion") != null ? rs.getString("direccion") : "-" %></td>
        <td data-label="Correo"><%= rs.getString("correo") != null ? rs.getString("correo") : "-" %></td>
        <td data-label="Usuario Generado"><%= rs.getString("usuario_generado") != null ? rs.getString("usuario_generado") : "-" %></td>
        <td data-label="Acción">
            <% 
                int idUsuarioListado = rs.getInt("id");
                String usuarioGeneradoListado = rs.getString("usuario_generado");
                Integer idSesion = (Integer) session.getAttribute("idUsuario");
                String usuarioGeneradoSesion = (String) session.getAttribute("usuario_generado");
                boolean esAdmin01Listado = idUsuarioListado == 1 && "admin01".equals(usuarioGeneradoListado);
                boolean esAdmin01Sesion = idSesion != null && idSesion == 1 && "admin01".equals(usuarioGeneradoSesion);
                if (!esAdmin01Listado || (esAdmin01Listado && esAdmin01Sesion)) {
            %>
                <a href="EditarUsuarioServlet?id=<%= rs.getInt("id") %>">Editar</a> |
                <a href="#" class="btn-eliminar" data-id="<%= rs.getInt("id") %>">Eliminar</a>
            <% } else { %>
                <span style="color:gray;">No permitido</span>
            <% } %>
        </td>
    </tr>
<%
    } while (rs.next());
%>
</tbody>
        </table>
    </div>
    <!-- Controles de paginación -->
    <div class="d-flex justify-content-center align-items-center my-3">
        <nav aria-label="Paginación">
            <ul class="pagination">
                <li class="page-item <%= (pageNum <= 1) ? "disabled" : "" %>">
                    <a class="page-link" href="editar_usuario.jsp?filtroNombre=<%= filtroNombre %>&filtroApellido=<%= filtroApellido %>&filtroTipo=<%= filtroTipo %>&page=<%= (pageNum-1) %>">Anterior</a>
                </li>
                <% for (int i = 1; i <= totalPaginas; i++) { %>
                    <li class="page-item <%= (i == pageNum) ? "active" : "" %>">
                        <a class="page-link" href="editar_usuario.jsp?filtroNombre=<%= filtroNombre %>&filtroApellido=<%= filtroApellido %>&filtroTipo=<%= filtroTipo %>&page=<%= i %>"><%= i %></a>
                    </li>
                <% } %>
                <li class="page-item <%= (pageNum >= totalPaginas) ? "disabled" : "" %>">
                    <a class="page-link" href="editar_usuario.jsp?filtroNombre=<%= filtroNombre %>&filtroApellido=<%= filtroApellido %>&filtroTipo=<%= filtroTipo %>&page=<%= (pageNum+1) %>">Siguiente</a>
                </li>
            </ul>
        </nav>
    </div>
<%
    } else {
%>
    <div class="alert alert-info">No se encontraron usuarios con los criterios indicados.</div>
<%
    }
} catch (Exception e) {
%>
    <div class='alert alert-danger'>Error al consultar usuarios: <%= e.getMessage() %></div>
<%
} finally {
    try { if (rs != null) rs.close(); } catch (Exception e) {}
    try { if (ps != null) ps.close(); } catch (Exception e) {}
    try { if (conexion != null) conexion.close(); } catch (Exception e) {}
}
%>
    <a href="menu_admin.jsp" class="btn-back" title="Volver al menú"></a>

    <!-- Modal personalizado para eliminar usuario -->
    <div id="modalEliminar" class="modal" style="display:none;">
        <div class="contenido-modal">
            <h2>Confirmar eliminación</h2>
            <p>¿Estás seguro de que deseas eliminar este usuario?</p>
            <div class="buttonGroup">
                <button class="btn btn-danger" id="btnConfirmarEliminar">Eliminar</button>
                <button class="btn btn-secondary" id="btnCancelarEliminar">Cancelar</button>
            </div>
        </div>
    </div>

    <script>
let idUsuarioEliminar = null;

document.addEventListener("DOMContentLoaded", function() {
    // Asigna evento a todos los botones de eliminar
    document.querySelectorAll('.btn-eliminar').forEach(function(btn) {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            idUsuarioEliminar = this.getAttribute('data-id');
            document.getElementById('modalEliminar').style.display = 'flex';
        });
    });

    document.getElementById('btnCancelarEliminar').onclick = function() {
        document.getElementById('modalEliminar').style.display = 'none';
        idUsuarioEliminar = null;
    };

    document.getElementById('btnConfirmarEliminar').onclick = function() {
        if (idUsuarioEliminar) {
            window.location.href = 'EliminarUsuarioServlet?id=' + idUsuarioEliminar;
        }
    };
});
    </script>
    <!-- Bootstrap JS Bundle CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>