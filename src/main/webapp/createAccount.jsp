<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Account - MyBank</title>
    <style>
        /* Reset CSS */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        /* Body 배경 스타일 */
        body {
            background: url('bank-background.jpg') no-repeat center center fixed;
            background-size: cover;
            color: #003366;
            padding-bottom: 100px;
        }

        /* Form Container */
        .form-container {
            background-color: rgba(255, 255, 255, 0.9);
            width: 400px;
            padding: 3em;
            margin: 5% auto;
            border-radius: 10px;
            box-shadow: 0px 6px 12px rgba(0, 0, 0, 0.2);
            text-align: center;
        }

        h2 {
            color: #003366;
            margin-bottom: 1em;
            font-size: 1.8em;
        }

        label {
            display: block;
            margin-top: 10px;
            color: #004080;
            font-weight: bold;
            font-size: 1.1em;
            text-align: left;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 14px;
            margin-top: 10px;
            margin-bottom: 15px;
            border-radius: 5px;
            border: 1px solid #ccc;
            font-size: 1em;
            box-sizing: border-box;
            transition: border-color 0.3s ease;
        }

        input[type="text"]:focus, input[type="password"]:focus {
            border-color: #0052a3;
            outline: none;
        }

        /* 계좌 생성 버튼 스타일 */
        input[type="submit"] {
            width: 100%;
            padding: 14px;
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

        /* 홈 버튼 스타일 */
        .home-button {
            width: 100%;
            padding: 14px;
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

        /* Result 메시지 스타일 */
        .result-container {
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

        /* 복사 버튼 스타일 */
        .copy-button {
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            padding: 6px 12px;
            margin-left: 10px;
            font-size: 0.9em;
            transition: background-color 0.3s;
        }

        .copy-button:hover {
            background-color: #45a049;
        }

        /* 복사 완료 메시지 */
        .copy-message {
            color: #4CAF50;
            font-size: 0.9em;
            margin-top: 10px;
            display: none;
        }
    </style>
    <script>
        function copyToClipboard() {
            var accountNumber = document.getElementById("accountNumberText").innerText;
            navigator.clipboard.writeText(accountNumber).then(function() {
                var copyMessage = document.getElementById("copyMessage");
                copyMessage.style.display = "block";
                setTimeout(function() {
                    copyMessage.style.display = "none";
                }, 3000);
            });
        }
    </script>
</head>
<body>
    <div class="form-container">
        <h2>Create Account</h2>
        <form action="createAccount.jsp" method="post">
            <label for="accountId">아이디:</label>
            <input type="text" id="accountId" name="accountId" required>

            <label for="password">비밀번호:</label>
            <input type="password" id="password" name="password" required>

            <label for="name">이름:</label>
            <input type="text" id="name" name="name" required>

            <input type="submit" value="계좌 생성">
        </form>

        <!-- 결과 표시 영역 -->
        <%
            String createResult = null;
            String generatedAccountNumber = null;
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String accountId = request.getParameter("accountId");
                String password = request.getParameter("password");
                String name = request.getParameter("name");

                try (Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "c##system", "c##system")) {
                    String checkQuery = "SELECT COUNT(*) FROM users WHERE id = ?";
                    PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
                    checkStmt.setString(1, accountId);
                    ResultSet rs = checkStmt.executeQuery();
                    rs.next();

                    if (rs.getInt(1) > 0) {
                        createResult = "중복된 ID가 존재합니다. 다른 ID를 사용해 주세요.";
                    } else {
                        String insertQuery = "INSERT INTO users (id, password, name) VALUES (?, ?, ?)";
                        PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
                        insertStmt.setString(1, accountId);
                        insertStmt.setString(2, password);
                        insertStmt.setString(3, name);

                        int rowsInserted = insertStmt.executeUpdate();
                        if (rowsInserted > 0) {
                            generatedAccountNumber = "6666" + String.valueOf((int)(Math.random() * 10000000000L));
                            String insertAccountQuery = "INSERT INTO accounts (account_number, user_id, balance) VALUES (?, ?, 0)";
                            PreparedStatement insertAccountStmt = conn.prepareStatement(insertAccountQuery);
                            insertAccountStmt.setString(1, generatedAccountNumber);
                            insertAccountStmt.setString(2, accountId);
                            insertAccountStmt.executeUpdate();

                            createResult = "계좌 생성이 완료되었습니다!";
                        } else {
                            createResult = "계좌 생성 중 오류가 발생했습니다.";
                        }
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    createResult = "데이터베이스 오류가 발생했습니다.";
                }
            }

            if (createResult != null) {
        %>
            <div class="<%= createResult.contains("오류") || createResult.contains("중복") ? "error-container" : "result-container" %>">
                <p><%= createResult %></p>
                <% if (generatedAccountNumber != null) { %>
                    <p>생성된 계좌 번호: <span id="accountNumberText"><%= generatedAccountNumber %></span>
                        <button class="copy-button" onclick="copyToClipboard()">복사하기</button>
                    </p>
                    <p id="copyMessage" class="copy-message">계좌 번호가 복사되었습니다.</p>
                <% } %>
            </div>
        <% } %>

        <!-- 홈으로 버튼 -->
        <a href="index.jsp" class="home-button">홈으로</a>
    </div>
</body>
</html>
