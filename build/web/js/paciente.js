/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/javascript.js to edit this template
 */
function agendarCita() {
    let fecha = document.getElementById("fecha").value;
    let hora = document.getElementById("hora").value;
    if (fecha && hora) {
        alert("Cita agendada para " + fecha + " a las " + hora);
        localStorage.setItem("cita", JSON.stringify({ fecha, hora }));
    } else {
        alert("Seleccione una fecha y hora válida.");
    }
}

function cargarCitas() {
    let cita = localStorage.getItem("cita");
    if (cita) {
        let datos = JSON.parse(cita);
        document.getElementById("listaCitas").innerHTML = "Cita el " + datos.fecha + " a las " + datos.hora;
    }
}
 function agendarCita() {
            const fecha = document.getElementById("fecha").value;
            const hora = document.getElementById("hora").value;
            const especialidad = document.getElementById("especialidad").value;
            
            if (fecha && hora && especialidad) {
                document.getElementById("mensaje").innerText = `Cita agendada para ${fecha} a las ${hora} en ${especialidad}.`;
            } else {
                alert("Por favor, complete todos los campos.");
            }
        }

