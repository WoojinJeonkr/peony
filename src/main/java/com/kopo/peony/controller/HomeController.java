package com.kopo.peony.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.kopo.peony.DB;
import com.kopo.peony.DatabaseInitializer;

@Controller
public class HomeController {
	
	@Autowired
    private DatabaseInitializer databaseInitializer;
	
	@Autowired
	private DB db;
	
	@GetMapping("/")
	public String home(Model model) {
		
		if (!databaseInitializer.isDatabaseReady()) {
            databaseInitializer.initializeDatabase();
        }
		
		if (!db.isPreparingTable("user")) {
	        db.createTable();
	    }
		
		int totalUsers = db.getTotalUserCount();
        int todayUsers = db.getTodayUserCount();
        
        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("todayUsers", todayUsers);
		
		return "home";
	}
	
}
