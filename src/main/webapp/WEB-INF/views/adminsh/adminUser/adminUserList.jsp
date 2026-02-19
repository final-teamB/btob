<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="showSearchArea" value="true" scope="request" />
<c:if test="${viewType == 'ADMIN'}">
	<c:set var="showAddBtn" value="true" scope="request" />
</c:if>


<style>
    /* [1] 스타일 */
    .tui-grid-cell-content { padding: 0 !important; }
    .direct-edit-el {
        pointer-events: auto !important; width: 100% !important; height: 100% !important;
        min-height: 38px; padding: 0 12px !important; border: 1px solid transparent !important;
        box-sizing: border-box !important; outline: none !important; transition: all 0.2s;
        cursor: pointer; background-color: transparent !important;
    }
    select.direct-edit-el {
        text-align: center !important; text-align-last: center !important; appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%239ca3af'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
        background-repeat: no-repeat; background-position: right 8px center; background-size: 14px;
    }
    .text-ellipsis { display: block; width: 100%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; padding: 0 8px; }



/* 필터 내 select 박스 스타일 조정 */
#dg-common-filter-wrapper select {
    width: 100% !important;
    height: 40px !important; /* 높이도 검색창과 통일 */
    padding-right: 30px !important; /* 화살표 공간 */
    cursor: pointer;
}

</style>

<div class="my-6 space-y-6">
    <div class="px-5 py-4 pb-0 flex flex-col md:flex-row justify-between items-center">
        <div>
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white">사용자 관리 시스템 (Admin)</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">상태를 변경한 후 반드시 [저장] 버튼을 눌러주세요.</p>
        </div>
    </div>

    <div class="px-5 pt-4">
        <div class="flex space-x-2">
            <a href="/admin/user/list" class="px-4 py-2 text-sm font-medium ${empty viewType ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-500'}">전체</a>
            <a href="/admin/user/list?viewType=COMPANY" class="px-4 py-2 text-sm font-medium ${viewType == 'COMPANY' ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-500'}">회사 관리</a>
            <a href="/admin/user/list?viewType=ADMIN" class="px-4 py-2 text-sm font-medium ${viewType == 'ADMIN' ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-500'}">관리자 관리</a>
            <a href="/admin/user/list?viewType=USER" class="px-4 py-2 text-sm font-medium ${viewType == 'USER' ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-500'}">일반 사용자</a>
        </div>
    </div>

    <div class="px-5" style="margin-top: 0rem !important;">
        <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp" />
    </div>
</div>

<script>
/* [1] 데이터 및 초기 설정 */
const viewType = "${viewType}";
const rawData = [
    <c:forEach var="u" items="${adminUserList}" varStatus="st">
    {
        userId: "${u.user_id}", userName: "${u.user_name}", userType: "${u.user_type}",
        companyName: "${u.company_name != null ? u.company_name : '-'}",
        bizNumber: "${u.biz_number != null ? u.biz_number : '-'}",
        email: "${u.email != null ? u.email : '-'}", phone: "${u.phone != null ? u.phone : '-'}",
        appStatus: "${u.app_status}", accStatus: "${u.acc_status}",
        regDtime: "${u.reg_dtime}", position: "${u.position != null ? u.position : '-'}",
        address: "${u.address != null ? u.address : '-'}", customsNum: "${u.customs_num != null ? u.customs_num : '-'}"
    }${!st.last ? ',' : ''}
    </c:forEach>
];

// 현재 탭 기준 데이터 필터링
const tabFilteredData = rawData.filter(u => {
    if(!viewType) return true;
    if(viewType === 'COMPANY') return u.userType === 'MASTER';
    if(viewType === 'ADMIN') return u.userType === 'ADMIN';
    if(viewType === 'USER') return u.userType === 'USER';
    return true;
});

/* [2] 커스텀 셀 렌더러 */
class DirectSelectRenderer {
    constructor(props) {
        this.el = document.createElement('select');
        this.el.className = 'direct-edit-el';
        this.el.id = 'select_status_' + props.rowKey;
        this.el.addEventListener('mousedown', e => e.stopPropagation());

        const list = [
            {v:'ACTIVE', t:'ACTIVE'}, 
            {v:'SLEEP', t:'SLEEP'}, 
            {v:'STOP', t:'STOP'}
        ];

        list.forEach(i => {
            const o = document.createElement('option');
            o.value = i.v;
            o.textContent = i.t;
            this.el.appendChild(o);
        });

        this.el.addEventListener('change', () => {
            props.grid.setValue(props.rowKey, props.columnInfo.name, this.el.value, false);
        });

        // ★ 최초 값 세팅
        this.render(props);
    }

    getElement() {
        return this.el;
    }

    render(props) {
        // ★ 여기서 값 갱신
        this.el.value = props.value || '';
    }
}


/* [3] DOM 로드 후 그리드 초기화 및 조회 기능 연결 */
document.addEventListener('DOMContentLoaded', () => {

	const searchInput = document.getElementById('dg-search-input');
    if (searchInput) {
        const searchGroupHtml = `
            <div class="search-group">
                <div class="search-input-wrapper">
                    <select id="dg-search-category" class="rounded-lg border border-gray-300 py-2 px-3 text-sm h-[40px] bg-white outline-none focus:border-blue-500">
                        <option value="all">전체</option>
                        <option value="userName">이름</option>
                        <option value="userId">아이디</option>
                        <option value="companyName">소속(회사)</option>
                    </select>
                </div>
            </div>
        `;
        
        searchInput.insertAdjacentHTML('beforebegin', searchGroupHtml);
        
        // 기존 input을 search-input-wrapper 안으로 이동시켜 한 줄 유지
        const wrapper = document.querySelector('.search-input-wrapper');
        wrapper.appendChild(searchInput); 
        
        searchInput.style.width = '250px';
        searchInput.style.height = '40px';
    }

    const fmt = ({value}) => `<span class="text-ellipsis" title="\${value}">\${value}</span>`;
    let columns = [{ header: '구분', name: 'userType', align: 'center', width: 70 }];

    if (viewType === 'COMPANY') {
        columns.push(
            { header: '회사명', name: 'companyName', align: 'left', formatter: fmt },
            { header: '사업자번호', name: 'bizNumber', align: 'center' },
            { header: '대표자명', name: 'userName', align: 'center' },
            { header: '연락처', name: 'phone', align: 'center' }
        );
    } else if (viewType === 'ADMIN') {
        columns.push(
            { header: '관리자ID', name: 'userId', align: 'center' },
            { header: '관리자명', name: 'userName', align: 'center' },
            { header: '연락처', name: 'phone', align: 'center' },
            { header: '등록일', name: 'regDtime', align: 'center' }
        );
    } else {
        columns.push(
            { header: '이름', name: 'userName', align: 'center' },
            { header: '아이디', name: 'userId', align: 'center' },
            { header: '소속', name: 'companyName', align: 'left', formatter: fmt },
            { header: '승인상태', name: 'appStatus', align: 'center' }
        );
    }

    columns.push(
        { header: '계정상태(수정)', name: 'accStatus', align: 'center', renderer: { type: DirectSelectRenderer } },
        { header: '관리', name: 'manage', align: 'center', renderer: { type: CustomActionRenderer, options: { btnText: '저장' } } }
    );

    // 그리드 초기화 (ID: dg-search-input 사용)
    window.userGrid = new DataGrid({
        containerId: 'dg-container',
        searchId: 'dg-search-input',
        btnSearchId: 'dg-btn-search',
        perPageId: 'dg-per-page',
        gridOptions: { scrollX: false, bodyHeight: 'auto' },
        data: tabFilteredData,
        columns: columns,
        pageOptions: { useClient: true, perPage: 10 }
    });
    
    const filterOptions = [
        { 
            field: 'accStatus', 
            title: '계정상태', 
            options: [
                { text: 'ACTIVE', value: 'ACTIVE' },
                { text: 'SLEEP', value: 'SLEEP' },
                { text: 'STOP', value: 'STOP' }
            ] 
        }
    ];

    if (viewType !== 'COMPANY' && viewType !== 'ADMIN') {
        filterOptions.push({
            field: 'appStatus',
            title: '승인상태',
            options: [
                { text: 'APPROVED', value: 'APPROVED' },
                { text: 'PENDING', value: 'PENDING' }
            ]
        });
    }

    window.userGrid.initFilters(filterOptions);

    // 실시간 필터링 
    const performFilter = () => {

    const category = document.getElementById('dg-search-category').value;
    const keyword = document.getElementById('dg-search-input').value.toLowerCase();
    const accFilter = document.getElementById('filter-accStatus')?.value;
    const appFilter = document.getElementById('filter-appStatus')?.value;

    let filtered = [...tabFilteredData];  // ★ 이거 추가

    // 계정 상태
    if (accFilter) {
        filtered = filtered.filter(row => row.accStatus === accFilter);
    }

    // 승인 상태
    if (appFilter) {
        filtered = filtered.filter(row => row.appStatus === appFilter);
    }

    // 검색어
    if (keyword) {
        if (category === 'all') {
            filtered = filtered.filter(row =>
                row.userName?.toLowerCase().includes(keyword) ||
                row.userId?.toLowerCase().includes(keyword) ||
                row.companyName?.toLowerCase().includes(keyword)
            );
        } else {
            filtered = filtered.filter(row =>
                row[category]?.toLowerCase().includes(keyword)
            );
        }
    }

    window.userGrid.grid.resetData(filtered);
};

    
    // 1. 검색어 입력 시 (키보드 칠 때마다)
    document.getElementById('dg-search-input').addEventListener('input', performFilter);
    
    // 2. 검색 카테고리 변경 시
    document.getElementById('dg-search-category').addEventListener('change', performFilter);
    
    // 3. 계정상태/승인상태 필터 변경 시 
    const filterAcc = document.getElementById('filter-accStatus');
    const filterApp = document.getElementById('filter-appStatus');
    
    if (filterAcc) filterAcc.addEventListener('change', performFilter);
    if (filterApp) filterApp.addEventListener('change', performFilter);

    // 조회 버튼 클릭 시에도 동일하게 작동
    document.getElementById('dg-btn-search').addEventListener('click', (e) => {
        e.preventDefault();
        performFilter();
    });
});

/* [4] 액션 핸들러 */
window.handleGridAction = function(rowData) {
    const rowKey = rowData.rowKey;
    const userId = rowData.userId; 

    // 렌더러에서 생성한 select 엘리먼트 참조
    const statusEl = document.getElementById('select_status_' + rowKey);

    if (!statusEl) return;

    const currentCode = statusEl.value; // 선택된 상태 값 (ACTIVE, SLEEP, STOP)

    // 중복 클릭 방지용 버튼 비활성화
    const saveBtn = document.querySelector(`[data-row-key="${rowKey}"] .custom-action-btn`);
    if(saveBtn) saveBtn.disabled = true;

    // 서버로 상태 변경 요청 전송
    fetch('/admin/user/modifyUserStatus', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({
            userId: userId,
            accStatus: currentCode
        })
    })
    .then(res => res.text())
    .then(res => {
        if (res === "OK") {
            alert('성공적으로 저장되었습니다.');
            
            // 1. 원본 데이터 배열(tabFilteredData)의 값 업데이트
            const targetRow = tabFilteredData.find(item => item.userId == userId);
            if (targetRow) {
                targetRow.accStatus = currentCode;
            }
            
            // 2. 그리드 내부 행 데이터 실제 값 업데이트 (UI 동기화)
            window.userGrid.grid.setValue(rowKey, 'accStatus', currentCode);
            
        } else {
            alert('실패: ' + res);
        }
    })
    .catch(err => {
        console.error('Error:', err);
        alert('통신 중 오류가 발생했습니다.');
    })
    .finally(() => {
        // 처리 완료 후 버튼 다시 활성화
        if(saveBtn) saveBtn.disabled = false;
    });
};

function handleAddAction() {
    location.href = '/admin/user/register';
}
</script>