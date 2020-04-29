CREATE OR REPLACE PROCEDURE OPERACION.P_CARGAEQP_EFSOT_AUTO_DTH
AS
/********************************************************************************
     NOMBRE: P_CARGAEQP_EF_SOT_AUTO_DTH
     PROPOSITO: CARGA DE EQUIPOS DESDE LA EF A LA SOLOT
     Creacion
     Ver     Fecha          Autor              Descripcion
    ------  ----------     ----------         --------------------
     1.0                                      Creación
     2.0    19/02/2010     MEchevarria        REQ-120026: se deshabilito la carga para el tipo de trabajo 457
 ********************************************************************************/


-- Variables para el envio de correos
/*c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.P_CARGAEQP_EFSOT_AUTO_DTH';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='1162';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );*/
--------------------------------------------------

v_cont number;
v_efptoequ number;
v_codef   ef.codef%type;

cursor cur is
    select v.numslc, v.tipsrv, s.estsol, s.codsolot, s.tiptra, s.fecusu
      from solot s, vtatabslcfac v, estsol e
     where s.estsol= e.estsol
       and e.tipestsol  in (4,6)
       and s.numslc = v.numslc
       and v.tipsrv in ('0061','0064')
       and not exists (select codsolot from solotptoequ q where q.codsolot=s.codsolot)
       --and s.tiptra in (419, 438, 1, 457, 458, 469) --<2.0>
       and s.tiptra in (419, 438, 1,458, 469)--<2.0>
--      and v.numslc in ('0000300597', '0000079621','0000239261')
       order by v.numslc;

begin

      for reg in cur loop

           select distinct codef into v_codef from ef where numslc=reg.numslc;
           select count (codef) into v_efptoequ from efptoequ where codef=v_codef;

           if v_efptoequ=0 then
                  operacion.p_act_efequ_de_soleftpi(v_codef);
                  commit;
                  operacion.p_act_costo_ef(v_codef);
                  commit;
           end if;

          operacion.pq_custoper.p_transfieresotproyecto_sap(reg.numslc,reg.codsolot);
          commit;

          v_cont := 0;

          select count(*) into v_cont from solotptoequ
          where (nro_res is not null or nro_res_l is not null) and codsolot = reg.codsolot;

          if v_cont = 0 then

              OPERACION.P_LLENA_SOLOTEQU_DE_EF(reg.codsolot);
              commit;
              update solotptoequ set fecfdis = sysdate where codsolot = reg.codsolot;
              commit;

           end if;
      end loop;

--- Este codigo se debe poner en todos los stores que se llaman con un job para ver si termino satisfactoriamente
/*sp_rep_registra_error (c_nom_proceso, c_id_proceso, sqlerrm , '0', c_sec_grabacion);
-------------------------------
exception
  when others then
      sp_rep_registra_error
         (c_nom_proceso, c_id_proceso,
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);*/

end;
/


