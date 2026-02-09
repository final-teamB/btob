<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="cp" value="${pageContext.request.contextPath}" />

<nav class="fixed z-30 w-full bg-white border-b border-gray-200 dark:bg-gray-800 dark:border-gray-700">
  <div class="px-3 py-3 lg:px-5 lg:pl-3">
    <div class="flex items-center justify-between">
      
      <div class="flex items-center justify-start">
        <button id="toggleSidebarMobile" aria-expanded="true" aria-controls="sidebar" class="p-2 text-gray-600 rounded cursor-pointer lg:hidden hover:text-gray-900 hover:bg-gray-100 focus:bg-gray-100 dark:focus:bg-gray-700 focus:ring-2 focus:ring-gray-100 dark:focus:ring-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white">
          <svg id="toggleSidebarMobileHamburger" class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M3 5a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 10a1 1 0 011-1h6a1 1 0 110 2H4a1 1 0 01-1-1zM3 15a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1z" clip-rule="evenodd"></path></svg>
          <svg id="toggleSidebarMobileClose" class="hidden w-6 h-6" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path></svg>
        </button>
        <a href="${cp}/" class="flex ml-2 md:mr-24">
          <img src="https://flowbite-admin-dashboard.vercel.app/images/logo.svg" class="h-8 mr-3" alt="Flowbite Logo" />
          <span class="self-center text-xl font-semibold sm:text-2xl whitespace-nowrap dark:text-white">Flowbite</span>
        </a>
      </div>

      <div class="flex items-center">
        
        <div class="relative mr-3">
         	 <button type="button" id="notificationButton" data-dropdown-toggle="notification-dropdown" class="p-2 text-gray-500 rounded-lg hover:text-gray-900 hover:bg-gray-100 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-700">
           		 <span class="sr-only">View notifications</span>
          		 <img src="https://img.icons8.com/ios-glyphs/30/6B7280/alarm.png" class="w-6 h-6" alt="notifications">
           		 <div id="notification-badge" class="hidden absolute inline-flex items-center justify-center w-5 h-5 text-[10px] font-bold text-white bg-red-500 border-2 border-white rounded-full -top-0 -right-0 dark:border-gray-900">0</div>
          	</button>
          
          	<div id="notification-dropdown" class="z-50 hidden w-72 absolute -right-10 mt-3 bg-white rounded-xl shadow-2xl border border-gray-200 dark:bg-gray-800 dark:border-gray-700 overflow-hidden">
			    <div class="px-4 py-3 border-b dark:border-gray-700">
			        <span class="text-sm font-bold text-gray-900 dark:text-white">알림 목록</span>
			    </div>
			    <div id="notification-list" class="max-h-80 overflow-y-auto divide-y divide-gray-100 dark:divide-gray-700 custom-scrollbar"> </div>
			</div>
        </div>

        <button id="theme-toggle" type="button" class="text-gray-500 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-700 focus:outline-none focus:ring-4 focus:ring-gray-200 dark:focus:ring-gray-700 rounded-lg text-sm p-2.5 mr-2">
          <svg id="theme-toggle-dark-icon" class="hidden w-5 h-5" fill="currentColor" viewBox="0 0 20 20"><path d="M17.293 13.293A8 8 0 016.707 2.707a8.001 8.001 0 1010.586 10.586z"></path></svg>
          <svg id="theme-toggle-light-icon" class="hidden w-5 h-5" fill="currentColor" viewBox="0 0 20 20"><path d="M10 2a1 1 0 011 1v1a1 1 0 11-2 0V3a1 1 0 011-1zm4 8a4 4 0 11-8 0 4 4 0 018 0zm-.464 4.95l.707.707a1 1 0 001.414-1.414l-.707-.707a1 1 0 00-1.414 1.414zm2.12-10.607a1 1 0 010 1.414l-.706.707a1 1 0 11-1.414-1.414l.707-.707a1 1 0 011.414 0zM17 11a1 1 0 100-2h-1a1 1 0 100 2h1zm-7 4a1 1 0 011 1v1a1 1 0 11-2 0v-1a1 1 0 011-1zM5.05 6.464A1 1 0 106.465 5.05l-.708-.707a1 1 0 00-1.414 1.414l.707.707zm1.414 8.486l-.707.707a1 1 0 01-1.414-1.414l.707-.707a1 1 0 011.414 1.414zM4 11a1 1 0 100-2H3a1 1 0 000 2h1z"></path></svg>
        </button>
        <div class="flex items-center ml-3">
          <div>
            <button type="button" class="flex text-sm bg-gray-800 rounded-full focus:ring-4 focus:ring-gray-300 dark:focus:ring-gray-600" id="user-menu-button-2" aria-expanded="false" data-dropdown-toggle="dropdown-2">
              <span class="sr-only">Open user menu</span>
              <img class="w-8 h-8 rounded-full" src="https://flowbite.com/docs/images/people/profile-picture-5.jpg" alt="user photo">
            </button>
          </div>
          <div class="z-50 hidden my-4 text-base list-none bg-white divide-y divide-gray-100 rounded shadow dark:bg-gray-700 dark:divide-gray-600" id="dropdown-2">
  
		  <%-- 1. 로그인한 사용자에게만 이름 표시 --%>
		  <sec:authorize access="isAuthenticated()">
		    <div class="px-4 py-3" role="none">
		      <p class="text-sm text-gray-900 dark:text-white" role="none">
		        <sec:authentication property="principal.username" />님 반갑습니다.
		      </p>
		    </div>
		  </sec:authorize>
		
		  <%-- 2. 로그인하지 않은 사용자(익명)에게 표시 --%>
		  <sec:authorize access="isAnonymous()">
		    <div class="px-4 py-3" role="none">
		      <p class="text-sm text-gray-500 dark:text-gray-400" role="none">
		        로그인이 필요합니다.
		      </p>
		    </div>
		  </sec:authorize>
		
		  <ul class="py-1" role="none">
		    <li><a href="${cp}/" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-600" role="menuitem">Dashboard</a></li>
		    <li><a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-600" role="menuitem">Settings</a></li>
		    
		    <%-- 3. 로그아웃 버튼도 로그인 상태일 때만 노출 --%>
		    <sec:authorize access="isAuthenticated()">
		      <li><a href="${cp}/logout" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-600" role="menuitem">Sign out</a></li>
		    </sec:authorize>
		    
		    <%-- 4. 로그인하지 않았다면 로그인 버튼 노출 --%>
		    <sec:authorize access="isAnonymous()">
		      <li><a href="${cp}/login" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:text-gray-300 dark:hover:bg-gray-600" role="menuitem">Sign in</a></li>
		    </sec:authorize>
		  </ul>
		</div>
        </div>

      </div>
    </div>
  </div>
</nav>

<script>
    // 1. 경로 및 시큐리티 설정 (안전한 문자열 처리)
    var ctx = "${pageContext.request.contextPath}";
    var csrfToken = "${_csrf.token}";
    var csrfHeader = "${_csrf.headerName}";

    // 알림 목록 로드
    function fetchMyNotifications() {
        fetch(ctx + "/notificationList")
            .then(function(res) {
                if (!res.ok) throw new Error("로드 실패");
                return res.json();
            })
            .then(function(data) {
                renderNotificationUI(data);
            })
            .catch(function(err) {
                console.error("목록 에러:", err);
            });
    }

    function renderNotificationUI(notifications) {
        var listContainer = document.getElementById('notification-list');
        var badge = document.getElementById('notification-badge');
        var unread = notifications.filter(n => n.isRead === 'N');
        
        badge.innerText = unread.length;
        unread.length > 0 ? badge.classList.remove('hidden') : badge.classList.add('hidden');

        if (notifications.length === 0) {
            listContainer.innerHTML = '<p class="py-10 text-center text-xs text-gray-400">알림이 없습니다.</p>';
            return;
        }

        var html = '';
        notifications.forEach(function(item) {
            var isUnread = item.isRead === 'N';
            var bgClass = isUnread ? 'bg-blue-50/40 dark:bg-blue-900/10' : 'bg-white dark:bg-gray-800';
            
            html += `
                <a href="javascript:void(0);" onclick="handleNotiClick(\${item.notificationId}, '\${item.notificationType}', \${item.targetId})" 
                   class="block px-4 py-3.5 hover:bg-gray-50 dark:hover:bg-gray-700 transition \${bgClass}">
                    <div class="flex flex-col">
                        <div class="flex justify-between items-center mb-1">
                            <span class="text-[10px] font-bold text-blue-600 dark:text-blue-400 uppercase tracking-tight">\${item.notificationType}</span>
                            <span class="text-[9px] text-gray-400">\${item.regDtime}</span>
                        </div>
                        <p class="text-[13px] \${isUnread ? 'font-bold text-gray-900 dark:text-white' : 'text-gray-500'} leading-snug line-clamp-2">
                            \${item.message}
                        </p>
                    </div>
                </a>`;
        });
        listContainer.innerHTML = html;
    }

    /* ====================================
       알림 클릭 처리 - Invalid Name 에러 해결
       ==================================== */
    function handleNotiClick(id, type, targetId) {
        var headers = { 'Content-Type': 'application/json' };
        
        // CSRF 헤더 이름이 정상적일 때만 헤더에 추가 (에러 방지 핵심)
        if (csrfHeader && csrfHeader !== "" && csrfHeader !== "null") {
            headers[csrfHeader] = csrfToken;
        }

        // 1. 읽음 처리 요청 (@PutMapping("/read/{notificationId}"))
        fetch(ctx + "/read/" + id, {
            method: 'PUT',
            headers: headers
        })
        .then(function(res) {
            if (!res.ok) throw new Error("읽음 처리 서버 응답 실패");
            
            console.log("읽음 처리 완료(Y), 상세 페이지 이동 시도...");

            // 2. 타입별 이동 경로 설정 (TargetId 기반)
            if (type === 'DELIVERY') {
	            moveUrl = ctx + "/admin/delivery/detail/" + targetId;
	        } else if (type === 'ORDER') {
	            moveUrl = ctx + "" + targetId;
	        } else if (type === 'NOTICE') {
	            moveUrl = ctx + "" + targetId;
	        } else if (type === 'APPROVAL') {
	            moveUrl = ctx + "" + targetId;
	        }

            // 3. 페이지 이동 혹은 목록 갱신
            if (moveUrl !== "") {
                window.location.href = moveUrl;
            } else {
                fetchMyNotifications(); // 이동 경로가 없으면 목록만 새로고침 (숫자 사라짐)
            }
        })
        .catch(function(err) {
            console.error("클릭 처리 최종 에러:", err);
            fetchMyNotifications();
        });
    }

    document.addEventListener('DOMContentLoaded', fetchMyNotifications);
    setInterval(fetchMyNotifications, 60000);

	// 테마 토글 기존 로직 유지
    var themeToggleDarkIcon = document.getElementById('theme-toggle-dark-icon');
    var themeToggleLightIcon = document.getElementById('theme-toggle-light-icon');
    if (localStorage.getItem('color-theme') === 'dark' || (!('color-theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
        themeToggleLightIcon.classList.remove('hidden');
        document.documentElement.classList.add('dark');
    } else {
        themeToggleDarkIcon.classList.remove('hidden');
    }
    document.getElementById('theme-toggle').addEventListener('click', function() {
        themeToggleDarkIcon.classList.toggle('hidden');
        themeToggleLightIcon.classList.toggle('hidden');
        if (localStorage.getItem('color-theme') === 'light') {
            document.documentElement.classList.add('dark');
            localStorage.setItem('color-theme', 'dark');
        } else {
            document.documentElement.classList.remove('dark');
            localStorage.setItem('color-theme', 'light');
        }
    });
</script>

<style>
    /* 종 아이콘 아래 적당한 위치에 정렬 */
    #notification-dropdown {
        top: 100% !important;
        /* -right-10 대신 정교하게 조절하고 싶으면 여기서 px로 조절해 */
        right: -20px !important; 
        left: auto !important;
        transform: none !important;
    }
    .custom-scrollbar::-webkit-scrollbar { width: 3px; }
    .custom-scrollbar::-webkit-scrollbar-thumb { background: #e5e7eb; border-radius: 10px; }
</style>