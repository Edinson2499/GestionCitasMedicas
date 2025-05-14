<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
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
</head>
<body>
    <h1>Bienvenido, Especialista <%= nombreEspecialista %></h1>
    <nav class="menu-usuario" id="menu-usuario">
        <ul>
            <li><a href="ver_citas_asignadas.jsp">Ver Citas Asignadas</a></li>
            <li><a href="actualizar_disponibilidad.jsp">Actualizar Disponibilidad</a></li>
            <li><a href="historial_pacientes.jsp">Historial de Pacientes</a></li>
            <li><a href="generar_reportes.jsp">Generar Reportes</a></li>
            <li><a href="CerrarSesionServlet">Cerrar Sesión</a></li>
        </ul>
    </nav>
</body>
</html>