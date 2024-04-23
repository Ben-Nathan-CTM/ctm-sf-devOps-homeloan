@IsTest
public class HLA_CreditScoreAssessmentScheduleTest {
  private final static String TEST_CRON_STATEMENT = '0 0 0 28 5 ? 2099';

  @isTest
  public static void should_create_scheduled_job() {
    MockHttpResponseGenerator mockHttp = new MockHttpResponseGenerator();
    Test.setMock(HttpCalloutMock.class, mockHttp);
    // query for the job to make sure it's scheduled at the right time/date

    Test.startTest();
    String scheduledJobId = System.schedule(
      'HLA_CreditScoreAssessmentSchedule',
      TEST_CRON_STATEMENT,
      new HLA_CreditScoreAssessmentSchedule()
    );
    Test.stopTest();

    CronTrigger checkCronTrigger = [
      SELECT CronExpression, timesTriggered, nextFireTime
      FROM CronTrigger
      WHERE id = :scheduledJobId
      LIMIT 1
    ];
    System.assertEquals(
      checkCronTrigger.CronExpression,
      TEST_CRON_STATEMENT,
      'These two cron statements should be equal'
    );

    System.assertEquals(
      checkCronTrigger.timesTriggered,
      0,
      'Expected this cron trigger to never have been fired'
    );

    System.assertEquals(
      String.valueOf(checkCronTrigger.nextFireTime),
      '2099-05-28 00:00:00',
      'Expected the next fire time to be set to 5/28/2099 at midnight'
    );
  }
}
