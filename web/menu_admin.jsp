<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("rol") == null || !"administrador".equals(session.getAttribute("rol"))) {
        response.sendRedirect("login_admin.jsp");
        return;
    }

    String nombreAdmin = (String) session.getAttribute("nombre");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menú del Administrador</title>
    <link rel="icon" href="imagenes/Logo.png" type="image/png">
    <link rel="stylesheet" href="css/estilosMenu_U.css">
</head>
<body>
    <h1>Bienvenido, Administrador <%= nombreAdmin %></h1>
    <nav class="menu-usuario" id="menu-usuario">
        <ul>
            <li><a href="consultar_usuarios.jsp">Consultar Usuarios</a></li>
            <li><a href="registrar_usuario.jsp">Registrar Nuevo Usuario</a></li>
            <li><a href="editar_usuario.jsp">Editar Usuario</a></li>
            <li><a href="gestionar_citas.jsp">Gestionar Citas</a></li>
            <li><a href="gestionar_disponibilidad.jsp">Gestionar Disponibilidad</a></li>
            <li><a href="gestionar_especialidades.jsp">Gestionar Especialidades</a></li>
            <li><a href="gestionar_horarios.jsp">Gestionar Horarios</a></li>
            <li><a href="gestionar_historial.jsp">Historial Médico</a></li>
            <li><a href="<%= request.getContextPath() %>/CerrarSesion">Cerrar Sesión</a></li>
        </ul>
    </nav>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const menuLinks = document.querySelectorAll('.menu-usuario a');

            menuLinks.forEach((link, index) => {
                const delay = index * 50;

                setTimeout(() => {
                    link.style.transform = 'translateY(0)';
                    link.style.opacity = '1';
                }, delay);

                link.style.transform = 'translateY(10px)';
                link.style.opacity = '0';
                link.style.transition = 'transform 0.3s ease-out, opacity 0.3s ease-out';
            });
        });
    </script>
</body>
</html>