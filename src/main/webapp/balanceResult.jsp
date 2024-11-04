<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>잔액 조회 결과</title>
</head>
<body>
    <h2>잔액 조회 결과</h2>
    <p>현재 잔액: <%= request.getAttribute("balance") != null ? request.getAttribute("balance") : "잔액을 가져오지 못했습니다." %>원</p>
    <a href="balance.jsp">다시 조회하기</a>
</body>
</html>
