<%@ page contentType="text/html; charset=UTF-8" %>
<aside id="sidebar" class="fixed top-0 left-0 z-20 flex flex-col flex-shrink-0 hidden w-64 h-full pt-16 font-normal duration-75 lg:flex transition-width" aria-label="Sidebar">
  <div class="relative flex flex-col flex-1 min-h-0 pt-0 bg-white border-r border-gray-200 dark:bg-gray-800 dark:border-gray-700">
    <div class="flex flex-col flex-1 pt-5 pb-4 overflow-y-auto">
      <div class="flex-1 px-3 space-y-1 bg-white divide-y divide-gray-200 dark:bg-gray-800 dark:divide-gray-700">
        
        <ul class="pb-2 space-y-2">
          <li class="px-3 py-2 text-xs font-semibold text-gray-500 uppercase tracking-wider">유류 카테고리</li>
          
          <li>
            <a href="/user/products?category=GASOLINE" class="flex items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
              <span class="w-2 h-2 bg-green-500 rounded-full"></span>
              <span class="ml-3">휘발유 (Gasoline)</span>
            </a>
          </li>

          <li>
            <a href="/user/products?category=DIESEL" class="flex items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
              <span class="w-2 h-2 bg-blue-500 rounded-full"></span>
              <span class="ml-3">경유 (Diesel)</span>
            </a>
          </li>

          <li>
            <a href="/user/products?category=KEROSENE" class="flex items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
              <span class="w-2 h-2 bg-yellow-500 rounded-full"></span>
              <span class="ml-3">등유 (Kerosene)</span>
            </a>
          </li>

          <li>
            <a href="/user/products?category=ETC" class="flex items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
              <span class="w-2 h-2 bg-gray-500 rounded-full"></span>
              <span class="ml-3">기타 유류</span>
            </a>
          </li>
        </ul>

        <ul class="pt-4 pb-2 space-y-2">
          <li class="px-3 py-2 text-xs font-semibold text-gray-500 uppercase tracking-wider">나의 거래/배송</li>
          <li>
            <a href="/user/orders/list" class="flex items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
              <svg class="w-5 h-5 text-gray-400 group-hover:text-gray-900" fill="currentColor" viewBox="0 0 20 20"><path d="M4 4a2 2 0 012-2h4.586A2 2 0 0112 2.586L15.414 6A2 2 0 0116 7.414V16a2 2 0 01-2 2H6a2 2 0 01-2-2V4z"></path></svg>
              <span class="ml-3">주문 및 견적현황</span>
            </a>
          </li>
        </ul>

        <ul class="pt-4 pb-2 space-y-2">
          <li>
            <a href="/notice/user/list" class="flex  items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
              <svg class="w-5 h-5 text-gray-400 group-hover:text-gray-900" fill="currentColor" viewBox="0 0 20 20"><path d="M10 2a2 2 0 00-2 2v1H5v2h1v7h2v-7h2v7h2v-7h1V5h-3V4a2 2 0 00-2-2z"></path></svg>
              <span class="ml-3">공지사항</span>
            </a>
          </li>
          <li>
            <a href="/support/faq" class="flex items-center p-2 text-base text-gray-900 rounded-lg hover:bg-gray-100 group dark:text-gray-200 dark:hover:bg-gray-700">
              <svg class="w-5 h-5 text-gray-400 group-hover:text-gray-900" fill="currentColor" viewBox="0 0 20 20"><path d="M18 10c0 3.866-3.582 7-8 7a8.96 8.96 0 01-3.258-.606L2 17l.879-3.516A6.718 6.718 0 012 10c0-3.866 3.582-7 8-7s8 3.134 8 7z"></path></svg>
              <span class="ml-3">문의/챗봇</span>
            </a>
          </li>
        </ul>

      </div>
    </div>
  </div>
</aside>