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
        const el = document.createElement('select');
        el.className = 'direct-edit-el';
        // 이 부분이 있어야 handleGridAction에서 찾을 수 있습니다.
        el.id = 'select_status_' + props.rowKey; 
        el.addEventListener('mousedown', e => e.stopPropagation());
        
        const rowData = props.grid.getRow(props.rowKey);
        // 기본 계정 상태 리스트
        const list = [
            {v:'ACTIVE', t:'ACTIVE'}, 
            {v:'SLEEP', t:'SLEEP'}, 
            {v:'STOP', t:'STOP'}
        ];
        
        let allowedStatus = list;
        
        allowedStatus.forEach(i => {
            const o = document.createElement('option');
            o.value = i.v; 
            o.textContent = i.t;
            if (i.v === props.value) o.selected = true;
            el.appendChild(o);
        });

        // 값이 바뀌면 그리드 데이터에 즉시 반영 (저장 버튼 누르기 전 상태 유지용)
        el.addEventListener('change', () => {
            props.grid.setValue(props.rowKey, props.columnInfo.name, el.value, false);
        });

        this.el = el;
    }
    getElement() { return this.el; }
}

/* [3] DOM 로드 후 그리드 초기화 및 조회 기능 연결 */
document.addEventListener('DOMContentLoaded', () => {
    // 필터 영역이 보이지 않도록 확실히 숨김 (요청사항 반영)
    const filterWrapper = document.getElementById('dg-common-filter-wrapper');
    if (filterWrapper) filterWrapper.classList.add('hidden');

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
        pageOptions: { useClient: true, perPage: 15 }
    });

    // [중요] 조회 버튼 클릭 시 키워드 필터링만 수행 (FAQ 방식)
    document.getElementById('dg-btn-search').addEventListener('click', () => {
        const keyword = document.getElementById('dg-search-input').value.toLowerCase();

        const filtered = tabFilteredData.filter(item => {
            return !keyword || 
                   item.userName.toLowerCase().includes(keyword) || 
                   item.userId.toLowerCase().includes(keyword) ||
                   item.companyName.toLowerCase().includes(keyword);
        });
        window.userGrid.grid.resetData(filtered);
    });

    // 엔터키 지원
    document.getElementById('dg-search-input').addEventListener('keydown', (e) => {
        if(e.key === 'Enter') {
            e.preventDefault();
            document.getElementById('dg-btn-search').click();
        }
    });
});

/* [4] 액션 핸들러 */
window.handleGridAction = function(rowData) {
    const rowKey = rowData.rowKey;
    const userId = rowData.userId; 

    const statusEl = document.getElementById('select_status_' + rowKey);

    if (!statusEl) return;

    const currentCode = statusEl.value;
    const currentText = statusEl.options[statusEl.selectedIndex].text;

    const saveBtn = document.querySelector(`[data-row-key="${rowKey}"] .custom-action-btn`);
    if(saveBtn) saveBtn.disabled = true;

    fetch('/admin/user/modifyUserStatus', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, // 서버가 @RequestParam을 쓰면 이 방식이 안전
        body: new URLSearchParams({
            userId: userId,
            accStatus: currentCode
        })
    })
    .then(res => {
        return res.text(); 
    })
    .then(res => {
        if (res === "OK") {
            alert('성공적으로 저장되었습니다.');
            
            const targetRow = tabFilteredData.find(item => item.userId == userId);
            if (targetRow) {
                targetRow.accStatus = currentCode;
            }
            window.userGrid.grid.setRow(rowKey, { ...window.userGrid.grid.getRow(rowKey), accStatus: newStatus });
        } else {
            alert('실패: ' + res);
        }
    });
};

function handleAddAction() {
    location.href = '/admin/user/register';
}
</script>