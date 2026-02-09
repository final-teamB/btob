<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>PDF 리포트 생성 테스트</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 p-10">

<div class="max-w-screen-2xl mx-auto">
    <div class="bg-white p-8 rounded-xl shadow-lg border border-gray-100">
        
        <h2 class="text-2xl font-bold mb-6 text-gray-800">PDF 리포트 생성 테스트</h2>
        
        <div class="mb-10">
            <h3 class="text-lg font-semibold mb-3 text-gray-700">1. 첨부파일 목록 PDF 추출 (TB_ATCH_FILE_MST)</h3>
            <p class="text-sm text-gray-500 mb-6">
                DB에 저장된 파일 메타 정보를 바탕으로 PDF 보고서를 생성합니다.<br />
                <span class="text-blue-600 text-xs font-medium">* 팁: 데이터가 1건이어도 리스트 형태로 안전하게 출력됩니다.</span>
            </p>
            
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6 p-6 bg-gray-50 rounded-lg border border-gray-200">
                <div>
                    <label class="block text-xs font-bold text-gray-600 mb-1">참조 유형 (refTypeCd)</label>
                    <input type="text" id="refTypeCd" value="TEST_BATCH" placeholder="예: NOTICE, BOARD"
                           class="w-full border border-gray-300 rounded px-3 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-600 mb-1">참조 대상 ID (refId)</label>
                    <input type="number" id="refId" value="12345" 
                           class="w-full border border-gray-300 rounded px-3 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <div class="flex items-end">
                    <button onclick="downloadPdf()" 
                            class="w-full bg-red-600 text-white px-3 py-1.5 text-sm rounded hover:bg-red-700 transition font-medium shadow-sm flex items-center justify-center">
                        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"></path>
                        </svg>
                        PDF 리포트 생성
                    </button>
                </div>
            </div>
            
            <div class="p-4 bg-amber-50 border border-amber-100 rounded-lg mb-6">
                <h4 class="text-sm font-bold text-amber-800 mb-2">⚠️ 날짜 변환 에러 발생 시 확인 (jakarta.el.ELException)</h4>
                <p class="text-xs text-amber-700 leading-relaxed">
                    DB의 <b>TIMESTAMP</b>가 DTO에서 <b>String</b>으로 매핑되어 있다면, JSP의 <b>&lt;fmt:formatDate&gt;</b>에서 에러가 날 수 있습니다.<br/>
                    이 경우 DTO의 타입을 <b>LocalDateTime</b>으로 변경하거나, JSP에서 <b>&lt;fmt:parseDate&gt;</b>를 선행하여 사용하세요.
                </p>
            </div>

            <div class="p-4 bg-blue-50 border border-blue-100 rounded-lg">
                <h4 class="text-sm font-bold text-blue-800 mb-2">기능 동작 프로세스</h4>
                <ul class="text-xs text-blue-700 list-disc ml-5 space-y-1">
                    <li>입력 파라미터를 `/jjjtest/download/pdflist` 컨트롤러로 전달합니다.</li>
                    <li>`AtchFileMapper`가 `use_yn = 'Y'`인 데이터를 필터링하여 조회합니다.</li>
                    <li>JSP를 HTML 문자열로 렌더링한 후, <b>ITextRenderer</b>가 PDF 바이너리를 스트리밍합니다.</li>
                </ul>
            </div>
        </div>

        <div class="mt-12 flex justify-start border-t pt-6">
            <a href="/jjjtest/hometest" class="text-blue-600 text-sm hover:underline flex items-center">
                <span class="mr-1">←</span> 메인 테스트 페이지로 돌아가기
            </a>
        </div>
    </div>
</div>

<script>
    function downloadPdf() {
        // value를 함수 호출 시점에 다시 한 번 정확히 타겟팅해서 가져옵니다.
        var refTypeCd = document.querySelector('#refTypeCd').value;
        var refId = document.querySelector('#refId').value;

        // 디버깅: 브라우저 콘솔(F12)에 값이 찍히는지 확인용
        console.log("Captured refTypeCd:", refTypeCd);
        console.log("Captured refId:", refId);

        if(!refTypeCd || !refId) {
            alert("조회 조건(유형 및 ID)을 모두 입력해주세요.");
            return;
        }

        // 새 창 팝업 설정
        var width = 1100;
        var height = 900;
        var left = (window.screen.width / 2) - (width / 2);
        var top = (window.screen.height / 2) - (height / 2);
        
        // 템플릿 리터럴 대신 일반 문자열 결합 사용 (안전성 확보)
        var options = "width=" + width + ",height=" + height + ",top=" + top + ",left=" + left + 
                      ",toolbar=no,menubar=no,scrollbars=yes,resizable=yes";
        
        // URL 생성 시 encodeURIComponent를 사용하여 특수문자 방지
        var url = "/jjjtest/download/pdflist?refTypeCd=" + encodeURIComponent(refTypeCd) + "&refId=" + refId;
        
        console.log("Final URL:", url);

        window.open(url, 'pdfPreview', options);
    }
</script>

</body>
</html>