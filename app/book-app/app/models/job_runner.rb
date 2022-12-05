class JobRunner
  def execute(job:, payload: nil)
    case job
    when 'db_migrate'
      run_db_migrate_job
    when 'db_seed'
      run_db_seed_job
    when 'test_book_job'
      run_test_book_job(payload)
    else
      raise NotImplementedError, 'unknown job name'
    end
  end

  private

  def run_db_migrate_job
    Rails.application.load_tasks
    Rake::Task['db:migrate'].execute
  end

  def run_db_seed_job
    Rails.application.load_tasks
    Rake::Task['db:seed'].execute
  end

  def run_test_book_job(payload)
    Rails.logger.info("Successfully test_book_job completed: #{payload}")
  end
end