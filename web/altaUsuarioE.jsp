
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registro E</title>
        <link rel="icon" href="imagenes/Logo.png" type="image/png">
        <link rel="stylesheet" href="css/estilosAltaUsuario.css" type="text/css" media="all">
        <%
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);
        %>
    </head>
    <body>
        <div class="cuerpoFormulario" id="cuerpoFormulario"> 
            <form class="formularioAlta" id="formularioAlta" method="post" action="GuardarServlet">
                <input type="hidden" name="rol" value="especialista">
                <h1>Registro de Usuarios</h1>
                <br>
                <label>ID:</label> <input type="text" class="txt" id="txtId" required="" name="txtiD">
                <br>
                <br>
                <label style="display: inline-block; width: 100px; text-align: left; margin-right: 5px; margin-bottom: 5px;">Nombre:</label> 
                <input type="text" class="txt" id="txtNombre" required="" onkeyup="usuarioGeneradoAutomaticamente()" name="txtNombre" style="margin-bottom: 5px;">
                <br>
                <label style="display: inline-block; width: 100px; text-align: left; margin-right: 5px; margin-bottom: 5px;">Apellidos:</label> 
                <input type="text" class="txt" id="txtApellidos" required="" onkeyup="usuarioGeneradoAutomaticamente()" name="txtApellidos" style="margin-bottom: 5px;">
                <br>
                <label style="display: inline-block; width: 100px; text-align: left; margin-right: 5px; margin-bottom: 5px;">Telefono:</label> 
                <input type="tel" class="txt" id="txtTelefono" required="" onkeyup="usuarioGeneradoAutomaticamente()" name="txtTelefono" style="margin-bottom: 5px;">
                <br>
                <label style="display: inline-block; width: 100px; text-align: left; margin-right: 5px; margin-bottom: 5px;">Direccion:</label> 
                <input type="text" class="txt" id="txtDireccion" required="" onkeyup="usuarioGeneradoAutomaticamente()" name="txtDireccion" style="margin-bottom: 5px;">
                <br>
                <br>
                <label>Especialidad:</label>
                <input list="especialidad" placeholder="Seleccione una especialidad" class="txt" id="txtEspecialidad" name="txtEspecialidad" required="">
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
                    <option value="Gastroenterología"> </option>
                    <option value="Nefrología"></option>
                    </datalist>
                <br>
                <br>
                <label style="display: contents; width: 100px; text-align: left; margin-right: 5px; margin-bottom: 5px;">ID Tarjeta Profecional:</label> 
                <input type="text" class="txt" id="txtTp" required="" name="txtTp"style="margin-bottom: 5px;">
                <br>
                <label style="display: contents; width: 100px; text-align: left; margin-right: 5px; margin-bottom: 5px;">Contraseña:</label> 
                <input type="password" class="txt" id="txtContrasena" required="" onkeyup="coincidirContrasena()"style="margin-bottom: 5px;">
                <br>
                <label style="display: contents; width: 100px; text-align: left; margin-right: 5px; margin-bottom: 5px;">Repita la Contraseña:</label> 
                <input type="password" class="txt" id="txtRepetirContrasena" required="" onkeyup="coincidirContrasena()" name="txtContrasena"style="margin-bottom: 5px;">
                <br>
                <br>
                <label class="avisoContrasena" id="avisoContrasena"> ------- </label>
                <br>
                <br>
                <label>Usuario Generado:</label> <input type="text" class="txt" id="txtUsuarioGeneradoAutomaticamente" required="" readonly="" name="txtUsuarioGeneradoAutomaticamente">
                <br>
                <br>
                
                <input type="submit" value="Enviar Datos" class="btn" id="btnEnviarDatos" disabled="">
                <input type="button" value="Borrar Datos" class="btn" id="btnBorrar" onclick="resetearFormulario()">
                
            </form>
        </div>
    </body>
    <script src="js/funcionesAltaUsuario.js"></script>
</html>
