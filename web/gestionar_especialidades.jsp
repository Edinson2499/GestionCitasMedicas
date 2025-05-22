<!-- filepath: c:\Users\Vargas Cardenas\Desktop\GestionCitasMedicas\web\gestionar_especialidades.jsp -->
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
    <title>Gestionar Especialidades</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="imagenes/Logo.png" type="image/png">
    <link rel="stylesheet" href="css/estilos_gestionar_especialidades.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5 mb-5" style="max-width: 700px;">
        <h2 class="mb-4 text-center">Gestión de Especialidades</h2>
        <% if (request.getAttribute("mensaje") != null) { %>
            <div class="alert alert-info text-center"><%= request.getAttribute("mensaje") %></div>
        <% } %>
        <form method="post" action="GestionarEspecialidadesServlet" class="mb-4 row g-3">
            <div class="col-8">
                <input type="text" class="form-control" name="nuevaEspecialidad" placeholder="Nueva especialidad" required>
            </div>
            <div class="col-4">
                <button type="submit" name="accion" value="agregar" class="btn btn-primary w-100">Agregar</button>
            </div>
        </form>
        <div class="table-responsive">
            <table class="tabla-gestionar-especialidades">
                <thead class="table-primary">
                    <tr>
                        <th>Especialidad</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    try {
                        conn = ConexionBD.conectar();
                        // Suponiendo que tienes una tabla llamada Especialidades
                        String sql = "SELECT id, nombre FROM Especialidades ORDER BY nombre ASC";
                        ps = conn.prepareStatement(sql);
                        rs = ps.executeQuery();
                        boolean hayResultados = false;
                        while (rs.next()) {
                            hayResultados = true;
                %>
                    <tr>
                        <td><%= rs.getString("nombre") %></td>
                        <td>
                            <form method="post" action="GestionarEspecialidadesServlet" style="display:inline;">
                                <input type="hidden" name="idEspecialidad" value="<%= rs.getInt("id") %>">
                                <button type="submit" name="accion" value="eliminar" class="btn btn-danger btn-sm" onclick="return confirm('¿Eliminar esta especialidad?');">Eliminar</button>
                            </form>
                        </td>
                    </tr>
                <%
                        }
                        if (!hayResultados) {
                %>
                    <tr>
                        <td colspan="2" class="text-center">No hay especialidades registradas.</td>
                    </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<div class='alert alert-danger'>Error al consultar especialidades: " + e.getMessage() + "</div>");
                    } finally {
                        try { if (rs != null) rs.close(); } catch (Exception e) {}
                        try { if (ps != null) ps.close(); } catch (Exception e) {}
                        try { if (conn != null) conn.close(); } catch (Exception e) {}
                    }
                %>
                </tbody>
            </table>
        </div>
        <a href="menu_admin.jsp" class="btn-back" title="Volver al menú de Administrador"></a>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>