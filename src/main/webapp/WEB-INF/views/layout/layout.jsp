<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>

    <!-- Tailwind + Flowbite CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
	    // Tailwind 설정 통합
	    tailwind.config = {
	        darkMode: 'class', // 이 줄이 빠지면 다크모드가 작동하지 않습니다.
	        theme: {
	            extend: {
	                fontFamily: {
	                    // 기본 산세리프 폰트에 Pretendard를 최우선으로 설정
	                    sans: ['Pretendard', 'Inter', 'ui-sans-serif', 'system-ui', '-apple-system', 'sans-serif'],
	                },
	            },
	        },
	    }
	
	    // 초기 테마 적용 스크립트 (기존 기능 유지)
	    if (localStorage.getItem('color-theme') === 'dark' || (!('color-theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
	        document.documentElement.classList.add('dark');
	    } else {
	        document.documentElement.classList.remove('dark');
	    }
	</script>

<style>
    /* CSS에서도 기본 폰트를 지정하여 렌더링 속도를 높입니다 */
    body {
        font-family: 'Pretendard', sans-serif;
    }
</style>
    <link href="https://cdn.jsdelivr.net/npm/flowbite@latest/dist/flowbite.min.css" rel="stylesheet">
</head>
<body class="bg-gray-50">

	<jsp:include page="/WEB-INF/views/layout/header.jsp" />
	
	<div class="flex pt-16">
		<jsp:include page="/WEB-INF/views/layout/adminSidebar.jsp" />
		<jsp:include page="/WEB-INF/views/layout/userSidebar.jsp" />
		
		<div class="flex flex-col flex-1 ml-64 min-h-screen">

            <!-- CONTENT -->
            <main class="p-5 flex-1 bg-gray-50 dark:bg-gray-900">
                <jsp:include page="/WEB-INF/views/${content}" />
            </main>

            <!-- FOOTER -->
            <footer class="p-5 bg-gray-50 dark:bg-gray-900">
            	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
            </footer>
            
        </div>
	</div>
	
	<script src="https://cdn.jsdelivr.net/npm/flowbite@latest/dist/flowbite.min.js"></script>
</body>
</html>