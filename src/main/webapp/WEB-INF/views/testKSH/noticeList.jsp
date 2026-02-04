<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%-- [1] 레이아웃 설정 --%>
<c:set var="showSearchArea" value="true" scope="request" />
<c:set var="showAddBtn" value="false" scope="request" />

<div class="mx-4 my-6 space-y-6">
    <%-- [2] 타이틀 및 버튼 영역 --%>
    <div class="px-5 py-4 pb-0 flex justify-between items-center">
        <div>
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white">공지사항 관리</h1>
            <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">공지사항을 등록하고 조회수 및 내용을 관리합니다.</p>
        </div>
        <sec:authorize access="hasRole('ADMIN')">
            <%-- 버튼 클릭 시 팝업을 띄우는 함수 호출 --%>
            <button type="button" 
                    class="px-4 py-2 bg-blue-600 text-white rounded-lg font-bold hover:bg-blue-700 transition shadow-sm" 
                    onclick="openWriteModal()">
                공지 등록
            </button>
        </sec:authorize>
    </div>

    <%-- [3] 데이터 그리드 인클루드 --%>
    <jsp:include page="/WEB-INF/views/datagrid/datagrid.jsp"/>
    
    <div class="text-center mt-4">
        <a href="/main" class="text-sm text-gray-500 hover:text-gray-800 underline">메인으로 돌아가기</a>
    </div>
</div>

<%-- [4] 공지사항 등록 모달 (스타일로 강제 숨김) --%>
<sec:authorize access="hasRole('ADMIN')">
<div id="customModalOverlay" class="custom-modal-overlay">
    <div class="custom-modal-content">
        <form action="/notice/write" method="post" enctype="multipart/form-data">
            <div class="modal-header-custom">
                <h5 class="fw-bold">공지사항 작성</h5>
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
    // [1] 서버 데이터 보관
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

    // [2] 모달 제어 함수 (Bootstrap 없이 직접 제어)
    function openWriteModal() {
        document.getElementById('customModalOverlay').style.display = 'flex';
        document.body.style.overflow = 'hidden'; // 배경 스크롤 방지
    }

    function closeWriteModal() {
        document.getElementById('customModalOverlay').style.display = 'none';
        document.body.style.overflow = 'auto';
    }

    document.addEventListener('DOMContentLoaded', function() {
        // [3] 그리드 초기화
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
                    header: '관리',
                    name: 'manage',
                    width: 100,
                    align: 'center',
                    formatter: () => {
                        return '<button type="button" class="detail-view-btn px-3 py-1 text-xs font-bold text-white bg-gray-800 rounded hover:bg-black transition">보기</button>';
                    }
                }
            ],
            data: rawData
        });

        // [4] 검색 로직
        document.getElementById('dg-btn-search').addEventListener('click', function() {
            const keyword = document.getElementById('dg-search-input').value.toLowerCase();
            const filtered = rawData.filter(item => 
                item.title.toLowerCase().includes(keyword) || 
                item.displayRegId.toLowerCase().includes(keyword)
            );
            noticeGrid.grid.resetData(filtered);
        });

        // [5] 행 클릭 상세조회
        noticeGrid.grid.on('click', (ev) => {
            const rowData = noticeGrid.grid.getRow(ev.rowKey);
            if (rowData && (ev.targetType === 'cell' || ev.nativeEvent.target.classList.contains('detail-view-btn'))) {
                location.href = '/notice/detail/' + rowData.noticeId;
            }
        });

        // [6] 에디터 초기화
        if (document.querySelector('#editor')) {
            ClassicEditor.create(document.querySelector('#editor')).catch(e => console.error(e));
        }
    });
</script>

<style>
    /* [7] 핵심 커스텀 모달 스타일 (하단 노출 절대 방지) */
    .custom-modal-overlay {
        display: none; /* 초기 상태 숨김 */
        position: fixed;
        top: 0; left: 0;
        width: 100%; height: 100%;
        background: rgba(0, 0, 0, 0.6);
        z-index: 9999; /* 최상단 배치 */
        justify-content: center;
        align-items: center;
    }

    .custom-modal-content {
        background: white;
        width: 800px;
        max-height: 90vh;
        border-radius: 12px;
        overflow-y: auto;
        padding: 0;
        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
    }

    .modal-header-custom { padding: 1.25rem; border-bottom: 1px solid #e5e7eb; display: flex; justify-content: space-between; align-items: center; }
    .modal-body-custom { padding: 1.5rem; }
    .modal-footer-custom { padding: 1.25rem; border-top: 1px solid #e5e7eb; display: flex; justify-content: flex-end; gap: 0.75rem; background: #f9fafb; }

    .form-label-custom { display: block; font-weight: 700; font-size: 0.875rem; color: #4b5563; margin-bottom: 0.5rem; }
    .form-input-custom { width: 100%; padding: 0.5rem 0.75rem; border: 1px solid #d1d5db; border-radius: 0.5rem; outline: none; }
    .form-input-custom:focus { border-color: #2563eb; ring: 2px #3b82f6; }

    .close-btn { font-size: 1.5rem; font-weight: bold; color: #9ca3af; cursor: pointer; border: none; background: none; }
    .btn-cancel { px: 1rem; py: 0.5rem; background: white; border: 1px solid #d1d5db; border-radius: 0.5rem; font-weight: bold; cursor: pointer; }
    .btn-save { px: 1.25rem; py: 0.5rem; background: #2563eb; color: white; border-radius: 0.5rem; font-weight: bold; cursor: pointer; border: none; }

    .tui-grid-cell { cursor: pointer !important; }
</style>