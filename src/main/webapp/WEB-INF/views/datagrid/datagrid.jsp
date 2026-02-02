<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 1. 변수 설정 (최상단 공백 없이) --%>
<c:set var="showSearchArea" value="${empty showSearchArea ? true : showSearchArea}" scope="request" />
<c:set var="showPerPage" value="${empty showPerPage ? true : showPerPage}" scope="request" />
<c:set var="showAddBtn" value="${empty showAddBtn ? false : showAddBtn}" scope="request" />

<%-- 2. 리소스 로드 --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/tui_grid.css" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/datagrid.css" >
<script src="${pageContext.request.contextPath}/js/tui-grid.js"></script>
<script src="${pageContext.request.contextPath}/js/datagrid.js"></script>

<%-- 3. 검색 및 등록 영역 --%>
<c:if test="${showSearchArea or showAddBtn}">
    <section class="p-4 bg-white rounded-lg shadow-sm dark:bg-gray-800 border border-gray-100 dark:border-gray-700">
        <div class="flex flex-wrap items-center justify-between gap-4">
            
            <%-- 모든 요소를 왼쪽으로 정렬 --%>
            <div class="flex items-center gap-2">
                
                <%-- 검색 영역 (조건부) --%>
                <c:if test="${showSearchArea}">
                    <%-- 필터 --%>
                    <div id="dg-common-filter-wrapper" class="hidden">
                        <select id="dg-common-filter" class="rounded-lg border border-gray-300 bg-white py-2 px-3 text-sm h-[40px] dark:bg-gray-700 outline-none"></select>
                    </div>

                    <%-- 검색창 --%>
                    <div class="relative">
                        <input type="text" id="dg-search-input" 
                               class="w-64 rounded-lg border border-gray-300 bg-white py-2 px-4 text-sm h-[40px] dark:bg-gray-700 outline-none" 
                               placeholder="검색...">
                    </div>
                    
                    <%-- 조회 버튼 --%>
                    <button type="button" id="dg-btn-search" 
                            class="px-6 py-2 text-sm font-bold text-white bg-gray-900 rounded-lg hover:bg-gray-800 h-[40px] transition-all shadow-sm">
                        조회
                    </button>
                </c:if>

                <%-- 등록 버튼 (조회 버튼 바로 옆에 위치) --%>
                <c:if test="${showAddBtn}">
                    <button type="button" onclick="handleAddAction()" 
                            class="px-6 py-2 text-sm font-bold text-white bg-green-600 rounded-lg hover:bg-green-700 h-[40px] transition-all shadow-sm">
                        등록
                    </button>
                </c:if>
            </div>            
        </div>
    </section>
</c:if>

<%-- 4. 그리드 영역 --%>
<section class="overflow-visible">
    <div id="dg-container"></div>
    <div class="px-2 py-6 flex flex-col md:flex-row justify-between items-center gap-4">
        <div class="hidden md:block w-32"></div> 
        <div id="dg-pagination" class="flex items-center"></div>
        <div class="w-32">
            <c:if test="${showPerPage}">
                <select id="dg-per-page" class="w-full rounded-lg border border-gray-300 py-1.5 px-3 text-sm">
                    <option value="5">5개씩</option>
                    <option value="10" selected>10개씩</option>
                    <option value="25">25개씩</option>
                    <option value="50">50개씩</option>
                </select>
            </c:if>
        </div>
    </div>
</section>