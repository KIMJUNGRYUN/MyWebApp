<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Deposit - MyBank</title>
    <style>
        /* Reset CSS */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* Body background */
        body {
            background: url('bank-background.jpg') no-repeat center center fixed;
            background-size: cover;
            color: #003366;
            padding-bottom: 100px;
        }

        /* Form Container */
        .form-container {
            background-color: rgba(255, 255, 255, 0.9);
            width: 400px; /* 폼 너비를 넓게 조정 */
            padding: 3em; /* 폼 내부 패딩을 늘려서 여백 증가 */
            margin: 5% auto;
            border-radius: 10px;
            box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.2);
            text-align: center;
            transition: transform 0.3s;
        }

        .form-container:hover {
            transform: translateY(-5px);
        }

        h2 {
            color: #003366;
            margin-bottom: 1em;
            font-size: 1.8em; /* 제목 폰트 크기 증가 */
        }

        label {
            display: block;
            margin-top: 10px;
            color: #004080;
            font-weight: bold;
            font-size: 1.1em; /* 라벨 폰트 크기 증가 */
            text-align: left; /* 라벨 왼쪽 정렬 */
        }

        input[type="text"] {
            width: 100%;
            padding: 14px; /* 입력 필드의 패딩을 늘림 */
            margin-top: 10px;
            margin-bottom: 15px;
            border-radius: 5px;
            border: 1px solid #ccc;
            transition: border-color 0.3s ease;
            font-size: 1em;
            box-sizing: border-box;
        }

        input[type="text"]:focus {
            border-color: #0052a3;
            outline: none;
        }

        /* 입금 버튼 스타일 */
        input[type="submit"] {
            width: 100%;
            padding: 14px; /* 버튼의 패딩을 늘림 */
            background-color: #0066cc;
            color: white;
            font-size: 1em;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-top: 20px;
        }

        input[type="submit"]:hover {
            background-color: #004d99;
        }

        /* 홈 버튼 스타일 (투명한 배경) */
        .home-button {
            width: 100%;
            padding: 14px; /* 홈 버튼 패딩 증가 */
            background-color: rgba(0, 102, 204, 0.6);
            color: white;
            font-size: 1em;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            margin-top: 10px;
            transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.2s ease;
        }

        .home-button:hover {
            background-color: rgba(0, 77, 153, 0.8);
            transform: scale(1.03);
            box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.3);
        }

        /* Message container for result display */
        .message-container {
            background-color: #00a64f;
            color: white;
            padding: 1.5em;
            margin-top: 1.5em;
            border-radius: 8px;
            font-size: 1.1em;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.15);
        }

        .error-container {
            background-color: #cc3333;
            color: white;
            padding: 1.5em;
            margin-top: 1.5em;
            border-radius: 8px;
            font-size: 1.1em;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.15);
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>Deposit Funds</h2>
        <form action="DepositServlet" method="post">
            <label for="accountNumber">계좌 번호:</label>
            <input type="text" id="accountNumber" name="accountNumber" value="<%= request.getAttribute("accountNumber") != null ? request.getAttribute("accountNumber") : "" %>" required>

            <label for="amount">입금 금액:</label>
            <input type="text" id="amount" name="amount" value="<%= request.getAttribute("amount") != null ? request.getAttribute("amount") : "" %>" required>

            <input type="submit" value="입금">
        </form>

        <!-- Result Message Display -->
        <%
            String message = (String) request.getAttribute("message");
            if (message != null) {
        %>
            <div class="<%= message.contains("오류") ? "error-container" : "message-container" %>">
                <p><%= message %></p>
            </div>
        <% } %>

        <!-- 홈으로 버튼 -->
        <a href="index.jsp" class="home-button">홈으로</a>
    </div>
</body>
</html>
