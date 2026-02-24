<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%-- [1] FAQ와 동일한 설정 --%>
<c:set var="showSearchArea" value="true" scope="request" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
/* [1] 전역 버튼 스타일 무력화: 클래스명을 붙여서 우선순위를 높임 */
    .tui-grid-cell-content button.real-delete-btn {
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

    /* [2] 호버 효과 강제 적용 */
    .tui-grid-cell-content button.real-delete-btn:hover {
        background-color: #eff6ff !important;  /* hover:bg-blue-50 */
    }

    /* 기존 그리드 레이아웃 유지 */
    .tui-grid-cell { cursor: pointer !important; }
    #dg-container { width: 100%; margin-top: 1rem; }
    .grid-relative-wrapper { position: relative; width: 100%; }
    #dg-search-input { padding-left: 1rem !important; padding-right: 2.5rem !important; }
    /* FAQ 관리 페이지 스타일 완벽 이식 */
    .tui-grid-cell { cursor: pointer !important; }
    #dg-container { width: 100%; margin-top: 1rem; }
    .grid-relative-wrapper { position: relative; width: 100%; }

    #dg-search-input {
        padding-left: 1rem !important;
        padding-right: 2.5rem !important;
    }
    
    .real-delete-btn {
        all: unset !important;
        display: inline-flex !important;
        align-items: center !important;
        justify-content: center !important;
        
        /* 사용자 관리 페이지 '저장' 버튼과 동일한 스타일 */
        padding: 0.25rem 0.75rem !important; 
        background-color: #ffffff !important;
        color: #1d4ed8 !important; /* text-blue-700 */
        
        font-size: 12px !important;            
        font-weight: 700 !important;           
        border-radius: 6px !important;         
        border: 1px solid #93c5fd !important; /* border-blue-300 */
        
        cursor: pointer !important;
        transition: all 0.2s ease !important;
    }

    /* 마우스 올렸을 때 (사용자 관리 페이지 hover 효과) */
    .real-delete-btn:hover {
        background-color: #eff6ff !important; /* bg-blue-50 */
        border-color: #2563eb !important;     /* border-blue-600 */
    }
    
    
</style>

<div class="max-w-screen-2xl mx-auto">
    <div class="bg-white p-8 rounded-xl shadow-lg border border-gray-100 dark:bg-gray-800 dark:border-gray-700">

        <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4">
            <div>
                <div class="flex items-center gap-3">
                    <h2 class="text-2xl font-bold text-gray-900 dark:text-white">
                        공지사항 관리
                    </h2>
                    <span class="bg-blue-100 text-blue-700 text-xs font-bold px-2.5 py-0.5 rounded-full dark:bg-blue-900 dark:text-blue-300">
                        ADMIN
                    </span>
                </div>
                <p class="text-sm text-gray-500 mt-1">
                    시스템 공지사항을 조회하고 작성 및 수정할 수 있습니다.
                </p>
            </div>

            <div class="flex items-center gap-2">
                <sec:authorize access="hasRole('ADMIN')">
                    <button type="button" onclick="handleAddAction()"
                            class="px-3 py-1.5 text-sm font-semibold text-white bg-blue-600 rounded-lg hover:bg-blue-700 transition active:scale-95 flex items-center shadow-md">
                        <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
                        </svg>
                        공지사항 등록
                    </button>
                </sec:authorize>
            </div>
        </div>

        <div class="grid-relative-wrapper">
            <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp"/>
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
            title: `<c:out value="${item.title}"/>`,
            displayRegId: "${item.displayRegId}",
            regDtime: "${item.formattedRegDate}",
            viewCount: "${item.viewCount}"
        }${!status.last ? ',' : ''}
        </c:forEach>
    ];

    document.addEventListener('DOMContentLoaded', function() {
        const searchInput = document.getElementById('dg-search-input');
        const btnSearch = document.getElementById('dg-btn-search');
        
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
            const keyword = document.getElementById('dg-search-input').value.toLowerCase();
            const filtered = rawData.filter(item => 
                item.title.toLowerCase().includes(keyword) || 
                item.displayRegId.toLowerCase().includes(keyword)
            );
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

    // 모달 열기 함수 (AJAX로 noticeEdit.jsp 내용을 가져옴)
    function openNoticeModal(id) {
        const url = id > 0 ? '/notice/edit/' + id : '/notice/edit/0';
        $.ajax({
            url: url + "?isModal=Y", // 모달 요청임을 알리는 파라미터
            type: "GET",
            success: function(html) {
                $('#noticeModalContent').html(html);
                $('#noticeModal').removeClass('hidden');
                document.body.style.overflow = 'hidden';
            }
        });
    }

    function closeNoticeModal() {
        $('#noticeModal').addClass('hidden');
        document.body.style.overflow = 'auto';
    }
</script>