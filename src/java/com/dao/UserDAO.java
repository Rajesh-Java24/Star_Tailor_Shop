/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.dao;

import com.Reset.DBConnectionUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.Reset.DBConnectionUtil;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAO {
    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    public boolean updatePassword(String email, String newPassword) throws ClassNotFoundException {
        String sql = "UPDATE users SET password = ? WHERE email = ?";
        try (Connection conn = DBConnectionUtil.openConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            LOGGER.log(Level.INFO, "Updating password for email: {0}", email);

            pstmt.setString(1, newPassword);
            pstmt.setString(2, email);

            int rowsUpdated = pstmt.executeUpdate();
            LOGGER.log(Level.INFO, "Rows updated: {0}", rowsUpdated);

            return rowsUpdated > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL Exception while updating password", e);
            return false;
        }
    }
}