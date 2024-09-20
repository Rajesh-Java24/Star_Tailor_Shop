<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, javax.mail.*, javax.mail.internet.*, javax.activation.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.http.Part" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Send Email</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h2>Send Email</h2>
    <form method="post" enctype="multipart/form-data" action="sendEmail.jsp">
        <div class="form-group">
            <label for="to">To:</label>
            <input type="email" class="form-control" id="to" name="to" required>
        </div>
        <div class="form-group">
            <label for="subject">Subject:</label>
            <input type="text" class="form-control" id="subject" name="subject" required>
        </div>
        <div class="form-group">
            <label for="message">Message:</label>
            <textarea class="form-control" id="message" name="message" rows="5" required></textarea>
        </div>
        <div class="form-group">
            <label for="file">Attachment:</label>
            <input type="file" class="form-control-file" id="file" name="file">
        </div>
        <button type="submit" class="btn btn-primary">Send</button>
    </form>
</div>

<%
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String from = "mkrajesh2000@gmail.com";
        String to = request.getParameter("to");
        String subject = request.getParameter("subject");
        String messageBody = request.getParameter("message");
        Part filePart = null;

        try {
            filePart = request.getPart("file"); // Retrieves the file part
        } catch (IllegalStateException e) {
            out.println("<div class='alert alert-danger mt-4' role='alert'>Multipart configuration error. Please check your server configuration.</div>");
        }

        if (to != null && !to.isEmpty() && subject != null && !subject.isEmpty() && messageBody != null && !messageBody.isEmpty()) {
            String host = "smtp.gmail.com";

            Properties p = new Properties();
            p.put("mail.smtp.auth", "true");
            p.put("mail.smtp.starttls.enable", "true");
            p.put("mail.smtp.host", host);
            p.put("mail.smtp.port", "587");

            Session mailSession = Session.getInstance(p, new javax.mail.Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication("mkrajesh2000@gmail.com", "cvsa vdyl vncl cjmp"); // Your app-specific password
                }
            });

            try {
                MimeMessage message = new MimeMessage(mailSession);
                message.setFrom(new InternetAddress(from));
                message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
                message.setSubject(subject);

                if (filePart == null || filePart.getSize() == 0) {
                    message.setText(messageBody);
                    Transport.send(message);
                    out.println("<div class='alert alert-success mt-4' role='alert'>Email sent successfully.</div>");
                } else {
                    Multipart multipart = new MimeMultipart();

                    // Add message body part
                    MimeBodyPart textPart = new MimeBodyPart();
                    textPart.setText(messageBody);
                    multipart.addBodyPart(textPart);

                    // Add attachment part
                    MimeBodyPart attachmentPart = new MimeBodyPart();
                    InputStream fileContent = filePart.getInputStream();
                    attachmentPart.setFileName(filePart.getSubmittedFileName());
                    attachmentPart.setContent(fileContent, filePart.getContentType());
                    multipart.addBodyPart(attachmentPart);

                    message.setContent(multipart);
                    Transport.send(message);
                    out.println("<div class='alert alert-success mt-4' role='alert'>Email with attachment sent successfully.</div>");
                }
            } catch (Exception ex) {
                out.println("<div class='alert alert-danger mt-4' role='alert'>Failed to send email. Please try again.</div>");
                ex.printStackTrace(); // Print the detailed error message for debugging
            }
        }
    }
%>
</body>
</html>
