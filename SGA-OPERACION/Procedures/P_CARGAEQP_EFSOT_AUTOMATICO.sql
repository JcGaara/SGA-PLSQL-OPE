CREATE OR REPLACE PROCEDURE OPERACION.P_CARGAEQP_EFSOT_AUTOMATICO
AS

------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
/*c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.P_CARGAEQP_EFSOT_AUTOMATICO';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='233';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );*/
--------------------------------------------------


v_RESPONSABLE_PI varchar2(30);
v_codcon number;
v_cont number;

cursor cur is
select 
        v.numslc, 
        v.tipsrv, 
        s.codsolot
from 
        solot s,
        vtatabslcfac v
where 
        s.estsol = 17 
        and to_char(s.fecultest,'dd/mm/yyyy') = to_char(sysdate-1,'dd/mm/yyyy')
        and s.numslc = v.numslc
        and v.tipsrv in ('0058','0059');

begin

      for reg in cur loop
      
          operacion.pq_custoper.p_transfieresotproyecto_sap(reg.numslc,reg.codsolot);
          commit;

          v_cont := 0;

          select count(*) into v_cont from solotptoequ
          where (nro_res is not null
                or nro_res_l is not null)
                and coDsolot = reg.codsolot;


          if v_cont = 0 then

               if reg.tipsrv = '0058' then --Paquete Pymes
                  v_RESPONSABLE_PI := 'RCRUZ';
                  v_codcon := 43; --BMP
               end if;
               if reg.tipsrv = '0059' then --TPI
                  v_RESPONSABLE_PI := 'KSONCO';
                  v_codcon := 117; --RASS
              end if;

              if reg.tipsrv = '0058' OR reg.tipsrv = '0059' then
                  update SOLOTPTO_ID
                  set
                         RESPONSABLE_PI = v_RESPONSABLE_PI,
                         CODCON = v_codcon,
                         ESTADO = 'Generado'
                  where codsolot = reg.codsolot
                  and codcon is null
                  and responsable_pi is null;
                  commit;
              end if;

              OPERACION.P_LLENA_SOLOTEQU_DE_EF(reg.codsolot);
              commit;
              update solotptoequ set fecfdis = sysdate where codsolot = reg.codsolot;
              commit;
           end if;
      end loop;
--------------------------------------------------
---ester codigo se debe poner en todos los stores
---que se llaman con un job
--para ver si termino satisfactoriamente
/*sp_rep_registra_error
   (c_nom_proceso, c_id_proceso,
    sqlerrm , '0', c_sec_grabacion);

------------------------
exception
  when others then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);*/

      
end;
/


