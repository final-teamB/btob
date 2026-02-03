package io.github.teamb.btob.service.attachfile;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import io.github.teamb.btob.dto.attachfile.AtchFileDto;

public interface FileService {

	// 단일 파일 업로드
    AtchFileDto uploadFile(MultipartFile file, 
    		String systemId, 
    		Integer refId) throws Exception;
    
    // 다중 파일 업로드 (List 활용)
    List<AtchFileDto> uploadFiles(List<MultipartFile> files, 
    		String systemId, 
    		Integer refId) throws Exception;
    
    // 파일 다운로드
    AtchFileDto getFileForDownload(Integer fileId, Integer systemId, Integer refId) throws Exception;
    
    // 파일 삭제
    void deleteFile(Integer fileId) throws Exception;
}
