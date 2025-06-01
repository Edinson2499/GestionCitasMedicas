<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, SQL.ConexionBD" %>
<%
    Integer idPaciente = (Integer) session.getAttribute("idUsuario");
    String rol = (String) session.getAttribute("rol");
    if (idPaciente == null || rol == null || !"paciente".equals(rol)) {
        response.sendRedirect("login.jsp");
        return;
    }
    String nombre = "";
    String apellidos = "";
    String telefono = "";
    String direccion = "";
    String correo = "";
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        conn = ConexionBD.conectar();
        String sql = "SELECT nombre, apellidos, telefono, direccion, correo FROM Usuario WHERE id = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, idPaciente);
        rs = ps.executeQuery();
        if (rs.next()) {
            nombre = rs.getString("nombre");
            apellidos = rs.getString("apellidos");
            telefono = rs.getString("telefono");
            direccion = rs.getString("direccion");
            correo = rs.getString("correo");
        }
    } catch (Exception e) {
        out.println("<p>Error al cargar datos: " + e.getMessage() + "</p>");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Actualizar Datos</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="imagenes/Logo.svg" type="image/svg+xml">
    <link rel="stylesheet" href="css/estilosActualizarDatos.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <h1 class="mb-4 text-center">Actualizar Datos Personales</h1>
    <div class="container mt-5 mb-5" style="max-width: 500px;">
        
        <% if (request.getAttribute("mensaje") != null) { %>
            <div class="alert alert-info text-center"><%= request.getAttribute("mensaje") %></div>
        <% } %>
        <form action="ActualizarDatosServlet" method="post">
            <div class="mb-3">
                <label for="nombre" class="form-label">Nombre</label>
                <input type="text" class="form-control" id="nombre" name="nombre" value="<%= nombre %>" required>
            </div>
            <div class="mb-3">
                <label for="apellidos" class="form-label">Apellidos</label>
                <input type="text" class="form-control" id="apellidos" name="apellidos" value="<%= apellidos %>" required>
            </div>
            <div class="mb-3">
                <label for="telefono" class="form-label">Teléfono</label>
                <input type="tel" class="form-control" id="telefono" name="telefono" value="<%= telefono %>">
            </div>
            <div class="mb-3">
                <label for="direccion" class="form-label">Dirección</label>
                <input type="text" class="form-control" id="direccion" name="direccion" value="<%= direccion %>">
            </div>
            <div class="mb-3">
                <label for="correo" class="form-label">Correo</label>
                <input type="email" class="form-control" id="correo" name="correo" value="<%= correo %>" required>
            </div>
            <button type="submit" class="btn btn-primary w-100">Actualizar</button>
        </form>
        <a href="menu_paciente.jsp" class="btn-back"  title="Volver al menú de Paciente"></a>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>