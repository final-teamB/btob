<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- [1] 레이아웃 설정: 헤더 영역은 목록에서 설정하므로 여기서는 끔 --%>
<c:set var="showSearchArea" value="false" scope="request" />
<c:set var="showAddBtn" value="false" scope="request" />

<div class="mx-4 my-6 space-y-6">
    
    <%-- [2. 타이틀 영역] ID가 0인지 아닌지에 따라 문구 동적 변경 --%>
    <div class="px-5 py-4 text-center">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
            <c:choose>
                <c:when test="${notice.noticeId > 0}">공지사항 수정</c:when>
                <c:otherwise>공지사항 신규 등록</c:otherwise>
            </c:choose>
        </h1>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">
            <c:choose>
                <c:when test="${notice.noticeId > 0}">등록된 공지사항의 내용을 수정하고 파일을 관리합니다.</c:when>
                <c:otherwise>새로운 공지사항을 작성하여 시스템에 등록합니다.</c:otherwise>
            </c:choose>
        </p>
    </div>

    <%-- [3. 입력 폼 영역] max-w-4xl mx-auto로 중앙 집중 배치 --%>
    <section class="max-w-4xl mx-auto p-8 bg-white rounded-xl shadow-sm border border-gray-100 dark:bg-gray-800 dark:border-gray-700">
        <%-- ID 존재 여부에 따라 저장(write) 또는 업데이트(update)로 전송 --%>
        <form action="/notice/${notice.noticeId > 0 ? 'update' : 'write'}" 
              method="post" enctype="multipart/form-data" class="space-y-6">
            
            <%-- 수정 모드일 때만 noticeId 전송 --%>
            <c:if test="${notice.noticeId > 0}">
                <input type="hidden" name="noticeId" value="${notice.noticeId}">
            </c:if>

            <%-- 제목 입력 --%>
            <div class="grid grid-cols-1 md:grid-cols-4 items-center gap-4">
                <label class="text-sm font-bold text-gray-700 dark:text-gray-300">제목 <span class="text-red-500">*</span></label>
                <div class="md:col-span-3">
                    <input type="text" name="title" value="${notice.title}" required 
                           placeholder="공지사항 제목을 입력하세요."
                           class="w-full px-4 py-2 text-sm border border-gray-300 rounded-lg focus:ring-1 focus:ring-gray-900 focus:outline-none dark:bg-gray-700 dark:text-white transition-all">
                </div>
            </div>

            <%-- 내용 입력 (CKEditor) --%>
            <div class="grid grid-cols-1 md:grid-cols-4 items-start gap-4 border-t border-gray-50 pt-6 dark:border-gray-700">
                <label class="text-sm font-bold text-gray-700 dark:text-gray-300 mt-2">내용 <span class="text-red-500">*</span></label>
                <div class="md:col-span-3 text-gray-900">
                    <textarea name="content" id="editor">${notice.content}</textarea>
                </div>
            </div>

            <%-- 첨부파일 영역 (커스텀 버튼 스타일) --%>
            <div class="grid grid-cols-1 md:grid-cols-4 items-start gap-4 border-t border-gray-50 pt-6 dark:border-gray-700">
                <label class="text-sm font-bold text-gray-700 dark:text-gray-300 mt-2">첨부파일</label>
                <div class="md:col-span-3 space-y-4">
                    
                    <%-- [수정 모드] 기존 파일 목록 및 삭제 체크박스 --%>
                    <c:if test="${not empty files}">
                        <div class="bg-gray-50 dark:bg-gray-900/50 rounded-lg p-4">
                            <p class="text-xs font-bold text-gray-500 mb-3 uppercase tracking-wider">기존 첨부파일 (삭제 시 체크)</p>
                            <ul class="space-y-2">
                                <c:forEach var="file" items="${files}">
                                    <li class="flex items-center justify-between bg-white dark:bg-gray-800 p-2 px-3 rounded border border-gray-100 dark:border-gray-700">
                                        <span class="text-sm text-gray-600 dark:text-gray-300">📎 ${file.originName}</span>
                                        <label class="flex items-center cursor-pointer group">
                                            <input type="checkbox" name="deleteFileIds" value="${file.savedFileName}" class="w-4 h-4 text-red-600 border-gray-300 rounded focus:ring-red-500">
                                            <span class="ml-2 text-xs font-bold text-red-500 group-hover:underline">삭제</span>
                                        </label>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>

                    <%-- [공통] 신규 파일 선택 (절대 안 짤리는 방식) --%>
                    <div class="flex items-center">
                        <input type="file" name="files" id="file-upload" multiple class="hidden" onchange="updateFileName(this)">
                        <label for="file-upload" 
                               class="cursor-pointer px-5 py-2.5 text-sm font-bold text-white bg-gray-900 rounded-lg hover:bg-gray-800 shadow-md transition-all active:scale-95 inline-block">
                            파일 선택
                        </label>
                        <span id="file-name-display" class="ml-4 text-sm text-gray-500 italic">선택된 파일 없음</span>
                    </div>
                    <p class="text-xs text-gray-400 mt-1">파일을 여러 개 선택하려면 Ctrl키를 누른 상태로 클릭하세요.</p>
                </div>
            </div>

            <%-- [4. 하단 액션 버튼] --%>
            <div class="flex justify-end space-x-3 pt-8 border-t border-gray-100 dark:border-gray-700">
                <button type="button" onclick="location.href='/notice'" 
                        class="px-6 py-2.5 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 transition-all">
                    취소
                </button>
                <button type="submit" 
                        class="px-8 py-2.5 text-sm font-bold text-white bg-gray-900 rounded-lg hover:bg-gray-800 shadow-md transition-all active:scale-95">
                    <c:choose>
                        <c:when test="${notice.noticeId > 0}">수정완료</c:when>
                        <c:otherwise>등록하기</c:otherwise>
                    </c:choose>
                </button>
            </div>
        </form>
    </section>
</div>

<script src="https://cdn.ckeditor.com/ckeditor5/39.0.1/classic/ckeditor.js"></script>
<script>
    // 1. CKEditor 초기화
    document.addEventListener('DOMContentLoaded', function() {
        if (document.querySelector('#editor')) {
            ClassicEditor.create(document.querySelector('#editor')).catch(e => console.error(e));
        }
    });
    
    // 2. 파일명 표시 스크립트 (\기호는 JSP 이스케이프 방지)
    function updateFileName(input) {
        const display = document.getElementById('file-name-display');
        if (input.files && input.files.length > 0) {
            const count = input.files.length;
            display.textContent = count > 1 ? `파일 \${count}개 선택됨` : input.files[0].name;
            display.classList.remove('text-gray-500', 'italic');
            display.classList.add('text-blue-600', 'font-bold');
        } else {
            display.textContent = '선택된 파일 없음';
            display.classList.remove('text-blue-600', 'font-bold');
            display.classList.add('text-gray-500', 'italic');
        }
    }
</script>

<style>
    /* CKEditor 높이 및 모서리 설정 */
    .ck-editor__editable { 
        min-height: 400px; 
        border-radius: 0 0 8px 8px !important; 
        background-color: #fcfcfc !important;
    }
    .ck.ck-editor__main>.ck-editor__editable:focus {
        border-color: #111827 !important;
    }
</style>