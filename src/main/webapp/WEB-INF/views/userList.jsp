<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>회원 관리</title>
    <link rel="stylesheet" href="/bootstrap/bootstrap.min.css">
    <link rel="stylesheet" href="/css/userList.css">
    <script src="/js/jquery.min.js"></script>
    <script src="/bootstrap/bootstrap.min.js"></script>
</head>
<body>
<div class="container mt-5">
    <div class="card shadow">
        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
            <h3 class="mb-0">회원 목록</h3>
            <div>
                <button id="editBtn" class="btn btn-warning btn-sm me-2" disabled>수정</button>
                <button id="deactivateBtn" class="btn btn-danger btn-sm me-2" disabled>삭제</button>
            </div>
        </div>
        <div class="card-body">
            <ul class="nav nav-tabs mb-3" id="userTabs" role="tablist">
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
            </div>

            <div style="overflow-x: auto; max-width: 100%;">
                <form id="userForm">
                    <table class="table table-hover">
                        <thead class="thead-light">
                            <tr>
                                <th><input type="checkbox" id="checkAll"></th>
                                <th>아이디</th>
                                <th>이름</th>
                                <th>전화번호</th>
                                <th>주소</th>
                                <th>권한</th>
                                <th>상태</th>
                                <th>가입일</th>
                                <th>수정일</th>
                                <th>삭제일</th>
                            </tr>
                        </thead>
                        <tbody id="userTableBody">
                            <tr>
                                <td colspan="10" class="text-center text-muted">데이터를 불러오는 중...</td>
                            </tr>
                        </tbody>
                    </table>
                </form>
            </div>
            <div class="text-center mt-3">
                <a href="/" class="btn btn-outline-primary">홈으로</a>
            </div>
        </div>
    </div>
</div>
<script src="/js/userList.js"></script>
</body>
</html>