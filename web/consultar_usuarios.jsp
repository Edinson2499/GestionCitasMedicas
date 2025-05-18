
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consultar Usuarios</title>
    <link rel="stylesheet" href="css/estilos_consultar_usuarios.css">
    <link rel="icon" href="imagenes/Logo.png" type="image/png">
</head>
<body>
    <h1>Consultar Usuarios</h1>

    <form action="ConsultarUsuariosServlet" method="get">
        <div class="form-group">
            <label for="tipo_usuario">Filtrar por tipo de usuario:</label>
            <select id="tipo_usuario" name="tipo_usuario">
                <option value="todos">Todos</option>
                <option value="paciente">Paciente</option>
                <option value="especialista">Especialista</option>
            </select>
        </div>
        <button type="submit">Buscar Usuarios</button>
    </form>

    <c:if test="${not empty error}">
        <p class="error-message">${error}</p>
    </c:if>

    <c:if test="${not empty listaUsuarios}">
        <h2>Resultados de la Búsqueda</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Apellido</th>
                    <th>Usuario</th>
                    <th>Rol</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="usuario" items="${listaUsuarios}">
                    <tr>
                        <td>${usuario.id}</td>
                        <td>${usuario.nombre}</td>
                        <td>${usuario.apellidos}</td>
                        <td>${usuario.usuarioGenerado}</td>
                        <td>${usuario.tipoUsuario}</td>
                        <td>
                            <a href="editar_usuario.jsp?id=${usuario.id}">Editar</a> |
                            <a href="EliminarUsuarioServlet?id=${usuario.id}" onclick="return confirm('¿Estás seguro de eliminar este usuario?')">Eliminar</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>

    <br>
    <area href="menu_admin.jsp"></area>
</body>
</html>