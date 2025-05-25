<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.List" %>
<%
    // Solo permite acceso si el usuario tiene el rol de especialista
    if (session.getAttribute("idUsuario") == null || !"especialista".equals(session.getAttribute("rol"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String nombreEspecialista = (String) session.getAttribute("nombre");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menú del Especialista</title>
    <link rel="icon" href="imagenes/Logo.png" type="image/png">
    <link rel="stylesheet" href="css/estilosMenu_U.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container d-flex flex-column align-items-center justify-content-center min-vh-100">
        <h1 class="mb-4 text-center">Bienvenido, Especialista <%= nombreEspecialista %></h1>
        <nav class="menu-usuario shadow-lg p-3 mb-5 bg-body rounded" id="menu-usuario">
            <ul class="list-unstyled">
                <li class="mb-2"><a class="w-100" href="VerCitasAsignadasServlet">Ver Citas Asignadas</a></li>
                <li class="mb-2"><a class="w-100" href="actualizar_disponibilidad.jsp">Actualizar Disponibilidad</a></li>
                <li class="mb-2"><a class="w-100" href="historial_pacientes.jsp">Historial de Pacientes</a></li>
                <li class="mb-2"><a class="w-100" href="generar_reportes.jsp">Generar Reportes</a></li>
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
