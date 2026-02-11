<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko" class="light">
<head>
    <meta charset="UTF-8">
    <title>BtoB 서비스 - 회원가입</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <script>
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
        .form-input-focus { outline: none; transition: all 0.2s; }
        .form-input-focus:focus { border-color: #4f46e5; ring: 2px; ring-color: #818cf8; }
        .tight-section { margin-top: 0 !important; }
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
            </div>

            <form action="/register" method="post" id="registerForm" onsubmit="return validateForm()" class="space-y-6">
                
                <%-- [1] 사용자 권한 설정 --%>
                <div class="p-4 bg-gray-50 dark:bg-gray-700/50 rounded-xl border border-gray-200 dark:border-gray-600">
                    <label class="block text-xs font-bold text-indigo-600 dark:text-indigo-400 uppercase tracking-wider mb-3">사용자 권한 설정 *</label>
                    <div class="flex justify-around px-10">
                        <label class="flex items-center gap-2 cursor-pointer">
                            <input type="radio" name="userType" value="USER" checked onclick="handleUserTypeChange('USER')" class="w-4 h-4 text-indigo-600 border-gray-300">
                            <span class="text-sm text-gray-700 dark:text-gray-300">일반사용자</span>
                        </label>
                        <label class="flex items-center gap-2 cursor-pointer">
                            <input type="radio" name="userType" value="MASTER" onclick="handleUserTypeChange('MASTER')" class="w-4 h-4 text-indigo-600 border-gray-300">
                            <span class="text-sm text-gray-700 dark:text-gray-300 font-bold">대표</span>
                        </label>
                    </div>
                </div>

                <%-- [2] 일반회원 전용: 소속 회사 선택 --%>
                <div id="companySelectArea" class="space-y-2">
                    <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-1">소속 회사 선택 *</label>
                    <select name="companyCd" class="w-full px-4 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-900 dark:text-white form-input-focus">
                        <option value="">소속된 회사를 선택하세요</option>
                        <c:forEach items="${companyList}" var="comp">
                            <option value="${comp.companyCd}">${comp.companyName}</option>
                        </c:forEach>
                    </select>
                </div>

                <%-- [3] 통합 영역: 회사 정보(MASTER전용) + 주소 정보 (공백 제거 디자인) --%>
                <div id="unifiedMasterSection" class="space-y-0">
                    <div id="masterInfoArea" class="hidden p-4 bg-indigo-50 dark:bg-indigo-900/20 rounded-t-xl border-x border-t border-indigo-100 dark:border-indigo-800 space-y-4">
                        <h4 class="text-sm font-bold text-indigo-700 dark:text-indigo-300 flex items-center gap-2">
                            <i class="bi bi-building-add"></i> 회사 및 사업장 정보 등록
                        </h4>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label class="block text-xs font-bold text-gray-500 dark:text-gray-400 mb-1">회사명 *</label>
                                <input type="text" name="companyName" class="w-full px-4 py-2 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-900 dark:text-white form-input-focus">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-gray-500 dark:text-gray-400 mb-1">사업자 등록번호 *</label>
                                <input type="text" name="businessNumber" placeholder="000-00-00000" class="w-full px-4 py-2 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-900 dark:text-white form-input-focus">
                            </div>
                        </div>
                        <input type="hidden" name="isRepresentative" id="isRepresentative" value="N">
                    </div>

                    <div id="addressSection" class="space-y-3">
                        <label id="addressLabel" class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-1">개인 거주지 주소 정보 *</label>
                        <div class="flex gap-2">
                            <input type="text" id="postcode" name="postcode" placeholder="우편번호" readonly class="w-32 px-4 py-2 bg-gray-100 dark:bg-gray-600 border border-gray-300 dark:border-gray-500 rounded-lg text-gray-500">
                            <button type="button" onclick="execPostcode()" class="px-3 py-2 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-600 rounded-lg text-xs font-bold text-gray-700 dark:text-gray-200">주소 찾기</button>
                        </div>
                        <input type="text" id="address" name="address" placeholder="기본 주소" readonly class="w-full px-4 py-2 bg-gray-100 dark:bg-gray-600 border border-gray-300 dark:border-gray-500 rounded-lg text-gray-500">
                        <input type="text" id="detailAddress" name="detailAddress" placeholder="상세 주소를 입력하세요" class="w-full px-4 py-2 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-900 dark:text-white form-input-focus">
                    </div>
                </div>

                <%-- [4] 계정 정보 (직위 및 전화번호 필드 포함) --%>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 pt-6 border-t border-gray-100 dark:border-gray-700">
                    <div class="md:col-span-2">
                        <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-1">아이디 (ID) *</label>
                        <input type="text" name="userId" required class="w-full px-4 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-900 dark:text-white form-input-focus">
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-1">비밀번호 *</label>
                        <input type="password" id="password" name="password" required class="w-full px-4 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-900 dark:text-white form-input-focus">
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-1">비밀번호 확인 *</label>
                        <input type="password" id="passwordConfirm" required class="w-full px-4 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-900 dark:text-white form-input-focus">
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-1">성함 *</label>
                        <input type="text" name="userName" required class="w-full px-4 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-900 dark:text-white form-input-focus">
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-1">직위 *</label>
                        <input type="text" name="position" placeholder="예: 대표이사, 부장" class="w-full px-4 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-900 dark:text-white form-input-focus">
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-1">이메일 *</label>
                        <input type="email" name="email" required class="w-full px-4 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-900 dark:text-white form-input-focus">
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-1">전화번호 *</label>
                        <input type="text" name="phone" required placeholder="010-0000-0000" class="w-full px-4 py-2.5 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-900 dark:text-white form-input-focus">
                    </div>
                </div>

                <button type="submit" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3.5 rounded-xl shadow-lg transition-all mt-4">
                    회원가입 완료
                </button>
            </form>
        </div>
    </main>

    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script>
        function handleUserTypeChange(type) {
            const masterArea = document.getElementById('masterInfoArea');
            const userArea = document.getElementById('companySelectArea');
            const addrLabel = document.getElementById('addressLabel');
            const addrSection = document.getElementById('addressSection');
            const isRep = document.getElementById('isRepresentative');
            
            if (type === 'MASTER') {
                masterArea.classList.remove('hidden');
                userArea.classList.add('hidden');
                addrLabel.innerText = "회사(사업장) 주소 정보 *";
                isRep.value = 'Y';
                addrSection.classList.add('p-4', 'bg-indigo-50', 'dark:bg-indigo-900/20', 'border-x', 'border-b', 'border-indigo-100', 'dark:border-indigo-800', 'rounded-b-xl', 'tight-section');
            } else {
                masterArea.classList.add('hidden');
                userArea.classList.remove('hidden');
                addrLabel.innerText = "개인 거주지 주소 정보 *";
                isRep.value = 'N';
                addrSection.classList.remove('p-4', 'bg-indigo-50', 'dark:bg-indigo-900/20', 'border-x', 'border-b', 'border-indigo-100', 'dark:border-indigo-800', 'rounded-b-xl', 'tight-section');
            }
        }

        function execPostcode() {
            new daum.Postcode({
                oncomplete: function(data) {
                    let addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
                    document.getElementById('postcode').value = data.zonecode;
                    document.getElementById("address").value = addr;
                    document.getElementById("detailAddress").focus();
                }
            }).open();
        }

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