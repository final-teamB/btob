<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<form action="/admin/chat/${not empty faq ? 'modifyFaq' : 'registerFaq'}" method="post">
    <c:if test="${not empty faq}"><input type="hidden" name="faqId" value="${faq.faqId}"></c:if>
    <select name="category">
        <option value="DELIVERY" ${faq.category=='DELIVERY'?'selected':''}>배송</option>
        <option value="PAYMENT" ${faq.category=='PAYMENT'?'selected':''}>결제</option>
        <option value="PRODUCT" ${faq.category=='PRODUCT'?'selected':''}>상품</option>
        <option value="ETC" ${faq.category=='ETC'?'selected':''}>기타</option>
    </select><br>
    질문: <input type="text" name="question" value="${faq.question}"><br>
    답변: <textarea name="answer">${faq.answer}</textarea><br>
    <button type="submit">저장</button>
</form>