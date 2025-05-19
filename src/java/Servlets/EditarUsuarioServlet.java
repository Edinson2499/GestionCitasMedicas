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
            String sql = "SELECT id, nombre, apellidos, tipo_usuario FROM Usuario WHERE id = ?";
            ps = conexion.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(idUsuario));
            rs = ps.executeQuery();

            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();

            if (rs.next()) {
                out.println("<!DOCTYPE html>");
                out.println("<html lang='es'><head><meta charset='UTF-8'><title>Editar Usuario</title>");
                out.println("<link rel='stylesheet' href='css/estilos_editar_usuario.css'></head><body>");
                out.println("<h1>Editar Usuario</h1>");
                out.println("<form action='GuardarEdicionUsuarioServlet' method='post'>");
                out.println("<input type='hidden' name='id' value='" + rs.getInt("id") + "'>");
                out.println("<div class='form-group'><label>Nombre:</label>");
                out.println("<input type='text' name='nombre' value='" + rs.getString("nombre") + "' required></div>");
                out.println("<div class='form-group'><label>Apellido:</label>");
                out.println("<input type='text' name='apellido' value='" + rs.getString("apellidos") + "' required></div>");
                out.println("<div class='form-group'><label>Tipo de Usuario:</label>");
                out.println("<select name='tipo_usuario'>");
                String tipo = rs.getString("tipo_usuario");
                out.println("<option value='paciente'" + ("paciente".equals(tipo) ? " selected" : "") + ">Paciente</option>");
                out.println("<option value='especialista'" + ("especialista".equals(tipo) ? " selected" : "") + ">Especialista</option>");
                out.println("<option value='administrador'" + ("administrador".equals(tipo) ? " selected" : "") + ">Administrador</option>");
                out.println("</select></div>");
                out.println("<input type='submit' value='Guardar Cambios' class='btn'>");
                out.println("</form>");
                out.println("<br><a href='editar_usuario.jsp'>Volver</a>");
                out.println("</body></html>");
            } else {
                response.sendRedirect("editar_usuario.jsp");
            }
        } catch (Exception e) {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<p>Error al cargar usuario: " + e.getMessage() + "</p>");
            out.println("<a href='editar_usuario.jsp'>Volver</a>");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conexion != null) conexion.close(); } catch (Exception e) {}
        }
    }
}