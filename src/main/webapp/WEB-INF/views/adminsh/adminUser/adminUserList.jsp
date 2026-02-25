<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="showSearchArea" value="true" scope="request" />
<c:set var="cp" value="${pageContext.request.contextPath}" />

<style>
    .user-link { 
        color: #1e293b;
        font-weight: 600; 
        cursor: pointer; 
        transition: all 0.2s ease;
        padding: 4px 8px;
        border-radius: 4px;
        display: inline-block;
    }
    .user-link:hover { 
        color: #2563eb; 
        background-color: #eff6ff;
        text-decoration: none !important;
    }

    /* 그리드 내 입력 요소 스타일링 */
    .direct-edit-el {
        pointer-events: auto !important; width: 90% !important; height: 32px !important;
        border: 1px solid #e2e8f0 !important; border-radius: 6px !important;
        background-color: #ffffff !important; font-size: 13px !important;
        transition: border-color 0.2s;
    }
    .direct-edit-el:focus { border-color: #3b82f6 !important; outline: none !important; }

    /* 데이터그리드 컨테이너 여백 */
    #dg-container { width: 100%; margin-top: 1rem; }
    .grid-relative-wrapper { position: relative; width: 100%; }
    
    select.direct-edit-el {
	    text-align: center !important;
	    text-align-last: center !important; 
	    appearance: none;                   
	    background-position: right 8px center;
	}
	
	select.direct-edit-el option {
	    text-align: center;
	}
	
	/* 1. 필터 셀렉트 박스 및 검색창 크기 확대 */
    #dg-common-filter-wrapper select, 
    #dg-search-category, 
    #dg-search-input {
        padding-left: 1rem !important;
        padding-right: 2.5rem !important;
    }

    /* 2. '구분', '검색어' 라벨 텍스트 크기 확대 */
    .search-group label, 
    .filter-label,
    div.text-sm.font-bold { 
        margin-bottom: 0.5rem !important;
        display: inline-block;
    }
</style>

<div class="max-w-screen-2xl mx-auto">
    <div class="bg-white p-8 rounded-xl shadow-lg border border-gray-100 dark:bg-gray-800 dark:border-gray-700">
        
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4">
            <div>
                <div class="flex items-center gap-3">
                    <h2 class="text-2xl font-bold text-gray-900 dark:text-white">사용자 관리</h2>
                    <span class="bg-blue-100 text-blue-700 text-xs font-bold px-2.5 py-0.5 rounded-full dark:bg-blue-900 dark:text-blue-300">
                        ${viewType == 'COMPANY' ? '회사' : viewType == 'ADMIN' ? '관리자' : '전체'}
                    </span>
                </div>
                <p class="text-sm text-gray-500 mt-1">시스템 사용자의 권한을 관리하고 가입 승인을 처리할 수 있습니다.</p>
            </div>
            
            <div class="flex flex-wrap items-center gap-2">
                <c:if test="${viewType == 'ADMIN'}">
                    <button type="button" onclick="handleAddAction()" 
                            class="px-4 py-2 text-sm font-semibold text-white bg-blue-600 rounded-lg hover:bg-blue-700 transition active:scale-95 flex items-center">
                        <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
                        신규 관리자 등록
                    </button>
                </c:if>
            </div>
        </div>

        <div class="flex space-x-1 mb-1">
            <a href="/admin/user/list" class="px-5 py-2.5 text-sm font-medium transition-all ${empty viewType ? 'text-blue-600 border-b-2 border-blue-600 bg-blue-50/50' : 'text-gray-500 hover:text-gray-700'}">전체</a>
            <a href="/admin/user/list?viewType=COMPANY" class="px-5 py-2.5 text-sm font-medium transition-all ${viewType == 'COMPANY' ? 'text-blue-600 border-b-2 border-blue-600 bg-blue-50/50' : 'text-gray-500 hover:text-gray-700'}">회사 관리</a>
            <a href="/admin/user/list?viewType=ADMIN" class="px-5 py-2.5 text-sm font-medium transition-all ${viewType == 'ADMIN' ? 'text-blue-600 border-b-2 border-blue-600 bg-blue-50/50' : 'text-gray-500 hover:text-gray-700'}">관리자 관리</a>
            <a href="/admin/user/list?viewType=USER" class="px-5 py-2.5 text-sm font-medium transition-all ${viewType == 'USER' ? 'text-blue-600 border-b-2 border-blue-600 bg-blue-50/50' : 'text-gray-500 hover:text-gray-700'}">일반 사용자</a>
        </div>

        <div class="grid-relative-wrapper">
            <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp">
                <jsp:param name="showSearchArea" value="true" />
                <jsp:param name="showPerPage" value="true" />
            </jsp:include>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/adminsh/adminUser/adminUserApprovModal.jsp" />
<jsp:include page="/WEB-INF/views/adminsh/adminUser/adminUserHistModal.jsp" />

<div id="adminRegModal" tabindex="-1" aria-hidden="true" class="fixed inset-0 z-50 hidden flex items-center justify-center bg-black/50 overflow-y-auto">
    <div class="relative w-full max-w-2xl p-4">
        <div class="relative bg-white rounded-xl border border-gray-200 dark:bg-gray-800 dark:border-gray-700">
            <div class="flex items-center justify-between p-4 border-b">
                <h3 class="text-xl font-bold text-gray-900 dark:text-white" id="modalTitle">신규 관리자 등록</h3>
                <button type="button" onclick="closeAdminRegModal()" class="text-gray-400 hover:text-gray-900 ml-auto p-2">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>
            <div>
                <jsp:include page="/WEB-INF/views/adminsh/adminUser/adminUserForm.jsp" />
            </div>
        </div>
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
        companyPhone: "${u.company_phone != null ? u.company_phone : '-'}",
        bizNumber: "${u.biz_number != null ? u.biz_number : '-'}",
        email: "${u.email != null ? u.email : '-'}", phone: "${u.phone != null ? u.phone : '-'}",
        appStatus: "${u.app_status}", accStatus: "${u.acc_status}",
        regDtime: "${u.reg_dtime}".replace('.0', ''), position: "${u.position != null ? u.position : '-'}",
        address: "${u.address != null ? u.address : '-'}", customsNum: "${u.customs_num != null ? u.customs_num : '-'}"
    }${!st.last ? ',' : ''}
    </c:forEach>
];

// 현재 탭 기준 데이터 필터링
const tabFilteredData = rawData.filter(u => {
    if(!viewType) return true;
    if(viewType === 'COMPANY') return u.userType === 'MASTER';
    if(viewType === 'ADMIN') return u.userType === 'ADMIN';
    if(viewType === 'USER') return (u.userType === 'USER' || u.userType === 'MASTER'); 
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

        // 최초 값 세팅
        this.render(props);
    }

    getElement() {
        return this.el;
    }

    render(props) {
        // 값 갱신
        this.el.value = props.value || '';
    }
}

function makeActionRenderer(btnText, showHistoryBtn = false) {
    return class {
        constructor(props) {
            const container = document.createElement('div');
            container.className = 'flex gap-2 justify-center p-1';
            
            const row = props.grid.getRow(props.rowKey);

            // 1. [회사 관리] 탭일 때의 로직
            if (viewType === 'COMPANY') {
                const isProcessed = (row.appStatus === 'APPROVED' || row.appStatus === 'REJECTED');

                // 승인/반려가 아직 안 된 경우에만 버튼 노출
                if (!isProcessed) {
                    const btnApprove = document.createElement('button');
                    btnApprove.className = 'px-3 py-1 text-xs font-bold text-blue-700 border border-blue-400 rounded-md hover:bg-blue-50';
                    btnApprove.textContent = '승인/반려';
                    btnApprove.addEventListener('click', (e) => {
                        e.preventDefault();
                        e.stopPropagation();
                        openUserModal(row); // 승인 모달 띄우기
                    });
                    container.appendChild(btnApprove);
                }

                // 이력 버튼 (이미 처리됐거나 showHistoryBtn이 true일 때)
                if (isProcessed || showHistoryBtn) {
                    const btnHist = document.createElement('button');
                    btnHist.className = 'px-3 py-1 text-xs font-bold text-gray-600 border border-gray-400 rounded-md hover:bg-gray-50';
                    btnHist.textContent = '이력';
                    btnHist.addEventListener('click', (e) => {
                        e.preventDefault();
                        e.stopPropagation();
                        window.viewUserHistory(row.userId); 
                    });
                    container.appendChild(btnHist);
                }
            } 
            // 2. 그 외 탭 (ADMIN, USER, 전체 등)일 때의 로직
            else {
                const btnSave = document.createElement('button');
                btnSave.className = 'px-3 py-1 text-xs font-bold text-blue-700 border border-blue-400 rounded-md hover:bg-blue-50';
                btnSave.textContent = btnText || '저장'; // 기본값 저장
                
                btnSave.addEventListener('click', (e) => {
                    e.preventDefault();
                    e.stopPropagation();
                    window.handleGridAction(row, 'SAVE'); // 기존 저장 로직 실행
                });
                container.appendChild(btnSave);
            }
            
            this.el = container;
        }
        getElement() { return this.el; }
        render() {}
    };
}

/* [3] DOM 로드 후 그리드 초기화 및 조회 기능 연결 */
document.addEventListener('DOMContentLoaded', () => {

	const modal = document.getElementById('userApprovModal'); // 모달 ID에 맞게 수정
    if (modal) modal.style.display = 'none';
	
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

    const fmt = ({value}) => `<span class="text-ellipsis" title="${value}">${value}</span>`;

    let columns = [{ 
        header: '구분', 
        name: 'userType', 
        align: 'center', 
        width: 80,
        renderer: { type: CustomStatusRenderer, options: { theme: 'accStatus' } }
    }];

    if (viewType === 'COMPANY') {
        // --- [1. 회사 관리] : 업체 승인 중심 ---
        columns.push(
            { header: '회사명', name: 'companyName', align: 'center' },
            { header: '회사연락처', name: 'companyPhone', align: 'center' },
            { header: '사업자번호', name: 'bizNumber', align: 'center' },
            { header: '통관번호', name: 'customsNum', align: 'center' },
            { header: '대표자명', name: 'userName', align: 'center' },
            { header: '아이디', name: 'userId', align: 'center' },
            { header: '승인상태', name: 'appStatus', align: 'center', renderer: { type: CustomStatusRenderer, options: { theme: 'appStatus' } } },
            { 
                header: '가입승인', 
                name: 'manage', 
                align: 'center', 
                width: 180,
                renderer: { 
                	type: makeActionRenderer('승인/반려', true)  // ← options 필요 없음, 직접 전달
                } 
            }
        );
    } else if (viewType === 'ADMIN') {
        // --- [2. 관리자 관리] : 소속 회사 제외 ---
        columns.push(
            { header: '관리자ID', name: 'userId', align: 'center' },
            { header: '관리자명', name: 'userName', align: 'center' },
            { header: '연락처', name: 'phone', align: 'center' },
            { header: '계정상태', name: 'accStatus', align: 'center', renderer: { type: DirectSelectRenderer } },
            { header: '관리', name: 'manage', align: 'center', renderer: { type: makeActionRenderer('저장', null) } }
        );
    } else {
        // --- [3. 일반 사용자] : MASTER + USER 합쳐서 관리 ---
        columns.push(
            { header: '이름', name: 'userName', align: 'center' },
            { header: '아이디', name: 'userId', align: 'center' },
            { header: '연락처', name: 'phone', align: 'center' },
            { header: '승인상태', name: 'appStatus', align: 'center', renderer: { type: CustomStatusRenderer, options: { theme: 'appStatus' } } },
            { header: '계정상태', name: 'accStatus', align: 'center', renderer: { type: DirectSelectRenderer } },
            { header: '관리', name: 'manage', align: 'center', renderer: { type: makeActionRenderer('저장', null) } }
        );
    }

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
    
    const initialPerPage = 10;
    const initialPageData = tabFilteredData.slice(0, initialPerPage);
    window.userGrid.grid.resetData(initialPageData);

    const initialPaginationEl = document.querySelector('.tui-pagination');
    if (initialPaginationEl) {
        initialPaginationEl.style.display = (tabFilteredData.length <= initialPerPage) ? 'none' : 'block';
    }
    
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
    
    if (!viewType || viewType === 'USER') {
        filterOptions.push({
            field: 'userType',
            title: '계정구분',
            options: [
                { text: '대표(MASTER)', value: 'MASTER' },
                { text: '직원(USER)', value: 'USER' }
            ]
        });
    }

    if (viewType !== 'MASTER' && viewType !== 'ADMIN') {
        filterOptions.push({
            field: 'appStatus',
            title: '승인상태',
            options: [
                { text: 'APPROVED', value: 'APPROVED' },
                { text: 'PENDING', value: 'PENDING' },
                { text: 'REJECTED', value: 'REJECTED' }
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
    const typeFilter = document.getElementById('filter-userType')?.value;

    let filtered = [...tabFilteredData];  

    // 계정 상태
    if (accFilter) {
        filtered = filtered.filter(row => row.accStatus === accFilter);
    }

    // 승인 상태
    if (appFilter) {
        filtered = filtered.filter(row => row.appStatus === appFilter);
    }
    
 	// 계정 구분 필터
    if (typeFilter) {
        filtered = filtered.filter(row => row.userType === typeFilter);
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

    const perPage = 10; // 페이지당 10개
    const pageData = filtered.slice(0, perPage);
    
    window.userGrid.grid.resetData(pageData);
    
    const paginationEl = document.querySelector('.tui-pagination');
    if (paginationEl) {
        paginationEl.style.display = (filtered.length <= perPage) ? 'none' : 'block';
    }
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
    
    const filterType = document.getElementById('filter-userType');
    if (filterType) filterType.addEventListener('change', performFilter);
});

/* [4] 액션 핸들러 */
window.handleGridAction = function(rowData, actionType) {
    const { userId, rowKey, appStatus } = rowData;

    if (viewType === 'COMPANY') {
        if (actionType === 'APPROVE') { // 승인 클릭
            if (appStatus === 'APPROVED') { alert('이미 승인된 업체입니다.'); return; }
            if (!confirm(`${userId}님의 가입을 승인하시겠습니까?`)) return;

            fetch('/admin/user/approveCompany', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({ userId })
            }).then(res => res.text()).then(res => {
                if (res === "OK") { alert('승인 완료!'); location.reload(); }
            });
        } 
        else if (actionType === 'REJECT') { // 반려 클릭
            if (appStatus === 'REJECTED') { alert('이미 반려 처리된 업체입니다.'); return; }
            
            const reason = prompt("반려 사유를 입력해주세요.\n(사용자 마이페이지에 노출됩니다)");
            if (reason === null) return; 
            if (!reason.trim()) { alert("반려 사유는 필수입니다."); return; }

            fetch('/admin/user/rejectCompany', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({ userId, rejectReason: reason })
            }).then(res => res.text()).then(res => {
                if (res === "OK") { alert('반려 처리가 완료되었습니다.'); location.reload(); }
            });
        }
    } else {
        // 일반 상태 저장 로직 (기존 유지)
        const accStatus = document.getElementById('select_status_' + rowKey).value;
        fetch('/admin/user/modifyUserStatus', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ userId, accStatus })
        }).then(res => res.text()).then(res => {
            if (res === "OK") alert('상태가 저장되었습니다.');
        });
    }
};

/* list.jsp 하단 <script> 영역 */

function handleAddAction() {
    openAdminRegModal();
}

function openAdminRegModal() {
    const modal = document.getElementById('adminRegModal');
    modal.style.display = 'flex'; // hidden 대신 display 조작
    modal.classList.remove('hidden');
    document.body.style.overflow = 'hidden';
}

function closeAdminRegModal() {
    const modal = document.getElementById('adminRegModal');
    modal.style.display = 'none'; // 다시 숨기기
    modal.classList.add('hidden');
    document.body.style.overflow = 'auto';
    
    // 폼 초기화 (jQuery가 있다면)
    if($('#adminRegForm').length > 0) {
        $('#adminRegForm')[0].reset();
    }
}
</script>