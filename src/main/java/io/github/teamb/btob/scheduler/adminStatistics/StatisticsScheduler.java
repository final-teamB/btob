package io.github.teamb.btob.scheduler.adminStatistics;

import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.JobParametersBuilder;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import io.github.teamb.btob.mapper.adminStatistics.StatisticsMapper;
import lombok.RequiredArgsConstructor;

@Component
@EnableScheduling
@RequiredArgsConstructor
public class StatisticsScheduler {

	private final JobLauncher jobLauncher;
	private final Job refreshOrderStatsJob;
	
	@Autowired
    private StatisticsMapper statisticsMapper;
	
	@Scheduled(cron = "0 59 23 * * *")
	public void runOrderStatsBatch() {
		try {
			JobParameters params = new JobParametersBuilder()
					.addLong("timestamp", System.currentTimeMillis())
					.toJobParameters();
			
			jobLauncher.run(refreshOrderStatsJob, params);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 매일 밤 23시 59분에 실행 (Cron 표현식)
    @Scheduled(cron = "0 59 23 * * *")
    public void saveDailyStats() {
        System.out.println("일일 유류 통계 기록 시작...");
        statisticsMapper.insertDailyOilStats();
    }
}
