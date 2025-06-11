package com.kopo.peony;

import java.sql.Connection;
import java.sql.DriverManager;
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
}
