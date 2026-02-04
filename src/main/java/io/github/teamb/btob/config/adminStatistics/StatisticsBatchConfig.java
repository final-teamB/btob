package io.github.teamb.btob.config.adminStatistics;

import org.springframework.batch.core.Job;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.job.builder.JobBuilder;
import org.springframework.batch.core.repository.JobRepository;
import org.springframework.batch.core.step.builder.StepBuilder;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.PlatformTransactionManager;

import io.github.teamb.btob.mapper.adminStatistics.StatisticsMapper;
import lombok.RequiredArgsConstructor;

@Configuration
@RequiredArgsConstructor
public class StatisticsBatchConfig {

	private final JobRepository jobRepository;
    private final PlatformTransactionManager transactionManager;
    private final StatisticsMapper statisticsMapper;

    @Bean
    public Job refreshOrderStatsJob() {
        return new JobBuilder("refreshOrderStatsJob", jobRepository)
                .start(orderStatsStep())
                .build();
    }

    @Bean
    public Step orderStatsStep() {
        return new StepBuilder("orderStatsStep", jobRepository)
                .tasklet(updateOrderStatsTasklet(), transactionManager)
                .build();
    }

    @Bean
    public Tasklet updateOrderStatsTasklet() {
        return (contribution, chunkContext) -> {
            // 기존 Mapper의 refreshOrderStats 호출 (userNo는 시스템 자동갱신용 0 전달)
            statisticsMapper.refreshOrderStats(0);
            return RepeatStatus.FINISHED;
        };
    }
}
