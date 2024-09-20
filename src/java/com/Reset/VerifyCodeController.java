/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.Reset;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/VerifyCodeController")
public class VerifyCodeController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String inputCode = request.getParameter("code");
        HttpSession session = request.getSession();
        String correctCode = (String) session.getAttribute("resetCode");

        // Debugging logs
        System.out.println("Correct code from session: " + correctCode);
        System.out.println("Input code: " + inputCode);

        if (correctCode != null && correctCode.equals(inputCode)) {
            session.setAttribute("userEmail", email);
            response.sendRedirect("setNewPassword.jsp");
        } else {
            response.sendRedirect("verifyCode.jsp?result=Invalid code, please try again.");
        }
    }

    @Override
    public String getServletInfo() {
        return "VerifyCodeController Servlet";
    }
}