<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>기능 통합 테스트 센터</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 p-10">

    <div class="max-w-screen-2xl mx-auto">
        
        <div class="bg-white p-8 rounded-xl shadow-lg border border-gray-100">
            
            <h2 class="text-2xl font-bold mb-2 text-gray-800">통합 테스트 관리자</h2>
            <p class="text-sm text-gray-500 mb-8">개발 중인 각 기능의 정상 동작 여부를 확인하기 위한 테스트 링크 모음입니다.</p>
            
            <hr class="mb-8 border-gray-100">

            <h3 class="text-lg font-semibold mb-4 text-gray-700">핵심 기능 목록</h3>

            <div class="flex flex-wrap gap-4">
                
                <a href="/jjjtest/page" 
                   class="flex items-center px-4 py-3 bg-blue-50 text-blue-700 rounded-lg hover:bg-blue-100 transition border border-blue-100 group">
                    <span class="mr-3 p-2 bg-white rounded shadow-sm group-hover:scale-110 transition">📂</span>
                    <span class="font-medium text-sm">첨부파일 업로드 시스템</span>
                </a>
                
                <a href="/jjjtest/filedownload-test" 
                   class="flex items-center px-4 py-3 bg-blue-50 text-blue-700 rounded-lg hover:bg-blue-100 transition border border-blue-100 group">
                    <span class="mr-3 p-2 bg-white rounded shadow-sm group-hover:scale-110 transition">📂</span>
                    <span class="font-medium text-sm">첨부파일 다운로드 시스템</span>
                </a>

                <a href="/jjjtest/excel" 
                   class="flex items-center px-4 py-3 bg-green-50 text-green-700 rounded-lg hover:bg-green-100 transition border border-green-100 group">
                    <span class="mr-3 p-2 bg-white rounded shadow-sm group-hover:scale-110 transition">📊</span>
                    <span class="font-medium text-sm">엑셀 데이터 연동</span>
                </a>

                <a href="/jjjtest/pdftest" 
                   class="flex items-center px-4 py-3 bg-red-50 text-red-700 rounded-lg hover:bg-red-100 transition border border-red-100 group">
                    <span class="mr-3 p-2 bg-white rounded shadow-sm group-hover:scale-110 transition">📄</span>
                    <span class="font-medium text-sm">PDF 리포트 생성</span>
                </a>

            </div>

            <div class="mt-12 p-4 bg-gray-50 rounded-lg border border-dashed border-gray-300">
                <p class="text-xs text-gray-400 text-center">
                    본 페이지는 테스트용입니다. 운영 환경에서는 별도의 접근 권한이 필요할 수 있습니다.
                </p>
            </div>

        </div>
    </div>

</body>
</html>