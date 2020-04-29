CREATE OR REPLACE PROCEDURE OPERACION.p_anula_pend_pago is
  /*********************************************************************************
  Procedimiento que Anula las SOTs que tienen mas de 30 días como pendientes de pago, Solo se incluyen las SOTs
  de Tiptra= 404 para los tipsrv in ('0061','0062').
  Author  : JOSE.RAMOS
  Created : 24/10/2008
  ***********************************************************************************/

------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.P_ANULA_PEND_PAGO';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='10000';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );
--------------------------------------------------



  cursor cur1 is

    select s.estsol, s.codsolot, se.fecha
      from solotchgest se, solot s, tystipsrv t
     where se.codsolot = s.codsolot
       and s.tipsrv = t.tipsrv
       and se.estado = 14
       and se.estado = s.estsol
       and (sysdate - se.fecha) > 30
       and s.tiptra in (404)
       and s.tipsrv in ('0061', '0062');
  l_cuenta number;

begin
  for c in cur1 loop
    BEGIN
      select count(*) into l_cuenta from solot where codsolot = c.codsolot;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        l_cuenta := 0;
    END;
    if l_cuenta > 0 then
      operacion.pq_solot.p_chg_estado_solot(c.codsolot,
                                            13,
                                            14,
                                            'Se anula la SOT por vencimiento, Fecha Pendiente de Pago:' ||
                                            to_char(trunc(c.fecha),
                                                    'dd/mm/yyyy') ||
                                            ', Fecha de Anulación:' ||
                                            to_char(trunc(sysdate),
                                                    'dd/mm/yyyy'));
    end if;
  end loop;
  commit;

--------------------------------------------------
---ester codigo se debe poner en todos los stores
---que se llaman con un job
--para ver si termino satisfactoriamente
sp_rep_registra_error
   (c_nom_proceso, c_id_proceso,
    sqlerrm , '0', c_sec_grabacion);

------------------------
exception
  when others then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm||' error(lineas) '||DBMS_UTILITY.format_error_backtrace , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);

end;
/


