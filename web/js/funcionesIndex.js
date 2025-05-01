/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function cargarElementoDinamicamente(url, elemento){
    var request = new XMLHttpRequest();
    request.open("GET", url, false);
    request.send(null);
    elemento.innerHTML = request.responseText;
}
function cargarAltaUsuarioE(){
    cargarElementoDinamicamente("altaUsuarioE.jsp", document.getElementById("contenidoDinamico"));
}
function cargarAltaUsuario(){
    cargarElementoDinamicamente("altaUsuario.jsp", document.getElementById("contenidoDinamico"));
}

function cargarLogin(){
    cargarElementoDinamicamente("login.jsp", document.getElementById("contenidoDinamico"));
}
 function mostrarSeleccionRegistro() {
                // Creamos el formulario con un <select> para elegir Especialista o Paciente
                const modal = document.createElement("div");
                modal.style.position = "fixed";
                modal.style.top = "0";
                modal.style.left = "0";
                modal.style.width = "100%";
                modal.style.height = "100%";
                modal.style.backgroundColor = "rgba(0,0,0,0.5)";
                modal.style.display = "flex";
                modal.style.justifyContent = "center";
                modal.style.alignItems = "center";
                modal.style.zIndex = "1000";
                modal.id = "modalSeleccion";
                
                const form = document.createElement("div");
                form.style.backgroundColor = "#fff";
                form.style.padding = "20px";
                form.style.borderRadius = "8px";
                form.style.textAlign = "center";
                
                const label = document.createElement("label");
                label.innerText = "Selecciona el tipo de usuario: ";
                form.appendChild(label);
                
                const select = document.createElement("select");
                select.id = "tipoUsuario";
                
                const option1 = document.createElement("option");
                option1.value = "especialista";
                option1.innerText = "Especialista";
                select.appendChild(option1);
                
                const option2 = document.createElement("option");
                option2.value = "paciente";
                option2.innerText = "Paciente";
                select.appendChild(option2);
                
                form.appendChild(select);
                
                const button = document.createElement("button");
                button.innerText = "Seleccionar";
                button.style.marginTop = "10px";
                button.onclick = function() {
                    const tipoUsuario = select.value;
                    if (tipoUsuario === "especialista") {
                        cargarAltaUsuarioE(); // Llamada para el registro de Especialista
                    } else if (tipoUsuario === "paciente") {
                        cargarAltaUsuario(); // Llamada para el registro de Paciente
                    }
                    // Cerrar el modal después de la selección
                    document.body.removeChild(modal);
                };
                
                form.appendChild(button);
                modal.appendChild(form);
                document.body.appendChild(modal);
            }