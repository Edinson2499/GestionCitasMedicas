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
        out.println("<body>");
        out.println("<script type=\"text/javascript\">");

        // Ahora buscarUsuarioInicioSesion retorna el rol
        String rol = metodos.buscarUsuarioInicioSesion(txtUsuario, txtContrasena);

        if (rol != null) { // Inicio de sesión exitoso
            String nombre = metodos.buscarNombre(txtUsuario);
            int idUsuario = metodos.buscarIdUsuario(txtUsuario);

            sesion.setAttribute("nombre", nombre);
            sesion.setAttribute("txtUsuario", txtUsuario);
            sesion.setAttribute("rol", rol);
            sesion.setAttribute("idUsuario", idUsuario); // Guardar el ID en la sesión

            out.println("alert('¡Bienvenido a mi página! \\nIniciaste sesión como: " + txtUsuario + " (Rol: " + rol + ")')");

            if (rol.equals("paciente")) {
                out.println("location = 'menu_paciente.jsp'");
            } else if (rol.equals("especialista")) {
                out.println("location = 'menu_Especialista.jsp'"); // Asegúrate de tener este JSP
            } else {
                out.println("location = 'menu_otro.jsp'"); // Para otros roles si los hay
            }

        } else {
            out.println("alert('Datos Incorrectos, verifica tus credenciales o date de alta en el sistema')");
            out.println("location = 'index.html'");
        }

        System.out.println("El valor del rol dentro del SERVLET es: " + rol);

        out.println("</script>");
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