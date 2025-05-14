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
        out.println("<meta charset='UTF-8'>");
        out.println("<title>Guardar Usuario</title>");
        out.println("<link rel='icon' href='imagenes/Logo.png' type='image/png'>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("<style>");
        out.println("body { margin: 0; font-family: Arial, sans-serif; background-color: #e6f4fe; }");
        out.println(".modal { display: flex; justify-content: center; align-items: center; position: fixed; z-index: 9999; left: 0; top: 0; width: 100%; height: 100%; }");
        out.println(".modal-content {");
        out.println("  background: linear-gradient(135deg, #a1c4fd 0%, #c2e9fb 100%);");
        out.println("  color: #000000;");
        out.println("  padding: 30px;");
        out.println("  border-radius: 12px;");
        out.println("  text-align: center;");
        out.println("  width: 90%; max-width: 400px;");
        out.println("  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);");
        out.println("}");
        out.println(".modal-content h2 { margin-top: 0; font-weight: bold; }");
        out.println(".modal-content p { margin: 10px 0; }");
        out.println(".modal-content button { background-color:rgba(113, 206, 239, 1); border: none; color: black; padding: 10px 20px; margin-top: 20px; font-size: 16px; cursor: pointer; border-radius: 8px; }");
        out.println(".modal-content button:hover { background-color:rgba(90, 180, 220, 1); }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");

        boolean usuarioRepetido = metodos.buscarUsuarioRepetidoBD(usuarioGeneradoAutomaticamente);

        if (usuarioRepetido) {
            out.println("<div class='modal' id='usuarioRepetidoModal'>");
            out.println("  <div class='modal-content'>");
            out.println("    <h2>¡Atención!</h2>");
            out.println("    <p>El nombre de usuario generado <strong>" + usuarioGeneradoAutomaticamente + "</strong> ya está registrado.</p>");
            out.println("    <button onclick='redirigir()'>Aceptar</button>");
            out.println("  </div>");
            out.println("</div>");
            out.println("<script>");
            out.println("function redirigir() { window.location = 'index.html'; }");
            out.println("setTimeout(redirigir, 3000);");
            out.println("</script>");
        } else {
            boolean registroExitoso = metodos.registrarUsuario(
                id, nombre, apellidos, telefono, direccion, contrasena,
                usuarioGeneradoAutomaticamente, rol, especialidad, numeroTarjetaProfesional
            );

            if (registroExitoso) {
                out.println("<div class='modal' id='registroExitosoModal'>");
                out.println("  <div class='modal-content'>");
                out.println("    <h2>¡Registro Exitoso!</h2>");
                out.println("    <p>El usuario ha sido registrado correctamente :)</p>");
                out.println("    <button onclick='redirigir()'>Aceptar</button>");
                out.println("  </div>");
                out.println("</div>");
            } else {
                out.println("<div class='modal' id='registroErrorModal'>");
                out.println("  <div class='modal-content'>");
                out.println("    <h2>¡Error!</h2>");
                out.println("    <p>No se pudo registrar el usuario :(</p>");
                out.println("    <button onclick='redirigir()'>Aceptar</button>");
                out.println("  </div>");
                out.println("</div>");
            }

            out.println("<script>");
            out.println("function redirigir() { window.location = 'index.html'; }");
            out.println("setTimeout(redirigir, 3000);");
            out.println("</script>");
        }

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