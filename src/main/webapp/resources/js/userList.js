$(document).ready(function() {
    let editMode = false;
    let editingRows = new Set(); 

    // 전체 선택
    $("#checkAll").click(function() {
	    $("input[name=userIds]:not(:disabled)").prop('checked', this.checked);
	    updateButtonStates();
	});

    // 개별 체크박스 선택
    $(".userCheckbox").change(function() {
        updateButtonStates();
    });

    // 버튼 상태 업데이트
    function updateButtonStates() {
    	const checkedBoxes = $("input[name=userIds]:checked:not(:disabled)");
        const hasChecked = checkedBoxes.length > 0;
        
        $("#editBtn").prop('disabled', !hasChecked);
        $("#deactivateBtn").prop('disabled', !hasChecked);
    }

    // 수정 모드 토글 (헤더의 수정 버튼)
    $("#editBtn").click(function() {
        const checkedBoxes = $("input[name=userIds]:checked");
        
        if (!editMode) {
            // 수정 모드로 전환
            editMode = true;
            $(this).text('저장').removeClass('btn-warning').addClass('btn-success');
            
            checkedBoxes.each(function() {
                const row = $(this).closest('tr');
                const userId = row.data('user-id');
                editingRows.add(userId);
                
                // 해당 행의 입력 필드 활성화
                row.find('.phone, .address, .userType').prop('disabled', false);
                row.find('.updateBtn').prop('disabled', false).text('저장');
            });
        } else {
            // 저장 모드
            const updates = [];
            
            checkedBoxes.each(function() {
                const row = $(this).closest('tr');
                const userId = row.data('user-id');
                
                if (editingRows.has(userId)) {
                    const user = {
                        id: userId,
                        phone: row.find('.phone').val(),
                        address: row.find('.address').val(),
                        userType: row.find('.userType').val()
                    };
                    updates.push(user);
                    editingRows.delete(userId);
                }
            });
            
            // 모든 업데이트 실행
            if (updates.length > 0) {
                Promise.all(updates.map(user => 
                    $.ajax({
                        url: '/user/update',
                        type: 'PUT',
                        contentType: 'application/json',
                        data: JSON.stringify(user)
                    })
                )).then(() => {
                    alert('선택된 회원 정보가 수정되었습니다.');
                    location.reload();
                }).catch(() => {
                    alert('수정 중 오류가 발생했습니다.');
                });
            }
            
            editMode = false;
            $(this).text('수정').removeClass('btn-success').addClass('btn-warning');
        }
    });

    // 개별 행 수정/저장
    $(".updateBtn").click(function() {
        const row = $(this).closest('tr');
        const userId = row.data('user-id');
        const isEditing = editingRows.has(userId);
        
        if (!isEditing) {
            // 수정 모드로 전환
            editingRows.add(userId);
            row.find('.phone, .address, .userType').prop('disabled', false);
            $(this).text('저장');
        } else {
            // 저장
            const user = {
                id: userId,
                phone: row.find('.phone').val(),
                address: row.find('.address').val(),
                userType: row.find('.userType').val()
            };

            $.ajax({
                url: '/user/update',
                type: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify(user),
                success: function(data) {
                    alert(data.message);
                    editingRows.delete(userId);
                    row.find('.phone, .address, .userType').prop('disabled', true);
                    row.find('.updateBtn').text('수정');
                    updateButtonStates();
                },
                error: function() {
                    alert('수정 중 오류가 발생했습니다.');
                }
            });
        }
    });

    // 선택 계정 비활성화 (삭제)
    $("#deactivateBtn").click(function() {
        const userIds = [];
        $("input[name=userIds]:checked").each(function() {
            userIds.push($(this).val());
        });

        if (userIds.length === 0) {
            alert('삭제할 계정을 선택해주세요.');
            return;
        }

        if (confirm(`선택된 ${userIds.length}개 계정을 삭제하시겠습니까?`)) {
            $.ajax({
                url: '/user/deactivate',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(userIds),
                success: function(data) {
                    alert(data.message);
                    location.reload();
                },
                error: function() {
                    alert('삭제 중 오류가 발생했습니다.');
                }
            });
        }
    });

    // 초기 버튼 상태 설정
    updateButtonStates();
});