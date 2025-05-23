/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author javie
 */
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

    private static final String USUARIO_GMAIL = "ecaceres06@uan.edu.com"; // Reemplaza con tu cuenta de Gmail
    private static final String CONTRASENA_GMAIL = "agpy gmjw aydd lkpw"; // Reemplaza con tu contraseña de Gmail o contraseña de aplicación

    public static void enviarEmail(String emailPaciente, String asuntoEmail, String contenidoEmail) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); // Use TLS

        Session session = Session.getInstance(props,
                new jakarta.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(USUARIO_GMAIL, CONTRASENA_GMAIL);
                    }
                });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(USUARIO_GMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(emailPaciente));
            message.setSubject(asuntoEmail);
            message.setText(contenidoEmail);

            Transport.send(message);

            System.out.println("Correo enviado a: " + emailPaciente);
        } catch (MessagingException e) {
            System.err.println("Error al enviar el correo: " + e.getMessage());
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
        String contenido = "Hola " + nombrePaciente + ",\n\n"
                + "Su cita ha sido confirmada para el día " + fechaHoraCita
                + " en la especialidad de " + especialidadCita + ".\n\n"
                + "Por favor, llegue 10 minutos antes de la hora programada.\n\n"
                + "Saludos,\nEquipo de Gestión de Citas Médicas";
        try {
            enviarEmail(emailPaciente, asunto, contenido);
            return true;
        } catch (Exception e) {
            System.err.println("Error al enviar correo de confirmación: " + e.getMessage());
            return false;
        }
    }
}