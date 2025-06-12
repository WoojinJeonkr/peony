package com.kopo.peony;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import org.sqlite.SQLiteConfig;

public class DB {
	
	private Connection connection;

	static {
		try {
			Class.forName("org.sqlite.JDBC");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void open() {
		try {
			String dbFileName = "H:/sts-bundle/dbdata/peony.sqlite";
			SQLiteConfig config = new SQLiteConfig();
			this.connection = DriverManager.getConnection("jdbc:sqlite:/" + dbFileName, config.toProperties());
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	private void close() {
		try {
			this.connection.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public boolean isPreparingTable(String tableName) {
	    this.open();
	    boolean isExist = false;
	    String query = "SELECT name FROM sqlite_master WHERE type='table' AND name='" + tableName + "';";
	    try {
	        Statement statement = this.connection.createStatement();
	        ResultSet rs = statement.executeQuery(query);
	        isExist = rs.next();
	        rs.close();
	        statement.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        this.close();
	    }
	    return isExist;
	}

	public void createTable() {
		this.open();
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
		try {
			Statement statement = this.connection.createStatement();
			statement.executeUpdate(query);
			statement.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		this.close();
	}
	
	public void insertData(User user) {
		this.open();
		String query = "INSERT INTO user (id, pwd, userType, name, phone, address, status, created, lastUpdated, deletedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement statement = this.connection.prepareStatement(query);
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
			statement.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		this.close();
	}
	
	public User getUserInfo(String id) {
		this.open();
		User user = null;
		try {
			String query = "SELECT * FROM user where id = ?";
			PreparedStatement statement = this.connection.prepareStatement(query);
			statement.setString(1, id);
	        ResultSet rs = statement.executeQuery();
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
	        rs.close();
	        statement.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        this.close();
	    }
	    return user;
	}
	
	// 전체 회원 조회
	public ArrayList<User> selectAllUsers() {
		this.open();
		ArrayList<User> data = new ArrayList<>();
		try {
			String query = "SELECT * FROM user";
			PreparedStatement statement = this.connection.prepareStatement(query);
			ResultSet result = statement.executeQuery();
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
			statement.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		this.close();
		return data;
	}
	
	// 활성 회원 조회
	public ArrayList<User> selectActiveUsers() {
	    this.open();
	    ArrayList<User> data = new ArrayList<>();
	    try {
	        String query = "SELECT * FROM user WHERE status = 'ACTIVE'";
	        PreparedStatement statement = this.connection.prepareStatement(query);
	        ResultSet result = statement.executeQuery();
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
	        statement.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    this.close();
	    return data;
	}
	
	// 탈퇴 회원 조회
	public ArrayList<User> selectDeletedUsers() {
	    this.open();
	    ArrayList<User> data = new ArrayList<>();
	    try {
	        String query = "SELECT * FROM user WHERE status = 'DELETED'";
	        PreparedStatement statement = this.connection.prepareStatement(query);
	        ResultSet result = statement.executeQuery();
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
	        statement.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    this.close();
	    return data;
	}
	
	public void deactivateUsers(ArrayList<String> userIds) {
	    this.open();
	    String query = "UPDATE user SET status = 'DELETED', deletedAt = ? WHERE id = ?";
	    String now = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
	                        .format(new java.util.Date());
	    try {
	        PreparedStatement statement = this.connection.prepareStatement(query);
	        for (String userId : userIds) {
	            statement.setString(1, now);
	            statement.setString(2, userId);
	            statement.addBatch();
	        }
	        statement.executeBatch();
	        statement.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        this.close();
	    }
	}
	
	public void updateUser(User user) {
	    this.open();
	    String query = "UPDATE user SET phone = ?, address = ?, userType = ?, lastUpdated = ? "
	                 + "WHERE id = ?";
	    String now = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
	                        .format(new java.util.Date());
	    try {
	        PreparedStatement statement = this.connection.prepareStatement(query);
	        statement.setString(1, user.getPhone());
	        statement.setString(2, user.getAddress());
	        statement.setString(3, user.getUserType());
	        statement.setString(4, now);
	        statement.setString(5, user.getId());
	        statement.executeUpdate();
	        statement.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        this.close();
	    }
	}
}