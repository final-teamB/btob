package io.github.teamb.btob.service.adminDelivery;

import java.util.List;

import org.springframework.stereotype.Service;

import io.github.teamb.btob.dto.adminDelivery.DeliveryDTO;
import io.github.teamb.btob.mapper.adminDelivery.DeliveryMapper;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor // Mapper 주입
public class DeliveryServiceImpl implements DeliveryService{
	
	private final DeliveryMapper deliveryMapper;

	@Override
	public List<DeliveryDTO> getDeliveryList() {
		
		return deliveryMapper.selectDeliveryList();
	}

	@Override
	public boolean modifyDelivery(DeliveryDTO deliveryDTO) {
		
		int result = deliveryMapper.updateDelivery(deliveryDTO);
		return result > 0;
	}

}
