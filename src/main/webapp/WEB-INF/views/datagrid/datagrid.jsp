<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 로컬 리소스 로드 --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/tui_grid.css" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/datagrid.css" >
<script src="${pageContext.request.contextPath}/js/tui-grid.js"></script>
<script src="${pageContext.request.contextPath}/js/datagrid.js"></script>

<div class="mx-4 my-6 space-y-4">

    <%-- [1. 액션 버튼 영역] 필요한 버튼만 true로 설정하여 노출 --%>
    <div class="flex flex-col md:flex-row justify-between items-center gap-4 px-2">
       
        <%-- 우측: 개별 추가 및 내보내기 액션 --%>
        <div class="flex items-center space-x-2">
            <c:if test="${showAddBtn}">
			    <button type="button" 
			            onclick="handleAddAction()" 
			            class="px-4 py-1.5 text-sm font-semibold text-white bg-gray-900 rounded-lg shadow-md hover:bg-gray-800 dark:bg-gray-700 dark:hover:bg-gray-600 transition-all active:scale-95">
			        등록
			    </button>
			</c:if>
        </div>
    </div>

  	<%-- [2. 검색 및 필터 영역] --%>
	<section class="p-4 bg-white rounded-lg shadow-sm dark:bg-gray-800 border border-gray-100 dark:border-gray-700">
	    <div class="flex flex-wrap items-center justify-between gap-4">
	        <div class="flex items-center gap-3">
	         
	            <div id="dg-common-filter-wrapper" class="hidden">
	                <select id="dg-common-filter" 
	                        class="rounded-lg border border-gray-300 bg-white py-2 px-3 text-sm text-gray-700 outline-none focus:ring-2 focus:ring-gray-400 dark:bg-gray-700 dark:border-gray-600 dark:text-white h-[40px] min-w-[140px]">
                    </select>
	            </div>
	
	            <div class="relative">
	                <input type="text" id="dg-search-input"
	                       class="w-64 rounded-lg border border-gray-300 bg-white py-2 px-4 text-sm text-gray-700 outline-none focus:ring-2 focus:ring-gray-400 dark:bg-gray-700 dark:border-gray-600 dark:text-white h-[40px]"
	                       placeholder="검색...">
	            </div>
	            
	            <button type="button" id="dg-btn-search" 
	                    class="px-6 py-2 text-sm font-bold text-white bg-gray-900 rounded-lg hover:bg-gray-800 dark:bg-gray-700 transition-all shadow-sm h-[40px]">
	                조회
	            </button>
	        </div>
	    </div>
	</section>

	<%-- [3. 데이터 그리드 영역] --%>
	<section class="overflow-visible"> 
	    <%-- 그리드 본체: CSS에서 설정한 min-width: 1100px이 이 아래에서 작동함 --%>
	    <div id="dg-container"></div>
	
	    <%-- 하단 페이징 & 개수 설정 영역 --%>
	    <div class="px-2 py-6 flex flex-col md:flex-row justify-between items-center gap-4">
	        <%-- 왼쪽 여백 (데스크탑에서 중앙 정렬 유지용) --%>
	        <div class="hidden md:block w-32"></div> 
	        
	        <%-- 중앙 페이징 버튼 --%>
	        <div id="dg-pagination" class="flex items-center"></div>
	
	        <%-- 우측 개수 선택 --%>
	        <div class="w-32">
	            <select id="dg-per-page" class="w-full rounded-lg border border-gray-300 bg-white py-1.5 px-3 text-sm text-gray-700 dark:bg-gray-700 dark:border-gray-600 dark:text-white outline-none focus:ring-2 focus:ring-gray-400">
	                <option value="5">5개씩</option>
	                <option value="10" selected>10개씩</option>
	                <option value="25">25개씩</option>
	                <option value="50">50개씩</option>
	            </select>
	        </div>
	    </div>
	</section>
</div>