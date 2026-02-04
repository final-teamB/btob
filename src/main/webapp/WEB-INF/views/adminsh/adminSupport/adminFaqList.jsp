<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- [1] 레이아웃 설정: datagrid.jsp의 검색 영역을 사용함 --%>
<c:set var="showSearchArea" value="true" scope="request" />
<c:set var="showAddBtn" value="true" scope="request" />

<%-- [2] 타이틀 영역 (패딩 포함) --%>
<div class="mx-4 my-6 space-y-6">
    <div class="px-5 py-4 pb-0">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">자주 묻는 질문 (FAQ) 관리</h1>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">시스템 데이터를 조회하고 관리합니다.</p>
    </div>

    <%-- [3] 데이터 그리드 인클루드 (여기에 검색 필터가 내장되어 있음) --%>
    <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp"/>
</div>

<script>
    // 서버 데이터 보관
    const rawData = [
        <c:forEach var="f" items="${faqList}" varStatus="status">
        {
            faqId: "${f.faqId}",
            category: "${f.category}",
            question: "${f.question}",
            regDtime: "${f.regDtime}"
        }${!status.last ? ',' : ''}
        </c:forEach>
    ];

    document.addEventListener('DOMContentLoaded', function() {
        // [1] datagrid.jsp 내부에 있는 '구분' 필터 활성화 및 옵션 추가
        const filterWrapper = document.getElementById('dg-common-filter-wrapper');
        const filterSelect = document.getElementById('dg-common-filter');
        
        if (filterWrapper && filterSelect) {
            filterWrapper.classList.remove('hidden'); // hidden 해제
            filterWrapper.classList.add('flex');
            
            // 카테고리 옵션 동적 삽입
            const categories = [
                { val: 'DELIVERY', text: '배송' },
                { val: 'PAYMENT', text: '결제' },
                { val: 'PRODUCT', text: '상품' },
                { val: 'ETC', text: '기타' }
            ];
            categories.forEach(cat => {
                const opt = document.createElement('option');
                opt.value = cat.val;
                opt.textContent = cat.text;
                filterSelect.appendChild(opt);
            });
        }

        // [2] 그리드 초기화
        const faqGrid = new DataGrid({
            containerId: 'dg-container',
            searchId: 'dg-search-input',      // datagrid.jsp의 검색창 ID
            btnSearchId: 'dg-btn-search',    // datagrid.jsp의 조회버튼 ID
            perPageId: 'dg-per-page',
            columns: [
                { header: 'ID', name: 'faqId', width: 80, align: 'center' },
                { 
                    header: '카테고리', name: 'category', width: 120, align: 'center',
                    formatter: ({value}) => {
                        const map = { 'DELIVERY': '배송', 'PAYMENT': '결제', 'PRODUCT': '상품', 'ETC': '기타' };
                        return map[value] || value;
                    }
                },
                { header: '질문', name: 'question', align: 'left' },
                { header: '등록일', name: 'regDtime', width: 180, align: 'center' },
                {
                    header: '관리',
                    name: 'manage',
                    width: 100,
                    align: 'center',
                    formatter: () => {
                        return '<button type="button" class="real-delete-btn px-3 py-1 text-xs font-bold text-white bg-red-500 rounded hover:bg-red-600 transition">삭제</button>';
                    }
                }
            ],
            data: rawData
        });

        // [3] datagrid.jsp의 조회 버튼 클릭 시 필터링 로직 연결
        document.getElementById('dg-btn-search').addEventListener('click', function() {
            const catVal = document.getElementById('dg-common-filter').value;
            const keyword = document.getElementById('dg-search-input').value.toLowerCase();

            const filtered = rawData.filter(item => {
                const matchCat = !catVal || item.category === catVal;
                const matchKey = !keyword || item.question.toLowerCase().includes(keyword);
                return matchCat && matchKey;
            });
            faqGrid.grid.resetData(filtered);
        });

        // [4] 행 클릭(수정) 및 삭제 버튼 이벤트
        faqGrid.grid.on('click', (ev) => {
            const rowData = faqGrid.grid.getRow(ev.rowKey);
            if (!rowData) return;

            if (ev.nativeEvent.target.classList.contains('real-delete-btn')) {
                if (confirm('삭제하시겠습니까?')) {
                    handleDelete(rowData.faqId);
                }
            } else if (ev.targetType === 'cell') {
                location.href = '/support/modifyFaq/' + rowData.faqId;
            }
        });
    });

    // 삭제 AJAX
    function handleDelete(faqId) {
        const params = new URLSearchParams();
        params.append('faqId', faqId);
        fetch('/support/removeFaq', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        })
        .then(res => res.json())
        .then(success => {
            if (success) { alert('삭제되었습니다.'); location.reload(); }
        });
    }

    // 신규 등록 버튼 연동
    function handleAddAction() {
        location.href = '/support/registerFaq';
    }
</script>

<style>
    .tui-grid-cell { cursor: pointer !important; }
    .real-delete-btn { pointer-events: auto !important; cursor: pointer !important; }
</style>