<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script src="https://cdn.ckeditor.com/ckeditor5/34.0.0/classic/ckeditor.js"></script>

<style>
    /* 1. 에디터 높이를 크게 고정 (이미지처럼 시원하게) */
    .ck-editor__editable {
        min-height: 200px !important;
        max-height: 400px !important;
    }
    
    /* 2. 에디터 테두리 및 라운딩 디자인 (이미지 톤) */
    .ck.ck-editor__main>.ck-editor__editable {
        border-radius: 0 0 8px 8px !important;
        border: 1px solid #e2e8f0 !important;
    }
    .ck.ck-toolbar {
        border-radius: 8px 8px 0 0 !important;
        border-bottom: none !important;
        background-color: #ffffff !important;
    }

    /* 3. 레이블 디자인 일치 */
    .section-label { 
        display: block;
        font-size: 14px; 
        font-weight: 600; 
        color: #374151; 
        margin-bottom: 6px; 
    }
</style>

<div class="p-2 space-y-4">
    <div class="px-2 pb-2 border-b">
        <h3 class="font-bold text-blue-600 text-sm uppercase">FAQ 상세 정보</h3>
        <p class="text-[12px] text-gray-400 mt-1">* 답변 내용을 상세히 입력해주세요.</p>
    </div>

    <section class="bg-white px-2">
        <form id="faqSubmitForm" class="space-y-3" autocomplete="off">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="hidden" name="faqId" value="${faq.faqId}">

            <div class="grid grid-cols-1 gap-y-3">
                <%-- 카테고리 --%>
                <div>
                    <label class="section-label">카테고리 <span class="text-red-500">*</span></label>
                    <select name="category" required
                            class="w-full px-3 py-2.5 text-sm border border-gray-300 rounded-lg outline-none focus:ring-1 focus:ring-blue-500 transition-all">
                        <option value="DELIVERY" ${faq.category=='DELIVERY'?'selected':''}>배송</option>
                        <option value="PAYMENT" ${faq.category=='PAYMENT'?'selected':''}>결제</option>
                        <option value="PRODUCT" ${faq.category=='PRODUCT'?'selected':''}>상품</option>
                        <option value="ETC" ${faq.category=='ETC'?'selected':''}>기타</option>
                    </select>
                </div>

                <%-- 질문 --%>
                <div>
                    <label class="section-label">질문 (Question) <span class="text-red-500">*</span></label>
                    <input type="text" name="question" value="${faq.question}" required
                           placeholder="질문을 입력하세요"
                           class="w-full px-3 py-2.5 text-sm border border-gray-300 rounded-lg outline-none focus:ring-1 focus:ring-blue-500 transition-all">
                </div>

                <%-- 답변 (이미지처럼 크게 확장됨) --%>
                <div>
                    <label class="section-label">답변 (Answer) <span class="text-red-500">*</span></label>
                    <div id="editor-container">
                        <textarea name="answer" id="faqEditor">${faq.answer}</textarea>
                    </div>
                </div>
            </div>

            <%-- 하단 액션바 --%>
            <div class="flex items-center justify-between p-4 border-t mt-6">
                <button type="button" onclick="submitFaqForm()" 
                        class="px-10 py-2.5 text-sm font-bold text-white bg-blue-600 rounded-lg hover:bg-blue-700 shadow-md transition-all active:scale-95">
                    저장하기
                </button>
                <button type="button" onclick="closeFaqModal()"
                        class="px-6 py-2.5 text-sm font-medium text-gray-500 bg-white border border-gray-200 rounded-lg hover:bg-gray-50 transition-all shadow-sm">
                    취소
                </button>
            </div>
        </form>
    </section>
</div>

<script>
   function submitFaqForm() {
        const $form = $('#faqSubmitForm');
        const editorEl = document.querySelector('#faqEditor');

        // [핵심] 에디터 인스턴스에서 데이터를 가져와서 textarea에 동기화
        if (editorEl && editorEl.ckeditorInstance) {
            const data = editorEl.ckeditorInstance.getData();
            $form.find('[name=answer]').val(data);
        }

        const question = $form.find('[name=question]').val().trim();
        const answer = $form.find('[name=answer]').val().trim();

        if (!question || !answer) {
            alert("모든 필수 항목을 입력해주세요.");
            return;
        }

        if (!confirm("내용을 저장하시겠습니까?")) return;

        // AJAX 전송 로직...
        $.ajax({
            url: "/support/admin/saveFaq",
            type: "POST",
            data: $form.serialize(),
            success: function(res) {
                if (res === true || res === "true" || res === "OK") {
                    alert("성공적으로 저장되었습니다.");
                    location.reload();
                } else {
                    alert("저장에 실패했습니다.");
                }
            }
        });
    }
</script>