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
<script>
	let map = null;
	let marker = null;
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
            loadUserInfo();
        });
    });
    
    function getAddressByDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
                document.getElementById("userAddress").value = addr;
            }
        }).open();
    }

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
                    
                 	// 주소가 있으면 지도 표시
                    if (user.address) {
                        showMap(user.address);
                    }
                } else {
                    showAlert('danger', response.message);
                }
            },
            error: function() {
                showAlert('danger', '사용자 정보를 불러오는데 실패했습니다.');
            }
        });
    }
    
    var mapContainer = document.getElementById('map'),
	    mapOption = {
	        center: new daum.maps.LatLng(37.537187, 127.005476),
	        level: 5
	    };
	
    function showMap(address) {
        if (!map) {
            map = new daum.maps.Map(document.getElementById('map'), {
                center: new daum.maps.LatLng(37.537187, 127.005476),
                level: 5
            });
            marker = new daum.maps.Marker({
                position: new daum.maps.LatLng(37.537187, 127.005476),
                map: map
            });
            
            map.setDraggable(false);
            map.setZoomable(false);
        }
        var geocoder = new daum.maps.services.Geocoder();
        geocoder.addressSearch(address, function(results, status) {
            if (status === daum.maps.services.Status.OK) {
                var coords = new daum.maps.LatLng(results[0].y, results[0].x);
                map.setCenter(coords);
                marker.setPosition(coords);
            }
        });
    }


    function enableEditing() {
        isEditing = true;
        $('#userName, #userPhone').prop('disabled', false);
        $('#userAddress').prop('readonly', false);
        $('#userAddress').css('background-color', 'white');
        $('#editBtn').hide();
        $('#saveBtn, #cancelBtn, #addressSearchBtn').show();
        $('#userName, #userPhone, #userAddress').removeClass('readonly-field');
    }

    function disableEditing() {
        isEditing = false;
        $('#userName, #userPhone').prop('disabled', true);
        $('#userAddress').prop('readonly', true);
        $('#userAddress').css('background-color', '#e9ecef');
        $('#saveBtn, #cancelBtn, #addressSearchBtn').hide();
        $('#editBtn').show();
        $('#userName, #userPhone, #userAddress').addClass('readonly-field');
    }
    
    $('#addressSearchBtn').click(getAddressByDaumPostcode);

    function saveUserInfo() {
        const userData = {
            id: $('#userId').val(),
            name: $('#userName').val(),
            phone: $('#userPhone').val(),
            address: $('#userAddress').val(),
            userType: originalData.userType
        };
        
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
                loadUserInfo();
            },
            error: function() {
                showAlert('danger', '회원 정보 수정에 실패했습니다.');
            }
        });
    }

    function showAlert(type, message) {
        const alertHtml = `
            <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        `;
        $('#alertContainer').html(alertHtml);
        
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
</html>