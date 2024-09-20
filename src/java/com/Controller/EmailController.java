package com.Controller;

import com.utility.EmailUtility;
import java.io.IOException;
import java.io.PrintWriter;
import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/EmailController")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class EmailController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        String to = request.getParameter("recipients");
        String[] recipients = to.split(",");
        
        try {
            System.out.println("Sending email to: " + String.join(", ", recipients));
            
            // Send email to each recipient
            for (String recipient : recipients) {
                EmailUtility.sendEmail(recipient, subject, message);
            }
            
            response.sendRedirect("sendEmail.jsp?result=Mail Sent Successfully!!");
        } catch (MessagingException e) {
            e.printStackTrace();
            response.sendRedirect("sendEmail.jsp?result=Message Sending Failed: " + e.getMessage());
        } catch (IOException e) {
            e.printStackTrace();
            response.sendRedirect("sendEmail.jsp?result=Message Sending Failed: " + e.getMessage());
        }
    }

    @Override
    public String getServletInfo() {
        return "EmailController Servlet";
    }
}
