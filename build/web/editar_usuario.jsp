<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if (session.getAttribute("rol") == null || !"administrador".equals(session.getAttribute("rol"))) {
        response.sendRedirect("login_admin.jsp");
        return;
    }

    String idUsuarioEditar = request.getParameter("id");
    if (idUsuarioEditar == null || idUsuarioEditar.isEmpty()) {
        response.sendRedirect("consultar_usuarios.jsp");
        return;
    }
    request.setAttribute("idUsuarioEditar", idUsuarioEditar);
    // Aquí iría la lógica para cargar los datos del usuario a editar
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Usuario</title>
    <link rel="stylesheet" href="css/estilos_editar_usuario.css">
</head>
<body>
    <h1>Editar Usuario</h1>

    <form id="formularioEditarUsuario" action="GuardarEdicionUsuarioServlet" method="post">

        <input type="hidden" name="id" value="${idUsuarioEditar}">

        <div class="form-group">
            <label for="username">Nombre:</label>
            <input type="text" id="username" name="txtUsuario" required>
        </div>
        <div class="form-group">
            <label for="apellido">Apellido:</label>
            <input type="text" id="apellido" name="txtApellido" required>
        </div>
        <div class="form-group">
            <label for="tipo_usuario">Tipo de Usuario:</label>
            <select id="tipo_usuario" name="tipo_usuario">
                <option value="paciente">Paciente</option>
                <option value="especialista">Especialista</option>
                <option value="administrador">Administrador</option>
            </select>
        </div>
        <div class="buttonGroup">
            <input type="submit" value="Guardar Cambios" class="btn">
            <input type="button" value="Borrar Datos" class="btn" onclick="resetearFormularioEditarUsuario()">
        </div>
    </form>

    <br>
    <area href="menu_admin.jsp"></area>
</body>
    <script>
        function resetearFormularioEditarUsuario() {
            document.getElementById('formularioEditarUsuario').reset();
        }
    </script>
</html>