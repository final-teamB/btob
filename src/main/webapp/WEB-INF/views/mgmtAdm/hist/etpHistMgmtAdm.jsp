<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cp" value="${pageContext.request.contextPath}" />
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style>
    /* 배경색 및 전체 컨테이너 설정 */
    body { background-color: #f9fafb; }

    /* [최종 수정] 푸터와 최대한 가깝게 붙도록 여백 최소화 */
    .admin-main-container { 
        width: 100%; 
        /* 데이터가 적어도 푸터가 아래에 너무 멀리 있지 않게 설정 */
        min-height: auto; 
        /* 하단 안쪽 여백 축소 (0.25rem) */
        padding-bottom: 0.25rem; 
        margin-bottom: 0 !important;
    }
    
    /* 그리드 카드 스타일 */
    .grid-card { 
        background-color: #ffffff; border: 1px solid #e5e7eb; 
        border-radius: 0.75rem; box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1); 
        /* 카드 하단 마진 제거하여 푸터와 밀착 */
        margin-bottom: 0; 
    }

    /* 배지 공통 스타일 (기존 유지) */
    .stts-badge { 
        padding: 3px 10px !important; border-radius: 9999px !important; 
        font-size: 11px !important; font-weight: 700 !important; 
        display: inline-block !important; text-align: center !important; 
        min-width: 95px !important; 
    }

    /* 상태별 컬러 정의 (기존 유지) */
    .stts-et { background-color: #f5f3ff !important; color: #7c3aed !important; border: 1px solid #ddd6fe !important; }
    .stts-od { background-color: #eff6ff !important; color: #2563eb !important; border: 1px solid #bfdbfe !important; }
    .stts-pr { background-color: #ecfeff !important; color: #0891b2 !important; border: 1px solid #a5f3fc !important; }
    .stts-pm { background-color: #ecfdf5 !important; color: #059669 !important; border: 1px solid #a7f3d0 !important; }
    .stts-dv { background-color: #fffbeb !important; color: #d97706 !important; border: 1px solid #fde68a !important; }
    .stts-reject { background-color: #fef2f2 !important; color: #dc2626 !important; border: 1px solid #fecaca !important; }
    .stts-default { background-color: #f9fafb !important; color: #4b5563 !important; border: 1px solid #e5e7eb !important; }

    /* 그리드 영역 보호 (초기 높이 살짝 낮춤) */
    .grid-relative-wrapper { min-height: 450px; position: relative; width: 100%; }

    /* 버튼 스타일 (기존 유지) */
    .btn-outline-custom {
        padding: 0.5rem 1.5rem; font-size: 0.875rem; font-weight: 600;
        color: #4b5563; background-color: #ffffff; border: 1px solid #d1d5db;
        border-radius: 0.5rem; transition: all 0.2s;
        white-space: nowrap; display: inline-flex; align-items: center; justify-content: center;
        min-width: 140px; 
    }
    .btn-outline-custom:hover { background-color: #f9fafb; border-color: #9ca3af; }
</style>

<div class="admin-main-container my-6 space-y-6">
    <div class="px-5 py-4 flex flex-col md:flex-row justify-between items-start md:items-center">
        <div class="w-full text-left">
            <div class="flex items-center gap-3">
                <h1 class="text-2xl font-bold text-gray-900 dark:text-white">주문 히스토리 이력 관리</h1>
                <span class="bg-blue-50 text-blue-700 text-xs font-bold px-2.5 py-1 rounded-full border border-blue-100">
                    전체 <span id="total-count-display">0</span>건
                </span>
            </div>
            <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">상태 변경 내역 및 관리자 승인/반려 이력을 확인합니다.</p>
        </div>
        
        <div class="flex items-center gap-2 mt-4 md:mt-0">
            <button type="button" onclick="HistExcelHandler.downloadExcel()" class="btn-outline-custom">
                <i class="fas fa-file-excel mr-2 text-green-600"></i> 엑셀 다운로드
            </button>
        </div>
    </div>

    <div class="px-5" style="margin-top: 1rem !important;">
        <div class="grid-card p-4">
            <div class="grid-relative-wrapper">
                <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp">
                    <jsp:param name="showSearchArea" value="true" />
                    <jsp:param name="showPerPage" value="true" />
                </jsp:include>
            </div>
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