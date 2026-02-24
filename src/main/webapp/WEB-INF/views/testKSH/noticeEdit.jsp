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

                <%-- 첨부 파일 --%>
                <div>
                    <label class="section-label">첨부 파일</label>
                    <input type="file" name="files" id="noticeFiles" class="hidden" multiple onchange="updateFileName(this)">
                    <button type="button" onclick="document.getElementById('noticeFiles').click()"
                            class="w-full py-2.5 border border-dashed border-gray-300 rounded-lg text-sm text-gray-400 hover:bg-gray-50 transition-all text-center">
                        <span id="file-name-display">+ 클릭하여 파일 추가</span>
                    </button>
                </div>

                <%-- 상세 설명 --%>
                <div>
                    <label class="section-label">상세 설명 <span class="text-red-500">*</span></label>
                    <textarea name="content" id="modalEditor">${notice.content}</textarea>
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

    function updateFileName(input) {
        const display = document.getElementById('file-name-display');
        display.innerHTML = input.files.length > 0 ?
            `<span class="text-blue-600 font-bold">${input.files.length}개 파일 선택됨</span>` : '+ 클릭하여 파일 추가';
    }
</script>