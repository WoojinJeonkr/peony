// 마이페이지 전역 변수
let map = null;
let marker = null;
let originalData = {};
let isEditing = false;

// 페이지 로드 시 초기화
$(document).ready(function() {
    loadUserInfo();
    initializeEventHandlers();
});

/**
 * 이벤트 핸들러 초기화
 */
function initializeEventHandlers() {
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
    
    $('#addressSearchBtn').click(getAddressByDaumPostcode);
}

/**
 * 다음 주소 API를 통한 주소 검색
 */
function getAddressByDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            var addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
            document.getElementById("userAddress").value = addr;
            
            // 주소 변경 시 지도 업데이트
            if (addr) {
                showMap(addr);
            }
        }
    }).open();
}

/**
 * 사용자 정보 로드
 */
function loadUserInfo() {
    $.ajax({
        url: '/user/myinfo',
        type: 'GET',
        success: function(response) {
            if (response.success) {
                const user = response.user;
                originalData = user;
                
                populateUserData(user);
                
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

/**
 * 사용자 데이터를 폼에 입력
 * @param {Object} user - 사용자 정보 객체
 */
function populateUserData(user) {
    $('#userId').val(user.id);
    $('#userType').val(user.userType === 'admin' ? '관리자' : '일반 사용자');
    $('#userName').val(user.name);
    $('#userPhone').val(user.phone);
    $('#userAddress').val(user.address);
    $('#created').val(formatDate(user.created));
    $('#lastUpdated').val(formatDate(user.lastUpdated));
}

/**
 * 카카오맵 표시 함수
 * @param {string} address - 표시할 주소
 */
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
        
        // 지도 조작 제한
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

/**
 * 편집 모드 활성화
 */
function enableEditing() {
    isEditing = true;
    $('#userName, #userPhone').prop('disabled', false);
    $('#userAddress').prop('readonly', false);
    $('#userAddress').css('background-color', 'white');
    $('#editBtn').hide();
    $('#saveBtn, #cancelBtn, #addressSearchBtn').show();
    $('#userName, #userPhone, #userAddress').removeClass('readonly-field');
}

/**
 * 편집 모드 비활성화
 */
function disableEditing() {
    isEditing = false;
    $('#userName, #userPhone').prop('disabled', true);
    $('#userAddress').prop('readonly', true);
    $('#userAddress').css('background-color', '#e9ecef');
    $('#saveBtn, #cancelBtn, #addressSearchBtn').hide();
    $('#editBtn').show();
    $('#userName, #userPhone, #userAddress').addClass('readonly-field');
}

/**
 * 사용자 정보 저장
 */
function saveUserInfo() {
    const userData = {
        id: $('#userId').val(),
        name: $('#userName').val(),
        phone: $('#userPhone').val(),
        address: $('#userAddress').val(),
        userType: originalData.userType
    };
    
    // 유효성 검사
    if (!validateUserData(userData)) {
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

/**
 * 사용자 데이터 유효성 검사
 * @param {Object} userData - 검증할 사용자 데이터
 * @returns {boolean} 검증 통과 여부
 */
function validateUserData(userData) {
    if (!userData.name.trim()) {
        showAlert('warning', '이름을 입력해주세요.');
        return false;
    }
    
    if (!userData.phone.trim()) {
        showAlert('warning', '전화번호를 입력해주세요.');
        return false;
    }
    
    if (!userData.address.trim()) {
        showAlert('warning', '주소를 입력해주세요.');
        return false;
    }
    
    return true;
}

/**
 * 알림 메시지 표시
 * @param {string} type - 알림 타입 (success, warning, danger)
 * @param {string} message - 표시할 메시지
 */
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

/**
 * 날짜 포맷팅 함수
 * @param {string} dateString - 포맷할 날짜 문자열
 * @returns {string} 포맷된 날짜 문자열
 */
function formatDate(dateString) {
    if (!dateString) return '';
    const date = new Date(dateString);
    return date.toLocaleString('ko-KR');
}
