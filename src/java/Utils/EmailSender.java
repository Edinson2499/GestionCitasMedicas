/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author javie

package Utils;

import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailSender {

    private static final String USUARIO_GMAIL = "ecaceres06@uan.edu.com"; // Reemplaza con tu cuenta de Gmail
    private static final String CONTRASENA_GMAIL = "agpy gmjw aydd lkpw"; // Reemplaza con tu contraseña de Gmail o contraseña de aplicación

    public static boolean enviarEmailConfirmacionCita(String destinatario, String nombrePaciente, String fechaHora, String especialidad) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); // Use TLS

        Session session = Session.getInstance(props,
                new javax.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(USUARIO_GMAIL, CONTRASENA_GMAIL);
                    }
                });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(USUARIO_GMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
            message.setSubject("Confirmación de Cita Médica");
            message.setText(String.format(
                    "Estimado/a %s,\n\nSu cita para %s ha sido confirmada para el día y hora: %s.\n\n¡Gracias por su preferencia!",
                    nombrePaciente, especialidad, fechaHora));

            Transport.send(message);

            System.out.println("Correo de confirmación enviado a: " + destinatario);
            return true;

        } catch (MessagingException e) {
            System.err.println("Error al enviar el correo de confirmación: " + e.getMessage());
            return false;
        }
    }
}
     */