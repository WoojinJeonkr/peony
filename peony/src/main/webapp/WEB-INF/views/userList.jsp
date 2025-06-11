<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>회원 관리</title>
    <link rel="stylesheet" href="/bootstrap/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <div class="card shadow">
        <div class="card-header bg-primary text-white">
            <h3 class="mb-0">회원 목록</h3>
        </div>
        <div class="card-body">
            <table class="table table-hover">
                <thead class="thead-light">
                    <tr>
                        <th>아이디</th>
                        <th>이름</th>
                        <th>전화번호</th>
                        <th>권한</th>
                        <th>가입일</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td>${user.id}</td>
                            <td>${user.name}</td>
                            <td>${user.phone}</td>
                            <td>
                                <span class="badge ${user.userType eq 'admin' ? 'badge-danger' : 'badge-secondary'}">
                                    ${user.userType}
                                </span>
                            </td>
                            <td>${user.created}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <a href="/" class="btn btn-outline-primary">홈으로</a>
        </div>
    </div>
</div>
</body>
</html>