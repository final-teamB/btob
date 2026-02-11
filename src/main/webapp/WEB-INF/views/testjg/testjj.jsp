<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Cart Test Page</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <h2>장바구니 테스트</h2>
    
    <div>
        <span>상품 1</span>
        <button onclick="addToCart(126, 2)">장바구니담기1</button>
        <button onclick="orderNow('126')">주문하기1</button>
    </div>
    
    <br>

    <div>
        <span>상품 2</span>
        <button onclick="addToCart(127, 5)">장바구니담기2</button>
        <button onclick="orderNow('127')">주문하기2</button>
    </div>

    <form id="orderForm" action="${pageContext.request.contextPath}/cart/orderReq" method="post">
        <input type="hidden" name="cartIds" id="cartIdsInput">
    </form>

    <script>
        // 1. 장바구니 담기 (AJAX - 비동기)
        function addToCart(productId, qty) {
            // CartItemInsertDTO 필드명에 맞춰 전송
            const data = {
                fuelId: productId,
                totalQty: qty
            };

            $.ajax({
                url: '${pageContext.request.contextPath}/cart/add',
                type: 'POST',
                data: data, // JSON.stringify 없이 일반 객체로 전달 (DTO 바인딩용)
                success: function(response) {
                    if(response.result === "success") {
                        alert("장바구니에 담겼습니다! (상품번호: " + productId + ")");
                    }
                },
                error: function(err) {
                    alert("장바구니 담기 실패");
                    console.error(err);
                }
            });
        }

        // 2. 주문하기 (Form Submit - 페이지 이동)
        function orderNow(cartId) {
            // Controller에서 @RequestParam String cartIds로 받으므로 문자열로 전송
            if(confirm("해당 상품을 바로 주문하시겠습니까?")) {
                document.getElementById('cartIdsInput').value = cartId;
                document.getElementById('orderForm').submit();
            }
        }
    </script>
</body>
</html>