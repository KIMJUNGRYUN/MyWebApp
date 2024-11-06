<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>잔액 조회 - MyBank</title>
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
            background-color: rgba(255, 255, 255, 0.85);
            width: 400px; /* 다른 페이지와 일관되게 수정 */
            padding: 3em; /* 폼 내부 패딩을 일관성 있게 조정 */
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
            font-size: 1.8em;
        }

        label {
            display: block;
            margin-top: 10px;
            color: #004080;
            font-weight: bold;
        }

        input[type="text"] {
            width: 100%;
            padding: 14px;
            margin-top: 10px;
            margin-bottom: 15px;
            border-radius: 5px;
            border: 1px solid #ccc;
            font-size: 1em;
            transition: border-color 0.3s ease;
            box-sizing: border-box;
        }

        input[type="text"]:focus {
            border-color: #0052a3;
            outline: none;
        }

        /* 조회 버튼 스타일 */
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
            transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.2s ease;
            margin-top: 10px;
            text-decoration: none;
            display: inline-block;
        }

        .home-button:hover {
            background-color: rgba(0, 77, 153, 0.8);
            transform: scale(1.03);
            box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.3);
        }

        /* Result container */
        #result {
            margin-top: 20px;
            font-size: 1.1em;
            color: #004d40;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>잔액 조회</h2>
        <form method="post">
            <label for="accountNumber">계좌 번호:</label>
            <input type="text" id="accountNumber" name="accountNumber" required>
            <input type="submit" value="조회">
        </form>

        <!-- 잔액 표시 영역 -->
        <div id="result">
         <%
            String accountNumber = request.getParameter("accountNumber");
            String balanceMessage = null;

            if (accountNumber != null) {
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("oracle.jdbc.driver.OracleDriver");
                    conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "c##system", "c##system");

                    String sql = "SELECT balance FROM accounts WHERE account_number = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, accountNumber);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        double balance = rs.getDouble("balance");
                        balanceMessage = String.format("잔액: %.2f 원", balance);
                    } else {
                        balanceMessage = "존재하지 않는 계좌입니다.";
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    balanceMessage = "오류가 발생했습니다.";
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                }
            }

            if (balanceMessage != null) {
        %>
            <p style="color: <%= balanceMessage.equals("존재하지 않는 계좌입니다.") ? "#cc3333" : "#004d40" %>; font-weight: bold;">
                <%= balanceMessage %>
            </p>
        <% } %>
        </div>

        <!-- 홈으로 버튼 -->
        <a href="index.jsp" class="home-button">홈으로</a>
    </div>
</body>
</html>
