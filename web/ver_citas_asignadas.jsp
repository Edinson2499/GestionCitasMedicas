<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if (session.getAttribute("idUsuario") == null || !"especialista".equals(session.getAttribute("rol"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    String nombreEspecialista = (String) session.getAttribute("nombre");
    // No necesitamos obtener el idEspecialista aquí, se maneja en el Servlet

    // Redirigir al Servlet para obtener las citas
    request.getRequestDispatcher("VerCitasAsignadasServlet").forward(request, response);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Citas Asignadas</title>
    <link rel="icon" href="imagenes/Logo.png" type="image/png">
    <link rel="stylesheet" href="css/estilos_citas_asignadas.css">
</head>
<body>
    <h1>Citas Asignadas a <%= nombreEspecialista %></h1>

    <div>
        <c:if test="${not empty error}">
            <p style="color: red;">${error}</p>
        </c:if>

        <c:if test="${not empty citasAsignadas}">
            <table>
                <thead>
                    <tr>
                        <th>Fecha y Hora</th>
                        <th>Paciente</th>
                        <th>Especialidad</th>
                        <th>Estado</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="cita" items="${citasAsignadas}">
                        <tr>
                            <td>${cita.fechaHora}</td>
                            <td>${cita.nombrePaciente}</td>
                            <td>${cita.especialidad}</td>
                            <td>${cita.estado}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>

        <c:if test="${empty citasAsignadas and empty error}">
            <p>No tienes citas asignadas.</p>
        </c:if>
    </div>

    <br>
    <a href="menu_especialista.jsp">Volver al Menú del Especialista</a>
</body>
</html>