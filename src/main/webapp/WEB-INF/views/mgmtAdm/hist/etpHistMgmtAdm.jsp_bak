<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cp" value="${pageContext.request.contextPath}" />
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<%-- 1. 스타일 정의 (관리 페이지와 동일한 배지 컬러 시스템 적용) --%>
<style>
    /* 배지 공통 스타일 */
    .stts-badge { 
        padding: 3px 10px !important; 
        border-radius: 9999px !important; 
        font-size: 11px !important; 
        font-weight: 700 !important; 
        display: inline-block !important; 
        text-align: center !important; 
        min-width: 95px !important; 
    }

    /* 상태별 컬러 정의 (요청하신 스타일과 100% 동기화) */
    .stts-et { background-color: #f5f3ff !important; color: #7c3aed !important; border: 1px solid #ddd6fe !important; } /* 견적: 보라 */
    .stts-od { background-color: #eff6ff !important; color: #2563eb !important; border: 1px solid #bfdbfe !important; } /* 주문: 파랑 */
    .stts-pr { background-color: #ecfeff !important; color: #0891b2 !important; border: 1px solid #a5f3fc !important; } /* 구매: 청록 */
    .stts-pm { background-color: #ecfdf5 !important; color: #059669 !important; border: 1px solid #a7f3d0 !important; } /* 결제: 에메랄드 */
    .stts-dv { background-color: #fffbeb !important; color: #d97706 !important; border: 1px solid #fde68a !important; } /* 배송: 주황 */
    .stts-reject { background-color: #fef2f2 !important; color: #dc2626 !important; border: 1px solid #fecaca !important; } /* 반려: 레드 */
    .stts-default { background-color: #f9fafb !important; color: #4b5563 !important; border: 1px solid #e5e7eb !important; }

    .hist-link { 
        color: #1e293b; 
        font-weight: 600; 
        cursor: pointer; 
        transition: all 0.2s ease; 
        padding: 4px 8px;
        border-radius: 4px;
        display: inline-block;
    }
    .hist-link:hover { color: #2563eb; background-color: #eff6ff; }
    #dg-container { width: 100%; margin-top: 1rem; }
    .grid-relative-wrapper { min-height: 400px; position: relative; }
</style>

<%-- 2. HTML 구조 --%>
<div class="max-w-screen-2xl mx-auto">
    <div class="bg-white p-8 rounded-xl shadow-lg border border-gray-300 dark:bg-gray-800 dark:border-gray-700">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4">
            <div>
                <div class="flex items-center gap-3">
                    <h2 class="text-2xl font-bold text-gray-900 dark:text-white">주문 히스토리 이력 관리</h2>
                    <span class="bg-blue-100 text-blue-700 text-xs font-bold px-2.5 py-0.5 rounded-full border border-blue-200">
                        전체 <span id="total-count-display">0</span>건
                    </span>
                </div>
                <p class="text-sm text-gray-500 mt-1">상태 변경 내역 및 관리자 승인/반려 이력을 확인합니다.</p>
            </div>
            <div class="flex items-center gap-2">
                <button type="button" onclick="HistExcelHandler.downloadExcel()" 
                    class="px-4 py-2 text-sm font-bold text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 transition-all">
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

<script>
    var contextPath = '${pageContext.request.contextPath}';
    if(contextPath === '/') contextPath = '';
    var cp = window.location.origin + contextPath;
    var myGrid;

    document.addEventListener('DOMContentLoaded', function() {
        var searchInput = document.getElementById('dg-search-input');
        if (searchInput) {
            var debounceTimer;
            searchInput.addEventListener('input', function() {
                clearTimeout(debounceTimer);
                debounceTimer = setTimeout(function() { window.fetchData(); }, 300);
            });
        }
        window.fetchData();
    });

    window.fetchData = function() {
        var searchInput = document.getElementById('dg-search-input');
        var searchVal = (searchInput && searchInput.value) ? searchInput.value : '';
        var perPageEl = document.getElementById('dg-per-page');
        var currentPerPage = (perPageEl && perPageEl.value) ? parseInt(perPageEl.value) : 10;

        // 상품 관리와 동일하게 대용량 데이터를 한 번에 가져와 그리드에서 페이징 처리
        var url = cp + '/admin/etphist/api/list?limit=5000&startRow=0&searchCondition=' + encodeURIComponent(searchVal);

        fetch(url)
            .then(function(res) { return res.json(); })
            .then(function(data) {
                var totalCountEl = document.getElementById('total-count-display');
                if (totalCountEl) totalCountEl.innerText = (data.totalCnt || 0).toLocaleString();
                initGrid(data.list || [], currentPerPage);
            })
            .catch(function(err) { console.error('Fetch Error:', err); });
    };

    function initGrid(data, perPage) {
        var formattedData = (data || []).map(function(item) {
            var newItem = Object.assign({}, item); 
            // T 문자 제거 및 초 단위 절삭
            if (newItem.regDtime) newItem.regDtime = newItem.regDtime.replace('T', ' ').split('.')[0];
            if (newItem.apprDtime) newItem.apprDtime = newItem.apprDtime.replace('T', ' ').split('.')[0];
            return newItem;
        });

        if (myGrid && myGrid.grid) {
            myGrid.allData = formattedData;
            myGrid.perPage = parseInt(perPage);
            myGrid.executeFiltering(true);
            setTimeout(function() { myGrid.grid.refreshLayout(); }, 100);
            return;
        }

        myGrid = new DataGrid({
            containerId: 'dg-container',
            searchId: 'dg-search-input',
            paginationId: 'dg-pagination',
            perPageId: 'dg-per-page',
            data: formattedData,
            perPage: parseInt(perPage),
            columns: [
                { 
                    header: '주문번호', name: 'orderNo', width: 160, align: 'center',
                    renderer: {
                        type: class {
                            constructor(props) {
                                this.el = document.createElement('span');
                                this.el.className = 'hist-link';
                                this.render(props);
                            }
                            getElement() { return this.el; }
                            render(props) { this.el.innerText = props.value || '-'; }
                        }
                    }
                },
                { 
                    header: '의사결정단계', name: 'etpSttsNm', width: 150, align: 'center',
                    renderer: {
                        type: class {
                            constructor(props) {
                                this.el = document.createElement('span');
                                this.render(props);
                            }
                            getElement() { return this.el; }
                            render(props) {
                                var row = props.grid.getRow(props.rowKey);
                                if(!row) return;
                                
                                // 코드값 판별 (CamelCase 대응)
                                var rawCode = row.etpSttsCd || row.etp_stts_cd || '';
                                var code = String(rawCode).toLowerCase().trim();
                                
                                var colorClass = 'stts-default';
                                if (code.includes('999')) colorClass = 'stts-reject';
                                else if (code.startsWith('et')) colorClass = 'stts-et';
                                else if (code.startsWith('od')) colorClass = 'stts-od';
                                else if (code.startsWith('pr')) colorClass = 'stts-pr';
                                else if (code.startsWith('pm')) colorClass = 'stts-pm';
                                else if (code.startsWith('dv')) colorClass = 'stts-dv';

                                this.el.className = 'stts-badge ' + colorClass;
                                this.el.innerText = props.value || '-';
                            }
                        }
                    }
                },
                { header: '요청자', name: 'requestUserNm', width: 120, align: 'center' },
                { header: '요청일자', name: 'regDtime', width: 170, align: 'center' },
                { header: '승인자', name: 'apprUserNm', width: 120, align: 'center', formatter: (v) => v.value || '-' },
                { header: '승인일자', name: 'apprDtime', width: 170, align: 'center', formatter: (v) => v.value || '-' },
                { 
                    header: '반려사유', name: 'rejtRsn', width: 300, align: 'center',
                    renderer: {
                        type: class {
                            constructor(props) {
                                this.el = document.createElement('div');
                                // [수정] 텍스트 중앙 정렬, 더 진한 레드, 굵게 표시
                                this.el.className = 'px-2 truncate text-red-600 font-bold text-center';
                                this.render(props);
                            }
                            getElement() { return this.el; }
                            render(props) {
                                this.el.innerText = props.value || '-';
                                if(props.value) this.el.title = props.value;
                            }
                        }
                    }
                }
            ]
        });
    }

    var HistExcelHandler = {
        downloadExcel: function() {
            var searchVal = document.getElementById('dg-search-input')?.value || '';
            window.location.href = cp + '/admin/etphist/download/excel?isExcel=Y&searchCondition=' + encodeURIComponent(searchVal);
        }
    };
</script>