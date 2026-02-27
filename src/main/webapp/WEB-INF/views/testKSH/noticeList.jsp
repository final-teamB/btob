<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%-- [1] FAQ와 동일한 설정 --%>
<c:set var="showSearchArea" value="true" scope="request" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
    /* [1] 배경 및 기본 컨테이너 설정 - FAQ 스타일 이식 */
    body { background-color: #f9fafb; }
    
    .admin-main-container { 
        width: 100%;
        min-height: auto;
        padding-bottom: 0.25rem;
        margin-bottom: 0 !important;
    }
    
    /* [2] 하얀색 카드 디자인 - 그리드 영역을 감싸는 박스 */
    .grid-card { 
        background-color: #ffffff;
        border: 1px solid #e5e7eb; 
        border-radius: 0.75rem; 
        box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1); 
        margin-bottom: 1rem;
    }

    #dg-container { width: 100%; margin-top: 1rem; }
    .grid-relative-wrapper { position: relative; width: 100%; min-height: 400px; }
    
    /* [3] 그리드 내 버튼 스타일 - FAQ '삭제' 버튼 스타일로 통일 */
    .real-delete-btn {
    height:10px;
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
        transition: all 0.2s ease !important;
    }
    
    .real-delete-btn:hover { background-color: #eff6ff !important; }
    
    /* [최종 해결책] 모든 종류의 셀 높이를 강제로 통일 */
.tui-grid-container .tui-grid-cell {
    height: 52px !important; /* 50px보다 조금 여유를 주는 게 정렬에 유리함 */
    background-color: #fff !important;
}

/* No. 컬럼(메타열)과 일반 셀의 내부 높이 강제 고정 */
.tui-grid-container .tui-grid-cell-content {
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    height: 52px !important; /* 위와 동일하게 */
    padding: 0 !important;
    line-height: normal !important;
}

/* 제목 열은 왼쪽 정렬 유지 */
.tui-grid-container .tui-grid-cell[data-column-name="title"] .tui-grid-cell-content {
    justify-content: flex-start !important;
    padding-left: 1rem !important;
}

/* 그리드 레이아웃 깨짐 방지 */
.tui-grid-border-line {
    display: none !important; /* 불필요한 미세 라인 제거로 어긋남 방지 */
}
</style>

<div class="admin-main-container my-6 space-y-6">
    <div class="px-8 py-4 flex flex-col md:flex-row justify-between items-start md:items-center">
        <div class="w-full text-left">
            <div class="flex items-center gap-3">
                <h2 class="text-2xl font-bold text-gray-900">공지사항 관리</h2>
                <span class="bg-blue-50 text-blue-700 text-xs font-bold px-2.5 py-1 rounded-full border border-blue-100">
                    전체 <span id="total-count-display">${noticeList.size()}</span>건
                </span>
            </div>
            <p class="text-sm text-gray-500 mt-1">시스템 공지사항을 조회하고 작성 및 수정할 수 있습니다.</p>
        </div>
        
        <div class="mt-4 md:mt-0">
            <button type="button" onclick="handleAddAction()"
                    class="min-w-[140px] p-2 text-sm font-bold text-white bg-blue-600 rounded-lg hover:bg-blue-700 transition active:scale-95 flex items-center justify-center shadow-md">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
                </svg>
                공지사항 등록
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

<div id="noticeModal" tabindex="-1" aria-hidden="true" data-modal-backdrop="static" 
     class="fixed inset-0 z-50 hidden flex items-center justify-center bg-black/50 overflow-y-auto">
    <div class="relative w-full max-w-4xl p-4 mx-auto">
        <div class="relative bg-white rounded-xl border border-gray-200 dark:bg-gray-800 dark:border-gray-700">
            <div class="flex items-center justify-between p-4 border-b">
                <h2 class="text-xl font-bold text-gray-900 dark:text-white">공지사항 설정</h2>
                <button type="button" onclick="closeNoticeModal()" class="text-gray-400 hover:text-gray-900 ml-auto p-2">
                     <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>
            <div id="noticeModalContent"></div>
        </div>
    </div>
</div>

<script>
    // 데이터 보관 (기존과 동일)
    const rawData = [
        <c:forEach var="item" items="${noticeList}" varStatus="status">
        {
            noticeId: "${item.noticeId}",
            category: "${item.category}",
            title: `<c:out value="${item.title}"/>`,
            displayRegId: "${item.displayRegId}",
            regDtime: "${item.formattedRegDate}",
            viewCount: "${item.viewCount}"
        }${!status.last ? ',' : ''}
        </c:forEach>
    ];

    document.addEventListener('DOMContentLoaded', function() {
    	const filterWrapper = document.getElementById('dg-common-filter-wrapper');
        const filterSelect = document.getElementById('dg-common-filter');
        const searchInput = document.getElementById('dg-search-input'); // 여기 선언!
        const btnSearch = document.getElementById('dg-btn-search');

        // [카테고리 설정]
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

            // 카테고리 변경 시 검색 실행
            filterSelect.addEventListener('change', () => btnSearch.click());
        }
        
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

                        const map = { 
                            '일반': '일반', 
                            '안내': '안내', 
                            '점검': '점검', 
                            '업데이트': '업데이트' 
                        };
                        const labelName = map[val] || val;

                        const badgeStyles = {
                            '일반': 'bg-gray-100 text-gray-600',
                            '안내': 'bg-blue-50 text-blue-600',
                            '점검': 'bg-red-50 text-red-600', 
                            '업데이트': 'bg-green-50 text-green-600'
                        };
                        
                        const styleClass = badgeStyles[val] || 'bg-gray-100 text-gray-500';
                        
                        return '<span class="px-2 py-1 rounded text-[11px] font-bold ' + styleClass + '">' + labelName + '</span>';
                    }
                },
                { header: '제목', name: 'title', align: 'left', sortable: true },
                { header: '작성자', name: 'displayRegId', width: 120, align: 'center' },
                { header: '등록일', name: 'regDtime', width: 180, align: 'center', sortable: true },
                { header: '조회수', name: 'viewCount', width: 100, align: 'center', sortable: true },
                {
                	header: '관리', name: 'manage', width: 100, align: 'center',
                    formatter: () => {
                    	return `<button type="button" class="real-delete-btn">삭제</button>`;
                    }
                }
            ],
            data: rawData
        });

        // [조회 버튼 필터 로직]
        document.getElementById('dg-btn-search').addEventListener('click', function() {
        	const catVal = document.getElementById('dg-common-filter').value;
        	const keyword = document.getElementById('dg-search-input').value.toLowerCase();
        	const filtered = rawData.filter(item => {
                // 카테고리 조건: 전체, 값 일치
                const matchCat = !catVal || item.category === catVal;
                
                // 검색어 조건: 검색어X, 제목 또는 작성자에 포함
                const matchKey = !keyword || 
                                 item.title.toLowerCase().includes(keyword) || 
                                 item.displayRegId.toLowerCase().includes(keyword);
                                 
                return matchCat && matchKey; // 두 조건 모두 참(True)이어야 함
            });
            noticeGrid.grid.resetData(filtered);
        });

     	// 클릭 이벤트 처리 (삭제 기능)
        noticeGrid.grid.on('click', (ev) => {
            const rowData = noticeGrid.grid.getRow(ev.rowKey);
            if (!rowData) return;

            if (ev.nativeEvent.target.classList.contains('real-delete-btn')) {
                if (confirm('정말 삭제하시겠습니까?')) {
                    handleDelete(rowData.noticeId); // 삭제 로직도 AJAX로 변경 권장
                }
            } else if (ev.targetType === 'cell') {
                openNoticeModal(rowData.noticeId); // 모달 열기
            }
        });
    });
    
 	// 등록 버튼 핸들러
    function handleAddAction() {
        openNoticeModal(0);
    }

    async function initEditor() {
        const el = document.querySelector('#modalEditor');
        if (!el) return;

        // 기존 인스턴스가 있다면 파괴
        if (el.ckeditorInstance) {
            try {
                await el.ckeditorInstance.destroy();
            } catch (e) {
                console.error('Destroy error:', e);
            }
            delete el.ckeditorInstance;
        }

        // CKEditor 생성
        if (typeof ClassicEditor !== 'undefined') {
            ClassicEditor.create(el, {
                placeholder: '상세 설명을 입력하세요...',
                toolbar: {
                    items: ['bold', 'italic', 'underline', '|', 'numberedList', 'bulletedList', '|', 'removeFormat', 'undo', 'redo'],
                    shouldNotGroupWhenFull: true
                }
            }).then(editor => {
                el.ckeditorInstance = editor;
            }).catch(err => console.error('CKEditor Error:', err));
        }
    }

    // 2. 모달 열기 함수 수정
    function openNoticeModal(id) {
        const url = id > 0 ? '/notice/edit/' + id : '/notice/edit/0';
        $.ajax({
            url: url + "?isModal=Y",
            type: "GET",
            success: function(html) {
                $('#noticeModalContent').html(html);
                $('#noticeModal').removeClass('hidden');
                document.body.style.overflow = 'hidden';
                
                // 핵심: HTML이 박힌 직후가 아니라, 브라우저가 렌더링할 시간을 준 뒤 실행
                setTimeout(() => {
                    initEditor();
                }, 100);
            }
        });
    }
 	
    function closeNoticeModal() {
        $('#noticeModal').addClass('hidden');
        document.body.style.overflow = 'auto';
    }
    
    function handleDelete(noticeId) {
        $.ajax({
            url: '/notice/delete/' + noticeId,
            type: 'GET',
            success: function() {
                alert('삭제되었습니다.');
                location.reload(); // 목록 새로고침
            },
            error: function() {
                alert('삭제 중 오류가 발생했습니다.');
            }
        });
    }
</script>