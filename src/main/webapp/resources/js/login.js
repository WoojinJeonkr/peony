// 로그인 폼 처리 및 검증 기능
$(document).ready(function() {
    $('#loginForm').submit(function(e) {
        e.preventDefault();
        
        const formData = {
            id: $('#id').val(),
            pwd: $('#pwd').val()
        };
        
        // 입력값 검증
        if (!validateLoginForm(formData)) {
            return;
        }
        
        // 로그인 요청 처리
        performLogin(formData);
    });
});

/**
 * 로그인 폼 유효성 검사
 * @param {Object} formData - 폼 데이터 객체
 * @returns {boolean} 검증 통과 여부
 */
function validateLoginForm(formData) {
    if (!formData.id.trim()) {
        showAlert('warning', '아이디를 입력해주세요.');
        return false;
    }
    if (!formData.pwd.trim()) {
        showAlert('warning', '비밀번호를 입력해주세요.');
        return false;
    }
    return true;
}

/**
 * 로그인 API 요청 처리
 * @param {Object} formData - 로그인 폼 데이터
 */
function performLogin(formData) {
    $.ajax({
        url: '/login',
        type: 'POST',
        data: formData,
        success: function(response) {
            handleLoginSuccess(response);
        },
        error: function() {
            showAlert('danger', '로그인에 실패했습니다.');
        }
    });
}

/**
 * 로그인 성공 응답 처리
 * @param {Object} response - 서버 응답 객체
 */
function handleLoginSuccess(response) {
    if (response.message === '로그인 성공') {
        showAlert('success', '로그인되었습니다.');
        setTimeout(function() {
            window.location.href = '/';
        }, 1500);
    } else {
        showAlert('danger', response.message);
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