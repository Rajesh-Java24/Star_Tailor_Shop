package com.utility;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Date;
import java.util.Properties;

public class EmailUtility {
    public static void sendEmail(String email, String subject, String messageContent) throws AddressException, MessagingException {
        String host = "smtp.gmail.com";
        String port = "587";
        String userName = "Enter your Email"; // replace with your email
        String password = "fjre pkqz ojtm yzfc"; // replace with your password or app password
         
        Properties properties = new Properties();
        properties.put("mail.smtp.host", host);
        properties.put("mail.smtp.port", port);
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Authenticator auth = new Authenticator() {
            public PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(userName, password);
            }
        };

        Session session = Session.getInstance(properties, auth);

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(userName));
        msg.setRecipient(Message.RecipientType.TO, new InternetAddress(email));
        msg.setSubject(subject);
        msg.setSentDate(new Date());
        msg.setText(messageContent);

        Transport.send(msg);
    }
}
