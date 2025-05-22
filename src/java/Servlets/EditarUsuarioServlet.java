package Servlets;

import SQL.ConexionBD;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/EditarUsuarioServlet")
public class EditarUsuarioServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idUsuario = request.getParameter("id");
        if (idUsuario == null || idUsuario.isEmpty()) {
            response.sendRedirect("editar_usuario.jsp");
            return;
        }

        Connection conexion = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conexion = ConexionBD.conectar();
            String sql = "SELECT u.id, u.nombre, u.apellidos, u.tipo_usuario, u.contrasena, u.telefono, u.direccion, u.correo, e.especialidad " +
                        "FROM Usuario u LEFT JOIN Especialista e ON u.id = e.id_usuario WHERE u.id = ?";
            ps = conexion.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(idUsuario));
            rs = ps.executeQuery();

            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();

            if (rs.next()) {
                out.println("<!DOCTYPE html>");
                out.println("<html lang='es'>");
                out.println("<head>");
                out.println("<meta charset='UTF-8'>");
                out.println("<title>Editar Usuario</title>");
                out.println("<link rel='stylesheet' href='css/estilos_editar_usuario.css'>");
                out.println("<link rel='icon' href='imagenes/Logo.png' type='image/png'>");
                // Agrega el script para mostrar/ocultar especialidad
                out.println("<script>");
                out.println("function mostrarEspecialidad() {");
                out.println("  var tipo = document.getElementById('tipo_usuario').value;");
                out.println("  var campoEsp = document.getElementById('campoEspecialidad');");
                out.println("  campoEsp.style.display = (tipo === 'especialista') ? 'block' : 'none';");
                out.println("}");
                out.println("window.onload = function() { mostrarEspecialidad(); };");
                out.println("</script>");
                out.println("</head>");
                out.println("<body>");
                out.println("<h1>Editar Usuario</h1>");
                out.println("<form action='GuardarEdicionUsuarioServlet' method='post'>");
                out.println("<input type='hidden' name='id' value='" + rs.getInt("id") + "'>");
                out.println("<div class='form-group'><label>Nombre:</label>");
                out.println("<input type='text' name='nombre' value='" + rs.getString("nombre") + "' required></div>");
                out.println("<div class='form-group'><label>Apellido:</label>");
                out.println("<input type='text' name='apellido' value='" + rs.getString("apellidos") + "' required></div>");
                out.println("<div class='form-group'><label style='display: inline-block; width: 100px; text-align: left; margin-right: 5px; margin-bottom: 5px;'>Tipo de Usuario:</label>");
                out.println("<select name='tipo_usuario' id='tipo_usuario' onchange='mostrarEspecialidad()' required>");
                String tipo = rs.getString("tipo_usuario");
                out.println("<option value='paciente'" + ("paciente".equals(tipo) ? " selected" : "") + ">Paciente</option>");
                out.println("<option value='especialista'" + ("especialista".equals(tipo) ? " selected" : "") + ">Especialista</option>");
                out.println("<option value='administrador'" + ("administrador".equals(tipo) ? " selected" : "") + ">Administrador</option>");
                out.println("</select></div>");
                out.println("<div class='form-group'><label>Contraseña:</label>");
                out.println("<input type='text' name='contrasena' value='" + (rs.getString("contrasena") != null ? rs.getString("contrasena") : "") + "' required></div>");
                out.println("<div class='form-group'><label>Teléfono:</label>");
                out.println("<input type='text' name='telefono' value='" + (rs.getString("telefono") != null ? rs.getString("telefono") : "") + "'></div>");
                out.println("<div class='form-group'><label>Dirección:</label>");
                out.println("<input type='text' name='direccion' value='" + (rs.getString("direccion") != null ? rs.getString("direccion") : "") + "'></div>");
                out.println("<div class='form-group'><label>Correo:</label>");
                out.println("<input type='text' name='correo' value='" + (rs.getString("correo") != null ? rs.getString("correo") : "") + "' required></div>");
                // Campo especialidad, visible solo si es especialista
                String displayEsp = "especialista".equals(tipo) ? "block" : "none";
                out.println("<div class='form-group' id='campoEspecialidad' style='display:" + displayEsp + "; margin-bottom: 10px;'>");
                out.println("<label style='display: inline-block; width: 100px; text-align: left; margin-right: 5px; margin-bottom: 5px;'>Especialidad:</label>");
                out.println("<input list='especialidad' placeholder='Seleccione una especialidad' class='txt' id='txtEspecialidad' name='especialidad' required style='margin-bottom: 5px; width: 220px;' value='" + (rs.getString("especialidad") != null ? rs.getString("especialidad") : "") + "'>");
                out.println("<datalist id='especialidad'>");
                out.println("<option value='Cardiología'></option>");
                out.println("<option value='Dermatología'></option>");
                out.println("<option value='Pediatría'></option>");
                out.println("<option value='Neurología'></option>");
                out.println("<option value='Oncología'></option>");
                out.println("<option value='Psiquiatría'></option>");
                out.println("<option value='Ginecología'></option>");
                out.println("<option value='Oftalmología'></option>");
                out.println("<option value='Ortopedia'></option>");
                out.println("<option value='Endocrinología'></option>");
                out.println("<option value='Traumatología'></option>");
                out.println("<option value='Otorrinolaringología'></option>");
                out.println("<option value='Medicina Interna'></option>");
                out.println("<option value='Urología'></option>");
                out.println("<option value='Radiología'></option>");
                out.println("<option value='Anestesiología'></option>");
                out.println("<option value='Cirugía General'></option>");
                out.println("<option value='Neumología'></option>");
                out.println("<option value='Gastroenterología'></option>");
                out.println("<option value='Nefrología'></option>");
                out.println("</datalist>");
                out.println("</div>");
                out.println("<button type='submit' class='btn btn-primary'>Guardar Cambios</button>");
                out.println("</form>");
                out.println("<a href='editar_usuario.jsp' class='btn-back' title='Volver al menú'></a>");
                out.println("</body></html>");
            } else {
                response.sendRedirect("editar_usuario.jsp");
            }
        } catch (Exception e) {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<p class='error-message'>Error al cargar usuario: " + e.getMessage() + "</p>");
            out.println("<a href='editar_usuario.jsp' class='btn-back' title='Volver al menú'></a>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conexion != null) conexion.close(); } catch (Exception e) {}
        }
    }
}