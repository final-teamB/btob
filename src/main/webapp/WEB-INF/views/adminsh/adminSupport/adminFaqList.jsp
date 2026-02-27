<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="showSearchArea" value="true" scope="request" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
    /* 배경 및 기본 컨테이너 설정 */
    body { background-color: #f9fafb; }
    
    .admin-main-container { 
        width: 100%;
        min-height: auto;
        padding-bottom: 0.25rem;
        margin-bottom: 0 !important;
    }
    
    /* 하얀색 카드 디자인 */
    .grid-card { 
        background-color: #ffffff;
        border: 1px solid #e5e7eb; 
        border-radius: 0.75rem; 
        box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1); 
        margin-bottom: 1rem;
    }

    #dg-container { width: 100%; margin-top: 1rem; }
    .grid-relative-wrapper { position: relative; width: 100%; min-height: 400px; }
    
    /* 그리드 셀 내용 중앙 정렬 */
    .tui-grid-cell-content {
        display: flex !important;
        justify-content: center !important;
        height: 100% !important;
    }

    /* 배송 관리와 동일한 '관리/삭제' 버튼 스타일 */
    .btn-action-custom {
        display: inline-flex !important;
        align-items: center !important;
        justify-content: center !important;
        height: 32px !important;
        padding: 0 12px !important;
        font-size: 0.75rem !important;
        font-weight: 700 !important;
        color: #1d4ed8 !important;
        border: 1px solid #60a5fa !important;
        border-radius: 0.375rem !important;
        background-color: #fff !important;
        cursor: pointer;
    }
    .btn-action-custom:hover { background-color: #eff6ff !important; }

    /* 카테고리 배지 스타일 (stts-badge-delivery 이식) */
    .cat-badge { 
        padding: 3px 10px !important;
        border-radius: 9999px !important;
        font-size: 11px !important; 
        font-weight: 700 !important; 
        display: inline-block !important; 
        text-align: center !important; 
        min-width: 80px !important;
    }
    /* 카테고리별 색상 (배송 관리의 dv 계열 색상 활용) */
    .cat-delivery { background-color: #fffbeb !important; color: #d97706 !important; border: 1px solid #fde68a !important; } /* 노란색 계열 */
    .cat-payment { background-color: #ecfdf5 !important; color: #059669 !important; border: 1px solid #a7f3d0 !important; }  /* 초록색 계열 */
    .cat-etc { background-color: #f9fafb !important; color: #4b5563 !important; border: 1px solid #e5e7eb !important; }     /* 회색 계열 */
</style>

<div class="admin-main-container my-6 space-y-6">
    <div class="px-8 py-4 flex flex-col md:flex-row justify-between items-start md:items-center">
        <div class="w-full text-left">
            <div class="flex items-center gap-3">
                <h2 class="text-2xl font-bold text-gray-900">자주 묻는 질문 (FAQ)</h2>
                <span class="bg-blue-50 text-blue-700 text-xs font-bold px-2.5 py-1 rounded-full border border-blue-100">
                    전체 <span id="total-count-display">${faqList.size()}</span>건
                </span>
            </div>
            <p class="text-sm text-gray-500 mt-1">FAQ 정보를 수정하거나 새로운 질문을 등록할 수 있습니다.</p>
        </div>
        
        <div class="mt-4 md:mt-0">
            <button type="button" onclick="handleAddAction()"
                    class="min-w-[120px] p-2 text-sm font-bold text-white bg-blue-600 rounded-lg hover:bg-blue-700 transition active:scale-95 flex items-center justify-center shadow-md">
                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
                </svg>
                FAQ 등록
            </button>
        </div>
    </div>

    <div class="px-5" style="margin-top: 1rem !important;">
        <div class="grid-card p-6">
            <div class="grid-relative-wrapper">
                <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp">
                    <jsp:param name="showSearchArea" value="true" />
                    <jsp:param name="showPerPage" value="true" />
                </jsp:include>
            </div>
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
                { header: '질문', name: 'question', align: 'left', className: 'column-question-left' },
                { 
                    header: '등록일', 
                    name: 'regDtime', 
                    width: 180, 
                    align: 'center',
                    formatter: function(props) {
                        let val = props.value || '';
                        // 'T'를 공백으로 바꾸고, 밀리초(.000Z 등)가 있다면 잘라버림
                        return val.replace('T', ' ').split('.')[0];
                    }
                },
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
            data: rawData,
            pageOptions: { 
                useClient: true, 
                perPage: 10 
            }
        });
        
        faqGrid.grid.resetData(rawData.slice(0, 10));

        // [3] datagrid.jsp의 조회 버튼 클릭 시 필터링 로직 연결
        document.getElementById('dg-btn-search').addEventListener('click', function() {
            const catVal = document.getElementById('dg-common-filter').value;
            const keyword = document.getElementById('dg-search-input').value.toLowerCase();

            const filtered = rawData.filter(item => {
                const matchCat = !catVal || item.category === catVal;
                const matchKey = !keyword || item.question.toLowerCase().includes(keyword);
                return matchCat && matchKey;
            });
            const perPage = 10;
            faqGrid.grid.resetData(filtered.slice(0, perPage)); 

            // 페이징 버튼 보일지 말지 결정
            const paginationEl = document.querySelector('.tui-pagination');
            if (paginationEl) {
                paginationEl.style.display = (filtered.length <= perPage) ? 'none' : 'block';
            }
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
    
 // FAQ 상세/등록 폼 내부 스크립트 부분
    let faqEditorInstance = null; // 전역 또는 폼 스코프 변수

    async function initFaqEditor() {
        const el = document.querySelector('#faqEditor');
        if (!el) return;

        if (faqEditorInstance) {
            try {
                await faqEditorInstance.destroy();
            } catch (e) {}
            faqEditorInstance = null;
        }

        if (typeof ClassicEditor !== 'undefined') {
            ClassicEditor.create(el, {
                placeholder: '답변 내용을 입력하세요...',
                toolbar: ['bold', 'italic', 'underline', '|', 'numberedList', 'bulletedList', '|', 'undo', 'redo']
            }).then(editor => {
                el.ckeditorInstance = editor; // 요소 자체에 인스턴스 저장
                faqEditorInstance = editor;    // 기존 submit 함수와 호환을 위해 유지
                
                // 높이 고정 (시원하게 보이도록)
                editor.editing.view.change(writer => {
                    writer.setStyle('min-height', '400px', editor.editing.view.document.getRoot());
                });
            }).catch(err => console.error(err));
        }
    }
    
    function openFaqModal(faqId) {
        const url = faqId > 0 ? '/support/modifyFaq/' + faqId : '/support/registerFaq';
        
        $.ajax({
            url: url + "?isModal=Y",
            type: "GET",
            success: function(html) {
                $('#faqModalContent').html(html);
                $('#faqModal').removeClass('hidden');
                document.body.style.overflow = 'hidden';

                // 공지사항 관리와 동일하게 setTimeout으로 안정적인 초기화 호출
                if (typeof initFaqEditor === 'function') {
                    setTimeout(initFaqEditor, 150);
                }
            },
            error: function() {
                alert("정보를 불러오는 데 실패했습니다.");
            }
        });
    }

    function closeFaqModal() {
        $('#faqModal').addClass('hidden');
        $('#faqModalContent').empty(); 
        document.body.style.overflow = 'auto';
    }
</script>