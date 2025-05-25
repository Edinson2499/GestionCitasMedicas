<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Actualizar Disponibilidad</title>
    <link rel="icon" href="imagenes/Logo.png" type="image/png">
    <link rel="stylesheet" href="css/estilos_actualizar_disponibilidad.css">
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <h1>Actualizar Disponibilidad, <%= nombreEspecialista %></h1>
    <div class="container-disponibilidad">
        <p>Aquí podrás ver y modificar tu horario de atención.</p>
        <!-- Mostrar disponibilidad actual -->
        <%
            String disponibilidadActual = (String) request.getAttribute("disponibilidadActual");
            if (disponibilidadActual != null && !disponibilidadActual.isEmpty()) {
        %>
            <div class="alert alert-info">
                <strong>Disponibilidad actual:</strong> <%= disponibilidadActual %>
            </div>
        <%
            }
        %>
        <!-- Mensaje de éxito o error -->
        <%
            String mensaje = (String) request.getAttribute("mensaje");
            if (mensaje != null && !mensaje.isEmpty()) {
        %>
            <div class="alert <%= mensaje.contains("éxito") ? "alert-success" : "alert-danger" %>">
                <%= mensaje %>
            </div>
        <%
            }
        %>
        <form action="GuardarDisponibilidadServlet" method="post" class="row g-3">
            <div class="col-12">
                <label for="fecha" class="form-label">Fecha</label>
                <input type="date" class="form-control" id="fecha" name="fecha" required>
            </div>
            <div class="col-12">
                <label for="hora_inicio" class="form-label">Hora de Inicio</label>
                <input type="time" class="form-control" id="hora_inicio" name="hora_inicio" required>
            </div>
            <div class="col-12">
                <label for="hora_fin" class="form-label">Hora de Fin</label>
                <input type="time" class="form-control" id="hora_fin" name="hora_fin" required>
            </div>
            <div class="col-12">
                <button type="submit" class="btn btn-primary btn-guardar">Guardar Disponibilidad</button>
            </div>
        </form>
    </div>

    <br>
    <a class="btn-back" href="menu_especialista.jsp" title="Volver al menú especialista"></a>

    <!-- Bootstrap JS Bundle CDN -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>