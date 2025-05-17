<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Iniciar Sesión</title>
    <link rel="icon" href="../imagenes/Logo.png" type="image/png">
    <link rel="stylesheet" href="../css/estilosLogin.css">

    <%
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    %>
</head>
<body>
    <div class="cuerpoFormulario" id="cuerpoFormulario">
        <form class="formularioLogin" id="formularioLogin" method="post" action="InicioSesionServlet">
            <label for="username">Usuario:</label>
            <input type="text" id="username" name="txtUsuario" placeholder="Ingrese su usuario" required />

            <label for="password">Contraseña:</label>
            <input type="password" id="password" name="txtContrasena" placeholder="Ingrese su contraseña" required />

            <div class="buttonGroup">
                <input type="submit" value="Iniciar Sesión" class="btn">
                <input type="button" value="Borrar Datos" class="btn" onclick="resetearFormularioLogin()">
            </div>
        </form>
    </div>

    <!-- Modal admin oculto -->
    <div id="modalAdmin">
        <div class="contenido-modal">
            <h2>¡Modo Administrador Activado!</h2>
            <p>Has activado el acceso para administradores.</p>
            <button onclick='redirigir()'>Aceptar</button>
        </div>
    </div>
    <script src="js/funcionesLogin.js"></script>
</body>
</html>