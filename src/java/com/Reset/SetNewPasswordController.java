/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.Reset;

import com.dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/SetNewPasswordController")
public class SetNewPasswordController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("sendAndVerifyCode.jsp?result=Passwords do not match, please try again.");
            return;
        }

        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("userEmail");

        if (userEmail == null) {
            response.sendRedirect("sendAndVerifyCode.jsp?result=Session expired or invalid email.");
            return;
        }

        // Update the password in the database (assuming you have a UserDAO for database operations)
        UserDAO userDAO = new UserDAO();
        boolean isUpdated = false;
        try {
            isUpdated = userDAO.updatePassword(userEmail, newPassword);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(SetNewPasswordController.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (isUpdated) {
            response.sendRedirect("login.jsp?result=Password updated successfully!");
        } else {
            response.sendRedirect("sendAndVerifyCode.jsp?result=Failed to update password, please try again.");
        }
    }

    @Override
    public String getServletInfo() {
        return "SetNewPasswordController Servlet";
    }
}