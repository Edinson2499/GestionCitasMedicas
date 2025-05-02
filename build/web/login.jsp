<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="css/estilosLogin.css" type="text/css" media="all">
        
        <%
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); //Borrar directivas de memoria cache y anular algoritmos predeterminados para almacenar cache 
            response.setHeader("Pragma", "no-cache");//Directivas compatibles con memorias cache 
            response.setDateHeader("Expires", 0);//Proporciona Fecha y hora para decir el tiempo de respuesta caduco 
        %>
    </head>
    <body>
        <div class="cuerpoFormulario" id="cuerpoFormulario">
            <form class="formularioLogin" id="formularioLogin" method="post" action="InicioSesionServlet">
                <form id="loginFormElement">
                    <label for="username">Usuario:</label>
                    <input type="text" id="username" name="username" placeholder="Ingrese su usuario" required />

                    <label for="password">Contraseña:</label>
                    <input type="password" id="password" name="password" placeholder="Ingrese su contraseña" required />

                    <div class="buttonGroup">
                        <input type="submit" value="Iniciar Sesion" class="btn">
                        <input type="button" value="Borrar Datos" class="btn" onclick="resetearFormularioLogin()">
                    </div>
                </form>
            </form>
        </div>
    </body>
        <div class="cuerpoFormulario" id="cuerpoFormulario">
    <script src="js/funcionesLogin.js"></script>
</html>
