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
                <button type="submit" formaction="AgendarCitaServlet">Agendar Cita</button>
            <% } %>
        </form>
    </main>
    <a href="menu_paciente.jsp"></a>
</body>
</html>
