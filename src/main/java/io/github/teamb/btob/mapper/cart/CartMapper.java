package io.github.teamb.btob.mapper.cart;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import io.github.teamb.btob.dto.cart.CartItemDTO;
import io.github.teamb.btob.dto.cart.CartItemInsertDTO;

@Mapper
public interface CartMapper {
	
	List<CartItemDTO> selectCartItemList(String userId);

	CartItemInsertDTO selectExistingCartItem(CartItemInsertDTO dto);

	void insertCartItem(CartItemInsertDTO dto);

	void updateCartItem(CartItemInsertDTO dto);

	void deleteCartItem(int cartId, String userId);

	void clearCart(String userId, String ordeNo);

	String getCartStatusByUser(String userId);

	List<CartItemDTO> selectCartItemListByIds(List<String> idList);

	void updateCartOrderInfo(Map<String, Object> cartParams);
	
	void updateCartStatusOrdered(Map<String, Object> cartParams);
	
}
