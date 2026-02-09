<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko" class="light"> <%-- 기본 라이트 모드 설정 --%>
<head>
    <meta charset="UTF-8">
    <title>BtoB 서비스 - 로그인</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <script>
        // Tailwind 설정 및 다크모드 제어
        tailwind.config = {
            darkMode: 'class',
            theme: { extend: { colors: { indigo: { 600: '#4f46e5', 700: '#4338ca' } } } }
        }
        
        function toggleDarkMode() {
            const html = document.querySelector('html');
            const icon = document.getElementById('theme-icon');
            if (html.classList.contains('dark')) {
                html.classList.remove('dark');
                icon.classList.replace('bi-sun-fill', 'bi-moon-fill');
            } else {
                html.classList.add('dark');
                icon.classList.replace('bi-moon-fill', 'bi-sun-fill');
            }
        }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; }
    </style>
</head>
<body class="bg-gray-50 dark:bg-gray-900 flex flex-col min-h-screen transition-colors duration-300">

    <header class="bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700 sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 h-16 flex items-center justify-between">
            <div class="flex items-center gap-2">
                <span class="text-xl font-bold text-indigo-600">Flowbite</span>
            </div>
            <div class="flex items-center gap-6">
                <button onclick="toggleDarkMode()" class="p-2 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-white transition">
                    <i id="theme-icon" class="bi bi-moon-fill text-xl"></i>
                </button>
                <nav class="flex gap-4">
                    <a href="/register" class="text-sm font-bold text-gray-500 hover:text-indigo-600 dark:hover:text-white transition">회원가입</a>
                </nav>
            </div>
        </div>
    </header>

    <main class="flex-grow flex items-center justify-center px-4 py-12">
        <div class="max-w-md w-full space-y-8 bg-white dark:bg-gray-800 p-8 rounded-2xl shadow-xl border border-gray-100 dark:border-gray-700">
            
            <div class="text-center">
                <h2 class="text-3xl font-extrabold text-gray-900 dark:text-white">반갑습니다</h2>
                <p class="mt-2 text-sm text-gray-500 dark:text-gray-400">서비스 이용을 위해 로그인이 필요합니다.</p>
            </div>

            <c:if test="${param.error != null}">
                <div class="p-4 bg-red-50 dark:bg-red-900/20 border border-red-100 dark:border-red-800 rounded-lg">
                    <p class="text-sm text-red-600 dark:text-red-400 font-medium text-center">
                        이메일 또는 비밀번호가 일치하지 않습니다.
                    </p>
                </div>
            </c:if>

            <form action="/login" method="post" class="mt-8 space-y-6">
                <div class="space-y-4">
                    <div>
                        <label for="username" class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-1">이메일 (ID)</label>
                        <input type="email" id="username" name="email" required 
                               class="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition outline-none" 
                               placeholder="example@company.com">
                    </div>
                    <div>
                        <label for="password" class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-1">비밀번호</label>
                        <input type="password" id="password" name="password" required 
                               class="w-full px-4 py-3 bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-xl text-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition outline-none">
                    </div>
                </div>

                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <div class="flex items-center justify-between">
                    <div class="flex items-center">
                        <input id="remember-me" name="remember-me" type="checkbox" 
                               class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 dark:border-gray-600 dark:bg-gray-700 rounded">
                        <label for="remember-me" class="ml-2 block text-sm text-gray-500 dark:text-gray-400">로그인 상태 유지</label>
                    </div>
                </div>

                <div>
                    <button type="submit" 
                            class="w-full py-3.5 px-4 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl transition shadow-lg shadow-indigo-200 dark:shadow-none transform active:scale-95">
                        로그인
                    </button>
                </div>
            </form>
        </div>
    </main>

    <footer class="bg-white dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700 py-10">
        <div class="max-w-7xl mx-auto px-4 text-center">
            <p class="text-sm text-gray-400 dark:text-gray-500">
                &copy; 2026 BtoB Service Corp. All rights reserved.
            </p>
        </div>
    </footer>

</body>
</html>