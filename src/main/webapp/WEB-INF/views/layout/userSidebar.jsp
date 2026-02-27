<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


<aside id="sidebar" class="fixed top-0 left-0 z-20 flex-col flex-shrink-0 w-64 h-full pt-16 font-normal duration-75 transition-transform -translate-x-full bg-white border-r border-gray-200 lg:translate-x-0 lg:flex dark:bg-gray-800 dark:border-gray-700" aria-label="Sidebar">

<jsp:include page="/WEB-INF/views/common/common.jsp" />
	
  <div class="relative flex flex-col flex-1 min-h-0 pt-0 bg-white border-r border-gray-200 dark:bg-gray-800 dark:divide-gray-700">
    <div class="flex flex-col flex-1 pt-5 pb-4 overflow-y-auto">
      <div class="flex-1 px-3 space-y-1 bg-white divide-y divide-gray-200 dark:bg-gray-800 dark:divide-gray-700">
        
        <ul class="pb-2 space-y-2">
		  <li class="px-3 py-2 text-xs font-semibold text-gray-500 uppercase tracking-wider dark:text-gray-400">
		    상품 조회 및 견적
		  </li>
		  <li>
		    <a href="/usr/productView/list" class="flex items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
		      <span class="w-3 h-3 bg-yellow-300 rounded-full shadow-sm"></span>
		      <span class="ml-4 font-medium" sidebar-toggle-item>상품 카탈로그</span>
		    </a>
		  </li>
		</ul>

       <ul class="pt-4 pb-2 space-y-2">
		  <li class="px-3 py-2 text-xs font-semibold text-gray-500 uppercase tracking-wider dark:text-gray-400">
		    마이오피스
		  </li>
		
		  <li>
		    <a href="/account/mypage" class="flex items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
		      <svg class="w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
		        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
		      </svg>
		      <span class="ml-3" sidebar-toggle-item>내 정보 관리</span>
		    </a>
		  </li>
         
          <li>
            <a href="/order/list" class="flex items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
              <svg class="w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17a2 2 0 11-4 0 2 2 0 014 0zM19 17a2 2 0 11-4 0 2 2 0 014 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16V6a1 1 0 00-1-1H4a1 1 0 00-1 1v10a1 1 0 001 1h1m8-1a1 1 0 01-1 1H9m4-1V8a1 1 0 011-1h2.586a1 1 0 01.707.293l3.414 3.414a1 1 0 01.293.707V16a1 1 0 01-1 1h-1m-6-1a1 1 0 001 1h1M5 17a2 2 0 104 0m-4 0a2 2 0 114 0m6 0a2 2 0 104 0m-4 0a2 2 0 114 0"/>
              </svg>
              <span class="ml-3" sidebar-toggle-item>주문/배송 목록</span>
            </a>
          </li>

          <li>
            <a href="/document/list" class="flex items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
              <svg class="w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
              </svg>
              <span class="ml-3" sidebar-toggle-item>문서 관리</span>
            </a>
          </li>

          <li>
            <a href="/notice/user/list" class="flex items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
              <svg class="w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h3.7a2 2 0 001.856-.586l1.828-1.828A2 2 0 0123 14.3V11a3 3 0 00-6 0v3a1 1 0 001 1zM8 17H6a2 2 0 01-2-2V7a2 2 0 012-2h2m0 0V3a2 2 0 012-2h4a2 2 0 012 2v2M8 17h4"/>
              </svg>
              <span class="ml-3" sidebar-toggle-item>공지사항</span>
            </a>
          </li>

	       <li>
			  <a href="/support/user/faqList" class="flex items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
			    <svg class="w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
			      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"/>
			    </svg>
			    <span class="ml-3" sidebar-toggle-item>문의/챗봇</span>
			  </a>
			</li>
			
			 <sec:authorize access="hasRole('MASTER')">
		    <li class="mt-4 px-3 py-1 text-[10px] font-bold text-blue-600 uppercase dark:text-blue-400">
		      대표 전용
		    </li>
		    
		    <li>
		      <a href="/users/list" class="flex items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
		        <svg class="w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
		          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
		        </svg>
		        <span class="ml-3" sidebar-toggle-item>사원 관리</span>
		      </a>
		    </li>
		    
		    <li>
		      <a href="/users/pending" class="flex items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
		        <svg class="w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
		            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z" />
		        </svg>
		        <span class="flex-1 ml-3 whitespace-nowrap">신규 가입 관리</span>
		        
		        <span id="user-pending-badge" 
				      class="${userPendingCount > 0 ? '' : 'hidden'} inline-flex items-center justify-center w-5 h-5 ml-3 text-xs font-semibold text-green-800 bg-green-100 rounded-full dark:bg-green-900 dark:text-green-300">
				    ${userPendingCount > 0 ? userPendingCount : 0}
				</span>
		      </a>
		    </li>
		    
			<li>
			    <a href="/trade/pending" class="flex items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
			        <svg class="w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
			            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4" />
			        </svg>
			        <span class="flex-1 ml-3 whitespace-nowrap">전자 결재 관리</span>
			        
			        <span id="pending-badge" 
			              class="${pendingCount > 0 ? '' : 'hidden'} inline-flex items-center justify-center w-5 h-5 ml-3 text-xs font-semibold text-blue-800 bg-blue-100 rounded-full dark:bg-blue-900 dark:text-blue-300">
			            ${pendingCount > 0 ? pendingCount : 0}
			        </span>
			    </a>
			</li>
		  </sec:authorize>
	    </ul>
	</li>
        </ul>
      </div>
    </div>
  </div>
</aside>

<div class="fixed inset-0 z-10 hidden bg-gray-900/50 dark:bg-gray-900/90" id="sidebarBackdrop"></div>