/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function borrarDatosEspecificos(){
    
    var txtUsuario =  document.getElementById("txtUsuario");
    txtUsuario.value = "";
    
    document.getElementById("txtContrasena").value = "";
}


function resetearFormularioLogin(){
    document.getElementById("formularioLogin").reset();
}

document.addEventListener("DOMContentLoaded", function () {
    let buffer = "";

    window.addEventListener('keydown', function(e) {
        if (e.key.length === 1) {
            buffer += e.key.toLowerCase();

            if (buffer.length > 10) {
                buffer = buffer.slice(-10);
            }

            if (buffer.includes("admin")) {
                const modal = document.getElementById('modalAdmin');
                if (modal) {
                    modal.style.display = 'flex'; // Mostrar el modal
                }
                buffer = "";
            }
        }
    });
        const btnAdmin = document.getElementById('btnAceptarAdmin');
    if (btnAdmin) {
        btnAdmin.addEventListener('click', redirigir);
    }
});

function redirigir() {
    window.location.href = 'login_admin.jsp'; // O la ruta que desees
}

