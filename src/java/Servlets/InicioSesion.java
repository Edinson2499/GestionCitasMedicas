package Servlets;

import SQL.MetodosSQL;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

/**
 *
 * @author edinson
 */
public class InicioSesion extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession sesion = request.getSession();

        MetodosSQL metodos = new MetodosSQL();
        String txtUsuario = request.getParameter("txtUsuario");
        String txtContrasena = request.getParameter("txtContrasena");

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<title>Inicio de Sesión</title>");
        out.println("<style>");
        out.println("body { margin: 0; font-family: Arial, sans-serif; background-color: #e6f4fe; }"); // fondo azul celeste claro
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
        out.println(".modal-content button:hover { background-color:rgba(113, 206, 239, 1); }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");

        String rol = metodos.buscarUsuarioInicioSesion(txtUsuario, txtContrasena);

        if (rol != null) {
            String nombre = metodos.buscarNombre(txtUsuario);
            int idUsuario = metodos.buscarIdUsuario(txtUsuario);

            sesion.setAttribute("nombre", nombre);
            sesion.setAttribute("txtUsuario", txtUsuario);
            sesion.setAttribute("rol", rol);
            sesion.setAttribute("idUsuario", idUsuario);

            out.println("<div class='modal' id='welcomeModal'>");
            out.println("  <div class='modal-content'>");
            out.println("    <h2>¡Bienvenido a BuinessHealth!</h2>");
            out.println("    <p>Iniciaste sesión como: <strong>" + txtUsuario + "</strong> (Rol: " + rol + ")</p>");
            out.println("    <button onclick='redirigir()'>Aceptar</button>");
            out.println("  </div>");
            out.println("</div>");

            out.println("<script type='text/javascript'>");
            out.println("function redirigir() {");

            if (rol.equals("paciente")) {
                out.println("  window.location = 'menu_paciente.jsp';");
            } else if (rol.equals("especialista")) {
                out.println("  window.location = 'menu_especialista.jsp';");
            } else {
                out.println("  window.location = 'menu_otro.jsp';");
            }

            out.println("}");
            out.println("</script>");

        } else {
            out.println("<div class='modal' id='errorModal'>");
            out.println("  <div class='modal-content'>");
            out.println("    <h2>Datos Incorrectos</h2>");
            out.println("    <p>Verifica tus credenciales o date de alta en el sistema.</p>");
            out.println("    <button onclick='redirigirError()'>Aceptar</button>");
            out.println("  </div>");
            out.println("</div>");

            out.println("<script type='text/javascript'>");
            out.println("function redirigirError() {");
            out.println("  window.location = 'index.html';");
            out.println("}");
            out.println("</script>");
        }

        out.println("</body>");
        out.println("</html>");
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet para iniciar sesión y redirigir según el rol del usuario.";
    }// </editor-fold>

}