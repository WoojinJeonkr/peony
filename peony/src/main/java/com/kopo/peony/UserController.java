package com.kopo.peony;

import java.util.HashMap;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class UserController {
	
	@RequestMapping(value="/register", method = RequestMethod.GET)
	public String register() {
		return "register";
	}
	
	@ResponseBody
	@RequestMapping(value="/insert", method = RequestMethod.POST)
	public HashMap<String, String> insert(@RequestParam("id") String id, @RequestParam("pwd") String pwd,
	                                    @RequestParam("name") String name, @RequestParam("phone") String phone,
	                                    @RequestParam("address") String address) {
		
	    HashMap<String, String> data = new HashMap<>();
	    DB db = new DB();
	    String userType = "user";
	    
	    if (id.startsWith("admin")) {
	    	userType = "admin";
	    }
	    
	    try {
	    	String hashedPwd = PasswordUtil.hashPassword(pwd);
	        User user = new User(id, hashedPwd, userType, name, phone, address);
	        db.insertData(user);
	        data.put("message", "회원 정보가 추가되었습니다.");
	    } catch (Exception e) {
	        e.printStackTrace();
	        data.put("message", "회원 정보 추가에 실패했습니다.");
	    }
	    
	    return data;
	    
	}
	
}
