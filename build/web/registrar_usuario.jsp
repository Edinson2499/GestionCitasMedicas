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
    <div class="container mt-5 mb-5" style="max-width: 600px;">
        <h2 class="mb-4 text-center">Registrar Nuevo Usuario</h2>
        <% if (request.getAttribute("mensaje") != null) { %>
            <div class="alert alert-info text-center"><%= request.getAttribute("mensaje") %></div>
        <% } %>
        <form action="GuardarUsuarioServlet" method="post">
            <div class="mb-3">
                <label for="nombre" class="form-label">Nombre</label>
                <input type="text" class="form-control" id="nombre" name="nombre" required>
            </div>
            <div class="mb-3">
                <label for="apellidos" class="form-label">Apellidos</label>
                <input type="text" class="form-control" id="apellidos" name="apellidos" required>
            </div>
            <div class="mb-3">
                <label for="telefono" class="form-label">Teléfono</label>
                <input type="tel" class="form-control" id="telefono" name="telefono">
            </div>
            <div class="mb-3">
                <label for="direccion" class="form-label">Dirección</label>
                <input type="text" class="form-control" id="direccion" name="direccion">
            </div>
            <div class="mb-3">
                <label for="correo" class="form-label">Correo</label>
                <input type="email" class="form-control" id="correo" name="correo" required>
            </div>
            <div class="mb-3">
                <label for="contrasena" class="form-label">Contraseña</label>
                <input type="password" class="form-control" id="contrasena" name="contrasena" required>
            </div>
            <div class="mb-3">
                <label for="tipo_usuario" class="form-label">Tipo de Usuario</label>
                <select class="form-select" id="tipo_usuario" name="tipo_usuario" onchange="mostrarCamposEspecialista()" required>
                    <option value="">Seleccione...</option>
                    <option value="paciente">Paciente</option>
                    <option value="especialista">Especialista</option>
                    <option value="administrador">Administrador</option>
                </select>
            </div>
            <div id="camposEspecialista" style="display:none;">
                <div class="mb-3">
                    <label for="especialidad" class="form-label">Especialidad</label>
                    <input type="text" class="form-control" id="especialidad" name="especialidad">
                </div>
                <div class="mb-3">
                    <label for="tarjeta" class="form-label">N° Tarjeta Profesional</label>
                    <input type="text" class="form-control" id="tarjeta" name="tarjeta">
                </div>
            </div>
            <button type="submit" class="btn btn-primary w-100">Registrar</button>
        </form>
        <a href="menu_admin.jsp" class="btn-back" title="Volver al menu de administracion"></a>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>