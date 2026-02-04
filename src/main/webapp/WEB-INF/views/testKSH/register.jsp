<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko" class="light"> <%-- 기본 라이트 모드 설정 --%>
<head>
    <meta charset="UTF-8">
    <title>BtoB 서비스 - 회원가입</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <script>
        // Tailwind 다크모드 설정 구성
        tailwind.config = {
            darkMode: 'class',
            theme: { extend: { colors: { indigo: { 600: '#4f46e5', 700: '#4338ca' } } } }
        }
        
        // 다크모드 토글 함수
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
        .form-input-focus { outline: none; transition: all 0.2s; }
        .form-input-focus:focus { border-color: #4f46e5; ring: 2px; ring-color: #818cf8; }
    </style>
</head>
<body class="bg-gray-50 dark:bg-gray-900 flex flex-col min-h-screen transition-colors duration-300">

    <header class="bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700 sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 h-16 flex items-center justify-between">
            <div class="flex items-center gap-2">
                <span class="text-xl font-bold text-indigo-600">Flowbite</span>
            </div>
            <div class="flex items-center gap-6">
                <button onclick="toggleDarkMode()" class="p-2 text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-white">
                    <i id="theme-icon" class="bi bi-moon-fill"></i>
                </button>
                <a href="/login" class="text-sm font-bold text-gray-500 hover:text-indigo-600 transition">로그인으로 돌아가기</a>
            </div>
        </div>
    </header>

    <main class="flex-grow flex items-center justify-center py-12 px-4">
        <div class="max-w-2xl w-full bg-white dark:bg-gray-800 rounded-2xl shadow-xl border border-gray-100 dark:border-gray-700 p-8">
            
            <div class="text-center mb-10">
                <h1 class="text-3xl font-bold text-gray-900 dark:text-white">회원가입</h1>
                <p class="mt-2 text-sm text-gray-500 dark:text-gray-400">새로운 계정을 만들고 서비스를 시작하세요.</p>
            </div>

            <form action="/register" method="post" id="registerForm" onsubmit="return validateForm()" class="space-y-6">
                
                <div class="p-4 bg-gray-50 dark:bg-gray-700/50 rounded-xl border border-gray-200 dark:border-gray-600">
                    <label class="block text-xs font-bold text-indigo-600 dark:text-indigo-400 uppercase tracking-wider mb-3">사용자 권한 설정 *</label>
                    <div class="flex justify-around">
                        <label class="flex items-center gap-2 cursor-pointer">
                            <input type="radio" name="userType" value="USER" checked onclick="toggleBusinessNum(false)" class="w-4 h-4 text-indigo-600 border-gray-300 focus:ring-indigo-500">
                            <span class="text-sm text-gray-700 dark:text-gray-300">일반사용자</span>
                        </label>
                        <label class="flex items-center gap-2 cursor-pointer">
                            <input type="radio" name="userType" value="MASTER" onclick="toggleBusinessNum(true)" class="w-4 h-4 text-indigo-600 border-gray-300 focus:ring-indigo-500">
                            <span class="text-sm text-gray-700 dark:text-gray-300 font-bold">대표</span>
                        </label>
                        <label class="flex items-center gap-2 cursor-pointer">
                            <input type="radio" name="userType" value="ADMIN" onclick="toggleBusinessNum(false)" class="w-4 h-4 text-indigo-600 border-gray-300 focus:ring-indigo-500">
                            <span class="text-sm text-gray-700 dark:text-gray-300">관리자</span>
                        </label>
                    </div>
                </div>

                <div id="businessNumArea" class="hidden">
                    <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-1">사업자 등록번호 *</label>
                    <input type="text" name="businessNumber" placeholder="000-00-00000" 
                           class="w-full px-4 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-900 dark:text-white form-input-focus">
                    <input type="hidden" name="isRepresentative" id="isRepresentative" value="N">
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 pt-4 border-t border-gray-100 dark:border-gray-700">
                    <div class="md:col-span-2">
                        <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-1">아이디 (ID) *</label>
                        <input type="text" name="userId" required placeholder="사용하실 아이디를 입력하세요" 
                               class="w-full px-4 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-900 dark:text-white form-input-focus">
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-1">비밀번호 *</label>
                        <input type="password" name="password" id="password" required 
                               class="w-full px-4 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg form-input-focus">
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-1">비밀번호 확인 *</label>
                        <input type="password" id="passwordConfirm" required 
                               class="w-full px-4 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg form-input-focus">
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-1">이름 *</label>
                        <input type="text" name="userName" required 
                               class="w-full px-4 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-900 dark:text-white form-input-focus">
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-1">연락처 *</label>
                        <input type="tel" name="phone" placeholder="010-0000-0000" required 
                               class="w-full px-4 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-900 dark:text-white form-input-focus">
                    </div>
                    <div class="md:col-span-2">
                        <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-1">이메일 *</label>
                        <input type="email" name="email" required placeholder="example@domain.com" 
                               class="w-full px-4 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-900 dark:text-white form-input-focus">
                    </div>
                </div>

                <div class="space-y-3 pt-4 border-t border-gray-100 dark:border-gray-700">
                    <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-1">주소 *</label>
                    <div class="flex gap-2">
                        <input type="text" id="postcode" name="postcode" placeholder="우편번호" readonly 
                               class="w-32 px-4 py-2.5 bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-500 dark:text-gray-400 cursor-not-allowed">
                        <button type="button" onclick="execPostcode()" 
                                class="px-4 py-2.5 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-lg text-sm font-bold text-gray-700 dark:text-gray-200 hover:bg-gray-50 transition">
                            주소 찾기
                        </button>
                    </div>
                    <input type="text" id="address" name="address" placeholder="기본 주소" readonly required 
                           class="w-full px-4 py-2.5 bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-500 dark:text-gray-400">
                    <input type="text" id="detailAddress" name="detailAddress" placeholder="상세 주소를 입력하세요" 
                           class="w-full px-4 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-900 dark:text-white form-input-focus">
                </div>

                <button type="submit" 
                        class="w-full py-4 px-6 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl shadow-lg shadow-indigo-200 dark:shadow-none transition transform hover:-translate-y-1 active:scale-95">
                    회원가입 완료
                </button>
            </form>
        </div>
    </main>

    <footer class="bg-white dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700 py-10 mt-12">
        <div class="max-w-7xl mx-auto px-4 text-center">
            <p class="text-sm text-gray-400 dark:text-gray-500">
                &copy; 2026 BtoB Service Corp. All rights reserved.
            </p>
        </div>
    </footer>

    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script>
        [cite_start]// 주소 찾기 [cite: 17, 18]
        function execPostcode() {
            new daum.Postcode({
                oncomplete: function(data) {
                    document.getElementById('postcode').value = data.zonecode;
                    document.getElementById("address").value = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
                    document.getElementById("detailAddress").focus();
                }
            }).open();
        }

        // 대표자 여부에 따른 사업자번호 입력창 제어
        function toggleBusinessNum(show) {
            const area = document.getElementById('businessNumArea');
            const isRep = document.getElementById('isRepresentative');
            const bizInput = area.querySelector('input[name="businessNumber"]');
            
            if (show) {
                area.classList.remove('hidden');
                isRep.value = 'Y';
                bizInput.required = true;
            } else {
                area.classList.add('hidden');
                isRep.value = 'N';
                bizInput.required = false;
                bizInput.value = '';
            }
        }

        [cite_start]// 비밀번호 일치 확인 및 폼 검증 [cite: 19, 20]
        function validateForm() {
            const pw = document.getElementById('password').value;
            const pwConfirm = document.getElementById('passwordConfirm').value;
            
            if(pw !== pwConfirm) {
                alert("비밀번호가 일치하지 않습니다.");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>