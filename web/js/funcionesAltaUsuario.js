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
    var nombre = document.getElementById("txtNombre").value.trim().toLowerCase();
    var apellidos = document.getElementById("txtApellidos").value.trim().toLowerCase();
    var usuarioGeneradoAutomaticamente = document.getElementById("txtUsuarioGeneradoAutomaticamente");

    if (!nombre || !apellidos) {
        usuarioGeneradoAutomaticamente.value = "";
        return;
    }

    var base = nombre.split(" ")[0] + "." + apellidos.split(" ")[0];
    var usuarioFinal = base + "@bussineshealth.com";
    let contador = 1;

    try {
        let existe = true;
        while (existe) {
            const response = await fetch(`VerificarUsuarioServlet?usuario=${encodeURIComponent(usuarioFinal)}`);
            const text = await response.text();
            existe = text.trim() === "true";

            if (!existe) {
                break;
            } else {
                usuarioFinal = base + contador + "@bussineshealth.com";
                contador++;
            }
        }
        usuarioGeneradoAutomaticamente.value = usuarioFinal;
    } catch (error) {
        console.error("Error al verificar usuario:", error);
        usuarioGeneradoAutomaticamente.value = "";
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
