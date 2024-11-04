package com.example;

import java.text.DecimalFormat;
import java.io.InputStream;
import java.io.IOException;
import java.util.Properties;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Random;

public class Bank_System {
    public class DatabaseConnection {
        private static String URL;
        private static String USER;
        private static String PASSWORD;

        static {
            Properties properties = new Properties();
            try (InputStream inputStream = DatabaseConnection.class.getClassLoader().getResourceAsStream("config.properties")) {
                if (inputStream == null) {
                    throw new IOException("config.properties 파일을 찾을 수 없습니다.");
                }
                properties.load(inputStream);

                URL = properties.getProperty("db.url");
                USER = properties.getProperty("db.user");
                PASSWORD = properties.getProperty("db.password");

            } catch (IOException e) {
                System.out.println("DB 설정 파일을 읽는 중 오류가 발생했습니다: " + e.getMessage());
            }
        }

        public static Connection getConnection() throws SQLException {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        }
    }

    // DecimalFormat 인스턴스를 전역적으로 선언
    private static final DecimalFormat df = new DecimalFormat("#,###");

    public void createAccountWithUser(String id, String name, String password, String accountNumber) {
        Connection conn = null;
        try {
            // 1. 계좌 번호 길이 확인 (14자리 이상이어야 함)
            if (accountNumber.length() < 14) {
                System.out.println("계좌 번호는 최소 14자리 이상이어야 합니다.");
                return;
            }



            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);  // 자동 커밋 비활성화

            // 2. 중복된 사용자 ID가 있는지 확인
            String checkUserSql = "SELECT COUNT(*) FROM users WHERE id = ?";
            PreparedStatement checkUserPstmt = conn.prepareStatement(checkUserSql);
            checkUserPstmt.setString(1, id);
            ResultSet userResultSet = checkUserPstmt.executeQuery();
            userResultSet.next();
            if (userResultSet.getInt(1) > 0) {
                System.out.println("아이디는 이미 사용 중입니다: " + id);
                conn.rollback();
                return;
            }

            // 3. 중복된 계좌 번호가 있는지 확인
            String checkAccountSql = "SELECT COUNT(*) FROM accounts WHERE account_number = ?";
            PreparedStatement checkAccountPstmt = conn.prepareStatement(checkAccountSql);
            checkAccountPstmt.setString(1, accountNumber);
            ResultSet accountResultSet = checkAccountPstmt.executeQuery();
            accountResultSet.next();
            if (accountResultSet.getInt(1) > 0) {
                System.out.println("이미 존재하는 계좌 번호입니다: " + accountNumber);
                conn.rollback();
                return;
            }

            // 4. USERS 테이블에 사용자 정보 삽입
            String userSql = "INSERT INTO users (id, name, password) VALUES (?, ?, ?)";
            PreparedStatement userPstmt = conn.prepareStatement(userSql);
            userPstmt.setString(1, id);
            userPstmt.setString(2, name);
            userPstmt.setString(3, password);
            int userRowsAffected = userPstmt.executeUpdate();

            // 5. ACCOUNTS 테이블에 계좌 정보 삽입
            String accountSql = "INSERT INTO accounts (account_number, balance) VALUES (?, ?)";
            PreparedStatement accountPstmt = conn.prepareStatement(accountSql);
            accountPstmt.setString(1, accountNumber);
            accountPstmt.setDouble(2, 0.0);  // 초기 잔액 0으로 설정
            int accountRowsAffected = accountPstmt.executeUpdate();

            // 6. 트랜잭션 커밋 (두 테이블 모두 성공 시)
            if (userRowsAffected > 0 && accountRowsAffected > 0) {
                conn.commit();
                System.out.println("계좌와 사용자 정보가 성공적으로 생성되었습니다.");
            } else {
                conn.rollback();  // 하나라도 실패하면 롤백
                System.out.println("계좌 또는 사용자 정보 생성에 실패했습니다.");
            }

        } catch (SQLException e) {
            System.out.println("계좌 생성 중 오류가 발생했습니다: " + e.getMessage());
            if (conn != null) {
                try {
                    conn.rollback();  // 오류 발생 시 롤백 시도
                    System.out.println("롤백되었습니다.");
                } catch (SQLException rollbackEx) {
                    System.out.println("트랜잭션 롤백 중 오류가 발생했습니다: " + rollbackEx.getMessage());
                }
            }
        } finally {
            // 자원 해제
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);  // 자동 커밋 복구
                    conn.close();  // 연결 해제
                } catch (SQLException e) {
                    System.out.println("연결 해제 중 오류가 발생했습니다: " + e.getMessage());
                }
            }
        }


    }

    public String generateAccountNumber() {
        Random random = new Random();
        StringBuilder accountNumber = new StringBuilder("6666");  // 앞 4자리 고정

        // 뒤에 10자리의 랜덤 숫자를 추가
        for (int i = 0; i < 10; i++) {
            int digit = random.nextInt(10);  // 0부터 9까지 랜덤한 숫자
            accountNumber.append(digit);
        }

        return accountNumber.toString();
    }

    public boolean isUserIdExists(String id) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String checkUserSql = "SELECT COUNT(*) FROM users WHERE id = ?";
            PreparedStatement pstmt = conn.prepareStatement(checkUserSql);
            pstmt.setString(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;  // 1 이상이면 중복된 ID
            }
        } catch (SQLException e) {
            System.out.println("ID 중복 확인 중 오류가 발생했습니다: " + e.getMessage());
        }
        return false;
    }



    // 입금
    public void deposit(String accountNumber, double amount) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String selectSql = "SELECT balance FROM accounts WHERE account_number = ?";
            PreparedStatement selectPstmt = conn.prepareStatement(selectSql);
            selectPstmt.setString(1, accountNumber);
            ResultSet rs = selectPstmt.executeQuery();

            if (rs.next()) {
                double currentBalance = rs.getDouble("balance");
                double newBalance = currentBalance + amount;

                String updateSql = "UPDATE accounts SET balance = ? WHERE account_number = ?";
                PreparedStatement updatePstmt = conn.prepareStatement(updateSql);
                updatePstmt.setDouble(1, newBalance);
                updatePstmt.setString(2, accountNumber);
                updatePstmt.executeUpdate();

                // DecimalFormat을 사용해 숫자를 포맷팅하여 출력
                System.out.println(df.format(amount) + "원이 입금되었습니다. 현재 잔액: " + df.format(newBalance) + "원");
            } else {
                System.out.println("계좌를 찾을 수 없습니다.");
            }
        } catch (SQLException e) {
            System.out.println("입금 중 오류가 발생했습니다: " + e.getMessage());
        }
    }

    // 출금
    public void withdraw(String accountNumber, double amount) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String selectSql = "SELECT balance FROM accounts WHERE account_number = ?";
            PreparedStatement selectPstmt = conn.prepareStatement(selectSql);
            selectPstmt.setString(1, accountNumber);
            ResultSet rs = selectPstmt.executeQuery();

            if (rs.next()) {
                double currentBalance = rs.getDouble("balance");

                if (currentBalance >= amount) {
                    double newBalance = currentBalance - amount;

                    String updateSql = "UPDATE accounts SET balance = ? WHERE account_number = ?";
                    PreparedStatement updatePstmt = conn.prepareStatement(updateSql);
                    updatePstmt.setDouble(1, newBalance);
                    updatePstmt.setString(2, accountNumber);
                    updatePstmt.executeUpdate();

                    // DecimalFormat을 사용해 숫자를 포맷팅하여 출력
                    System.out.println(df.format(amount) + "원이 출금되었습니다. 현재 잔액: " + df.format(newBalance) + "원");
                } else {
                    System.out.println("잔액이 부족합니다.");
                }
            } else {
                System.out.println("계좌를 찾을 수 없습니다.");
            }
        } catch (SQLException e) {
            System.out.println("출금 중 오류가 발생했습니다: " + e.getMessage());
        }
    }
    // 송금 기능
    public void transfer(String fromAccount, String toAccount, double amount) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);  // 트랜잭션 시작

            // 1. 출금 계좌에서 금액을 차감
            String selectFromSql = "SELECT balance FROM accounts WHERE account_number = ?";
            PreparedStatement selectFromPstmt = conn.prepareStatement(selectFromSql);
            selectFromPstmt.setString(1, fromAccount);
            ResultSet fromRs = selectFromPstmt.executeQuery();

            if (fromRs.next()) {
                double fromBalance = fromRs.getDouble("balance");

                if (fromBalance >= amount) {
                    // 출금 계좌의 새로운 잔액 계산
                    double newFromBalance = fromBalance - amount;

                    String updateFromSql = "UPDATE accounts SET balance = ? WHERE account_number = ?";
                    PreparedStatement updateFromPstmt = conn.prepareStatement(updateFromSql);
                    updateFromPstmt.setDouble(1, newFromBalance);
                    updateFromPstmt.setString(2, fromAccount);
                    updateFromPstmt.executeUpdate();
                } else {
                    System.out.println("출금 계좌의 잔액이 부족합니다.");
                    conn.rollback();  // 트랜잭션 롤백
                    return;
                }
            } else {
                System.out.println("출금 계좌를 찾을 수 없습니다.");
                conn.rollback();  // 트랜잭션 롤백
                return;
            }

            // 2. 입금 계좌에 금액 추가
            String selectToSql = "SELECT balance FROM accounts WHERE account_number = ?";
            PreparedStatement selectToPstmt = conn.prepareStatement(selectToSql);
            selectToPstmt.setString(1, toAccount);
            ResultSet toRs = selectToPstmt.executeQuery();

            if (toRs.next()) {
                double toBalance = toRs.getDouble("balance");
                double newToBalance = toBalance + amount;

                String updateToSql = "UPDATE accounts SET balance = ? WHERE account_number = ?";
                PreparedStatement updateToPstmt = conn.prepareStatement(updateToSql);
                updateToPstmt.setDouble(1, newToBalance);
                updateToPstmt.setString(2, toAccount);
                updateToPstmt.executeUpdate();
            } else {
                System.out.println("입금 계좌를 찾을 수 없습니다.");
                conn.rollback();  // 트랜잭션 롤백
                return;
            }

            // 3. 송금 내역을 transfer_history 테이블에 추가
            String insertHistorySql = "INSERT INTO transfer_history (from_account, to_account, amount) VALUES (?, ?, ?)";
            PreparedStatement insertHistoryPstmt = conn.prepareStatement(insertHistorySql);
            insertHistoryPstmt.setString(1, fromAccount);
            insertHistoryPstmt.setString(2, toAccount);
            insertHistoryPstmt.setDouble(3, amount);
            insertHistoryPstmt.executeUpdate();

            // 4. 트랜잭션 커밋 (모든 작업 성공 시)
            conn.commit();
            System.out.println(df.format(amount) + "원이 " + fromAccount + "에서 " + toAccount + "으로 송금되었습니다.");

        } catch (SQLException e) {
            System.out.println("송금 중 오류가 발생했습니다: " + e.getMessage());
            if (conn != null) {
                try {
                    conn.rollback();  // 오류 발생 시 롤백 시도
                    System.out.println("롤백되었습니다.");
                } catch (SQLException rollbackEx) {
                    System.out.println("트랜잭션 롤백 중 오류가 발생했습니다: " + rollbackEx.getMessage());
                }
            }
        } finally {
            // 자원 해제
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);  // 자동 커밋 복구
                    conn.close();  // 연결 해제
                } catch (SQLException e) {
                    System.out.println("연결 해제 중 오류가 발생했습니다: " + e.getMessage());
                }
            }
        }
    }



    // 잔액 조회
    public double checkBalance(String accountNumber) {
        double balance = 0.0; // 초기 값을 지정합니다.
        try (Connection conn = DBConnection.getConnection()) {
            System.out.println("데이터베이스 연결 성공, 잔액 조회 중...");

            String sql = "SELECT balance FROM accounts WHERE account_number = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, accountNumber);

            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                balance = rs.getDouble("balance");
                System.out.println("계좌의 현재 잔액: " + balance);
            } else {
                System.out.println("해당 계좌를 찾을 수 없습니다: " + accountNumber);
            }
        } catch (SQLException e) {
            System.out.println("잔액 조회 중 오류 발생: " + e.getMessage());
        }
        return balance; // 잔액을 반환
    }



}
