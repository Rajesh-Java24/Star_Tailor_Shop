/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.Reset;
import com.Reset.MailUtility;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;
import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ResetCodeController")
public class ResetCodeController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        String host = "smtp.gmail.com";
        String user = "mkrajesh2000@gmail.com";
        String port = "587";  // Change to "465" if using SSL
        String password = "fjre pkqz ojtm yzfc";  // Use an App Password if 2FA is enabled
        String to = request.getParameter("email");
        String[] recipients = {to};
        String subject = "Password Reset Code";
        
        // Generate a random 6-digit code
        Random rand = new Random();
        int code = rand.nextInt(1000000);
        String resetCode = String.format("%06d", code);
        String message = "Your password reset code is: " + resetCode;
        
        // Store the reset code in session
        HttpSession session = request.getSession();
        session.setAttribute("resetCode", resetCode);
        
        try {
            MailUtility.sendEmail(host, port, user, password, recipients, subject, message);
            response.sendRedirect("sendCode.jsp?result=Reset code sent successfully to " + to);
        } catch (MessagingException e) {
            e.printStackTrace();
            response.sendRedirect("sendCode.jsp?result=Message Sending Failed: " + e.getMessage());
        }
    }

    @Override
    public String getServletInfo() {
        return "ResetCodeController Servlet";
    }
}