/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Servlets;

import SQL.ConexionBD;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ConsultarUsuariosServlet")
public class ConsultarUsuariosServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("rol") == null || !"administrador".equals(session.getAttribute("rol"))) {
            response.sendRedirect("login_admin.jsp");
            return;
        }

        String tipoUsuarioFiltro = request.getParameter("tipo_usuario");
        int limit = 10;
        int page = 1;
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
                if (page < 1) page = 1;
            } catch (Exception e) { page = 1; }
        }
        int offset = (page - 1) * limit;
        int totalRegistros = 0;
        List<UsuarioAdmin> listaUsuarios = new ArrayList<>();
        Connection conexion = null;
        PreparedStatement sentencia = null;
        ResultSet resultado = null;
        String mensajeError = null;

        try {
            conexion = ConexionBD.conectar();
            if (conexion != null) {
                // Contar total de registros para paginación
                String countSql = "SELECT COUNT(*) FROM Usuario";
                if (!"todos".equals(tipoUsuarioFiltro)) {
                    countSql += " WHERE tipo_usuario = ?";
                }
                PreparedStatement psCount = conexion.prepareStatement(countSql);
                if (!"todos".equals(tipoUsuarioFiltro)) {
                    psCount.setString(1, tipoUsuarioFiltro);
                }
                ResultSet rsCount = psCount.executeQuery();
                if (rsCount.next()) {
                    totalRegistros = rsCount.getInt(1);
                }
                rsCount.close();
                psCount.close();

                // Consulta paginada
                String consulta = "SELECT id, nombre, apellidos, usuario_generado, tipo_usuario FROM Usuario";
                if (!"todos".equals(tipoUsuarioFiltro)) {
                    consulta += " WHERE tipo_usuario = ?";
                }
                consulta += " ORDER BY id DESC LIMIT ? OFFSET ?";
                sentencia = conexion.prepareStatement(consulta);
                int idx = 1;
                if (!"todos".equals(tipoUsuarioFiltro)) {
                    sentencia.setString(idx++, tipoUsuarioFiltro);
                }
                sentencia.setInt(idx++, limit);
                sentencia.setInt(idx++, offset);
                resultado = sentencia.executeQuery();

                while (resultado.next()) {
                    UsuarioAdmin usuario = new UsuarioAdmin();
                    usuario.setId(resultado.getInt("id"));
                    usuario.setNombre(resultado.getString("nombre"));
                    usuario.setApellidos(resultado.getString("apellidos"));
                    usuario.setUsuarioGenerado(resultado.getString("usuario_generado"));
                    usuario.setTipoUsuario(resultado.getString("tipo_usuario"));
                    listaUsuarios.add(usuario);
                }
            } else {
                mensajeError = "Error al conectar a la base de datos.";
            }
        } catch (SQLException e) {
            mensajeError = "Error al consultar usuarios: " + e.getMessage();
            e.printStackTrace();
        } finally {
            try { if (resultado != null) resultado.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (sentencia != null) sentencia.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conexion != null && !conexion.isClosed()) conexion.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        int totalPaginas = (int) Math.ceil((double) totalRegistros / limit);
        request.setAttribute("listaUsuarios", listaUsuarios);
        request.setAttribute("error", mensajeError);
        request.setAttribute("page", page);
        request.setAttribute("totalPaginas", totalPaginas);
        request.getRequestDispatcher("consultar_usuarios.jsp").forward(request, response);
    }

    public static class UsuarioAdmin {
        private int id;
        private String nombre;
        private String apellidos;
        private String usuarioGenerado;
        private String tipoUsuario;

        // Getters y Setters
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }
        public String getNombre() { return nombre; }
        public void setNombre(String nombre) { this.nombre = nombre; }
        public String getApellidos() { return apellidos; }
        public void setApellidos(String apellidos) { this.apellidos = apellidos; }
        public String getUsuarioGenerado() { return usuarioGenerado; }
        public void setUsuarioGenerado(String usuarioGenerado) { this.usuarioGenerado = usuarioGenerado; }
        public String getTipoUsuario() { return tipoUsuario; }
        public void setTipoUsuario(String tipoUsuario) { this.tipoUsuario = tipoUsuario; }
    }
}