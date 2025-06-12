<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.kopo.peony.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <link rel="stylesheet" href="/bootstrap/bootstrap.min.css">
    <script src="/js/jquery.min.js"></script>
    <script src="/bootstrap/bootstrap.min.js"></script>
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .navbar-brand {
            font-weight: bold;
            color: white !important;
        }
        .navbar-nav .nav-link {
            color: white !important;
            transition: all 0.3s ease;
        }
        .navbar-nav .nav-link:hover {
            background-color: rgba(255,255,255,0.2);
            border-radius: 5px;
        }
        .main-container {
            margin-top: 30px;
            margin-bottom: 30px;
        }
        .profile-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
            transition: transform 0.3s ease;
        }
        .profile-card:hover {
            transform: translateY(-5px);
        }
        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .profile-header h2 {
            margin: 0;
            font-weight: 300;
        }
        .profile-header .user-type {
            background: rgba(255,255,255,0.2);
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            margin-top: 10px;
            display: inline-block;
        }
        .profile-body {
            padding: 40px;
        }
        .form-group {
            margin-bottom: 25px;
        }
        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 8px;
            display: block;
        }
        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 12px 15px;
            font-size: 16px;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .form-control:disabled {
            background-color: #f8f9fa;
            border-color: #e9ecef;
            color: #6c757d;
        }
        .btn-group-custom {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }
        .btn-custom {
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 16px;
            border: none;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .btn-edit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-edit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .btn-save {
            background: linear-gradient(135deg, #56ab2f 0%, #a8e6cf 100%);
            color: white;
        }
        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(86, 171, 47, 0.4);
        }
        .btn-cancel {
            background: linear-gradient(135deg, #ff6b6b 0%, #ffa8a8 100%);
            color: white;
        }
        .btn-cancel:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 107, 107, 0.4);
        }
        .alert-custom {
            border-radius: 10px;
            border: none;
            padding: 15px 20px;
            margin-bottom: 20px;
        }
        .readonly-field {
            background-color: #f8f9fa !important;
            color: #6c757d !important;
        }
    </style>
</head>
<body>
    <%
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("/login");
            return;
        }
    %>
    
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="/">Peony System</a>
            <div class="navbar-nav ms-auto">
                <span class="navbar-text me-3">
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
                <div class="profile-card">
                    <div class="profile-header">
                        <h2>마이페이지</h2>
                        <div class="user-type">
                            <%= "admin".equals(currentUser.getUserType()) ? "관리자" : "일반 사용자" %>
                        </div>
                    </div>
                    
                    <div class="profile-body">
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
                                <input type="text" class="form-control" id="userPhone" name="phone" disabled>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">주소</label>
                                <textarea class="form-control" id="userAddress" name="address" rows="3" disabled></textarea>
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
                            
                            <div class="btn-group-custom">
                                <button type="button" class="btn btn-custom btn-edit" id="editBtn">수정</button>
                                <button type="button" class="btn btn-custom btn-save" id="saveBtn" style="display: none;">저장</button>
                                <button type="button" class="btn btn-custom btn-cancel" id="cancelBtn" style="display: none;">취소</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        let originalData = {};
        let isEditing = false;

        $(document).ready(function() {
            loadUserInfo();
            
            $('#editBtn').click(function() {
                enableEditing();
            });
            
            $('#saveBtn').click(function() {
                saveUserInfo();
            });
            
            $('#cancelBtn').click(function() {
                disableEditing();
                loadUserInfo(); // 원래 데이터로 복원
            });
        });

        function loadUserInfo() {
            $.ajax({
                url: '/user/myinfo',
                type: 'GET',
                success: function(response) {
                    if (response.success) {
                        const user = response.user;
                        originalData = user;
                        
                        $('#userId').val(user.id);
                        $('#userType').val(user.userType === 'admin' ? '관리자' : '일반 사용자');
                        $('#userName').val(user.name);
                        $('#userPhone').val(user.phone);
                        $('#userAddress').val(user.address);
                        $('#created').val(formatDate(user.created));
                        $('#lastUpdated').val(formatDate(user.lastUpdated));
                    } else {
                        showAlert('danger', response.message);
                    }
                },
                error: function() {
                    showAlert('danger', '사용자 정보를 불러오는데 실패했습니다.');
                }
            });
        }

        function enableEditing() {
            isEditing = true;
            $('#userName, #userPhone, #userAddress').prop('disabled', false);
            $('#editBtn').hide();
            $('#saveBtn, #cancelBtn').show();
            
            // 수정 가능한 필드 스타일 변경
            $('#userName, #userPhone, #userAddress').removeClass('readonly-field');
        }

        function disableEditing() {
            isEditing = false;
            $('#userName, #userPhone, #userAddress').prop('disabled', true);
            $('#saveBtn, #cancelBtn').hide();
            $('#editBtn').show();
            
            // 수정 불가능한 필드 스타일 복원
            $('#userName, #userPhone, #userAddress').addClass('readonly-field');
        }

        function saveUserInfo() {
            const userData = {
                id: $('#userId').val(),
                name: $('#userName').val(),
                phone: $('#userPhone').val(),
                address: $('#userAddress').val(),
                userType: originalData.userType // 원본 userType 유지
            };
            
            // 유효성 검사
            if (!userData.name.trim()) {
                showAlert('warning', '이름을 입력해주세요.');
                return;
            }
            
            if (!userData.phone.trim()) {
                showAlert('warning', '전화번호를 입력해주세요.');
                return;
            }
            
            if (!userData.address.trim()) {
                showAlert('warning', '주소를 입력해주세요.');
                return;
            }

            $.ajax({
                url: '/user/myinfo/update',
                type: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify(userData),
                success: function(response) {
                    showAlert('success', response.message);
                    disableEditing();
                    loadUserInfo(); // 업데이트된 정보 다시 로드
                },
                error: function() {
                    showAlert('danger', '회원 정보 수정에 실패했습니다.');
                }
            });
        }

        function showAlert(type, message) {
            const alertHtml = `
                <div class="alert alert-${type} alert-custom alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            `;
            $('#alertContainer').html(alertHtml);
            
            // 3초 후 자동으로 사라지게 하기
            setTimeout(function() {
                $('.alert').fadeOut();
            }, 3000);
        }

        function formatDate(dateString) {
            if (!dateString) return '';
            const date = new Date(dateString);
            return date.toLocaleString('ko-KR');
        }
    </script>
</body>
</html>