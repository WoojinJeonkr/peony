package com.kopo.peony;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

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
			String dbFileName = "D:/sts-bundle/dbdata/peony.sqlite";
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
		String query = "CREATE TABLE user (idx INTEGER PRIMARY KEY AUTOINCREMENT, id TEXT, pwd TEXT, userType TEXT, name TEXT, phone TEXT, address TEXT, created TEXT, lastUpdated TEXT);";
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
		String query = "INSERT INTO user (id, pwd, userType, name, phone, address, created, lastUpdated) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement statement = this.connection.prepareStatement(query);
			statement.setString(1, user.id);
			statement.setString(2, user.pwd);
			statement.setString(3, user.userType);
			statement.setString(4, user.name);
			statement.setString(5, user.phone);
			statement.setString(6, user.address);
			String now = (new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss")).format(new java.util.Date());
			statement.setString(7, now);
			statement.setString(8, now);
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
	                    rs.getString("created"),
	                    rs.getString("lastUpdated")
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
}
