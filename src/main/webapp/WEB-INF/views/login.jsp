<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>로그인</title>
	<link rel="stylesheet" href="/bootstrap/bootstrap.min.css">
	<script src="/js/jquery.min.js"></script>
	<script src="/bootstrap/bootstrap.min.js"></script>
</head>
<body>
	<div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-4">
                <div class="card shadow">
                    <div class="card-body">
                        <h2 class="card-title text-center mb-4">로그인</h2>
                        <form id="loginForm">
                            <div class="form-group mb-3">
                                <label for="id" class="form-label">아이디</label>
                                <input type="text" class="form-control" id="id" name="id" required>
                            </div>
                            <div class="form-group mb-3">
                                <label for="pwd" class="form-label">비밀번호</label>
                                <input type="password" class="form-control" id="pwd" name="pwd" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100 mt-2">로그인</button>
                        </form>
                        <div class="text-center mt-3">
                            <a href="/user/register" class="btn btn-link">회원가입</a>
                            <a href="/" class="btn btn-link">취소</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
<script>
	$(document).ready(function() {
	    $('#loginForm').on('submit', function(e) {
	        e.preventDefault();
	        $.ajax({
	            type: 'POST',
	            url: '/login',
	            data: $(this).serialize(),
	            success: function(data) {
	                alert(data.message);
	                if (data.message === "로그인 성공") {
	                    window.location.href = "/";
	                }
	            },
	            error: function() {
	                alert('로그인 중 오류가 발생했습니다.');
	            }
	        });
	    });
	});
</script>
</html>