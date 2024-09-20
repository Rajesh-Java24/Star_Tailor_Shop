/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.Reset;

import com.utility.EmailUtility;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/SendCodeController")
public class SendCodeController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String resetCode = generateResetCode();
        HttpSession session = request.getSession();
        session.setAttribute("resetCode", resetCode);

        // Send email (ensure EmailUtility is correctly implemented)
        String subject = "Password Reset Code";
        String message = "Your password reset code is: " + resetCode;

        try {
            EmailUtility.sendEmail(email, subject, message);
            response.sendRedirect("verifyCode.jsp?result=Code sent to your email.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("sendCode.jsp?result=Failed to send code, please try again.");
        }
    }

    private String generateResetCode() {
        int code = (int) (Math.random() * 900000) + 100000;
        return String.valueOf(code);
    }
}