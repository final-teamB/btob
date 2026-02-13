<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%-- [1] 레이아웃 설정: FAQ처럼 datagrid의 버튼과 검색창을 사용 --%>
<c:set var="showSearchArea" value="true" scope="request" />
<c:set var="showAddBtn" value="true" scope="request" />

<div class="mx-4 my-6 space-y-6">
    <%-- [2] 타이틀 영역: 버튼을 지우고 FAQ처럼 텍스트만 남김 --%>
    <div class="px-5 py-4 pb-0">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">공지사항 관리</h1>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">시스템 공지사항을 조회하고 관리합니다.</p>
    </div>

    <%-- [3] 데이터 그리드 인클루드 (여기에 신규등록 버튼이 포함됨) --%>
    <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp"/>
</div>

<%-- [4] 공지사항 등록 모달 (기존 로직 유지) --%>
<sec:authorize access="hasRole('ADMIN')">
<div id="customModalOverlay" class="custom-modal-overlay">
    <div class="custom-modal-content">
        <form action="/notice/write" method="post" enctype="multipart/form-data">
            <div class="modal-header-custom">
                <h5 class="fw-bold text-lg">공지사항 작성</h5>
                <button type="button" class="close-btn" onclick="closeWriteModal()">&times;</button>
            </div>
            <div class="modal-body-custom">
                <div class="mb-4">
                    <label class="form-label-custom">제목</label>
                    <input type="text" name="title" class="form-input-custom" placeholder="제목을 입력하세요" required>
                </div>
                <div class="mb-4">
                    <label class="form-label-custom">내용</label>
                    <textarea name="content" id="editor"></textarea>
                </div>
                <div class="mb-0">
                    <label class="form-label-custom">첨부파일</label>
                    <input type="file" name="files" class="form-input-custom" multiple>
                </div>
            </div>
            <div class="modal-footer-custom">
                <button type="button" class="btn-cancel" onclick="closeWriteModal()">취소</button>
                <button type="submit" class="btn-save">저장하기</button>
            </div>
        </form>
    </div>
</div>
</sec:authorize>

<script src="https://cdn.ckeditor.com/ckeditor5/39.0.1/classic/ckeditor.js"></script>

<script>
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

    window.handleGridAction = function(rowData) {
        if (rowData && rowData.noticeId) {
            location.href = '/notice/edit/' + rowData.noticeId;
        }
    };
    
    // [5] 모달 제어 함수
    function openWriteModal() {
        document.getElementById('customModalOverlay').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeWriteModal() {
        document.getElementById('customModalOverlay').style.display = 'none';
        document.body.style.overflow = 'auto';
    }

    // ★ FAQ 방식 핵심: datagrid.jsp 내부에 생성된 버튼 클릭 시 호출되는 함수
    function handleAddAction() {
    	location.href = '/notice/edit/0';
    }

    document.addEventListener('DOMContentLoaded', function() {
        // [6] 그리드 초기화
        const noticeGrid = new DataGrid({
            containerId: 'dg-container',
            searchId: 'dg-search-input',
            btnSearchId: 'dg-btn-search',
            perPageId: 'dg-per-page',
            columns: [
            	{ header: '번호', name: 'noticeId', width: 80, align: 'center', sortable: true },
                { header: '제목', name: 'title', align: 'left', sortable: true },
                { header: '작성자', name: 'displayRegId', width: 120, align: 'center' },
                { header: '등록일', name: 'regDtime', width: 150, align: 'center', sortable: true },
                { header: '조회수', name: 'viewCount', width: 100, align: 'center', sortable: true },
                {
                    header: '관리', name: 'editBtn', width: 90, align: 'center',
                    renderer: {
                        type:  CustomActionRenderer, options:{ btnText:'수정', btnClass: 'edit-view-btn'}
                    }
                }
            ],
            data: rawData
        });

        // [7] FAQ 스타일 검색 로직 (조회 버튼 연결)
        document.getElementById('dg-btn-search').addEventListener('click', function() {
            const keyword = document.getElementById('dg-search-input').value.toLowerCase();
            const filtered = rawData.filter(item => 
                item.title.toLowerCase().includes(keyword) || 
                item.displayRegId.toLowerCase().includes(keyword)
            );
            noticeGrid.grid.resetData(filtered);
        });

        // [8] 행 클릭 상세조회
        noticeGrid.grid.on('click', (ev) => {
        	
            if (ev.columnName === 'editBtn' || (ev.nativeEvent && ev.nativeEvent.target.classList.contains('edit-view-btn'))) {
            	const rowData = deliveryGrid.grid.getRow(ev.rowKey);
            	if (rowData && rowData.noticeId) {
                    location.href = '/notice/edit/' + rowData.deliveryId;
                }
            }
        });
    });
</script>

<style>
    /* [9] 모달 및 그리드 스타일 유지 */
    .custom-modal-overlay {
        display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(0, 0, 0, 0.6); z-index: 9999; justify-content: center; align-items: center;
    }
    .custom-modal-content {
        background: white; width: 800px; max-height: 90vh; border-radius: 12px; overflow-y: auto;
        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
    }
    .modal-header-custom { padding: 1.25rem; border-bottom: 1px solid #e5e7eb; display: flex; justify-content: space-between; align-items: center; }
    .modal-body-custom { padding: 1.5rem; }
    .modal-footer-custom { padding: 1.25rem; border-top: 1px solid #e5e7eb; display: flex; justify-content: flex-end; gap: 0.75rem; background: #f9fafb; }
    .form-label-custom { display: block; font-weight: 700; font-size: 0.875rem; color: #4b5563; margin-bottom: 0.5rem; }
    .form-input-custom { width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #d1d5db; border-radius: 0.5rem; outline: none; }
    .close-btn { font-size: 1.5rem; font-weight: bold; color: #9ca3af; cursor: pointer; border: none; background: none; }
    .btn-cancel { padding: 0.5rem 1rem; background: white; border: 1px solid #d1d5db; border-radius: 0.5rem; font-weight: bold; cursor: pointer; }
    .btn-save { padding: 0.5rem 1.25rem; background: #2563eb; color: white; border-radius: 0.5rem; font-weight: bold; cursor: pointer; border: none; }
    .tui-grid-cell { cursor: default !important; }
</style>