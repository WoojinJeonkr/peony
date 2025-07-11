package com.kopo.peony.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
	
	int idx;
	String id;
	String pwd;
	String userType;
	String name;
	String phone;
	String address;
	String status;
	String created;
	String lastUpdated;
	String deletedAt;
	
	public User(String id, String pwd) {
		this.id = id;
		this.pwd = pwd;
	}
	
	public User(String idx, String userType, String name) {
		this.idx = Integer.parseInt(idx);
		this.userType = userType;
		this.name = name;
	}

	public User(String id, String pwd, String userType, String name, String phone, String address) {
		this.id = id;
		this.pwd = pwd;
		this.userType = userType;
		this.name = name;
		this.phone = phone;
		this.address = address;
	}

}
