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

    // Detectar escritura de "admin"
    window.addEventListener('keydown', function(e) {
        if (e.key.length === 1) {
            buffer += e.key.toLowerCase();

            if (buffer.length > 10) {
                buffer = buffer.slice(-10);
            }

            if (buffer.includes("admin")) {
                const modal = document.getElementById('modalAdmin');
                if (modal) {
                    modal.style.display = 'flex';
                }
                buffer = "";
            }
        }
    // Botón Aceptar dentro del modal
    const btnAdmin = document.getElementById('btnAceptarAdmin');
    if (btnAdmin) {
        btnAdmin.addEventListener('click', redirigir);
    }

    // Redirigir si el modal está visible y se presiona Enter
    if (e.key === 'Enter') {
        const modal = document.getElementById('modalAdmin');
        if (modal && getComputedStyle(modal).display !== 'none') {
            e.preventDefault();
            redirigir();
        }
    }
});
// Función para redirigir a la página de administración

function redirigir() {
    window.location.href = 'login_admin.jsp'; // O la ruta que desees
}

});

function redirigir() {
    window.location.href = 'login_admin.jsp'; // O la ruta que desees
}
