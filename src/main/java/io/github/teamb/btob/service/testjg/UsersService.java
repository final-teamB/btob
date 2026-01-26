package io.github.teamb.btob.service.testjg;

import java.util.List;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import io.github.teamb.btob.dto.testjg.UserExcelResult;
import io.github.teamb.btob.dto.testjg.Users;
import io.github.teamb.btob.mapper.testjg.UsersMapper;

@Service
@Transactional
public class UsersService {
	private final UsersMapper usersMapper;

    public UsersService(UsersMapper usersMapper) {
        this.usersMapper = usersMapper;
    }
    
    public UserExcelResult readExcel(MultipartFile file) throws Exception {
        UserExcelResult result = new UserExcelResult();

        try (Workbook workbook = new XSSFWorkbook(file.getInputStream())) {
            Sheet sheet = workbook.getSheetAt(0);
            int lastRow = sheet.getLastRowNum();
            result.setTotalCount(lastRow);

            for (int r = 1; r <= lastRow; r++) { // 0번 행은 헤더
                Row row = sheet.getRow(r);
                if (row == null) continue;

                String userId   = getCellValue(row.getCell(0));
                String userName = getCellValue(row.getCell(1));
                String phone    = getCellValue(row.getCell(2));
                String email    = getCellValue(row.getCell(3));
                String companyCd= getCellValue(row.getCell(4));

                // 검증
                UserExcelResult.FailItem fail = validateRow(r, userId, userName, companyCd);
                if(fail != null) {
                    result.getFailList().add(fail);
                    continue;
                }

                // DTO 생성
                Users user = new Users();
                user.setUserId(userId);
                user.setPassword("1234"); // 테스트용
                user.setUserName(userName);
                user.setPhone(phone);
                user.setEmail(email);
                user.setCompanyCd((companyCd == null || companyCd.trim().isEmpty()) ? null : companyCd);
                user.setUserType("USER");
                user.setAppStatus("APPROVED");
                user.setAccStatus("ACTIVE");
                user.setRegId("admin");
                user.setUpdId("admin");
               

                result.getSuccessList().add(user);
            }
        }

        result.setSuccessCount(result.getSuccessList().size());
        result.setFailCount(result.getFailList().size());
        return result;
    }
    
    public int commitExcel(List<Users> list) {
        int count = 0;
        for(Users user : list) {
            usersMapper.insertUsers(user);
            count++;
        }
        return count;
    }
    
    private String getCellValue(Cell c) {
        if(c == null) return null;
        if(c.getCellType() == CellType.STRING) return c.getStringCellValue().trim();
        if(c.getCellType() == CellType.NUMERIC) return String.valueOf((int)c.getNumericCellValue());
        return null;
    }
    
    private UserExcelResult.FailItem validateRow(int row, String userId, String userName, String companyCd) {
        if(userId == null || userName == null || companyCd == null) {
            return createFail(row, userId, "필수 항목 누락");
        }
        if(usersMapper.checkUserId(userId) > 0) {
            return createFail(row, userId, "중복된 ID");
        }
        return null;
    }
    
    private UserExcelResult.FailItem createFail(int rowNum, String userId, String reason) {
        UserExcelResult.FailItem f = new UserExcelResult.FailItem();
        f.setRowNum(rowNum + 1);
        f.setUserId(userId);
        f.setReason(reason);
        return f;
    }
	    
}
