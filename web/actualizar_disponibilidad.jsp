<%-- 
    Document   : actualizar_disponibilidad
    Created on : 22/04/2025, 3:38:16 p. m.
    Author     : javie
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("idUsuario") == null || !"especialista".equals(session.getAttribute("rol"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer idEspecialista = (Integer) session.getAttribute("idUsuario");
    String nombreEspecialista = (String) session.getAttribute("nombre");

    // Aquí iría la lógica para mostrar la disponibilidad actual del especialista
    // y un formulario para que pueda modificarla.
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Actualizar Disponibilidad</title>
    <link rel="stylesheet" href="css/estilos_actualizar_disponibilidad.css">
</head>
<body>
    <h1>Actualizar Disponibilidad, <%= nombreEspecialista %></h1>

    <div>
        <p>Aquí podrás ver y modificar tu horario de atención.</p>
        <form action="GuardarDisponibilidadServlet" method="post">
            <label for="dia">Seleccione el día:</label>
            <input type="date" id="dia" name="dia">

            <label for="hora_inicio">Hora de inicio:</label>
            <input type="time" id="hora_inicio" name="hora_inicio">

            <label for="hora_fin">Hora de fin:</label>
            <input type="time" id="hora_fin" name="hora_fin">

            <button type="submit">Guardar Disponibilidad</button>
        </form>
    </div>

    <br>
    <a href="menu_Especialista.jsp">Volver al Menú del Especialista</a>
</body>
</html>