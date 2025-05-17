<%-- 
    Document   : login_admin
    Created on : 3/05/2025, 11:52:28 a. m.
    Author     : javie
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Administrador</title>
    <link rel="stylesheet" href="../css/estilosLogin.css">
    <link rel="icon" href="../imagenes/Logo.png" type="image/png">
</head>
<body>
    <div class="login-container">
        <h2>Acceso de Administrador</h2>
        <form id="formularioAdmin" action="InicioSesionAdmin" method="post">
            <div class="form-group">
                <label for="usuario">Usuario:</label>
                <input type="text" id="usuario" name="txtUsuario" required>
            </div>
            <div class="form-group">
                <label for="contrasena">Contraseña:</label>
                <input type="password" id="contrasena" name="txtContrasena" required>
            </div>
            <div class="buttonGroup">
                <input type="submit" value="InicioSesion" class="btn">
                <input type="button" value="Borrar Datos" class="btn" onclick="resetearFormulario()">
            </div>
        </form>
    </div>

    <script>
        function resetearFormulario() {
            document.getElementById('formularioAdmin').reset();
        }
    </script>
    <area href="index.html"></area>
</body>
</html>
