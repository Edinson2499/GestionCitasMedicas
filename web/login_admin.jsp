<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Administrador</title>
    <link rel="stylesheet" href="css/estilosLogin.css">
    <link rel="icon" href="imagenes/Logo.svg" type="image/svg+xml">
</head>
<body>
    <div class="cuerpoFormulario">
        <h1>Administrador</h1>
        <!-- Mensaje de error si hay parámetro error -->
        <%
            String error = request.getParameter("error");
            if (error != null) {
        %>
            <div class="alert alert-danger" style="color:#b94a48; background:#f2dede; border:1px solid #ebccd1; border-radius:8px; padding:10px; margin-bottom:15px; text-align:center;">
                Usuario o contraseña incorrectos. Intente nuevamente.
            </div>
        <%
            }
        %>
        <form class="formularioAdmin" id="formularioAdmin" method="post" action="InicioSesionAdmin">
            <label for="username">Usuario:</label>
            <input type="text" id="username" name="txtUsuario" placeholder="Ingrese su usuario" required />

            <label for="password">Contraseña:</label>
            <input type="password" id="password" name="txtContrasena" placeholder="Ingrese su contraseña" required />

            <div class="buttonGroup">
                <input type="submit" value="Iniciar Sesión" class="btn">
                <input type="button" value="Borrar Datos" class="btn" onclick="resetearFormulario()">
            </div>
        </form>
    </div>

    <script>
        function resetearFormulario() {
            document.getElementById('formularioAdmin').reset();
        }
    </script>
    <a href="index.html" class="btn-atras" title="Volver al inicio"></a>
</body>
</html>
