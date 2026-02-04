<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 1. 기본 설정 (사용자 지정값 및 2026 기본 가이드 반영) --%>
<c:set var="showSearchArea" value="${empty showSearchArea ? true : showSearchArea}" scope="request" />
<c:set var="showPerPage" value="${empty showPerPage ? true : showPerPage}" scope="request" />
<c:set var="showAddBtn" value="${empty showAddBtn ? false : showAddBtn}" scope="request" />
<c:set var="showDownloadBtn" value="${empty showDownloadBtn ? false : showDownloadBtn}" scope="request" />

<%-- 2. 필수 리소스 로드 --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/tui_grid.css" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/datagrid.css" >
<script src="${pageContext.request.contextPath}/js/tui-grid.js"></script>
<%-- datagrid.js는 HTML 요소들이 모두 생성된 후 로드되어야 하므로 맨 아래 배치하거나 지연 로드합니다. --%>

<div class="space-y-6">
    <%-- 3. 상단 액션 영역 (신규등록/다운로드) --%>
    <div class="flex justify-end items-center space-x-3">
        <c:if test="${showDownloadBtn}">
            <button type="button" id="dg-btn-download"
                    class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 dark:bg-gray-800 dark:text-gray-300 dark:border-gray-600 dark:hover:bg-gray-700 transition shadow-sm">
                다운로드
            </button>
        </c:if>
        <c:if test="${showAddBtn}">
            <button type="button" onclick="handleAddAction()" 
                    class="px-4 py-2 text-sm font-semibold text-white bg-gray-900 rounded-lg shadow-md hover:bg-gray-800 dark:bg-gray-700 dark:hover:bg-gray-600 dark:border dark:border-gray-500 transition-all active:scale-95">
                + 신규 등록
            </button>
        </c:if>
    </div>

<%-- 검색 필터 섹션 --%>
<c:if test="${showSearchArea}">
    <section class="p-4 bg-white rounded-lg shadow-sm border border-gray-100 dark:bg-gray-800 dark:border-gray-700">
        <form id="dg-search-form" class="flex flex-wrap items-start gap-6" onsubmit="return false;">
            
            <%-- [구분] 그룹: 라벨 상단, 필터 하단 --%>
            <div id="dg-common-filter-wrapper" class="hidden flex-col gap-1.5">
                <label class="text-sm font-bold text-gray-700 dark:text-white">구분</label>
                <div class="flex items-center gap-2">
                    <select id="dg-common-filter" class="rounded-lg border border-gray-300 py-2 px-4 text-sm outline-none bg-white min-w-[120px]">
                        <option value="">전체</option>
                    </select>
                    <%-- JS에서 추가되는 필터(상태 등)가 이 옆으로 붙습니다 --%>
                </div>
            </div>

            <%-- [검색어] 그룹: 라벨 상단, 입력창 하단 --%>
            <div class="flex flex-col gap-1.5">
                <label class="text-sm font-bold text-gray-700 dark:text-white">검색어</label>
                <input type="text" id="dg-search-input" 
                       class="rounded-lg border border-gray-300 py-2 px-4 text-sm outline-none w-72" 
                       placeholder="내용을 입력하세요">
            </div>

            <%-- 버튼 그룹: 입력창 높이에 맞게 하단 정렬 --%>
            <div class="flex gap-2 self-end">
                <button type="button" id="dg-btn-search" class="px-5 py-2 text-sm font-bold text-white bg-slate-900 rounded-lg hover:bg-slate-800 transition h-[40px]">조회</button>
                <button type="reset" onclick="location.reload();" class="px-5 py-2 text-sm font-bold text-gray-500 bg-gray-100 rounded-lg hover:bg-gray-200 transition border h-[40px]">초기화</button>
            </div>
        </form>
    </section>
</c:if>

    <%-- 5. 데이터 그리드 섹션 --%>
    <section class="bg-white rounded-lg shadow-sm dark:bg-gray-800 border border-gray-100 dark:border-gray-700 overflow-hidden">
        <%-- 그리드 본체 --%>
        <div id="dg-container" class="w-full"></div>

        <%-- 6. 하단 페이징 영역: 템플릿이 들어갈 그릇 --%>
        <div class="px-5 py-10 flex flex-col md:flex-row justify-between items-center gap-4 border-t border-gray-200 dark:border-gray-700">
            <%-- 페이지당 개수 --%>
            <div class="w-32">
                <c:if test="${showPerPage}">
                    <select id="dg-per-page" class="w-full rounded-lg border border-gray-300 bg-white py-1.5 px-3 text-sm text-gray-700 dark:bg-gray-700 dark:text-white outline-none">
                        <option value="10" selected>10개씩</option>
                        <option value="25">25개씩</option>
                        <option value="50">50개씩</option>
                    </select>
                </c:if>
            </div> 
            
            <%-- [중요] 자바스크립트가 여기에 페이징 버튼들을 동적으로 그려넣습니다 --%>
            <div id="dg-pagination" class="tui-pagination"></div>
            
            <%-- 밸런스용 빈 공간 --%>
            <div class="hidden md:block w-32"></div>
        </div>
    </section>
</div>

<%-- 모든 DOM 요소가 준비된 후 JS 실행 --%>
<script src="${pageContext.request.contextPath}/js/datagrid.js"></script>