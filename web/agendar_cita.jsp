<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
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
    <!-- Formulario para consultar disponibilidad -->
    <form action="AgendarCitaServlet" method="post">
        <input type="hidden" name="accion" value="consultar">
        <!-- Fecha -->
        <div class="mb-3">
            <label for="fecha" class="form-label">Fecha</label>
            <input type="date" class="form-control" id="fecha" name="fecha" required value="<%= request.getParameter("fecha") != null ? request.getParameter("fecha") : "" %>">
        </div>
        <!-- Especialidad -->
        <div class="mb-3">
            <label for="especialidad" class="form-label">Especialidad</label>
            <select class="form-control" id="especialidad" name="especialidad" required>
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
            </select>
        </div>
        <!-- Motivo de la cita -->
        <div class="mb-3">
            <label for="motivo" class="form-label">Motivo de la cita</label>
            <input type="text" class="form-control" id="motivo" name="motivo" required value="<%= request.getParameter("motivo") != null ? request.getParameter("motivo") : "" %>">
        </div>
        <button type="submit" class="btn btn-primary">Consultar Disponibilidad</button>
        <div id="mensaje">
            <% if (request.getAttribute("mensaje") != null) { %>
                <p><%= request.getAttribute("mensaje") %></p>
            <% } %>
        </div>
    </form>

    <!-- Mostrar horarios disponibles solo si existen -->
    <% if (request.getAttribute("disponibilidadEspecialistas") != null) {
        Map<String, List<String>> disponibilidad = (Map<String, List<String>>) request.getAttribute("disponibilidadEspecialistas");
        boolean hayHorarios = false;
        for (List<String> horarios : disponibilidad.values()) {
            if (!horarios.isEmpty()) { hayHorarios = true; break; }
        }
    %>
        <h2 class="mt-4">Horarios Disponibles:</h2>
        <% if (hayHorarios) { %>
        <form action="AgendarCitaServlet" method="post">
            <input type="hidden" name="accion" value="agendar">
            <input type="hidden" name="especialidad" value="<%= request.getParameter("especialidad") %>">
            <input type="hidden" name="fecha" value="<%= request.getParameter("fecha") %>">
            <input type="hidden" name="motivo" value="<%= request.getParameter("motivo") %>">
            <div class="mb-3">
                <label for="especialistaSeleccionado" class="form-label">Especialista:</label>
                <select id="especialistaSeleccionado" name="especialistaSeleccionado" class="form-select" required>
                    <% for (String especialista : disponibilidad.keySet()) { %>
                        <option value="<%= especialista %>"><%= especialista %></option>
                    <% } %>
                </select>
            </div>
            <div class="mb-3">
                <label for="horarioSeleccionado" class="form-label">Horario:</label>
                <select id="horarioSeleccionado" name="horarioSeleccionado" class="form-select" required>
                    <% 
                    // Por defecto, muestra los horarios del primer especialista
                    List<String> horarios = disponibilidad.values().iterator().next();
                    for (String horario : horarios) { %>
                        <option value="<%= horario %>"><%= horario %></option>
                    <% } %>
                </select>
            </div>
            <button type="submit" class="btn btn-success">Agendar Cita</button>
        </form>
        <% } else { %>
            <div class="alert alert-warning">No hay horarios disponibles para los especialistas seleccionados en esa fecha.</div>
        <% } %>
    <% } %>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<% if (request.getAttribute("disponibilidadEspecialistas") != null) { %>
<script>
document.addEventListener("DOMContentLoaded", function() {
    var especialistaSelect = document.getElementById("especialistaSeleccionado");
    var horarioSelect = document.getElementById("horarioSeleccionado");

    function actualizarHorarios() {
        var especialista = especialistaSelect.value;
        var horarios = disponibilidadEspecialistas[especialista] || [];
        horarioSelect.innerHTML = "";
        horarios.forEach(function(horario) {
            var opt = document.createElement("option");
            opt.value = horario;
            opt.textContent = horario;
            horarioSelect.appendChild(opt);
        });
    }

    if (especialistaSelect && horarioSelect) {
        especialistaSelect.addEventListener("change", actualizarHorarios);
        actualizarHorarios(); // Inicializa con el primero
    }
});
</script>
<% } %>
</body>
</html>
