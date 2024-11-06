<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Transfer - MyBank</title>
    <style>
        .form-container {
            background-color: rgba(255, 255, 255, 0.8);
            width: 300px;
            padding: 2em;
            margin: 5% auto;
            border-radius: 10px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
            text-align: center;
        }

        h2 {
            color: #003366;
            margin-bottom: 1em;
            font-size: 1.6em;
        }

        label {
            display: block;
            text-align: left;
            margin: 10px 0 5px;
            color: #004080;
            font-weight: bold;
        }

        input[type="text"] {
            width: 100%;
            padding: 12px;
            margin: 5px 0 15px; /* 텍스트 박스 간격 조정 */
            border-radius: 4px;
            border: 1px solid #ccc;
            font-size: 1em;
            box-sizing: border-box;
        }

        /* 버튼 공통 스타일 */
        .button {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border-radius: 4px;
            font-size: 1em;
            color: white;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.2s ease;
            text-decoration: none;
            display: inline-block;
            box-sizing: border-box;
        }

        .submit-button {
            background-color: #0066cc;
        }

        .submit-button:hover {
            background-color: #0052a3;
            box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.3);
        }

        .home-button {
            background-color: rgba(0, 102, 204, 0.6);
        }

        .home-button:hover {
            background-color: rgba(0, 77, 153, 0.8);
            box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.3);
        }

        .message-container {
            background-color: rgba(0, 153, 51, 0.9);
            color: white;
            padding: 1em;
            margin-top: 1em;
            border-radius: 5px;
            text-align: center;
            font-size: 1.1em;
        }

        .error-message {
            background-color: rgba(255, 0, 0, 0.9);
            color: white;
            padding: 1em;
            margin-top: 1em;
            border-radius: 5px;
            text-align: center;
            font-size: 1.1em;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Transfer Funds</h2>
        <form action="TransferServlet" method="post">
            <label for="fromAccountNumber">송금 계좌 번호:</label>
            <input type="text" id="fromAccountNumber" name="fromAccountNumber" value="<%= request.getAttribute("fromAccountNumber") != null ? request.getAttribute("fromAccountNumber") : "" %>" required>

            <label for="toAccountNumber">수취 계좌 번호:</label>
            <input type="text" id="toAccountNumber" name="toAccountNumber" value="<%= request.getAttribute("toAccountNumber") != null ? request.getAttribute("toAccountNumber") : "" %>" required>

            <label for="amount">송금 금액:</label>
            <input type="text" id="amount" name="amount" value="<%= request.getAttribute("amount") != null ? request.getAttribute("amount") : "" %>" required>

            <input type="submit" class="button submit-button" value="송금">
        </form>

        <!-- 결과 메시지 표시 영역 -->
        <%
            String message = (String) request.getAttribute("message");
            if (message != null) {
                boolean isError = message.contains("실패") || message.contains("오류") || message.contains("부족");
        %>
            <div class="<%= isError ? "error-message" : "message-container" %>">
                <p><%= message %></p>
            </div>
        <% } %>

        <!-- 홈으로 버튼 -->
        <a href="index.jsp" class="button home-button">홈으로</a>
    </div>
</body>
</html>
