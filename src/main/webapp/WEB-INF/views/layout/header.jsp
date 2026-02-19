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
          <svg id="toggleSidebarMobileClose" class="hidden w-6 h-6" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 110 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path></svg>
        </button>
        
        <a href="${cp}/" class="flex ml-2 md:mr-24">
          <img src="https://flowbite-admin-dashboard.vercel.app/images/logo.svg" class="h-8 mr-3" alt="Flowbite Logo" />
          <span class="self-center text-xl font-semibold sm:text-2xl whitespace-nowrap dark:text-white">Flowbite</span>
        </a>
      </div>

      <div class="flex items-center">
        
        <div class="relative mr-1">
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

        <div class="flex items-center">
          <div>
            <button type="button" class="flex text-sm bg-gray-100 rounded-full focus:ring-4 focus:ring-gray-300 dark:focus:ring-gray-600 overflow-hidden" id="user-menu-button-2" aria-expanded="false" data-dropdown-toggle="dropdown-2">
			    <span class="sr-only">Open user menu</span>
			    
			    <div class="w-8 h-8 flex items-center justify-center bg-gray-200 dark:bg-gray-700">
			        <svg class="w-6 h-6 text-gray-500 dark:text-gray-400" fill="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
			            <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"></path>
			        </svg>
			    </div>
			</button>
          </div>
          <div class="z-50 hidden w-56 my-4 text-base list-none bg-white rounded-xl shadow-2xl border border-gray-200 dark:bg-gray-800 dark:border-gray-700 overflow-hidden" id="dropdown-2">
		    
		    <%-- 사용자 정보 헤더 영역 (Spring Security 인증 상태에 따른 처리) --%>
		    <div class="px-4 py-4 border-b border-gray-100 dark:border-gray-700 bg-gray-50/50 dark:bg-gray-700/50">
		        <sec:authorize access="isAuthenticated()">
					<p class="text-xs font-medium text-blue-600 dark:text-blue-400 mb-1 uppercase tracking-wider">
			            <sec:authorize access="hasRole('MASTER')">Master Profile</sec:authorize>
			            <sec:authorize access="hasRole('ADMIN') and !hasRole('MASTER')">Admin Profile</sec:authorize>
			            <sec:authorize access="hasRole('USER') and !hasRole('ADMIN') and !hasRole('MASTER')">User Profile</sec:authorize>
			        </p>
		            <p class="text-sm font-bold text-gray-900 dark:text-white truncate" role="none">
		                <sec:authentication property="principal.username" />님
		            </p>
		            <p class="text-[11px] text-gray-500 dark:text-gray-400 mt-0.5">반갑습니다!</p>
		        </sec:authorize>
		        <sec:authorize access="isAnonymous()">
		            <p class="text-sm font-bold text-gray-900 dark:text-white">손님 (Guest)</p>
		            <p class="text-[11px] text-gray-500 dark:text-gray-400">로그인이 필요합니다.</p>
		        </sec:authorize>
		    </div>
		
		    <%-- 실제 이동 메뉴 리스트 --%>
		    <ul class="py-1" role="none">
		        <li>
		            <a href="/mypage" class="flex items-center px-4 py-2.5 text-sm text-gray-700 hover:bg-gray-50 dark:text-gray-300 dark:hover:bg-gray-700 transition-colors group">
		                <svg class="w-4 h-4 mr-3 text-gray-400 group-hover:text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
		                마이페이지
		            </a>
		        </li>
		
		        <div class="my-1 border-t border-gray-100 dark:border-gray-700"></div>
		
                <sec:authorize access="isAuthenticated()">
		            <li>
		                <a href="${cp}/logout" class="flex items-center px-4 py-2.5 text-sm text-red-600 hover:bg-red-50 dark:text-red-400 dark:hover:bg-red-900/20 transition-colors group">
		                    <svg class="w-4 h-4 mr-3 text-red-400 group-hover:text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
		                    Sign out
		                </a>
		            </li>
		        </sec:authorize>
		        <sec:authorize access="isAnonymous()">
		            <li>
		                <a href="${cp}/login" class="flex items-center px-4 py-2.5 text-sm text-blue-600 hover:bg-blue-50 dark:text-blue-400 dark:hover:bg-blue-900/20 transition-colors group">
		                    <svg class="w-4 h-4 mr-3 text-blue-400 group-hover:text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
		                    Sign in
		                </a>
		            </li>
		        </sec:authorize>
		    </ul>
		</div>
        </div>

      </div>
    </div>
  </div>
</nav>

<script>
    // 1. 서버 환경 변수 및 시큐리티 설정 (CSRF 방지용)
    var ctx = "${pageContext.request.contextPath}";
    var csrfToken = "${_csrf.token}";
    var csrfHeader = "${_csrf.headerName}";

    /**
     * 알림 데이터 조회 함수
     * /notificationList API에서 데이터를 가져와 UI를 갱신함
     */
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

    /**
     * 알림 UI 렌더링 함수
     * 읽지 않은 알림 뱃지 카운트 및 드롭다운 리스트 생성
     */
    function renderNotificationUI(notifications) {
        var listContainer = document.getElementById('notification-list');
        var badge = document.getElementById('notification-badge');
        var unread = notifications.filter(n => n.isRead === 'N');
        
        // 뱃지 업데이트
        badge.innerText = unread.length;
        unread.length > 0 ? badge.classList.remove('hidden') : badge.classList.add('hidden');

        // 데이터가 없을 때 처리
        if (notifications.length === 0) {
            listContainer.innerHTML = '<p class="py-10 text-center text-xs text-gray-400">알림이 없습니다.</p>';
            return;
        }

        // 알림 아이템 루프 생성
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

    /**
     * 알림 클릭 시: 읽음 처리(PUT) 후 타겟 페이지로 이동
     */
    function handleNotiClick(id, type, targetId) {
        var headers = { 'Content-Type': 'application/json' };
        
        // CSRF 헤더 보안 검증 및 추가 (Invalid Name 에러 방지)
        if (csrfHeader && csrfHeader !== "" && csrfHeader !== "null") {
            headers[csrfHeader] = csrfToken;
        }

        // 1. 읽음 상태 업데이트 API 호출
        fetch(ctx + "/read/" + id, {
            method: 'PUT',
            headers: headers
        })
        .then(function(res) {
            if (!res.ok) throw new Error("읽음 처리 서버 응답 실패");
            
            console.log("읽음 처리 완료(Y), 상세 페이지 이동 시도...");

            // 2. 알림 타입(Type)에 따른 이동 URL 분기 처리
            var moveUrl = "";
            if (type === 'DELIVERY') {
	            moveUrl = ctx + "/admin/delivery/detail/" + targetId;
	        } else if (type === 'ORDER') {
	            moveUrl = ctx + "" + targetId;
	        } else if (type === 'NOTICE') {
	            moveUrl = ctx + "/notice/user/detail/" + targetId;
	        } else if (type === 'APPROVAL') {
	            moveUrl = ctx + "" + targetId;
	        }

            // 3. 페이지 이동 혹은 목록 갱신
            if (moveUrl !== "") {
                window.location.href = moveUrl;
            } else {
                fetchMyNotifications(); // 이동 경로가 없으면 UI만 새로고침
            }
        })
        .catch(function(err) {
            console.error("클릭 처리 최종 에러:", err);
            fetchMyNotifications();
        });
    }

    // 초기 실행 및 30초 간격 폴링
    document.addEventListener('DOMContentLoaded', fetchMyNotifications);
    setInterval(fetchMyNotifications, 30000);
    
    // 모바일 사이드바 토글 이벤트
    document.getElementById('toggleSidebarMobile').addEventListener('click', function() {
        var sidebar = document.getElementById('sidebar');
        var hamburger = document.getElementById('toggleSidebarMobileHamburger');
        var close = document.getElementById('toggleSidebarMobileClose');

        sidebar.classList.toggle('-translate-x-full');
        hamburger.classList.toggle('hidden');
        close.classList.toggle('hidden');
    });
    
	// 테마(Dark/Light) 설정 및 로컬스토리지 저장 로직
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
    /* 알림 드롭다운이 종 아이콘 아래에 정확히 위치하도록 조정 */
    #notification-dropdown {
        top: 100% !important;
        right: -20px !important; 
        left: auto !important;
        transform: none !important;
    }
    
    /* 알림 목록 내 얇은 커스텀 스크롤바 디자인 */
    .custom-scrollbar::-webkit-scrollbar { width: 3px; }
    .custom-scrollbar::-webkit-scrollbar-thumb { background: #e5e7eb; border-radius: 10px; }
</style>