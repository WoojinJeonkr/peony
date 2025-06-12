<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입 - Peony</title>
    <link rel="stylesheet" href="/bootstrap/bootstrap.min.css">
    <link rel="stylesheet" href="/css/common.css">
    <script src="/js/jquery.min.js"></script>
    <script src="/bootstrap/bootstrap.min.js"></script>
</head>
<body>
    <nav class="navbar">
        <div class="container">
            <a class="navbar-brand" href="/">Peony</a>
            <div class="d-flex align-items-center gap-3">
                <a class="nav-link" href="/login">로그인</a>
                <a class="nav-link" href="/user/register">회원가입</a>
            </div>
        </div>
    </nav>

    <div class="container main-container">
        <div class="row justify-content-center">
            <div class="col-lg-6 col-md-8">
                <div class="card">
                    <div class="card-header text-center">
                        <h2>회원가입</h2>
                        <p class="mb-0 mt-2" style="opacity: 0.9;">새로운 계정을 만들어보세요</p>
                    </div>
                    
                    <div class="card-body">
                        <div id="alertContainer"></div>
                        
                        <form id="registerForm">
                            <div class="form-group">
                                <label class="form-label">아이디</label>
                                <input type="text" class="form-control" id="id" name="id" placeholder="아이디를 입력하세요" required>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">비밀번호</label>
                                <input type="password" class="form-control" id="pwd" name="pwd" placeholder="비밀번호를 입력하세요" required>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">이름</label>
                                <input type="text" class="form-control" id="name" name="name" placeholder="이름을 입력하세요" required>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">전화번호</label>
                                <input type="tel" class="form-control" id="phone" name="phone" placeholder="전화번호를 입력하세요" required>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">주소</label>
                                <textarea class="form-control" id="address" name="address" rows="3" placeholder="주소를 입력하세요" required></textarea>
                            </div>
                            
                            <div class="text-center">
                                <button type="submit" class="btn btn-primary mb-3" style="width: 100%;">
                                    가입하기
                                </button>
                                <div>
                                    <span class="text-muted">이미 계정이 있으신가요? </span>
                                    <a href="/login" class="text-decoration-none" style="color: var(--primary-color);">로그인</a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
<script>
    $('#registerForm').submit(function(e) {
        e.preventDefault();
        
        const formData = {
            id: $('#id').val(),
            pwd: $('#pwd').val(),
            name: $('#name').val(),
            phone: $('#phone').val(),
            address: $('#address').val()
        };
        
        // 유효성 검사
        if (!formData.id.trim()) {
            showAlert('warning', '아이디를 입력해주세요.');
            return;
        }
        if (!formData.pwd.trim()) {
            showAlert('warning', '비밀번호를 입력해주세요.');
            return;
        }
        if (!formData.name.trim()) {
            showAlert('warning', '이름을 입력해주세요.');
            return;
        }
        if (!formData.phone.trim()) {
            showAlert('warning', '전화번호를 입력해주세요.');
            return;
        }
        if (!formData.address.trim()) {
            showAlert('warning', '주소를 입력해주세요.');
            return;
        }
        
        $.ajax({
            url: '/user/insert',
            type: 'POST',
            data: formData,
            success: function(response) {
                showAlert('success', response.message);
                if (response.message.includes('추가되었습니다')) {
                    setTimeout(function() {
                        window.location.href = '/login';
                    }, 2000);
                }
            },
            error: function() {
                showAlert('danger', '회원가입에 실패했습니다.');
            }
        });
    });

    function showAlert(type, message) {
        const alertHtml = `
            <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        `;
        $('#alertContainer').html(alertHtml);
        setTimeout(() => $('.alert').fadeOut(), 3000);
    }
</script>
</html>