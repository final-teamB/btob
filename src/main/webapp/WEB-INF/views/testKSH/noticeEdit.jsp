<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- [1] 레이아웃 설정: 헤더 및 버튼 영역 제어 --%>
<c:set var="showSearchArea" value="false" scope="request" />
<c:set var="showAddBtn" value="false" scope="request" />

<%-- [2] 타이틀 영역 --%>
<div class="mx-4 my-6 space-y-6">
    <div class="px-5 py-4">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">공지사항 수정</h1>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">등록된 공지사항의 내용을 수정합니다.</p>
    </div>

    <%-- [3] 수정 폼 영역 --%>
    <div class="mx-5 p-6 bg-white dark:bg-gray-800 rounded-lg shadow-sm border border-gray-200 dark:border-gray-700">
        <form action="/notice/update" method="post" id="updateForm">
            <input type="hidden" name="noticeId" value="${notice.noticeId}">
            
            <div class="space-y-5">
                <%-- 제목 입력 --%>
                <div>
                    <label class="block mb-2 text-sm font-bold text-gray-900 dark:text-white">제목</label>
                    <input type="text" name="title" 
                           class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white" 
                           value="${notice.title}" required>
                </div>
                
                <%-- 내용 입력 (CKEditor) --%>
                <div>
                    <label class="block mb-2 text-sm font-bold text-gray-900 dark:text-white">내용</label>
                    <div class="text-gray-900">
                        <textarea name="content" id="editor">${notice.content}</textarea>
                    </div>
                </div>

                <%-- 버튼 영역 --%>
                <div class="flex justify-end space-x-3 pt-4 border-t border-gray-100 dark:border-gray-700">
                    <button type="button" 
                            onclick="history.back()"
                            class="px-5 py-2.5 text-sm font-medium text-gray-900 bg-white border border-gray-200 rounded-lg hover:bg-gray-100 hover:text-blue-700 focus:z-10 focus:ring-4 focus:ring-gray-200 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700">
                        취소
                    </button>
                    <button type="submit" 
                            class="px-5 py-2.5 text-sm font-bold text-center text-white bg-blue-700 rounded-lg hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800">
                        수정완료
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.ckeditor.com/ckeditor5/39.0.1/classic/ckeditor.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // CKEditor 초기화
        ClassicEditor
            .create(document.querySelector('#editor'), {
                // 필요 시 에디터 높이 설정
            })
            .catch(error => {
                console.error(error);
            });
    });
</script>

<style>
    /* CKEditor 높이 조절 및 스타일 맞춤 */
    .ck-editor__editable {
        min-height: 400px;
        background-color: #f9fafb !important;
    }
    .dark .ck-editor__editable {
        background-color: #374151 !important;
        color: white;
    }
</style>