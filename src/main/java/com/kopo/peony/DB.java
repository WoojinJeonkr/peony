package com.kopo.peony;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.sqlite.SQLiteConfig;

@Component
public class DB {
	
	@Autowired
    private DatabaseInitializer databaseInitializer;
    
    @SuppressWarnings("unused")
    private boolean initialized = false;
    
    private String databaseUrl; 
    
    static {
        try {
            Class.forName("org.sqlite.JDBC");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    @PostConstruct
    public void initDatabase() {
    	try {
            boolean initResult = databaseInitializer.initializeDatabase();
            if (initResult) {
            	this.databaseUrl = "jdbc:sqlite:" + databaseInitializer.getDatabasePath();
                this.initialized = true;
            } else {
                this.initialized = false;
            }
        } catch (Exception e) {
            System.out.println("데이터베이스 초기화 실패: " + e.getMessage());
            e.printStackTrace();
            this.initialized = false;
        }
    }
    
    private Connection getConnection() throws SQLException {
        if (this.databaseUrl == null) {
            throw new SQLException("Database URL is not initialized. Ensure initDatabase() runs successfully.");
        }
        SQLiteConfig config = new SQLiteConfig();
        return DriverManager.getConnection(this.databaseUrl, config.toProperties());
    }
    
	public boolean isPreparingTable(String tableName) {
	    boolean isExist = false;
	    String query = "SELECT name FROM sqlite_master WHERE type='table' AND name='" + tableName + "';";
	    try (Connection connection = getConnection();
	    	Statement statement = connection.createStatement();
    		ResultSet rs = statement.executeQuery(query)) {
	    	isExist = rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isExist;
	}

	public void createTable() {
		String query = "CREATE TABLE IF NOT EXISTS user ("
		        + "idx INTEGER PRIMARY KEY AUTOINCREMENT, "
		        + "id TEXT UNIQUE NOT NULL, "
		        + "pwd TEXT NOT NULL, "
		        + "userType TEXT NOT NULL, "
		        + "name TEXT NOT NULL, "
		        + "phone TEXT NOT NULL, "
		        + "address TEXT NOT NULL, "
		        + "status TEXT DEFAULT 'ACTIVE', "
		        + "created TEXT NOT NULL, "
		        + "lastUpdated TEXT NOT NULL, "
		        + "deletedAt TEXT"
		        + ");";
		try (Connection connection = getConnection();
             Statement statement = connection.createStatement()) {
			statement.executeUpdate(query);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void insertData(User user) {
		String query = "INSERT INTO user (id, pwd, userType, name, phone, address, status, created, lastUpdated, deletedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
			statement.setString(1, user.id);
			statement.setString(2, user.pwd);
			statement.setString(3, user.userType);
			statement.setString(4, user.name);
			statement.setString(5, user.phone);
			statement.setString(6, user.address);
			statement.setString(7, "ACTIVE");
			String now = (new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss")).format(new java.util.Date());
			statement.setString(8, now);
			statement.setString(9, now);
			statement.setString(10, null);
			statement.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public User getUserInfo(String id) {
		User user = null;
		String query = "SELECT * FROM user where id = ?";
		try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
			statement.setString(1, id);
			try (ResultSet rs = statement.executeQuery()) {
				if (rs.next()) {
					user = new User(
							rs.getInt("idx"),
							rs.getString("id"),
							rs.getString("pwd"),
							rs.getString("userType"),
							rs.getString("name"),
							rs.getString("phone"),
							rs.getString("address"),
							rs.getString("status"),
							rs.getString("created"),
							rs.getString("lastUpdated"),
							rs.getString("deletedAt")
						);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return user;
	}
	
	// 전체 회원 조회
	public ArrayList<User> selectAllUsers() {
		ArrayList<User> data = new ArrayList<>();
		String query = "SELECT * FROM user";
		try (Connection connection = getConnection();
			PreparedStatement statement = connection.prepareStatement(query);
			ResultSet result = statement.executeQuery()) {
			while (result.next()) {
				int idx = result.getInt("idx");
				String userType = result.getString("userType");
				String id = result.getString("id");
				String pwd = result.getString("pwd");
				String name = result.getString("name");
				String phone = result.getString("phone");
				String address = result.getString("address");
				String status = result.getString("status");
				String created = result.getString("created");
				String lastUpdated = result.getString("lastUpdated");
				String deletedAt = result.getString("deletedAt");
				data.add(new User(idx, id, pwd, userType, name, phone, address, status, created, lastUpdated, deletedAt));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return data;
	}
	
	// 활성 회원 조회
	public ArrayList<User> selectActiveUsers() {
	    ArrayList<User> data = new ArrayList<>();
	    String query = "SELECT * FROM user WHERE status = 'ACTIVE'";
	    try (Connection connection = getConnection();
		PreparedStatement statement = connection.prepareStatement(query);
		ResultSet result = statement.executeQuery()) {
			while (result.next()) {
				int idx = result.getInt("idx");
				String userType = result.getString("userType");
				String id = result.getString("id");
				String pwd = result.getString("pwd");
				String name = result.getString("name");
				String phone = result.getString("phone");
				String address = result.getString("address");
				String status = result.getString("status");
				String created = result.getString("created");
				String lastUpdated = result.getString("lastUpdated");
				String deletedAt = result.getString("deletedAt");
				data.add(new User(idx, id, pwd, userType, name, phone, address, status, created, lastUpdated, deletedAt));
			}
	    } catch (SQLException e) {
			e.printStackTrace();
		}
		return data;
	}
	
	// 탈퇴 회원 조회
	public ArrayList<User> selectDeletedUsers() {
		ArrayList<User> data = new ArrayList<>();
		String query = "SELECT * FROM user WHERE status = 'DELETED'";
		try (Connection connection = getConnection();
			PreparedStatement statement = connection.prepareStatement(query);
			ResultSet result = statement.executeQuery()) {
			while (result.next()) {
				int idx = result.getInt("idx");
				String userType = result.getString("userType");
				String id = result.getString("id");
				String pwd = result.getString("pwd");
				String name = result.getString("name");
				String phone = result.getString("phone");
				String address = result.getString("address");
				String status = result.getString("status");
				String created = result.getString("created");
				String lastUpdated = result.getString("lastUpdated");
				String deletedAt = result.getString("deletedAt");
				data.add(new User(idx, id, pwd, userType, name, phone, address, status, created, lastUpdated, deletedAt));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return data;
	}
	
	public void deactivateUsers(ArrayList<String> userIds) {
		String query = "UPDATE user SET status = 'DELETED', deletedAt = ? WHERE id = ?";
		String now = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());
		try (Connection connection = getConnection();
			PreparedStatement statement = connection.prepareStatement(query)) {
			for (String userId : userIds) {
				statement.setString(1, now);
				statement.setString(2, userId);
				statement.addBatch();
			}
			statement.executeBatch();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void updateUser(User user) {
		String query = "UPDATE user SET phone = ?, address = ?, userType = ?, lastUpdated = ? "
						+ "WHERE id = ?";
		String now = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());
		try (Connection connection = getConnection();
			PreparedStatement statement = connection.prepareStatement(query)) {
				statement.setString(1, user.getPhone());
				statement.setString(2, user.getAddress());
				statement.setString(3, user.getUserType());
				statement.setString(4, now);
				statement.setString(5, user.getId());
				statement.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void updateMyInfo(User user) {
		String query = "UPDATE user SET name = ?, phone = ?, address = ?, lastUpdated = ? WHERE id = ?";
		String now = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());
		try (Connection connection = getConnection();
			PreparedStatement statement = connection.prepareStatement(query)) {
				statement.setString(1, user.getName());
				statement.setString(2, user.getPhone());
				statement.setString(3, user.getAddress());
				statement.setString(4, now);
				statement.setString(5, user.getId());
				statement.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	// 전체 가입자 수 조회
	public int getTotalUserCount() {
	    int count = 0;
	    String query = "SELECT COUNT(*) as total FROM user WHERE status = 'ACTIVE'";
	    try (Connection connection = getConnection();
	         PreparedStatement statement = connection.prepareStatement(query);
	         ResultSet rs = statement.executeQuery()) {
	        if (rs.next()) {
	            count = rs.getInt("total");
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return count;
	}

	// 금일 가입자 수 조회
	public int getTodayUserCount() {
	    int count = 0;
	    String today = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
	    String query = "SELECT COUNT(*) as today_count FROM user WHERE status = 'ACTIVE' AND DATE(created) = ?";
	    try (Connection connection = getConnection();
	         PreparedStatement statement = connection.prepareStatement(query)) {
	        statement.setString(1, today);
	        try (ResultSet rs = statement.executeQuery()) {
	            if (rs.next()) {
	                count = rs.getInt("today_count");
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return count;
	}
}