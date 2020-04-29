create or replace package body OPERACION.PROCESOS_INTRAWAY is
  /****************************************************************************
   Nombre Package    : procesos_intraway
   Proposito         : Procedimiento creados para los procesos Intraway
   REVISIONES:
   Ver  Fecha       Autor             Solicitado por    Descripcion
   ---  ----------  ----------------  ----------------  ----------------------
   1.0  08/01/2016  Freddy Gonzales   karen Velezmoro   SD-621816
  ****************************************************************************/
  procedure ASIGNA_IDVENTA(LD_FECHA date) is
    --a.  Asigna valor al id_venta y id_venta_padre
    l_cont   number;
    cursor abc is
      select *
        from int_mensaje_intraway i
       where exists
       (select 't' from intraway.int_envio where codsolot = i.codsolot)
         and id_venta_padre is null
          or id_venta is null
         and fecha_creacion > LD_FECHA - 3;
  
  begin
    l_cont := 0;
    for bb in abc loop
      update int_mensaje_intraway
         set id_venta = 0, id_venta_padre = 0
       where codsolot = bb.codsolot
         and id_interfaz = bb.id_interfaz;
      update intraway.int_envio
         set id_venta = 0, id_venta_padre = 0
       where codsolot = bb.codsolot
         and id_interfaz = bb.id_interfaz;
    
      l_cont := l_cont + 1;
      if l_cont = 100 then
        l_cont := 0;
        commit;
      end if;
    end loop;
    commit;
  
  exception
    when others then
      DBMS_OUTPUT.PUT_LINE('El error es:' || sqlerrm);
    
  end;
  --------------------------------------------------------------------------------
  procedure ALINEA_SUSP_REC_DUP(LD_DATE date) is
    --b. Alinea las suspensiones y reconexiones duplicadaas
    cursor abc is
      select min(id_lote),
             codcli,
             id_interfase,
             id_estado,
             id_producto,
             id_error,
             id_mensaje
        from intraway.int_envio i
       where codcli in (select s.codcli
                          from solot s, tiptrabajo tip, estsol e
                         where s.tiptra = tip.tiptra
                           and s.estsol = e.estsol
                           and s.tiptra in (441, 443, 442)
                           and s.estsol = 17
                           and s.fecusu > trunc(LD_DATE - 7)
                         group by s.codcli, tip.descripcion, e.descripcion
                        having count(s.codsolot) > 1)
         and id_error = 0
       group by id_interfase,
                id_estado,
                id_producto,
                codcli,
                id_error,
                id_mensaje;
  begin
    for bb in abc loop
      update intraway.int_envio
         set id_error = bb.id_error, id_mensaje = bb.id_mensaje, est_envio = 3
       where codcli = bb.codcli
         and id_interfase = bb.id_interfase
         and id_estado = bb.id_estado
         and id_producto = bb.id_producto
         and id_error is null;
      commit;
    end loop;
    
  exception
    when others then
      DBMS_OUTPUT.PUT_LINE('El error es:' || sqlerrm);
    
  end;
  --------------------------------------------------------------------------------
  procedure ACT_PROCESOS_BAJA(LD_FECHA date) is
    --c.ctualiza los procesos de baja
    p_error    number;
    p_mensaje  varchar2(1000);
    l_err      varchar2(1000);
    l_mensaje  varchar2(1000);
    v_mail     varchar2(200);
  
    cursor abc is
      select distinct s.codsolot
        from solot s, opedd o
       where s.tiptra in (select t2.codigon
                            from tipopedd t1, opedd t2
                           where t1.tipopedd = t2.tipopedd
                             and t1.abrev = 'TIPTRA_ANULA_SOT_INST_HFC'
                             and t2.codigoc = 'ACTIVO')
         and o.abreviacion = 'RECH_X_SIS'
         and o.codigoc = 'ACTIVO'
         and s.estsol = o.codigon;
  
  begin
    for bb in abc loop
      begin
        operacion.pq_anulacion_bscs.p_anula_iw(bb.codsolot, p_error, p_mensaje);
      exception
        when others then
          l_err     := sqlerrm;
          l_mensaje := 'ERROR EN EL CURSOR:' || l_err || CHR(10) || ' SOT :' ||
                       bb.codsolot || CHR(10) || ' DETALLE: ' || l_err ||
                       chr(10) || dbms_utility.format_error_stack || '@' ||
                       dbms_utility.format_call_stack || chr(10) ||
                       dbms_utility.format_error_backtrace;
        
          select EMAIL
            into v_mail
            from ENVCORREO
           where TIPO = 10
             and AREA = 1;
             
          OPEWF.PQ_SEND_MAIL_JOB.p_send_mail('OPERACION.PROCESOS_INTRAWAY.ACT_PROCESOS_BAJA',
                                             v_mail,
                                             l_mensaje);
      end;
    end loop;
  
  exception
    when others then
      l_err     := sqlerrm;
      l_mensaje := 'ERROR EN EL PROCEDURE:' || l_err || CHR(10) || ' DETALLE: ' ||
                   l_err || chr(10) || dbms_utility.format_error_stack || '@' ||
                   dbms_utility.format_call_stack || chr(10) ||
                   dbms_utility.format_error_backtrace;
    
      select EMAIL
        into v_mail
        from ENVCORREO
       where TIPO = 10
         and CODDPT = '8001';
         
      OPEWF.PQ_SEND_MAIL_JOB.p_send_mail('OPERACION.PROCESOS_INTRAWAY.ACT_PROCESOS_BAJA',
                                         v_mail,
                                         l_mensaje);
  end;
  --------------------------------------------------------------------------------
  procedure ACTUALIZA_HUB(LD_DATE date) is
    --e.ctualiza error por el hub pendiente.  
    l_hub          ope_hub.abrevhub%type;
    put1           varchar2(1000);
    put2           varchar2(1000);
    L_CABECERA_XML varchar2(50);
    l_interfaz     number;
    LS_ERROR       varchar2(500);
  
    cursor ABC is
      select * from intraway.int_envio where ID_ERROR = 22096;
  
    cursor cde is
      select '<' || nombre_atributo || '>' || valor_atributo || '</' ||
             nombre_atributo || '>' val
        from int_mensaje_atributo_intraway
       where id_mensaje_intraway = l_interfaz;
  
  begin
    for BB in ABC loop
      put1  := '';
      put2  := '';
      l_hub := intraway.pq_intraway_proceso.f_obt_hub_pla_o_ubi(bb.codinssrv);
    
      if l_hub is not null then
        begin
          update int_mensaje_atributo_intraway
             set valor_atributo = l_hub
           where id_mensaje_intraway = bb.id_interfaz
             and nombre_atributo = 'defaultConfigCRMId';
          commit;
        
          l_interfaz := BB.ID_INTERFAZ;
          for cc in cde loop
            put2 := put2 || cc.val;
          end loop;
        
          select cabecera_xml
            into l_cabecera_xml
            from int_mensaje_intraway
           where codsolot = bb.codsolot
             and id_interfaz = bb.id_interfaz;
        
          put1 := '<' || L_CABECERA_XML || '>' || put2 || '</' ||
                  L_CABECERA_XML || '>';
        
          update INTRAWAY.INT_ENVIO
             set ID_CONEXION = 0, CABECERA_XML = put1, EST_ENVIO = 0
           where CODSOLOT = BB.CODSOLOT
             and ID_LOTE = BB.ID_LOTE;
          commit;
        
          --Relanza cuando la cantidad de est_envio = 1 no cambia
          update intraway.int_envio
             set est_envio = 0, id_venta = 0, id_venta_padre = 0
           where est_envio = 1;
          commit;
        
        exception
          when others then
            LS_ERROR := sqlerrm;
            DBMS_OUTPUT.put_line(BB.CODSOLOT || '|' || BB.CODINSSRV || '|' ||
                                 LS_ERROR);
        end;
      else
        dbms_output.put_line(bb.codsolot || '|' || bb.codinssrv || '|SIN HUB');
      end if;
    end loop;
  end;
  --------------------------------------------------------------------------------
  procedure REENVIO_ERROR(LD_FECHA date) is
    --f.Reenvio por error - Actualiza fecha para que el sistema lo coja de inmediato
    LS_ERROR varchar2(500);
    l_frec   number;
    l_cenv   number;
    
    cursor abc is
      select *
        from intraway.int_envio
       where est_envio = 3
         and id_error <> 0;
  
  begin
    for bb in abc loop
      select frecuencia, cant_envios
        into l_frec, l_cenv
        from intraway.int_errores_iw
       where iderror = bb.id_error;
    
      update int_transaccionesxsolot
         set envio = l_cenv + 1
       where codsolot = bb.codsolot
         and id_lote = bb.id_lote;
      update intraway.int_envio
         set fecha_frecuencia = fecha_frecuencia - 8 / 120
       where codsolot = bb.codsolot
         and id_lote = bb.id_lote;
    
    end loop;
    commit;
  
    --g. Elimina lo que no me sirve  
    delete from intraway.int_envio i
     where exists (select 'y'
              from solot s
             where s.codsolot = i.codsolot
               and s.estsol not in (29, 17, 20, 22, 11));
    commit;
  exception
    when others then
      LS_ERROR := sqlerrm;
      dbms_output.put_line('El error es: ' || LS_ERROR);
  end;
  --------------------------------------------------------------------------------
  procedure ACTUALIZA_EST_SOT(LD_FECHA date) is
    --H.Actuliza el estado de la SOT.  
    l_idwf   wf.idwf%type;
    l_wfdef  wf.wfdef%type;
    l_cent   number;
    LS_ERROR varchar2(500);
    
    cursor abc is
      select distinct codsolot
        from intraway.int_envio i
       where exists (select 'y'
                from solot
               where estsol = 11
                 and codsolot = i.codsolot);
  
  begin
    for bb in abc loop
      l_cent := 0;
      begin
        select idwf, wfdef
          into l_idwf, l_wfdef
          from wf
         where codsolot = bb.codsolot
           and valido = 1;
        opewf.pq_wf.P_CANCELAR_WF(l_idwf);
        l_cent := 1;
        commit;
      
      exception
        when others then
          lS_error := sqlerrm;
          dbms_output.put_line(bb.codsolot || '|1|' || lS_error);
          l_cent := 0;
      end;
    
      if l_cent = 1 then
        begin
          operacion.pq_solot.p_asig_wf(bb.codsolot, l_wfdef);
          commit;
        exception
          when others then
            lS_error := sqlerrm;
            dbms_output.put_line(bb.codsolot || '|2|' || lS_error);
        end;
      end if;
    end loop;
  
  exception
    when others then
      LS_ERROR := sqlerrm;
      DBMS_OUTPUT.PUT_LINE('El error es:' || sqlerrm);
    
  end;
  --------------------------------------------------------------------------------
  procedure ACTUALIZA_SOT(LD_FECHA date) is
    --I. Actualiza según el estado de la Sot  
    lS_error varchar2(1000);
    int_ev   number;
    int_tr   number;
    
    cursor abc is
      select *
        from solot s
       where ((s.tiptra in (424, 658, 427) and estsol not in (20, 22, 17)) or
             (s.tiptra in (412, 620)))
         and exists (select 'f'
                from int_solot_itw
               where codsolot = s.codsolot
                 and estado < 4);
  begin
    for bb in abc loop
      begin
        int_ev := 0;
        int_tr := 0;
      
        update int_solot_itw
           set estado = 4, flagproc = 1
         where codsolot = bb.codsolot;
      
        select count(1)
          into int_ev
          from intraway.int_envio
         where codsolot = bb.codsolot;
         
        select count(1)
          into int_tr
          from int_transaccionesxsolot
         where codsolot = bb.codsolot;
         
        if int_ev > 0 then
          delete from intraway.int_envio where codsolot = bb.codsolot;
        end if;
        
        if int_tr > 0 then
          update int_transaccionesxsolot
             set estado = 0
           where codsolot = bb.codsolot;
        end if;
        
      exception
        when others then
          lS_error := sqlerrm;
          dbms_output.put_line(bb.codsolot || '|' || lS_error);
      end;
      commit;
    end loop;
  
    --j. --Para actualizar los estados de los servicios que no se necesita dar de baja  
    update int_transaccionesxsolot
       set estado = 3
     where codsolot in
           (select distinct codsolot from intraway.int_envio where proceso = 4)
       and id_interfase in (830, 2030, 500);
    commit;
  
    update int_transaccionesxsolot i
       set i.estado = 3
     where i.codsolot in
           (select distinct codsolot from intraway.int_envio where proceso = 4)
       and exists (select 'y'
              from int_mensaje_intraway
             where codsolot = i.codsolot
               and id_interfase = i.id_interfase
               and id_producto = i.id_producto
               and id_lote = i.id_lote
               and proceso <> 4);
    commit;
  
  exception
    when others then
      LS_ERROR := sqlerrm;
      DBMS_OUTPUT.PUT_LINE('El error es:' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  procedure ACTUALIZA_TRSMAMBAF(LD_FECHA date) is
    L_CONT   number;
  
    cursor ABC is
      select distinct S.CODSOLOT, S.TIPTRA
        from OPERACION.TRSBAMBAF T, SOLOT S
       where T.CODSOLOT = S.CODSOLOT
         and S.TIPTRA in (441, 442, 443, 672)
         and S.ESTSOL = 17
         and exists (select 'Y'
                from INTRAWAY.INT_ENVIO
               where CODSOLOT = S.CODSOLOT
                 and CODCLI = S.CODCLI)
         and T.EST_ENVIO <> 3;
  
  begin
    L_CONT := 0;
    for BB in ABC loop
      L_CONT := L_CONT + 1;
      begin
        update OPERACION.TRSBAMBAF
           set EST_ENVIO = 3
         where CODSOLOT = BB.CODSOLOT;
      exception
        when others then
          DBMS_OUTPUT.PUT_LINE(BB.CODSOLOT || sqlerrm);
      end;
      commit;
    end loop;
    DBMS_OUTPUT.PUT_LINE('----------------');
    DBMS_OUTPUT.PUT_LINE('CANTIDAD ' || L_CONT);
  
  exception
    when others then
      DBMS_OUTPUT.PUT_LINE('El error es:' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  procedure ACTUALIZA_TAREAWFCPY(LD_FECHA date) is
    --l. Actualiza las tareas para la reconexion
    sql_str  varchar2(10000);
  
    cursor x_up is
      select 'UPDATE TAREAWFCPY SET PRE_PROC = NULL WHERE IDTAREAWF = ' ||
             P.IDTAREAWF || ' AND IDWF = ' || P.IDWF || '' QQ,
             S.CODSOLOT,
             P.*
        from SOLOT S, WF W, TAREAWFCPY P
       where S.CODSOLOT = W.CODSOLOT
         and W.IDWF = P.IDWF
         and P.TAREADEF = 1061
         and W.VALIDO = 1
         and S.TIPTRA in (443, 4)
         and S.ESTSOL = 17
         and not exists
       (select 'Y' from operacion.trsoac where CODSOLOT = S.CODSOLOT)
         and exists
       (select 'T' from INTRAWAY.INT_ENVIO where CODSOLOT = S.CODSOLOT)
         and p.PRE_PROC is not null;
    --Si aparece data ejecutar esta en el comand
  begin
    for z in x_up loop
      sql_str := z.QQ;
      execute immediate sql_str;
      commit;
    
    end loop;
  
  exception
    when others then
      DBMS_OUTPUT.PUT_LINE('El error es:' || sqlerrm);
  end;
  --------------------------------------------------------------------------------
  procedure ACTUALIZA_TRANSACCIONES(LD_FECHA date) is
    --m.--Validar transacciones
    sql_upd  varchar2(10000);
    sql_del  varchar2(10000);
  
    cursor x_ is
      select decode(s.estsol,
                    17,
                    decode((select count(1)
                             from int_solot_itw
                            where estado in (4)
                              and codsolot = s.codsolot),
                           1,
                           'update int_solot_itw set estado = 3, flagproc = 0 where codsolot = ' ||
                           s.codsolot || '')) upd_solot,
             decode(s.estsol,
                    12,
                    'delete from intraway.int_envio where codsolot = ' ||
                    s.codsolot || '') del_solot,
             (select count(1)
                from int_solot_itw
               where estado = 4
                 and codsolot = s.codsolot) int_solot,
             (select count(1)
                from int_solot_itw
               where estado = 3
                 and codsolot = s.codsolot
                 and flagproc = 0) int_solot1,
             (select count(1)
                from intraway.int_envio
               where codsolot = s.codsolot) env,
             (select count(1)
                from intraway.int_envio
               where codsolot = s.codsolot
                 and est_envio = 3) env3,
             (select count(1)
                from intraway.int_envio
               where codsolot = s.codsolot
                 and est_envio = 4) env4,
             (select count(1)
                from intraway.int_envio
               where codsolot = s.codsolot
                 and est_envio = 5) env5,
             (select count(1)
                from int_transaccionesxsolot
               where codsolot = s.codsolot) tran,
             (select count(1)
                from int_transaccionesxsolot
               where codsolot = s.codsolot
                 and estado = 3) tran3,
             s.*
        from solot s
       where s.codsolot in (select distinct codsolot from intraway.int_envio)
         and s.tiptra not in (448);
  
  begin
    for a in x_ loop
      sql_upd := a.upd_solot;
      sql_del := a.del_solot;
    
      if (sql_upd is not null) then
        execute immediate sql_upd;
        commit;
      end if;
      if (sql_del is not null) then
        execute immediate sql_del;
        commit;
      end if;
    end loop;
  
  exception
    when others then
      DBMS_OUTPUT.PUT_LINE('El error es:' || sqlerrm);
    
  end;
  --------------------------------------------------------------------------------
  procedure INVOCA_SP(LD_FECHA date) is
  
  begin
    OPERACION.PROCESOS_INTRAWAY.ASIGNA_IDVENTA(sysdate);
    OPERACION.PROCESOS_INTRAWAY.ALINEA_SUSP_REC_DUP(sysdate);
    OPERACION.PROCESOS_INTRAWAY.ACT_PROCESOS_BAJA(sysdate);
    OPERACION.PROCESOS_INTRAWAY.ACTUALIZA_HUB(sysdate);
    OPERACION.PROCESOS_INTRAWAY.REENVIO_ERROR(sysdate);
    OPERACION.PROCESOS_INTRAWAY.ACTUALIZA_EST_SOT(sysdate);
    OPERACION.PROCESOS_INTRAWAY.ACTUALIZA_SOT(sysdate);
    OPERACION.PROCESOS_INTRAWAY.ACTUALIZA_TRSMAMBAF(sysdate);
    OPERACION.PROCESOS_INTRAWAY.ACTUALIZA_TAREAWFCPY(sysdate);
    OPERACION.PROCESOS_INTRAWAY.ACTUALIZA_TRANSACCIONES(sysdate);
  
  end;
  --------------------------------------------------------------------------------
end;
/
