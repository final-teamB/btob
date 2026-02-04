<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/modal.css">

<div id="userModal" class="modal" style="display:none;">
    <div class="modal-box">
        <h3>사원 상태 수정</h3>

        <form id="userForm">
            <input type="hidden" name="userNo" id="mUserNo">

            <label>ID</label>
            <input type="text" id="mUserId" readonly>

            <label>이름</label>
            <input type="text" id="mUserName" readonly>

            <label>계정 상태</label>
            <select name="accStatus" id="mAccStatus">
                <option value="ACTIVE">ACTIVE</option>
                <option value="SLEEP">SLEEP</option>
                <option value="STOP">STOP</option>
            </select>

            <div class="modal-btn">
                <button type="button" onclick="saveUser()">저장</button>
                <button type="button" onclick="closeModal()">취소</button>
            </div>
        </form>
    </div>
</div>
