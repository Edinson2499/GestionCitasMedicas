<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    String nombre = (String) session.getAttribute("nombre");
    String rol = (String) session.getAttribute("rol");
    if (nombre == null || rol == null) {
        response.sendRedirect("index.html");
        return;
    }
    String menu = "";
    if ("administrador".equals(rol)) {
        menu = "menu_admin.jsp";
    } else if ("especialista".equals(rol)) {
        menu = "menu_especialista.jsp";
    } else if ("paciente".equals(rol)) {
        menu = "menu_paciente.jsp";
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Inicio</title>
        <link rel="icon" href="imagenes/Logo.png" type="image/png">
        <link rel="stylesheet" href="css/estilosPaginaInicio.css" type="text/css" media="all">
    </head>
    <body>
        <div class="contenidoInicio">
            <h1>Hola <%= nombre %>, ¡Bienvenido!</h1>
            <p>Tu rol: <strong><%= rol.substring(0,1).toUpperCase() + rol.substring(1) %></strong></p>
            <a href="<%= menu %>" class="btn-ir-menu">Ir a mi menú principal</a>
            <form action="CerrarSesionServlet" style="margin-top:2em;">
                <input type="submit" value="Cerrar Sesión">
            </form>
        </div>
    </body>
</html>
