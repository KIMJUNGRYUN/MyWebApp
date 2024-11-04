package com.example;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/BalanceServlet")
public class BalanceServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accountNumber = request.getParameter("accountNumber");

        Bank_System bankSystem = new Bank_System();
        double balance = bankSystem.checkBalance(accountNumber);

        // 조회한 잔액을 JSP로 전달
        request.setAttribute("balance", balance);
        RequestDispatcher dispatcher = request.getRequestDispatcher("balanceResult.jsp");
        dispatcher.forward(request, response);
    }
}
