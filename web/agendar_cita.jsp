<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agendamiento</title>
    <link rel="icon" href="imagenes/Logo.png" type="image/png">
    <link rel="stylesheet" href="css/estilosAgendarCita.css" type="text/css" media="all">
</head>
<body>
    <header>
        <h1>Agende su Cita</h1>
    </header>
    <main>
        <form action="VerificarDisponibilidadServlet" method="post">
            <label for="fecha">Seleccione la fecha:</label>
            <input type="date" id="fecha" name="fecha" required>

            <label for="hora">Seleccione la hora:</label>
            <input type="time" id="hora" name="hora" required>

            <label for="especialidad">Especialidad:</label>
            <select id="especialidad" name="especialidad" required>
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
                    <option value="Inmunología">Inmunología</option>
                </select>

            <button type="submit">Verificar Disponibilidad</button>
            <p id="mensaje"></p>
            <% if (request.getAttribute("mensaje") != null) { %>
                <p><%= request.getAttribute("mensaje") %></p>
            <% } %>
            <% if (request.getAttribute("especialistasDisponibles") != null) { %>
                <h2>Especialistas Disponibles:</h2>
                <ul>
                    <% java.util.List<String> especialistas = (java.util.List<String>) request.getAttribute("especialistasDisponibles");
                       for (String especialista : especialistas) { %>
                           <li><%= especialista %></li>
                    <% } %>
                </ul>
                <label for="especialistaSeleccionado">Seleccione un especialista (opcional):</label>
                <select id="especialistaSeleccionado" name="especialistaSeleccionado">
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