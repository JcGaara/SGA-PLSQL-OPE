CREATE OR REPLACE VIEW OPERACION.V_JOB_CORTE_SERVICIO
AS 
select case
      when (to_char( sysdate, 'hh24' ) between 08 and 12) then  trunc(sysdate)+13/24
      when (to_char( sysdate, 'hh24' ) between 13 and 16) then  trunc(sysdate)+17/24
      when (to_char( sysdate, 'hh24' ) between 17 and 24) then  trunc(sysdate + 1)+7/24
        end interval_date
           from dual;


