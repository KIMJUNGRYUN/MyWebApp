<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>잔액 조회</title>
</head>
<body>
    <h2>잔액 조회</h2>
    <form action="BalanceServlet" method="post">
        계좌 번호: <input type="text" name="accountNumber" required><br>
        <input type="submit" value="조회">
    </form>
</body>
</html>
