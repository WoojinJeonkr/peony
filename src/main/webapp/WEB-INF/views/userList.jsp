<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.kopo.peony.model.User" %>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 관리 - Peony</title>
    <link rel="stylesheet" href="/bootstrap/bootstrap.min.css">
    <link rel="stylesheet" href="/css/common.css">
    <script src="/js/jquery.min.js"></script>
    <script src="/bootstrap/bootstrap.min.js"></script>
</head>
<style>
    .table {
	    table-layout: fixed;
	    width: 100%;
	}
	
	/* 체크박스 스타일링 개선 */
	.form-check-input, input[type="checkbox"] {
	    width: 18px;
	    height: 18px;
	    margin: 0;
	    vertical-align: middle;
	    cursor: pointer;
	    appearance: auto;
	    -webkit-appearance: auto;
	    position: relative;
	    border: 1px solid var(--gray-400);
	}
	
	/* 테이블 셀 내부 입력 필드 너비 조정 */
	.table td input.form-control {
	    width: 100%;
	    min-width: 100%;
	    box-sizing: border-box;
	    padding: 0.5rem;
	}
	
	/* 테이블 셀 내부 셀렉트 박스 너비 조정 */
	.table td select.form-control {
	    width: 100%;
	    min-width: 100%;
	    box-sizing: border-box;
	    padding: 0.5rem;
	}
	
	/* 테이블 셀 패딩 조정 */
	.table td {
	    padding: 0.75rem 0.5rem;
	    vertical-align: middle;
	}
	
	/* 체크박스 셀 너비 고정 */
	.table th:first-child, 
	.table td:first-child {
	    width: 40px;
	    min-width: 40px;
	    max-width: 40px;
	    text-align: center;
	}
	
	/* 아이디 셀 너비 고정 */
	.table th:nth-child(2), 
	.table td:nth-child(2) {
	    width: 120px;
	    min-width: 120px;
	}
	
	/* 이름 셀 너비 고정 */
	.table th:nth-child(3), 
	.table td:nth-child(3) {
	    width: 100px;
	    min-width: 100px;
	}
	
	/* 전화번호 셀 너비 고정 */
	.table th:nth-child(4), 
	.table td:nth-child(4) {
	    width: 150px;
	    min-width: 150px;
	}
	
	/* 주소 셀 너비 조정 */
	.table th:nth-child(5), 
	.table td:nth-child(5) {
	    width: 300px;
	    min-width: 300px;
	}
	
	/* 권한 셀 너비 고정 */
	.table th:nth-child(6), 
	.table td:nth-child(6) {
	    width: 120px;
	    min-width: 120px;
	}
	
	/* 컬럼별 너비 확대 (첫 번째 CSS에서 정의되지 않은 열만 적용) */
	.table th:nth-child(7) { width: 100px; }   /* 상태 */
	.table th:nth-child(8) { width: 180px; }   /* 가입일 */
	.table th:nth-child(9) { width: 180px; }   /* 수정일 */
	.table th:nth-child(10) { width: 180px; }  /* 삭제일 */
	
	/* 테이블 셀 스타일 (첫 번째 CSS에서 정의되지 않은 속성만 적용) */
	.table th, .table td {
	    line-height: 1.8;
	    white-space: normal;
	    word-break: keep-all;
	    word-wrap: break-word;
	    height: auto;
	}
	
	/* 테이블 헤더 고정 */
	.table th {
	    font-weight: 600;
	    color: var(--gray-700);
	    border-bottom: 2px solid var(--gray-300);
	    background-color: var(--gray-50);
	    position: sticky;
	    top: 0;
	    z-index: 10;
	}
	
	.table-responsive {
	    border-radius: var(--border-radius);
	    border: 1px solid var(--gray-200);
	    max-height: 600px;
	    overflow-x: auto;
	    overflow-y: auto;
	    width: 100%;
	}
	
	/* 나머지 스타일은 기존과 동일 */
	.form-check-input:checked {
	    background-color: var(--primary-color);
	    border-color: var(--primary-color);
	}
	
	.user-status-active {
	    color: var(--success-color);
	    font-weight: 600;
	}
	
	.user-status-deleted {
	    color: var(--danger-color);
	    font-weight: 600;
	}
	
	.deleted-user {
	    background-color: var(--gray-50);
	    opacity: 0.7;
	}
	
	.deleted-user td {
	    color: var(--gray-500);
	}
	
	.non-editable {
	    background-color: var(--gray-100) !important;
	}
	
	.userCheckbox:disabled {
	    opacity: 0.5;
	    cursor: not-allowed;
	}
	
	/* 스크롤바 스타일링 */
	.table-responsive::-webkit-scrollbar {
	    width: 12px;
	    height: 12px;
	}
	
	.table-responsive::-webkit-scrollbar-track {
	    background: var(--gray-100);
	    border-radius: 6px;
	}
	
	.table-responsive::-webkit-scrollbar-thumb {
	    background: var(--gray-400);
	    border-radius: 6px;
	}
	
	.table-responsive::-webkit-scrollbar-thumb:hover {
	    background: var(--gray-500);
	}
	
	/* 모바일 반응형 처리 */
	@media (max-width: 768px) {
	    .table {
	        min-width: 1200px; /* 모바일에서도 충분한 너비 보장 */
	    }
	    
	    .table-responsive {
	        font-size: 0.875rem;
	    }
	    
	    .table td, .table th {
	        padding: 0.5rem 0.25rem;
	        font-size: 0.75rem;
	    }
	    
	    .btn-group .btn {
	        font-size: 0.75rem;
	        padding: 0.375rem 0.75rem;
	    }
	}
</style>
<body>
    <%
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"admin".equals(currentUser.getUserType())) {
            response.sendRedirect("/");
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
                <a class="nav-link" href="/user/list">회원 목록</a>
                <a class="nav-link" href="/logout">로그아웃</a>
            </div>
        </div>
    </nav>

    <div class="container main-container">
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h3 class="mb-0">회원 관리</h3>
                            <div class="btn-group">
                                <button id="editBtn" class="btn btn-warning btn-sm" disabled>
                                    선택 수정
                                </button>
                                <button id="deactivateBtn" class="btn btn-danger btn-sm" disabled>
                                    선택 삭제
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card-body">
                        <ul class="nav nav-tabs mb-4" id="userTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="all-tab" data-tab="all" type="button" role="tab">
                                    전체 <span id="all-count" class="badge bg-secondary ms-1">0</span>
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="active-tab" data-tab="active" type="button" role="tab">
                                    활성 <span id="active-count" class="badge bg-success ms-1">0</span>
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="deleted-tab" data-tab="deleted" type="button" role="tab">
                                    탈퇴 <span id="deleted-count" class="badge bg-danger ms-1">0</span>
                                </button>
                            </li>
                        </ul>

                        <div id="loadingSpinner" class="text-center d-none">
                            <div class="spinner-border" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                            <p class="text-muted mt-2">데이터를 불러오는 중...</p>
                        </div>
                        <div class="table-responsive">
						    <form id="userForm">
						        <table class="table table-hover">
						            <colgroup>
						                <col style="width: 60px;">
						                <col style="width: 150px;">
						                <col style="width: 120px;">
						                <col style="width: 150px;">
						                <col style="width: 350px;">
						                <col style="width: 150px;">
						                <col style="width: 100px;">
						                <col style="width: 180px;">
						                <col style="width: 180px;">
						                <col style="width: 180px;">
						            </colgroup>
						            <thead>
						                <tr>
						                    <th scope="col">
						                        <input type="checkbox" id="checkAll" class="form-check-input">
						                    </th>
						                    <th scope="col">아이디</th>
						                    <th scope="col">이름</th>
						                    <th scope="col">전화번호</th>
						                    <th scope="col">주소</th>
						                    <th scope="col">권한</th>
						                    <th scope="col">상태</th>
						                    <th scope="col">가입일</th>
						                    <th scope="col">수정일</th>
						                    <th scope="col">삭제일</th>
						                </tr>
						            </thead>
						            <tbody id="userTableBody">
						                <tr>
						                    <td colspan="10" class="text-center text-muted py-4">
						                        데이터를 불러오는 중...
						                    </td>
						                </tr>
						            </tbody>
						        </table>
						    </form>
						</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
<script src="/js/userList.js"></script>
</html>