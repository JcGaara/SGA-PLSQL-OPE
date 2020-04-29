CREATE OR REPLACE PROCEDURE OPERACION.P_GEN_SOLOT_TRASLADO_F(a_codsolot  in number,
                                                             a_sotbajtrs out operacion.solot.codsolot%TYPE) is

  /************************************************************
  NOMBRE:     P_GEN_SOLOT_TRASLADO
  PROPOSITO:  Genera las SOT de traslado en base a una SOT
  PROGRAMADO EN JOB:  NO

  REVISIONES:
  Version   Fecha           Autor               Descripcisn
  --------- ----------      ---------------     ------------------------
  1.0       24/11/2016      Jose Varillas          Alertas Transfer Billing
  2.0       22/12/2016      Servicio Fallas-HITSS  SD1044806
  3.0       17/02/2017      Servicio Fallas-HITSS  INC000000648417
  4.0	    24/01/2019	    Luis Flores            PROY-32581-Postventa LTE
  5.0       13/02/2019      Abel Ojeda             PROY-32581-Postventa HFC
  ***********************************************************/

  Cursor cur_pto is
    select distinct codinssrv, codinssrv_tra, pid_old
      from solotpto pto, solot sot
     where pto.codsolot = a_codsolot
       and pto.codsolot = sot.codsolot
       and pto.codinssrv_tra is not NULL;
 --INI INC 0000000648417
    Cursor cur_pto_sisact is
    select distinct codinssrv, codinssrv_tra, pid_old
      from solotpto pto, solot sot
     where pto.codsolot = a_codsolot
       and pto.codsolot = sot.codsolot
       and pto.codinssrv_tra is not NULL;
--FIN INC 0000000648417
  r_solot     solot%rowtype;
  r_int_solot int_solot%rowtype;
  l_proceso   number;
  l_cont      number;
  l_obs       int_solot.observacion%type;
  l_num       inssrv.numero%type;
 --INI INC 0000000648417
   l_sisact    number;
   l_codigon   number;
--FIN INC 0000000648417
   ln_tiptra_des             number; --4.0
 --Ini 5.0
   ls_numslc           varchar2(10);
   tipo_alta_trs_ext   constant varchar2(1) := '2';
   ls_numslc_ori       varchar2(10);
   codsolot_old        operacion.solot.codsolot%type;
   ln_count_pid        number;

   Cursor cur_pto_old(codsolot_old number) is
     select distinct tys.tipsrv, ins.codinssrv
     from operacion.solotpto pto  
     inner join insprd ins on (pto.codinssrv = ins.codinssrv and ins.flgprinc = 1)
     inner join tystabsrv tys on (ins.codsrv = tys.codsrv)
     where pto.codsolot = codsolot_old;
   
   Cursor cur_pto_upd(codsolot_upd number) is
     select distinct tys.tipsrv, ins.codinssrv
     from operacion.solotpto pto  
     inner join insprd ins on (pto.codinssrv = ins.codinssrv and ins.flgprinc = 1)
     inner join tystabsrv tys on (ins.codsrv = tys.codsrv)
     where pto.codsolot = codsolot_upd;

   Cursor cur_pid_old(codsolot_old number) is 
     select distinct tys.tipsrv, ins.codinssrv, pto.pid
     from operacion.solotpto pto  
     inner join insprd ins on (pto.codinssrv = ins.codinssrv and ins.flgprinc = 1)
     inner join tystabsrv tys on (ins.codsrv = tys.codsrv)
     where pto.codsolot = codsolot_old
     order by pto.pid asc;

   Cursor cur_upd_pid_old(codsolot_upd number, codinssrv_tra number) is 
     select distinct tys.tipsrv, ins.codinssrv, pto.pid
     from operacion.solotpto pto  
     inner join insprd ins on (pto.codinssrv = ins.codinssrv and ins.flgprinc = 1)
     inner join tystabsrv tys on (ins.codsrv = tys.codsrv)
     where pto.codsolot = codsolot_upd and pto.codinssrv_tra = codinssrv_tra 
     and pto.pid_old is null;
   --Fin 5.0
begin

  --INI INC 0000000648417
  --   select count(*) into l_cont from solotpto where codsolot = a_codsolot
  --   and codinssrv_tra is not null;
  --Ini 4.0
  begin
    select nvl(codigon, 0)
      into l_codigon
      from opedd
     where tipopedd =
           (select tipopedd from tipopedd where abrev = 'TIPTRA_BAJA_SUST')
       and codigon_aux = 1;
  exception
    when others then
      l_codigon := null;
  end;
  --Fin 4.0
  l_sisact := PQ_SGA_IW.f_val_tipo_serv_sot(a_codsolot);
  --FIN INC 0000000648417
  select count(*)
    into l_cont
    from solotpto
   where codsolot = a_codsolot
     and codinssrv_tra is not null;
  
  --Ini 5.0
  if l_cont = 0 then
     begin
       select numslc
       into ls_numslc
       from operacion.solot
       where codsolot = a_codsolot;
     exception        
       when others then
         ls_numslc := null;
     end;
     begin
       select prorv_numslc_ori
       into ls_numslc_ori
       from operacion.sgat_postv_proyecto_origen
       where prorv_numslc_new = ls_numslc and prorv_tpo_altas = tipo_alta_trs_ext;
     exception        
       when others then
         ls_numslc_ori := null;
     end;
      
     if ls_numslc_ori is not null then
       begin
         select codsolot 
         into codsolot_old
         from operacion.solot
         where numslc = ls_numslc_ori and estsol in (12,29);
       exception
         when others then
           codsolot_old := 0;
       end;

       --Actualizando los codinssrv_tra
       for r_pto_upd in cur_pto_old(codsolot_old) loop        
           for r_pto_upd_new in cur_pto_upd(a_codsolot) loop
             if r_pto_upd.tipsrv = r_pto_upd_new.tipsrv then
               update operacion.solotpto
               set codinssrv_tra = r_pto_upd.codinssrv
               where codsolot = a_codsolot and codinssrv = r_pto_upd_new.codinssrv;                              
             end if;
           end loop;
       end loop;

       --Actualizando los PID_OLD
       for r_pid_old in cur_pid_old(codsolot_old) loop
         for r_upd_pid in cur_upd_pid_old(a_codsolot, r_pid_old.codinssrv ) loop
           
           ln_count_pid := 0;
           select count(1)
           into ln_count_pid
           from operacion.solotpto
           where codsolot = a_codsolot 
           and codinssrv_tra = r_pid_old.codinssrv
           and pid_old = r_pid_old.pid
           and pid <> r_upd_pid.pid;
           
           if ln_count_pid = 0 then
             update operacion.solotpto
             set pid_old = r_pid_old.pid 
             where codsolot = a_codsolot 
             and codinssrv_tra = r_pid_old.codinssrv
             and pid = r_upd_pid.pid
             and pid_old is null;
           end if;
           
         end loop;
       end loop;
       
       --Limpiando data
       update operacion.solotpto
       set codinssrv_tra = null
       where codsolot = a_codsolot and pid_old is null;
       
     end if;      
  end if;  
  
  select count(*)
  into l_cont
  from solotpto
  where codsolot = a_codsolot
  and codinssrv_tra is not null;
  --Fin 5.0

  if l_cont > 0 then
    select * into r_solot from solot where codsolot = a_codsolot;

    -- Se filtra solo los traslados externos por tipo de trabajo
    select count(*)
      into l_cont
      from tipopedd tp, opedd od
     where TP.ABREV = 'TRASLADO_EXTERNO'
       and TP.TIPOPEDD = od.TIPOPEDD
       and od.codigoN = r_solot.tiptra;

    if l_cont > 0 then  
      ln_tiptra_des := operacion.pq_sga_janus.f_get_constante_conf('TIPTRA_DESC_TE');
 --INI INC 0000000648417
    if l_sisact=3 or l_sisact=5 then

      l_proceso := pq_int_solot.f_get_id_proceso;
      r_int_solot.proceso := l_proceso;--LO HABIA QUITADO SEGUN LO QUE ME INDICO JOSE
       r_int_solot.codcli  := r_solot.codcli;
       r_int_solot.estsol  := 11;
      r_int_solot.numslc  := r_solot.numslc;
      r_int_solot.tipsrv := r_solot.tipsrv;
      r_int_solot.feccom := sysdate + 7;

        if l_codigon <> 0 then
           r_int_solot.tiptra :=l_codigon;
        else
           r_int_solot.tiptra  := ln_tiptra_des;
        end if;

       for r_pto_sisact in cur_pto_sisact loop
        begin
          select numero
            into l_num
            from inssrv
           where codinssrv = r_pto_sisact.codinssrv;
          l_obs := 'SOT generada por la activacion de ' || l_num;
          l_obs := l_obs || chr(13) || ' Proyecto ' || r_solot.numslc;
          l_obs := l_obs || ', SOT ' || r_solot.codsolot;

          update numtel
             set codinssrv = r_pto_sisact.codinssrv, estnumtel = 2
           where numero = l_num;

           exception
           when others then
            l_obs := null;
        end;

        r_int_solot.observacion := l_obs;
        r_int_solot.codinssrv   := r_pto_sisact.codinssrv_tra;
        r_int_solot.pid         := r_pto_sisact.pid_old;
        pq_int_solot.p_insert_int_solot(r_int_solot);
      end loop;

    else
--FIN INC 0000000648417
      l_proceso := pq_int_solot.f_get_id_proceso;

      r_int_solot.proceso := l_proceso;
      r_int_solot.codcli  := r_solot.codcli;
      r_int_solot.tiptra  := ln_tiptra_des;
      r_int_solot.estsol  := 11;
      r_int_solot.numslc  := r_solot.numslc;
      r_int_solot.tipsrv := r_solot.tipsrv;
      r_int_solot.feccom := sysdate + 7;

      for r_pto in cur_pto loop
        begin
          select numero
            into l_num
            from inssrv
           where codinssrv = r_pto.codinssrv;
          l_obs := 'SOT generada por la activacion de ' || l_num;
          l_obs := l_obs || chr(13) || '  Proyecto ' || r_solot.numslc;
          l_obs := l_obs || ', SOT ' || r_solot.codsolot;

          update numtel
             set codinssrv = r_pto.codinssrv, estnumtel = 2
           where numero = l_num;

        exception
          when others then
            l_obs := null;
        end;

        r_int_solot.observacion := l_obs;
        r_int_solot.codinssrv   := r_pto.codinssrv_tra;
        r_int_solot.pid         := r_pto.pid_old;

        pq_int_solot.p_insert_int_solot(r_int_solot);
      end loop;
       --INI INC 0000000648417
      end if;
       --FIN INC 0000000648417
      pq_int_solot.p_exe_proceso(l_proceso);
      -- Cambio CC
      update solot
         set areasol = r_solot.areasol, codusu = r_solot.codusu
       where codsolot in
             (select distinct codsolot from int_solot where proceso = l_proceso);

      select codsolot
        into a_sotbajtrs
        from int_solot
       where proceso = l_proceso
         and idseq = (select max(idseq) from int_solot where proceso = l_proceso); --2.0

    end if;
    --INI INC 0000000648417
     if l_sisact=3 or l_sisact=5 then
        update trssolot t
             set t.flgbil = 2, t.esttrs = 2
           where t.codsolot = a_sotbajtrs;
       end if;
    --FIN INC 0000000648417
    -- fin de traslados externos
  end if;

end;
/
