package io.github.teamb.btob.service.attachfile;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import io.github.teamb.btob.dto.attachfile.AtchFileDto;
import jakarta.servlet.http.HttpServletResponse;

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
    
    // 첨부 파일 수정 시 삭제 처리 ( 미사용으로 변경 처리 )
    void updateUnusedFiles(String systemId, Integer refId, List<String> remainingFileNames) throws Exception;
    
    // 파일 이미지 송출
    void displayImage(String systemId, String fileName, HttpServletResponse response) throws Exception;
    
    // 일반 미사용 처리
    Integer updateUnuseAtchFile(List<Integer> refIds, String userId) throws Exception;
    
    // 임시파일 저장
    AtchFileDto uploadImgTempFile(MultipartFile file) throws Exception;
    
    // 서버 내 특정 임시 경로의 파일을 시스템 저장소로 이동 및 등록
    AtchFileDto registerInternalImgFile(AtchFileDto fileDto) throws Exception;
    
    // 상품 세부정보 변경 시 사용여부 동적
    void updateUseYnByDetailChg(String useYn, Integer fileId, String strFileNm) throws Exception;
    
    // 세부정보에서 수정 시 아이디랑 변환파일명
    AtchFileDto getFileIdAndStrFileNm(Integer refId, String systemId) throws Exception;
}
