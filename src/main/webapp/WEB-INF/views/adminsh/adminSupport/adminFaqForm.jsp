<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- [팀 공통 가이드: Charcoal & White 미니멀 폼 레이아웃] --%>
<div class="mx-4 my-6 space-y-6">
    
    <%-- [1. 타이틀 영역] --%>
    <div class="px-8 py-4 border-b border-gray-100 dark:border-gray-700">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
            <c:choose>
                <c:when test="${not empty faq.faqId}">FAQ 수정</c:when>
                <c:otherwise>FAQ 신규 등록</c:otherwise>
            </c:choose>
        </h1>
        <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">사용자가 자주 묻는 질문에 대한 정확한 정보를 입력해 주세요.</p>
    </div>

    <%-- [2. 입력 폼 영역] --%>
    <section class="mx-5 p-8 bg-white rounded-lg shadow-sm border border-gray-100 dark:bg-gray-800 dark:border-gray-700">
		<form action="/support/admin/${faq.faqId > 0 ? 'modifyFaq' : 'registerFaq'}" method="post" class="space-y-6 max-w-4xl">
            <%-- 수정 시 필수 ID 값 --%>
            <c:if test="${faq.faqId > 0}">
        <input type="hidden" name="faqId" value="${faq.faqId}">
    </c:if>

            <%-- 카테고리 선택 --%>
            <div class="grid grid-cols-1 md:grid-cols-4 items-center gap-4">
                <label class="text-sm font-bold text-gray-700 dark:text-gray-300">카테고리 <span class="text-red-500">*</span></label>
                <div class="md:col-span-3">
                    <select name="category" required 
                            class="w-full md:w-1/3 px-4 py-2 text-sm border border-gray-300 rounded-lg focus:ring-1 focus:ring-gray-900 focus:outline-none dark:bg-gray-700 dark:text-white transition-all">
                        <option value="DELIVERY" ${faq.category=='DELIVERY'?'selected':''}>배송</option>
                        <option value="PAYMENT" ${faq.category=='PAYMENT'?'selected':''}>결제</option>
                        <option value="PRODUCT" ${faq.category=='PRODUCT'?'selected':''}>상품</option>
                        <option value="ETC" ${faq.category=='ETC'?'selected':''}>기타</option>
                    </select>
                </div>
            </div>

            <%-- 질문 입력 --%>
            <div class="grid grid-cols-1 md:grid-cols-4 items-center gap-4 border-t border-gray-50 pt-6 dark:border-gray-700">
                <label class="text-sm font-bold text-gray-700 dark:text-gray-300">질문 (Question) <span class="text-red-500">*</span></label>
                <div class="md:col-span-3">
                    <input type="text" name="question" value="${faq.question}" required 
                           placeholder="사용자가 질문할 내용을 입력하세요."
                           class="w-full px-4 py-2 text-sm border border-gray-300 rounded-lg focus:ring-1 focus:ring-gray-900 focus:outline-none dark:bg-gray-700 dark:text-white transition-all">
                </div>
            </div>

            <%-- 답변 입력 --%>
            <div class="grid grid-cols-1 md:grid-cols-4 items-start gap-4 border-t border-gray-50 pt-6 dark:border-gray-700">
                <label class="text-sm font-bold text-gray-700 dark:text-gray-300 mt-2">답변 (Answer) <span class="text-red-500">*</span></label>
                <div class="md:col-span-3">
                    <textarea name="answer" rows="12" required 
                              placeholder="질문에 대한 상세 답변을 입력하세요."
                              class="w-full px-4 py-2 text-sm border border-gray-300 rounded-lg focus:ring-1 focus:ring-gray-900 focus:outline-none dark:bg-gray-700 dark:text-white transition-all resize-none">${faq.answer}</textarea>
                    <p class="text-xs text-gray-400 mt-2">사용자에게 직접 노출되는 답변이므로 정확하게 작성해 주세요.</p>
                </div>
            </div>

            <%-- [3. 하단 액션 버튼] --%>
            <div class="flex justify-end space-x-3 pt-8 border-t border-gray-100 dark:border-gray-700">
                <button type="button" onclick="history.back()" 
                        class="px-6 py-2.5 text-sm font-medium text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 transition-all">
                    취소
                </button>
                <button type="submit" 
                        class="px-8 py-2.5 text-sm font-bold text-white bg-gray-900 rounded-lg hover:bg-gray-800 shadow-md transition-all active:scale-95">
                    저장하기
                </button>
            </div>
        </form>
    </section>
</div>