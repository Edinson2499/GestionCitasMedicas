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
    <link rel="icon" href="imagenes/Logo.svg" type="image/svg+xml">
    <link rel="stylesheet" href="css/estilosMenu_U.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

</head>
<body>
    <div class="container d-flex flex-column align-items-center justify-content-center min-vh-100">
        <h1 class="mb-4 text-center">Bienvenido, Administrador <%= nombreAdmin %></h1>
        <nav class="menu-usuario shadow-lg p-3 mb-5 bg-body rounded" id="menu-usuario">
            <ul class="list-unstyled">
                <li class="mb-2"><a class="w-100" href="consultar_usuarios.jsp">Consultar Usuarios</a></li>
                <li class="mb-2"><a class="w-100" href="registrar_usuario.jsp">Registrar Nuevo Usuario</a></li>
                <li class="mb-2"><a class="w-100" href="editar_usuario.jsp">Editar Usuario</a></li>
                <li class="mb-2"><a class="w-100" href="gestionar_citas.jsp">Gestionar Citas</a></li>
                <li class="mb-2"><a class="w-100" href="gestionar_horarios.jsp">Gestionar Horarios</a></li>
                <li class="mb-2"><a class="w-100" href="gestionar_historial.jsp">Historial Médico</a></li>
                <li class="mb-2"><a class="w-100" href="<%= request.getContextPath() %>/CerrarSesion">Cerrar Sesión</a></li>
            </ul>
        </nav>
    </div>
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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>