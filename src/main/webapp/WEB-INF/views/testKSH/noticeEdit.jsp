<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script src="https://cdn.ckeditor.com/ckeditor5/34.0.0/classic/ckeditor.js"></script>

<style>
    .ck-editor__editable {
        min-height: 200px !important;
        max-height: 400px !important;
    }
    .ck.ck-editor__main>.ck-editor__editable {
        border-radius: 0 0 8px 8px !important;
        border: 1px solid #e2e8f0 !important;
    }
    .ck.ck-toolbar {
        border-radius: 8px 8px 0 0 !important;
        border-bottom: none !important;
        background-color: #ffffff !important;
    }
    .ck.ck-toolbar > .ck-toolbar__items { flex-wrap: wrap !important; }
    .ck.ck-toolbar__grouped-dropdown { display: none !important; }
    .section-label { 
        display: block; font-size: 14px; font-weight: 600; 
        color: #374151; margin-bottom: 6px; 
    }
</style>

<div class="p-2 space-y-2">
    <div class="px-2 pb-1 border-b">
        <h3 class="font-bold text-blue-600 text-sm uppercase">공지사항 상세 정보</h3>
        <p class="text-[12px] text-gray-400 mt-1">* 모든 항목은 필수 입력 사항입니다.</p>
    </div>

    <section class="bg-white">
        <form id="noticeForm" action="/notice/${notice.noticeId > 0 ? 'update' : 'write'}" method="post" enctype="multipart/form-data" class="space-y-3">
            <c:if test="${notice.noticeId > 0}">
                <input type="hidden" name="noticeId" value="${notice.noticeId}">
            </c:if>

            <div class="grid grid-cols-1 gap-y-2 px-2">
                <%-- 제목 --%>
                <div>
                    <label class="section-label">제목 <span class="text-red-500">*</span></label>
                    <input type="text" name="title" value="${notice.title}" required
                           placeholder="제목을 입력하세요"
                           class="w-full px-3 py-2.5 text-sm border border-gray-300 rounded-lg outline-none focus:ring-1 focus:ring-blue-500 transition-all">
                </div>

                <%-- 상세 설명 --%>
                <div>
                    <label class="section-label">상세 설명 <span class="text-red-500">*</span></label>
                    <textarea name="content" id="modalEditor">${notice.content}</textarea>
                </div>
                
                <%-- 첨부 파일 영역 수정 --%>
				<div>
				    <label class="section-label">첨부 파일</label>
				    
				    <div id="existing-file-list" class="space-y-2 mb-2">
					    <c:forEach var="file" items="${notice.noticeFiles}">
					        <c:if test="${file.useYn eq 'Y'}">
					            <div id="file-item-${file.noticeFileId}" class="flex items-center justify-between p-2.5 bg-blue-50 border border-blue-200 rounded-lg">
					                <div class="flex items-center gap-2">
					                    <span class="text-blue-600 text-xs font-bold">첨부됨:</span>
					                    <a href="/notice/download/${file.storedFileName}" class="text-sm text-gray-700">${file.originFileName}</a>
					                </div>  <%-- ✅ 이 닫힘 태그가 없었음 --%>
					                <button type="button" onclick="deleteExistingFile(${file.noticeFileId})" class="text-red-500 hover:text-red-700 text-xs font-bold px-2 py-1">삭제</button>
					            </div>
					        </c:if>
					    </c:forEach>
					</div>
					
					<div id="file-count-display" class="mb-1 text-xs font-bold text-blue-600 hidden"></div>
					
					<div id="new-file-list" class="space-y-2 mb-3"></div>
				
				    <input type="file" name="files" id="noticeFiles" class="hidden" multiple onchange="updateFileName(this)">
				    <button type="button" onclick="document.getElementById('noticeFiles').click()"
				            class="w-full py-2.5 border border-dashed border-gray-300 rounded-lg text-sm text-gray-400 hover:bg-gray-50 transition-all text-center">
				        <span id="file-name-display">+ 클릭하여 파일 추가 (여러 개 가능)</span>
				    </button>
				</div>
            </div>

            <%-- 하단 액션바 --%>
            <div class="flex items-center justify-between p-4 border-t mt-3">
                <button type="submit"
                        class="px-10 py-2.5 text-sm font-bold text-white bg-blue-600 rounded-lg hover:bg-blue-700 shadow-md transition-all active:scale-95">
                    저장하기
                </button>
                <button type="button" onclick="closeNoticeModal()"
                        class="px-6 py-2.5 text-sm font-medium text-gray-500 bg-white border border-gray-200 rounded-lg hover:bg-gray-50 transition-all shadow-sm">
                    취소
                </button>
            </div>
        </form>
    </section>
</div>

<script>
    // 파일 목록 누적 배열
    let selectedFiles = [];

    // 에디터 초기화
    function initEditor() {
        if (typeof ClassicEditor === 'undefined') {
            setTimeout(initEditor, 100);
            return;
        }
        const el = document.querySelector('#modalEditor');
        if (!el || el.dataset.initialized) return;
        el.dataset.initialized = 'true';

        ClassicEditor.create(el, {
            placeholder: '상세 설명을 입력하세요...',
            toolbar: {
                items: ['bold', 'italic', 'underline', '|', 'numberedList', 'bulletedList', '|', 'removeFormat', 'undo', 'redo'],
                shouldNotGroupWhenFull: true
            }
        }).then(editor => {
            console.log('에디터 로드 성공');
        }).catch(err => console.error(err));
    }
    setTimeout(initEditor, 100);

    // 파일 선택 시 호출
    function updateFileName(input) {
	    Array.from(input.files).forEach(newFile => {
	        const isDuplicate = selectedFiles.some(f => f.name === newFile.name && f.size === newFile.size);
	        if (!isDuplicate) {
	            selectedFiles.push(newFile);
	        }
	    });
	    input.value = "";
	    renderNewFileList(document.getElementById('new-file-list'));
	}

    // 파일 목록 렌더링
    function renderNewFileList(container, display) {
	    container.innerHTML = '';
	    
	    const countDisplay = document.getElementById('file-count-display');
	
	    if (selectedFiles.length === 0) {
	        countDisplay.classList.add('hidden');
	        countDisplay.innerHTML = '';
	        return;
	    }
	
	    countDisplay.classList.remove('hidden');
	    countDisplay.innerHTML = selectedFiles.length + '개의 파일 선택됨';
	
	    selectedFiles.forEach(function(file, index) {
	        const fileRow = document.createElement('div');
	        fileRow.className = "flex items-center justify-between p-2.5 bg-blue-50 border border-blue-200 rounded-lg";
	        fileRow.innerHTML =
	            '<div class="flex items-center gap-2">' +
	                '<span class="text-blue-600 text-xs font-bold">신규:</span>' +
	                '<span class="text-sm text-gray-700">' + file.name + '</span>' +
	            '</div>' +
	            '<button type="button" onclick="removeNewFile(' + index + ')" class="text-red-500 hover:text-red-700 text-xs font-bold px-2 py-1">취소</button>';
	        container.appendChild(fileRow);
	    });
	}

    // 신규 파일 제거
    function removeNewFile(index) {
	    selectedFiles.splice(index, 1);
	    renderNewFileList(document.getElementById('new-file-list'));
	}

    // 폼 제출 시 파일 input에 동기화
    document.getElementById('noticeForm').addEventListener('submit', function() {
        if (selectedFiles.length > 0) {
            const dt = new DataTransfer();
            selectedFiles.forEach(function(file) { dt.items.add(file); });
            document.getElementById('noticeFiles').files = dt.files;
        }
    });

    // 기존 파일 삭제
    function deleteExistingFile(fileId) {
        if (!confirm("이 파일을 삭제하시겠습니까?")) return;

        fetch('${pageContext.request.contextPath}/notice/file/delete/' + fileId, {
            method: 'POST'
        })
        .then(function(response) {
            if (response.ok) {
                var fileItem = document.getElementById('file-item-' + fileId);
                if (fileItem) {
                    fileItem.remove();
                    alert("파일이 삭제되었습니다.");
                } else {
                    location.reload();
                }
            } else {
                alert("서버에서 삭제 처리에 실패했습니다. (상태코드: " + response.status + ")");
            }
        })
        .catch(function(error) {
            console.error('Error:', error);
            alert("통신 오류가 발생했습니다.");
        });
    }
</script>