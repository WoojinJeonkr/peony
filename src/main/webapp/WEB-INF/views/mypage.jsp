<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.kopo.peony.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - Peony</title>
    <link rel="stylesheet" href="/bootstrap/bootstrap.min.css">
    <link rel="stylesheet" href="/css/common.css">
    <script src="/js/jquery.min.js"></script>
    <script src="/bootstrap/bootstrap.min.js"></script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>
    <%
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("/login");
            return;
        }
    %>
    
    <nav class="navbar">
        <div class="container-fluid main-container">
            <a class="navbar-brand" href="/">Peony</a>
            <div class="d-flex align-items-center gap-3">
                <span class="text-muted me-3">
                    <%= currentUser.getName() %>님, 환영합니다!
                </span>
                <a class="nav-link" href="/user/mypage">마이페이지</a>
                <% if ("admin".equals(currentUser.getUserType())) { %>
                    <a class="nav-link" href="/user/list">회원 목록</a>
                <% } %>
                <a class="nav-link" href="/logout">로그아웃</a>
            </div>
        </div>
    </nav>

    <div class="container main-container">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-md-10">
                <div class="card">
                    <div class="card-header text-center">
                        <h2>마이페이지</h2>
                        <div style="margin-top: 0.5rem;">
                            <span class="badge bg-secondary">
                                <%= "admin".equals(currentUser.getUserType()) ? "관리자" : "일반 사용자" %>
                            </span>
                        </div>
                    </div>
                    
                    <div class="card-body">
                        <div id="alertContainer"></div>
                        
                        <form id="profileForm">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">아이디</label>
                                        <input type="text" class="form-control readonly-field" id="userId" name="id" readonly>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">사용자 유형</label>
                                        <input type="text" class="form-control readonly-field" id="userType" name="userType" readonly>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">이름</label>
                                <input type="text" class="form-control" id="userName" name="name" disabled>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">전화번호</label>
                                <input type="tel" class="form-control" id="userPhone" name="phone" disabled>
                            </div>
                            
                            <div class="form-group">
							    <label class="form-label">주소</label>
							    <div class="d-flex mb-2">
							        <input type="text" class="form-control" id="userAddress" name="address" readonly>
							        <button type="button" class="btn btn-outline-secondary ms-2" id="addressSearchBtn" style="display: none;">주소 검색</button>
							    </div>
							    <div id="map" style="width:100%; height:300px; margin-top:10px;"></div>
							</div>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">가입일</label>
                                        <input type="text" class="form-control readonly-field" id="created" readonly>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">최종 수정일</label>
                                        <input type="text" class="form-control readonly-field" id="lastUpdated" readonly>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="text-center">
                                <button type="button" class="btn btn-primary" id="editBtn">정보 수정</button>
                                <button type="button" class="btn btn-success" id="saveBtn" style="display: none;">저장</button>
                                <button type="button" class="btn btn-outline-secondary" id="cancelBtn" style="display: none;">취소</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoApiKey}&libraries=services"></script>
<script src="/js/mypage.js"></script>
</html>