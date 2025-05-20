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
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Editar Usuario</title>
    <link rel="stylesheet" href="css/estilos_editar_usuario.css">
    <link rel="icon" href="imagenes/Logo.png" type="image/png">
</head>
<body>
    <h1>Editar Usuario</h1>
    <form method="get" action="editar_usuario.jsp">
        <div class="form-group">
            <label for="filtroNombre">Nombre:</label>
            <input type="text" id="filtroNombre" name="filtroNombre" value="<%= filtroNombre %>">
        </div>
        <div class="form-group">
            <label for="filtroApellido">Apellido:</label>
            <input type="text" id="filtroApellido" name="filtroApellido" value="<%= filtroApellido %>">
        </div>
        <div class="form-group">
            <label for="filtroTipo">Tipo de Usuario:</label>
            <select id="filtroTipo" name="filtroTipo">
                <option value="" <%= filtroTipo.equals("") ? "selected" : "" %>>Todos</option>
                <option value="paciente" <%= filtroTipo.equals("paciente") ? "selected" : "" %>>Paciente</option>
                <option value="especialista" <%= filtroTipo.equals("especialista") ? "selected" : "" %>>Especialista</option>
                <option value="administrador" <%= filtroTipo.equals("administrador") ? "selected" : "" %>>Administrador</option>
            </select>
        </div>
        <button type="submit">Buscar</button>
    </form>

    <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conexion = SQL.ConexionBD.conectar();
            String sql = "SELECT id, nombre, apellidos, tipo_usuario FROM Usuario WHERE 1=1";
            if (!filtroNombre.isEmpty()) {
                sql += " AND nombre LIKE ?";
            }
            if (!filtroApellido.isEmpty()) {
                sql += " AND apellidos LIKE ?";
            }
            if (!filtroTipo.isEmpty()) {
                sql += " AND tipo_usuario = ?";
            }
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

            rs = ps.executeQuery();
            if (rs.isBeforeFirst()) {
    %>
        <h2>Resultados de la Búsqueda</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Apellido</th>
                    <th>Tipo de Usuario</th>
                    <th>Acción</th>
                </tr>
            </thead>
            <tbody>
    <%
                while (rs.next()) {
    %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("nombre") %></td>
                    <td><%= rs.getString("apellidos") %></td>
                    <td><%= rs.getString("tipo_usuario") %></td>
                    <td>
                        <a href="EditarUsuarioServlet?id=<%= rs.getInt("id") %>">Editar</a> |
                        <a href="#" class="btn-eliminar" data-id="<%= rs.getInt("id") %>">Eliminar</a>
                    </td>
                </tr>
    <%
                }
            } else {
    %>
                <p class="error-message">No se encontraron usuarios con los criterios indicados.</p>
    <%
            }
        } catch (Exception e) {
            out.println("<p class='error-message'>Error al consultar usuarios: " + e.getMessage() + "</p>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conexion != null) conexion.close(); } catch (Exception e) {}
        }
    %>
            </tbody>
        </table>

    <a href="menu_admin.jsp" class="btn-back" title="Volver al menú"></a>
    <area href="menu_admin.jsp"></area>

    <!-- Modal personalizado para eliminar usuario -->
    <div id="modalEliminar" class="modal" style="display:none;">
        <div class="contenido-modal">
            <h2>Confirmar eliminación</h2>
            <p>¿Estás seguro de que deseas eliminar este usuario?</p>
            <div class="buttonGroup">
                <button class="btn" id="btnConfirmarEliminar">Eliminar</button>
                <button class="btn" id="btnCancelarEliminar">Cancelar</button>
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
</body>
</html>

    <br>
    <area href="menu_admin.jsp" title="Volver al menú administrador"></area>
</body>
</html>