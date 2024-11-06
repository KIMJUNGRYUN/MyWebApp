<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Transfer - MyBank</title>
    <style>
        .form-container {
            background-color: rgba(255, 255, 255, 0.9);
            width: 400px; /* 폼 너비를 넓게 조정 */
            padding: 3em; /* 폼 내부 패딩을 늘려서 여백 증가 */
            margin: 5% auto;
            border-radius: 10px;
            box-shadow: 0px 6px 12px rgba(0, 0, 0, 0.2);
            text-align: center;
        }

        h2 {
            color: #003366;
            margin-bottom: 1em;
            font-size: 1.8em; /* 제목 폰트 크기 증가 */
        }

        label {
            display: block;
            text-align: left;
            margin: 10px 0 5px;
            color: #004080;
            font-weight: bold;
            font-size: 1.1em; /* 라벨 폰트 크기 증가 */
        }

        input[type="text"] {
            width: 100%;
            padding: 14px; /* 입력 필드의 패딩을 늘림 */
            margin: 10px 0 15px; /* 텍스트 박스 간격 조정 */
            border-radius: 5px;
            border: 1px solid #ccc;
            font-size: 1em;
            box-sizing: border-box;
        }

        /* 버튼 공통 스타일 */
        .button {
            width: 100%;
            padding: 14px; /* 버튼 패딩을 증가 */
            margin: 12px 0;
            border-radius: 5px;
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
            padding: 1.5em;
            margin-top: 1.5em;
            border-radius: 8px;
            text-align: center;
            font-size: 1.1em;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.15);
        }

        .error-message {
            background-color: rgba(255, 0, 0, 0.9);
            color: white;
            padding: 1.5em;
            margin-top: 1.5em;
            border-radius: 8px;
            text-align: center;
            font-size: 1.1em;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.15);
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
