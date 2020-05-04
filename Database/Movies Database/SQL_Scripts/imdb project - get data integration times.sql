USE DI_CNTL_Dev
GO

SELECT top 100000
  stats.job_name,
  job_status,
  is_root_job,
  root_name,
 -- convert(numeric(15,2),(convert(numeric(15,2), job_duration) /1000.00))  as "Duration (seconds)",
  convert(numeric(15,2),( (convert(numeric(15,2), job_duration) /1000.00))/60.00 )  as "Duration (minutes)",
   job_duration as "Duration (milliseconds)",
  sc.moment job_start_time,
  job_finish_time,
  stats.Job_pid,
  stats.father_pid as parent_pid,
  stats.root_pid
 -- context,
  --job_sk,
 -- moment,
FROM  cntl_JobStats stats
left outer join cntl_statCatcher sc 
on stats.pid = sc.pid 
where sc.message_type = 'begin'
--and job_name 'you_root_job_name'
--and stats.is_root_job  = 'y'                       -- if you just want root jobs
and job_finish_time > DATEADD(HOUR, -1, GETDATE())   -- change to whatever time time interval
order by stats.job_finish_time desc
GO


