package com.kopo.peony.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kopo.peony.DB;

@Controller
@RequestMapping("/api")
public class StatsController {
    
    @Autowired
    private DB db;
    
    @GetMapping("/stats")
    @ResponseBody
    public Map<String, Integer> getStats() {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("totalUsers", db.getTotalUserCount());
        stats.put("todayUsers", db.getTodayUserCount());
        return stats;
    }
}

