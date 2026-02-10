<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cp" value="${pageContext.request.contextPath}" />

<%-- 1. 스타일 정의 (상품관리와 동일한 컨테이너 클래스 유지) --%>
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
                <h2 class="text-2xl font-bold text-gray-900 dark:text-white">주문 히스토리 이력 관리</h2>
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
        // [추가] 날짜 형식 가공 (T 제거)
        // 데이터가 들어올 때마다 미리 가공해서 넣어주면 렌더링이 깔끔합니다.
        var formattedData = (data || []).map(function(item) {
            var newItem = Object.assign({}, item); // 원본 데이터 보존을 위한 복사
            if (newItem.regDtime && typeof newItem.regDtime === 'string') {
                newItem.regDtime = newItem.regDtime.replace('T', ' ').split('.')[0];
            }
            if (newItem.apprDtime && typeof newItem.apprDtime === 'string') {
                newItem.apprDtime = newItem.apprDtime.replace('T', ' ').split('.')[0];
            }
            return newItem;
        });

        // 기존 그리드가 존재할 경우 (업데이트 모드)
        if (myGrid && myGrid.grid) {
            myGrid.allData = formattedData; // 가공된 데이터 할당
            myGrid.perPage = parseInt(perPage); // 페이지당 개수 동기화
            myGrid.executeFiltering(true);
            return;
        }

        // 그리드 최초 생성 시
        myGrid = new DataGrid({
            containerId: 'dg-container',
            searchId: 'dg-search-input',
            btnSearchId: 'dg-btn-search',
            paginationId: 'dg-pagination',
            perPageId: 'dg-per-page',
            data: formattedData,
            perPage: parseInt(perPage),
            columns: [
                // { header: '순번', name: 'rownm', width: 70, align: 'center' }, <-- 이 줄을 삭제했습니다.
                { 
                    header: '주문번호', name: 'etpId', width: 140, align: 'center',
                    renderer: {
                        type: class {
                            constructor(props) {
                                var el = document.createElement('span');
                                el.className = 'hist-link';
                                el.innerText = props.value;
                                this.el = el;
                            }
                            getElement() { return this.el; }
                        }
                    }
                },
                { header: '의사결정단계', name: 'etpSttsNm', width: 180, align: 'center' },
                { header: '요청자', name: 'requestUserNm', width: 120, align: 'center' },
                { header: '요청일자', name: 'regDtime', width: 180, align: 'center' },
                { header: '승인자', name: 'apprUserNm', width: 120, align: 'center' },
                { header: '반려사유', name: 'rejtRsn', width: 300, align: 'left' }
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