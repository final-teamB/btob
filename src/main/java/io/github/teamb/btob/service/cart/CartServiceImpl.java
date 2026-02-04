package io.github.teamb.btob.service.cart;

import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.teamb.btob.dto.cart.CartItemDTO;
import io.github.teamb.btob.dto.cart.CartItemInsertDTO;
import io.github.teamb.btob.mapper.cart.CartMapper;

@Service
@Transactional
public class CartServiceImpl implements CartService {
	private final CartMapper cartMapper;
	
	public CartServiceImpl(CartMapper cartMapper) {
		this.cartMapper = cartMapper;
	}
	
	 private String getLoginUserId() {
	        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	        //CustomUserDetails user = (CustomUserDetails) auth.getPrincipal();
	        return "user01@example.com"; // user.getUserId();
	    }
	
	
	@Override
	public List<CartItemDTO> getCartItemList() {
		return cartMapper.selectCartItemList(getLoginUserId());
	}

	@Override
	public void addToCart(CartItemInsertDTO dto) {
		// 안전장치
	    if (dto.getTotalQty() < 1) {
	        throw new IllegalArgumentException("수량은 1 이상이어야 합니다.");
	    }
		
		// 1. 이미 담긴 상품인지 확인
        CartItemInsertDTO existItem = cartMapper.selectExistingCartItem(dto); // userId + fuelId + PENDING

        if (existItem == null) {
            // 신규 담기
            dto.setTotalPrice(dto.getTotalQty() * dto.getBaseUnitPrc());
            dto.setCartStatus("PENDING");
            cartMapper.insertCartItem(dto);
        } else {
            // 수량 누적
            int newQty = existItem.getTotalQty() + dto.getTotalQty();
            existItem.setTotalQty(newQty);
            int newPrice = newQty * dto.getBaseUnitPrc();
            existItem.setTotalPrice(newPrice);
            
            cartMapper.updateCartItem(existItem);
        }
		
	}

	@Override
	public void updateCartItemQty(CartItemInsertDTO dto) {
		dto.setTotalPrice(dto.getTotalQty() * dto.getBaseUnitPrc());
        cartMapper.updateCartItem(dto);	
	}
	
	@Override
	public void deleteCartItem(int cartId) {
		cartMapper.deleteCartItem(cartId, getLoginUserId());		
	}
	
	// rejected 카트목록 삭제
	@Override
	public void clearCart(String userId) {
		cartMapper.clearCart(userId);		
	}

	@Override
	public String getCartStatusByUser(String userId) {
		return cartMapper.getCartStatusByUser(userId);
	}
	

	
}
