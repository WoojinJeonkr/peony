<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>회원가입</title>
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
						<h2 class="card-title text-center mb-4">회원가입</h2>
						<form id="registerForm">
						    <div class="form-group mb-3">
						        <label for="id" class="form-label">아이디</label>
						        <input type="text" class="form-control" id="id" name="id" required>
						    </div>
						    <div class="form-group mb-3">
						        <label for="pwd" class="form-label">비밀번호</label>
						        <input type="password" class="form-control" id="pwd" name="pwd" required>
						    </div>
						    <div class="form-group mb-3">
						        <label for="name" class="form-label">이름</label>
						        <input type="text" class="form-control" id="name" name="name" required>
						    </div>
						    <div class="form-group mb-3">
						        <label for="phone" class="form-label">전화번호</label>
						        <input type="text" class="form-control" id="phone" name="phone" required>
						    </div>
						    <div class="form-group mb-3">
						        <label for="address" class="form-label">주소</label>
						        <input type="text" class="form-control" id="address" name="address" required>
						    </div>
						    <input type="submit" id="joinBtn" class="btn btn-primary w-100 mt-2" value="가입하기" />
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
<script>
	$('#registerForm').on('submit', function(e) {
	    e.preventDefault();
		$.ajax({
			type: 'POST',
			url: '/insert',
			data: $(this).serialize(),
			success: function(data) {
				alert(data.message);
				if (data.message === "회원 정보가 추가되었습니다.") {
					window.location.href = "/";
				}
			},
			error: function() {
				alert('서버 오류가 발생했습니다.');
			}
		});
	});
</script>
</html>