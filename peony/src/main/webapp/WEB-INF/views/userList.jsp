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
	                    <tbody>
	                        <c:forEach var="user" items="${users}">
	                            <tr data-user-id="${user.id}" ${user.status eq 'DELETED' ? 'class="deleted-user"' : ''}>
	                                <td>
							            <input type="checkbox" 
							                   name="userIds" 
							                   value="${user.id}" 
							                   class="userCheckbox"
							                   ${user.status eq 'DELETED' ? 'disabled' : ''}>
							        </td>
	                                <td>${user.id}</td>
	                                <td>${user.name}</td>
	                                <td><input type="text" class="form-control phone" value="${user.phone}" disabled></td>
	                                <td><input type="text" class="form-control address" value="${user.address}" disabled></td>
	                                <td>
	                                    <select class="form-control userType" disabled>
	                                        <option value="user" ${user.userType eq 'user' ? 'selected' : ''}>일반</option>
	                                        <option value="admin" ${user.userType eq 'admin' ? 'selected' : ''}>관리자</option>
	                                    </select>
	                                </td>
	                                <td>${user.status}</td>
	                                <td>${user.created}</td>
	                                <td>${user.lastUpdated}</td>
	                                <td>${user.deletedAt}</td>
	                            </tr>
	                        </c:forEach>
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