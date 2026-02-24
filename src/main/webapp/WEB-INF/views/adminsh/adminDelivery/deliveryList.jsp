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
    border: 1px solid transparent !important;
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
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%239ca3af'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
    background-repeat: no-repeat;
    background-position: right 8px center;
    background-size: 14px;
}

/* 3. 운송장번호(Input) 전용 스타일: 연필 아이콘 추가 */
input.direct-edit-el {
    text-align: left !important;
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
    border: 1px solid #64748b !important;
    box-shadow: 0 0 0 2px rgba(100, 116, 139, 0.1) !important;
    background-image: none !important;
}

/* 그리드 바디의 데이터 셀에 마우스 올리면 포인터로 변경 */
.tui-grid-body-area .tui-grid-cell {
    cursor: pointer;
}

/* 직접 수정 영역과 관리 버튼 위에서는 기본 커서 유지 */
.tui-grid-body-area .tui-grid-cell .direct-edit-el,
.tui-grid-body-area .tui-grid-cell .custom-action-btn {
    cursor: auto;
}

/* [핵심] 현재 상태 열의 두 줄 간격 최소화 */

/* 1. 본문 셀 내부 컨텐츠의 줄 간격 조절 */
.tui-grid-body-area .tui-grid-cell-content {
    height: 100% !important;
    display: flex !important;
    flex-direction: column !important;
    justify-content: center !important;
    align-items: center !important;
    /* 줄 간격을 평소보다 좁게(1.0) 설정하여 두 줄 사이 공백 제거 */
    line-height: 1.0 !important; 
    padding: 0 !important;
}

/* 2. 상단 텍스트(strong)와 하단 텍스트(small) 사이 간격 미세 조정 */
.tui-grid-body-area .tui-grid-cell-content strong {
    display: block;
    margin-bottom: 2px !important; /* 위아래 글자 사이의 간격을 2px로 제한 */
}

.tui-grid-body-area .tui-grid-cell-content small {
    display: block;
    font-size: 11px !important;
    color: #94a3b8 !important; /* 약간 연한 회색으로 처리하여 가독성 향상 */
    margin-top: 0 !important;
}

/* 3. 행 높이 고정 (이미지 상 어긋남 방지용) */
.tui-grid-body-area .tui-grid-cell {
    height: 55px !important; 
    box-sizing: border-box !important;
}

/* 1. 본문 셀 컨텐츠 설정: 줄 간격을 더 타이트하게 조정 */
.tui-grid-body-area .tui-grid-cell-content {
    height: 100% !important;
    display: flex !important;
    flex-direction: column !important;
    justify-content: center !important;
    align-items: center !important;
    line-height: 1.0 !important; /* 💡 기존 0.9에서 1.0 정도로 살짝 조정 (필요시) */
    padding: 0 !important;
}

/* 2. 위쪽 글자(strong) 스타일 */
.tui-grid-body-area .tui-grid-cell-content strong {
    display: block !important;
    margin: 0 !important;
    padding: 0 !important;
    font-weight: 700 !important;
}

/* 3. 아래쪽 글자(small) 스타일: 간격 줄이기의 핵심 */
.tui-grid-body-area .tui-grid-cell-content small {
    display: block !important;
    /* 💡 마이너스 마진 값을 더 크게 주어 위로 바짝 붙입니다. */
    margin-top: -6px !important; 
    font-size: 11px !important;
    color: #64748b !important;
}
</style>

<div class="mx-4 my-6 space-y-6">
<div class="px-5 py-4 pb-0 flex flex-col md:flex-row justify-between items-center">
<div>
<h1 class="text-2xl font-bold text-gray-900 dark:text-white">배송 관리 시스템 (Admin)</h1>
<p class="text-sm text-gray-500 dark:text-gray-400 mt-1">모든 페이지에서 배송 상태와 운송장을 즉시 수정하고 저장할 수 있습니다.</p>
</div>
</div>

<c:set var="showSearchArea" value="true" scope="request" />
<c:set var="showPerPage" value="true" scope="request" />
<c:set var="showAddBtn" value="false" scope="request" />
<jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp" />
</div>

<script>
class DirectInputRenderer {
    constructor(props) {
        const el = document.createElement('input');
        el.type = 'text'; 
        el.className = 'direct-edit-el';
        ['mousedown','click','mouseup'].forEach(e => el.addEventListener(e, ev => ev.stopPropagation()));
        this.el = el;
        this.render(props);
    }
    render(props) {
        const rowData = props.grid.getRow(props.rowKey);
        if (rowData && rowData.deliveryId) {
            // ✅ rowKey 대신 deliveryId로 id 생성
            this.el.id = 'input_tracking_' + rowData.deliveryId;
        }
        this.el.value = (props.value !== undefined && props.value !== null) ? props.value : '';
    }
    refresh(props) { this.render(props); return true; }
    getElement() { return this.el; }
}

class DirectSelectRenderer {
    constructor(props) {
        const el = document.createElement('select');
        el.className = 'direct-edit-el';
        el.addEventListener('mousedown', e => e.stopPropagation());
        this.el = el;
        this.render(props);
    }
    render(props) {
        this.el.innerHTML = '';
        const rowData = props.grid.getRow(props.rowKey);
        if (!rowData) return;

        // ✅ rowKey 대신 deliveryId로 id 생성
        this.el.id = 'select_status_' + rowData.deliveryId;

        const orderStatus = String(rowData.orderStatus || '').toLowerCase().trim();
        const currentValue = (props.value !== undefined && props.value !== null) ? props.value : rowData.deliveryStatus;
        
        const list = [
            {v:'dv001', t:'상품준비중'}, {v:'dv002', t:'국제운송중'}, {v:'dv003', t:'보세창고입고'},
            {v:'dv004', t:'통관진행중'}, {v:'dv005', t:'통관완료'}, {v:'dv006', t:'국내배송중'}, {v:'dv007', t:'배송완료'}
        ];

        let allowedStatus = list;
        if (orderStatus === 'pm004') allowedStatus = list.filter(s => s.v === 'dv006' || s.v === 'dv007');
        else if (orderStatus === 'pm002') allowedStatus = list.filter(s => ['dv001','dv002','dv003','dv004','dv005'].includes(s.v));

        allowedStatus.forEach(i => {
            const o = document.createElement('option');
            o.value = i.v; o.textContent = i.t;
            if (i.v === currentValue) o.selected = true;
            this.el.appendChild(o);
        });
    }
    refresh(props) { this.render(props); return true; }
    getElement() { return this.el; }
}

let deliveryGrid;
let allOriginalData = []; 

<c:forEach var="item" items="${deliveryList}">
allOriginalData.push({
    deliveryId: "${item.deliveryId}",
    regDtime: "${item.regDtime}".replace('T',' '),
    orderId: "${item.orderId}",
    orderStatus: "${item.orderStatus}",
    statusDisplay: '<strong>${item.statusName}</strong><br><small>(${item.deliveryStatus})</small>',
    deliveryStatus: "${item.deliveryStatus}",
    trackingNo: "${item.trackingNo}"
});
</c:forEach>

document.addEventListener('DOMContentLoaded', () => {
    // [A] 상단 필터 설정 (전역 데이터 사용)
    const filterWrapper = document.getElementById('dg-common-filter-wrapper');
    const filterSelect = document.getElementById('dg-common-filter');
    
    if (filterWrapper && filterSelect) {
        filterWrapper.classList.remove('hidden');
        filterWrapper.classList.add('flex');
        filterWrapper.querySelector('label').textContent = '배송상태';
        
        const enumList = [
            {v:'dv001', t:'상품준비중'}, {v:'dv002', t:'국제운송중'}, {v:'dv003', t:'보세창고입고'},
            {v:'dv004', t:'통관진행중'}, {v:'dv005', t:'통관완료'},
            {v:'dv006', t:'국내배송중'}, {v:'dv007', t:'배송완료'}
        ];
        filterSelect.innerHTML = '<option value="">전체 상태</option>';
        enumList.forEach(s => {
            const opt = document.createElement('option');
            opt.value = s.v; opt.textContent = s.t;
            filterSelect.appendChild(opt);
        });

        const dateHtml = `<div class="flex flex-col gap-1.5 ml-4">
            <label class="text-sm font-bold text-gray-700 dark:text-white">주문일시</label>
            <div class="flex items-center gap-2">
                <input type="date" id="searchStartDate" class="rounded-lg border border-gray-300 py-2 px-3 text-sm h-[40px]">
                <span class="dark:text-white">~</span>
                <input type="date" id="searchEndDate" class="rounded-lg border border-gray-300 py-2 px-3 text-sm h-[40px]">
            </div>
        </div>`;
        document.getElementById('dg-search-input').parentElement.insertAdjacentHTML('beforebegin', dateHtml);
        
        ['searchStartDate', 'searchEndDate'].forEach(id => {
            const dateInput = document.getElementById(id);
            if (dateInput) {
                dateInput.addEventListener('change', () => searchAllPages());
            }
        });
        
        filterSelect.addEventListener('change', () => searchAllPages());
    }
    
    // 검색어 입력 실시간 검색
    const searchInput = document.getElementById('dg-search-input');
    if (searchInput) {
        let searchTimeout;
        searchInput.addEventListener('input', () => {
            clearTimeout(searchTimeout);
            setTimeout(() => {
                if (deliveryGrid && deliveryGrid.grid) {
                    deliveryGrid.grid.refreshLayout();
                }
            }, 300);
        });
    }

    // 🔧 핵심: 모든 페이지에서 작동하는 검색 함수
    window.searchAllPages = function() {
        const statusVal = document.getElementById('dg-common-filter')?.value || '';
        const startDate = document.getElementById('searchStartDate')?.value || '';
        const endDate = document.getElementById('searchEndDate')?.value || '';
        const keyword = (document.getElementById('dg-search-input')?.value || '').toLowerCase();

        const filtered = allOriginalData.filter(item => {
            const itemDate = item.regDtime.substring(0, 10);
            const matchDate = (!startDate || itemDate >= startDate) && (!endDate || itemDate <= endDate);
            const matchStatus = !statusVal || item.deliveryStatus === statusVal;
            
            const keywordTrim = keyword.trim();
            const matchKey = !keywordTrim || 
                             (item.orderId && item.orderId.toLowerCase().includes(keywordTrim)) || 
                             (item.trackingNo && item.trackingNo.trim().toLowerCase().includes(keywordTrim));
            
            return matchDate && matchStatus && matchKey;
        });

        clearAllInputSelects();
        
        const perPage = deliveryGrid?.perPage || 10;
        if (deliveryGrid && deliveryGrid.grid) {
            deliveryGrid.filteredData = filtered;
            deliveryGrid.currentPage = 1;
            deliveryGrid.grid.resetData(filtered);
            
            // 페이징 보이기/숨기기
            const paginationEl = document.querySelector('.tui-pagination');
            if (paginationEl) {
                paginationEl.style.display = (filtered.length <= perPage) ? 'none' : 'block';
            }
        }
    };

    // [B] 그리드 초기화
    deliveryGrid = new DataGrid({
        containerId: 'dg-container',
        searchId: 'dg-search-input',
        btnSearchId: 'dg-btn-search',
        perPageId: 'dg-per-page',
        data: allOriginalData, // 초기 데이터도 전역 데이터 사용
        columns: [
            { header:'주문번호', name:'orderId', width:130, align:'center' },
            { header:'주문일시', name:'regDtime', width:160, align:'center' },
            {
                header: '주문상태',
                name: 'orderStatus',
                width: 120,
                align: 'center',
                formatter: ({ value }) => {
                	const map = {
                            pm001: '1차결제요청<br><span style="display:inline-block; margin-top:4px; font-size: 11px; color: #666;">(pm001)</span>',
                            pm002: '1차결제완료<br><span style="display:inline-block; margin-top:4px; font-size: 11px; color: #666;">(pm002)</span>',
                            pm003: '2차결제요청<br><span style="display:inline-block; margin-top:4px; font-size: 11px; color: #666;">(pm003)</span>',
                            pm004: '2차결제완료<br><span style="display:inline-block; margin-top:4px; font-size: 11px; color: #666;">(pm004)</span>'
                        }
                    return map[value] || value;
                }
            },
            { header:'현재 상태', name:'statusDisplay', width:150, align:'center' },
            { header:'배송상태(수정)', name:'deliveryStatus', width:150, align:'center', renderer:{ type: DirectSelectRenderer } },
            { header:'운송장번호', name:'trackingNo', align:'left', renderer:{ type: DirectInputRenderer } },
            {
                header:'관리', name:'manage', width:90, align:'center',
                renderer:{ type: CustomActionRenderer, options:{ btnText:'저장' } }
            }
        ],
        scrollY: false,
    	bodyHeight: 'auto',
    	rowHeight: 60,         
        columnOptions: {
            resizable: true
        },
        pageOptions: { useClient: true, perPage: 10 }
    });

    deliveryGrid.grid.on('click', (ev) => {
        if (ev.columnName !== 'manage' && ev.columnName !== 'deliveryStatus' && ev.columnName !== 'trackingNo') {
            const rowData = deliveryGrid.grid.getRow(ev.rowKey);
            if (rowData && rowData.deliveryId) {
                location.href = '/admin/delivery/detail/' + rowData.deliveryId;
            }
        }
    });
});

function syncGridHeight() {
    setTimeout(() => {
        if (deliveryGrid && deliveryGrid.grid) {
            deliveryGrid.grid.refreshLayout();
        }
    }, 500); 
}

function clearAllInputSelects() {
    const currentRows = deliveryGrid.grid.getData();
    currentRows.forEach(row => {
        const deliveryId = row.deliveryId;
        if (!deliveryId) return;

        const trackingEl = document.getElementById('input_tracking_' + deliveryId);
        if (trackingEl) trackingEl.value = row.trackingNo || '';

        const statusEl = document.getElementById('select_status_' + deliveryId);
        if (statusEl) statusEl.value = row.deliveryStatus || '';
    });
}

function clearAllInputSelectsForVisibleData(visibleData) {
    clearAllInputSelects();
}

// 저장 처리 (전역 데이터와 동기화)
window.handleGridAction = function(rowData) {
    const deliveryId = rowData.deliveryId;
    const statusEl = document.getElementById('select_status_' + deliveryId);
    const trackingEl = document.getElementById('input_tracking_' + deliveryId);

    if (!statusEl || !trackingEl) { alert('엘리먼트 못찾음'); return; }

    const currentCode = statusEl.value;
    const trackingNo = trackingEl.value;

    fetch('/admin/delivery/deliveryUpdate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ deliveryId: parseInt(deliveryId), deliveryStatus: currentCode, trackingNo: trackingNo })
    })
    .then(res => res.json())
    .then(res => {
        if (res.success) {
            const statusName = statusEl.options[statusEl.selectedIndex].text;
            const newDisplay = '<strong>' + statusName + '</strong><br><small>(' + currentCode + ')</small>';

            [allOriginalData, deliveryGrid.allData, deliveryGrid.filteredData].forEach(arr => {
                if (!arr) return;
                const idx = arr.findIndex(i => String(i.deliveryId) === String(deliveryId));
                if (idx !== -1) {
                    arr[idx].deliveryStatus = currentCode;
                    arr[idx].trackingNo = trackingNo;
                    arr[idx].statusDisplay = newDisplay;
                }
            });

            deliveryGrid.updateGrid();
            alert('저장되었습니다.');
        } else {
            alert('실패: ' + res.message);
        }
    })
    .catch(err => alert('오류: ' + err));
};
</script>