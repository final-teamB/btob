<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%-- [1] 레이아웃 설정: 첨부파일과 동일하게 datagrid.jsp의 검색 영역을 사용함 [cite: 1] --%>
<c:set var="showSearchArea" value="true" scope="request" />
<sec:authorize access="hasRole('ADMIN')">
    <c:set var="showAddBtn" value="true" scope="request" />
</sec:authorize>

<%-- [2] 타이틀 영역 --%>
<div class="mx-4 my-6 space-y-6">
    <div class="px-5 py-4 pb-0 flex flex-col md:flex-row justify-between items-center">
        <div>
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white">자주 묻는 질문 (FAQ) 관리</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">질문을 클릭하여 상세 내용을 확인하거나 관리자가 데이터를 관리합니다.</p>
        </div>
    </div>

    <%-- [3] 데이터 그리드 인클루드 [cite: 1] --%>
    <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp"/>
</div>

<script>
    // [1] 서버 데이터 보관 (rawData 형식 유지) [cite: 2]
    const rawData = [
        <c:forEach var="f" items="${faqList}" varStatus="status">
        {
            faqId: "${f.faqId}",
            categoryLabel: "${f.category.label}",
            categoryValue: "${f.category}",
            question: "${f.question}",
            answer: `${f.answer.replace('`', '\\`')}`, 
            regDtime: "${f.regDtime}"
        }${!status.last ? ',' : ''} <%-- [cite: 3] --%>
        </c:forEach>
    ];

    // 관리자 여부 체크
    const isAdmin = <sec:authorize access="hasRole('ADMIN')">true</sec:authorize><sec:authorize access="!hasRole('ADMIN')">false</sec:authorize>;

    document.addEventListener('DOMContentLoaded', function() { <%-- [cite: 4] --%>
        // [2] 카테고리 필터 활성화 (첨부파일 로직 적용) [cite: 4, 7]
        const filterWrapper = document.getElementById('dg-common-filter-wrapper');
        const filterSelect = document.getElementById('dg-common-filter');
        
        if (filterWrapper && filterSelect) {
            filterWrapper.classList.remove('hidden');
            filterWrapper.classList.add('flex');
            
            const categories = [
                { val: 'GENERAL', text: '일반' },
                { val: 'ACCOUNT', text: '계정' },
                { val: 'PAYMENT', text: '결제' }
            ];
            categories.forEach(cat => {
                const opt = document.createElement('option');
                opt.value = cat.val;
                opt.textContent = cat.text;
                filterSelect.appendChild(opt); <%-- [cite: 7] --%>
            });
        }

        // [3] 그리드 초기화 [cite: 7, 8]
        const faqGrid = new DataGrid({
            containerId: 'dg-container',
            searchId: 'dg-search-input',
            btnSearchId: 'dg-btn-search',
            perPageId: 'dg-per-page',
            columns: [
                { header: '카테고리', name: 'categoryLabel', width: 120, align: 'center' },
                { header: '질문', name: 'question', align: 'left' },
                { header: '등록일', name: 'regDtime', width: 180, align: 'center' },
                {
                    header: '관리',
                    name: 'manage',
                    width: 120,
                    align: 'center',
                    formatter: () => {
                        const btnText = isAdmin ? '수정/삭제' : '답변보기';
                        const btnClass = isAdmin ? 'bg-blue-600 hover:bg-blue-700' : 'bg-gray-800 hover:bg-black';
                        return `<button type="button" class="action-btn px-3 py-1 text-xs font-bold text-white \${btnClass} rounded transition">\${btnText}</button>`;
                    }
                }
            ],
            data: rawData
        });

        // [4] 조회 버튼 필터링 로직 연결 [cite: 14]
        document.getElementById('dg-btn-search').addEventListener('click', function() {
            const catVal = document.getElementById('dg-common-filter').value;
            const keyword = document.getElementById('dg-search-input').value.toLowerCase();

            const filtered = rawData.filter(item => {
                const matchCat = !catVal || item.categoryValue === catVal;
                const matchKey = !keyword || item.question.toLowerCase().includes(keyword);
                return matchCat && matchKey;
            });
            faqGrid.grid.resetData(filtered); <%-- [cite: 15] --%>
        });

        // [5] 행 클릭 이벤트: 답변보기 또는 수정 페이지 이동 [cite: 16]
        faqGrid.grid.on('click', (ev) => {
            const rowData = faqGrid.grid.getRow(ev.rowKey);
            if (!rowData) return;

            if (isAdmin) {
                // 관리자: 수정 페이지로 이동 (첨부파일의 handleDelete 대신 이동 로직 적용) [cite: 17]
                location.href = '/support/modifyFaq/' + rowData.faqId;
            } else {
                // 사용자: 답변 펼치기
                toggleAnswerRow(rowData, ev.nativeEvent);
            }
        });
    });

    // 일반 사용자용 답변 토글 로직
    function toggleAnswerRow(data, event) {
        const btn = event.target.closest('button') || event.target;
        const currentRow = event.target.closest('tr');
        const nextRow = currentRow.nextElementSibling;

        if (nextRow && nextRow.classList.contains('answer-row')) {
            nextRow.remove();
            if(btn.classList.contains('action-btn')) btn.innerText = '답변보기';
            return;
        }

        document.querySelectorAll('.answer-row').forEach(row => row.remove());
        
        const answerRow = document.createElement('tr');
        answerRow.className = 'answer-row bg-gray-50';
        const formattedAnswer = data.answer.replace(/\n/g, '<br>');
        answerRow.innerHTML = `
            <td colspan="4" class="p-4 border-b">
                <div class="px-8 py-2 text-gray-600 line-height-relaxed">
                    <strong class="text-blue-600">A.</strong> \${formattedAnswer}
                </div>
            </td>
        `;
        currentRow.after(answerRow);
        if(btn.classList.contains('action-btn')) btn.innerText = '답변닫기';
    }

    // 신규 등록 버튼 연동 (첨부파일과 동일) [cite: 20]
    function handleAddAction() {
        location.href = '/support/registerFaq'; <%-- [cite: 20] --%>
    }
</script>

<style>
    .tui-grid-cell { cursor: pointer !important; }
    .action-btn { pointer-events: auto !important; cursor: pointer !important; } <%-- [cite: 21, 22] --%>
    .answer-row { animation: fadeIn 0.3s ease-out; }
    @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
</style>