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
    <link rel="icon" href="imagenes/Logo.svg" type="image/svg+xml">
    <link rel="stylesheet" href="css/estilosAltaUsuario.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script>
        function mostrarCamposEspecialista() {
            var tipo = document.getElementById("tipo_usuario").value;
            var campos = document.getElementById("camposEspecialista");
            var especialidad = document.getElementById("txtEspecialidad");
            if (tipo === "especialista") {
                campos.style.display = "block";
                especialidad.required = true;
            } else {
                campos.style.display = "none";
                especialidad.required = false;
            }
        }
        // Ejecutar al cargar la página para mantener el estado correcto
        document.addEventListener("DOMContentLoaded", function () {
            mostrarCamposEspecialista();
        });
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
                <input type="tel" class="txt" id="telefono" name="telefono" pattern="\d{7,}" title="Solo números, mínimo 7 dígitos">
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
                <input type="password" class="txt" id="contrasena" name="contrasena" required 
                pattern='^(?=.*[0-9])(?=.*[!@#$%^&*()_+\-=\[\]{};":\\|,.\/?]).{8,}$' 
                title="Mínimo 8 caracteres, al menos un número y un símbolo">


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
                    <label for="txtEspecialidad" class="form-label" style="display: inline-block; width: 140px; text-align: left; margin-right: 5px; margin-bottom: 5px;">Especialidad:</label>
                    <input list="especialidad" placeholder="Seleccione una especialidad" class="txt" id="txtEspecialidad" name="txtEspecialidad" required>
                    <datalist id="especialidad">
                        <option value="Cardiología"></option>
                        <option value="Dermatología"></option>
                        <option value="Pediatría"></option>
                        <option value="Neurología"></option>
                        <option value="Oncología"></option>
                        <option value="Psiquiatría"></option>
                        <option value="Ginecología"></option>
                        <option value="Oftalmología"></option>
                        <option value="Ortopedia"></option>
                        <option value="Endocrinología"></option>
                        <option value="Traumatología"></option>
                        <option value="Otorrinolaringología"></option>
                        <option value="Medicina Interna"></option>
                        <option value="Urología"></option>
                        <option value="Radiología"></option>
                        <option value="Anestesiología"></option>
                        <option value="Cirugía General"></option>
                        <option value="Neumología"></option>
                        <option value="Gastroenterología"></option>
                        <option value="Nefrología"></option>
                    </datalist>
                </div>
                <div class="mb-3">
                    <label for="tarjeta" class="form-label" style="display: inline-block; width: 180px; text-align: left; margin-right: 5px; margin-bottom: 5px;">N° Tarjeta Profesional:</label>
                    <input type="text" class="txt" id="tarjeta" name="tarjeta">
                </div>
            </div>
            <div class="mb-3">
                <label for="usuario_generado" class="form-label" style="display: inline-block; width: 180px; text-align: left; margin-right: 5px; margin-bottom: 5px;">
                    Usuario Generado:
                </label>
                <input type="text" class="txt" id="usuario_generado" name="usuario_generado" readonly>
            </div>
            <input type="submit" class="btn" value="Registrar">
            <a href="menu_admin.jsp" class="btn-back" title="Volver al menú"></a>
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
document.addEventListener("DOMContentLoaded", function () {
    document.getElementById("nombre").addEventListener("input", generarUsuario);
    document.getElementById("apellidos").addEventListener("input", generarUsuario);
    generarUsuario();
});

async function generarUsuario() {
    var nombre = document.getElementById("nombre").value.trim().toLowerCase();
    var apellidos = document.getElementById("apellidos").value.trim().toLowerCase();
    var usuarioBase = "";
    var usuarioFinal = "";

    if (nombre && apellidos) {
        // Toma la primera letra del primer nombre y la primera letra del primer apellido
        var nombreBase = nombre.split(" ")[0].charAt(0);
        var apellidoBase = apellidos.split(" ")[0].charAt(0);
        usuarioBase = nombreBase + apellidoBase + "@bussineshealth.com";
        usuarioFinal = usuarioBase;

        let contador = 1;
        let existe = true;

        while (existe) {
            let response = await fetch('VerificarUsuarioServlet?usuario=' + encodeURIComponent(usuarioFinal));
            let result = await response.text();
            if (result.trim() === "false") {
                existe = false;
            } else {
                usuarioFinal = nombreBase + apellidoBase + contador + "@bussineshealth.com";
                contador++;
            }
        }
    } else {
        usuarioFinal = "";
    }

    var campoUsuario = document.getElementById("usuario_generado");
    if (campoUsuario) {
        campoUsuario.value = usuarioFinal;
    } else {
        console.error("No se encontró el campo con id 'usuario_generado'");
    }
}
</script>
</body>
</html>