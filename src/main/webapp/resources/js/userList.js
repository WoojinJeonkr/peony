$(document).ready(function() {
    let editMode = false;
    let editingRows = new Set();
    let currentTab = 'all'; // 기본값을 'all'로 설정

    // 페이지 로드 시 즉시 전체 사용자 데이터 로드
    initializePage();

    // 페이지 초기화 함수
    function initializePage() {
        // 전체 탭이 기본으로 선택된 상태로 시작
        setActiveTab('all');
        // 전체 사용자 데이터 로드
        loadUsersByTab('all');
        // 모든 탭의 카운트 업데이트
        updateTabCounts();
    }

    // 활성 탭 설정 함수
    function setActiveTab(tabType) {
        $('#userTabs button[data-tab]').removeClass('active');
        $(`#${tabType}-tab`).addClass('active');
        currentTab = tabType;
    }

    // 탭 클릭 이벤트
    $('#userTabs button[data-tab]').click(function() {
        const tabType = $(this).data('tab');
        if (currentTab === tabType) return; // 같은 탭 클릭 시 무시
        
        // 편집 모드일 경우 확인 후 취소
        if (editMode) {
            if (!confirm('편집 중인 내용이 있습니다. 탭을 변경하시겠습니까?')) {
                return;
            }
            cancelEditMode();
        }
        
        switchTab(tabType);
    });

    // 탭 전환 함수
    function switchTab(tabType) {
        setActiveTab(tabType);
        loadUsersByTab(tabType);
    }

    // 탭별 사용자 데이터 로드
    function loadUsersByTab(tabType) {
        showLoading(true);
        
        let url = '';
        switch(tabType) {
            case 'all':
                url = '/user/list/all';
                break;
            case 'active':
                url = '/user/list/active';
                break;
            case 'deleted':
                url = '/user/list/deleted';
                break;
        }

        $.ajax({
            url: url,
            type: 'GET',
            success: function(response) {
                if (response.success) {
                    renderUserTable(response.users);
                    // 현재 탭의 카운트도 업데이트
                    updateCurrentTabCount(tabType, response.users.length);
                } else {
                    alert(response.message || '데이터 로딩에 실패했습니다.');
                    renderEmptyTable('데이터 로딩에 실패했습니다.');
                }
            },
            error: function() {
                alert('서버 오류가 발생했습니다.');
                renderEmptyTable('서버 오류가 발생했습니다.');
            },
            complete: function() {
                showLoading(false);
                updateButtonStates();
            }
        });
    }

    // 현재 탭 카운트 업데이트
    function updateCurrentTabCount(tabType, count) {
        $(`#${tabType}-count`).text(count);
    }

    // 빈 테이블 렌더링
    function renderEmptyTable(message) {
        const tbody = $('#userTableBody');
        tbody.empty();
        tbody.append(`
            <tr>
                <td colspan="10" class="text-center text-muted">${message}</td>
            </tr>
        `);
    }

    // 사용자 테이블 렌더링
    function renderUserTable(users) {
        const tbody = $('#userTableBody');
        tbody.empty();

        if (users.length === 0) {
            renderEmptyTable('표시할 데이터가 없습니다.');
            return;
        }

        users.forEach(function(user) {
            const isDeleted = user.status === 'DELETED';
            const row = `
                <tr data-user-id="${user.id}" ${isDeleted ? 'class="deleted-user"' : ''}>
                    <td>
                        <input type="checkbox" 
                               name="userIds" 
                               value="${user.id}" 
                               class="userCheckbox"
                               ${isDeleted ? 'disabled' : ''}>
                    </td>
                    <td>${user.id}</td>
                    <td>${user.name}</td>
                    <td><input type="text" class="form-control phone" value="${user.phone}" disabled></td>
                    <td><input type="text" class="form-control address" value="${user.address}" disabled></td>
                    <td>
                        <select class="form-control userType" disabled>
                            <option value="user" ${user.userType === 'user' ? 'selected' : ''}>일반</option>
                            <option value="admin" ${user.userType === 'admin' ? 'selected' : ''}>관리자</option>
                        </select>
                    </td>
                    <td>${user.status}</td>
                    <td>${user.created}</td>
                    <td>${user.lastUpdated}</td>
                    <td>${user.deletedAt || ''}</td>
                </tr>
            `;
            tbody.append(row);
        });

        // 체크박스 이벤트 재바인딩
        bindCheckboxEvents();
    }

    // 체크박스 이벤트 바인딩
    function bindCheckboxEvents() {
        // 전체 선택
        $("#checkAll").off('click').on('click', function() {
            $("input[name=userIds]:not(:disabled)").prop('checked', this.checked);
            updateButtonStates();
        });

        // 개별 체크박스 선택
        $(".userCheckbox").off('change').on('change', function() {
            updateButtonStates();
        });
    }

    // 모든 탭 카운트 업데이트
    function updateTabCounts() {
        // 전체 카운트 조회
        $.get('/user/list/all', function(response) {
            if (response.success) {
                $('#all-count').text(response.users.length);
            }
        });

        // 활성 카운트 조회
        $.get('/user/list/active', function(response) {
            if (response.success) {
                $('#active-count').text(response.users.length);
            }
        });

        // 탈퇴 카운트 조회
        $.get('/user/list/deleted', function(response) {
            if (response.success) {
                $('#deleted-count').text(response.users.length);
            }
        });
    }

    // 로딩 표시/숨김
    function showLoading(show) {
        if (show) {
            $('#loadingSpinner').removeClass('d-none');
            $('#userTableBody').closest('div').addClass('d-none');
        } else {
            $('#loadingSpinner').addClass('d-none');
            $('#userTableBody').closest('div').removeClass('d-none');
        }
    }

    // 편집 모드 취소
    function cancelEditMode() {
        editMode = false;
        editingRows.clear();
        $('#editBtn').text('수정').removeClass('btn-success').addClass('btn-warning');
        $('input[name=userIds]').prop('checked', false);
        $('#checkAll').prop('checked', false).prop('indeterminate', false);
        updateButtonStates();
    }

    // 버튼 상태 업데이트
    function updateButtonStates() {
        const checkedBoxes = $("input[name=userIds]:checked:not(:disabled)");
        const hasChecked = checkedBoxes.length > 0;
        
        $("#editBtn").prop('disabled', !hasChecked);
        $("#deactivateBtn").prop('disabled', !hasChecked || currentTab === 'deleted');
        
        // 전체 선택 체크박스 상태 업데이트
        const totalCheckboxes = $("input[name=userIds]:not(:disabled)").length;
        const checkedCount = checkedBoxes.length;
        
        if (checkedCount === 0) {
            $("#checkAll").prop('indeterminate', false).prop('checked', false);
        } else if (checkedCount === totalCheckboxes) {
            $("#checkAll").prop('indeterminate', false).prop('checked', true);
        } else {
            $("#checkAll").prop('indeterminate', true);
        }
    }

    // 기존 수정, 삭제 기능들...
    // (이전 대화의 수정, 삭제 관련 코드들을 그대로 유지)

    // 수정 모드 토글
    $("#editBtn").click(function() {
        const checkedBoxes = $("input[name=userIds]:checked");
        
        if (!editMode) {
            editMode = true;
            $(this).text('저장').removeClass('btn-warning').addClass('btn-success');
            
            checkedBoxes.each(function() {
                const row = $(this).closest('tr');
                const userId = row.data('user-id');
                editingRows.add(userId);
                
                row.find('.phone, .address, .userType').prop('disabled', false);
            });
        } else {
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
                }
            });
            
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
                    loadUsersByTab(currentTab);
                    updateTabCounts();
                    cancelEditMode();
                }).catch(() => {
                    alert('수정 중 오류가 발생했습니다.');
                });
            } else {
                cancelEditMode();
            }
        }
    });

    // 선택 계정 비활성화
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
                    loadUsersByTab(currentTab);
                    updateTabCounts();
                    cancelEditMode();
                },
                error: function() {
                    alert('삭제 중 오류가 발생했습니다.');
                }
            });
        }
    });
});