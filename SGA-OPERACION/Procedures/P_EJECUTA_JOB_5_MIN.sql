CREATE OR REPLACE PROCEDURE OPERACION.p_ejecuta_job_5_min(a_pry in number) IS

  /************************************************************
  NOMBRE:     OPERACION.p_ejecuta_job_5_min
  PROPOSITO:  Procedimiento que se asocia con la  frecuencia de ejecucion de un procedimiento
              en la definicion de la tarea
  PROGRAMADO EN JOB:

  REVISIONES:
  Version      Fecha        Autor           Descripcisn
  ---------  ----------  ---------------  ------------------------
  1.0        23/11/2009  Jimmy Farfan     Req. 97766

  ***********************************************************/

  cursor c_wf is
    select a.idtareawf,
           a.tarea,
           a.idwf,
           a.tipesttar,
           a.tareadef,
           b.cur_proc
      from tareawf a, tareawfcpy b
     where a.idtareawf = b.idtareawf
       and b.frecuencia = 5
       and a.tipesttar in (1, 2);

BEGIN
  for c_1 in c_wf loop
    if c_1.cur_proc is not null then
      PQ_WF.P_EJECUTA_PROC(c_1.cur_proc,
                           c_1.idtareawf,
                           c_1.idwf,
                           c_1.tarea,
                           c_1.tareadef);
    end if;
  end loop;
END p_ejecuta_job_5_min;
/


