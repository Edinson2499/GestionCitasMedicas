
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
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
                <input type="submit" value="Enviar Datos" class="btn" id="btnEnviarDatos" disabled="">
                <h1>Registro de Usuarios</h1>
                <br>
                <label>ID:</label> <input type="text" class="txt" id="txtId" required="" name="txtiD">
                <br>
                <br>
                <label>Nombre:</label> <input type="text" class="txt" id="txtNombre" required="" onkeyup="usuarioGeneradoAutomaticamente()" name="txtNombre">
                <label>Apellidos:</label> <input type="text" class="txt" id="txtApellidos" required="" onkeyup="usuarioGeneradoAutomaticamente()" name="txtApellidos">
                <label>Telefono:</label> <input type="tel" class="txt" id="txtTelefono" required="" onkeyup="usuarioGeneradoAutomaticamente()" name="txtTelefono">
                <label>Direccion:</label> <input type="text" class="txt" id="txtDireccion" required="" onkeyup="usuarioGeneradoAutomaticamente()" name="txtDireccion">
                <br>
                <br>
                <label>Especialidad:</label>
                <select class="txt" id="txtEspecialidad" name="txtEspecialidad" required="">
                    <option value="">Seleccione una especialidad</option>
                    <option value="Cardiología">Cardiología</option>
                    <option value="Dermatología">Dermatología</option>
                    <option value="Pediatría">Pediatría</option>
                    <option value="Neurología">Neurología</option>
                    <option value="Oncología">Oncología</option>
                    <option value="Psiquiatría">Psiquiatría</option>
                    <option value="Ginecología">Ginecología</option>
                    <option value="Oftalmología">Oftalmología</option>
                    <option value="Ortopedia">Ortopedia</option>
                    <option value="Endocrinología">Endocrinología</option>
                    <option value="Traumatología">Traumatología</option>
                    <option value="Otorrinolaringología">Otorrinolaringología</option>
                    <option value="Medicina Interna">Medicina Interna</option>
                    <option value="Urología">Urología</option>
                    <option value="Radiología">Radiología</option>
                    <option value="Anestesiología">Anestesiología</option>
                    <option value="Cirugía General">Cirugía General</option>
                    <option value="Neumología">Neumología</option>
                    <option value="Gastroenterología">Gastroenterología</option>
                    <option value="Nefrología">Nefrología</option>
                    <option value="Inmunología">Inmunología</option>
                </select>
                
                <br>
                <br>
                <label>NUMERO TARJETA PROFESIONAL:</label> <input type="text" class="txt" id="txtTp" required="" name="txtTp">
                <label>Contraseña:</label> <input type="password" class="txt" id="txtContrasena" required="" onkeyup="coincidirContrasena()">
                <label>Repita la Contraseña:</label> <input type="password" class="txt" id="txtRepetirContrasena" required="" onkeyup="coincidirContrasena()" name="txtContrasena">
                <br>
                <br>
                <label class="avisoContrasena" id="avisoContrasena"> ------- </label>
                <br>
                <br>
                <label>Usuario Generado Automaticamente:</label> <input type="text" class="txt" id="txtUsuarioGeneradoAutomaticamente" required="" readonly="" name="txtUsuarioGeneradoAutomaticamente">
                <br>
                <br>
                
                <input type="submit" value="Enviar Datos" class="btn" id="btnEnviarDatos" disabled="">
                <input type="button" value="Borrar Datos" class="btn" id="btnBorrar" onclick="resetearFormulario()">
                
            </form>
        </div>
    </body>
    <script src="js/funcionesAltaUsuario.js"></script>
</html>
