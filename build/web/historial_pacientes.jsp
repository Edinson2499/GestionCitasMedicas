<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("idUsuario") == null || !"especialista".equals(session.getAttribute("rol"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer idEspecialista = (Integer) session.getAttribute("idUsuario");
    String nombreEspecialista = (String) session.getAttribute("nombre");

    // Aquí iría la lógica para permitir al especialista buscar pacientes
    // y ver su historial médico.
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial de Pacientes</title>
    <link rel="icon" href="imagenes/Logo.png" type="image/png">
    <link rel="stylesheet" href="css/estilos_historial_pacientes.css">
</head>
<body>
    <h1>Historial de Pacientes, <%= nombreEspecialista %></h1>

    <div>
        <p>Aquí podrás buscar pacientes y acceder a su historial médico.</p>
        <form action="BuscarPacienteServlet" method="get">
            <label for="nombre_paciente">Nombre del paciente:</label>
            <input type="text" id="nombre_paciente" name="nombre_paciente" required>
            <button type="submit">Buscar Paciente</button>
        </form>

        <div id="resultado_historial"></div>
    </div>

    <br>
    <a href="menu_especialista.jsp"></a>
</body>
</html>