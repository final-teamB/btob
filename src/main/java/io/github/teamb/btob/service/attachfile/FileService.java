package io.github.teamb.btob.service.attachfile;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import io.github.teamb.btob.dto.attachfile.AtchFileDto;

public interface FileService {

	// 단일 파일 업로드
    AtchFileDto uploadFile(MultipartFile file, 
    		String refTypeCd, 
    		int refId) throws Exception;
    
    // 다중 파일 업로드 (List 활용)
    List<AtchFileDto> uploadFiles(List<MultipartFile> files, 
    		String refTypeCd, 
    		int refId) throws Exception;
    
    // 파일 정보 조회 (단건)
    AtchFileDto getFile(int fileId) throws Exception;
    
    // 파일 참조 대상별 목록 확인 ( ex 공지사항, 등 )
    List<AtchFileDto> getFilesByRef(String refTypeCd, int refId) throws Exception;
    
    // 파일 삭제
    void deleteFile(int fileId) throws Exception;
}
