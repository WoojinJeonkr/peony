package com.kopo.peony.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kopo.peony.DB;
import com.kopo.peony.model.User;
import com.kopo.peony.util.PasswordUtil;

@Controller
public class UserController {
	
	@Autowired
	private DB db;
	
	@Value("${kakao.api.key}")
    private String kakaoApiKey;
	
	@RequestMapping(value="/user/register", method = RequestMethod.GET)
	public String register() {
		return "register";
	}
	
	@ResponseBody
	@RequestMapping(value="/user/insert", method = RequestMethod.POST)
	public HashMap<String, String> insert(@RequestParam("id") String id, @RequestParam("pwd") String pwd,
	                                    @RequestParam("name") String name, @RequestParam("phone") String phone,
	                                    @RequestParam("address") String address) {
		
	    HashMap<String, String> data = new HashMap<>();
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
	
	@RequestMapping(value="/login")
	public String moveLoginPage() {
		return "login";
	}
	
	@ResponseBody
	@RequestMapping(value="/login", method = RequestMethod.POST)
	public HashMap<String, String> login(@RequestParam("id") String id, @RequestParam("pwd") String pwd, HttpSession session) {
		HashMap<String, String> data = new HashMap<>();
	    User user = db.getUserInfo(id);

	    if (user != null && BCrypt.checkpw(pwd, user.getPwd())) {
	    	if ("DELETED".equals(user.getStatus())) {
	    		data.put("message", "탈퇴된 계정입니다.");
	    	} else {
	    		session.setAttribute("user", user);
	    		data.put("message", "로그인 성공");
	    		data.put("name", user.getName());
	    		data.put("userType", user.getUserType());
	    	}
	    } else {
	    	data.put("message", "아이디 또는 비밀번호가 일치하지 않습니다.");
	    }
	    
	    return data;
	}
	
	@RequestMapping("/logout")
	public String logout(HttpSession session) {
	    session.invalidate();
	    return "redirect:/";
	}
	
	@RequestMapping("/user/list")
	public String moveUserListPage(HttpSession session) {
	    User currentUser = (User) session.getAttribute("user");
	    if(currentUser == null || !"admin".equals(currentUser.getUserType())) {
	        return "redirect:/";
	    }
	    
	    return "userList";
	}
	
	@ResponseBody
	@RequestMapping(value="/user/list/all", method=RequestMethod.GET)
	public HashMap<String, Object> getAllUsers(HttpSession session) {
		HashMap<String, Object> data = new HashMap<>();
	    User currentUser = (User) session.getAttribute("user");
	    
	    if(currentUser == null || !"admin".equals(currentUser.getUserType())) {
	        data.put("success", false);
	        data.put("message", "권한이 없습니다.");
	        return data;
	    }
	    
	    try {
	        ArrayList<User> userList = db.selectAllUsers();
	        data.put("success", true);
	        data.put("users", userList);
	    } catch (Exception e) {
	        e.printStackTrace();
	        data.put("success", false);
	        data.put("message", "회원 목록 조회에 실패했습니다.");
	    }
	    
	    return data;
	}
	
	@ResponseBody
	@RequestMapping(value="/user/list/active", method=RequestMethod.GET)
	public HashMap<String, Object> getActiveUsers(HttpSession session) {
	    HashMap<String, Object> data = new HashMap<>();
	    User currentUser = (User) session.getAttribute("user");
	    
	    if(currentUser == null || !"admin".equals(currentUser.getUserType())) {
	        data.put("success", false);
	        data.put("message", "권한이 없습니다.");
	        return data;
	    }
	    
	    try {
	        
	        ArrayList<User> userList = db.selectActiveUsers();
	        data.put("success", true);
	        data.put("users", userList);
	    } catch (Exception e) {
	        e.printStackTrace();
	        data.put("success", false);
	        data.put("message", "활성 회원 목록 조회에 실패했습니다.");
	    }
	    
	    return data;
	}
	
	@ResponseBody
	@RequestMapping(value="/user/list/deleted", method=RequestMethod.GET)
	public HashMap<String, Object> getDeletedUsers(HttpSession session) {
	    HashMap<String, Object> data = new HashMap<>();
	    User currentUser = (User) session.getAttribute("user");
	    
	    if(currentUser == null || !"admin".equals(currentUser.getUserType())) {
	        data.put("success", false);
	        data.put("message", "권한이 없습니다.");
	        return data;
	    }
	    
	    try {
	        
	        ArrayList<User> userList = db.selectDeletedUsers();
	        data.put("success", true);
	        data.put("users", userList);
	    } catch (Exception e) {
	        e.printStackTrace();
	        data.put("success", false);
	        data.put("message", "탈퇴 회원 목록 조회에 실패했습니다.");
	    }
	    
	    return data;
	}
	
	@ResponseBody
	@RequestMapping(value="/user/deactivate", method=RequestMethod.POST)
	public HashMap<String, String> deactivateUsers(@RequestBody ArrayList<String> userIds) {
	    HashMap<String, String> data = new HashMap<>();
	    
	    try {
	        db.deactivateUsers(userIds);
	        data.put("message", "선택 계정이 비활성화되었습니다.");
	    } catch (Exception e) {
	        e.printStackTrace();
	        data.put("message", "계정 비활성화에 실패했습니다.");
	    }
	    return data;
	}

	@ResponseBody
	@RequestMapping(value="/user/update", method=RequestMethod.PUT)
	public HashMap<String, String> updateUser(@RequestBody User user) {
	    HashMap<String, String> data = new HashMap<>();
	    
	    try {
	        db.updateUser(user);
	        data.put("message", "회원 정보가 수정되었습니다.");
	    } catch (Exception e) {
	        e.printStackTrace();
	        data.put("message", "회원 정보 수정에 실패했습니다.");
	    }
	    return data;
	}
	
	@RequestMapping(value="/user/mypage", method = RequestMethod.GET)
	public String moveMyPage(Model model, HttpSession session) {
	    User currentUser = (User) session.getAttribute("user");
	    if(currentUser == null) {
	        return "redirect:/login";
	    }
	    
	    model.addAttribute("kakaoApiKey", kakaoApiKey);
	    
	    return "mypage";
	}
	
	@ResponseBody
	@RequestMapping(value="/user/myinfo", method=RequestMethod.GET)
	public HashMap<String, Object> getMyInfo(HttpSession session) {
	    HashMap<String, Object> data = new HashMap<>();
	    User currentUser = (User) session.getAttribute("user");
	    
	    if(currentUser == null) {
	        data.put("success", false);
	        data.put("message", "로그인이 필요합니다.");
	        return data;
	    }
	    
	    try {
	        User user = db.getUserInfo(currentUser.getId());
	        if(user != null) {
	            data.put("success", true);
	            data.put("user", user);
	        } else {
	            data.put("success", false);
	            data.put("message", "사용자 정보를 찾을 수 없습니다.");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        data.put("success", false);
	        data.put("message", "사용자 정보 조회에 실패했습니다.");
	    }
	    
	    return data;
	}
	
	@ResponseBody
	@RequestMapping(value="/user/myinfo/update", method=RequestMethod.PUT)
	public HashMap<String, String> updateMyInfo(@RequestBody User user, HttpSession session) {
	    HashMap<String, String> data = new HashMap<>();
	    User currentUser = (User) session.getAttribute("user");
	    
	    if(currentUser == null) {
	        data.put("message", "로그인이 필요합니다.");
	        return data;
	    }
	    
	    if(!currentUser.getId().equals(user.getId())) {
	        data.put("message", "본인의 정보만 수정할 수 있습니다.");
	        return data;
	    }
	    
	    try {
	        db.updateMyInfo(user);
	        
	        User updatedUser = db.getUserInfo(user.getId());
	        session.setAttribute("user", updatedUser);
	        
	        data.put("message", "회원 정보가 성공적으로 수정되었습니다.");
	    } catch (Exception e) {
	        e.printStackTrace();
	        data.put("message", "회원 정보 수정에 실패했습니다.");
	    }
	    
	    return data;
	}
}
