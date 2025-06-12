package com.kopo.peony;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class HomeController {
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Model model) {
		
		DB db = new DB();
		
		if (!db.isPreparingTable("user")) {
	        db.createTable();
	    }
		
		return "home";
	}
	
}
