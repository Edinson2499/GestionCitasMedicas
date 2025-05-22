<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Agendar Cita</title>
    <link rel="icon" href="imagenes/Logo.png" type="image/png">
    <link rel="stylesheet" href="css/estilosAgendarCita.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<!-- Botón de volver -->
<a class="btn btn-back" href="menu_paciente.jsp" title="Volver al menú paciente"></a>

<h1>Agendar Cita Médica</h1>

<main>
    <form action="AgendarCitaServlet" method="post">
        <!-- Fecha -->
        <div class="mb-3">
            <label for="fecha" class="form-label">Fecha:</label>
            <input type="date" id="fecha" name="fecha" class="form-control" required>
        </div>

        <!-- Hora -->
        <div class="mb-3">
            <label for="hora" class="form-label">Hora:</label>
            <input type="time" id="hora" name="hora" class="form-control" required>
        </div>

        <!-- Especialidad -->
        <div class="mb-3">
            <label for="especialidad" class="form-label">Especialidad:</label>
            <select id="especialidad" name="especialidad" class="form-select" required>
                <!-- Opciones agregadas por JS -->
            </select>
        </div>

        <!-- Botón para verificar disponibilidad -->
        <button type="submit" class="btn btn-primary w-100">Verificar Disponibilidad</button>

        <!-- Mensaje -->
        <div id="mensaje">
            <% if (request.getAttribute("mensaje") != null) { %>
                <p><%= request.getAttribute("mensaje") %></p>
            <% } %>
        </div>

        <!-- Especialistas disponibles (solo si existen) -->
        <% if (request.getAttribute("especialistasDisponibles") != null) {
            List<String> especialistas = (List<String>) request.getAttribute("especialistasDisponibles");
        %>
            <h2 class="mt-4">Especialistas Disponibles:</h2>
            <ul class="list-group mb-3">
                <% for (String especialista : especialistas) { %>
                    <li class="list-group-item"><%= especialista %></li>
                <% } %>
            </ul>
            <div class="mb-3">
                <label for="especialistaSeleccionado" class="form-label">Seleccione un especialista (opcional):</label>
                <select id="especialistaSeleccionado" name="especialistaSeleccionado" class="form-select">
                    <option value="">Cualquier especialista disponible</option>
                    <% for (String especialista : especialistas) { %>
                        <option value="<%= especialista %>"><%= especialista %></option>
                    <% } %>
                </select>
            </div>
            <button type="submit" formaction="AgendarCitaServlet" class="btn btn-success w-100">Agendar Cita</button>
        <% } %>
    </form>
</main>

<!-- Contenedor para carga dinámica vía JS -->
<div id="especialistas-dinamicos"></div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const selectEspecialidad = document.getElementById("especialidad");
    const container = document.getElementById("especialistas-dinamicos");

    // Cargar especialidades dinámicamente
    fetch("${pageContext.request.contextPath}/Especialidades")
        .then(response => response.json())
        .then(data => {
            console.log("Especialidades recibidas:", data);
            selectEspecialidad.innerHTML = '<option value="" >Seleccione una especialidad</option>';
            data.forEach(especialidad => {
                if (typeof especialidad === "string" && especialidad.trim() !== "") {
                    const valor = especialidad.trim();
                    selectEspecialidad.innerHTML += `<option value="${valor}">${valor}</option>`;
                }
            });
        });

    // Al cambiar especialidad, cargar horarios disponibles
    selectEspecialidad.addEventListener("change", function () {
        console.log("Seleccionaste:", this.value);
        const especialidad = this.value;
        if (!especialidad) return;

        fetch("HorariosPorEspecialidad?especialidad=" + encodeURIComponent(especialidad))
            .then(response => response.json())
            .then(data => {
                if (data.length === 0) {
                    container.innerHTML = "<p class='text-danger mt-3'>No hay horarios disponibles para esta especialidad.</p>";
                    return;
                }
                let html = '<h2 class="mt-4">Horarios Disponibles:</h2>';
                html += '<ul class="list-group mb-3">';
                data.forEach(horario => {
                    html += `<li class="list-group-item">Fecha: ${horario.fecha} | De: ${horario.hora_inicio} a ${horario.hora_fin}</li>`;
                });
                html += '</ul>';
                container.innerHTML = html;
            })
            .catch(error => {
                console.error("Error al obtener horarios:", error);
                container.innerHTML = "<p class='text-danger mt-3'>Error al cargar horarios.</p>";
            });
    });
});
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
