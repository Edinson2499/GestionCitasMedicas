<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.List,java.util.Map" %>
<%
    if (session.getAttribute("idUsuario") == null || !"especialista".equals(session.getAttribute("rol"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer idEspecialista = (Integer) session.getAttribute("idUsuario");
    String nombreEspecialista = (String) session.getAttribute("nombre");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Historial de Pacientes</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="imagenes/Logo.png" type="image/png">
    <link rel="stylesheet" href="css/estilos_historial_pacientes.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <a href="menu_especialista.jsp" class="btn-back" title="Volver al menú especialista"></a>

    <div class="container mt-5 mb-5">
        <h1 class="text-center mb-4">Historial de Pacientes, <%= nombreEspecialista %></h1>

        <div class="card p-4 shadow">
            <p class="mb-3">Aquí podrás buscar pacientes y acceder a su historial médico.</p>

            <form action="BuscarPacienteServlet" method="get" class="needs-validation" novalidate>
                <div class="mb-3">
                    <label for="nombre_paciente" class="form-label">Nombre del paciente:</label>
                    <input type="text" class="form-control" id="nombre_paciente" name="nombre_paciente" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">Buscar Paciente</button>
            </form>

            <div id="resultado_historial" class="mt-4">
<%
    List<Map<String, Object>> pacientes = (List<Map<String, Object>>) request.getAttribute("pacientes");
    if (pacientes != null) {
        if (pacientes.isEmpty()) {
%>
            <div class="alert alert-warning">No se encontraron pacientes con ese nombre.</div>
<%
        } else {
%>
            <ul class="list-group">
<%
            for (Map<String, Object> paciente : pacientes) {
                Integer id = (Integer) paciente.get("id");
                String nombre = (String) paciente.get("nombre");
                String apellidos = (String) paciente.get("apellidos");
%>
                <li class="list-group-item">
                    <a href="historial_medico_paciente.jsp?id=<%= id %>">
                        <%= nombre %> <%= apellidos %>
                    </a>
                </li>
<%
            }
%>
            </ul>
<%
        }
    }
%>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
