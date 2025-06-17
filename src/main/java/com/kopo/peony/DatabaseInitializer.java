package com.kopo.peony;

import java.io.File;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

@Component
@PropertySource("classpath:database.properties")
public class DatabaseInitializer {
	
	@Value("${sqlite.db.path}")
    private String dbPath;
    
    @Value("${gitclone.rootproject.path}")
    private String gitCloneRootPath;
    
    private String cachedProjectRoot = null;
    
    private String findProjectRoot() {
        try {
            File gitRoot = new File(gitCloneRootPath);
            if (gitRoot.exists() && new File(gitRoot, ".git").exists()) {
                return gitRoot.getAbsolutePath();
            } else {
                System.out.println("설정된 Git 프로젝트 루트가 유효하지 않음: " + gitCloneRootPath);
                String fallbackPath = System.getProperty("user.dir");
                System.out.println("대체 경로 사용: " + fallbackPath);
                return fallbackPath;
            }
        } catch (Exception e) {
            System.err.println("프로젝트 루트 탐색 중 오류: " + e.getMessage());
            return System.getProperty("user.dir");
        }
    }
    
    public String getProjectRoot() {
        if (cachedProjectRoot == null) {
            cachedProjectRoot = findProjectRoot();
        }
        return cachedProjectRoot;
    }
    
    public String getDatabasePath() {
        String projectRoot = getProjectRoot();
        String relativePath = dbPath.startsWith("./") ? dbPath.substring(2) : dbPath;
        return new File(projectRoot, relativePath).getAbsolutePath();
    }
    
    public boolean initializeDatabase() {
        try {
            String projectRoot = getProjectRoot();
            
            if (projectRoot == null || projectRoot.isEmpty()) {
                throw new RuntimeException("프로젝트 루트 경로를 찾을 수 없습니다.");
            }
            
            String relativePath = dbPath.startsWith("./") ? dbPath.substring(2) : dbPath;
            File dbFile = new File(projectRoot, relativePath);
            
            // 디렉토리 생성
            File parentDir = dbFile.getParentFile();
            if (!parentDir.exists()) {
                parentDir.mkdirs();
            }
            
            return true;
        } catch (Exception e) {
            System.out.println("데이터베이스 초기화 실패: " + e.getMessage());
            return false;
        }
    }
    
    public boolean isDatabaseReady() {
        try {
            String dbPath = getDatabasePath();
            File dbFile = new File(dbPath);
            return dbFile.exists() && dbFile.length() > 0;
        } catch (Exception e) {
            System.out.println("데이터베이스 상태 확인 중 오류: " + e.getMessage());
            return false;
        }
    }
}
