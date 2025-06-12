package com.kopo.peony;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class HomeController {
	
	@Autowired
    private DatabaseInitializer databaseInitializer;
	
	@Autowired
	private DB db;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Model model) {
		
		if (!databaseInitializer.isDatabaseReady()) {
            databaseInitializer.initializeDatabase();
        }
		
		if (!db.isPreparingTable("user")) {
	        db.createTable();
	    }
		
		return "home";
	}
	
}
