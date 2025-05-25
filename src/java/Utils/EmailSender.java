package Utils;

import java.util.Properties;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailSender {

    private static final String USUARIO_GMAIL = "javiercito9456@gmail.com"; // Reemplaza con tu cuenta de Gmail
    private static final String CONTRASENA_GMAIL = "mcnl ochd uqxs kruv"; // Reemplaza con tu contraseña de Gmail o contraseña de aplicación

    // Método privado para obtener las propiedades SMTP
    private static Properties obtenerPropiedadesSMTP() {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); // Use TLS
        return props;
    }

    // Método privado para obtener la sesión autenticada
    private static Session obtenerSesion() {
        return Session.getInstance(obtenerPropiedadesSMTP(),
                new jakarta.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(USUARIO_GMAIL, CONTRASENA_GMAIL);
                    }
                });
    }

    public static void enviarEmail(String emailDestinatario, String asunto, String contenido) throws MessagingException {
        Session session = obtenerSesion();
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(USUARIO_GMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(emailDestinatario));
            message.setSubject(asunto);
            message.setText(contenido);

            Transport.send(message);

            System.out.println("Correo enviado a: " + emailDestinatario);
        } catch (MessagingException e) {
            System.err.println("Error al enviar el correo: " + e.getMessage());
            throw e;
        }
    }

    // Nuevo método para enviar correos HTML
    public static void enviarEmailHTML(String emailDestinatario, String asunto, String contenidoHTML) throws MessagingException {
        Session session = obtenerSesion();
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(USUARIO_GMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(emailDestinatario));
            message.setSubject(asunto);
            message.setContent(contenidoHTML, "text/html; charset=utf-8");

            Transport.send(message);

            System.out.println("Correo HTML enviado a: " + emailDestinatario);
        } catch (MessagingException e) {
            System.err.println("Error al enviar el correo HTML: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Envía un correo de confirmación de cita al paciente.
     *
     * @param emailPaciente Email del paciente
     * @param nombrePaciente Nombre completo del paciente
     * @param fechaHoraCita Fecha y hora de la cita
     * @param especialidadCita Especialidad de la cita
     * @return true si el correo fue enviado correctamente, false en caso contrario
     */
    public static boolean enviarEmailConfirmacionCita(String emailPaciente, String nombrePaciente, String fechaHoraCita, String especialidadCita) {
        String asunto = "Confirmación de cita médica";
        String contenidoHTML = "<html><body style='font-family: Arial, sans-serif; color: #333;'>"
                + "<h2 style='color:#0069d9;'>Confirmación de su cita médica</h2>"
                + "<p>Estimado/a <strong>" + nombrePaciente + "</strong>,</p>"
                + "<p>Nos complace informarle que su cita ha sido <b>confirmada</b> con los siguientes detalles:</p>"
                + "<ul>"
                + "<li><b>Fecha y hora:</b> " + fechaHoraCita + "</li>"
                + "<li><b>Especialidad:</b> " + especialidadCita + "</li>"
                + "</ul>"
                + "<p>Le recomendamos presentarse al menos <b>10 minutos antes</b> de la hora programada.</p>"
                + "<p>Si tiene alguna duda o necesita reprogramar su cita, por favor comuníquese con nuestro equipo de atención.</p>"
                + "<br>"
                + "<p style='color:#888;'>Gracias por confiar en nuestro servicio.</p>"
                + "<p>Atentamente,<br><b>Equipo de Gestión de Citas Médicas</b></p>"
                // Logo al final (ruta relativa, debe ser accesible públicamente)
                + "<div style='margin-top:30px;text-align:center;'>"
                + "</div>"
                + "</body></html>";
        try {
            enviarEmailHTML(emailPaciente, asunto, contenidoHTML);
            return true;
        } catch (MessagingException e) {
            System.err.println("Error al enviar correo de confirmación: " + e.getMessage());
            return false;
        }
    }
}