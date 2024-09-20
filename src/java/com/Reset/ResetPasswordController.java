/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.Reset;

import com.utility.EmailUtility;
import com.dao.UserDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/ResetPasswordController")
public class ResetPasswordController extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ResetPasswordController.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        switch (action) {
            case "sendCode":
                handleSendCode(request, response, session);
                break;
            case "verifyCode":
                handleVerifyCode(request, response, session);
                break;
            case "setNewPassword":
                handleSetNewPassword(request, response, session);
                break;
            default:
                response.sendRedirect("sendAndVerifyCode.jsp?result=Invalid action.");
                break;
        }
    }

    private void handleSendCode(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        String email = request.getParameter("email");
        String resetCode = generateResetCode();
        session.setAttribute("resetCode", resetCode);
        session.setAttribute("userEmail", email);

        String subject = "Password Reset Code";
        String message = "Your password reset code is: " + resetCode;

        try {
            EmailUtility.sendEmail(email, subject, message);
            response.sendRedirect("sendAndVerifyCode.jsp?result=verifyCode");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("sendAndVerifyCode.jsp?result=Failed to send code, please try again.");
        }
    }

    private void handleVerifyCode(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        String inputCode = request.getParameter("code");
        String correctCode = (String) session.getAttribute("resetCode");

        if (correctCode != null && correctCode.equals(inputCode)) {
            response.sendRedirect("sendAndVerifyCode.jsp?result=setNewPassword");
        } else {
            response.sendRedirect("sendAndVerifyCode.jsp?result=Invalid code, please try again.");
        }
    }

    private void handleSetNewPassword(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        String newPassword = request.getParameter("newPassword");
        String userEmail = (String) session.getAttribute("userEmail");

        if (userEmail == null || userEmail.isEmpty()) {
            response.sendRedirect("sendAndVerifyCode.jsp?result=Session expired or invalid email.");
            return;
        }

        UserDAO userDAO = new UserDAO();
        boolean isUpdated = false;
        try {
            isUpdated = userDAO.updatePassword(userEmail, newPassword);
        } catch (ClassNotFoundException ex) {
            LOGGER.log(Level.SEVERE, "ClassNotFoundException while updating password", ex);
        }

        if (isUpdated) {
            response.sendRedirect("login.jsp?result=Password updated successfully!");
        } else {
            response.sendRedirect("sendAndVerifyCode.jsp?result=Failed to update password, please try again.");
        }
    }

    private String generateResetCode() {
        int code = (int) (Math.random() * 900000) + 100000;
        return String.valueOf(code);
    }

    @Override
    public String getServletInfo() {
        return "ResetPasswordController Servlet";
    }
}