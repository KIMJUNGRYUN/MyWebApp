package com.example;

import java.io.IOException;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/DepositServlet")
public class DepositServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accountNumber = request.getParameter("accountNumber");
        String amountStr = request.getParameter("amount");
        double amount = Double.parseDouble(amountStr);

        String message = null;
        String userName = null;

        // DB 입금 처리
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                message = "데이터베이스 연결에 실패했습니다. 연결 정보를 확인해 주세요.";
            } else {
                // 계좌 번호에 해당하는 사용자 이름을 조회
                String userQuery = "SELECT u.name FROM users u JOIN accounts a ON u.id = a.user_id WHERE a.account_number = ?";
                PreparedStatement userStmt = conn.prepareStatement(userQuery);
                userStmt.setString(1, accountNumber);
                ResultSet userRs = userStmt.executeQuery();

                if (userRs.next()) {
                    userName = userRs.getString("name");

                    // 입금 처리
                    String updateSql = "UPDATE accounts SET balance = balance + ? WHERE account_number = ?";
                    PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                    updateStmt.setDouble(1, amount);
                    updateStmt.setString(2, accountNumber);
                    int rowsUpdated = updateStmt.executeUpdate();

                    if (rowsUpdated > 0) {
                        message = String.format("계좌번호: %s, 이름: %s, %.2f원이 입금되었습니다.", accountNumber, userName, amount);
                    } else {
                        message = "계좌를 찾을 수 없습니다. 입금에 실패했습니다.";
                    }
                } else {
                    message = "해당 계좌를 찾을 수 없습니다.";
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            message = "데이터베이스 오류가 발생했습니다: " + e.getMessage();
        }

        // 결과와 입력한 값을 JSP 페이지로 전달
        request.setAttribute("message", message);
        request.setAttribute("accountNumber", accountNumber);
        request.setAttribute("amount", amountStr);
        RequestDispatcher dispatcher = request.getRequestDispatcher("deposit.jsp");
        dispatcher.forward(request, response);
    }
}
