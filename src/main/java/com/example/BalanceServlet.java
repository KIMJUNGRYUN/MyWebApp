package com.example;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/BalanceServlet")
public class BalanceServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accountNumber = request.getParameter("accountNumber");
        
        // 여기서 계좌 번호 조회 로직을 구현합니다. 예를 들어, 데이터베이스에서 계좌를 확인합니다.
        // 예제에서는 더미 데이터로 존재하지 않는 계좌 처리를 설명합니다.
        
        double balance = getBalanceFromDatabase(accountNumber); // 데이터베이스에서 잔액 조회
        
        if (balance == -1) { // -1을 반환하면 계좌가 존재하지 않는다는 의미로 가정합니다.
            request.setAttribute("balance", "존재하지 않는 계좌입니다.");
        } else {
            request.setAttribute("balance", String.format("%.2f 원", balance));
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("balance.jsp");
        dispatcher.forward(request, response);
    }

    private double getBalanceFromDatabase(String accountNumber) {
        // 데이터베이스에서 accountNumber를 조회하여 잔액을 반환
        // 여기서는 -1을 계좌가 없을 경우로 가정
        return -1; // 실제 구현에서는 데이터베이스 연동 필요
    }
}
