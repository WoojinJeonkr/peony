<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.kopo.peony.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Peony</title>
    <link rel="stylesheet" href="/bootstrap/bootstrap.min.css">
    <link rel="stylesheet" href="/css/common.css">
    <script src="/js/jquery.min.js"></script>
    <script src="/bootstrap/bootstrap.min.js"></script>
</head>
<style>
    .service-card {
        background: var(--white);
        border: 2px solid var(--gray-200);
        border-radius: var(--border-radius-lg);
        padding: 2rem 1.5rem;
        text-align: center;
        transition: var(--transition);
        height: 100%;
        box-shadow: var(--shadow-sm);
    }
    
    .service-card:hover {
        border-color: var(--primary-color);
        transform: translateY(-4px);
        box-shadow: var(--shadow-lg);
    }
    
    .service-icon {
        font-size: 3rem;
        margin-bottom: 1rem;
        opacity: 0.8;
    }
    
    .service-card h4 {
        margin-bottom: 1rem;
        color: var(--gray-800);
        font-weight: 600;
    }
    
    .service-card p {
        color: var(--gray-600);
        margin-bottom: 1.5rem;
        line-height: 1.6;
    }
    
    .stats-widget {
	    background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
	    border-radius: var(--border-radius-lg);
	    padding: 1rem 1.5rem;
	    box-shadow: var(--shadow);
	    transition: var(--transition);
	    color: var(--white);
	    text-align: center;
	}
	
	.stats-widget:hover {
	    transform: translateY(-2px);
	    box-shadow: var(--shadow-lg);
	}
	
	.stats-container {
	    display: flex;
	    justify-content: center;
	    align-items: center;
	    gap: 2rem;
	    flex-wrap: wrap;
	}
	
	.stats-text {
	    font-size: 1.1rem;
	    font-weight: 600;
	    margin: 0;
	    white-space: nowrap;
	}
	
	@media (max-width: 576px) {
	    .stats-container {
	        gap: 1rem;
	        flex-direction: column;
	    }
	    
	    .stats-text {
	        font-size: 1rem;
	    }
	}
	    
</style>
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
<script>
	$(document).ready(function() {
	    setInterval(function() {
	        updateStats();
	    }, 300000);
	});
	
	function updateStats() {
	    $.ajax({
	        url: '/api/stats',
	        type: 'GET',
	        dataType: 'json',
	        success: function(data) {
	            $('.stats-number').eq(0).text(data.totalUsers);
	            $('.stats-number').eq(1).text(data.todayUsers);
	        },
	        error: function() {
	            console.log('통계 데이터 업데이트 실패');
	        }
	    });
	}
</script>
</html>