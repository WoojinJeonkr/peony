<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.kopo.peony.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Peony</title>
    <link rel="stylesheet" href="/bootstrap/bootstrap.min.css">
    <link rel="stylesheet" href="/css/home.css">
    <script src="/js/jquery.min.js"></script>
    <script src="/bootstrap/bootstrap.min.js"></script>
</head>
<body>
    <%
        User currentUser = (User) session.getAttribute("user");
    %>
    
    <nav class="navbar">
        <div class="container-fluid main-container">
            <a class="navbar-brand" href="/">Peony</a>
            <div class="d-flex align-items-center gap-3">
                <% if (currentUser != null) { %>
                    <span class="text-muted me-3">
                        <%= currentUser.getName() %>님, 환영합니다!
                    </span>
                    <a class="nav-link" href="/user/mypage">
                        마이페이지
                    </a>
                    <% if ("admin".equals(currentUser.getUserType())) { %>
                        <a class="nav-link" href="/user/list">
                            회원 목록
                        </a>
                    <% } %>
                    <a class="nav-link" href="/logout">
                        로그아웃
                    </a>
                <% } else { %>
                    <a class="nav-link" href="/login">
                        로그인
                    </a>
                    <a class="nav-link" href="/user/register">
                        회원가입
                    </a>
                <% } %>
            </div>
        </div>
    </nav>

    <div class="container main-container">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card">
                    <div class="card-header text-center">
                        <h1 style="font-size: 2.5rem; font-weight: bold;">
                            멀티서비스 포털
                        </h1>
                        <p style="margin: 1rem 0 0 0; opacity: 0.9; font-size: 1.1rem;">
                            게시판, 쇼핑몰, 게임을 한 번에 경험하세요
                        </p>
                    </div>
                    
                    <div class="card-body">
                    	<div class="row g-4 mb-4">
				            <div class="col-12">
				                <div class="stats-widget">
				                    <div class="stats-container">
				                        <div class="stats-text">👥 총 가입자 ${totalUsers}명</div>
				                        <div class="stats-text">📈 금일 가입자 ${todayUsers}명</div>
				                    </div>
				                </div>
				            </div>
				        </div>
                        <% if (currentUser != null) { %>
                            <div class="row g-4 mb-5">
                                <div class="col-md-4">
                                    <div class="service-card">
                                        <div class="service-icon">📝</div>
                                        <h4>게시판</h4>
                                        <p>다양한 주제로 소통하고<br> 정보를 공유하세요</p>
                                        <button class="btn btn-primary">
                                            바로가기
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="service-card">
                                        <div class="service-icon">🛒</div>
                                        <h4>쇼핑몰</h4>
                                        <p>필요한 상품을<br> 편리하게 구매하세요</p>
                                        <button class="btn btn-primary">
                                            바로가기
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="service-card">
                                        <div class="service-icon">🎮</div>
                                        <h4>게임</h4>
                                        <p>재미있는 게임으로<br> 즐거운 시간을 보내세요</p>
                                        <button class="btn btn-primary">
                                            바로가기
                                        </button>
                                    </div>
                                </div>
                            </div>
                        <% } else { %>
                            <div class="text-center">
                                <div class="welcome-section mb-5">
                                    <h2 style="color: var(--gray-800); margin-bottom: 1rem;">
                                        서비스를 이용하려면 로그인하세요
                                    </h2>
                                    <p class="text-muted">
                                        로그인하여 다양한 서비스를 경험해보세요
                                    </p>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
<script src="/js/home.js"></script>
</html>