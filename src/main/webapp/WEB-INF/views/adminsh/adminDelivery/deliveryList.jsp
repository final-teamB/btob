<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="showSearchArea" value="true" scope="request" />
<c:set var="showPerPage" value="true" scope="request" />
<c:set var="showAddBtn" value="false" scope="request" />

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
	#dg-container { width: 100%; margin-top: 1rem; }
	.grid-relative-wrapper { position: relative; width: 100%; }
	
	/* 직접 수정 input/select 톤 통일 */
	.direct-edit-el {
	    pointer-events: auto !important;
	    width: 90% !important;
	    height: 36px !important;
	    border: 1px solid #e2e8f0 !important;
	    border-radius: 6px !important;
	    background-color: #ffffff !important;
	    font-size: 13px !important;
	    transition: border-color 0.2s ease;
	}
	
	.direct-edit-el:focus {
	    border-color: #3b82f6 !important;
	    outline: none !important;
	}
	
	/* select 가운데 정렬 */
	select.direct-edit-el {
	    text-align: center !important;
	    text-align-last: center !important;
	    appearance: none;
	    background-position: right 8px center;
	}
	
	select.direct-edit-el option {
	    text-align: center;
	}
	
	/* 상태 표시 strong/small 정리 */
	.tui-grid-body-area .tui-grid-cell-content {
	    line-height: 1.1 !important;
	    padding: 0 !important;
	}
	
	.tui-grid-body-area .tui-grid-cell-content strong {
	    display: block;
	    font-weight: 700;
	}
	
	.tui-grid-body-area .tui-grid-cell-content small {
	    display: block;
	    font-size: 11px;
	    color: #64748b;
	    margin-top: -4px;
	}
	
	/* 필터, 검색 영역 사이즈 통일 */
	#dg-common-filter-wrapper select, 
	#dg-search-input {
	    padding-left: 1rem !important;
	    padding-right: 2.5rem !important;
	}
	
	.tui-grid-body-area td[data-column-name="manage"] button {
	    padding: 0.1rem 0.75rem !important;   /* px-3 py-1 */
	    font-size: 0.75rem !important;         /* text-xs */
	    font-weight: 700 !important;           /* font-bold */
	    color: #1d4ed8 !important;             /* text-blue-700 */
	    background-color: #ffffff !important;
	    border: 1px solid #60a5fa !important;  /* border-blue-400 */
	    border-radius: 0.375rem !important;    /* rounded-md */
	    transition: all 0.2s ease !important;
	    text-decoration: none !important;
	}
	
	.tui-grid-body-area td[data-column-name="manage"] button:hover {
	    background-color: #eff6ff !important;  /* hover:bg-blue-50 */
	}
</style>

<div class="max-w-screen-2xl mx-auto">
    <div class="bg-white p-8 rounded-xl shadow-lg border border-gray-100 dark:bg-gray-800 dark:border-gray-700">
        
        <!-- ===== 상단 타이틀 영역 (사용자 관리와 동일 구조) ===== -->
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4">
            <div>
                <div class="flex items-center gap-3">
                    <h2 class="text-2xl font-bold text-gray-900 dark:text-white">
                        배송 관리
                    </h2>
                    <span class="bg-blue-100 text-blue-700 text-xs font-bold px-2.5 py-0.5 rounded-full dark:bg-blue-900 dark:text-blue-300">
                        ADMIN
                    </span>
                </div>
                <p class="text-sm text-gray-500 mt-1">
                    모든 주문의 배송 상태와 운송장을 즉시 수정하고 저장할 수 있습니다.
                </p>
            </div>
        </div>

        <!-- ===== 데이터그리드 영역 ===== -->
        <div class="grid-relative-wrapper">
            <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp">
                <jsp:param name="showSearchArea" value="true" />
                <jsp:param name="showPerPage" value="true" />
            </jsp:include>
        </div>

    </div>
</div>

<div id="deliveryDetailModal" tabindex="-1" aria-hidden="true" class="fixed inset-0 z-50 hidden flex items-center justify-center bg-black/50 overflow-y-auto">
    <div class="relative w-full max-w-3xl p-4">
        <div class="relative bg-white rounded-xl border border-gray-200 dark:bg-gray-800 dark:border-gray-700">
            <div class="flex items-center justify-between p-4 border-b">
                <h3 class="text-xl font-bold text-gray-900 dark:text-white">배송 상세 정보 관리</h3>
                <button type="button" onclick="closeDeliveryModal()" class="text-gray-400 hover:text-gray-900 ml-auto p-2">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>
            <div id="deliveryModalContent">
                <div class="flex justify-center py-10">
                    <span>데이터를 불러오는 중...</span>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
class DirectInputRenderer {
    constructor(props) {
        const el = document.createElement('input');
        el.type = 'text'; 
        el.className = 'direct-edit-el';
        el.placeholder = 'TRK + 숫자 10자리';
        el.maxLength = 13;
        ['mousedown','click','mouseup'].forEach(e => el.addEventListener(e, ev => ev.stopPropagation()));
        
    	// 한글 조합 중 여부 플래그
        let isComposing = false;
        el.addEventListener('compositionstart', () => { isComposing = true; });
        el.addEventListener('compositionend', function() {
            isComposing = false;
            // 조합 완료 후 한글 제거
            this.value = this.value.replace(/[^a-zA-Z0-9]/g, '').toUpperCase();
            formatTracking(this);
        });

        el.addEventListener('input', function() {
            if (isComposing) return; // 한글 조합 중이면 아무것도 안 함
            formatTracking(this);
        });

        function formatTracking(el) {
            let val = el.value.replace(/[^a-zA-Z0-9]/g, '').toUpperCase();

            if (val.length >= 3) {
                val = 'TRK' + val.slice(3).replace(/[^0-9]/g, '');
            } else {
                val = 'TRK'.slice(0, val.length);
            }

            if (val.length > 13) val = val.slice(0, 13);
            el.value = val;
        }

        // 포커스 시 TRK 자동 입력
        el.addEventListener('focus', function() {
            if (!this.value) this.value = 'TRK';
        });

        // 저장 전 형식 검증 (포커스 아웃 시)
        el.addEventListener('blur', function() {
            const val = this.value;
            if (val && val !== 'TRK') {
                const isValid = /^TRK\d{10}$/.test(val);
                if (!isValid) {
                    this.style.borderColor = '#ef4444';
                    this.title = 'TRK + 숫자 10자리 형식이어야 합니다 (예: TRK1234567890)';
                } else {
                    this.style.borderColor = '#e2e8f0';
                    this.title = '';
                }
            } else if (val === 'TRK') {
                // TRK만 입력한 경우 초기화
                this.value = '';
                this.style.borderColor = '#e2e8f0';
            }
        });
        
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
        
        el.addEventListener('change', function() {
            const selectedValue = this.value;
            const selectId = this.id; 
            const deliveryId = selectId.replace('select_status_', '');

            if (selectedValue === 'dv006') {
                // 국내배송중으로 변경 시 서버에서 운송장 정보 가져오기
                fetch('/admin/delivery/getTrackingInfo?deliveryId=' + deliveryId)
                    .then(res => res.json())
                    .then(data => {
                        if (data.success) {
                            const trackingEl = document.getElementById('input_tracking_' + deliveryId);
                            if (trackingEl) {
                                trackingEl.value = data.trackingNo;
                            }
                        }
                    })
                    .catch(err => console.error('운송장 조회 실패:', err));
            }
        });
        
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
        if (orderStatus === 'pm004') {
            // dv005(통관완료)는 비활성화 옵션으로 포함, dv006/dv007은 선택 가능
            allowedStatus = list.filter(s => ['dv005', 'dv006', 'dv007'].includes(s.v));
        } else if (orderStatus === 'pm002') allowedStatus = list.filter(s => ['dv001','dv002','dv003','dv004','dv005'].includes(s.v));

        allowedStatus.forEach(i => {
            const o = document.createElement('option');
            o.value = i.v;
            o.textContent = i.t;
            if (i.v === currentValue) o.selected = true;

            if (i.v === 'dv005' && orderStatus === 'pm004') {
                o.disabled = true;
                o.style.color = '#aaa';
            }
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

        const perPage = 10; 
        const pageData = filtered.slice(0, perPage); // 10개만 자르기
        
        if (deliveryGrid && deliveryGrid.grid) {
            deliveryGrid.grid.resetData(pageData); // 자른 데이터 삽입
            
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
    	bodyHeight: 'auto',
    	rowHeight: 60,         
        columnOptions: {
            resizable: true
        },
        pageOptions: { useClient: true, perPage: 10 }
    });
    
    const initialPerPage = 10;
    const initialPageData = allOriginalData.slice(0, initialPerPage);
    deliveryGrid.grid.resetData(initialPageData); // 초기 10개만 먼저 세팅

    const initialPaginationEl = document.querySelector('.tui-pagination');
    if (initialPaginationEl) {
        initialPaginationEl.style.display = (allOriginalData.length <= initialPerPage) ? 'none' : 'block';
    }

    deliveryGrid.grid.on('click', (ev) => {
        if (ev.columnName !== 'manage' && ev.columnName !== 'deliveryStatus' && ev.columnName !== 'trackingNo') {
            const rowData = deliveryGrid.grid.getRow(ev.rowKey);
            if (rowData && rowData.deliveryId) {
                openDeliveryModal(rowData.deliveryId); 
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
    
    if (trackingNo && !/^TRK\d{10}$/.test(trackingNo)) {
        alert('운송장번호는 TRK + 숫자 10자리 형식이어야 합니다.\n예: TRK1234567890');
        trackingEl.focus();
        return;
    }

    fetch('/admin/delivery/deliveryUpdate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ deliveryId: parseInt(deliveryId), deliveryStatus: currentCode, trackingNo: trackingNo })
    })
    .then(res => res.json())
    .then(res => {
        if (res.success) {
            // ✅ 변수 선언 추가 (이게 빠져서 에러났던 것)
            const savedTrackingNo = res.trackingNo || trackingNo;
            const savedStatusCode = res.deliveryStatus || currentCode;
            const savedStatusDesc = res.deliveryStatusDesc || statusEl.options[statusEl.selectedIndex].text;
            const newDisplay = '<strong>' + savedStatusDesc + '</strong><br><small>(' + savedStatusCode + ')</small>';

            // 데이터 배열 업데이트
            [allOriginalData, deliveryGrid.allData, deliveryGrid.filteredData].forEach(arr => {
                if (!arr) return;
                const idx = arr.findIndex(i => String(i.deliveryId) === String(deliveryId));
                if (idx !== -1) {
                    arr[idx].deliveryStatus = savedStatusCode;
                    arr[idx].trackingNo = savedTrackingNo;
                    arr[idx].statusDisplay = newDisplay;
                }
            });

            // ✅ 저장된 행 input에 운송장번호 즉시 반영
            if (trackingEl) trackingEl.value = savedTrackingNo;

            // ✅ '현재 상태' 셀만 업데이트 (다른 행 건드리지 않음)
            const rowKey = deliveryGrid.grid.getData().findIndex(
                r => String(r.deliveryId) === String(deliveryId)
            );
            if (rowKey !== -1) {
                deliveryGrid.grid.setValue(rowKey, 'statusDisplay', newDisplay);
            }

            alert('저장되었습니다.');
        } else {
            alert('실패: ' + res.message);
        }
    })
    .catch(err => alert('오류: ' + err));
};

function openDeliveryModal(deliveryId) {
    const modal = document.getElementById('deliveryDetailModal');
    modal.style.display = 'flex';
    modal.classList.remove('hidden');
    document.body.style.overflow = 'hidden';

    $.ajax({
        url: "/admin/delivery/detail/" + deliveryId + "?modal=Y",
        type: "GET",
        success: function(html) {
            $('#deliveryModalContent').html(html);
        },
        error: function() {
            alert("데이터를 불러오지 못했습니다.");
            closeDeliveryModal();
        }
    });
}
function closeDeliveryModal() {
    const modal = document.getElementById('deliveryDetailModal');
    modal.style.display = 'none';
    modal.classList.add('hidden');
    document.body.style.overflow = 'auto';
}
</script>