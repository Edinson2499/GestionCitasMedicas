<!-- filepath: c:\Users\Vargas Cardenas\Desktop\GestionCitasMedicas\web\registrar_usuario.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("rol") == null || !"administrador".equals(session.getAttribute("rol"))) {
        response.sendRedirect("login_admin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registrar Nuevo Usuario</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="imagenes/Logo.png" type="image/png">
    <link rel="stylesheet" href="css/estilosAltaUsuario.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script>
        function mostrarCamposEspecialista() {
            var tipo = document.getElementById("tipo_usuario").value;
            document.getElementById("camposEspecialista").style.display = (tipo === "especialista") ? "block" : "none";
        }
    </script>
</head>
<body>
    <div class="container cuerpoFormulario mt-5 mb-5">
        <form class="formularioAlta" action="GuardarUsuarioServlet" method="post" autocomplete="off">
            <h2 class="mb-4 text-center">Registrar Nuevo Usuario</h2>
            <% if (request.getAttribute("mensaje") != null) { %>
                <div class="avisoContrasena text-center mb-3"><%= request.getAttribute("mensaje") %></div>
            <% } %>
            <div class="mb-3">
                <label for="nombre" class="form-label" style="display: inline-block; width: 100px; text-align: left; margin-right: 5px; margin-bottom: 5px;">Nombre:</label>
                <input type="text" class="txt" id="nombre" name="nombre" required>
            </div>
            <div class="mb-3">
                <label for="apellidos" class="form-label" style="display: inline-block; width: 100px; text-align: left; margin-right: 5px; margin-bottom: 5px;">Apellidos:</label>
                <input type="text" class="txt" id="apellidos" name="apellidos" required>
            </div>
            <div class="mb-3">
                <label for="telefono" class="form-label" style="display: inline-block; width: 100px; text-align: left; margin-right: 5px; margin-bottom: 5px;">Teléfono:</label>
                <input type="tel" class="txt" id="telefono" name="telefono">
            </div>
            <div class="mb-3">
                <label for="direccion" class="form-label" style="display: inline-block; width: 100px; text-align: left; margin-right: 5px; margin-bottom: 5px;">Dirección:</label>
                <input type="text" class="txt" id="direccion" name="direccion">
            </div>
            <div class="mb-3">
                <label for="correo" class="form-label" style="display: inline-block; width: 100px; text-align: left; margin-right: 5px; margin-bottom: 5px;">Correo:</label>
                <input type="email" class="txt" id="correo" name="correo" required>
            </div>
            <div class="mb-3">
                <label for="contrasena" class="form-label" style="display: inline-block; width: 100px; text-align: left; margin-right: 5px; margin-bottom: 5px;">Contraseña:</label>
                <input type="password" class="txt" id="contrasena" name="contrasena" required>
            </div>
            <div class="mb-3">
                <label for="tipo_usuario" class="form-label" style="display: inline-block; width: 140px; text-align: left; margin-right: 5px; margin-bottom: 5px;">Tipo de Usuario:</label>
                <div class="d-flex justify-content-center">
                    <select class="form-select" id="tipo_usuario" name="tipo_usuario" onchange="mostrarCamposEspecialista()" required style="width:60%;max-width:400px;">
                        <option value="">Seleccione...</option>
                        <option value="paciente">Paciente</option>
                        <option value="especialista">Especialista</option>
                        <option value="administrador">Administrador</option>
                    </select>
                </div>
            </div>
            <div id="camposEspecialista" style="display:none;">
                <div class="mb-3">
                    <label for="especialidad" class="form-label" style="display: inline-block; width: 140px; text-align: left; margin-right: 5px; margin-bottom: 5px;">Especialidad:</label>
                    <input type="text" class="txt" id="especialidad" name="especialidad">
                </div>
                <div class="mb-3">
                    <label for="tarjeta" class="form-label" style="display: inline-block; width: 180px; text-align: left; margin-right: 5px; margin-bottom: 5px;">N° Tarjeta Profesional:</label>
                    <input type="text" class="txt" id="tarjeta" name="tarjeta">
                </div>
            </div>
            <input type="submit" class="btn" value="Registrar">
            <a href="menu_admin.jsp" class="btn-back" title="Volver al menu de administrador"></a>
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>