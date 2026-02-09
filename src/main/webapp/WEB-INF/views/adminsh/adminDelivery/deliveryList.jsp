<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
	/* 그리드 셀 내부 여백 제거 */
	.tui-grid-cell-content {
	    padding: 0 !important;
	}
	
	/* 1. 기본 상태: 수정 가능한 곳임을 암시하는 연한 회색 배경 + 연필 아이콘 */
	.direct-edit-el {
	    pointer-events: auto !important;
	    width: 100% !important;
	    height: 100% !important;
	    min-height: 38px;
	    padding: 0 12px !important;
	    border: 1px solid transparent !important; /* 평소엔 투명 테두리 */
	    box-sizing: border-box !important;
	    outline: none !important;
	    transition: all 0.2s;
	    cursor: text;
	}
	
	/* 2. 배송상태(Select) 전용 스타일 */
	select.direct-edit-el {
	    text-align: center !important;
	    text-align-last: center !important;
	    cursor: pointer;
	    appearance: none;
	    /* 화살표 아이콘 */
	    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%239ca3af'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
	    background-repeat: no-repeat;
	    background-position: right 8px center;
	    background-size: 14px;
	}
	
	/* 3. 운송장번호(Input) 전용 스타일: 연필 아이콘 추가 */
	input.direct-edit-el {
	    text-align: left !important;
	    /* 오른쪽 끝에 아주 작게 연필 아이콘을 넣어서 '수정가능' 표시 */
	    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%23d1d5db'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z'%3E%3C/path%3E%3C/svg%3E");
	    background-repeat: no-repeat;
	    background-position: right 8px center;
	    background-size: 12px;
	}
	
	/* 4. 마우스 올렸을 때(hover): 테두리를 살짝 보여줌 */
	.direct-edit-el:hover {
	    background-color: #f3f4f6 !important;
	    border: 1px solid #d1d5db !important;
	}
	
	/* 5. 클릭(focus): 확실하게 "나 지금 고치는 중!" 표시 */
	.direct-edit-el:focus {
	    background-color: #fff !important;
	    border: 1px solid #64748b !important; /* 진한 회색 테두리 */
	    box-shadow: 0 0 0 2px rgba(100, 116, 139, 0.1) !important;
	    background-image: none !important; /* 입력 중엔 아이콘 숨김 */
	}
	
	/* 그리드 바디의 데이터 셀에 마우스 올리면 포인터로 변경 (상세 이동 가능 암시) */
	.tui-grid-body-area .tui-grid-cell {
	    cursor: pointer;
	}
	
	/* 하지만 직접 수정하는 영역(Input, Select)과 관리 버튼 위에서는 기본 커서 유지 */
	.tui-grid-body-area .tui-grid-cell .direct-edit-el,
	.tui-grid-body-area .tui-grid-cell .custom-action-btn {
	    cursor: auto;
	}
</style>

<div class="mx-4 my-6 space-y-6">
	<div class="px-5 py-4 pb-0 flex flex-col md:flex-row justify-between items-center">
		<div>
			<h1 class="text-2xl font-bold text-gray-900 dark:text-white">배송 관리 시스템 (Admin)</h1>
			<p class="text-sm text-gray-500 dark:text-gray-400 mt-1">배송 상태와 운송장을 즉시 수정하고 저장할 수 있습니다.</p>
		</div>
	</div>

	<c:set var="showSearchArea" value="true" scope="request" />
	<c:set var="showPerPage" value="true" scope="request" />
	<c:set var="showAddBtn" value="false" scope="request" />
	<jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp" />
</div>

<script>
/* 1. 커스텀 렌더러 정의 */
class DirectInputRenderer {
    constructor(props) {
        const el = document.createElement('input');
        el.type = 'text'; el.className = 'direct-edit-el';
        el.value = props.value || '';
        ['mousedown','click','mouseup'].forEach(e => el.addEventListener(e, ev => ev.stopPropagation()));
        el.addEventListener('input', () => props.grid.setValue(props.rowKey, props.columnInfo.name, el.value, false));
        this.el = el;
    }
    getElement() { return this.el; }
}

class DirectSelectRenderer {
    constructor(props) {
        const el = document.createElement('select');
        el.className = 'direct-edit-el';
        el.addEventListener('mousedown', e => e.stopPropagation());
        const list = [
            {v:'READY', t:'상품준비중'}, {v:'L_SHIPPING', t:'국제운송중'}, {v:'L_WH', t:'보세창고입고'},
            {v:'IN_CUSTOMS', t:'통관진행중'}, {v:'C_DONE', t:'통관완료'},
            {v:'D_SHIPPING', t:'국내배송중'}, {v:'COMPLETE', t:'배송완료'}
        ];
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

/* 2. 데이터 바인딩 */
let deliveryGrid;
const gridData = [
    <c:forEach var="item" items="${deliveryList}" varStatus="st">
    {
        deliveryId: "${item.deliveryId}",
        regDtime: "${item.regDtime}", 
        orderId: "${item.orderId}",
        statusDisplay: '<strong>${item.statusName}</strong><br><small>(${item.deliveryStatus})</small>',
        deliveryStatus: "${item.deliveryStatus}",
        trackingNo: "${item.trackingNo}"
    }${!st.last ? ',' : ''}
    </c:forEach>
];

document.addEventListener('DOMContentLoaded', () => {
    // [A] 상단 필터 설정
    const filterWrapper = document.getElementById('dg-common-filter-wrapper');
    const filterSelect = document.getElementById('dg-common-filter');
    
    if (filterWrapper && filterSelect) {
        filterWrapper.classList.remove('hidden');
        filterWrapper.classList.add('flex');
        filterWrapper.querySelector('label').textContent = '배송상태';
        
        const enumList = [
        	{v:'READY', t:'상품준비중'}, {v:'L_SHIPPING', t:'국제운송중'}, {v:'L_WH', t:'보세창고입고'},
            {v:'IN_CUSTOMS', t:'통관진행중'}, {v:'C_DONE', t:'통관완료'},
            {v:'D_SHIPPING', t:'국내배송중'}, {v:'COMPLETE', t:'배송완료'}
        ];
        filterSelect.innerHTML = '<option value="">전체 상태</option>';
        enumList.forEach(s => {
            const opt = document.createElement('option');
            opt.value = s.v; opt.textContent = s.t;
            filterSelect.appendChild(opt);
        });

        const dateHtml = `<div class="flex flex-col gap-1.5 ml-4"><label class="text-sm font-bold text-gray-700 dark:text-white">주문일시</label><div class="flex items-center gap-2"><input type="date" id="searchStartDate" class="rounded-lg border border-gray-300 py-2 px-3 text-sm h-[40px]"><span class="dark:text-white">~</span><input type="date" id="searchEndDate" class="rounded-lg border border-gray-300 py-2 px-3 text-sm h-[40px]"></div></div>`;
        document.getElementById('dg-search-input').parentElement.insertAdjacentHTML('beforebegin', dateHtml);
    }

    // [B] 그리드 초기화 (정렬 옵션 및 페이징)
    deliveryGrid = new DataGrid({
        containerId: 'dg-container',
        searchId: 'dg-search-input',
        btnSearchId: 'dg-btn-search',
        perPageId: 'dg-per-page',
        data: gridData,
        columns: [
            { header:'주문번호', name:'orderId', width:130, align:'center' },
            { header:'주문일시', name:'regDtime', width:160, align:'center' },
            { header:'현재 상태', name:'statusDisplay', width:150, align:'center' },
            { header:'배송상태(수정)', name:'deliveryStatus', width:150, align:'center', renderer:{ type: DirectSelectRenderer } },
            { header:'운송장번호', name:'trackingNo', align:'left', renderer:{ type: DirectInputRenderer } },
            {
                header:'관리', name:'manage', width:90, align:'center',
                renderer:{ type: CustomActionRenderer, options:{ btnText:'저장' } }
            }
        ],
        pageOptions: { useClient: true, perPage: 10 }
    });

    // [C] 조회 버튼 로직
    document.getElementById('dg-btn-search').addEventListener('click', () => {
        const statusVal = document.getElementById('dg-common-filter').value;
        const startDate = document.getElementById('searchStartDate').value;
        const endDate = document.getElementById('searchEndDate').value;
        const keyword = document.getElementById('dg-search-input').value.toLowerCase();

        const filtered = gridData.filter(item => {
            const itemDate = item.regDtime.substring(0, 10); 
            const matchDate = (!startDate || itemDate >= startDate) && (!endDate || itemDate <= endDate);
            const matchStatus = !statusVal || item.deliveryStatus === statusVal;
            const matchKey = !keyword || item.orderId.includes(keyword) || item.trackingNo.includes(keyword);
            return matchDate && matchStatus && matchKey;
        });
        deliveryGrid.grid.resetData(filtered);
    });
    
 // [D] 행 클릭 시 상세 페이지 이동
    deliveryGrid.grid.on('click', (ev) => {
        // 클릭된 대상이 '관리(save)' 버튼이나 'input/select'인 경우는 제외하고 행 이동
        if (ev.columnName !== 'manage' && ev.columnName !== 'deliveryStatus' && ev.columnName !== 'trackingNo') {
            const rowData = deliveryGrid.grid.getRow(ev.rowKey);
            if (rowData && rowData.deliveryId) {
                location.href = '/admin/delivery/detail/' + rowData.deliveryId;
            }
        }
    });
});

/* 저장 처리 */
window.handleGridAction = function(rowData) {
    const rowKey = rowData.rowKey;
    
    const currentCode = deliveryGrid.grid.getValue(rowKey, 'deliveryStatus'); 
    const trackingNo = deliveryGrid.grid.getValue(rowKey, 'trackingNo');
    const deliveryId = deliveryGrid.grid.getValue(rowKey, 'deliveryId');

    const statusMap = {
        'READY': '상품준비중',
        'L_SHIPPING': '국제운송중',
        'L_WH': '보세창고입고',
        'IN_CUSTOMS': '통관진행중',
        'C_DONE': '통관완료',
        'D_SHIPPING': '국내배송중',
        'COMPLETE': '배송완료'
    };

    if (!deliveryId) return;
    
    // 유효성 체크
    if (currentCode !== 'READY' && !trackingNo) {
        if(!confirm('운송장 번호가 없습니다. 이대로 저장할까요?')) return;
    }

    const saveBtn = document.querySelector(`[data-row-key="${rowKey}"] .custom-action-btn`);
    if(saveBtn) { 
        saveBtn.innerText = '처리중'; 
        saveBtn.disabled = true; 
    }

    fetch('/admin/delivery/deliveryUpdate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            deliveryId: deliveryId,
            deliveryStatus: currentCode,
            trackingNo: trackingNo
        })
    })
    .then(res => res.json())
    .then(res => {
        if (res.success) {
            alert('저장되었습니다.');

            // statusMap에서 한글 이름, 없으면 코드
            const statusKor = statusMap[currentCode] || currentCode;
            
            // 현재 상태(statusDisplay) 컬럼을 새로고침 없이 강제 업데이트
            const newStatusHtml = '<strong>' + statusKor + '</strong><br><small>(' + currentCode + ')</small>';
            
            deliveryGrid.grid.setValue(rowKey, 'statusDisplay', newStatusHtml);
            
        } else {
            alert('실패: ' + res.message);
        }
    })
    .catch(err => {
        console.error('Update Error:', err);
        alert('통신 오류가 발생했습니다.');
    })
    .finally(() => {
        if(saveBtn) { 
            saveBtn.innerText = '저장'; 
            saveBtn.disabled = false; 
        }
    });
};
</script>