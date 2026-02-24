<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
/**
 * 전역 변수 설정 (공통으로 사용)
 * 이미 다른 곳에서 선언되었을 경우를 대비해 var 또는 window 객체 활용
 */
window.cp = "${pageContext.request.contextPath}";

function updateAllBadges() {
    // 1. 결재 대기함 (Sidebar)
    const pendingBadge = document.getElementById('pending-badge');
    if (pendingBadge) {
        fetch(window.cp + "/trade/pendingCount")
            .then(res => res.json())
            .then(count => {
                pendingBadge.innerText = count;
                // 숫자가 0보다 크면 노출, 아니면 숨김
                if (count > 0) {
                    pendingBadge.classList.remove('hidden');
                } else {
                	pendingBadge.classList.add('hidden');
                }
            }).catch(e => console.warn("Pending count error:", e));
    }

    // 2. 장바구니 (Header)
    const cartBadge = document.getElementById('cart-badge');
    if (cartBadge) {
        fetch(window.cp + "/cart/count")
            .then(res => res.json())
            .then(count => {
                cartBadge.innerText = count;             
                cartBadge.classList.remove('hidden');        
            }).catch(e => console.warn("Cart count error:", e));
    }
}

// 모든 페이지 로드 시 실행
document.addEventListener('DOMContentLoaded', updateAllBadges);
</script>