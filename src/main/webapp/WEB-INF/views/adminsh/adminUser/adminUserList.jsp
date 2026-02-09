<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<c:set var="showSearchArea" value="true" scope="request" />
<c:set var="showPerPage" value="true" scope="request" />
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

    <div class="px-5">
        <div class="flex space-x-2">
            <a href="/admin/user/list" class="px-4 py-2 text-sm font-medium ${empty viewType ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-500'}">전체</a>
            <a href="/admin/user/list?viewType=COMPANY" class="px-4 py-2 text-sm font-medium ${viewType == 'COMPANY' ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-500'}">회사 관리</a>
            <a href="/admin/user/list?viewType=ADMIN" class="px-4 py-2 text-sm font-medium ${viewType == 'ADMIN' ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-500'}">관리자 관리</a>
            <a href="/admin/user/list?viewType=USER" class="px-4 py-2 text-sm font-medium ${viewType == 'USER' ? 'text-blue-600 border-b-2 border-blue-600' : 'text-gray-500'}">일반 사용자</a>
        </div>
    </div>

    <div class="px-5">
        <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp" />
    </div>
</div>

<script>
/* [2] 데이터 그리드 설정 */
const gridData = [
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

class DirectSelectRenderer {
    constructor(props) {
        const el = document.createElement('select');
        el.className = 'direct-edit-el';
        el.addEventListener('mousedown', e => e.stopPropagation());
        const list = [{v:'ACTIVE', t:'정상'}, {v:'SLEEP', t:'휴면'}, {v:'STOP', t:'정지'}];
        list.forEach(i => {
            const o = document.createElement('option');
            o.value = i.v; o.textContent = i.t;
            if (i.v === props.value) o.selected = true;
            el.appendChild(o);
        });
        el.addEventListener('change', () => props.grid.setValue(props.rowKey, props.columnInfo.name, el.value, false));
        this.el = el;
    }
    getElement() { return this.el; }
}

document.addEventListener('DOMContentLoaded', () => {
    const viewType = "${viewType}";
    let columns = [];
    const fmt = ({value}) => `<span class="text-ellipsis" title="\${value}">\${value}</span>`;

    if (viewType === 'COMPANY') {
        columns = [
            { header: '구분', name: 'userType', align: 'center', width: 70 },
            { header: '회사명', name: 'companyName', align: 'left', formatter: fmt },
            { header: '사업자번호', name: 'bizNumber', align: 'center' },
            { header: '대표자명', name: 'userName', align: 'center' },
            { header: '연락처', name: 'phone', align: 'center' },
            { header: '주소', name: 'address', align: 'left', formatter: fmt },
            { header: '통관번호', name: 'customsNum', align: 'center' }
        ];
    } else if (viewType === 'ADMIN') {
        columns = [
            { header: '구분', name: 'userType', align: 'center', width: 70 },
            { header: '관리자ID', name: 'userId', align: 'center' },
            { header: '관리자명', name: 'userName', align: 'center' },
            { header: '연락처', name: 'phone', align: 'center' },
            { header: '등록일', name: 'regDtime', align: 'center' }
        ];
    } else if (viewType === 'USER') {
        columns = [
            { header: '구분', name: 'userType', align: 'center', width: 70 },
            { header: '이름', name: 'userName', align: 'center' },
            { header: '아이디', name: 'userId', align: 'center' },
            { header: '소속회사', name: 'companyName', align: 'left', formatter: fmt },
            { header: '연락처', name: 'phone', align: 'center' },
            { header: '승인상태', name: 'appStatus', align: 'center' }
        ];
    } else {
        columns = [
            { header: '구분', name: 'userType', align: 'center', width: 70 },
            { header: '이름', name: 'userName', align: 'center' },
            { header: '아이디', name: 'userId', align: 'center' },
            { header: '소속', name: 'companyName', align: 'left', formatter: fmt },
            { header: '승인상태', name: 'appStatus', align: 'center' }
        ];
    }

    columns.push(
        { header: '계정상태(수정)', name: 'accStatus', align: 'center', renderer: { type: DirectSelectRenderer } },
        { header: '관리', name: 'manage', align: 'center', renderer: { type: CustomActionRenderer, options: { btnText: '저장' } } }
    );

    window.userGrid = new DataGrid({
        containerId: 'dg-container',
        gridOptions: { scrollX: false, bodyHeight: 'auto' }, // <--- 오른쪽 빈공간 없이 꽉 채우기
        data: gridData.filter(u => {
            if(!viewType) return true;
            if(viewType === 'COMPANY') return u.userType === 'MASTER';
            if(viewType === 'ADMIN') return u.userType === 'ADMIN';
            if(viewType === 'USER') return u.userType === 'USER';
            return true;
        }),
        columns: columns,
        pageOptions: { useClient: true, perPage: 15 }
    });
});

window.handleGridAction = function(rowData) {
    const userId = window.userGrid.grid.getValue(rowData.rowKey, 'userId');
    const newStatus = window.userGrid.grid.getValue(rowData.rowKey, 'accStatus');
    if(!confirm("변경하시겠습니까?")) return;
    $.post("/admin/user/modifyUserStatus", { userId: userId, accStatus: newStatus }, function(res) {
        if(res === "OK") { alert("저장 완료"); location.reload(); }
        else alert("저장 실패");
    });
};

//신규 등록 버튼 연동
function handleAddAction() {
    location.href = '/admin/user/register';
}
</script>