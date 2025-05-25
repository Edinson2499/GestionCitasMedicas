/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author javie
 */
package Utils;
import com.twilio.Twilio;
import com.twilio.converter.Promoter;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;

import java.net.URI;
import java.math.BigDecimal;

public class SMSSender {
    // Reemplaza con tus Account SID y Auth Token de Twilio
    public static final String ACCOUNT_SID = "a0dc440d87446c8d1f9bc5b9af1fda0e";
    public static final String AUTH_TOKEN = "a0dc440d87446c8d1f9bc5b9af1fda0e";
    // Reemplaza con tu número de teléfono de Twilio
    public static final String TWILIO_PHONE_NUMBER = "+15083792625";

    public static boolean enviarSMS(String numeroDestinatario, String mensaje) {
        try {
            Twilio.init(ACCOUNT_SID, AUTH_TOKEN);
            Message message = Message.creator(
                    new PhoneNumber(numeroDestinatario),
                    new PhoneNumber(TWILIO_PHONE_NUMBER),
                    mensaje)
                .create();
            System.out.println("SMS SID: " + message.getSid() + " enviado a " + numeroDestinatario);
            return true;
        } catch (Exception e) {
            System.err.println("Error al enviar SMS a " + numeroDestinatario + ": " + e.getMessage());
            return false;
        }
    }

    // Puedes mantener el método main para pruebas unitarias si lo deseas
    public static void main(String[] args) {
        // Reemplaza con un número de teléfono real al que quieras enviar un SMS de prueba
        enviarSMS("+573046611102", "Este es un mensaje de prueba desde Twilio!");
    }

}