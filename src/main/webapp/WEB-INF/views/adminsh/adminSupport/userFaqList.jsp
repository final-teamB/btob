<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- [1] 전체 레이아웃 (관리자용 adminFaqList.jsp의 여백과 구조 동일하게 유지) --%>
<div class="mx-4 my-6 space-y-6">
    <div class="px-5 py-4 pb-0">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">자주 묻는 질문 (FAQ) 관리</h1>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">궁금하신 내용을 카테고리별로 확인하실 수 있습니다.</p>
    </div>

    <%-- [2] 카테고리 선택 영역 (필터 대신 버튼 탭 형태) --%>
    <div class="flex flex-wrap gap-2 px-5">
        <button onclick="filterCategory('ALL', this)" class="cat-btn active-cat px-6 py-2 rounded-full border text-sm font-bold transition">전체</button>
        <button onclick="filterCategory('DELIVERY', this)" class="cat-btn px-6 py-2 rounded-full border bg-white text-gray-600 text-sm font-bold transition">배송</button>
        <button onclick="filterCategory('PAYMENT', this)" class="cat-btn px-6 py-2 rounded-full border bg-white text-gray-600 text-sm font-bold transition">결제</button>
        <button onclick="filterCategory('PRODUCT', this)" class="cat-btn px-6 py-2 rounded-full border bg-white text-gray-600 text-sm font-bold transition">상품</button>
        <button onclick="filterCategory('ETC', this)" class="cat-btn px-6 py-2 rounded-full border bg-white text-gray-600 text-sm font-bold transition">기타</button>
    </div>

    <%-- [3] 검색 영역 (조회 버튼 사이즈 축소 및 정렬 수정) --%>
    <div class="p-4 bg-white rounded-lg shadow-sm border border-gray-100 dark:bg-gray-800 dark:border-gray-700">
        <div class="flex flex-col gap-1.5">
            <label class="text-xs font-bold text-gray-600 ml-1">검색어</label>
            <div class="flex items-center gap-2">
                <input type="text" id="user-search-input" placeholder="검색어를 입력하세요" 
                       class="w-72 border border-gray-300 rounded-lg px-4 py-2 text-sm outline-none focus:ring-2 focus:ring-blue-500 bg-white">
                <button onclick="renderUserList(1)" 
                        class="w-fit px-4 py-2 bg-gray-900 text-white rounded-lg text-xs font-bold hover:bg-gray-800 transition">
                    조회
                </button>
            </div>
        </div>
    </div>

    <%-- [4] 리스트 영역 (관리자 그리드 컬럼 구성 및 가로폭 매칭) --%>
    <div class="bg-white rounded-lg shadow-sm dark:bg-gray-800 border border-gray-100 dark:border-gray-700 overflow-hidden">
        <table class="w-full border-collapse table-fixed">
            <thead>
                <tr class="bg-gray-50 border-b border-gray-200">
                    <th class="w-20 px-4 py-4 text-xs font-bold text-gray-500 uppercase text-center">ID</th>
                    <th class="w-32 px-4 py-4 text-xs font-bold text-gray-500 uppercase text-center">카테고리</th>
                    <th class="px-4 py-4 text-xs font-bold text-gray-500 uppercase text-left">질문</th>
                    <th class="w-44 px-4 py-4 text-xs font-bold text-gray-500 uppercase text-center">등록일</th>
                </tr>
            </thead>
            <tbody id="user-list-body">
                </tbody>
        </table>
        <div id="no-data" class="hidden py-20 text-center text-gray-400 bg-white">검색 결과가 없습니다.</div>
    </div>
    
	<%-- [5] 페이징 영역 (구조 변경: 페이지당 개수 선택 + 중앙 페이징 + 우측 밸런스) --%>
    <div class="px-5 py-6 flex flex-col md:flex-row justify-between items-center gap-4 border-t border-gray-100 bg-gray-50/50">
        <div class="w-32">
            <select id="user-per-page" onchange="renderUserList(1)" class="w-full rounded-lg border border-gray-300 bg-white py-1.5 px-3 text-xs text-gray-700 outline-none focus:ring-2 focus:ring-blue-500">
                <option value="10" selected>10개씩</option>
                <option value="25">25개씩</option>
                <option value="50">50개씩</option>
            </select>
        </div>
        
        <%-- 중앙: 페이징 버튼 --%>
        <div id="user-pagination" class="flex justify-center items-center gap-1"></div>
        
        <%-- 우측: 밸런스용 빈 공간 (중앙 정렬 유지용) --%>
        <div class="hidden md:block w-32"></div>
    </div>

</div>

<script>
    // 서버 데이터 안전하게 바인딩
    const faqData = [
        <c:forEach var="f" items="${faqList}" varStatus="status">
        {
            faqId: "${f.faqId}",
            category: "${f.category}",
            question: `<c:out value="${f.question}" />`,
            answer: `<c:out value="${f.answer}" />`.replace(/`/g, '\\`').replace(/\$/g, '\\$'),
            regDtime: "${f.regDtime}"
        }${!status.last ? ',' : ''}
        </c:forEach>
    ];

    let currentCategory = 'ALL';
    const perPage = 10;

    function filterCategory(cat, btn) {
        currentCategory = cat;
        document.querySelectorAll('.cat-btn').forEach(b => {
            b.classList.remove('active-cat', 'bg-gray-900', 'text-white');
            b.classList.add('bg-white', 'text-gray-600');
        });
        btn.classList.add('active-cat', 'bg-gray-900', 'text-white');
        btn.classList.remove('bg-white', 'text-gray-600');
        renderUserList(1);
    }

    function renderUserList(page) {
        const kw = document.getElementById('user-search-input').value.toLowerCase();
        const perPage = parseInt(document.getElementById('user-per-page').value);
        const filtered = faqData.filter(d => 
            (currentCategory === 'ALL' || d.category === currentCategory) && 
            (d.question.toLowerCase().includes(kw))
        );

        const totalPages = Math.ceil(filtered.length / perPage) || 1;
        const items = filtered.slice((page - 1) * perPage, page * perPage);

        const body = document.getElementById('user-list-body');
        const noData = document.getElementById('no-data');

        if (filtered.length === 0) {
            body.innerHTML = ''; noData.classList.remove('hidden');
        } else {
            noData.classList.add('hidden');
            body.innerHTML = items.map(d => `
                <tr class="border-b border-gray-100 hover:bg-gray-50 cursor-pointer" onclick="toggleRow(this)">
                    <td class="px-4 py-5 text-sm text-center text-gray-400">\${d.faqId}</td>
                    <td class="px-4 py-5 text-center">
                        <span class="px-2 py-1 rounded text-[11px] font-bold \${getBadgeClass(d.category)}">\${getCatName(d.category)}</span>
                    </td>
                    <td class="px-4 py-5 text-[15px] font-medium text-gray-900">\${d.question}</td>
                    <td class="px-4 py-5 text-sm text-center text-gray-400">\${d.regDtime}</td>
                </tr>
                <tr class="hidden bg-gray-50 faq-answer-row">
                    <td colspan="4" class="px-20 py-8 border-b border-gray-200">
                        <div class="flex gap-4">
                            <span class="w-6 h-6 bg-gray-900 text-white rounded-full flex items-center justify-center text-[10px] font-bold flex-shrink-0">A</span>
                            <div class="text-[14px] text-gray-600 leading-relaxed whitespace-pre-wrap">\${d.answer}</div>
                        </div>
                    </td>
                </tr>
            `).join('');
        }
        renderPaging(totalPages, page);
    }

    function toggleRow(tr) {
        const next = tr.nextElementSibling;
        const isHidden = next.classList.contains('hidden');
        document.querySelectorAll('.faq-answer-row').forEach(row => row.classList.add('hidden'));
        if (isHidden) next.classList.remove('hidden');
    }

    function renderPaging(total, current) {
        const pagin = document.getElementById('user-pagination');
        let html = '';
        for (let i = 1; i <= total; i++) {
            // 관리자용(datagrid.jsp)과 동일한 클래스 및 간격(mx-0.5) 적용
            const active = i === current 
                ? 'bg-gray-900 text-white border-gray-900' 
                : 'bg-white text-gray-600 border-gray-300 hover:bg-gray-100';
            
            html += `<button onclick="renderUserList(\${i})" class="mx-0.5 w-8 h-8 rounded border \${active} text-xs font-bold transition shadow-sm">\${i}</button>`;
        }
        pagin.innerHTML = html;
    }

    function getCatName(c) { return {'DELIVERY':'배송','PAYMENT':'결제','PRODUCT':'상품','ETC':'기타'}[c] || c; }
    function getBadgeClass(c) { 
        return {'DELIVERY':'bg-blue-50 text-blue-600','PAYMENT':'bg-green-50 text-green-600','PRODUCT':'bg-purple-50 text-purple-600','ETC':'bg-gray-100 text-gray-600'}[c] || ''; 
    }

    document.addEventListener('DOMContentLoaded', () => renderUserList(1));
</script>

<style>
    .active-cat { border-color: #111827 !important; background-color: #111827 !important; color: white !important; }
    .cat-btn:hover:not(.active-cat) { border-color: #111827; color: #111827; }
</style>