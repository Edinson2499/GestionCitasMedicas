<%-- 
    Document   : menu_paciente
    Created on : 22/04/2025, 2:32:40 a. m.
    Author     : javie
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/estilosMenu_paciente.css" type="text/css" media="all">
    <title>Menú Paciente</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <h1>Bienvenido, Paciente</h1>
    </header>
    <nav>
        <ul>
            <li><a href="agendar_cita.jsp">Agendar Cita</a></li>
            <li><a href="consultar_citas.jsp">Consultar Citas</a></li>
            <li><a href="cancelar_cita.jsp">Cancelar Cita</a></li>
            <li><a href="actualizar_datos.jsp">Actualizar Datos</a></li>
            <li><a href="historial_medico.jsp">Historial Médico</a></li>
        </ul>
    </nav>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const menuLinks = document.querySelectorAll('.menu-paciente a');

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