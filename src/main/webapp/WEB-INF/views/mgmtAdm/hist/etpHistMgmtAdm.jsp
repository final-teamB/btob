<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cp" value="${pageContext.request.contextPath}" />

<%-- 1. 스타일 정의 (상품관리와 동일한 컨테이너 클래스 유지) --%>
<style>
	/* 배지 공통 스타일 */
    .stts-badge {
        padding: 4px 10px;
        border-radius: 9999px;
        font-size: 12px;
        font-weight: 700;
        display: inline-block;
        min-width: 80px;
        text-align: center;
    }
    /* 상태별 색상 (예시) */
    .stts-et { bg-color: #e0f2fe; color: #0369a1; border: 1px solid #bae6fd; } /* 요청 */
    .stts-od { bg-color: #fef9c3; color: #854d0e; border: 1px solid #fef08a; } /* 주문 */
    .stts-reject { bg-color: #fee2e2; color: #991b1b; border: 1px solid #fecaca; } /* 반려/취소 */
    .stts-default { bg-color: #f3f4f6; color: #374151; border: 1px solid #e5e7eb; }
</style>
<style>
    .hist-link { 
        color: #1e293b; 
        font-weight: 600; 
        cursor: pointer; 
        transition: all 0.2s ease; 
        padding: 4px 8px;
        border-radius: 4px;
        display: inline-block;
    }
    .hist-link:hover { 
        color: #2563eb; 
        background-color: #eff6ff; 
    }
    #dg-container { width: 100%; margin-top: 1rem; }
</style>

<%-- 2. HTML 구조 (상품관리 페이지의 최상위 div 구조를 그대로 복사) --%>
<div class="max-w-screen-2xl mx-auto">
    <div class="bg-white p-8 rounded-xl shadow-lg border border-gray-100 dark:bg-gray-800 dark:border-gray-700">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4">
            <div>
                <div class="flex items-center gap-3">
                    <h2 class="text-2xl font-bold text-gray-900 dark:text-white">주문 히스토리 이력 관리</h2>
                    <%-- [추가] 조회 건수 표시 영역 --%>
                    <span class="bg-blue-100 text-blue-700 text-xs font-bold px-2.5 py-0.5 rounded-full dark:bg-blue-900 dark:text-blue-300">
                        전체 <span id="total-count-display">0</span>건
                    </span>
                </div>
                <p class="text-sm text-gray-500 mt-1">주문 상태 변경 및 승인/반려 내역을 관리합니다.</p>
            </div>
            <div class="flex items-center gap-2">
                <button type="button" onclick="HistExcelHandler.downloadExcel()"
                    class="px-3 py-1.5 text-sm font-medium text-gray-700 bg-white border border-gray-200 rounded-lg hover:bg-gray-50 transition">
                    엑셀 다운로드
                </button>
            </div>
        </div>

        <%-- 데이터그리드 포함 --%>
        <div class="grid-relative-wrapper">
            <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp">
                <jsp:param name="showSearchArea" value="true" />
                <jsp:param name="showPerPage" value="true" />
            </jsp:include>
        </div>
    </div>
</div>

<script>
    // 3. 자바스크립트 변수 선언 (백틱 금지)
    var contextPath = '${pageContext.request.contextPath}';
    if(contextPath === '/') contextPath = '';
    var cp = window.location.origin + contextPath;
    
    var myGrid;

    document.addEventListener('DOMContentLoaded', function() {
    	// [추가] 실시간 검색어 입력에 따른 건수 업데이트 (디바운싱)
        var searchInput = document.getElementById('dg-search-input');
        if (searchInput) {
            var debounceTimer;
            searchInput.addEventListener('input', function() {
                clearTimeout(debounceTimer);
                debounceTimer = setTimeout(function() {
                    console.log("히스토리 실시간 입력 감지: 건수 갱신 중...");
                    window.fetchData(); 
                }, 200);
            });
        }
        
        window.fetchData();
    });

 	// 4. 데이터 조회 함수 (상품 관리 로직과 동기화)
    window.fetchData = function() {
        var searchInput = document.getElementById('dg-search-input');
        var searchVal = (searchInput && searchInput.value) ? searchInput.value : '';
        
        // [수정] 현재 그리드에 설정된 페이지당 건수를 가져오되, 서버 요청은 넉넉하게 5000건으로 함
        var perPageEl = document.getElementById('dg-per-page');
        var currentPerPage = (perPageEl && perPageEl.value) ? parseInt(perPageEl.value) : 10;

        // [핵심 변경] limit=5000 으로 하드코딩하여 서버 페이징 에러를 회피하고 데이터를 통째로 가져옴
        var params = 'searchCondition=' + encodeURIComponent(searchVal) 
                   + '&startRow=0' 
                   + '&limit=5000'; // 상품 쪽과 동일하게 5000으로 고정

        var url = cp + '/admin/etphist/api/list?' + params;

        console.log("Request URL:", url);

        fetch(url)
            .then(function(res) { 
                if(!res.ok) {
                    return res.json().then(function(errData) {
                        throw new Error(errData.message || '서버 내부 에러');
                    });
                }
                return res.json(); 
            })
            .then(function(data) {
            	// [추가] 상단 조회 건수 반영 (서비스에서 반환된 totalCnt 사용)
                var totalCountEl = document.getElementById('total-count-display');
                if (totalCountEl) {
                    totalCountEl.innerText = (data.totalCnt || 0).toLocaleString();
                }
                // [중요] 두 번째 파라미터로 currentPerPage를 넘겨 그리드 UI를 유지합니다.
                initGrid(data.list || [], currentPerPage);
            })
            .catch(function(err) {
                console.error('Fetch Error:', err);
                initGrid([], currentPerPage);
            });
    };

 	// 5. 그리드 초기화
    function initGrid(data, perPage) {
        var formattedData = (data || []).map(function(item) {
            var newItem = Object.assign({}, item); 
            if (newItem.regDtime) newItem.regDtime = newItem.regDtime.replace('T', ' ').split('.')[0];
            if (newItem.apprDtime) newItem.apprDtime = newItem.apprDtime.replace('T', ' ').split('.')[0];
            return newItem;
        });

        if (myGrid && myGrid.grid) {
            myGrid.allData = formattedData;
            myGrid.perPage = parseInt(perPage);
            myGrid.executeFiltering(true);
            setTimeout(function() { myGrid.grid.refreshLayout(); }, 50);
            return;
        }

        myGrid = new DataGrid({
            containerId: 'dg-container',
            searchId: 'dg-search-input',
            btnSearchId: 'dg-btn-search',
            paginationId: 'dg-pagination',
            perPageId: 'dg-per-page',
            data: formattedData,
            perPage: parseInt(perPage),
            columns: [
                { 
                    header: '주문번호', 
                    name: 'orderNo', 
                    width: 160, 
                    align: 'center',
                    renderer: {
                        type: class {
                            constructor(props) {
                                var el = document.createElement('span');
                                el.className = 'hist-link';
                                this.el = el;
                                this.render(props);
                            }
                            getElement() { return this.el; }
                            render(props) {
                                this.el.innerText = props.value || '-';
                            }
                        }
                    }
                },
                { 
                    header: '의사결정단계', 
                    name: 'etpSttsNm', 
                    width: 150, 
                    align: 'center',
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

                                // [수정] CamelCase와 SnakeCase 둘 다 대응하도록 변경
                                var code = String(row.etpSttsCd || row.etp_stts_cd || '').toLowerCase().trim();
                                var text = props.value || '-';
                                
                                var colorClass = 'stts-default';
                                if (code.includes('999')) colorClass = 'stts-reject';
                                else if (code.startsWith('et')) colorClass = 'stts-et';
                                else if (code.startsWith('od')) colorClass = 'stts-od';
                                else if (code.startsWith('pr')) colorClass = 'stts-pr';
                                else if (code.startsWith('pm')) colorClass = 'stts-pm';
                                else if (code.startsWith('dv')) colorClass = 'stts-dv';

                                // 배지 클래스 적용 (기존 스타일 시트에 정의된 클래스 사용)
                                this.el.className = 'stts-badge ' + colorClass;
                                this.el.innerText = text;
                            }
                        }
                    }
                },
                { header: '요청자', name: 'requestUserNm', width: 120, align: 'center' },
                { header: '요청일자', name: 'regDtime', width: 170, align: 'center' },
                { header: '승인자', name: 'apprUserNm', width: 120, align: 'center', formatter: (v) => v.value || '-' },
                { header: '승인일자', name: 'apprDtime', width: 170, align: 'center', formatter: (v) => v.value || '-' },
                { 
                    header: '반려사유', 
                    name: 'rejtRsn', 
                    width: 300, 
                    align: 'center', // [수정] 가운데 정렬로 변경
                    renderer: {
                        type: class {
                            constructor(props) {
                                var el = document.createElement('div');
                                // [수정] text-red-600으로 더 진하게, font-bold로 굵게, text-center로 중앙정렬
                                el.className = 'px-2 truncate text-red-600 font-bold text-center';
                                this.el = el;
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