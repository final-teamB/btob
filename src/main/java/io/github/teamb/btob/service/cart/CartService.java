package io.github.teamb.btob.service.cart;

import java.util.List;

import io.github.teamb.btob.dto.cart.CartItemDTO;
import io.github.teamb.btob.dto.cart.CartItemInsertDTO;

public interface CartService {
	// 장바구니 목록 조회
    List<CartItemDTO> getCartItemList(String orderNo);

    // 장바구니 담기 / 수량 증가
    void addToCart(CartItemInsertDTO dto);

    // 수량 변경
    void updateCartItemQty(CartItemInsertDTO dto);

    // 삭제
    void deleteCartItem(int cartId);

	void clearCart(String userId, String orderNo);

	List<CartItemDTO> selectCartItemListByIds(List<String> idList);

}
