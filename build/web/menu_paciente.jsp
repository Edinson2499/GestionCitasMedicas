<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String nombrePaciente = (String) session.getAttribute("nombre");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/estilosMenu_U.css" type="text/css" media="all">
    <title>Menú Paciente</title>
    <link rel="icon" href="imagenes/Logo.png" type="image/png">
</head>
<body>
    <header>
        <h1>Bienvenido, Paciente <%= nombrePaciente %> </h1>
    </header>
    <nav class="menu-usuario">
        <ul>
            <li><a href="agendar_cita.jsp">Agendar Cita</a></li>
            <li><a href="consultar_citas.jsp">Consultar Citas</a></li>
            <li><a href="cancelar_cita.jsp">Cancelar Cita</a></li>
            <li><a href="actualizar_datos.jsp">Actualizar Datos</a></li>
            <li><a href="historial_medico.jsp">Historial Médico</a></li>
            <li><a href="CerrarSesionServlet">Cerrar Sesión</a></li>
        </ul>
    </nav>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const menuLinks = document.querySelectorAll('.menu-u a');

        menuLinks.forEach((link, index) => {
            // Retraso ligero para cada enlace
            const delay = index * 50; // Milisegundos

            setTimeout(() => {
                link.style.transform = 'translateY(0)';
                link.style.opacity = '1';
            }, delay);

            // Estilos iniciales (oculto y ligeramente desplazado)
            link.style.transform = 'translateY(10px)';
            link.style.opacity = '0';
            link.style.transition = 'transform 0.3s ease-out, opacity 0.3s ease-out';
        });
    });
</script>
</body>
</html>