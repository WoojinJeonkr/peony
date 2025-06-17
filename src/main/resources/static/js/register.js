$(document).ready(function() {
    initializeEventHandlers();
});

/**
 * 이벤트 핸들러 초기화
 */
function initializeEventHandlers() {
    $('#registerForm').submit(function(e) {
        e.preventDefault();
        handleRegisterSubmit();
    });
}

/**
 * 다음 주소 API를 통한 주소 검색
 */
function getAddressByDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            var addr = '';
            if (data.userSelectedType === 'R') {
                addr = data.roadAddress;
            } else {
                addr = data.jibunAddress;
            }
            document.getElementById("address").value = addr;
        }
    }).open();
}

/**
 * 회원가입 폼 제출 처리
 */
function handleRegisterSubmit() {
    const formData = collectFormData();
    
    if (!validateRegisterForm(formData)) {
        return;
    }
    
    performRegister(formData);
}

/**
 * 폼 데이터 수집
 * @returns {Object} 폼 데이터 객체
 */
function collectFormData() {
    return {
        id: $('#id').val(),
        pwd: $('#pwd').val(),
        name: $('#name').val(),
        phone: $('#phone').val(),
        address: $('#address').val()
    };
}

/**
 * 회원가입 폼 유효성 검사
 * @param {Object} formData - 폼 데이터 객체
 * @returns {boolean} 검증 통과 여부
 */
function validateRegisterForm(formData) {
    if (!formData.id.trim()) {
        showAlert('warning', '아이디를 입력해주세요.');
        return false;
    }
    if (!formData.pwd.trim()) {
        showAlert('warning', '비밀번호를 입력해주세요.');
        return false;
    }
    if (!formData.name.trim()) {
        showAlert('warning', '이름을 입력해주세요.');
        return false;
    }
    if (!formData.phone.trim()) {
        showAlert('warning', '전화번호를 입력해주세요.');
        return false;
    }
    if (!formData.address.trim()) {
        showAlert('warning', '주소를 입력해주세요.');
        return false;
    }
    return true;
}

/**
 * 회원가입 API 요청 처리
 * @param {Object} formData - 회원가입 폼 데이터
 */
function performRegister(formData) {
    $.ajax({
        url: '/user/insert',
        type: 'POST',
        data: formData,
        success: function(response) {
            handleRegisterSuccess(response);
        },
        error: function() {
            showAlert('danger', '회원가입에 실패했습니다.');
        }
    });
}

/**
 * 회원가입 성공 응답 처리
 * @param {Object} response - 서버 응답 객체
 */
function handleRegisterSuccess(response) {
    showAlert('success', response.message);
    if (response.message.includes('추가되었습니다')) {
        setTimeout(function() {
            window.location.href = '/login';
        }, 2000);
    }
}

/**
 * 알림 메시지 표시 함수
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
    setTimeout(() => $('.alert').fadeOut(), 3000);
}