<%@ page contentType="text/html; charset=UTF-8" %>
<aside id="sidebar" class="fixed top-0 left-0 z-20 flex-col flex-shrink-0 w-64 h-full pt-16 font-normal duration-75 transition-transform -translate-x-full bg-white border-r border-gray-200 lg:translate-x-0 lg:flex dark:bg-gray-800 dark:border-gray-700" aria-label="Sidebar">
  <div class="relative flex flex-col flex-1 min-h-0 pt-0 bg-white border-r border-gray-200 dark:bg-gray-800 dark:border-gray-700">
    <div class="flex flex-col flex-1 pt-5 pb-4 overflow-y-auto">
      <div class="flex-1 px-3 space-y-1 bg-white divide-y divide-gray-200 dark:bg-gray-800 dark:divide-gray-700">
        <ul class="pb-2 space-y-2">

          <!-- 사용자관리 -->
          <li>
            <a href="/admin/user/list" class="flex items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
              <svg class="w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                <path d="M10 10a4 4 0 100-8 4 4 0 000 8z"></path>
                <path fill-rule="evenodd" d="M2 16a6 6 0 1112 0H2z" clip-rule="evenodd"></path>
              </svg>
              <span class="ml-3" sidebar-toggle-item>사용자관리</span>
            </a>
          </li>

          <!-- 상품관리 -->
          <li>
            <a href="/admin/products" class="flex items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
              <svg class="w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                <path d="M4 3a2 2 0 00-2 2v2a2 2 0 002 2v6a1 1 0 001.447.894L10 14.618l4.553 2.276A1 1 0 0016 15V9a2 2 0 002-2V5a2 2 0 00-2-2H4z"></path>
              </svg>
              <span class="ml-3" sidebar-toggle-item>상품관리</span>
            </a>
          </li>

          <!-- 주문관리 -->
          <li>
            <a href="/admin/orders" class="flex items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
              <svg class="w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                <path d="M4 3a2 2 0 00-2 2v1a1 1 0 001 1h14a1 1 0 001-1V5a2 2 0 00-2-2H4z"></path>
                <path fill-rule="evenodd" d="M3 8h14v7a2 2 0 01-2 2H5a2 2 0 01-2-2V8zm4 3a1 1 0 100 2h6a1 1 0 100-2H7z" clip-rule="evenodd"></path>
              </svg>
              <span class="ml-3" sidebar-toggle-item>주문관리</span>
            </a>
          </li>

          <!-- 배송관리 -->
          <li>
            <a href="/admin/delivery/list" class="flex items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
              <svg class="w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                <path d="M3 3a1 1 0 000 2h1l1 3h9l1-3h1a1 1 0 100-2H3z"></path>
                <path d="M5 9h10v5a2 2 0 01-2 2h-1a2 2 0 11-4 0H7a2 2 0 01-2-2V9z"></path>
              </svg>
              <span class="ml-3" sidebar-toggle-item>배송관리</span>
            </a>
          </li>
          </li>

          <!-- 공지사항관리 -->
          <li>
            <a href="/notice" class="flex items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
              <svg class="w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                <path d="M10 2a2 2 0 00-2 2v1H5v2h1v7h2v-7h2v7h2v-7h1V5h-3V4a2 2 0 00-2-2z"></path>
              </svg>
              <span class="ml-3" sidebar-toggle-item>공지사항관리</span>
            </a>
          </li>

          <!-- 문의관리 -->
          <li>
		  <a href="/support/admin/faqList" class="flex items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
		    <svg class="w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
		      <path d="M18 10c0 3.866-3.582 7-8 7a8.96 8.96 0 01-3.258-.606L2 17l.879-3.516A6.718 6.718 0 012 10c0-3.866 3.582-7 8-7s8 3.134 8 7z"></path>
		    </svg>
		    <span class="ml-3" sidebar-toggle-item>문의관리</span>
		  </a>
		</li>

          <!-- 통계관리 -->
          <li>
		  <a href="/admin/stats/main" class="flex items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
		    <svg class="w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
		      <path d="M4 13a1 1 0 011-1h1v3H4v-2z"></path>
		      <path d="M9 9a1 1 0 011-1h1v7H9V9z"></path>
		      <path d="M14 5a1 1 0 011-1h1v11h-2V5z"></path>
		    </svg>
		    <span class="ml-3" sidebar-toggle-item>통계관리</span>
		  </a>
		</li>

        </ul>
      </div>
    </div>
  </div>
</aside>

<div class="fixed inset-0 z-10 hidden bg-gray-900/50 dark:bg-gray-900/90" id="sidebarBackdrop"></div>
