<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 - Peony</title>
    <link rel="stylesheet" href="/bootstrap/bootstrap.min.css">
    <link rel="stylesheet" href="/css/common.css">
    <script src="/js/jquery.min.js"></script>
    <script src="/bootstrap/bootstrap.min.js"></script>
</head>
<body>
    <nav class="navbar">
        <div class="container-fluid main-container">
            <a class="navbar-brand" href="/">Peony</a>
            <div class="d-flex align-items-center gap-3">
                <a class="nav-link" href="/login">로그인</a>
                <a class="nav-link" href="/user/register">회원가입</a>
            </div>
        </div>
    </nav>

    <div class="container main-container">
        <div class="row justify-content-center">
            <div class="col-lg-5 col-md-7">
                <div class="card">
                    <div class="card-header text-center">
                        <h2>로그인</h2>
                        <p class="mb-0 mt-2" style="opacity: 0.9;">계정에 로그인하세요</p>
                    </div>
                    
                    <div class="card-body">
                        <div id="alertContainer"></div>
                        
                        <form id="loginForm">
                            <div class="form-group">
                                <label class="form-label">아이디</label>
                                <input type="text" class="form-control" id="id" name="id" placeholder="아이디를 입력하세요" required>
                            </div>
                            
                            <div class="form-group mb-4">
                                <label class="form-label">비밀번호</label>
                                <input type="password" class="form-control" id="pwd" name="pwd" placeholder="비밀번호를 입력하세요" required>
                            </div>
                            
                            <div class="text-center">
                                <button type="submit" class="btn btn-primary mb-3" style="width: 100%;">
                                    로그인
                                </button>
                                <div>
                                    <a href="/user/register" class="text-decoration-none me-3" style="color: var(--primary-color);">회원가입</a>
                                    <a href="/" class="text-decoration-none" style="color: var(--gray-500);">홈으로</a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
<script src="/js/login.js"></script>
</html>