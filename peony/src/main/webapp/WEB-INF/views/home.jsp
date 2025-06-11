<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
	<meta charset="UTF-8">
	<title>Home</title>
	<link rel="stylesheet" href="/bootstrap/bootstrap.min.css">
	<script src="/js/jquery.min.js"></script>
	<script src="/bootstrap/bootstrap.min.js"></script>
</head>
<style>
	body {
		background-color: #f8f9fa;
		padding-top: 3rem;
	}
	.main-card {
		max-width: 800px;
		margin: 0 auto;
		box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	}
	.feature-card {
		transition: transform 0.2s;
	}
	.feature-card:hover {
		transform: scale(1.03);
	}
	.user-info {
		text-align: right;
		margin-bottom: 1rem;
	}
</style>
<body>
<div class="container">
		<div class="row justify-content-center">
			<div class="col-md-10">
				<c:if test="${empty sessionScope.user}">
	                <div class="alert alert-info d-flex align-items-center justify-content-center mb-4" role="alert" style="max-width: 800px; margin: 0 auto;">
	                  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="#0dcaf0" class="bi bi-info-circle me-2" viewBox="0 0 16 16">
	                    <path d="M8 15A7 7 0 1 0 8 1a7 7 0 0 0 0 14zm0 1A8 8 0 1 1 8 0a8 8 0 0 1 0 16z"/>
	                    <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 .877-.252 1.02-.598l.088-.416c.073-.34.217-.466.465-.466.288 0 .352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 .877-.252 1.02-.598l.088-.416c.073-.34.217-.466.465-.466.288 0 .352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 .877-.252 1.02-.598l.088-.416c.073-.34.217-.466.465-.466z"/>
	                    <circle cx="8" cy="4.5" r="1"/>
	                  </svg>
	                  <span class="fw-semibold">
	                    현재 <b>비회원 상태</b>입니다. 
	                    <a href="/login" class="alert-link">로그인</a> 또는 
	                    <a href="/register" class="alert-link">회원가입</a> 후 더 많은 서비스를 이용해보세요!
	                  </span>
	                </div>
	            </c:if>
				<div class="card main-card">
					<c:if test="${not empty sessionScope.user}">
				        <div class="d-flex justify-content-between align-items-center px-4 pt-3 pb-2" style="border-bottom:1px solid #eee;">
				            <div>
				                <span class="fw-bold" style="font-size:1.1rem;">
				                    <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" fill="#0d6efd" class="bi bi-person-circle mb-1 me-1" viewBox="0 0 16 16">
				                        <path d="M13.468 12.37C12.758 11.226 11.481 10.5 10 10.5s-2.758.726-3.468 1.87A6.987 6.987 0 0 0 8 15a6.987 6.987 0 0 0 5.468-2.63z"/>
				                        <path fill-rule="evenodd" d="M8 9a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm0 1a4 4 0 1 0 0-8 4 4 0 0 0 0 8z"/>
				                    </svg>
				                    ${sessionScope.user.name}님, 환영합니다!
				                </span>
				            </div>
				            <div>
				                <a href="/logout" class="btn btn-outline-secondary btn-sm ms-2">로그아웃</a>
				            </div>
				        </div>
				    </c:if>
					<div class="card-body text-center">
						<h1 class="card-title mb-4">멀티서비스 포털</h1>
						<p class="lead mb-5">게시판, 쇼핑몰, 게임을 한 번에!</p>
						
						<div class="row">
							<div class="col-md-4 mb-4">
								<div class="card feature-card h-100">
									<div class="card-body">
										<h5 class="card-title">게시판</h5>
										<p class="card-text">다양한 주제로<br>소통하세요.</p>
										<a href="#" class="btn btn-outline-primary">바로가기</a>
									</div>
								</div>
							</div>
							<div class="col-md-4 mb-4">
								<div class="card feature-card h-100">
									<div class="card-body">
										<h5 class="card-title">쇼핑몰</h5>
										<p class="card-text">필요한 상품을<br>쉽게 구매하세요.</p>
										<a href="#" class="btn btn-outline-primary">바로가기</a>
									</div>
								</div>
							</div>
							<div class="col-md-4 mb-4">
								<div class="card feature-card h-100">
									<div class="card-body">
										<h5 class="card-title">게임</h5>
										<p class="card-text">즐거운 게임을<br>경험하세요.</p>
										<a href="#" class="btn btn-outline-primary">바로가기</a>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>