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
    if (menu) {
        menu.classList.add('move-to-top');
    }
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
    form.style.padding = "10px";
    form.style.borderRadius = "8px";
    form.style.textAlign = "center";
    form.style.width = "218px"; // Ancho ajustado
    form.style.height = "94px"; // Altura ajustada
    form.style.boxShadow = "0 4px 8px rgba(0, 0, 0, 0.2)";
    form.style.display = "flex";
    form.style.flexDirection = "column";
    form.style.justifyContent = "space-between"; // Espaciado uniforme entre los elementos
    form.style.alignItems = "center"; // Centramos el contenido horizontalmente

    const select = document.createElement("select");
    select.id = "tipoUsuario";
    select.style.width = "calc(100% - 20px)"; // Ancho ajustado con margen
    select.style.margin = "10px 0"; // Margen ajustado
    select.style.height = "30px"; // Altura ajustada
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
    button.style.width = "calc(100% - 20px)"; // Ancho ajustado con margen
    button.style.margin = "10px 0"; // Margen ajustado
    button.style.height = "30px"; // Altura ajustada
    button.onclick = function() {
        const tipoUsuario = select.value;
        const menu = document.getElementById("menu"); // Asumimos que el menú tiene este ID
        if (tipoUsuario === "especialista") {
            cargarAltaUsuarioE(); // Llamada para el registro de Especialista
        } else if (tipoUsuario === "paciente") {
            cargarAltaUsuario(); // Llamada para el registro de Paciente
        }
        if (menu) {
            menu.classList.add('move-to-top'); // Aplicamos la clase 'move-to-top'
        }
        // Cerrar el modal después de la selección
        document.body.removeChild(modal);
    };
    
    form.appendChild(button);
    modal.appendChild(form);
    document.body.appendChild(modal);
}
