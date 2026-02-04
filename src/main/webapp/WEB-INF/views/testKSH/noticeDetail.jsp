<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%-- [1] 레이아웃 설정: 헤더 영역 표시 설정 (목록으로 이동 버튼 등 활용 가능) --%>
<c:set var="showSearchArea" value="false" scope="request" />
<c:set var="showAddBtn" value="false" scope="request" />

<div class="mx-4 my-6 space-y-6">
    <%-- [2] 타이틀 영역 --%>
    <div class="px-5 py-4 pb-0">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">공지사항 상세 조회</h1>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">공지사항의 상세 내용과 첨부파일을 확인합니다.</p>
    </div>

    <%-- [3] 상세 내용 카드 영역 --%>
    <div class="mx-5 bg-white dark:bg-gray-800 shadow-md rounded-lg overflow-hidden border border-gray-200 dark:border-gray-700">
        <div class="p-6">
            <h2 class="text-3xl font-extrabold text-gray-900 dark:text-white mb-4">
                <c:out value="${notice.title}" />
            </h2>
            
            <div class="flex flex-wrap justify-between items-center text-sm text-gray-600 dark:text-gray-400 bg-gray-50 dark:bg-gray-700 p-4 rounded-md mb-6">
                <div class="space-x-4">
                    <span><strong class="text-gray-900 dark:text-white">작성자:</strong> ${notice.displayRegId}</span>
                    <span><strong class="text-gray-900 dark:text-white">등록일:</strong> ${notice.formattedRegDate}</span>
                </div>
                <div>
                    <span><strong class="text-gray-900 dark:text-white">조회수:</strong> ${notice.viewCount}</span>
                </div>
            </div>

            <div class="notice-content min-h-[300px] text-gray-800 dark:text-gray-200 leading-relaxed mb-8 border-t border-gray-100 dark:border-gray-700 pt-6">
                <c:out value="${notice.content}" escapeXml="false" />
            </div>

            <div class="mb-8 p-4 bg-gray-50 dark:bg-gray-900 rounded-lg">
                <h6 class="text-sm font-bold text-gray-900 dark:text-white mb-3 flex items-center">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13"></path></svg>
                    첨부파일
                </h6>
                <ul class="space-y-2">
                    <c:forEach var="file" items="${files}">
                        <li>
                            <a href="/notice/download/${file.savedFileName}" class="text-sm text-blue-600 hover:text-blue-800 dark:text-blue-400 dark:hover:text-blue-300 flex items-center transition">
                                <span class="mr-1">📎</span> ${file.originName}
                            </a>
                        </li>
                    </c:forEach>
                    <c:if test="${empty files}">
                        <li class="text-sm text-gray-500 italic">첨부된 파일이 없습니다.</li>
                    </c:if>
                </ul>
            </div>

            <hr class="border-gray-200 dark:border-gray-700">

            <div class="flex justify-between mt-6">
                <button type="button" 
                        class="px-5 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 transition"
                        onclick="location.href='/notice'">
                    목록으로
                </button>
                
                <sec:authorize access="hasRole('ADMIN')">
                    <div class="flex space-x-2">
                        <button type="button" 
                                class="px-5 py-2 text-sm font-medium text-white bg-amber-500 rounded-lg hover:bg-amber-600 transition"
                                onclick="location.href='/notice/edit/${notice.noticeId}'">
                            수정
                        </button>
                        <button type="button" 
                                class="px-5 py-2 text-sm font-medium text-white bg-red-500 rounded-lg hover:bg-red-600 transition"
                                onclick="deleteNotice(${notice.noticeId})">
                            삭제
                        </button>
                    </div>
                </sec:authorize>
            </div>
        </div>
    </div>
</div>

<script>
/**
 * 공지사항 삭제 처리
 * adminFaqList.jsp의 handleDelete 방식(fetch)을 참고하여 일관성 있게 구현
 */
function deleteNotice(id) {
    if(confirm("정말 이 공지사항을 삭제하시겠습니까?")) {
        fetch('/notice/delete/' + id, { 
            method: 'GET' // 기존 요구사항 유지
        })
        .then(res => {
            if(res.ok) {
                alert("삭제되었습니다.");
                location.href = '/notice';
            } else {
                alert("삭제 권한이 없거나 오류가 발생했습니다.");
            }
        })
        .catch(err => {
            console.error('Error:', err);
            alert("서버 통신 중 오류가 발생했습니다.");
        });
    }
}
</script>

<style>
    /* 기존 공통 스타일 유지 */
    .notice-content img { max-width: 100%; height: auto; }
</style>