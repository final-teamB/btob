<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="showSearchArea" value="true" scope="request" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
    .tui-grid-cell { cursor: pointer !important; }
    .real-delete-btn { pointer-events: auto !important; cursor: pointer !important; }

    /* 사용자 관리와 동일한 입력/필터 톤 */
    #dg-container { width: 100%; margin-top: 1rem; }
    .grid-relative-wrapper { position: relative; width: 100%; }

    #dg-common-filter-wrapper select,
    #dg-search-input {
        padding-left: 1rem !important;
        padding-right: 2.5rem !important;
    }
    
    /* FAQ 삭제 버튼 저장 버튼이랑 동일하게 강제 */
	.tui-grid-body-area td[data-column-name="manage"] button {
	    padding: 0.25rem 0.75rem !important;   /* px-3 py-1 */
	    font-size: 0.75rem !important;         /* text-xs */
	    font-weight: 700 !important;           /* font-bold */
	    color: #1d4ed8 !important;             /* text-blue-700 */
	    background-color: #ffffff !important;  /* bg-white */
	    border: 1px solid #60a5fa !important;  /* border-blue-400 */
	    border-radius: 0.375rem !important;    /* rounded-md */
	    text-decoration: none !important;     /* 밑줄 제거 */
	    transition: background-color 0.2s ease !important;
	}
	
	.tui-grid-body-area td[data-column-name="manage"] button:hover {
	    background-color: #eff6ff !important;  /* hover:bg-blue-50 */
	}
	
	/* 1. 필터 셀렉트 박스 및 검색창 크기 확대 */
    #dg-common-filter-wrapper select, 
    #dg-search-category, 
    #dg-search-input {
        padding-left: 1rem !important;
        padding-right: 2.5rem !important;
    }

    /* 2. '구분', '검색어' 라벨 텍스트 크기 확대 */
    .search-group label, 
    .filter-label,
    div.text-sm.font-bold { 
        margin-bottom: 0.5rem !important;
        display: inline-block;
    }
</style>

<div class="max-w-screen-2xl mx-auto">
    <div class="bg-white p-8 rounded-xl shadow-lg border border-gray-100 dark:bg-gray-800 dark:border-gray-700">

        <!-- 상단 타이틀 영역 -->
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4">
            <div>
                <div class="flex items-center gap-3">
                    <h2 class="text-2xl font-bold text-gray-900 dark:text-white">
                        자주 묻는 질문 (FAQ) 관리
                    </h2>
                    <span class="bg-blue-100 text-blue-700 text-xs font-bold px-2.5 py-0.5 rounded-full dark:bg-blue-900 dark:text-blue-300">
                        ADMIN
                    </span>
                </div>
                <p class="text-sm text-gray-500 mt-1">
                    자주 묻는 질문을 조회하고 수정 및 삭제할 수 있습니다.
                </p>
            </div>

            <div class="flex items-center gap-2">
                <button type="button" onclick="handleAddAction()"
                        class="px-3 py-1.5 text-sm font-semibold text-white bg-blue-600 rounded-lg hover:bg-blue-700 transition active:scale-95 flex items-center">
                    <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M12 4v16m8-8H4"></path>
                    </svg>
                    FAQ 등록
                </button>
            </div>
        </div>

        <!-- 데이터그리드 영역 -->
        <div class="grid-relative-wrapper">
            <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp"/>
        </div>
    </div>
</div>

<div id="faqModal" tabindex="-1" aria-hidden="true" data-modal-backdrop="static" 
     class="fixed inset-0 z-50 hidden flex items-center justify-center bg-black/50 overflow-y-auto">
    <div class="relative w-full max-w-4xl p-4 mx-auto">
        <div class="relative bg-white rounded-xl border border-gray-200 dark:bg-gray-800 dark:border-gray-700">
            <div class="flex items-center justify-between p-4 border-b">
                <h2 class="text-xl font-bold text-gray-900 dark:text-white">자주 묻는 질문 설정</h2>
                <button type="button" onclick="closeFaqModal()" class="text-gray-400 hover:text-gray-900 ml-auto p-2">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>
            <div id="faqModalContent"></div>
        </div>
    </div>
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
        
        const filterWrapper = document.getElementById('dg-common-filter-wrapper');
        const filterSelect = document.getElementById('dg-common-filter');
        const searchInput = document.getElementById('dg-search-input');
        const btnSearch = document.getElementById('dg-btn-search');
        
        if (filterWrapper && filterSelect) {
            filterWrapper.classList.remove('hidden'); 
            filterWrapper.classList.add('flex');
            
            // 카테고리 옵션 동적 삽입
            const categories = [
                { val: 'DELIVERY', text: '배송' },
                { val: 'PAYMENT', text: '결제' },
                { val: 'PRODUCT', text: '상품' },
                { val: 'ETC', text: '기타' }
            ];
            
            filterSelect.innerHTML = '<option value="">전체 카테고리</option>';
            categories.forEach(cat => {
                const opt = document.createElement('option');
                opt.value = cat.val;
                opt.textContent = cat.text;
                filterSelect.appendChild(opt);
            });
            
            // 필터 셀렉트 변경 시 즉시 검색
            filterSelect.addEventListener('change', () => {
                btnSearch.click();
            });
            
            // 검색어 입력 시 실시간 검색
            if (searchInput) {
		        let searchTimeout;
		        searchInput.addEventListener('input', () => {
		            clearTimeout(searchTimeout);
		            searchTimeout = setTimeout(() => {
		                btnSearch.click();
		            }, 300);
		        });
		    }
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
                    formatter: function(props) {
                        const val = props.value;
                        if (!val) return '-';

                        const map = { 'DELIVERY': '배송', 'PAYMENT': '결제', 'PRODUCT': '상품', 'ETC': '기타' };
                        const labelName = map[val] || val;

                        const badgeStyles = {
                            'DELIVERY': 'bg-blue-50 text-blue-600 dark:bg-blue-900/30 dark:text-blue-400',
                            'PAYMENT': 'bg-green-50 text-green-600 dark:bg-green-900/30 dark:text-green-400',
                            'PRODUCT': 'bg-purple-50 text-purple-600 dark:bg-purple-900/30 dark:text-purple-400',
                            'ETC': 'bg-gray-100 text-gray-600 dark:bg-gray-700 dark:text-gray-400'
                        };
                        
                        const styleClass = badgeStyles[val] || 'bg-gray-100 text-gray-500';
                        
                        return '<span class="px-2 py-1 rounded text-[11px] font-bold ' + styleClass + '">' + labelName + '</span>';
                    }
                },
                { header: '질문', name: 'question', align: 'left' },
                { header: '등록일', name: 'regDtime', width: 180, align: 'center' },
                {
                    header: '관리',
                    name: 'manage',
                    width: 120,
                    align: 'center',
                    formatter: () => {
                        return `
                            <button type="button"
                                class="real-delete-btn px-3 py-1 text-xs font-bold text-blue-700 border border-blue-400 rounded-md hover:bg-blue-50">
                                삭제
                            </button>
                        `;
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
                if (confirm('삭제하시겠습니까?')) handleDelete(rowData.faqId);
            } else if (ev.targetType === 'cell') {
                openFaqModal(rowData.faqId); // 수정 모달 열기
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
    	openFaqModal(0);
    }
    
 // 모달 열기 함수 (AJAX로 폼 불러오기)
    function openFaqModal(faqId) {
    	const url = faqId > 0 ? '/support/modifyFaq/' + faqId : '/support/registerFaq';
        
        $.ajax({
            url: url + "?isModal=Y",
            type: "GET",
            success: function(html) {
                $('#faqModalContent').html(html);
                $('#faqModal').removeClass('hidden');
                document.body.style.overflow = 'hidden';
            }
        });
    }

    function closeFaqModal() {
    	$('#faqModal').addClass('hidden');
        document.body.style.overflow = 'auto';
    }
</script>