/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
function resetearFormulario() {
    document.getElementById("formularioAlta").reset();
    var avisoContrasena = document.getElementById("avisoContrasena");
    var btnEnviarDatos = document.getElementById("btnEnviarDatos");
    
    btnEnviarDatos.disabled = false;
    avisoContrasena.innerHTML = "-------";
    avisoContrasena.style.color = "black";
}


async function usuarioGeneradoAutomaticamente() {
    var nombre = document.getElementById("txtNombre") ? document.getElementById("txtNombre").value.trim().toLowerCase() : "";
    var apellidos = document.getElementById("txtApellidos") ? document.getElementById("txtApellidos").value.trim().toLowerCase() : "";
    var campoUsuario = document.getElementById("txtUsuarioGeneradoAutomaticamente");
    var usuarioFinal = "";

    if (nombre && apellidos) {
        let nombreArr = nombre.split(" ")[0];
        let apellidoArr = apellidos.split(" ")[0];
        let letrasNombre = 1;
        let letrasApellido = 1;
        let usuarioBase = nombreArr.substring(0, letrasNombre) + apellidoArr.substring(0, letrasApellido);
        usuarioFinal = usuarioBase + "@bussineshealth.com";
        let contador = 1;
        let existe = true;

        while (existe) {
            // Verifica si el usuario existe llamando a tu servlet (ajusta la URL si es necesario)
            let response = await fetch('VerificarUsuarioServlet?usuario=' + encodeURIComponent(usuarioFinal));
            let result = await response.text();
            if (result.trim() === "false") {
                existe = false;
            } else {
                usuarioFinal = usuarioBase + contador + "@bussineshealth.com";
                contador++;
                // Si ya hay 100 intentos, agrega una letra más del nombre y apellido
                if (contador > 100) {
                    letrasNombre = Math.min(letrasNombre + 1, nombreArr.length);
                    letrasApellido = Math.min(letrasApellido + 1, apellidoArr.length);
                    usuarioBase = nombreArr.substring(0, letrasNombre) + apellidoArr.substring(0, letrasApellido);
                    usuarioFinal = usuarioBase + "@bussineshealth.com";
                    contador = 1;
                }
            }
        }
    }

    if (campoUsuario) {
        campoUsuario.value = usuarioFinal;
    }
}




function coincidirContrasena() {

    var txtContrasena = document.getElementById("txtContrasena");
    var txtRepetirContrasena = document.getElementById("txtRepetirContrasena");
    var avisoContrasena = document.getElementById("avisoContrasena");
    var btnEnviarDatos = document.getElementById("btnEnviarDatos");

    btnEnviarDatos.disabled = true; //Boton en desactivado o apagado

    if (txtContrasena.value.length == 0 || txtRepetirContrasena.value.length == 0) {
        avisoContrasena.innerHTML = "Ninguna de las contraseñas pueden quedar vacias";
        avisoContrasena.style.color = "blue";
        btnEnviarDatos.disabled = true;

    } else if (txtContrasena.value != txtRepetirContrasena.value) {
        avisoContrasena.innerHTML = "Contraseñas son erroneas por que no coinciden";
        avisoContrasena.style.color = "red";
        btnEnviarDatos.disabled = true;

    } else {
        avisoContrasena.innerHTML = "Las contraseñas coinciden";
        avisoContrasena.style.color = "green";
        btnEnviarDatos.disabled = false;
    }
}

// Asegúrate de que el DOM esté cargado antes de agregar el event listener
document.addEventListener('DOMContentLoaded', function() {
    var inputContrasena = document.getElementById('txtContrasena');
    var aviso = document.getElementById('avisoMinimoContrasena');
    if (inputContrasena && aviso) {
        // Usa Bootstrap alert para el aviso
        aviso.classList.add('alert', 'alert-warning', 'py-2', 'px-3', 'mb-2');
        aviso.style.display = inputContrasena.value.length >= 8 ? 'none' : 'block';

        inputContrasena.addEventListener('input', function() {
            if (this.value.length >= 8) {
                aviso.style.display = 'none';
            } else {
                aviso.style.display = 'block';
            }
        });
    }
});
