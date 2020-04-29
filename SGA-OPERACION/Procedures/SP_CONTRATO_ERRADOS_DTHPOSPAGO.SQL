CREATE OR REPLACE PROCEDURE OPERACION.SP_CONTRATO_ERRADOS_DTHPOSPAGO is
    ls_nro_contrato     varchar2(500);
    lv_resp_actDTH      varchar2(500);
    lv_IPaplicacion     varchar2(30);
    lv_aplicacion       varchar2(30);
    lv_servicio         varchar2(30);
   lv_usuario          varchar2(30);
    ln_valida_act       number;
   ln_act              number;
    an_numslc             char(10);
ac_mensaje varchar2(500);

cursor c_carga is
    select a.*
      from ope_srv_recarga_cab a,
           (select tw.esttarea, f.codsolot
              from tareawf tw, wf f
             where tw.idwf = f.idwf
               and tw.tareadef = 1070) reg
     where a.flg_envio_act like '%|-%'
       and trunc(a.fecusu) > to_date('01/01/2015','DD/MM/YYYY')
       and reg.codsolot = a.codsolot
       and reg.esttarea = 4;
begin
 for c_r  in c_carga loop
   an_numslc:=c_r.numslc;

  select o.nro_contrato
  into ls_nro_contrato
  from OPE_SRV_RECARGA_CAB O
  where O.NUMSLC =  an_numslc;
 c_r.flg_envio_act:=null;

   if c_r.flg_envio_act is null then
         --Ip-aplicacion
      select o.descripcion into lv_IPaplicacion
        from operacion.tipopedd t, operacion.opedd o
       where t.abrev = 'WSDTH'
         and t.tipopedd = o.tipopedd
         and o.abreviacion = 'IPAPLICACION';
         --Aplicacion
       select o.descripcion into  lv_aplicacion
        from operacion.tipopedd t, operacion.opedd o
       where t.abrev = 'WSDTH'
         and t.tipopedd = o.tipopedd
         and o.abreviacion = 'APLICACION';

         --Usuario
       select o.descripcion into lv_usuario
        from operacion.tipopedd t, operacion.opedd o
       where t.abrev = 'WSDTH'
         and t.tipopedd = o.tipopedd
         and o.abreviacion = 'USUARIO';
     BEGIN

          lv_resp_actDTH:=sales.pq_dth_postventa.f_activarDTH_vc(to_char(sysdate,'ddmmyyyyhhmmss')||ls_nro_contrato,lv_IPaplicacion,lv_aplicacion,to_number(ls_nro_contrato),lv_usuario); -- 14.0
      UPDATE OPE_SRV_RECARGA_CAB a SET a.FLG_ENVIO_ACT=lv_resp_actDTH ,a.flag_verif_conax=1 WHERE a.NUMSLC = an_numslc;---8.0
      commit;---8.0
     exception
      when OTHERS then
        ac_mensaje := 'ERROR ACTIVACIÓN A SISACT' || ac_mensaje || sqlerrm;
         return;
      END;

    end if;

end loop;
--fin 7.0


end SP_CONTRATO_ERRADOS_DTHPOSPAGO;
/
