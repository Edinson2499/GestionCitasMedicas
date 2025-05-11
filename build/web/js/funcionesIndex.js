function cargarElementoDinamicamente(url, elemento){
    var request = new XMLHttpRequest();
    request.open("GET", url, false);
    request.send(null);
    elemento.innerHTML = request.responseText;
}
function cargarAltaUsuarioE(){
    cargarElementoDinamicamente("altaUsuarioE.jsp", document.getElementById("contenidoDinamico"));
    document.getElementById('contenidoDinamico').innerHTML += '<br><a href="index.html" class="menu move-to-top-inicioregistro"></a>';
}
function cargarAltaUsuario(){
    cargarElementoDinamicamente("altaUsuario.jsp", document.getElementById("contenidoDinamico"));
    document.getElementById('contenidoDinamico').innerHTML += '<br><a href="index.html" class="menu move-to-top-inicioregistro"></a>';
}

function cargarLogin() {
    cargarElementoDinamicamente("login.jsp", document.getElementById("contenidoDinamico"));
    const menu = document.getElementById("menu");
    if (menu) {
        console.log("Aplicando clase move-to-top-login");
        menu.classList.add('move-to-top-login');
        document.getElementById('contenidoDinamico').innerHTML += '<br><a href="index.html" class="menu move-to-top-inicio"></a>';
    } else {
        console.log("El elemento con ID 'menu' no se encontró");
    }
}
function mostrarSeleccionRegistro() {
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
    form.style.padding = "10px"; // Espaciado interno
    form.style.borderRadius = "5px"; // Bordes redondeados
    form.style.textAlign = "center";
    form.style.width = "218px"; // Ancho ajustado
    form.style.height = "94px"; // Altura ajustada
    form.style.boxShadow = "0 4px 8px rgba(0, 0, 0, 0.2)";
    form.style.display = "flex";
    form.style.flexDirection = "column";
    form.style.justifyContent = "space-between"; // Espaciado uniforme entre los elementos
    form.style.alignItems = "center";

    // Estilo del select
    const select = document.createElement("select");
    select.id = "tipoUsuario";
    select.style.width = "100%"; // Ancho completo del contenedor
    select.style.margin = "0"; // Sin margen
    select.style.height = "30px"; // Altura ajustada
    select.style.border = "1px solid #ccc"; // Borde delgado
    select.style.borderRadius = "5px"; // Bordes redondeados
    select.style.padding = "2px"; // Espaciado interno
    select.style.fontSize = "14px"; // Tamaño de fuente

    const option1 = document.createElement("option");
    option1.value = "especialista";
    option1.innerText = "Especialista";
    select.appendChild(option1);
    
    const option2 = document.createElement("option");
    option2.value = "paciente";
    option2.innerText = "Paciente";
    select.appendChild(option2);
    
    form.appendChild(select);

    // Estilo del botón
    const button = document.createElement("button");
    button.innerText = "Seleccionar";
    button.style.width = "100%"; // Ancho completo del contenedor
    button.style.margin = "5px 0"; // Margen superior e inferior
    button.style.height = "30px"; // Altura ajustada
    button.style.backgroundColor = "#f5f5f5"; // Color de fondo
    button.style.color = "#000"; // Color del texto
    button.style.border = "1px solid #ccc"; // Borde delgado
    button.style.borderRadius = "5px"; // Bordes redondeados
    button.style.fontSize = "14px"; // Tamaño de fuente
    button.style.cursor = "pointer"; // Cursor de puntero

    button.onclick = function() {
        const tipoUsuario = select.value;
        const menu = document.getElementById("menu");
        if (tipoUsuario === "especialista") {
            cargarAltaUsuarioE();
        } else if (tipoUsuario === "paciente") {
            cargarAltaUsuario();
        }
        if (menu) {
            menu.classList.remove('move-to-top-login');
            menu.classList.add('move-to-top-registro');
        }
        document.body.removeChild(modal);
    };
    
    form.appendChild(button);
    modal.appendChild(form);
    document.body.appendChild(modal);
}