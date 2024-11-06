<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>MyBank - Online Banking</title>
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

        /* Header 스타일 */
        header {
            background-color: rgba(0, 51, 102, 0.85);
            color: white;
            padding: 1.5em;
            text-align: center;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        }

        header h1 {
            margin-bottom: 0.2em;
        }

        header p {
            font-size: 1.2em;
            font-style: italic;
        }

        /* 네비게이션 스타일 */
        nav ul {
            list-style: none;
            background-color: rgba(0, 64, 128, 0.85);
            padding: 1em;
            text-align: center;
            display: flex;
            justify-content: center;
            gap: 20px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        }

        nav ul li a {
            color: white;
            text-decoration: none;
            font-size: 1.1em;
            padding: 0.5em 1em;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        nav ul li a:hover {
            background-color: #FFD700;
            color: #003366;
        }

        /* 메인 콘텐츠 스타일 */
        .content {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            padding: 2em;
            gap: 20px;
            background-color: rgba(255, 255, 255, 0.8);
            border-radius: 10px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
            margin: 2em;
        }

        /* 서비스 카드 스타일 */
        .card {
            width: 250px;
            background-color: white;
            padding: 1.5em;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s, box-shadow 0.3s;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 200px; /* 카드 높이 일정하게 설정 */
        }

        .card h3 {
            color: #003366;
            margin-bottom: 0.8em;
            font-size: 1.3em;
        }

        .card p {
            flex-grow: 1;
            margin-bottom: 1em;
            font-size: 0.95em;
            color: #333;
        }

        .button {
            display: inline-block;
            padding: 0.8em 1.5em;
            font-size: 1em;
            color: white;
            background-color: #0066cc;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            cursor: pointer;
            transition: background-color 0.3s;
            width: 100%; /* 버튼 너비를 카드 내 전체 너비로 */
            max-width: 200px; /* 버튼 최대 너비 */
            align-self: center;
        }

        .button:hover {
            background-color: #0052a3;
        }

        /* Footer 스타일 (화면 하단 고정) */
        footer {
            background-color: rgba(0, 51, 102, 0.85);
            color: white;
            padding: 1.5em;
            text-align: center;
            width: 100%;
            position: fixed;
            bottom: 0;
            left: 0;
            box-shadow: 0px -4px 8px rgba(0, 0, 0, 0.1);
        }

        /* 반응형 스타일 */
        @media (max-width: 30vw) {
            nav ul {
                flex-direction: column;
                padding: 1em 0;
            }

            nav ul li {
                display: block;
                margin: 0.5em 0;
            }

            .content {
                flex-direction: column;
                align-items: center;
                padding: 1em;
            }

            .card {
                width: 100%;
                max-width: 300px;
            }

            footer {
                padding: 1em;
                font-size: 0.9em;
            }
        }

        @media (max-width: 600px) {
            header h1 {
                font-size: 1.5em;
            }

            header p {
                font-size: 1em;
            }

            .button {
                font-size: 0.9em;
                padding: 0.5em 1em;
            }

            .card {
                padding: 1em;
            }

            footer p {
                font-size: 0.8em;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <h1>Welcome to MyBank</h1>
        <p>Your trusted partner for all banking needs</p>
    </header>

    <!-- Navigation -->
    <nav>
        <ul>
            <li><a href="index.jsp">Home</a></li>
            <li><a href="createAccount.jsp">Create Account</a></li>
            <li><a href="deposit.jsp">Deposit</a></li>
            <li><a href="withdraw.jsp">Withdraw</a></li>
            <li><a href="transfer.jsp">Transfer</a></li>
            <li><a href="checkBalance.jsp">Check Balance</a></li>
        </ul>
    </nav>

    <!-- Main Content -->
    <div class="content">
        <div class="card">
            <h3>Create Account</h3>
            <p>Open a new account with ease and enjoy exclusive banking services.</p>
            <a href="createAccount.jsp" class="button">Create Account</a>
        </div>

        <div class="card">
            <h3>Deposit</h3>
            <p>Deposit money into your account safely and instantly.</p>
            <a href="deposit.jsp" class="button">Deposit</a>
        </div>

        <div class="card">
            <h3>Withdraw</h3>
            <p>Withdraw funds from your account whenever you need.</p>
            <a href="withdraw.jsp" class="button">Withdraw</a>
        </div>

        <div class="card">
            <h3>Transfer</h3>
            <p>Transfer funds to other accounts quickly and securely.</p>
            <a href="transfer.jsp" class="button">Transfer</a>
        </div>

        <div class="card">
            <h3>Check Balance</h3>
            <p>Keep track of your balance with real-time updates.</p>
            <a href="checkBalance.jsp" class="button">Check Balance</a>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <p>© 2024 MyBank. 부산외국어대학교.</p>
        <p>Contact us: 김정륜| +82 010 8270 3590</p>
    </footer>
</body>
</html>
