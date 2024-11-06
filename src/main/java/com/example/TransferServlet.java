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

@WebServlet("/TransferServlet")
public class TransferServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fromAccountNumber = request.getParameter("fromAccountNumber");
        String toAccountNumber = request.getParameter("toAccountNumber");
        String amountStr = request.getParameter("amount");
        double amount;

        // 금액 입력값이 숫자인지 확인
        try {
            amount = Double.parseDouble(amountStr);
        } catch (NumberFormatException e) {
            request.setAttribute("message", "송금 금액은 숫자로 입력해 주세요.");
            forwardToJsp(request, response);
            return;
        }

        String message = null;

        // DB 송금 처리
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                message = "데이터베이스 연결에 실패했습니다. 연결 정보를 확인해 주세요.";
            } else {
                // 출금 계좌의 잔액 조회
                String fromAccountQuery = "SELECT balance FROM accounts WHERE account_number = ?";
                PreparedStatement fromAccountStmt = conn.prepareStatement(fromAccountQuery);
                fromAccountStmt.setString(1, fromAccountNumber);
                ResultSet fromAccountRs = fromAccountStmt.executeQuery();

                if (fromAccountRs.next()) {
                    double fromAccountBalance = fromAccountRs.getDouble("balance");

                    // 잔액이 충분한지 확인
                    if (fromAccountBalance >= amount) {
                        // 수취 계좌가 존재하는지 확인
                        String toAccountQuery = "SELECT balance FROM accounts WHERE account_number = ?";
                        PreparedStatement toAccountStmt = conn.prepareStatement(toAccountQuery);
                        toAccountStmt.setString(1, toAccountNumber);
                        ResultSet toAccountRs = toAccountStmt.executeQuery();

                        if (toAccountRs.next()) {
                            // 출금 계좌에서 금액 차감
                            String withdrawSql = "UPDATE accounts SET balance = balance - ? WHERE account_number = ?";
                            PreparedStatement withdrawStmt = conn.prepareStatement(withdrawSql);
                            withdrawStmt.setDouble(1, amount);
                            withdrawStmt.setString(2, fromAccountNumber);
                            int withdrawUpdated = withdrawStmt.executeUpdate();

                            // 수취 계좌에 금액 추가
                            if (withdrawUpdated > 0) {
                                String depositSql = "UPDATE accounts SET balance = balance + ? WHERE account_number = ?";
                                PreparedStatement depositStmt = conn.prepareStatement(depositSql);
                                depositStmt.setDouble(1, amount);
                                depositStmt.setString(2, toAccountNumber);
                                int depositUpdated = depositStmt.executeUpdate();

                                if (depositUpdated > 0) {
                                    message = String.format("계좌번호: %s에서 계좌번호: %s로 %.2f원이 송금되었습니다.", fromAccountNumber, toAccountNumber, amount);
                                } else {
                                    message = "수취 계좌에 송금 처리 중 오류가 발생했습니다.";
                                }
                            } else {
                                message = "출금 처리 중 오류가 발생했습니다.";
                            }
                        } else {
                            message = "수취 계좌를 찾을 수 없습니다.";
                        }
                    } else {
                        message = "잔액이 부족합니다. 송금에 실패했습니다.";
                    }
                } else {
                    message = "출금 계좌를 찾을 수 없습니다.";
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            message = "데이터베이스 오류가 발생했습니다: " + e.getMessage();
        }

        // 결과와 입력한 값을 JSP 페이지로 전달
        request.setAttribute("message", message);
        request.setAttribute("fromAccountNumber", fromAccountNumber);
        request.setAttribute("toAccountNumber", toAccountNumber);
        request.setAttribute("amount", amountStr);

        forwardToJsp(request, response);
    }

    private void forwardToJsp(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("transfer.jsp");
        dispatcher.forward(request, response);
    }
}