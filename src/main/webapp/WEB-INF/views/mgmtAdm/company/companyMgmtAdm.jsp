<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="cp" value="${pageContext.request.contextPath}" />

<%-- 1. 스타일 정의 --%>
<style>
    /* 상태 배지 스타일 */
    .stts-badge {
        padding: 4px 10px;
        border-radius: 9999px;
        font-size: 12px;
        font-weight: 700;
        display: inline-block;
        min-width: 60px;
        text-align: center;
    }
    .stts-y { background-color: #ecfdf5; color: #059669; border: 1px solid #a7f3d0; } /* 사용중 */
    .stts-n { background-color: #fef2f2; color: #dc2626; border: 1px solid #fecaca; } /* 미사용 */

    .comp-link { 
        color: #2563eb; 
        font-weight: 600; 
        cursor: pointer; 
        text-decoration: underline;
    }
    #dg-container { width: 100%; margin-top: 1rem; }
</style>

<div class="max-w-screen-2xl mx-auto">
    <%-- 상단 헤더 및 버튼 영역 --%>
    <div class="bg-white p-8 rounded-xl shadow-lg border border-gray-100 dark:bg-gray-800 dark:border-gray-700">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4">
            <div>
                <div class="flex items-center gap-3">
                    <h2 class="text-2xl font-bold text-gray-900 dark:text-white">회사 관리</h2>
                    <span class="bg-blue-100 text-blue-700 text-xs font-bold px-2.5 py-0.5 rounded-full">
                        전체 <span id="total-count-display">0</span>건
                    </span>
                </div>
                <p class="text-sm text-gray-500 mt-1">플랫폼 가입 회사 정보를 조회하고 관리합니다.</p>
            </div>
            
            <div class="flex flex-wrap items-center gap-2">
                <%-- 엑셀 관련 버튼 --%>
                <button type="button" onclick="CompanyExcelHandler.downloadTemplate()"
                    class="px-3 py-1.5 text-sm font-medium text-gray-700 bg-white border border-gray-200 rounded-lg hover:bg-gray-50 transition">
                    양식 다운로드
                </button>
                <button type="button" onclick="CompanyExcelHandler.openUploadModal()"
                    class="px-3 py-1.5 text-sm font-medium text-white bg-green-600 rounded-lg hover:bg-green-700 transition">
                    엑셀 업로드
                </button>
                <button type="button" onclick="CompanyExcelHandler.downloadExcel()"
                    class="px-3 py-1.5 text-sm font-medium text-gray-700 bg-white border border-gray-200 rounded-lg hover:bg-gray-50 transition">
                    목록 다운로드
                </button>
                <%-- 신규 등록 버튼 --%>
                <button type="button" onclick="openRegisterModal()"
                    class="px-4 py-2 text-sm font-bold text-white bg-blue-600 rounded-lg hover:bg-blue-700 shadow-md transition-all">
                    신규 회사 등록
                </button>
            </div>
        </div>

        <%-- 데이터그리드 영역 --%>
        <div class="grid-relative-wrapper">
            <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp">
                <jsp:param name="showSearchArea" value="true" />
                <jsp:param name="showPerPage" value="true" />
            </jsp:include>
        </div>
    </div>
</div>

<%-- 등록/수정 모달 및 엑셀 업로드 모달 include (필요시 파일명 확인) --%>
<%-- <jsp:include page="companyRegisterModal.jsp" /> --%>
<%-- <jsp:include page="companyExcelUploadModal.jsp" /> --%>

<script>
    var contextPath = '${pageContext.request.contextPath}';
    if(contextPath === '/') contextPath = '';
    var cp = window.location.origin + contextPath;
    
    var companyGrid;

    document.addEventListener('DOMContentLoaded', function() {
        // 검색어 입력 시 디바운싱 처리
        var searchInput = document.getElementById('dg-search-input');
        if (searchInput) {
            var debounceTimer;
            searchInput.addEventListener('input', function() {
                clearTimeout(debounceTimer);
                debounceTimer = setTimeout(function() {
                    window.fetchData(); 
                }, 300);
            });
        }
        
        window.fetchData();
    });

    /**
     * 데이터 조회 함수
     */
    window.fetchData = function() {
        var searchInput = document.getElementById('dg-search-input');
        var searchVal = (searchInput && searchInput.value) ? searchInput.value : '';
        
        var perPageEl = document.getElementById('dg-per-page');
        var currentPerPage = (perPageEl && perPageEl.value) ? parseInt(perPageEl.value) : 10;

        // API 호출 파라미터 구성 (상품관리와 동일하게 limit 5000 고정 후 그리드 페이징)
        var params = 'searchCondition=' + encodeURIComponent(searchVal) 
                   + '&startRow=0' 
                   + '&limit=5000'; 

        var url = cp + '/admin/company/api/list?' + params;

        fetch(url)
            .then(function(res) { return res.json(); })
            .then(function(data) {
                var totalCountEl = document.getElementById('total-count-display');
                if (totalCountEl) {
                    totalCountEl.innerText = (data.totalCnt || 0).toLocaleString();
                }
                initGrid(data.list || [], currentPerPage);
            })
            .catch(function(err) {
                console.error('Fetch Error:', err);
                initGrid([], currentPerPage);
            });
    };

    /**
     * 그리드 초기화
     */
    function initGrid(data, perPage) {
        // 날짜 포맷팅 등 전처리
        var formattedData = (data || []).map(function(item) {
            var newItem = Object.assign({}, item); 
            // 등록일시 포맷팅 (시분초 포함)
            if (newItem.regDtime) newItem.regDtime = newItem.regDtime.replace('T', ' ').split('.')[0];
            // [추가] 수정일시 포맷팅 (시분초 포함)
            if (newItem.updDtime) newItem.updDtime = newItem.updDtime.replace('T', ' ').split('.')[0];
            else newItem.updDtime = '-';
            
            return newItem;
        });

        // 이미 그리드가 존재하는 경우 데이터만 업데이트
        if (companyGrid && companyGrid.grid) {
            companyGrid.allData = formattedData;
            companyGrid.perPage = parseInt(perPage);
            companyGrid.executeFiltering(true);
            setTimeout(function() { companyGrid.grid.refreshLayout(); }, 50);
            return;
        }

        // 그리드 신규 생성
        companyGrid = new DataGrid({
            containerId: 'dg-container',
            searchId: 'dg-search-input',
            paginationId: 'dg-pagination',
            perPageId: 'dg-per-page',
            data: formattedData,
            perPage: parseInt(perPage),
            columns: [
                { 
                    header: '회사코드', 
                    name: 'companyCd', 
                    width: 180, 
                    align: 'center',
                    renderer: {
                        type: class {
                            constructor(props) {
                                var el = document.createElement('span');
                                el.className = 'comp-link';
                                el.onclick = function() { openModifyModal(props.grid.getRow(props.rowKey).companySeq); };
                                this.el = el;
                                this.render(props);
                            }
                            getElement() { return this.el; }
                            render(props) { this.el.innerText = props.value || '-'; }
                        }
                    }
                },
                { header: '회사명', name: 'companyName', width: 200, align: 'left' },
                { header: '대표자명', name: 'userName', width: 120, align: 'center' },
                { header: '연락처', name: 'companyPhone', width: 150, align: 'center' },
                { header: '사업자번호', name: 'bizNumber', width: 150, align: 'center' },
                { header: '통관번호', name: 'customsNum', width: 150, align: 'center', formatter: (v) => v.value || '-' },
                { 
                    header: '상태', 
                    name: 'useYn', 
                    width: 100, 
                    align: 'center',
                    renderer: {
                        type: class {
                            constructor(props) {
                                this.el = document.createElement('span');
                                this.render(props);
                            }
                            getElement() { return this.el; }
                            render(props) {
                                var val = props.value === 'Y' ? '사용중' : '미사용';
                                var colorClass = props.value === 'Y' ? 'stts-y' : 'stts-n';
                                this.el.className = 'stts-badge ' + colorClass;
                                this.el.innerText = val;
                            }
                        }
                    }
                },
                { header: '등록일시', name: 'regDtime', width: 160, align: 'center' },
                { header: '수정일시', name: 'updDtime', width: 160, align: 'center' }
            ]
        });
    }

    /**
     * 모달 열기 함수 (등록/수정)
     */
    function openRegisterModal() {
        if (typeof CompanyRegisterModal !== 'undefined') {
            CompanyRegisterModal.open('REG');
        } else {
            alert('등록 모달 스크립트가 로드되지 않았습니다.');
        }
    }

    function openModifyModal(companySeq) {
        if (typeof CompanyRegisterModal !== 'undefined') {
            CompanyRegisterModal.open('MOD', companySeq);
        } else {
            alert('수정 모달 스크립트가 로드되지 않았습니다.');
        }
    }

    /**
     * 엑셀 처리 핸들러
     */
    var CompanyExcelHandler = {
        downloadTemplate: function() {
            window.location.href = cp + '/admin/company/download/template';
        },
        downloadExcel: function() {
            var searchVal = document.getElementById('dg-search-input')?.value || '';
            window.location.href = cp + '/admin/company/download/excel?isExcel=Y&searchCondition=' + encodeURIComponent(searchVal);
        },
        openUploadModal: function() {
            // 엑셀 업로드 모달 오픈 로직
            if (typeof CompanyExcelUploadModal !== 'undefined') {
                CompanyExcelUploadModal.show();
            }
        }
    };
</script>