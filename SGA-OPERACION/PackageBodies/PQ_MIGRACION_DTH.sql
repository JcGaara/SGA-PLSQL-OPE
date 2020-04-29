CREATE OR REPLACE PACKAGE BODY OPERACION.pq_migracion_dth is

 /*procedure p_migra_reginsdth is

 cursor cur_dth is
  select a.*, b.estado,
  decode(a.recarga_virtual,'SI',1,'NO',0) flg_recarga,
  b.sersut,b.numsut,b.tipdocfac
  from operacion.tmp_dth a, reginsdth b
  where a.numregistro = b.numregistro;

  lc_estado ope_srv_recarga_cab.estado%type;
  ln_sot_baja solot.codsolot%type;
  ln_estsol solot.estsol%type;
  ln_tipestsol estsol.tipestsol%type;
  ld_fecinivig ope_srv_recarga_cab.fecinivig%type;
  ld_fecfinvig ope_srv_recarga_cab.fecfinvig%type;
  ld_fecalerta ope_srv_recarga_cab.fecalerta%type;
  ld_feccorte ope_srv_recarga_cab.feccorte%type;
  ln_est_instancia number(2);
  ln_estinssrv estinssrv.estinssrv%type;
  ln_estinsprd estinsprd.estinsprd%type;
  ln_idtrans number(10);
  lc_mensaje varchar2(1000);
  ln_num number;
  error exception;
  lc_codsrv tystabsrv.codsrv%type;
  lc_tipsrv tystipsrv.tipsrv%type;
 begin
 delete from operacion.tmp_dth;

 insert into dual
 select * 
 from dual@bgsgacfg.world a;
---  from dual@bgsgacfg.world a
  --where
  \*a.numregistro in (select numregistro from operacion.TMP_MIGRACION_DTH where
    tipo = 1 and procesado = 2) and*\
  \*a.numregistro not in (select numregistro from ope_srv_recarga_cab) and*\
  \*a.fecregistro >= to_date('01/01/10','dd/mm/yy') and*\
   --a.considerar = 1;

  commit;

  for reg_dth in cur_dth loop
    begin
      --validaciones de data
      select count(1) into ln_num
      from vtatabcli where codcli = reg_dth.codcli;
      if ln_num = 0 then
        lc_mensaje := 'No se encontró cliente';
        raise error;
      end if;

      select count(1) into ln_num
      from paquete_venta where idpaq = reg_dth.idpaq;
      if ln_num = 0 then
        lc_mensaje := 'No se encontró paquete';
        raise error;
      end if;

      select count(1) into ln_num
      from inssrv where codinssrv = reg_dth.codinssrv;
      if ln_num = 0 then
        lc_mensaje := 'No se encontró instancia de servicio';
        raise error;
      end if;

      select count(1) into ln_num
      from insprd where pid = reg_dth.pid;
      if ln_num = 0 then
        lc_mensaje := 'No se encontró instancia de producto';
        raise error;
      end if;

      if reg_dth.codsolot is null then
        lc_mensaje := 'No se encontró SOT de instalacion';
        raise error;
      end if;
      --
      select codsrv,tipsrv into lc_codsrv,lc_tipsrv
      from inssrv where codinssrv = reg_dth.codinssrv;

      select max(a.codsolot) into ln_sot_baja
      from solot a,solotpto b, inssrv c,tiptrabajo d where
      a.codsolot = b.codsolot
      and b.codinssrv = c.codinssrv
      and a.tiptra = d.tiptra
      and d.tiptrs = 5
      and b.codinssrv = reg_dth.codinssrv;

      if reg_dth.estado_final is not null then
        if reg_dth.estado_final = 1 then
          lc_estado := '02';--activo
        elsif reg_dth.estado_final = 2 then
          lc_estado := '03';--suspendido
        elsif reg_dth.estado_final = 3 then
          lc_estado := '04';--cancelado
        elsif reg_dth.estado_final = 4 then
          lc_estado := '01';--generado
        end if;
      else
        lc_estado := null;
      end if;

      --sot de baja
      if ln_sot_baja is not null then
        select a.estsol, b.tipestsol into ln_estsol,ln_tipestsol
        from solot a,estsol b where a.codsolot = ln_sot_baja
        and a.estsol = b.estsol;

        if ln_tipestsol = 6 and ln_estsol <> 29 then --En ejecucion y no en "atendida"
          select nvl(max(idtrans),0) + 1 into ln_idtrans
          from operacion.TMP_MIGRACION_DTH;
          insert into operacion.TMP_MIGRACION_DTH(idtrans,numregistro,codsolot,tipo)
          values(ln_idtrans,reg_dth.numregistro,ln_sot_baja,3);
        end if;
      end if;
      --
      --sot de instalacion
      select tipestsol into ln_tipestsol
      from estsol a, solot b
      where a.estsol = b.estsol
      and b.codsolot = reg_dth.codsolot;
      --
      if ln_tipestsol in (6,7) then -- rechazada, en ejecucion
        select nvl(max(idtrans),0) + 1 into ln_idtrans
          from operacion.TMP_MIGRACION_DTH;
        insert into operacion.TMP_MIGRACION_DTH(idtrans,numregistro,codsolot,tipo)
        values(ln_idtrans,reg_dth.numregistro,reg_dth.codsolot,2);
      end if;

      --validacion de estado
      if lc_estado is null then
        lc_mensaje := 'Estado en nulo';
        raise error;
      end if;

      ld_fecfinvig := reg_dth.fechamax;
      ld_fecinivig := ld_fecfinvig - reg_dth.diamax;
      ld_fecalerta := ld_fecfinvig - 3;
      ld_feccorte := ld_fecfinvig + 1;

      --validacion de fecha
      if ld_fecfinvig is null and lc_estado in ('02','03') then
        lc_mensaje := 'Fecha fin en nulo';
        raise error;
      end if;

      select decode(lc_estado,'02',1,'03',2,'04',3,'01',4,null) into ln_est_instancia
      from dual;

      select estinssrv into ln_estinssrv from inssrv
      where codinssrv = reg_dth.codinssrv;

      if ln_estinssrv <> ln_est_instancia then
        --if reg_dth.flg_recarga = 1 then
          update inssrv
          set estinssrv = ln_est_instancia
          where codinssrv = reg_dth.codinssrv;--comentado para pruebas

          select nvl(max(idtrans),0) + 1 into ln_idtrans
            from operacion.TMP_MIGRACION_DTH;
          insert into operacion.TMP_MIGRACION_DTH(idtrans,numregistro,codinssrv,tipo,procesado,
                      estinssrv_ant,estinssrv_new)
          values(ln_idtrans,reg_dth.numregistro,reg_dth.codinssrv,4,1,ln_estinssrv,ln_est_instancia);
        \*else
          lc_mensaje := 'La instancia de servicio es facturable';
          select nvl(max(idtrans),0) + 1 into ln_idtrans
            from operacion.TMP_MIGRACION_DTH;
          insert into operacion.TMP_MIGRACION_DTH(idtrans,numregistro,codinssrv,tipo,procesado,
                      estinssrv_ant,estinssrv_new,mensaje)
          values(ln_idtrans,reg_dth.numregistro,reg_dth.codinssrv,4,2,ln_estinssrv,ln_est_instancia,lc_mensaje);
        end if; *\
      end if;

      select estinsprd into ln_estinsprd from insprd
      where pid = reg_dth.pid;

      if ln_estinsprd <> ln_est_instancia then
        --if reg_dth.flg_recarga = 1 then
          update insprd
          set estinsprd = ln_est_instancia
          where pid = reg_dth.pid; --comentado para pruebas

          select nvl(max(idtrans),0) + 1 into ln_idtrans
            from operacion.TMP_MIGRACION_DTH;
          insert into operacion.TMP_MIGRACION_DTH(idtrans,numregistro,pid,tipo,procesado,
                      estinsprd_ant,estinsprd_new)
          values(ln_idtrans,reg_dth.numregistro,reg_dth.pid,5,1,ln_estinsprd,ln_est_instancia);
        \*else
          lc_mensaje := 'La instancia de producto es facturable';
          select nvl(max(idtrans),0) + 1 into ln_idtrans
            from operacion.TMP_MIGRACION_DTH;
          insert into operacion.TMP_MIGRACION_DTH(idtrans,numregistro,codinssrv,tipo,procesado,
                      estinssrv_ant,estinssrv_new,mensaje)
          values(ln_idtrans,reg_dth.numregistro,reg_dth.codinssrv,5,2,ln_estinssrv,ln_est_instancia,lc_mensaje);
        end if;*\
      end if;

      insert into ope_srv_recarga_cab(
         numregistro,
         codigo_recarga,
         fecinivig,
         fecfinvig,
         fecalerta,
         feccorte,
         flg_recarga,
         codcli,
         numslc,
         codsolot,
         idpaq,
         estado,
         tipbqd,--nuevo
         sersut,--nuevo
         numsut,--nuevo
         tipdocfac,--nuevo
         codusu,
         fecusu)
      values(
         reg_dth.numregistro,
         reg_dth.codigo_recarga,
         ld_fecinivig,
         ld_fecfinvig,
         ld_fecalerta,
         ld_feccorte,
         reg_dth.flg_recarga,
         reg_dth.codcli,
         reg_dth.numslc,
         reg_dth.codsolot,
         reg_dth.idpaq,
         lc_estado,
         4,
         reg_dth.sersut,
         reg_dth.numsut,
         reg_dth.tipdocfac,
         reg_dth.usureg,
         reg_dth.fecregistro);

      insert into ope_srv_recarga_det(
         numregistro,
         codinssrv,
         tipsrv,
         codsrv,
         codusu,
         fecusu,
         fecact,
         fecbaja,
         pid,
         estado)
      values(
         reg_dth.numregistro,
         reg_dth.codinssrv,
         lc_tipsrv,
         lc_codsrv,
         reg_dth.usureg,
         reg_dth.fecregistro,
         reg_dth.fecactconax,
         reg_dth.fecbajaconax,
         reg_dth.pid,
         reg_dth.estado);--comentado para pruebas

      commit;
    exception
      when error then
        rollback;
         select nvl(max(idtrans),0) + 1 into ln_idtrans
          from operacion.TMP_MIGRACION_DTH;
         insert into operacion.TMP_MIGRACION_DTH(idtrans,numregistro,tipo,procesado,mensaje)
         values(ln_idtrans,reg_dth.numregistro,1,2,lc_mensaje);
         commit;
      when others then
         rollback;
         lc_mensaje := sqlerrm;
         select nvl(max(idtrans),0) + 1 into ln_idtrans
          from operacion.TMP_MIGRACION_DTH;
         insert into operacion.TMP_MIGRACION_DTH(idtrans,numregistro,tipo,procesado,mensaje)
         values(ln_idtrans,reg_dth.numregistro,1,2,lc_mensaje);
         commit;
    end;
  end loop;
 end;*/

 procedure p_reasigna_wf(an_tipo number) is
   cursor cur_sot_dth is
     select * from operacion.TMP_MIGRACION_DTH a
     where procesado = 0
     and tipo = an_tipo;

   ln_idwf_ant wf.idwf%type;
   ln_idwf_new wf.idwf%type;
   ln_wfdef wfdef.wfdef%type;
   --ln_equipos_sot number;
   ln_tipestsol estsol.tipestsol%type;
   ls_mensaje operacion.TMP_MIGRACION_DTH.mensaje%type;
 begin
   for reg_sot_dth in cur_sot_dth loop
     begin
       select idwf into ln_idwf_ant from wf
       where codsolot = reg_sot_dth.codsolot
       and estwf <> 5;
       PQ_WF.P_CANCELAR_WF(ln_idwf_ant);
       if reg_sot_dth.tipo = 2 then --alta
         ln_wfdef := WFINST;
       else --baja
         ln_wfdef := WFBAJA;
       end if;

       --creacion de WF
       PQ_WF.P_CREAR_WF(ln_wfdef,ln_idwf_new);
       --asignacion de SOT a wf
       update wf
       set codsolot = reg_sot_dth.codsolot
       where idwf = ln_idwf_new;

       --activacion de WF
       PQ_WF.P_ACTIVAR_WF(ln_idwf_new);

       if reg_sot_dth.tipo = 2 then --alta

         select a.tipestsol into ln_tipestsol
         from estsol a, solot b
         where a.estsol = b.estsol
         and b.codsolot = reg_sot_dth.codsolot;

         if ln_tipestsol = 7 then --rechazada
            PQ_WF.P_SUSPENDER_WF(ln_idwf_new);
         end if;
       end if;

       update operacion.TMP_MIGRACION_DTH
       set procesado = 1,
       idwf_ant = ln_idwf_ant,
       idwf_new = ln_idwf_new
       where idtrans = reg_sot_dth.idtrans;
       commit;--graba
     exception
       when others then
         ls_mensaje := sqlerrm;
         rollback;--error
         update operacion.TMP_MIGRACION_DTH
         set procesado = 2,--error
         mensaje = ls_mensaje
         where idtrans = reg_sot_dth.idtrans;
         commit;--graba
     end;
   end loop;
 end;

end pq_migracion_dth;
/


