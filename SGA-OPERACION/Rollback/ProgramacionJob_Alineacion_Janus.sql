---Script de programacion cada 20 min
declare 
v_job Integer;
begin
  sys.dbms_job.submit(job => v_job,
                      what => 'OPERACION.PQ_CONT_REGULARIZACION.SP_ALINEACION_JANUS_JOB;',
                      next_date => to_date('23-09-2015 12:18:51', 'dd-mm-yyyy hh24:mi:ss'),
                      interval => 'sysdate + 1/72');
  commit;
end;
/
