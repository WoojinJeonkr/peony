// 통계 데이터 실시간 업데이트 기능
$(document).ready(function() {
    // 5분마다 통계 데이터 업데이트
    setInterval(function() {
        updateStats();
    }, 300000);
});

function updateStats() {
    $.ajax({
        url: '/api/stats',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            $('.stats-text').eq(0).text('👥 총 가입자 ' + data.totalUsers + '명');
            $('.stats-text').eq(1).text('📈 금일 가입자 ' + data.todayUsers + '명');
        },
        error: function() {
            console.log('통계 데이터 업데이트 실패');
        }
    });
}
