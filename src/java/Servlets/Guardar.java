package Servlets;

import SQL.MetodosSQL;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class Guardar extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        MetodosSQL metodos = new MetodosSQL();

        String id = request.getParameter("txtId"); // Obtener el ID (aunque es autoincremental, lo recibimos)
        String nombre = request.getParameter("txtNombre");
        String apellidos = request.getParameter("txtApellidos");
        String telefono = request.getParameter("txtTelefono");
        String direccion = request.getParameter("txtDireccion");
        String contrasena = request.getParameter("txtContrasena");
        String usuarioGeneradoAutomaticamente = request.getParameter("txtUsuarioGeneradoAutomaticamente");
        String rol = request.getParameter("rol"); // Obtenemos el rol del formulario (especialista o paciente)
        String especialidad = null;
        String numeroTarjetaProfesional = null;

        if ("especialista".equals(rol)) {
            especialidad = request.getParameter("txtEspecialidad");
            numeroTarjetaProfesional = request.getParameter("txtTp");
        }

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Guardar Usuario</title>");
        out.println("</head>");
        out.println("<body>");
        out.println("<script type=\"text/javascript\">");

        boolean usuarioRepetido = metodos.buscarUsuarioRepetidoBD(usuarioGeneradoAutomaticamente);

        if (usuarioRepetido) {
            out.println("alert('¡Atención!, El usuario con el nombre de usuario generado: " + usuarioGeneradoAutomaticamente + ", ya está registrado.')");
            out.println("location='index.html'"); // Redirigir a la página principal o al formulario de registro
        } else {
            boolean registroExitoso = metodos.registrarUsuario(
                    id, nombre, apellidos, telefono, direccion, contrasena,
                    usuarioGeneradoAutomaticamente, rol, especialidad, numeroTarjetaProfesional
            );

            if (registroExitoso) {
                out.println("alert('El usuario se ha registrado con éxito :) ')");
                out.println("location='index.html'"); // Redirigir a una página de éxito
            } else {
                out.println("alert('ERROR: No se pudo registrar el usuario :( ')");
                out.println("location='index.html'"); // Redirigir a una página de error o al formulario de registro
            }
        }

        out.println("</script>");
        out.println("</body>");
        out.println("</html>");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet para guardar usuarios (especialistas y pacientes)";
    }
}