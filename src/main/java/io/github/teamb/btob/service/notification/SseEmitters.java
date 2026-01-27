package io.github.teamb.btob.service.notification;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

@Component
public class SseEmitters {

	// 명단 (현재 접속 중인 사용자 보관)
	private final Map<String, SseEmitter> emitters = new ConcurrentHashMap<>();
	
	// 명단에 추가
	public SseEmitter add(String receiverId, SseEmitter sseEmitter) {
		this.emitters.put(receiverId, sseEmitter);
		
		// 끝나면 삭제
		sseEmitter.onCompletion(() -> this.emitters.remove(receiverId));
		sseEmitter.onTimeout(() -> this.emitters.remove(receiverId));
		
        return sseEmitter;
	}
	
	// 특정 id에 전송
	public void sendToClient(String receiverId, Object data) {
        if (emitters.containsKey(receiverId)) {
            try {
            	// 실시간 전송
                emitters.get(receiverId).send(SseEmitter.event().name("notification").data(data));
            } catch (IOException e) {
            	// 실패하면 삭제
                emitters.remove(receiverId); 
            }
        }
    }
}
