<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cp" value="${pageContext.request.contextPath}" />
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
    /* 상태별 배지 스타일 */
    .stts-badge { padding: 2px 8px; border-radius: 9999px; font-size: 12px; font-weight: 600; }
    .stts-ready { background-color: #f3f4f6; color: #374151; }    /* 대기 */
    .stts-ing { background-color: #eff6ff; color: #1d4ed8; }      /* 진행중 */
    .stts-complete { background-color: #ecfdf5; color: #059669; } /* 완료 */
    .stts-reject { background-color: #fef2f2; color: #dc2626; }   /* 반려 */

    .btn-action { transition: all 0.2s; }
    .btn-action:hover { transform: translateY(-1px); shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
</style>

<div class="max-w-screen-2xl mx-auto">
    <div class="bg-white p-8 rounded-xl shadow-lg border border-gray-100 dark:bg-gray-800 dark:border-gray-700">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4">
            <div>
                <div class="flex items-center gap-3">
                    <h2 class="text-2xl font-bold text-gray-900 dark:text-white">견적/주문/구매/결제 관리</h2>
                    <span class="bg-blue-100 text-blue-700 text-xs font-bold px-2.5 py-0.5 rounded-full">
                        전체 <span id="total-count-display">0</span>건
                    </span>
                </div>
                <p class="text-sm text-gray-500 mt-1">단계별 프로세스를 모니터링하고 관리자 승인/반려 처리를 수행합니다.</p>
            </div>
            <div class="flex items-center gap-2">
                <button type="button" onclick="EtpExcelHandler.downloadExcel()" class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-200 rounded-lg hover:bg-gray-50">
                    <i class="fas fa-file-excel mr-1 text-green-600"></i> 엑셀 다운로드
                </button>
            </div>
        </div>

        <div class="grid-relative-wrapper">
            <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp">
                <jsp:param name="showSearchArea" value="true" />
                <jsp:param name="showPerPage" value="true" />
            </jsp:include>
        </div>
    </div>
</div>

<jsp:include page="etpApprovRejctModal.jsp" />

<script>
    const cp = window.location.origin + ( '${pageContext.request.contextPath}' === '/' ? '' : '${pageContext.request.contextPath}' );
    let etpGrid, approvModal;

    document.addEventListener('DOMContentLoaded', function() {
        // 모달 초기화
        if (typeof Modal !== 'undefined') {
            approvModal = new Modal(document.getElementById('approvModal'), { backdrop: 'static' });
        }

     	// [추가] 실시간 검색 및 필터 변경 이벤트 감지 (이벤트 위임)
        const filterWrapper = document.getElementById('dg-common-filter-wrapper');
        if (filterWrapper) {
            filterWrapper.addEventListener('change', function(e) {
                if (e.target.tagName === 'SELECT') {
                    window.fetchData();
                }
            });
        }

        const searchInput = document.getElementById('dg-search-input');
        if (searchInput) {
            let debounceTimer;
            searchInput.addEventListener('input', () => {
                clearTimeout(debounceTimer);
                debounceTimer = setTimeout(() => window.fetchData(), 300);
            });
        }

        window.fetchData();
    });

 	// --- 데이터 조회 함수 ---
    window.fetchData = function() {
        const searchInput = document.getElementById('dg-search-input');
        const searchCondition = searchInput && searchInput.value ? encodeURIComponent(searchInput.value) : '';

        // [수정 포인트] 필터 셀렉트 박스 값 수집
        const etpSttsCd = document.getElementById('filter-etpSttsCd')?.value || '';
        const ordYear = document.getElementById('filter-ordYear')?.value || '';
        
        const perPageEl = document.getElementById('dg-per-page');
        const currentPerPage = perPageEl ? parseInt(perPageEl.value) : 10;

        let url = cp + '/admin/etp/api/list?limit=5000'
                + '&searchCondition=' + searchCondition
                + '&etpSttsCd=' + encodeURIComponent(etpSttsCd)
                + '&ordYear=' + encodeURIComponent(ordYear);

        fetch(url)
            .then(res => res.json())
            .then(data => {
                const totalCountEl = document.getElementById('total-count-display');
                if (totalCountEl) {
                    totalCountEl.innerText = (data.totalCnt || 0).toLocaleString();
                }
                
                // [핵심 수정] 로컬 필터링을 위해 서버 데이터의 키값을 매핑합니다.
                // datagrid.js는 'etpSttsCd' 필터를 돌릴 때 데이터의 'etpSttsCd' 속성을 검사합니다.
                const mappedList = (data.list || []).map(item => ({
                    ...item,
                    etpSttsCd: item.orderStatus, // 서버의 orderStatus 값을 필터가 사용하는 키값으로 복사
                    ordYear: item.orderDate ? item.orderDate.substring(0, 4) : '' // 연도 필터 대응
                }));

                initGrid(mappedList, currentPerPage);
            });
    };

    function initGrid(data, perPage) {
        const container = document.getElementById('dg-container');
        if (!container) return;

        // 기존 그리드가 있을 경우 데이터만 업데이트
        if (etpGrid && etpGrid.grid) {
            etpGrid.allData = data.map(item => {
                const newItem = { ...item };
                if (newItem.regDtime && typeof newItem.regDtime === 'string') {
                    newItem.regDtime = newItem.regDtime.replace('T', ' ').split('.')[0];
                }
                return newItem;
            });
            etpGrid.perPage = perPage;
            etpGrid.currentPage = 1;
            etpGrid.executeFiltering(true);
            setTimeout(() => etpGrid.grid.refreshLayout(), 50);
            return;
        }

        // --- 그리드 최초 생성 ---
        container.innerHTML = '';
        etpGrid = new DataGrid({
            containerId: 'dg-container',
            searchId: 'dg-search-input',
            paginationId: 'dg-pagination',
            perPageId: 'dg-per-page',
            data: data,
            perPage: perPage || 10,
            columns: [
                { header: '주문번호', name: 'orderNo', width: 160, align: 'center' },
                { header: '견적번호', name: 'estNo', width: 160, align: 'center', formatter: (v) => v.value || '-' },
                { header: '계약명', name: 'ctrtNm', width: 220, align: 'left', formatter: (v) => v.value || '-' },
                { header: '결제번호', name: 'paymentNo', width: 160, align: 'center', formatter: (v) => v.value || '-' },
                { 
                    header: '상태', name: 'etpSttsNm', width: 120, align: 'center',
                    renderer: {
                        type: class {
                            constructor(props) {
                                const el = document.createElement('span');
                                this.el = el;
                                this.render(props);
                            }
                            getElement() { return this.el; }
                            render(props) {
                                this.el.className = 'stts-badge ' + getSttsClass(props.rowKey, props.grid);
                                this.el.innerText = props.value || '-';
                            }
                        }
                    }
                },
                { header: '회사명', name: 'companyName', width: 150, align: 'left' },
                { header: '직급', name: 'userType', width: 100, align: 'center' },
                { header: '요청자', name: 'userName', width: 120, align: 'center' },
                { header: '주문일자', name: 'orderDate', width: 110, align: 'center', formatter: (v) => v.value ? v.value.split('T')[0] : '-' },
                { header: '등록일시', name: 'regDtime', width: 160, align: 'center', formatter: (v) => v.value ? v.value.replace('T', ' ').split('.')[0] : '-' },
                {
                    header: '관리', name: 'manage', width: 220, align: 'center',
                    renderer: {
                        type: class {
                            constructor(props) {
                                const row = props.grid.getRow(props.rowKey);
                                const container = document.createElement('div');
                                container.className = 'flex gap-2 justify-center';
                                
                            	 // [수정 포인트] 승인 혹은 반려 권한이 하나라도 있으면 통합 버튼 노출
                                if (row.approveBtn === 'Y' || row.rejectBtn === 'Y') {
                                    const btnManage = document.createElement('button');
                                    btnManage.className = 'px-3 py-1 text-xs font-bold text-blue-600 border border-blue-600 rounded hover:bg-blue-50 transition-colors';
                                    btnManage.innerText = '승인/반려';
                                    btnManage.onclick = () => openApproveModal(row);
                                    container.appendChild(btnManage);
                                }
                                
                             	// 이력 버튼 (항시 노출)
                                const btnHist = document.createElement('button');
                                btnHist.className = 'px-3 py-1 text-xs font-bold text-gray-600 border border-gray-300 rounded hover:bg-gray-50 transition-colors';
                                btnHist.innerText = '이력';
                                btnHist.onclick = () => viewHistory(row.orderId);
                                container.appendChild(btnHist);

                                this.el = container;
                            }
                            getElement() { return this.el; }
                        }
                    }
                }
            ]
        });

        if (etpGrid.initFilters) {
            etpGrid.initFilters([
                { 
                    field: 'etpSttsCd', 
                    title: '진행상태', 
                    options: [
                        <c:forEach var="opt" items="${selectBoxes.etpSttsCdList}" varStatus="status">
                            { value: '${opt.value}', text: '${opt.text}' }${!status.last ? ',' : ''}
                        </c:forEach>
                    ]
                },
                { 
                    field: 'ordYear', 
                    title: '연도별', 
                    options: [
                        <c:forEach var="opt" items="${selectBoxes.ordYearList}" varStatus="status">
                            { value: '${opt.value}', text: '${opt.text}' }${!status.last ? ',' : ''}
                        </c:forEach>
                    ]
                }
            ]);
            etpGrid.executeFiltering(true);
        }
    }

    function getSttsClass(rowKey, grid) {
        const row = grid.getRow(rowKey);
        // 행 데이터가 없거나 orderStatus가 없는 경우 대비
        if (!row || !row.orderStatus) return 'stts-ready';
        
        const code = row.orderStatus; 

        // 1. 반려 (999 또는 rej 포함)
        if (code.includes('999') || code.toLowerCase().includes('rej')) {
            return 'stts-reject';
        }
        
        // 2. 대기 (끝자리가 001)
        if (code.endsWith('001')) {
            return 'stts-ready';
        }
        
        // 3. 완료 (끝자리가 002, 003, 004 또는 complete 포함)
        // pm002: 주문요청완료, pm003: 1차결제완료, pm004: 2차결제완료 등
        if (code.endsWith('002') || code.endsWith('003') || code.endsWith('004') || code.toLowerCase().includes('complete')) {
            return 'stts-complete';
        }
        
        // 4. 그 외 나머지는 진행중 (stts-ing)
        return 'stts-ing';
    }

	 // 모달 오픈 함수 (하나의 모달에서 처리하므로 mode 파라미터 제거)
    function openApproveModal(rowData) {
        if(!rowData) return;
        
     // jQuery를 사용하므로 $('#id') 방식으로 값 세팅 가능
        $('#modalOrderId').val(rowData.orderId || '');
        $('#modalEstId').val(rowData.estId || '');       // 버그 해결을 위한 estId 추가
        $('#modalSystemId').val(rowData.systemId || '');
        $('#modalUserId').val(rowData.userId || '');    
        $('#modalUserType').val(rowData.userType || ''); 
        
        // 텍스트 출력
        $('#modalRequestUser').text((rowData.userName || '') + ' (' + (rowData.userId || '-') + ')');
        $('#modalCtrtNm').text(rowData.ctrtNm || '-');
        
        // 반려 사유 영역 초기화
        $('#rejtRsnArea').hide();
        $('#rejtRsn').val('');
        
        // 승인 버튼 기본 체크
        $('input[name="apprStatus"][value="APPROVED"]').prop('checked', true);
        
        if(approvModal) approvModal.show();
    }

    // 엑셀 핸들러
    const EtpExcelHandler = {
        downloadExcel: function() {
            const searchCondition = document.getElementById('dg-search-input')?.value || '';
            location.href = cp + '/admin/etp/download/excel?searchCondition=' + encodeURIComponent(searchCondition) + '&isExcel=Y';
        }
    };
</script>