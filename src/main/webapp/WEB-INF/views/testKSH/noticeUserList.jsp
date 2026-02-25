<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- [1] 레이아웃 설정: 검색바 노출, 등록 버튼 미노출 --%>
<c:set var="showSearchArea" value="true" scope="request" />
<c:set var="showAddBtn" value="false" scope="request" />

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
    /* [1] 그리드 및 레이아웃 스타일 (ADMIN 기준 이식) */
    .tui-grid-cell { cursor: pointer !important; }
    #dg-container { width: 100%; margin-top: 1rem; }
    .grid-relative-wrapper { position: relative; width: 100%; }

    /* [2] 필터 및 검색창 스타일 강화 */
    #dg-common-filter-wrapper select, 
    #dg-search-input {
        padding-left: 1rem !important;
        padding-right: 2.5rem !important;
        height: 42px !important;
        border-radius: 8px !important;
        border: 1px solid #e2e8f0 !important;
    }

    /* [3] 라벨 텍스트 가시성 */
    .filter-label, div.text-sm.font-bold { 
        margin-bottom: 0.5rem !important;
        display: inline-block;
        color: #475569;
    }
</style>

<div class="max-w-screen-2xl mx-auto">
    <div class="bg-white p-8 rounded-xl shadow-lg border border-gray-100 dark:bg-gray-800 dark:border-gray-700">

        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4">
            <div>
                <h2 class="text-2xl font-bold text-gray-900 dark:text-white">공지사항</h2>
                <p class="text-sm text-gray-500 mt-1">시스템의 최신 소식을 확인하세요.</p>
            </div>
        </div>

        <div class="grid-relative-wrapper">
            <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp"/>
        </div>
    </div>
</div>

<script>
    // 1. 서버 데이터 바인딩 (ADMIN 기준: c:out 적용)
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

        // [카테고리 필터 설정 - ADMIN 기준 동일 이식]
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

        // [실시간 검색 Debounce 적용]
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
                { 
                    header: '카테고리', name: 'category', width: 180, align: 'center',
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
                { header: '작성자', name: 'displayRegId', width: 150, align: 'center' },
                { header: '등록일', name: 'regDtime', width: 180, align: 'center', sortable: true },
                { header: '조회수', name: 'viewCount', width: 100, align: 'center', sortable: true }
            ],
            data: rawData
        });
        
        // [검색 및 필터 통합 로직 - 중복 제거 및 ADMIN 방식 적용]
        btnSearch.addEventListener('click', function() {
            const catVal = filterSelect ? filterSelect.value : '';
            const keyword = searchInput.value.toLowerCase();

            const filtered = rawData.filter(item => {
                const matchCat = !catVal || item.category === catVal;
                const matchKey = !keyword || item.title.toLowerCase().includes(keyword);
                return matchCat && matchKey;
            });
            noticeGrid.grid.resetData(filtered);
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