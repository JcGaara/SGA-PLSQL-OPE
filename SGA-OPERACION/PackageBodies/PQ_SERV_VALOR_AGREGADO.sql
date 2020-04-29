CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_SERV_VALOR_AGREGADO IS

/************************************************************
NOMBRE:     P_GENERA_REGINSRPROF24H
PROPOSITO:  Manejo de los procedimientos de los servicios de valor agregado.
PROGRAMADO EN JOB:  NO

REVISIONES:
Version      Fecha        Autor           Descripcisn
---------  ----------  ---------------  ------------------------
1.0        12/08/2009  Hector Huaman 99917 se rehace el paquete
2.0        17/04/2015  César Quispe      Hector Huaman     REQ-165004 Creación de Interface de compra de servicios SVA
3.0        06/07/2015  Edwin Vasquez     Hector Huaman     INC-IDEA-12991-Creacion Interface de compra servicios SVA a través de la Fija
4.0        10/07/2015  Michael Boza      Hector Huaman     INC-IDEA-12991-Creacion Interface de compra servicios SVA a través de la Fija
***********************************************************/

  FUNCTION f_encode(parametro VARCHAR2) RETURN VARCHAR2 AS
    LANGUAGE JAVA NAME 'URLEncode.f_encode(java.lang.String) return java.lang.String';

  FUNCTION f_linkea(link VARCHAR2) RETURN VARCHAR2 AS
    LANGUAGE JAVA NAME 'URLEncode.f_linkea(java.lang.String) return java.lang.String';

procedure p_genera_reginsprof24h
IS
------------------------------------
--VARIABLES PARA EL ENVIO DE CORREOS
c_nom_proceso LOG_REP_PROCESO_ERROR.NOM_PROCESO%TYPE:='OPERACION.P_GENERA_REGINSRPROF24H';
c_id_proceso LOG_REP_PROCESO_ERROR.ID_PROCESO%TYPE:='3303';
c_sec_grabacion float:= fn_rep_registra_error_ini(c_nom_proceso,c_id_proceso );

  CURSOR c_opedth IS
    select r.num_control,
           r.codsol,
           r.idpaq,
           r.codcli,
           r.pid,
           r.codinssrv,
           r.codsuc,
           p.idsolucion,
           s.tipsrv,
           a.dsctipsrv,
           t.idcampanha,
           r.fecusu,
           r.tipdoccon,
           u.nrocontrato
      from reginsprof24h r,
           paquete_venta       p,
           soluciones          s,
           solucionxcampanha   t,
           tystipsrv           a,
           usuariomitelmex u
     where r.estprof24h = '01'
       and r.idpaq = p.idpaq
       --and r.num_control='0000000517'
       and p.idsolucion = s.idsolucion
       and s.idsolucion = t.idsolucion
       and a.tipsrv = s.tipsrv
       and r.numslc is null
       and r.correo=u.correo
       order by r.num_control;

  l_numslc        varchar2(50);
  l_codcnt        varchar2(10);
  l_countcodsolot number;
  l_codsolot      number;
  ll_cantidad     number;
  ll_pid          number(10);
  ll_codinssrv    number(10);
  ll_codsol       varchar2(10);
  ls_valida       varchar2(400);
  b               varchar2(400);
  l_contcodcnt number;
  v_codcnt vtatabcntcli.codcnt%type;
begin

  FOR reg1 IN c_opedth LOOP
    BEGIN

    l_contcodcnt:=0;

    select count(ve.codcnt) into l_contcodcnt from vtatabcntcli ve where ve.estado=1 and ve.codcli = reg1.codcli;

    if l_contcodcnt=0 then

          insert into vtatabcntcli
                      select v_codcnt codcnt,
                             v.codubi,
                             v.tipdide,
                             v.codcli,
                             '08' tipcnt,
                             v.nomcli nomcnt,
                             v.ntdide nidcnt,
                             v.dircli dircnt,
                             'PROPIETARIO' carcnt,
                             user codusu,
                             sysdate fecusu,
                             2 decisor,
                             3 carcli,
                             null codtipdes,
                             51 codarea,
                             0 codjerar,
                             1 estado,
                             null idvantive,
                             null idestatus,
                             null password,
                             v.tipviap,
                             v.nomvia,
                             v.numvia,
                             v.nomurb,
                             v.interior,
                             null codpos,
                             null fecultact,
                             10 idtipact,
                             null fecnac,
                             null genero,
                             v.codpai,
                             null idestadocivil,
                             null numerohijos,
                             v.apepatcli apepat,
                             v.apematcli apemat,
                             v.nomclires nombre,
                             null observacion,
                             0 flg_legal,
                             '9999' tipsrv
                        from vtatabcli v
                       where v.codcli =reg1.codcli;
    end if;

      select vt.codcnt
        into l_codcnt
        from vtatabcntcli vt
       where vt.estado = 1
         and vt.codcli = reg1.codcli
         and rownum = 1;
      --Verifica Si tiene Cabecera
      if reg1.codsol is null then
        ll_codsol := '00000391'; --Sin Definir
        update reginsprof24h
           set codsol = ll_codsol
         where num_control = reg1.num_control;
      else
        ll_codsol := reg1.codsol;
      end if;

      --Cabecera del proyecto
      PQ_INT_TPINT_VTA.P_CREAR_CABECERA(ll_codsol,
                                        10,
                                        sysdate,
                                        reg1.tipsrv,
                                        0,
                                        null,
                                        reg1.codcli,
                                        reg1.dsctipsrv,
                                        reg1.idsolucion,
                                        reg1.idcampanha,
                                        reg1.dsctipsrv,
                                        l_numslc);
    COMMIT;
      --Detalle del proyecto
      PQ_INT_TPINT_VTA.P_GENERA_PTOENL(l_numslc,
                                       reg1.codsuc,
                                       reg1.idpaq,
                                       10,
                                       reg1.tipsrv,
                                       l_codcnt);
      update reginsprof24h
         set numslc = l_numslc
       where num_control = reg1.num_control;
      commit;
      insert into VTATABPRECON
        (NUMSLC,
         CODCLI,
         NRODOC,
         TIPDOC,
         FECACE,
         FECREC,
         CODMODELO,
         FECAPLCOM,
         CODSUCFAC,
         CODPAI,
         FLAG_FACTXSEGUNDO,
         FLAG_FACTXMINUTO,
         CODMOTIVO)
      VALUES
        (l_numslc,
         reg1.codcli,
         reg1.nrocontrato,
         reg1.tipdoccon,
         sysdate,
         sysdate,
         11,
         sysdate,
         reg1.codsuc,
         51,
         0,
         1,
         9); -- Definir Codmotivo de la tabla motivo_aprobacion
      --   commit;

      pq_proyecto.P_VALIDAR_TIPOSOLUCION(l_numslc);

      ---- Genera Oferta comercial
      --sales.pq_oferta_comercial.P_GENERA_OC_AUTOMATICA(l_numslc);


      ls_valida := pq_valida_proyecto.f_valida_checkproy(l_numslc);

      ----Genera Estudio de Factibilidad y lo aprueba

      if ls_valida = 'OK' then
        commit;

        if (reg1.num_control is not null) then
          --Aprueba OC, Genera contrato y Genera SOT.
          b:=pq_valida_proyecto.f_proyecto_preventa(l_numslc);
/*          pq_oferta_comercial.P_GENERA_OC_AUTOMATICA(l_numslc);
          pq_contratos_automatico.P_GENERA_CONTRATO_AUTOMATICO(l_numslc);*/
          commit;

          select count(*)
            into l_countcodsolot
            from solot
           where numslc = l_numslc;

          if l_countcodsolot > 0 then

            SELECT codsolot
              INTO l_codsolot
              FROM solot
             WHERE numslc = l_numslc;

            SELECT count(solotpto.codinssrv)
              INTO ll_cantidad
              FROM solotpto, tystabsrv, insprd
             WHERE solotpto.codsrvnue = tystabsrv.codsrv
               AND solotpto.pid = insprd.pid(+)
               AND insprd.flgprinc = 1
               AND codsolot = l_codsolot;

            if ll_cantidad = 1 then
              SELECT solotpto.codinssrv, solotpto.pid
                INTO ll_codinssrv, ll_pid
                FROM solotpto, tystabsrv, insprd
               WHERE solotpto.codsrvnue = tystabsrv.codsrv
                 AND solotpto.pid = insprd.pid(+)
                 AND insprd.flgprinc = 1
                 AND codsolot = l_codsolot;

              UPDATE reginsprof24h
                 SET pid       = ll_pid,
                     codinssrv = ll_codinssrv,
                     codsolot  = l_codsolot
               WHERE num_control = reg1.num_control;

             update reginsprof24h set estprof24h = '02' where num_control = reg1.num_control;
            end if;
          end if;
        end if;
        --- Aprueba Oferta Comercial , Genera Contrato, Genera SOt
        update solot set areasol = 102 where numslc = l_numslc;
        commit;

      end if;
    END;

  END LOOP;

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
          sqlerrm , '1',c_sec_grabacion );
      raise_application_error(-20000,sqlerrm);
end;

procedure p_prof24h_baja(a_idtareawf in number,
                          a_idwf      in number,
                          a_tarea     in number,
                          a_tareadef  in number) IS

 v_codsolot   solot.codsolot%type;
 v_correo     varchar2(3000);
 v_password   varchar2(3000);
 v_tipo_plan  varchar2(100);
 v_url        varchar2(3000);
 lr_usutelmex   usuariomitelmex%rowtype;
 l_count        number;
 vnum_control   varchar2(100);
 vtelf          varchar2(50);
 vservicio      NUMBER(2);
 vestinssrv     varchar2(50);
 vap_paterno    varchar2(3000);
 vap_materno    varchar2(3000);
 vnombre        varchar2(3000);
 vdircli        varchar2(3000);
 vcodpos        varchar2(20);
 vnompvc        varchar2(3000);
 vnomdst        varchar2(3000);
 vlbNivel       varchar2(20);
 vlbGrado       varchar2(20);
 vtfTutor       varchar2(20);
 vtipo          varchar2(20);
 vaccion        varchar2(100);
 link           varchar2(500);
 parametro      varchar2(500);
 pResult        number;
 pError         varchar2(3000);
BEGIN
  -- Capturo el codigo de la solot
  select codsolot into v_codsolot from wf where idwf = a_idwf;

  BEGIN

 pResult :=0;

  select u.correo, u.password, r.tipo_plan
    into v_correo, v_password, v_tipo_plan
    from solot s, usuariomitelmex u, reginsprof24h r
   where s.codsolot = v_codsolot
     and s.codcli = u.codcli
     and r.codcli = u.codcli
     and r.correo = u.correo
     and rownum=1;

  select * into lr_usutelmex
  from usuariomitelmex where  correo=v_correo and password=v_password;

 select count(*) into l_count
 from  reginsprof24h where correo=lr_usutelmex.correo;

  if pResult=0 then
  BEGIN
--Valida Servicio de Internet Infinitum
  select c.nrodoc_contrato into lr_usutelmex.nrocontrato
    from vtatabslcfac  a, insprd  b, tystabsrv  t,
    vtatabpspcli  v, contrato  c
   where a.codcli =lr_usutelmex.codcli
     and v.codcli=a.codcli
     and a.numslc = b.numslc
     and a.tipsrv = '0061'
     and b.codsrv = t.codsrv
     and t.tipsrv = '0006'
     and v.numpsp=c.numpsp
     and c.nrodoc_contrato=lr_usutelmex.nrocontrato
     and rownum=1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        pResult  := -1;
        pError := 'Ud. no cuenta con el servicio Telmex Infinitum';
     END;


  end if;
--Valida Servicio de Internet Infinitum Activo
if pResult=0 then
BEGIN
  select c.nrodoc_contrato into lr_usutelmex.nrocontrato
    from vtatabslcfac  a, insprd  b, tystabsrv  t,
    vtatabpspcli  v,contrato  c
   where a.codcli = lr_usutelmex.codcli
     and v.codcli=a.codcli
     and a.numslc = b.numslc
     and a.tipsrv = '0061'
     and b.codsrv = t.codsrv
     and b.estinsprd = 1
     and t.tipsrv = '0006'
     and v.numpsp=c.numpsp
     and c.nrodoc_contrato=lr_usutelmex.nrocontrato
     and rownum=1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        pResult  := -1;
        pError := 'Su cuenta se encuentra suspendida de manera temporal mientras su servicio Telmex Infinitum se encuentre suspendido';
     END;
  end if;

      IF  pResult=0 THEN
                vservicio  := 1;
                vestinssrv :='B';
       select *  into lr_usutelmex from usuariomitelmex
       where correo=v_correo and password=v_password;


               select vtatabcli.telefono1,
                     vtatabcli.nomcli,
                     vtatabcli.dircli,
                     vtatabcli.codubi,
                     v_ubicaciones.nompvc,
                     v_ubicaciones.nomdst
                into vtelf, vnombre, vdircli, vcodpos, vnompvc, vnomdst
                from vtatabcli , v_ubicaciones
               where vtatabcli.codcli = lr_usutelmex.codcli
                 and vtatabcli.codubi = v_ubicaciones.codubi;

              vnum_control := '1';
              vap_paterno  := '';
              vap_materno  := '';
              vlbNivel     := 'Secundaria';
              vlbGrado     := 'Segundo';
              vtfTutor     := 'tutor';
              vtipo        := '1';
              vaccion      := vestinssrv;

              link      := 'http://www.aula24horas.com/param_pro_peru.cfm?';
              parametro := 'num_control=' || f_encode(vnum_control) || '&';
              parametro := parametro || 'uname=' || f_encode(lr_usutelmex.codcli) || '&';
              parametro := parametro || 'telefono=' || f_encode(vtelf) || '&';
              parametro := parametro || 'servicio=' || f_encode(vservicio) || '&';
              parametro := parametro || 'ap_paterno=' || f_encode(vap_paterno) || '&';
              parametro := parametro || 'ap_materno=' || f_encode(vap_materno) || '&';
              if length(vnombre) > 100 then
                vnombre := substr(vnombre, 1, 100);
              end if;
              parametro := parametro || 'nombres=' || f_encode(vnombre) || '&';
              if length(vdircli) > 150 then
                vdircli := substr(vdircli, 1, 150);
              end if;
              parametro := parametro || 'direccion=' || f_encode(vdircli) || '&';
              parametro := parametro || 'cp=' || f_encode(vcodpos) || '&';
              parametro := parametro || 'estado=' || f_encode(vnompvc) || '&';
              parametro := parametro || 'delegacion=' || f_encode(vnomdst) || '&';
              parametro := parametro || 'folio_prodigy=' || f_encode(lr_usutelmex.nrocontrato) || '&';
              parametro := parametro || 'operacion=' || f_encode(vaccion) || '&';
              parametro := parametro || 'lbNivel=' || f_encode(vlbNivel) || '&';
              parametro := parametro || 'lbGrado=' || f_encode(vlbGrado) || '&';
              parametro := parametro || 'tfTutor=' || f_encode(vtfTutor) || '&';
              parametro := parametro || 'tipo=' || f_encode(vtipo);
              link      := link || parametro;
              v_url       := link;
              pResult   := length(link);
              pError    := f_linkea(link);

      END IF;
  exception
     WHEN OTHERS THEN
        raise_application_error(-20000,'El cliente no esta registrado correctamente en Mi Telmex' );
        ROLLBACK;
  END;
END;
procedure p_baja_srvprofesor24h(a_idtareawf in number, a_idwf in number, a_tarea in number, a_tareadef in number) is
    n_codsolot solot.codsolot%type;
    vregsolot  solot%rowtype;
  begin
    select codsolot into n_codsolot from wf where idwf = a_idwf;

    select *
      into vregsolot
      from solot
     where codsolot = n_codsolot;
    operacion.p_ejecuta_activ_desactiv(n_codsolot, 299, vregsolot.fecusu);
  end;

  --PROCEDIMIENTOS
  /*********************************************************************
   PROCEDIMIENTO: Genera envío de transacción del traslado externo a Claro Video.
   PARAMETROS:
      Entrada:
        - a_idtareawf: --
        - a_idwf: Código identificador de Workflow
        - a_tarea: --
        - a_tareadef: --
  *********************************************************************/
  procedure p_genera_traslado_externo_sva(a_idtareawf in number,
                                          a_idwf      in number,
                                          a_tarea     in number,
                                          a_tareadef  in number) is
    lv_codcli     varchar(8);
    lv_numslc_old varchar(10);
    lv_numslc_new varchar(10);
    ln_codsolot   number(8);
    ln_sid_old    number(10);
    ln_sid_new    number(10);
    ln_resultado  number;
    lv_mensaje    varchar2(2000);
  begin
    ln_resultado := 0;
    lv_mensaje   := 'Exito';

    select distinct s.codsolot, s.codcli, s.numslc, vm.numslc_ori
      into ln_codsolot, lv_codcli, lv_numslc_new, lv_numslc_old
      from wf w, solot s, regvtamentab vm
     where w.idwf = a_idwf
       and w.codsolot = s.codsolot
       and s.tiptra = 412
       and s.numslc = vm.numslc;
    if f_valida_registrado_sva(ln_codsolot) = 0 then
      ln_sid_old := f_obtiene_sidxproyecto_te(lv_numslc_old);
      ln_sid_new := f_obtiene_sidxproyecto_te(lv_numslc_new);
      p_genera_trx_envio_sva(lv_codcli,
                             cv_tipope_trasexterno,
                             cv_criterio_reasigna,
                             lv_numslc_old,
                             lv_numslc_new,
                             ln_codsolot,
                             ln_sid_old,
                             ln_sid_new,
                             ln_resultado,
                             lv_mensaje);
    end if;
  end;
  /*********************************************************************
   PROCEDIMIENTO: Genera envío de transacción de Cambio de Plan a Claro Video.
   PARAMETROS:
      Entrada:
        - a_idtareawf: --
        - a_idwf: Código identificador de Workflow
        - a_tarea: --
        - a_tareadef: --
  *********************************************************************/
  procedure p_genera_cambio_plan_sva(a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number) is
    lv_codcli       varchar(8);
    lv_numslc_old   varchar(10);
    lv_numslc_new   varchar(10);
    ln_codsolot     number(8);
    ln_sid_old      number(10);
    ln_sid_new      number(10);
    ln_cant_srv_old number(8);
    ln_cant_srv_new number(8);
    ln_resultado    number;
    lv_mensaje      varchar2(2000);
  begin
    ln_resultado := 0;
    lv_mensaje   := 'Exito';

    select distinct s.codsolot, s.codcli, s.numslc, vm.numslc_ori
      into ln_codsolot, lv_codcli, lv_numslc_new, lv_numslc_old
      from wf w, solot s, regvtamentab vm
     where w.idwf = a_idwf
       and w.codsolot = s.codsolot
       and s.tiptra = 427
       and s.numslc = vm.numslc;

    select count(distinct codinssrv)
      into ln_cant_srv_old
      from insprd p
     where numslc = lv_numslc_old
       and exists (select 1
              from inssrv
             where codinssrv = p.codinssrv
               and tipsrv <> '0025');

    select count(distinct codinssrv)
      into ln_cant_srv_new
      from insprd p
     where numslc = lv_numslc_new
       and exists (select 1
              from inssrv
             where codinssrv = p.codinssrv
               and tipsrv <> '0025');

    if ln_cant_srv_old > ln_cant_srv_new then
      if f_valida_registrado_sva(ln_codsolot) = 0 then
        ln_sid_old := f_obtiene_sidxproyecto_cp(lv_numslc_old);
        ln_sid_new := f_obtiene_sidxproyecto_cp(lv_numslc_new);
        p_genera_trx_envio_sva(lv_codcli,
                               cv_tipope_cambioplan,
                               cv_criterio_reasigna,
                               lv_numslc_old,
                               lv_numslc_new,
                               ln_codsolot,
                               ln_sid_old,
                               ln_sid_new,
                               ln_resultado,
                               lv_mensaje);
      end if;
    end if;
  end;
  /*********************************************************************
   PROCEDIMIENTO: Genera envío de transacción de baja por cambio de titularidad a Claro Video.
   PARAMETROS:
      Entrada:
        - a_idtareawf: --
        - a_idwf: Código identificador de Workflow
        - a_tarea: --
        - a_tareadef: --
  *********************************************************************/
  procedure p_genera_baja_sva(a_idtareawf in number,
                              a_idwf      in number,
                              a_tarea     in number,
                              a_tareadef  in number) is
    ln_resultado  number;
    lv_numslcxsid varchar2(10);
    lv_mensaje    varchar2(2000);
    cursor cur_sid is
      select s.codsolot,
             s.codcli     cliente,
             s.tiptra     tiptra,
             sp.codinssrv sid_baja
        from wf w, solot s, solotpto sp, inssrv i
       where w.idwf = a_idwf
         and w.codsolot = s.codsolot
         and s.codsolot = sp.codsolot
         and sp.codinssrv is not null
         and sp.pid is null
         and sp.codinssrv = i.codinssrv
         and i.tipsrv <> '0025';
  begin
    ln_resultado := 0;
    lv_mensaje   := 'Exito';

    for reg in cur_sid loop
      if reg.tiptra <> 448 then
        return;
      end if;

      select distinct (numslc)
        into lv_numslcxsid
        from inssrv
       where codinssrv = reg.sid_baja;

      if f_obtiene_sidxproyecto_cp(lv_numslcxsid) = reg.sid_baja then
        p_genera_trx_envio_sva(reg.cliente,
                               cv_tipope_baja,
                               cv_criterio_baja,
                               lv_numslcxsid,-- 4.0
                               null,
                               reg.codsolot,
                               reg.sid_baja,
                               null,
                               ln_resultado,
                               lv_mensaje);
      end if;
    end loop;
  end;
  /*********************************************************************
   PROCEDIMIENTO: Revierte la actualización del SID realizada en Claro Video.
   PARAMETROS:
      Entrada:
        - an_codsolot: Código de solot rechazado.
        - av_numslc: Número de proyecto relacionado a la solot rechazada.
        - an_tiptra: Tipo de trabajo (Cambio de Plan o Traslado Externo)
  *********************************************************************/
  procedure p_revierte_envio_sva(an_codsolot in number) is
    ln_cantidad  number;
    ln_resultado number;
    lv_mensaje   varchar2(2000);
    cursor cur_revertir(an_codsolot in number) is
      select cod_cli_sga,
             tipo_operacion,
             criterio,
             numslc_inicial,
             numslc_final,
             codsolot,
             sid_inicial,
             sid_final
        from operacion.ope_trx_clarovideo_sva
       where codsolot = an_codsolot
         and rownum = 1
       order by idregistro asc;
  begin
    ln_resultado := 0;
    lv_mensaje   := 'Exito';

    select count(*)
      into ln_cantidad
      from operacion.ope_trx_clarovideo_sva
     where codsolot = an_codsolot;

    if ln_cantidad = 1 then

      for reg in cur_revertir(an_codsolot) loop
        p_genera_trx_envio_sva(reg.cod_cli_sga,
                               reg.tipo_operacion,
                               reg.criterio,
                               reg.numslc_inicial,
                               reg.numslc_final,
                               reg.codsolot,
                               reg.sid_final,
                               reg.sid_inicial,
                               ln_resultado,
                               lv_mensaje);
      end loop;
    end if;
  end;
  /*********************************************************************
   PROCEDIMIENTO: Genera flujo de envío de la transaccion a Claro Video.
   PARAMETROS:
      Entrada:
        - ac_codcli: Código de cliente
        - ac_tipo_operacion: Tipo de operación(Baja:BA,Cambio de Plan:CP,Cambio de titularidad:CT)
        - an_sid_inicial: Sid anterior
        - an_sid_final: Sid nuevo
      Salida:
        - an_resultado:  0:OK   1:ERROR   -1:ERROR BD
        - av_mensaje:    Descripción de Resultado
  *********************************************************************/
  procedure p_genera_trx_envio_sva(av_codcli         in varchar2,
                                   av_tipo_operacion in varchar2,
                                   av_criterio       in varchar2,
                                   av_numslc_inicial in varchar2,
                                   av_numslc_final   in varchar2,
                                   an_codsolot       in number,
                                   an_sid_inicial    number,
                                   an_sid_final      number,
                                   an_resultado      out number,
                                   av_mensaje        out varchar2) is
    PRAGMA AUTONOMOUS_TRANSACTION;
    lr_ope_clarovideo_sva operacion.ope_trx_clarovideo_sva%rowtype;
    lv_ipaplicacion       operacion.ope_trx_clarovideo_sva.ipaplicacion%type;
    ln_trx_pendiente      number;
    ln_resultado          number;
    lv_mensaje            varchar2(2000);
  begin
    ln_resultado := 0;
    lv_mensaje   := 'Exito';

    --IP APLICACION
    select SYS_CONTEXT('USERENV', 'IP_ADDRESS', 15)
      into lv_ipaplicacion
      from dual;

    --ASIGNA DATOS DE REGISTRO DE TRANSACCION
    lr_ope_clarovideo_sva.idtransaccion    := null;
    lr_ope_clarovideo_sva.aplicacion       := cv_aplicacion;
    lr_ope_clarovideo_sva.usraplicacion    := cv_usuario;
    lr_ope_clarovideo_sva.ipaplicacion     := lv_ipaplicacion;
    lr_ope_clarovideo_sva.cod_cli_sga      := av_codcli;
    lr_ope_clarovideo_sva.tipo_operacion   := av_tipo_operacion;
    lr_ope_clarovideo_sva.criterio         := av_criterio;
    lr_ope_clarovideo_sva.numslc_inicial   := av_numslc_inicial;
    lr_ope_clarovideo_sva.numslc_final     := av_numslc_final;
    lr_ope_clarovideo_sva.codsolot         := an_codsolot;
    lr_ope_clarovideo_sva.sid_inicial      := an_sid_inicial;
    lr_ope_clarovideo_sva.sid_final        := an_sid_final;
    lr_ope_clarovideo_sva.fecha_envio      := to_char(sysdate, 'dd-mm-yyyy');
    lr_ope_clarovideo_sva.estado           := cn_trx_registrado;
    lr_ope_clarovideo_sva.nro_reintento    := null;
    lr_ope_clarovideo_sva.flag_envio_email := 0;
    --Ini 4.0
    lr_ope_clarovideo_sva.resultado        := ln_resultado;
    lr_ope_clarovideo_sva.mensaje          := lv_mensaje;
    --Fin 4.0

    --OBTIENE CODIGO REGISTRO DE TRANSACCION
    lr_ope_clarovideo_sva.idregistro := f_obtiene_idregistro;
    if lr_ope_clarovideo_sva.idregistro is null then
      ln_resultado := 1;
      lv_mensaje   := 'Error al obtener codigo de registro de transaccion.';
    end if;
    --REGISTRA TRANSACCION DE ENVIO A CLARO VIDEO
    p_registra_trx_envio_sva(lr_ope_clarovideo_sva,
                             ln_resultado,
                             lv_mensaje);
    if ln_resultado <> 0 then
      goto salto;
      rollback;
    else
      commit;
    end if;
    ln_trx_pendiente := f_valida_trx_pendiente(lr_ope_clarovideo_sva.codsolot,
                                               lr_ope_clarovideo_sva.idregistro);
    if ln_trx_pendiente = 0 then
      --EJECUTA WEBSERVICE DE CLARO VIDEO
      p_ejecuta_trx_ws_sva(lr_ope_clarovideo_sva, ln_resultado, lv_mensaje);
      if ln_resultado <> 0 then
        lr_ope_clarovideo_sva.resultado := ln_resultado;
        lr_ope_clarovideo_sva.mensaje   := lv_mensaje;
      end if;
      --REGISTRA TRANSACCION DE RESPUESTA DE CLARO VIDEO
      p_registra_trx_resp_sva(lr_ope_clarovideo_sva,
                              ln_resultado,
                              lv_mensaje);
      commit;
    end if;
    <<salto>>
    an_resultado := ln_resultado;
    av_mensaje   := lv_mensaje;
  exception
    when others then
      an_resultado := -1;
      av_mensaje   := 'Error BD: ' || sqlcode || ' ' || sqlerrm;
      rollback;
  end;
  /*********************************************************************
   PROCEDIMIENTO: Registro de transacciones de envio a Claro Video.
   PARAMETROS:
      Entrada:
        - ar_ope_clarovideo_sva: Lista de campos de transacciones
      Salida:
        - an_resultado:  0:OK   1:ERROR   -1:ERROR BD
        - av_mensaje:    Descripcion de Resultado
  *********************************************************************/
  procedure p_registra_trx_envio_sva(ar_ope_clarovideo_sva in operacion.ope_trx_clarovideo_sva%rowtype,
                                     an_resultado          out number,
                                     av_mensaje            out varchar2) is
    ln_resultado number;
    lv_mensaje   varchar2(900);
  begin
    ln_resultado := 0;
    lv_mensaje   := 'Exito';
    --REGISTRA TRANSACCION DE ENVIO A CLARO VIDEO
    insert into operacion.ope_trx_clarovideo_sva
      (idregistro,
       idtransaccion,
       aplicacion,
       usraplicacion,
       ipaplicacion,
       cod_cli_sga,
       tipo_operacion,
       criterio,
       numslc_inicial,
       numslc_final,
       codsolot,
       sid_inicial,
       sid_final,
       fecha_envio,
       estado,
       nro_reintento,
       flag_envio_email,
       --Ini 4.0
       resultado,
       mensaje
       --Fin 4.0
       )
    values
      (ar_ope_clarovideo_sva.idregistro,
       ar_ope_clarovideo_sva.idtransaccion,
       ar_ope_clarovideo_sva.aplicacion,
       ar_ope_clarovideo_sva.usraplicacion,
       ar_ope_clarovideo_sva.ipaplicacion,
       ar_ope_clarovideo_sva.cod_cli_sga,
       ar_ope_clarovideo_sva.tipo_operacion,
       ar_ope_clarovideo_sva.criterio,
       ar_ope_clarovideo_sva.numslc_inicial,
       ar_ope_clarovideo_sva.numslc_final,
       ar_ope_clarovideo_sva.codsolot,
       ar_ope_clarovideo_sva.sid_inicial,
       ar_ope_clarovideo_sva.sid_final,
       ar_ope_clarovideo_sva.fecha_envio,
       ar_ope_clarovideo_sva.estado,
       ar_ope_clarovideo_sva.nro_reintento,
       ar_ope_clarovideo_sva.flag_envio_email,
       -- Ini 4.0
       ar_ope_clarovideo_sva.resultado,
       ar_ope_clarovideo_sva.mensaje
       -- Fin 4.0
       );

    an_resultado := ln_resultado;
    av_mensaje   := lv_mensaje;
  exception
    when others then
      an_resultado := -1;
      av_mensaje   := 'Error BD: Al registrar transaccion de envio a Claro Video. ' ||
                      sqlcode || ' ' || sqlerrm;
  end;
  /*********************************************************************
   PROCEDIMIENTO: Registro de transacciones de respuesta de Claro Video.
   PARAMETROS:
      Entrada:
        - ar_ope_clarovideo_sva: Lista de campos de transacciones
      Salida:
        - an_resultado:  0:OK   1:ERROR   -1:ERROR BD
        - av_mensaje:    Descripcion de Resultado
  *********************************************************************/
  procedure p_registra_trx_resp_sva(ar_ope_clarovideo_sva in operacion.ope_trx_clarovideo_sva%rowtype,
                                    an_resultado          out number,
                                    av_mensaje            out varchar2) is
    ln_reintento number;
    ln_estado    number;
    ln_resultado number;
    lv_mensaje   varchar2(900);
  begin
    ln_resultado := 0;
    lv_mensaje   := 'Exito';
    --OBTIENE ESTADO DE TRANSACCION
    if ar_ope_clarovideo_sva.resultado <> '0' then
      ln_estado := cn_trx_procesado_error;
    else
      ln_estado := cn_trx_procesado_ok;
    end if;
    --OBTIENE NUMERO REINTENTO
    if ar_ope_clarovideo_sva.nro_reintento is null then
      ln_reintento := 0;
    else
      ln_reintento := ar_ope_clarovideo_sva.nro_reintento + 1;
    end if;
    --REGISTRA TRANSACCION DE RESPUESTA DE CLARO VIDEO
    update operacion.ope_trx_clarovideo_sva
       set resultado      = ar_ope_clarovideo_sva.resultado,
           mensaje        = ar_ope_clarovideo_sva.mensaje,
           tipo_operacion = ar_ope_clarovideo_sva.tipo_operacion,
           idtransaccion  = ar_ope_clarovideo_sva.idtransaccion,
           estado         = ln_estado,
           nro_reintento  = ln_reintento
     where idregistro = ar_ope_clarovideo_sva.idregistro;

    an_resultado := ln_resultado;
    av_mensaje   := lv_mensaje;
  exception
    when others then
      an_resultado := -1;
      av_mensaje   := 'Error BD: Al registrar transaccion de respuesta de Claro Video. ' ||
                      sqlcode || ' ' || sqlerrm;
  end;
  /*********************************************************************
   PROCEDIMIENTO: Ejecuta la transacción de envío al ws de Claro Video.
   PARAMETROS:
      Entrada:
        - ar_ope_clarovideo_sva: Lista de campos de transacciones
      Salida:
        - an_resultado:  0:OK   1:ERROR   -1:ERROR BD
        - av_mensaje:    Descripcion de Resultado
  *********************************************************************/
  procedure p_ejecuta_trx_ws_sva(ar_ope_clarovideo_sva in out operacion.ope_trx_clarovideo_sva%rowtype,
                                 an_resultado          out number,
                                 av_mensaje            out varchar2) is
    lv_xml       varchar2(32767);
    lv_xml_rpta  varchar2(32767);
    lv_url       varchar2(32767);
    lv_codrspta  varchar2(50);
    lv_msgrspta  varchar2(2000);
    ln_resultado number;
    lv_mensaje   varchar2(2000);
  begin
    ln_resultado := 0;
    lv_mensaje   := 'Exito';
    If ar_ope_clarovideo_sva.tipo_operacion in
       (cv_tipope_trasexterno, cv_tipope_cambioplan) then
      --url
      select para.prmtv_valor
        into lv_url
        from operacion.sga_ap_parametro para
       where para.prmtc_tipo_param = 'WSACV'
         and para.prmtn_codigo_param = 4;
      --codRspta
      select para.prmtv_valor
        into lv_codrspta
        from operacion.sga_ap_parametro para
       where para.prmtc_tipo_param = 'WSACV'
         and para.prmtn_codigo_param = 5;
      --msgRspta
      select para.prmtv_valor
        into lv_msgrspta
        from operacion.sga_ap_parametro para
       where para.prmtc_tipo_param = 'WSACV'
         and para.prmtn_codigo_param = 6;

    ElsIf ar_ope_clarovideo_sva.tipo_operacion in (cv_tipope_baja) then
      --url
      select para.prmtv_valor
        into lv_url
        from operacion.sga_ap_parametro para
       where para.prmtc_tipo_param = 'WSBCV'
         and para.prmtn_codigo_param = 4;
      --codRspta
      select para.prmtv_valor
        into lv_codrspta
        from operacion.sga_ap_parametro para
       where para.prmtc_tipo_param = 'WSBCV'
         and para.prmtn_codigo_param = 5;
      --msgRspta
      select para.prmtv_valor
        into lv_msgrspta
        from operacion.sga_ap_parametro para
       where para.prmtc_tipo_param = 'WSBCV'
         and para.prmtn_codigo_param = 6;

    end if;

    lv_xml                          := f_arma_xml(ar_ope_clarovideo_sva);
    lv_xml_rpta                     := f_ejecuta_webservice(lv_xml, lv_url);
    ar_ope_clarovideo_sva.resultado := f_obtiene_atributo(lv_xml_rpta,
                                                          lv_codrspta);
    ar_ope_clarovideo_sva.mensaje   := f_obtiene_atributo(lv_xml_rpta,
                                                          lv_msgrspta);
    /*ar_ope_clarovideo_sva.idtransaccion := f_obtiene_atributo(lv_xml_rpta,
    'idTransaccion');*/
    /*ar_ope_clarovideo_sva.resultado     := 2;
    ar_ope_clarovideo_sva.mensaje       := 'Ocurrió un error en la Reasignacion';*/

    an_resultado := ln_resultado;
    av_mensaje   := lv_mensaje;
  exception
    when others then
      an_resultado := -1;
      av_mensaje   := 'Error BD: Al ejecutar transaccion de SVA. ' ||
                      sqlcode || ' ' || sqlerrm;
  end;
  /*********************************************************************
   PROCEDIMIENTO: Aplica transacciones de envío a Claro Video con error
   PARAMETROS:
      Salida:
        - an_resultado:  0:OK   1:ERROR   -1:ERROR BD
        - av_mensaje:    Descripcion de Resultado
  *********************************************************************/
  procedure p_aplica_trx_ws_sva(an_resultado out number,
                                av_mensaje   out varchar2) is
    lr_ope_clarovideo_sva operacion.ope_trx_clarovideo_sva%rowtype;
    ln_trx_pendiente      number;
    ln_resultado          number;
    lv_mensaje            varchar2(2000);
    cursor cur_trx_disputa_oac is
      select *
        from operacion.ope_trx_clarovideo_sva
       where estado in (cn_trx_registrado, cn_trx_procesado_error)
         and nvl(nro_reintento, 0) < f_obtiene_max_reintento
         and flag_envio_email = 0
       order by idregistro;
  begin
    ln_resultado := 0;
    lv_mensaje   := 'Exito';

    for reg in cur_trx_disputa_oac loop
      --ASIGNA DATOS DE REGISTRO DE TRANSACCION
      lr_ope_clarovideo_sva := reg;
      ln_trx_pendiente      := f_valida_trx_pendiente(lr_ope_clarovideo_sva.codsolot,
                                                      lr_ope_clarovideo_sva.idregistro);
      if ln_trx_pendiente = 0 then
        --EJECUTA WEBSERVICE DE CLARO VIDEO
        p_ejecuta_trx_ws_sva(lr_ope_clarovideo_sva,
                             ln_resultado,
                             lv_mensaje);
        if ln_resultado <> 0 then
          lr_ope_clarovideo_sva.resultado := ln_resultado;
          lr_ope_clarovideo_sva.mensaje   := lv_mensaje;
        end if;
        --REGISTRA TRANSACCION DE RESPUESTA DE CLARO VIDEO
        p_registra_trx_resp_sva(lr_ope_clarovideo_sva,
                                ln_resultado,
                                lv_mensaje);
      end if;
      <<salto>>
      null;
    end loop;

    an_resultado := 0;
    av_mensaje   := 'Exito';

  exception
    when others then
      an_resultado := -1;
      av_mensaje   := 'Error BD: ' || sqlcode || ' ' || sqlerrm;
  end;
  /*********************************************************************
    FUNCION: Arma XML
    PARAMETROS:
      Entrada:
        - ar_ope_clarovideo_sva: Lista de campos de transacciones
      Salida:
        - lv_xml: XML
  *********************************************************************/
  function f_arma_xml(ar_ope_clarovideo_sva in operacion.ope_trx_clarovideo_sva%rowtype)
    return varchar2 is
    lv_xml varchar2(32767);
  begin
    If ar_ope_clarovideo_sva.tipo_operacion in
       (cv_tipope_trasexterno, cv_tipope_cambioplan) then
      --soap envelope
      select prmtv_valor
        into lv_xml
        from operacion.sga_ap_parametro
       where prmtc_tipo_param = 'WSACV'
         and prmtn_codigo_param = 1;
      --namespace
      select replace(lv_xml, '@namespace', prmtv_valor)
        into lv_xml
        from operacion.sga_ap_parametro
       where prmtc_tipo_param = 'WSACV'
         and prmtn_codigo_param = 2;
      --trama
      select replace(lv_xml, '@trama', prmtv_valor)
        into lv_xml
        from operacion.sga_ap_parametro para
       where para.prmtc_tipo_param = 'WSACV'
         and para.prmtn_codigo_param = 3;
    ElsIf ar_ope_clarovideo_sva.tipo_operacion in (cv_tipope_baja) then
      --soap envelope
      select prmtv_valor
        into lv_xml
        from operacion.sga_ap_parametro
       where prmtc_tipo_param = 'WSBCV'
         and prmtn_codigo_param = 1;
      --namespace
      select replace(lv_xml, '@namespace', prmtv_valor)
        into lv_xml
        from operacion.sga_ap_parametro
       where prmtc_tipo_param = 'WSBCV'
         and prmtn_codigo_param = 2;
      --trama
      select replace(lv_xml, '@trama', prmtv_valor)
        into lv_xml
        from operacion.sga_ap_parametro para
       where para.prmtc_tipo_param = 'WSBCV'
         and para.prmtn_codigo_param = 3;
    End If;
    lv_xml := replace(lv_xml,
                      '@idtransaccion',
                      ar_ope_clarovideo_sva.idtransaccion);
    lv_xml := replace(lv_xml,
                      '@aplicacion',
                      ar_ope_clarovideo_sva.aplicacion);
    lv_xml := replace(lv_xml,
                      '@usrAplicacion',
                      ar_ope_clarovideo_sva.usraplicacion);
    lv_xml := replace(lv_xml,
                      '@ipAplicacion',
                      ar_ope_clarovideo_sva.ipaplicacion);
    lv_xml := replace(lv_xml, '@criterio', ar_ope_clarovideo_sva.criterio);
    lv_xml := replace(lv_xml,
                      '@valorCriterio',
                      ar_ope_clarovideo_sva.sid_inicial);
    lv_xml := replace(lv_xml,
                      '@valorAntiguo',
                      ar_ope_clarovideo_sva.sid_inicial);
    lv_xml := replace(lv_xml,
                      '@valorNuevo',
                      ar_ope_clarovideo_sva.sid_final);
    lv_xml := replace(lv_xml, '@listaOpcionalRequest', '');

    return lv_xml;
  exception
    when others then
      lv_xml := null;
      return lv_xml;
  end;
  /*********************************************************************
    FUNCION: Ejecuta webservice
    PARAMETROS:
      Entrada:
        - av_xml: XML construido
        - av_url: URL
      Salida:
        - lv_response: Respuesta
  *********************************************************************/
  function f_ejecuta_webservice(av_xml in varchar2, av_url in varchar2)
    return varchar2 is
    time_out    pls_integer := -12535;
    lv_response varchar2(32767);
    http_req    utl_http.req;
    http_resp   utl_http.resp;
  begin
    http_req := utl_http.begin_request(av_url, 'POST', 'HTTP/1.1');
    utl_http.set_header(http_req, 'Content-Type', 'text/xml');
    utl_http.set_header(http_req, 'Content-Length', length(av_xml));
    utl_http.write_text(http_req, av_xml);
    http_resp := utl_http.get_response(http_req);
    utl_http.read_text(http_resp, lv_response);
    utl_http.end_response(http_resp);

    return lv_response;
  exception
    when utl_http.end_of_body then
      utl_http.end_response(http_resp);
    when others then
      if sqlcode = time_out then
        raise_application_error(-20000,
                                $$plsql_unit ||
                                '.call_webservice: time_out' || sqlerrm);
      else
        raise_application_error(-20000,
                                $$plsql_unit || '.call_webservice: ' ||
                                sqlerrm);
      end if;
  end;
  /*********************************************************************
    FUNCION: Obtiene el valor del atributo
    PARAMETROS:
      Entrada:
        - av_xml: XML
        - av_atributo: Atributo
      Salida:
        - lv_xml: Valor del atributo
  *********************************************************************/
  function f_obtiene_atributo(av_xml in varchar2, av_atributo in varchar2)
    return varchar2 is
    lv_xml varchar2(32767);
  begin
    lv_xml := av_xml;
    lv_xml := substr(lv_xml,
                     instr(lv_xml, av_atributo) + length(av_atributo) + 1);
    --lv_xml := substr(lv_xml, instr(lv_xml, '>') -1);
    lv_xml := substr(lv_xml, 1, instr(lv_xml, '<') - 1);

    return lv_xml;
  exception
    when others then
      lv_xml := null;
      return lv_xml;
  end;
  /*********************************************************************
    FUNCION: Obtiene codigo de registro de transaccion
    PARAMETROS:
      Salida:
        - ln_idregistro: Codigo de registro
  *********************************************************************/
  function f_obtiene_idregistro return number is
    ln_idregistro number;
  begin
    select max(idregistro)
      into ln_idregistro
      from operacion.ope_trx_clarovideo_sva;

    ln_idregistro := nvl(ln_idregistro, 0) + 1;
    return ln_idregistro;
  exception
    when others then
      ln_idregistro := null;
      return ln_idregistro;
  end;
  /*********************************************************************
    FUNCION: Obtiene numero maximo de reintento
    PARAMETROS:
      Salida:
        - lv_max_reintento: Numero maximo de reintento
  *********************************************************************/
  function f_obtiene_max_reintento return varchar2 is
    lv_max_reintento varchar2(50);
  begin
    select codigon_aux
      into lv_max_reintento
      from opedd
     where codigoc = 'SVA_MAX_INTENTO';
    return lv_max_reintento;
  exception
    when others then
      lv_max_reintento := null;
      return lv_max_reintento;
  end;
  /*********************************************************************
    FUNCION: Obtiene SID por proyecto de traslado externo
    PARAMETROS:
      Entrada:
        - av_numslc: Número de proyecto a obtener SID
      Salida:
        - ln_SID: SID principal del proyecto
  *********************************************************************/
  function f_obtiene_sidxproyecto_te(av_numslc in varchar2) return number is
    ln_sid_internet  inssrv.codinssrv%type;
    ln_sid_cable     inssrv.codinssrv%type;
    ln_sid_telefonia inssrv.codinssrv%type;
    ln_codinssrv     inssrv.codinssrv%type;
    an_ser_internet  constant number := '0006';
    an_ser_cable     constant number := '0062';
    an_ser_telefonia constant number := '0004';
    cursor cur_sid(av_numslc in varchar2) is
      select i.codinssrv, i.tipsrv
        from inssrv i, vtatabslcfac v
       where v.tipsrv = '0061'
         and v.numslc = i.numslc
         and i.numslc = av_numslc
         and i.estinssrv in (1, 2,3)
         and i.tipsrv <> '0025';
  begin
    for reg in cur_sid(av_numslc) loop
      if reg.tipsrv = an_ser_internet then
        ln_sid_internet := reg.codinssrv;
      elsif reg.tipsrv = an_ser_cable then
        ln_sid_cable := reg.codinssrv;
      elsif reg.tipsrv = an_ser_telefonia then
        ln_sid_telefonia := reg.codinssrv;
      end if;
    end loop;

    if ln_sid_internet > 0 then
      ln_codinssrv := ln_sid_internet;
    elsif ln_sid_cable > 0 then
      ln_codinssrv := ln_sid_cable;
    elsif ln_sid_telefonia > 0 then
      ln_codinssrv := ln_sid_telefonia;
    end if;
    return ln_codinssrv;
  exception
    when others then
      ln_codinssrv := null;
      return ln_codinssrv;
  end;
  /*********************************************************************
    FUNCION: Obtiene SID por proyecto de traslado externo
    PARAMETROS:
      Entrada:
        - av_numslc: Número de proyecto a obtener SID
      Salida:
        - ln_SID: SID principal del proyecto
  *********************************************************************/
  function f_obtiene_sidxproyecto_cp(av_numslc in varchar2) return number is
    ln_sid_internet  inssrv.codinssrv%type;
    ln_sid_cable     inssrv.codinssrv%type;
    ln_sid_telefonia inssrv.codinssrv%type;
    ln_codinssrv     inssrv.codinssrv%type;
    an_ser_internet  constant number := '0006';
    an_ser_cable     constant number := '0062';
    an_ser_telefonia constant number := '0004';
    cursor cur_sid(av_numslc in varchar2) is
      select distinct p.codinssrv, i.tipsrv
        from insprd p, inssrv i, vtatabslcfac v
       where p.numslc = av_numslc
         and p.codinssrv = i.codinssrv
         and p.numslc = v.numslc
         and v.tipsrv = '0061'
         and i.estinssrv in (1, 2,3)
         and i.tipsrv <> '0025';
  begin
    for reg in cur_sid(av_numslc) loop
      if reg.tipsrv = an_ser_internet then
        ln_sid_internet := reg.codinssrv;
      elsif reg.tipsrv = an_ser_cable then
        ln_sid_cable := reg.codinssrv;
      elsif reg.tipsrv = an_ser_telefonia then
        ln_sid_telefonia := reg.codinssrv;
      end if;
    end loop;

    if ln_sid_internet > 0 then
      ln_codinssrv := ln_sid_internet;
    elsif ln_sid_cable > 0 then
      ln_codinssrv := ln_sid_cable;
    elsif ln_sid_telefonia > 0 then
      ln_codinssrv := ln_sid_telefonia;
    end if;
    return ln_codinssrv;
  exception
    when others then
      ln_codinssrv := null;
      return ln_codinssrv;
  end;
  /*********************************************************************
    FUNCION: Valida transacciones pendientes de envío para la misma solot.
    PARAMETROS:
      Entrada:
        - an_codsolot: Código de solot
      Salida:
        - ln_trx_pendiente: Cantidad de transacciones pendientes
  *********************************************************************/
  function f_valida_trx_pendiente(an_codsolot   in number,
                                  an_idregistro in number) return number is
    ln_trx_pendiente number;
  begin
    select count(*)
      into ln_trx_pendiente
      from operacion.ope_trx_clarovideo_sva
     where codsolot = an_codsolot
       and estado in (cn_trx_registrado, cn_trx_procesado_error)
       and idregistro < an_idregistro;
    return ln_trx_pendiente;
  exception
    when others then
      ln_trx_pendiente := null;
      return ln_trx_pendiente;
  end;
  /*********************************************************************
    FUNCION: Valida si se envió la transacción a Claro Video..
    PARAMETROS:
      Entrada:
        - an_codsolot: Código de solot
      Salida:
        - ln_trx_pendiente: Cantidad de transacciones enviadas
  *********************************************************************/
  function f_valida_registrado_sva(an_codsolot in number) return number is
    ln_trx_pendiente number;
  begin
    select count(*)
      into ln_trx_pendiente
      from operacion.ope_trx_clarovideo_sva
     where codsolot = an_codsolot;

    return ln_trx_pendiente;
  exception
    when others then
      ln_trx_pendiente := null;
      return ln_trx_pendiente;
  end;
   --------------------------------------------------------------------------------> 0.3 (ini)  
  procedure devuelve_respuesta_error(p_resultado     out number,
                                     p_mensaje       out varchar2,
                                     p_detalle_error out clob) is
  
    l_resultado pls_integer;
    l_mensaje   varchar2(1000);
  
    cursor c_registros is
      select a.idregistro, a.cod_cli_sga, decode(a.tipo_operacion,
                     'TE',
                     'Traslado Externo.',
                     'CP',
                     'Cambio de Plan.',
                     'BA',
                     'Baja por cambio de Titularidad.') tipo_operacion, (select numslc
                 from inssrv
                where codinssrv =
                      a.sid_inicial) as numslc_inicial, a.sid_inicial, (select numslc
                 from inssrv
                where codinssrv =
                      a.sid_final) as numslc_final, a.sid_final, a.fecha_envio                      
        from operacion.ope_trx_clarovideo_sva a
       where a.estado in (0, 2)
         and a.flag_envio_email = 0
         and to_char(a.nro_reintento) =
             (select codigon_aux
                from opedd
               where abreviacion = 'SVA_MAX_INTENTO')
       order by a.idregistro;
  
  begin
  
    for r in c_registros loop
      p_detalle_error := p_detalle_error || chr(10) || r.cod_cli_sga || ',' ||
                         r.tipo_operacion || ',' || r.numslc_inicial || ',' ||
                         r.sid_inicial || ',' || r.numslc_final || ',' ||
                         r.sid_final || ',' || r.fecha_envio;
    
      update operacion.ope_trx_clarovideo_sva
         set flag_envio_email = 1
       where idregistro = r.idregistro;
    end loop;
  
    l_resultado := 0;
    l_mensaje   := 'Exito';
  
  exception
    when others then
      l_resultado := -1;
      l_mensaje   := 'Error BD: ' || sqlcode || ' ' || sqlerrm;
  end;
  --------------------------------------------------------------------------------> 0.3 (fin)
END PQ_SERV_VALOR_AGREGADO;
/