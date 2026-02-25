<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- [1] 레이아웃 설정: 목록과 마찬가지로 버튼/검색창 끔 --%>
<c:set var="showSearchArea" value="false" scope="request" />
<c:set var="showAddBtn" value="false" scope="request" />

<div class="mx-4 my-8">
    <div class="mx-auto space-y-6">
        
        <%-- [2] 제목 및 정보 영역 --%>
        <div class="border-b border-gray-200 dark:border-gray-700 pb-6">
            <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-4">
                <c:out value="${notice.title}"/>
            </h1>
            <div class="flex flex-wrap items-center text-sm text-gray-500 dark:text-gray-400 gap-y-2">
                <span class="flex items-center">
                    <span class="font-bold text-gray-700 dark:text-gray-300 mr-1">작성자:</span> 관리자
                </span>
                <span class="mx-3 text-gray-300">|</span>
                <span class="flex items-center">
                    <span class="font-bold text-gray-700 dark:text-gray-300 mr-1">등록일:</span> ${notice.formattedRegDate}
                </span>
                <span class="mx-3 text-gray-300">|</span>
                <span class="flex items-center">
                    <span class="font-bold text-gray-700 dark:text-gray-300 mr-1">조회수:</span> ${notice.viewCount}
                </span>
            </div>
        </div>

        <%-- [3] 본문 영역 (CKEditor로 작성된 HTML이 그대로 렌더링됨) --%>
        <div class="bg-white dark:bg-gray-800 p-8 rounded-xl shadow-sm border border-gray-100 dark:border-gray-700">
            <div class="prose max-w-none dark:prose-invert text-gray-800 dark:text-gray-200 min-h-[400px]">
                ${notice.content}
            </div>
        </div>

        <%-- [4] 첨부파일 영역 --%>
		<c:if test="${not empty notice.noticeFiles}">
		    <div class="bg-gray-50 dark:bg-gray-900/50 rounded-xl p-6 border border-gray-100 dark:border-gray-700">
		        <h3 class="text-sm font-bold text-gray-700 dark:text-gray-300 mb-4 flex items-center">
		            <span class="mr-2">📎</span> 첨부파일
		        </h3>
		        <ul class="grid grid-cols-1 md:grid-cols-2 gap-3">
		            <c:forEach var="file" items="${notice.noticeFiles}">
		                <c:if test="${file.useYn eq 'Y'}">
		                    <li>
		                        <a href="/notice/download/${file.storedFileName}" 
		                           class="flex items-center p-3 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg hover:border-blue-500 hover:text-blue-600 transition-all group">
		                            <span class="text-sm truncate flex-1 font-medium text-gray-600 dark:text-gray-400 group-hover:text-blue-600">
		                                ${file.originFileName}
		                            </span>
		                            <span class="ml-2 text-xs text-blue-500 font-bold">다운로드</span>
		                        </a>
		                    </li>
		                </c:if>
		            </c:forEach>
		        </ul>
		    </div>
		</c:if>

        <%-- [5] 하단 버튼 --%>
        <div class="flex justify-center pt-6">
            <button type="button" onclick="location.href='/notice/user/list'" 
                    class="px-10 py-3 text-sm font-bold text-white bg-gray-900 rounded-lg hover:bg-gray-800 shadow-md transition-all active:scale-95">
                목록으로 돌아가기
            </button>
        </div>

    </div>
</div>

<style>
    /* 본문 내 이미지 등이 영역을 벗어나지 않게 조정 */
    .prose img { max-width: 100%; height: auto; border-radius: 8px; }
    /* CKEditor 스타일 대응 (글자 크기 등) */
    .prose p { margin-bottom: 1rem; line-height: 1.8; }
</style>