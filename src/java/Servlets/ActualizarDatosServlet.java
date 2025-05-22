package Servlets;

import SQL.ConexionBD;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/ActualizarDatosServlet")
public class ActualizarDatosServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer idPaciente = (Integer) session.getAttribute("idUsuario");
        if (idPaciente == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String nombre = request.getParameter("nombre");
        String apellidos = request.getParameter("apellidos");
        String telefono = request.getParameter("telefono");
        String direccion = request.getParameter("direccion");
        String correo = request.getParameter("correo");
        String mensaje;

        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = ConexionBD.conectar();
            String sql = "UPDATE Usuario SET nombre=?, apellidos=?, telefono=?, direccion=?, correo=? WHERE id=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, nombre);
            ps.setString(2, apellidos);
            ps.setString(3, telefono);
            ps.setString(4, direccion);
            ps.setString(5, correo);
            ps.setInt(6, idPaciente);
            int filas = ps.executeUpdate();
            if (filas > 0) {
                mensaje = "Datos actualizados correctamente.";
                session.setAttribute("nombre", nombre); // Actualiza el nombre en sesión
            } else {
                mensaje = "No se pudo actualizar los datos.";
            }
        } catch (Exception e) {
            mensaje = "Error al actualizar datos: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        request.setAttribute("mensaje", mensaje);
        request.getRequestDispatcher("actualizar_datos.jsp").forward(request, response);
    }
}