<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cp" value="${pageContext.request.contextPath}" />
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style>
    .stts-badge { padding: 3px 10px !important; border-radius: 9999px !important; font-size: 11px !important; font-weight: 700 !important; display: inline-block !important; text-align: center !important; min-width: 95px !important; }

    /* [견적: et] 보라색 */
    .stts-et { background-color: #f5f3ff !important; color: #7c3aed !important; border: 1px solid #ddd6fe !important; } 
    
    /* [주문: od] 파란색 */
    .stts-od { background-color: #eff6ff !important; color: #2563eb !important; border: 1px solid #bfdbfe !important; }

    /* [구매: pr] 청록색 (Teal) - 추가 분리 */
    .stts-pr { background-color: #ecfeff !important; color: #0891b2 !important; border: 1px solid #a5f3fc !important; }
    
    /* [결제: pm] 에메랄드색 */
    .stts-pm { background-color: #ecfdf5 !important; color: #059669 !important; border: 1px solid #a7f3d0 !important; } 

    /* [배송: dv] 주황/노랑색 */
    .stts-dv { background-color: #fffbeb !important; color: #d97706 !important; border: 1px solid #fde68a !important; }

    /* [반려: 999] 붉은색 */
    .stts-reject { background-color: #fef2f2 !important; color: #dc2626 !important; border: 1px solid #fecaca !important; }

    /* [기본] 회색 */
    .stts-default { background-color: #f9fafb !important; color: #4b5563 !important; border: 1px solid #e5e7eb !important; }

    /* 그리드 영역 보호 */
    .grid-relative-wrapper { min-height: 400px; position: relative; }
</style>

<div class="max-w-screen-2xl mx-auto">
    <div class="bg-white p-8 rounded-xl shadow-lg border border-gray-300 dark:bg-gray-800 dark:border-gray-700">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4">
            <div>
                <div class="flex items-center gap-3">
                    <h2 class="text-2xl font-bold text-gray-900 dark:text-white">견적/주문/구매/결제 관리</h2>
                    <span class="bg-blue-100 text-blue-700 text-xs font-bold px-2.5 py-0.5 rounded-full border border-blue-200">
                        전체 <span id="total-count-display">0</span>건
                    </span>
                </div>
                <p class="text-sm text-gray-500 mt-1">단계별 프로세스를 모니터링하고 관리자 승인/반려 처리를 수행합니다.</p>
            </div>
            <div class="flex items-center gap-2">
                <button type="button" onclick="EtpExcelHandler.downloadExcel()" class="px-4 py-2 text-sm font-bold text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 transition-all">
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
<jsp:include page="etpHistModal.jsp" />

<script>
    const cp = window.location.origin + ( '${pageContext.request.contextPath}' === '/' ? '' : '${pageContext.request.contextPath}' );
    let etpGrid, approvModal;

    document.addEventListener('DOMContentLoaded', function() {
        // [수정] 모달 초기화 시 backdrop 옵션 명확화
        if (typeof Modal !== 'undefined') {
            const modalEl = document.getElementById('approvModal');
            if (modalEl) {
                approvModal = new Modal(modalEl, { 
                    backdrop: 'static',
                    closable: true,
                    onHide: () => {
                        // 모달이 닫힐 때 강제로 body 잠금 해제 (클릭 안됨 방지)
                        document.body.classList.remove('overflow-hidden');
                        $('.modal-backdrop').remove();
                    }
                });
            }
        }

        // 검색 및 필터 이벤트 리스너
        initEventListeners();
        window.fetchData();
    });

    function initEventListeners() {
        const filterWrapper = document.getElementById('dg-common-filter-wrapper');
        if (filterWrapper) {
            filterWrapper.addEventListener('change', (e) => {
                if (e.target.tagName === 'SELECT') window.fetchData();
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
    }

    window.fetchData = function() {
        const searchInput = document.getElementById('dg-search-input');
        const searchCondition = searchInput?.value ? encodeURIComponent(searchInput.value) : '';
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
                document.getElementById('total-count-display').innerText = (data.totalCnt || 0).toLocaleString();
                
                const mappedList = (data.list || []).map(item => ({
                    ...item,
                    etpSttsCd: item.orderStatus,
                    ordYear: item.orderDate ? item.orderDate.substring(0, 4) : ''
                }));

                initGrid(mappedList, currentPerPage);
            })
            .catch(err => console.error("Data fetch error:", err));
    };

    function initGrid(data, perPage) {
        const container = document.getElementById('dg-container');
        if (!container) return;

        // [핵심 수정] 기존 그리드가 있으면 innerHTML을 비우지 않고 데이터만 교체합니다.
        if (etpGrid && etpGrid.grid) {
            const cleanData = data.map(item => ({
                ...item,
                orderDate: item.orderDate ? item.orderDate.replace('T', ' ').split('.')[0] : '-',
                regDtime: item.regDtime ? item.regDtime.replace('T', ' ').split('.')[0] : '-'
            }));
            
            etpGrid.allData = cleanData;
            // resetData 사용 시 페이징 유지를 위해 기존 인스턴스 활용
            etpGrid.grid.resetData(cleanData);
            
        	 // [추가] 페이징 영역이 혹시라도 사라졌는지 체크하여 강제로 다시 그리기 지시
            if (typeof etpGrid.renderPagination === 'function') {
                etpGrid.renderPagination(); 
            }
            
            etpGrid.executeFiltering(true); 
            
            // 레이아웃이 깨지지 않게 보정
            setTimeout(() => etpGrid.grid.refreshLayout(), 100);
            return;
        }

        // 그리드 최초 생성 시에만 컨테이너 비우기
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
                                this.el = document.createElement('span');
                                this.render(props);
                            }
                            getElement() { return this.el; }
                            render(props) {
                                const rowData = props.grid.getRow(props.rowKey);
                                if(!rowData) return;
                                this.el.className = 'stts-badge ' + getSttsClass(props.rowKey, props.grid);
                                this.el.innerText = props.value || '-';
                            }
                        }
                    }
                },
                { header: '회사명', name: 'companyName', width: 150, align: 'left' },
                { header: '직급', name: 'userType', width: 100, align: 'center' },
                { header: '요청자', name: 'userName', width: 120, align: 'center' },
                { header: '주문일자', name: 'orderDate', width: 110, align: 'center', formatter: (v) => v.value ? v.value.replace('T', ' ').split('.')[0] : '-' },
                { header: '등록일시', name: 'regDtime', width: 160, align: 'center', formatter: (v) => v.value ? v.value.replace('T', ' ').split('.')[0] : '-' },
                {
                    header: '관리', name: 'manage', width: 220, align: 'center',
                    renderer: {
                        type: class {
                            constructor(props) {
                                const container = document.createElement('div');
                                container.className = 'flex gap-2 justify-center';
                                this.el = container;
                                this.render(props);
                            }
                            getElement() { return this.el; }
                            render(props) {
                                this.el.innerHTML = '';
                                const row = props.grid.getRow(props.rowKey);
                                if (!row) return;

                                if (row.approveBtn === 'Y' || row.rejectBtn === 'Y') {
                                    const btnManage = document.createElement('button');
                                    btnManage.className = 'px-3 py-1 text-xs font-bold text-blue-700 border border-blue-400 rounded-md hover:bg-blue-50 transition-colors';
                                    btnManage.innerText = '승인/반려';
                                    btnManage.onclick = (e) => {
                                        e.stopPropagation();
                                        openApproveModal(props.grid.getRow(props.rowKey));
                                    };
                                    this.el.appendChild(btnManage);
                                }
                                
                                const btnHist = document.createElement('button');
                                btnHist.className = 'px-3 py-1 text-xs font-bold text-gray-700 border border-gray-400 rounded-md hover:bg-gray-100 transition-colors';
                                btnHist.innerText = '이력';
                                btnHist.onclick = (e) => {
                                    e.stopPropagation();
                                    viewHistory(props.grid.getRow(props.rowKey).orderId);
                                };
                                this.el.appendChild(btnHist);
                            }
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
        if (!row) return 'stts-default';

        // etpSttsCd(매핑값) 또는 orderStatus(원천값) 참조
        const rawCode = row.etpSttsCd || row.orderStatus || '';
        const code = String(rawCode).toLowerCase().trim(); 

        // 1. 반려 (999 포함 시 최우선)
        if (code.includes('999')) {
            return 'stts-reject';
        }

        // 2. 견적 (et)
        if (code.startsWith('et')) {
            return 'stts-et';
        }

        // 3. 주문 (od) - 파란색
        if (code.startsWith('od')) {
            return 'stts-od';
        }

        // 4. 구매 (pr) - 청록색
        if (code.startsWith('pr')) {
            return 'stts-pr';
        }

        // 5. 결제 (pm)
        if (code.startsWith('pm')) {
            return 'stts-pm';
        }

        // 6. 배송 (dv)
        if (code.startsWith('dv')) {
            return 'stts-dv';
        }
        
        return 'stts-default';
    }

    function openApproveModal(rowData) {
        if(!rowData) return;
        
        // 폼 초기화
        $('#modalOrderId').val(rowData.orderId || '');
        $('#modalEstId').val(rowData.estId || '');
        $('#modalSystemId').val(rowData.systemId || '');
        $('#modalUserId').val(rowData.userId || '');
        $('#modalUserType').val(rowData.userType || '');
        $('#modalRequestUser').text((rowData.userName || '') + ' (' + (rowData.userId || '-') + ')');
        $('#modalCtrtNm').text(rowData.ctrtNm || '-');
        $('#rejtRsnArea').hide();
        $('#rejtRsn').val('');
        $('input[name="apprStatus"][value="APPROVED"]').prop('checked', true);
        
        // [중요] 모달 표시 전 배경잠김 해제 확인
        document.body.classList.add('overflow-hidden');
        if(approvModal) approvModal.show();
    }

    const EtpExcelHandler = {
        downloadExcel: function() {
            const searchCondition = document.getElementById('dg-search-input')?.value || '';
            const etpSttsCd = document.getElementById('filter-etpSttsCd')?.value || '';
            const ordYear = document.getElementById('filter-ordYear')?.value || '';

            let url = cp + '/admin/etp/download/excel?isExcel=Y'
                    + '&searchCondition=' + encodeURIComponent(searchCondition)
                    + '&etpSttsCd=' + encodeURIComponent(etpSttsCd)
                    + '&ordYear=' + encodeURIComponent(ordYear);
            location.href = url;
        }
    };
</script>