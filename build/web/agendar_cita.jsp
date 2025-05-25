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
            <label for="fecha" class="form-label">Fecha</label>
            <input type="date" class="form-control" id="fecha" name="fecha" required>
        </div>

        <!-- Hora -->
        <div class="mb-3">
            <label for="hora" class="form-label">Hora</label>
            <input type="time" class="form-control" id="hora" name="hora" required>
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
            <input type="text" class="form-control" id="motivo" name="motivo" required>
        </div>

        <!-- Botón para verificar disponibilidad -->
        <button type="submit" class="btn btn-primary">Agendar Cita</button>

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
            <button type="submit" class="btn btn-primary w-100" onclick="document.getElementById('accion').value='agendar';">Agendar Cita</button>
            <input type="hidden" id="accion" name="accion" value="verificar">
        <% } %>
    </form>
</main>


<script>

</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
