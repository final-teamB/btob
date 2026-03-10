<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- [1] 레이아웃 설정: 검색바 노출, 등록 버튼 미노출 (사용자용이므로) --%>
<c:set var="showSearchArea" value="true" scope="request" />
<c:set var="showAddBtn" value="false" scope="request" />

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
    /* [1] 배경 및 기본 컨테이너 설정 - 요청하신 관리자 스타일 이식 */
    body { background-color: #f9fafb; }
    
    .admin-main-container { 
        width: 100%;
        min-height: auto;
        padding-bottom: 0.25rem;
        margin-bottom: 0 !important;
    }

    #dg-container { width: 100%; margin-top: 1rem; }
    .grid-relative-wrapper { position: relative; width: 100%; min-height: 400px; }

    /* [3] 그리드 셀 높이 및 정렬 통일 (관리자 CSS와 동일) */
    .tui-grid-container .tui-grid-cell {
        height: 52px !important; 
        background-color: #fff !important;
        cursor: pointer !important;
    }

    .tui-grid-container .tui-grid-cell-content {
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        height: 52px !important;
        padding: 0 !important;
        line-height: normal !important;
    }

    .tui-grid-container .tui-grid-cell[data-column-name="title"] .tui-grid-cell-content {
        justify-content: flex-start !important;
        padding-left: 1.5rem !important;
    }

    .tui-grid-border-line { display: none !important; }
</style>

<div class="admin-main-container my-6">
    <%-- 상단 헤더 영역 --%>
    <div class="px-10 py-4 flex flex-col md:flex-row justify-between items-start md:items-center">
        <div class="w-full text-left">
            <div class="flex items-center gap-3">
                <h2 class="text-2xl font-bold text-gray-900">공지사항</h2>
            </div>
            <p class="text-sm text-gray-500 mt-1">시스템의 최신 소식을 확인하세요.</p>
        </div>
    </div>

    <%-- 그리드 영역 --%>
    <div class="px-3">
        <div class="grid-card px-6">
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
    // 1. 서버 데이터 바인딩
    const rawData = [
        <c:forEach var="item" items="${noticeList}" varStatus="status">
        {
            noticeId: "${item.noticeId}",
            category: "${item.category}",
            title: `<c:out value="${item.title}"/>`,
            displayRegId: "관리자", 
            regDtime: "${item.formattedRegDate}",
            viewCount: "${item.viewCount}"
        }${!status.last ? ',' : ''}
        </c:forEach>
    ];

    document.addEventListener('DOMContentLoaded', function() {
        const filterWrapper = document.getElementById('dg-common-filter-wrapper');
        const filterSelect = document.getElementById('dg-common-filter');
        const searchInput = document.getElementById('dg-search-input');
        const btnSearch = document.getElementById('dg-btn-search');

        // [카테고리 필터 설정]
        if (filterWrapper && filterSelect) {
            filterWrapper.classList.remove('hidden');
            filterWrapper.classList.add('flex');

            const categories = [
                { val: '일반', text: '일반' },
                { val: '안내', text: '안내' },
                { val: '점검', text: '점검' },
                { val: '업데이트', text: '업데이트' }
            ];

            filterSelect.innerHTML = '<option value="">전체 카테고리</option>';
            categories.forEach(cat => {
                const opt = document.createElement('option');
                opt.value = cat.val;
                opt.textContent = cat.text;
                filterSelect.appendChild(opt);
            });

            filterSelect.addEventListener('change', () => btnSearch.click());
        }

        // [실시간 검색 Debounce]
        if (searchInput) {
            let searchTimeout;
            searchInput.addEventListener('input', () => {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    btnSearch.click();
                }, 300);
            });
        }
        
        // [그리드 초기화]
        const noticeGrid = new DataGrid({
            containerId: 'dg-container',
            searchId: 'dg-search-input',
            btnSearchId: 'dg-btn-search',
            perPageId: 'dg-per-page',
            columns: [
                { header: '번호', name: 'noticeId', width: 80, align: 'center', sortable: true },
                { 
                    header: '카테고리', name: 'category', width: 120, align: 'center',
                    formatter: function(props) {
                        const val = props.value;
                        if (!val) return '-';

                        const badgeStyles = {
                            '일반': 'bg-gray-100 text-gray-600',
                            '안내': 'bg-blue-50 text-blue-600',
                            '점검': 'bg-red-50 text-red-600', 
                            '업데이트': 'bg-green-50 text-green-600'
                        };
                        
                        const styleClass = badgeStyles[val] || 'bg-gray-100 text-gray-500';
                        return '<span class="px-2 py-1 rounded text-[11px] font-bold ' + styleClass + '">' + val + '</span>';
                    }
                },
                { header: '제목', name: 'title', align: 'left', sortable: true },
                { header: '작성자', name: 'displayRegId', width: 120, align: 'center' },
                { header: '등록일', name: 'regDtime', width: 180, align: 'center', sortable: true },
                { header: '조회수', name: 'viewCount', width: 100, align: 'center', sortable: true }
            ],
            data: rawData
        });
        
        // [검색 및 필터 통합 로직]
        btnSearch.addEventListener('click', function() {
            const catVal = filterSelect ? filterSelect.value : '';
            const keyword = searchInput.value.toLowerCase();

            const filtered = rawData.filter(item => {
                const matchCat = !catVal || item.category === catVal;
                const matchKey = !keyword || item.title.toLowerCase().includes(keyword);
                return matchCat && matchKey;
            });
            noticeGrid.grid.resetData(filtered);
            
            // 건수 업데이트
            const countDisplay = document.getElementById('total-count-display');
            if(countDisplay) countDisplay.innerText = filtered.length;
        });

        // [행 클릭 시 상세 페이지 이동]
        noticeGrid.grid.on('click', (ev) => {
            const rowData = noticeGrid.grid.getRow(ev.rowKey);
            if (rowData && ev.targetType === 'cell') {
                location.href = '/notice/user/detail/' + rowData.noticeId;
            }
        });
    });
</script>