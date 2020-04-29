create or replace package body operacion.pq_ope_aviso IS

  /*******************************************************************************************************
  NOMBRE:     PQ_OPE_AVISO
  PROPÓSITO:  Agrupación de funcionalidad de suspensiones, cortes y reconexiones

  REVISIONES:
  Versión      Fecha        Autor           Descripción
  ---------  ----------  ---------------  ------------------------
  1.0        15/11/2011  Alfonso Pérez     Creación
  1.1        19/03/2012  Kevy Carranza     Envío de mensajes a los equipos compatibles con Portal Cautivo
  2.0        13/09/2012  Kevy Carranza     REQ 163208 Portal Cautivo - Exoneracion de evento cobranzas
  3.0        07/10/2013  Isaac Barrios     PROY-4086 Nuevo Sistema de Cobranza     
  4.0        20/02/2017  Servicio Fallas-HITSS       
  ********************************************************************************************************/

  cn_susp   constant number := 49; --grupo de suspension
  cn_corte  constant number := 50; --grupo de corte
  cn_cm     constant number := 620; --interfase handleCM
  cn_cm_int constant number := 628; --interfase
  cn_ep     constant number := 824; --interfase handleEndPoint
  cn_stb    constant number := 2020; --interfase handleSTB

  --Se elimina constante cn_comando --2.0

  --Ini 2.0
  cn_codstatus_gen constant atccorp.incidence.codstatus%type := 1; -- 1 Generado, 2 En Proceso
  cn_codstatus_pro constant atccorp.incidence.codstatus%type := 2; --2 En Proceso
  --fin 2.0
  procedure p_genera_registros(an_inicio number) is
    cursor cur_proceso is
      select mm.idmensaje,
             cr.idcomando,
             mm.aplicaxsegmark,
             mm.diasposteriorestx,
             cr.comando,
             mm.mensaje,
             mm.codtipo,
             cr.orden,
             gm.idgrupo,
             gm.grupoejecucion,
             gm.diasutiles,
             mm.estado,
             op.descabr,
             op.aplicasolucion
        from ope_mensajes_mae        mm,
             ope_grupo_mensajes_det  gm,
             ope_serviciomensaje_rel sm,
             ope_comando_rel         cr,
             ope_grupos_rel          op
       where mm.idmensaje = gm.idmensaje
         and mm.idmensaje = sm.idmensaje
         and sm.idservmens = cr.idservmens
         and gm.idgrupo = op.idgrupo
         and gm.estado = 1
         and cr.estado = 1
         and cr.orden = 1
         and sm.estado = 1
         and mm.estado = 1
         and op.estado = 1;

  begin
    for reg_procesa in cur_proceso loop

      if reg_procesa.estado = 1 then
        if reg_procesa.codtipo = 1 then
          p_gen_antesvencimiento(reg_procesa.idmensaje,
                                 reg_procesa.idgrupo,
                                 reg_procesa.comando,
                                 reg_procesa.orden,
                                 reg_procesa.aplicaxsegmark,
                                 reg_procesa.aplicasolucion,
                                 reg_procesa.diasposteriorestx);
        end if;
        --Ini 2.0 Se comenta procesos antes y después de suspensión
        /*if reg_procesa.codtipo = 2 then
          p_gen_antsuspension(reg_procesa.idmensaje,
                              reg_procesa.idgrupo,
                              reg_procesa.comando,
                              reg_procesa.orden,
                              reg_procesa.aplicaxsegmark,
                              reg_procesa.aplicasolucion,
                              reg_procesa.diasposteriorestx);
        end if;

        if reg_procesa.codtipo = 3 then
          p_gen_despsuspension(reg_procesa.idmensaje,
                               reg_procesa.idgrupo,
                               reg_procesa.comando,
                               reg_procesa.orden,
                               reg_procesa.aplicaxsegmark,
                               reg_procesa.aplicasolucion,
                               reg_procesa.diasposteriorestx);
        end if;*/
        --Fin 2.0
      end if;

    end loop;

  end;

  procedure p_gen_antesvencimiento(an_caso       number,
                                   an_grupo      number,
                                   an_comando    number,
                                   an_orden      number,
                                   an_aplica_seg number,
                                   an_aplica_sol number,
                                   an_dias       number) is

    an_idlote number;
    --Ini 2.0
    --as_nombre   OPE_ESTADOMENSAJE_DET.NOMBRE%type;
    --ln_segmento number;
    --ln_solucion number;
    ln_incidence    number;
    ln_incidence_ok number;
    --Fin 2.0

    cursor cur_fecven(an_diasrestar number) is
      SELECT fac.codcli,
             fac.nomcli,
             fac.sldact,
             fac.idfac,
             fac.tipdoc,
             fac.sersut,
             fac.numsut,
             fac.fecemi,
             fac.fecven,
             fac.idisprincipal,
             fac.nomabr,
             fac.codsegmark,
             fac.idgrupocorte,
             fac.codinssrv,
             fac.estinssrv,
             fac.cicfac,
             fac.grupo,
             fac.idsolucion
        FROM operacion.vm_ope_facturas fac
       where trunc(fac.fecven + an_diasrestar) = trunc(sysdate);

    /*    Se comenta las condiciones
     FROM operacion.vm_ope_facturas fac, cxctabfac doc
    WHERE fac.codcli = doc.codcli
      AND fac.idfac = doc.idfac
      and trunc(fac.fecven + an_diasrestar) = trunc(sysdate);*/
    --Fin 2.0

  begin

    --Ini 2.0
    --El insert a la tabla ope_inscliente_cab se coloco dentro de un procedimiento
    p_ins_ope_inscliente_cab(an_idlote);
    --Se comento el siguiente select
    /*select nombre
     into as_nombre
     from OPE_ESTADOMENSAJE_DET
    where idestado = 1;*/

    --Fin 2.0
    for cur in cur_fecven(an_dias) loop

      --Ini 2.0
      --Se coloco toda la lógica de inserción de la tabla ope_inscliente_rel en en el nuevo procedimiento p_procesa_registros

      ln_incidence := f_val_incidence(cur.codcli, cur.sersut, cur.numsut);

      if ln_incidence > 0 then

        ln_incidence_ok := f_val_estado_incidence(cur.codcli,
                                                  cur.sersut,
                                                  cur.numsut);
        if ln_incidence_ok = 0 then

          p_procesa_registros(an_caso,
                              an_grupo,
                              an_comando,
                              an_orden,
                              an_aplica_seg,
                              an_aplica_sol,
                              an_idlote,
                              cur.codcli,
                              cur.nomcli,
                              cur.idsolucion,
                              cur.codinssrv,
                              cur.nomabr,
                              cur.idfac,
                              cur.codsegmark);
        end if;
      else
        p_procesa_registros(an_caso,
                            an_grupo,
                            an_comando,
                            an_orden,
                            an_aplica_seg,
                            an_aplica_sol,
                            an_idlote,
                            cur.codcli,
                            cur.nomcli,
                            cur.idsolucion,
                            cur.codinssrv,
                            cur.nomabr,
                            cur.idfac,
                            cur.codsegmark);
        --Fin 2.0
      end if;
      commit;
    end loop;

  end;

  procedure p_gen_antsuspension(an_caso       number,
                                an_grupo      number,
                                an_comando    number,
                                an_orden      number,
                                an_aplica_seg number,
                                an_aplica_sol number,
                                an_dias       number) is
    an_idlote   number;
    as_nombre   varchar2(30);
    ln_segmento number;
    ln_solucion number;

    cursor cur_antsusp(an_diasrestar number) is
      select a.codcli,
             a.codinssrv    as codins,
             a.idfac        as idfa,
             b.*,
             c.nomcli,
             seg.codsegmark,
             sol.idsolucion,
             d.nomabr       nombre
        from cxc_inscabcorte              a,
             cxc_instransaccioncorte      b,
             vtatabcli                    c,
             cxctabfac                    d,
             billcolper.instanciaservicio insfac,
             operacion.inssrv             insope,
             sales.vtatabslcfac           pro,
             sales.soluciones             sol,
             marketing.vtatabcli          cli,
             marketing.vtatabsegmark      seg
       where a.codinssrv = insfac.codinssrv
         and insfac.codcli = a.codcli
         and insfac.codinssrv = insope.codinssrv
         AND insfac.codcli = insope.codcli
         and insfac.codcli = cli.codcli
         and cli.codsegmark = seg.codsegmark
         AND insope.numslc = pro.numslc
         and insope.estinssrv in (1, 2)
         AND pro.idsolucion = sol.idsolucion
         and sol.idgrupocorte is not null
         and a.codcli = c.codcli
         and a.idfac = d.idfac
         and a.estado = 1
         and a.idinscabcorte = b.idinscabcorte
         and b.flgprocesado = 0
         and b.flgultimo = 1
         and b.idtragrucorte = cn_susp --suspension
         and b.fase = 'PEND_EJECUCION'
         and b.estado = 'OK'
         and b.automatico = 'SI'
         and trunc(b.fecpro + an_diasrestar) = trunc(sysdate);

  begin

    insert into ope_inscliente_cab
      (nombre, tipo)
    values
      ('LOTE ANTES SUSPENSION', 2);

    select max(id_lote) into an_idlote from ope_inscliente_cab;

    select nombre
      into as_nombre
      from OPE_ESTADOMENSAJE_DET
     where idestado = 1;

    for cur in cur_antsusp(an_dias) loop

      -- el cliente tiene un codsegmark ya que aplica la condicion, buscamos en nuestros
      -- registros si esta el codsegmark configurado, si me bota diferente de cero existe
      select count(1)
        into ln_segmento
        from ope_segmentomercado_rel
       where idmensaje = an_caso
         and codsegmark = cur.codsegmark
         and estado = 1;

      -- busca solucion asociada en tabla

      select count(1)
        into ln_solucion
        from ope_grupomenssol_det
       where idgrupo = an_grupo
         and idsolucion = cur.idsolucion
         and estadosol = 1;

      if an_aplica_seg = 1 then

        if an_aplica_sol = 1 then

          -- existe valores en segmento de mercado y solucion
          if ln_segmento != 0 and ln_solucion != 0 then

            insert into OPE_INSCLIENTE_REL
              (idgrupomensaje,
               idmensaje,
               idcomando,
               codcli,
               idmensseg,
               idestado,
               fecha_estado,
               seleccion,
               orden,
               nomcli,
               id_lote,
               fecha_creacion,
               codinssrv,
               NOMABR,
               idsolucion,
               codtipo,
               Idfac)
            values
              (an_grupo,
               an_caso,
               an_comando,
               cur.codcli,
               cur.codsegmark,
               1,
               sysdate,
               1,
               an_orden,
               cur.nomcli,
               an_idlote,
               sysdate,
               cur.codins,
               cur.nombre,
               cur.idsolucion,
               2,
               cur.idfa);

          end if;

        else
          --existe valores en segmento
          if ln_segmento != 0 then

            insert into OPE_INSCLIENTE_REL
              (idgrupomensaje,
               idmensaje,
               idcomando,
               codcli,
               idmensseg,
               idestado,
               fecha_estado,
               seleccion,
               orden,
               nomcli,
               id_lote,
               fecha_creacion,
               codinssrv,
               NOMABR,
               Idsolucion,
               codtipo,
               idfac)
            values
              (an_grupo,
               an_caso,
               an_comando,
               cur.codcli,
               cur.codsegmark,
               1,
               sysdate,
               1,
               an_orden,
               cur.nomcli,
               an_idlote,
               sysdate,
               cur.codins,
               cur.nombre,
               0,
               2,
               cur.idfa);

          end if;

        end if;

      else
        if an_aplica_sol = 1 then
          -- existen valores que cumplen condicion de solución
          if ln_solucion != 0 then
            insert into OPE_INSCLIENTE_REL
              (idgrupomensaje,
               idmensaje,
               idcomando,
               codcli,
               idmensseg,
               idestado,
               fecha_estado,
               seleccion,
               orden,
               nomcli,
               id_lote,
               fecha_creacion,
               codinssrv,
               NOMABR,
               idsolucion,
               codtipo,
               idfac)
            values
              (an_grupo,
               an_caso,
               an_comando,
               cur.codcli,
               0,
               1,
               sysdate,
               1,
               an_orden,
               cur.nomcli,
               an_idlote,
               sysdate,
               cur.codins,
               cur.nombre,
               cur.idsolucion,
               2,
               cur.idfa);
          end if;

        else
          insert into OPE_INSCLIENTE_REL
            (idgrupomensaje,
             idmensaje,
             idcomando,
             codcli,
             idmensseg,
             idestado,
             fecha_estado,
             seleccion,
             orden,
             nomcli,
             id_lote,
             fecha_creacion,
             codinssrv,
             NOMABR,
             idsolucion,
             codtipo,
             idfac)
          values
            (an_grupo,
             an_caso,
             an_comando,
             cur.codcli,
             0,
             1,
             sysdate,
             1,
             an_orden,
             cur.nomcli,
             an_idlote,
             sysdate,
             cur.codins,
             cur.nombre,
             0,
             2,
             cur.idfa);
        end if;
      end if;
      commit;
    end loop;

  end;

  procedure p_gen_despsuspension(an_caso       number,
                                 an_grupo      number,
                                 an_comando    number,
                                 an_orden      number,
                                 an_aplica_seg number,
                                 an_aplica_sol number,
                                 an_dias       number) is

    an_idlote   number;
    as_nombre   varchar2(30);
    ln_segmento number;
    ln_solucion number;

    cursor cur_despsusp(an_diassumar number) is
      select a.codcli,
             a.codinssrv,
             a.idfac, /*b.*,*/
             d.nomcli,
             seg.codsegmark,
             sol.idsolucion,
             e.nomabr nombre
        from cxc_inscabcorte              a,
             cxc_instransaccioncorte      b,
             vtatabcli                    d,
             cxctabfac                    e,
             billcolper.instanciaservicio insfac,
             operacion.inssrv             insope,
             sales.vtatabslcfac           pro,
             sales.soluciones             sol,
             marketing.vtatabcli          cli,
             marketing.vtatabsegmark      seg
       where a.codinssrv = insfac.codinssrv
         and insfac.codcli = a.codcli
         and insfac.codinssrv = insope.codinssrv
         AND insfac.codcli = insope.codcli
         and insfac.codcli = cli.codcli
         and cli.codsegmark = seg.codsegmark
         AND insope.numslc = pro.numslc
         and insope.estinssrv in (1, 2)
         AND pro.idsolucion = sol.idsolucion
         and sol.idgrupocorte is not null
         and a.codcli = d.codcli
         and a.idfac = e.idfac
         and a.estado = 1
         and a.idinscabcorte = b.idinscabcorte
         and b.flgprocesado = 0
         and b.flgultimo = 1
         and b.idtragrucorte = cn_corte --corte
         and b.fase = 'PEND_EJECUCION'
         and b.estado = 'OK'
         and b.automatico = 'SI'
         and trunc(b.fecgen + an_diassumar) = trunc(sysdate);

  begin

    insert into ope_inscliente_cab
      (nombre, tipo)
    values
      ('LOTE DESPUES DE SUSPENSION', 3);

    select max(id_lote) into an_idlote from ope_inscliente_cab;

    select nombre
      into as_nombre
      from OPE_ESTADOMENSAJE_DET
     where idestado = 1;

    for cur in cur_despsusp(an_dias) loop

      -- el cliente tiene un codsegmark ya que aplica la condicion, buscamos en nuestros
      -- registros si esta el codsegmark configurado, si me bota diferente de cero existe
      select count(1)
        into ln_segmento
        from ope_segmentomercado_rel
       where idmensaje = an_caso
         and codsegmark = cur.codsegmark
         and estado = 1;

      -- busca solucion asociada en tabla

      select count(1)
        into ln_solucion
        from ope_grupomenssol_det
       where idgrupo = an_grupo
         and idsolucion = cur.idsolucion
         and estadosol = 1;

      if an_aplica_seg = 1 then

        if an_aplica_sol = 1 then

          -- existe valores en segmento de mercado y solucion
          if ln_segmento != 0 and ln_solucion != 0 then

            insert into OPE_INSCLIENTE_REL
              (idgrupomensaje,
               idmensaje,
               idcomando,
               codcli,
               idmensseg,
               idestado,
               fecha_estado,
               seleccion,
               orden,
               nomcli,
               id_lote,
               fecha_creacion,
               codinssrv,
               NOMABR,
               idsolucion,
               codtipo,
               Idfac)
            values
              (an_grupo,
               an_caso,
               an_comando,
               cur.codcli,
               cur.codsegmark,
               1,
               sysdate,
               1,
               an_orden,
               cur.nomcli,
               an_idlote,
               sysdate,
               cur.codinssrv,
               cur.nombre,
               cur.idsolucion,
               3,
               cur.idfac);

          end if;

        else
          --existe valores en segmento
          if ln_segmento != 0 then

            insert into OPE_INSCLIENTE_REL
              (idgrupomensaje,
               idmensaje,
               idcomando,
               codcli,
               idmensseg,
               idestado,
               fecha_estado,
               seleccion,
               orden,
               nomcli,
               id_lote,
               fecha_creacion,
               codinssrv,
               NOMABR,
               Idsolucion,
               codtipo,
               Idfac)
            values
              (an_grupo,
               an_caso,
               an_comando,
               cur.codcli,
               cur.codsegmark,
               1,
               sysdate,
               1,
               an_orden,
               cur.nomcli,
               an_idlote,
               sysdate,
               cur.codinssrv,
               cur.nombre,
               0,
               3,
               cur.idfac);

          end if;

        end if;

      else
        if an_aplica_sol = 1 then
          -- existen valores que cumplen condicion de solución
          if ln_solucion != 0 then
            insert into OPE_INSCLIENTE_REL
              (idgrupomensaje,
               idmensaje,
               idcomando,
               codcli,
               idmensseg,
               idestado,
               fecha_estado,
               seleccion,
               orden,
               nomcli,
               id_lote,
               fecha_creacion,
               codinssrv,
               NOMABR,
               idsolucion,
               codtipo,
               idfac)
            values
              (an_grupo,
               an_caso,
               an_comando,
               cur.codcli,
               0,
               1,
               sysdate,
               1,
               an_orden,
               cur.nomcli,
               an_idlote,
               sysdate,
               cur.codinssrv,
               cur.nombre,
               cur.idsolucion,
               3,
               cur.idfac);
          end if;

        else
          insert into OPE_INSCLIENTE_REL
            (idgrupomensaje,
             idmensaje,
             idcomando,
             codcli,
             idmensseg,
             idestado,
             fecha_estado,
             seleccion,
             orden,
             nomcli,
             id_lote,
             fecha_creacion,
             codinssrv,
             NOMABR,
             idsolucion,
             codtipo,
             idfac)
          values
            (an_grupo,
             an_caso,
             an_comando,
             cur.codcli,
             0,
             1,
             sysdate,
             1,
             an_orden,
             cur.nomcli,
             an_idlote,
             sysdate,
             cur.codinssrv,
             cur.nombre,
             0,
             3,
             cur.idfac);
        end if;
      end if;
      commit;
    end loop;
  end;

  procedure p_valida_registros(an_tipo number) is

    ln_detalle number;
    an_cant    number;

    cursor cur_obtiene is
      select b.idtransmensaje,
             b.codcli,
             b.nomcli,
             b.nomabr,
             b.fecreg,
             b.estado,
             a.tipo
        from OPE_INSCLIENTE_REL b, ope_inscliente_cab a
       WHERE a.id_lote = b.id_lote
         and a.ESTADO = 1
         and b.estado = 1
         and trunc(b.fecreg) = trunc(sysdate);

  begin

    for cur in cur_obtiene loop

      ln_detalle := 0;

      if cur.nomabr is null then

        update OPE_INSCLIENTE_REL
           set estado = 0
         where idtransmensaje = cur.idtransmensaje;
        ln_detalle := 1;
      end if;

      if ln_detalle = 0 then

        select count(*)
          into an_cant
          from ope_inscliente_rel a, ope_inscliente_cab b
         where a.id_lote = b.id_lote
           and a.codcli = cur.codcli
           and a.nomabr = cur.nomabr
           and trunc(a.fecreg) = trunc(sysdate)
           and a.estado = 1
           and b.tipo = cur.tipo;

        if an_cant != 1 then
          update OPE_INSCLIENTE_REL
             set estado = 0
           where idtransmensaje = cur.idtransmensaje;
        end if;

      end if;
      commit;
    end loop;

  end;

  procedure p_setea_campos(an_tipo number) is

    ls_idproducto   intraway.int_servicio_intraway.id_producto%type;
    ls_interfase    intraway.int_servicio_intraway.id_interfase%type;
    ls_activacion   intraway.int_servicio_intraway.id_activacion%type;
    ls_codinssrv    intraway.int_servicio_intraway.codinssrv%type;
    ld_creacion     intraway.int_servicio_intraway.fecha_creacion%type;
    ld_activacion   intraway.int_servicio_intraway.fecha_activacion%type;
    ld_modificacion intraway.int_servicio_intraway.fecha_modificacion%type;
    ln_cantidad     number;

    cursor cur_obteniene is
      select *
        from ope_inscliente_rel
       where estado = 1
         and trunc(fecreg) = trunc(sysdate);

  begin

    for reg_actualiza in cur_obteniene loop
      update ope_inscliente_rel
         set codinssrv = f_obtiene_datos(reg_actualiza.codinssrv)
       where idtransmensaje = reg_actualiza.idtransmensaje;
    end loop;
    commit;

    for reg in cur_obteniene loop

      select count(1)
        into ln_cantidad
        from int_servicio_intraway
       where id_cliente = reg.codcli
         and id_interfase = cn_cm
         and codinssrv = reg.codinssrv;

      if ln_cantidad = 1 then

        select id_producto,
               id_interfase,
               id_activacion,
               codinssrv,
               fecha_creacion,
               fecha_activacion,
               fecha_modificacion
          into ls_idproducto,
               ls_interfase,
               ls_activacion,
               ls_codinssrv,
               ld_creacion,
               ld_activacion,
               ld_modificacion
          from int_servicio_intraway
         where id_cliente = reg.codcli
           and id_interfase = cn_cm
           and codinssrv = reg.codinssrv;

        update ope_inscliente_rel
           set id_producto        = ls_idproducto,
               id_interfase       = ls_interfase,
               id_activacion      = ls_activacion,
               codinssrv          = ls_codinssrv,
               fecha_creacion     = ld_creacion,
               fecha_activacion   = ld_activacion,
               fecha_modificacion = ld_modificacion
         where idtransmensaje = reg.idtransmensaje;
      end if;
      commit;
    end loop;

  end;

  procedure p_int_proceso(a_opcion     in number,
                          a_codsolot   in solot.codsolot%type,
                          a_enviar_itw in number default 0) IS

    v_codcli            solot.codcli%type;
    p_resultado         varchar2(10);
    p_mensaje           varchar(32000);
    p_error             number;
    v_id_estado         number;
    v_idMensajeCRM      varchar2(100);
    v_mensaje           varchar2(32400);
    v_sendtocontroler   varchar2(10);
    v_HomeExchangeCrmId varchar2(100);
    error_general EXCEPTION;
    error_cant_lineas EXCEPTION;
    error_no EXCEPTION;
    v_codsrv_telefonia tystabsrv.codsrv%type;
    v_validaregistro   number;

    CURSOR c_ins is

      select st.*
        from int_servicio_intraway st
       where st.id_interfase in (cn_cm, cn_ep, cn_stb)
         and st.estado = 1
         AND st.codinssrv IN
             (select codinssrv FROM solotpto where codsolot = a_codsolot);
  begin
    select count(*)
      into v_validaregistro
      from intraway.int_solot_itw
     where codsolot = a_codsolot;

    IF v_validaregistro = 0 THEN

      select codcli into v_codcli from solot where codsolot = a_codsolot;

      insert into intraway.int_solot_itw
        (codsolot, codcli, estado, flagproc)
      values
        (a_codsolot, v_codcli, 2, 0);

      for c_ii in c_ins loop

        IF c_ii.id_interfase = cn_cm and a_opcion in (5, 6, 7) THEN
          if a_opcion in (5, 7) then

            v_id_estado := 1;
          elsif a_opcion = 6 then
            v_id_estado := 0;
          end if;

          SELECT DESCRIPCION
            INTO v_idMensajeCRM
            FROM OPERACION.OPEDD
           WHERE TIPOPEDD = 191
             AND CODIGON = 3;

          P_CM_MANAGER_MESSAGE(v_id_estado,
                               c_ii.id_cliente,
                               c_ii.id_producto,
                               c_ii.id_producto,
                               v_idMensajeCRM,
                               a_opcion,
                               a_codsolot,
                               p_resultado,
                               p_mensaje,
                               p_error,
                               a_enviar_itw,
                               c_ii.id_venta);
        END IF;

        if c_ii.id_interfase = cn_ep then

          BEGIN
            select distinct intraway.PQ_INTRAWAY_PROCESO.F_OBT_CODSRV_PRINC(a.codinssrv) CODSRV
              INTO v_codsrv_telefonia
              FROM SOLOTPTO A, TYSTABSRV C, insprd p
             WHERE a.codsolot = a_codsolot
               AND a.codsrvnue = c.codsrv
               and a.codinssrv = p.codinssrv
               AND a.codsrvnue = p.codsrv
               and p.estinsprd <> 3
               AND a.codinssrv = c_ii.codinssrv
               AND c.tipsrv in ('0004', '0059')
               AND p.flgprinc = 1
               AND p.fecini is not null;

          EXCEPTION
            WHEN OTHERS THEN
              v_mensaje := 'OPERACION.PQ_OPE_AVISO.P_INT_PROCESO, atendiendo la solot:' ||
                           a_codsolot ||
                           '. No se pudo obtener la configuración de Código Externo para el EP.' ||
                           sqlerrm;
              RAISE error_general;
          END;

          IF a_opcion in (5, 6, 8, 9) THEN
            v_id_estado := 2;
          ELSIF a_opcion = 7 THEN
            v_id_estado := 4;
          END IF;

          v_HomeExchangeCrmId := intraway.PQ_INTRAWAY_PROCESO.F_GET_NCOS(a_codsolot,
                                                                         v_codsrv_telefonia,
                                                                         a_opcion);

          pq_intraway.P_MTA_EP_ADMINISTRACION(v_id_Estado,
                                              c_ii.id_cliente,
                                              c_ii.id_producto,
                                              c_ii.id_producto,
                                              c_ii.id_producto_padre,
                                              c_ii.nroendpoint,
                                              c_ii.numero,
                                              v_HomeExchangeCrmId,
                                              a_opcion,
                                              a_codsolot,
                                              c_ii.codinssrv,
                                              p_resultado,
                                              p_mensaje,
                                              p_error,
                                              a_enviar_itw,
                                              c_ii.id_venta,
                                              c_ii.id_venta_padre);
        END IF;

        IF c_ii.id_interfase = cn_stb and a_opcion in (5, 6, 7) THEN
          IF a_opcion in (5, 7) THEN
            v_id_estado       := 4;
            v_sendtocontroler := 'TRUE';
          ELSIF a_opcion = 6 THEN
            v_id_estado       := 2;
            v_sendtocontroler := 'TRUE';
          END IF;

          PQ_INTRAWAY.P_STB_CREA_ESPACIO(V_ID_ESTADO,
                                         c_ii.id_cliente,
                                         c_ii.id_producto,
                                         c_ii.id_producto,
                                         c_ii.id_activacion,
                                         c_ii.codigo_ext,
                                         'BASICO',
                                         c_ii.modelo,
                                         v_sendtocontroler,
                                         a_opcion,
                                         a_codsolot,
                                         c_ii.codinssrv,
                                         p_resultado,
                                         p_mensaje,
                                         p_error,
                                         a_enviar_itw,
                                         c_ii.id_venta);

        END IF;
      end loop;

      RAISE error_no;
    END IF;

  end;

  procedure p_cm_manager_message(a_estado       in number,
                                 a_cliente      in vtatabcli.codcli%type,
                                 a_pidorigen    in number,
                                 a_pidactual    in number,
                                 a_idmensajecrm in varchar2,
                                 a_proceso      in int_mensaje_intraway.proceso%type,
                                 a_codsolot     in solot.codsolot%type,
                                 o_resultado    in out varchar2,
                                 o_mensaje      in out varchar2,
                                 o_error        in out number,
                                 a_enviar_itw   in number default 1,
                                 a_id_venta     in number default 0)

   is
  begin

    declare
      v_id_lote      number;
      v_id_interfaz  number;
      v_resultado    varchar2(10);
      v_mensaje      varchar(1000);
      v_fase         varchar2(10);
      v_null         varchar2(10);
      v_estado       varchar2(50);
      v_servicio     inssrv.idpaq%type;
      v_id_empresa   number;
      v_id_sistema   number;
      v_id_conexion  number;
      v_interface    int_interface.id_interface%type;
      v_error        number;
      v_cabecera_xml int_interface.cabecera_xml%type;
      v_asincrono    int_interface.asincrono%type;
      v_transaccion  int_interface.transaccion%type;
      v_cuenta_itw   number(3);
      v_flag_itw     number(1);
      v_subproceso   number(3);
    begin
      v_subproceso := 1;
      v_null       := null;
      v_error      := 0;
      v_interface  := intraway.pq_fnd_utilitario_interfaz.fnd_idinterface_cmm;
      v_fase       := intraway.pq_fnd_utilitario_interfaz.fnd_fase_validacion;
      v_estado     := intraway.pq_fnd_utilitario_interfaz.fnd_estado_cargado;
      v_servicio   := intraway.pq_fnd_utilitario_interfaz.fnd_idservicio_cmm;

      -- Obtener la empresa
      select codigon
        into v_id_empresa
        from operacion.opedd
       where tipopedd = 188
         and descripcion = 'ID_EMPRESA';
      -- Obtener la empresa
      select codigon
        into v_id_sistema
        from operacion.opedd
       where tipopedd = 188
         and descripcion = 'ID_SISTEMA';
      -- Obtener la empresa
      select codigon
        into v_id_conexion
        from operacion.opedd
       where tipopedd = 188
         and descripcion = 'ID_CONEXION';

      select id_interfaz_intraway_s.nextval into v_id_interfaz from dual;

      select int_lote_proceso_itw.nextval into v_id_lote from dual;

      select cabecera_xml, asincrono, transaccion
        into v_cabecera_xml, v_asincrono, v_transaccion
        from int_interface
       where id_interface = v_interface;

      insert into int_mensaje_intraway
        (id_interfaz,
         id_sistema,
         id_conexion,
         id_empresa,
         id_interfase,
         id_estado,
         id_cliente,
         id_servicio,
         id_producto,
         id_venta,
         id_producto_padre,
         id_promotor_padre,
         id_servicio_padre,
         id_venta_padre,
         cabecera_xml,
         asincrono,
         id_lote,
         desc_lote,
         transaccion,
         estado,
         mensaje,
         fecha_creacion,
         creado_por,
         proceso,
         codsolot,
         pidsga)
      values
        (v_id_interfaz,
         v_id_sistema,
         v_id_conexion,
         v_id_empresa,
         v_interface,
         a_estado,
         a_cliente,
         v_servicio,
         a_pidorigen,
         a_id_venta,
         0,
         0,
         0,
         a_id_venta,
         v_cabecera_xml,
         v_asincrono,
         v_id_lote,
         null,
         v_transaccion,
         v_estado,
         null,
         sysdate,
         'SGA',
         a_proceso,
         a_codsolot,
         a_pidactual);

      insert into int_mensaje_atributo_intraway
        (id_mensaje_intraway, nombre_atributo, valor_atributo)
        select v_id_interfaz, id_parametro, id_valor
          from int_interface_parametro
         where id_interface = v_interface;

      insert into int_mensaje_atributo_intraway
        (id_mensaje_intraway, nombre_atributo, valor_atributo)
      values
        (v_id_interfaz, 'idMensajeCRM', a_idmensajecrm);

      commit;
      if a_enviar_itw = 1 then
        pq_int_proceso_intraway.reproceso_maestro_interfaz('SGA',
                                                           v_id_lote,
                                                           v_null,
                                                           v_null,
                                                           v_null,
                                                           v_null,
                                                           v_resultado,
                                                           v_mensaje,
                                                           v_fase);

        select id_error, mensaje
          into v_error, v_mensaje
          from int_mensaje_intraway
         where id_interfaz = v_id_interfaz;

        if v_error = 0 and v_mensaje <> 'Operation Success' then
          v_error := -1;
        end if;

        update intraway.int_servicio_intraway
           set nromensajecm       = decode(a_estado, 0, 0, 1),
               tipomensajecm      = decode(a_estado, 0, null, a_idmensajecrm),
               fecha_modificacion = sysdate
         where id_producto = a_pidactual --El id_padre
           and id_interfase = cn_cm
           and id_venta = a_id_venta; --Cable Modem
        commit;

      else
        select count(*)
          into v_cuenta_itw
          from intraway.int_transaccionesxsolot
         where codsolot = a_codsolot;

        if v_cuenta_itw = 0 then
          v_flag_itw := 1;
        else
          v_flag_itw := 0;
        end if;

        if a_proceso in (5, 6, 7, 8, 9) then
          v_subproceso := 1;
        elsif (a_proceso in (3, 14)) then
          v_subproceso := 2;
        elsif (a_proceso in (20)) then
          v_subproceso := 3;
        end if;
        insert into intraway.int_transaccionesxsolot
          (codsolot,
           id_lote,
           id_interfase,
           id_estado,
           id_producto,
           flag,
           sendtocontroler,
           id_venta,
           pid_sga,
           id_producto_padre,
           id_venta_padre,
           codinssrv,
           tipomensajecm,
           estado,
           subproceso)
        values
          (a_codsolot,
           v_id_lote,
           v_interface,
           a_estado,
           a_pidorigen,
           v_flag_itw,
           'FALSE',
           a_id_venta,
           a_pidactual,
           0,
           0,
           null,
           a_idmensajecrm,
           0,
           v_subproceso);
        commit;

      end if;

      o_error     := v_error;
      o_resultado := v_resultado;
      o_mensaje   := v_mensaje;

    exception
      when others then
        o_resultado := pq_fnd_utilitario_interfaz.fnd_estado_error;
        o_mensaje   := sqlerrm;
        o_error     := sqlcode;
    end;
  end p_cm_manager_message;

  procedure p_genera_mensaje_itw(an_inicio number) is

    cursor c_serv is
      select *
        from ope_inscliente_rel a
       where a.seleccion = 1
         and estado in (1)
         and trunc(a.fecreg) = trunc(sysdate);

    cursor c_comxmsj(an_idservmens in number) is
      select c.idcomando,
             c.comando,
             c.orden,
             c.procedimiento,
             b.estado,
             c.id_interfase_base
        from ope_serviciomensaje_rel b, ope_comando_rel c
       where b.idservmens = c.idservmens
         and b.estado = 1
         and c.estado = 1
         and b.idservmens = an_idservmens
       order by c.orden asc;

    lr_int_mensaje_itw_cab     int_mensaje_itw_cab%rowtype;
    lr_int_comandoxmensaje_itw int_comandoxmensaje_itw%rowtype;
    lr_int_servicio_intraway   int_servicio_intraway%rowtype;
    lc_tipsrv                  tystipsrv.tipsrv%type;
    lc_dsctipsrv               tystipsrv.dsctipsrv%type;
    ln_idtranmensaje           int_mensaje_itw_cab.idtranmsj%type;
    ln_idservmens              ope_serviciomensaje_rel.idservmens%type;
    lc_resultado               varchar2(50);
    lc_mensaje                 varchar2(3000);
    lc_id_estado               varchar2(50);
    ln_error_proceso           number;
    ln_contador                number;
    ln_proceso                 number;

  begin

    for c_srv in c_serv loop

      ln_error_proceso := 0;
      ln_contador      := 0;

      select sq_idtranmsj.nextval into ln_idtranmensaje from dual;

      begin
        select a.tipsrv, b.dsctipsrv
          into lc_tipsrv, lc_dsctipsrv
          from inssrv a, tystipsrv b
         where a.codinssrv = c_srv.codinssrv
           and a.tipsrv = b.tipsrv;

        select a.idservmens
          into ln_idservmens
          from ope_serviciomensaje_rel a
         where a.idmensaje = c_srv.idmensaje
           and a.estado = 1
           and a.tipsrv = lc_tipsrv;
      exception
        when others then
          lc_mensaje       := 'No se pudo hallar servicio asociado a mensaje(Tabla OPE_SERVICIOMENSAJE_REL), para el SID: ' ||
                              to_char(c_srv.codinssrv) ||
                              ' de la familia de servicios: ' ||
                              lc_dsctipsrv || '(' || lc_tipsrv || ') ' ||
                              ', CODCLI: ' || c_srv.codcli ||
                              ', IDMENSAJE: ' || to_char(c_srv.idmensaje) ||
                              '. ERROR: ' || sqlerrm;
          ln_error_proceso := -1;
      end;

      if ln_error_proceso = 0 then
        lr_int_mensaje_itw_cab.codcli         := c_srv.codcli;
        lr_int_mensaje_itw_cab.codinssrv      := c_srv.codinssrv;
        lr_int_mensaje_itw_cab.idmensaje      := c_srv.idmensaje;
        lr_int_mensaje_itw_cab.idservmens     := ln_idservmens;
        lr_int_mensaje_itw_cab.idtranmsj      := ln_idtranmensaje;
        lr_int_mensaje_itw_cab.idtransmensaje := c_srv.idtransmensaje;
        lr_int_mensaje_itw_cab.tipsrv         := lc_tipsrv;

        --Insertar instancia de mensaje
        p_ins_mensaje(lr_int_mensaje_itw_cab, lc_resultado, lc_mensaje);

        if lc_resultado = 'OK' then

          for c_com in c_comxmsj(ln_idservmens) loop

            begin
              select *
                into lr_int_servicio_intraway
                from int_servicio_intraway
               where id_interfase = c_com.id_interfase_base
                 and codinssrv = c_srv.codinssrv
                 and estado = 1
                 and id_cliente = c_srv.codcli;
            exception
              when others then
                lc_mensaje       := 'Error al ubicar registro en int_servicio_intraway, para el SID: ' ||
                                    to_char(c_srv.codinssrv) ||
                                    ', CODCLI: ' || c_srv.codcli ||
                                    ' e Interface: ' ||
                                    c_com.id_interfase_base || '. Error: ' ||
                                    sqlerrm;
                ln_error_proceso := -1;
            end;

            if ln_error_proceso <> 0 then
              exit;
            end if;

            begin
              select b.valor
                into lc_id_estado
                from ope_comandoparametro_rel a, ope_parametros_det b
               where a.idparametro = b.idparametro
                 and a.idcomando = c_com.idcomando
                 and a.estado = 1
                 and b.parametro = 'id_estado';
            exception
              when others then
                lc_mensaje       := 'Error al ubicar parametro ID_ESTADO activo(estado = 1) para el IDMENSAJE: ' ||
                                    to_char(c_srv.idmensaje) ||
                                    ', y el IDCOMANDO: ' ||
                                    to_char(c_com.idcomando) || '. Error: ' ||
                                    sqlerrm;
                ln_error_proceso := -1;
            end;

            if ln_error_proceso <> 0 then
              exit;
            end if;

            lr_int_comandoxmensaje_itw.idtranmsj         := ln_idtranmensaje;
            lr_int_comandoxmensaje_itw.codinssrv         := c_srv.codinssrv;
            lr_int_comandoxmensaje_itw.idcomando         := c_com.idcomando;
            lr_int_comandoxmensaje_itw.id_interfase      := c_com.comando;
            lr_int_comandoxmensaje_itw.id_producto       := lr_int_servicio_intraway.id_producto;
            lr_int_comandoxmensaje_itw.id_producto_padre := lr_int_servicio_intraway.id_producto_padre;
            lr_int_comandoxmensaje_itw.id_venta          := lr_int_servicio_intraway.id_venta;
            lr_int_comandoxmensaje_itw.id_venta_padre    := lr_int_servicio_intraway.id_venta_padre;
            lr_int_comandoxmensaje_itw.pid_sga           := lr_int_servicio_intraway.pid_sga;
            lr_int_comandoxmensaje_itw.id_estado         := lc_id_estado;
            lr_int_comandoxmensaje_itw.orden             := c_com.orden;
            lr_int_comandoxmensaje_itw.Procedimiento     := c_com.procedimiento;
            --Insertar instancia de comandos por mensaje

            select codigon
              into ln_proceso
              from opedd, tipopedd
             where tipopedd.tipopedd = opedd.tipopedd
               and tipopedd.abrev = 'ITW_PROCESO';

            p_ins_comando_mensaje(lr_int_comandoxmensaje_itw,
                                  c_srv.codcli,
                                  ln_proceso,
                                  lc_resultado,
                                  lc_mensaje);

            if lc_resultado <> 'OK' then
              ln_error_proceso := -1;
              exit;
            end if;

            ln_contador := ln_contador + 1;
          end loop;

          --Validación de registro de comandos
          if ln_contador > 0 then
            if ln_error_proceso = 0 then
              begin
                update ope_inscliente_rel a
                   set a.estado = 2
                 where a.idtransmensaje = c_srv.idtransmensaje;

                commit;
              exception
                when others then
                  lc_mensaje := 'Error al actualizar OPE_INSCLIENTE_REL a estado 2. IDTRANSMENSAJE: ' ||
                                to_char(c_srv.idtransmensaje) ||
                                '. Error: ' || sqlerrm;
                  rollback;
                  intraway.pq_intraway.p_crea_mensaje_error(7777,
                                                            'p_genera_mensaje_itw',
                                                            sqlcode,
                                                            substr(lc_mensaje,
                                                                   1,
                                                                   3000));
              end;
            else
              rollback;
              intraway.pq_intraway.p_crea_mensaje_error(7777,
                                                        'p_genera_mensaje_itw',
                                                        sqlcode,
                                                        substr(lc_mensaje,
                                                               1,
                                                               3000));
            end if;
          else
            lc_mensaje := 'No existe configurado comandos para el IDMENSAJE: ' ||
                          to_char(c_srv.idmensaje) ||
                          ' y que pertenece a la familia de servicios: ' ||
                          lc_dsctipsrv || '(' || lc_tipsrv || ') ' ||
                          '. Error: ' || sqlerrm;
            rollback;
            intraway.pq_intraway.p_crea_mensaje_error(7777,
                                                      'p_genera_mensaje_itw',
                                                      sqlcode,
                                                      substr(lc_mensaje,
                                                             1,
                                                             3000));
          end if;
        else
          rollback;
          intraway.pq_intraway.p_crea_mensaje_error(7777,
                                                    'p_genera_mensaje_itw',
                                                    sqlcode,
                                                    substr(lc_mensaje,
                                                           1,
                                                           3000));
        end if;
      else
        rollback;
        intraway.pq_intraway.p_crea_mensaje_error(7777,
                                                  'p_genera_mensaje_itw',
                                                  sqlcode,
                                                  substr(lc_mensaje,
                                                         1,
                                                         3000));
      end if;

    end loop;

  end;

  procedure p_ins_mensaje(ar_int_mensaje_itw_cab in int_mensaje_itw_cab%rowtype,
                          ac_resultado           out varchar2,
                          ac_mensaje             out varchar2) is
  begin

    insert into int_mensaje_itw_cab
      (idtranmsj,
       codcli,
       codinssrv,
       idmensaje,
       idservmens,
       tipsrv,
       idtransmensaje)
    values
      (ar_int_mensaje_itw_cab.idtranmsj,
       ar_int_mensaje_itw_cab.codcli,
       ar_int_mensaje_itw_cab.codinssrv,
       ar_int_mensaje_itw_cab.idmensaje,
       ar_int_mensaje_itw_cab.idservmens,
       ar_int_mensaje_itw_cab.tipsrv,
       ar_int_mensaje_itw_cab.idtransmensaje);

    ac_resultado := 'OK';
    ac_mensaje   := ar_int_mensaje_itw_cab.idtranmsj;

  exception
    when others then
      ac_resultado := 'ERROR';
      ac_mensaje   := sqlerrm;
  end;

  procedure p_ins_comando_mensaje(ar_int_comandoxmensaje_itw in int_comandoxmensaje_itw%rowtype,
                                  a_cliente                  in vtatabcli.codcli%type,
                                  a_proceso                  in number,
                                  o_resultado                in out varchar2,
                                  o_mensaje                  in out varchar2) is
    v_id_lote           number;
    v_id_interfaz       number;
    v_id_empresa        number;
    v_id_sistema        number;
    v_id_conexion       number;
    v_cuenta_itw        number(3);
    v_flag_itw          number(1);
    v_estado            varchar2(50);
    v_servicio          varchar2(50);
    v_cabecera_xml      int_interface.cabecera_xml%type;
    v_asincrono         int_interface.asincrono%type;
    v_transaccion       int_interface.transaccion%type;
    ln_iddettranmsj     int_comandoxmensaje_itw.iddettranmsj%type;
    ln_cuenta_atributos number;
    ll_codsolot_lote    number;
    put1                varchar2(4000);
    put2                varchar2(4000);
    l_interfaz          NUMBER;
    -- Para Revertir Inicio
    v_id_lote_rev number;
    -- Para Revertir Fin
    --Ini 2.0
    ln_count_equipo number;
    --Fin 2.0

    cursor cde is
      select '<' || nombre_atributo || '>' || valor_atributo || '</' ||
             nombre_atributo || '>' val
        from int_mensaje_atributo_intraway
       where id_mensaje_intraway = l_interfaz;

  begin
    v_estado         := intraway.pq_fnd_utilitario_interfaz.fnd_estado_cargado;
    v_servicio       := intraway.pq_fnd_utilitario_interfaz.fnd_idservicio_cmm;
    ll_codsolot_lote := 0;

    -- Obtener la empresa
    select codigon
      into v_id_empresa
      from operacion.opedd
     where tipopedd = 188
       and descripcion = 'ID_EMPRESA';
    -- Obtener la empresa
    select codigon
      into v_id_sistema
      from operacion.opedd
     where tipopedd = 188
       and descripcion = 'ID_SISTEMA';
    -- Obtener la empresa
    select codigon
      into v_id_conexion
      from operacion.opedd
     where tipopedd = 188
       and descripcion = 'ID_CONEXION';

    select id_interfaz_intraway_s.nextval into v_id_interfaz from dual;

    select int_lote_proceso_itw.nextval into v_id_lote from dual;

    select cabecera_xml, asincrono, transaccion
      into v_cabecera_xml, v_asincrono, v_transaccion
      from int_interface
     where id_interface = ar_int_comandoxmensaje_itw.id_interfase;

    insert into int_mensaje_intraway
      (id_interfaz,
       id_sistema,
       id_conexion,
       id_empresa,
       id_interfase,
       id_estado,
       id_cliente,
       id_servicio,
       id_producto,
       id_venta,
       id_producto_padre,
       id_promotor_padre,
       id_servicio_padre,
       id_venta_padre,
       cabecera_xml,
       asincrono,
       id_lote,
       desc_lote,
       transaccion,
       estado,
       mensaje,
       fecha_creacion,
       creado_por,
       proceso,
       pidsga,
       codinssrv)
    values
      (v_id_interfaz,
       v_id_sistema,
       v_id_conexion,
       v_id_empresa,
       ar_int_comandoxmensaje_itw.id_interfase,
       ar_int_comandoxmensaje_itw.id_estado,
       a_cliente,
       v_servicio,
       ar_int_comandoxmensaje_itw.id_producto,
       ar_int_comandoxmensaje_itw.id_venta,
       0,
       0,
       0,
       ar_int_comandoxmensaje_itw.id_venta_padre,
       v_cabecera_xml,
       v_asincrono,
       v_id_lote,
       null,
       v_transaccion,
       v_estado,
       null,
       sysdate,
       'SGA',
       a_proceso,
       ar_int_comandoxmensaje_itw.pid_sga,
       ar_int_comandoxmensaje_itw.codinssrv);

    -- Ini 1.1.
    /*    insert into int_mensaje_atributo_intraway
    (id_mensaje_intraway, nombre_atributo, valor_atributo)
    select v_id_interfaz, id_parametro, id_valor
      from int_interface_parametro
     where id_interface = ar_int_comandoxmensaje_itw.id_interfase;*/

    select count(1)
      into ln_cuenta_atributos
      from ope_comandoparametro_rel a, ope_parametros_det b
     where a.idparametro = b.idparametro
       and a.idcomando = ar_int_comandoxmensaje_itw.idcomando
       and a.flg_xml = 1
       and a.estado = 1;
    -- Fin 1.1.

    if ln_cuenta_atributos > 0 then

      insert into int_mensaje_atributo_intraway
        (id_mensaje_intraway, nombre_atributo, valor_atributo)
        select v_id_interfaz, b.parametro, a.valor
          from ope_comandoparametro_rel a, ope_parametros_det b
         where a.idparametro = b.idparametro
           and a.idcomando = ar_int_comandoxmensaje_itw.idcomando
           and a.flg_xml = 1
           and a.estado = 1;

      insert into int_mensaje_atributo_intraway
        (id_mensaje_intraway, nombre_atributo)
        select v_id_interfaz, 'Custom1' from dummy_ope;

      insert into int_mensaje_atributo_intraway
        (id_mensaje_intraway, nombre_atributo, valor_atributo)
        select v_id_interfaz, 'NoBoot', 'AUTO' from dummy_ope;

      select sq_iddettranmsj.nextval into ln_iddettranmsj from dual;

      select count(1)
        into v_cuenta_itw
        from intraway.int_comandoxmensaje_itw
       where idtranmsj = ar_int_comandoxmensaje_itw.idtranmsj;

      if v_cuenta_itw = 0 then
        v_flag_itw := 1;
      else
        v_flag_itw := 0;
      end if;

      --  Ini  1.1
      -- Ini 2.0 Se comenta cursor, se validará con existencia de registros
      /*      DECLARE
        cursor c_portal_cautivo is
          select distinct s.id_cliente,
                          s.id_producto,
                          s.macaddress,
                          s.codsolot,
                          e.nroserie,
                          e.cod_sap,
                          g.tipequ,
                          g.descripcion
            from intraway.int_servicio_intraway s,
                 maestro_Series_equ             e,
                 almtabmat                      f,
                 tipequ                         g
           where e.cod_sap = trim(f.cod_sap)
             and f.codmat = g.codtipequ(+)
             and (trim(upper(replace(replace(s.macaddress, ':', ''),
                                     '.',
                                     ''))) = e.mac1 or
                 trim(upper(replace(replace(s.macaddress, ':', ''),
                                     '.',
                                     ''))) = e.mac2 or
                 trim(upper(replace(replace(s.macaddress, ':', ''),
                                     '.',
                                     ''))) = e.mac3 or
                 trim(upper(replace(replace(s.macaddress, ':', ''),
                                     '.',
                                     ''))) = e.nroserie)
             and s.ID_INTERFASE = cn_cm --- Cable moden
             and s.id_cliente = a_cliente
             and s.id_producto = ar_int_comandoxmensaje_itw.id_producto
             and g.flg_portal_cautivo = '1';

      BEGIN
        FOR c_pc IN c_portal_cautivo LOOP

          EXIT WHEN c_portal_cautivo%NOTFOUND;*/

      select count(1)
        into ln_count_equipo
        from intraway.int_servicio_intraway s,
             maestro_Series_equ             e,
             almtabmat                      f,
             tipequ                         g
       where e.cod_sap = trim(f.cod_sap)
         and f.codmat = g.codtipequ(+)
         and trim(upper(replace(replace(s.macaddress, ':'), '-'))) in
             (e.mac1, e.mac2, e.mac3, e.nroserie)
         and s.ID_INTERFASE = cn_cm --- Cable moden
         and s.id_cliente = a_cliente
         and s.id_producto = ar_int_comandoxmensaje_itw.id_producto
         and g.flg_portal_cautivo = '1';

      if ln_count_equipo > 0 then
        --Fin 2.0
        l_interfaz := v_id_interfaz;
        -- nuevo
        put2 := '';
        for cc in cde loop
          put2 := put2 || cc.val;
        end loop;
        put1 := '<' || v_cabecera_xml || '>' || put2 || '</' ||
                v_cabecera_xml || '>';

        insert into intraway.int_envio
          (CODSOLOT,
           FECHA_CREACION,
           PROCESO,
           CODINSSRV,
           ID_LOTE,
           ID_INTERFAZ,
           ID_CONEXION,
           ID_INTERFASE,
           ID_ESTADO,
           ASINCRONO,
           FECHA_DIFERIDO,
           ID_CLIENTE,
           ID_EMPRESA,
           ID_VENTA,
           ID_VENTA_PADRE,
           ID_SERVICIO,
           ID_PRODUCTO,
           ID_SERVICIO_PADRE,
           ID_PRODUCTO_PADRE,
           ID_PROMOTOR,
           CABECERA_XML,
           TIPTRABAJO,
           CODCLI)
        values
          (ll_codsolot_lote,
           sysdate,
           a_proceso,
           ar_int_comandoxmensaje_itw.codinssrv,
           v_id_lote,
           v_id_interfaz,
           v_id_conexion,
           ar_int_comandoxmensaje_itw.id_interfase,
           0,
           v_asincrono,
           '',
           a_cliente,
           v_id_empresa,
           ar_int_comandoxmensaje_itw.id_venta,
           ar_int_comandoxmensaje_itw.id_venta_padre,
           v_servicio,
           ar_int_comandoxmensaje_itw.id_producto,
           0,
           0,
           0,
           put1,
           0,
           a_cliente);

        -- Para Revertir Inicio
        select int_lote_proceso_itw.nextval into v_id_lote_rev from dual;

        insert into intraway.int_envio
          (CODSOLOT,
           FECHA_CREACION,
           PROCESO,
           CODINSSRV,
           ID_LOTE,
           ID_INTERFAZ,
           ID_CONEXION,
           ID_INTERFASE,
           ID_ESTADO,
           ASINCRONO,
           FECHA_DIFERIDO,
           ID_CLIENTE,
           ID_EMPRESA,
           ID_VENTA,
           ID_VENTA_PADRE,
           ID_SERVICIO,
           ID_PRODUCTO,
           ID_SERVICIO_PADRE,
           ID_PRODUCTO_PADRE,
           ID_PROMOTOR,
           CABECERA_XML,
           TIPTRABAJO,
           CODCLI,
           ID_LOTE_REVIERTE)
        values
          (ll_codsolot_lote,
           sysdate,
           5,
           ar_int_comandoxmensaje_itw.codinssrv,
           v_id_lote_rev,
           v_id_interfaz,
           v_id_conexion,
           ar_int_comandoxmensaje_itw.id_interfase,
           1,
           v_asincrono,
           '',
           a_cliente,
           v_id_empresa,
           ar_int_comandoxmensaje_itw.id_venta,
           ar_int_comandoxmensaje_itw.id_venta_padre,
           v_servicio,
           ar_int_comandoxmensaje_itw.id_producto,
           0,
           0,
           0,
           put1,
           0,
           a_cliente,
           v_id_lote);
        -- Para Revertir Fin

        COMMIT;
        --Ini 2.0

        /*END LOOP;

        EXCEPTION
          WHEN OTHERS THEN
            ROLLBACK;
        END;*/
        --Fin 2.0
        --  Fin  1.1

        insert into intraway.int_comandoxmensaje_itw
          (iddettranmsj,
           idtranmsj,
           codinssrv,
           idcomando,
           id_interfase,
           id_estado,
           id_lote,
           id_producto,
           id_producto_padre,
           id_venta,
           id_venta_padre,
           pid_sga,
           orden,
           procedimiento,
           flag)
        values
          (ln_iddettranmsj,
           ar_int_comandoxmensaje_itw.idtranmsj,
           ar_int_comandoxmensaje_itw.codinssrv,
           ar_int_comandoxmensaje_itw.idcomando,
           ar_int_comandoxmensaje_itw.id_interfase,
           ar_int_comandoxmensaje_itw.id_estado,
           v_id_lote,
           ar_int_comandoxmensaje_itw.id_producto,
           ar_int_comandoxmensaje_itw.id_producto_padre,
           ar_int_comandoxmensaje_itw.id_venta,
           ar_int_comandoxmensaje_itw.id_venta_padre,
           ar_int_comandoxmensaje_itw.pid_sga,
           ar_int_comandoxmensaje_itw.orden,
           ar_int_comandoxmensaje_itw.procedimiento,
           v_flag_itw);
        commit; --2.0
        o_resultado := 'OK';
        o_mensaje   := ln_iddettranmsj;
        --Ini 2.0
      else
        o_resultado := 'El cliente no cuenta con un equipo compatible con Portal Cautivo';
      end if;
      --Fin 2.0

    else
      o_resultado := 'ERROR';
      o_mensaje   := 'No está configurado atributos dinamicos(flg_xml=1) para el Comando:' ||
                     to_char(ar_int_comandoxmensaje_itw.idcomando) ||
                     'Interface: ' ||
                     to_char(ar_int_comandoxmensaje_itw.id_interfase);

    end if;
  exception
    when others then
      o_resultado := pq_fnd_utilitario_interfaz.fnd_estado_error;
      o_mensaje   := sqlerrm;
  end;

  procedure p_proc_comando_mensaje is

    ln_error         number;
    ls_texto         int_mensaje_intraway.texto%type;
    ln_error_proceso number;
    ls_mensaje       varchar2(3000);
    le_error exception;
    le_error2 exception;
    ls_id_conexion     int_mensaje_intraway .id_conexion%type;
    ls_sql_error       varchar2(3200);
    ln_cntenv          number;
    ln_prienv          number;
    ln_prxenv          number;
    ls_descripcion_msj varchar2(200);
    ln_orden           number;
    ln_cantidad        number;
    ln_num_total       number;
    ln_num_ejecutado   number;

    cursor c_valida is
      select b.idfac, a.idtranmsj
        from int_mensaje_itw_cab a, ope_inscliente_rel b
       where a.estado in (0)
         and a.flagproc = 0
         and a.idtransmensaje = b.idtransmensaje;

    cursor c_mensaje is
      select *
        from int_mensaje_itw_cab a
       where a.estado in (1, 2)
         and a.flagproc = 0;

    cursor c_comando_mensaje(an_idtranmensaje in number) is
      select *
        from intraway.int_comandoxmensaje_itw a
       where a.estado in (0, 1, 2)
         and a.idtranmsj = an_idtranmensaje
       order by a.orden asc;

  begin
    begin
      select valor
        into ln_cntenv
        from constante
       where constante = 'CNT_ENV_ITW';

      for c_val in c_valida loop
        select count(1)
          into ln_cantidad
          from cxctabfac
         where idfac = c_val.idfac
           and estfac not in ('02', '04');

        if ln_cantidad = 1 then
          update int_mensaje_itw_cab
             set estado = 4
           where idtranmsj = c_val.idtranmsj;
        else
          update int_mensaje_itw_cab
             set estado = 1
           where idtranmsj = c_val.idtranmsj;
        end if;
        commit;
      end loop;

      for c_msj in c_mensaje loop

        for c_com_msj in c_comando_mensaje(c_msj.idtranmsj) loop

          begin
            update intraway.int_mensaje_itw_cab a
               set a.estado = 2
             where a.idtranmsj = c_msj.idtranmsj
               and a.estado <> 2;
          exception
            when others then
              ls_mensaje       := 'Error al actualizar int_mensaje_itw_cab: 2 ' ||
                                  sqlerrm;
              ln_error_proceso := -1;
          end;

          if c_com_msj.estado = 0 then

            if c_com_msj.id_interfase = 628 then

              if c_com_msj.flag = 1 then

                --pq_int_proceso_intraway.procesa_interfaz('SGA',c_com_msj.id_lote,ls_resultado,ls_mensaje);

                ln_error_proceso := 0;
                begin
                  select nvl(e.id_conexion, 0),
                         nvl(e.mensaje, ''),
                         e.id_error,
                         nvl(e.texto, '')
                    into ls_id_conexion, ls_mensaje, ln_error, ls_texto
                    from int_mensaje_intraway e
                   where e.id_lote = c_com_msj.id_lote;
                exception
                  when others then
                    ls_id_conexion   := 0;
                    ls_mensaje       := 'No se encontró el id_conexión para el id_lote: ' ||
                                        to_char(c_com_msj.id_lote) || '. ' ||
                                        ls_mensaje || ' ' || ls_texto;
                    ln_error_proceso := -1;
                end;
                --
                if ln_error is not null then
                  --si es nulo no ha procesado por lote aun
                  --
                  if ln_error_proceso = 0 then
                    if ln_error = 0 and ls_mensaje <> 'Operation Success' then
                      ln_error := -1;
                    end if;

                    if ln_error = 0 then
                      begin
                        update intraway.int_servicio_intraway
                           set nromensajecm       = decode(c_com_msj.id_estado,
                                                           0,
                                                           0,
                                                           1),
                               fecha_modificacion = sysdate
                         where id_producto = c_com_msj.id_producto
                           and id_interfase = cn_cm
                           and id_cliente = c_msj.codcli
                           and id_venta = nvl(c_com_msj.id_venta, 0);

                        ln_error_proceso := 0;

                      exception
                        when others then
                          ls_mensaje       := 'Error al actualizar Servicios Intraway: 1 ' ||
                                              sqlerrm;
                          ln_error_proceso := -1;
                          ln_error         := -1;
                      end;

                      begin
                        update intraway.int_comandoxmensaje_itw
                           set estado       = 3,
                               mensaje      = ls_mensaje,
                               id_error_env = ln_error,
                               id_error_rsp = ln_error,
                               fecmod       = sysdate,
                               usumod       = user,
                               envio        = nvl(envio, 0) + 1,
                               flag         = 0
                         where id_lote = c_com_msj.id_lote;
                      exception
                        when others then
                          ls_mensaje       := 'Error al actualizar int_comandoxmensaje_itw: 3 ' ||
                                              sqlerrm;
                          ln_error_proceso := -1;
                      end;
                      begin
                        select min(orden)
                          into ln_orden
                          from intraway.int_comandoxmensaje_itw
                         where flag = 0
                           and estado <> 3
                           and idtranmsj = c_com_msj.idtranmsj;

                        update intraway.int_comandoxmensaje_itw
                           set flag = 1, usumod = user, fecmod = sysdate
                         where idtranmsj = c_com_msj.idtranmsj
                           and orden = ln_orden;

                        --se actualiza cabecera
                        select count(1)
                          into ln_num_total
                          from intraway.int_comandoxmensaje_itw
                         where idtranmsj = c_com_msj.idtranmsj;

                        select count(1)
                          into ln_num_ejecutado
                          from intraway.int_comandoxmensaje_itw
                         where idtranmsj = c_com_msj.idtranmsj
                           and flag = 0
                           and estado = 3; --ejecutado

                        if ln_num_ejecutado = ln_num_total then
                          update intraway.int_mensaje_itw_cab i
                             set i.flagproc = 1
                           where i.idtranmsj = c_msj.idtranmsj;
                        end if;
                        --
                      exception
                        when others then
                          ln_orden := -1;
                      end;
                    else
                      begin
                        --Actualizar a estado con error
                        update intraway.int_comandoxmensaje_itw
                           set estado       = 2,
                               mensaje      = ls_mensaje,
                               id_error_env = ln_error,
                               id_error_rsp = ln_error,
                               fecmod       = sysdate,
                               usumod       = user,
                               envio        = nvl(envio, 0) + 1
                         where id_lote = c_com_msj.id_lote;

                        ln_error_proceso := 0;

                      exception
                        when others then
                          ls_sql_error     := 'Error al actualizar int_comandoxmensaje_itw: 2 ' ||
                                              sqlerrm;
                          ln_error_proceso := -1;
                      end;
                    end if;
                  else
                    begin
                      --Actualizar a estado con error
                      update intraway.int_comandoxmensaje_itw
                         set estado       = 2,
                             mensaje      = ls_mensaje,
                             id_error_env = ln_error,
                             id_error_rsp = ln_error,
                             fecmod       = sysdate,
                             usumod       = user,
                             envio        = nvl(envio, 0) + 1
                       where id_lote = c_com_msj.id_lote;

                      ln_error_proceso := 0;

                    exception
                      when others then
                        ls_sql_error     := 'Error al actualizar int_comandoxmensaje_itw: 2 ' ||
                                            sqlerrm;
                        ln_error_proceso := -1;
                    end;
                  end if;
                  --
                end if;
                --
              end if;
            end if;
          elsif c_com_msj.estado = 2 then
            select valor
              into ln_prienv
              from constante
             where constante = 'PRI_ENV_ITW';

            select valor
              into ln_prxenv
              from constante
             where constante = 'PRX_ENV_ITW';

            if c_com_msj.envio = ln_cntenv then
              if c_com_msj.id_interfase in (628) then
                ln_error_proceso := 0;

                update intraway.int_mensaje_itw_cab i
                   set i.flagproc = 1,
                       i.mensaje  = 'Se procesó ' || ln_cntenv ||
                                    ' veces el mismo comando, pero el error continúa.'
                 where i.idtranmsj = c_msj.idtranmsj;

                select descripcion
                  into ls_descripcion_msj
                  from ope_mensajes_mae a
                 where a.idmensaje = c_msj.idmensaje;

                opewf.pq_send_mail_job.p_send_mail('Error al procesar Mensaje: ' ||
                                                   ls_descripcion_msj ||
                                                   '. Transacción: ' ||
                                                   c_msj.idtranmsj,
                                                   'DL-PE-ITSoportealNegocio@claro.com.pe',
                                                   'Ocurrió error al procesar el idlote:' ||
                                                   c_com_msj.id_lote ||
                                                   'Se procesó ' ||
                                                   ln_cntenv ||
                                                   ' veces el mismo comando y el error continua.');

              end if;
            else

              if (c_com_msj.envio = 1 and
                 (sysdate - c_com_msj.fecmod) * 1440 >= ln_prienv) or
                 (c_com_msj.envio > 1 and c_com_msj.envio < ln_cntenv and
                 (sysdate - c_com_msj.fecmod) * 1440 >= ln_prxenv) then

                if c_com_msj.id_interfase = 628 then
                  if c_com_msj.flag = 1 then

                    --pq_int_proceso_intraway.procesa_interfaz('SGA',c_com_msj.id_lote,ls_resultado,ls_mensaje);

                    begin
                      select nvl(e.id_conexion, 0),
                             nvl(e.mensaje, ''),
                             nvl(e.texto, '')
                        into ls_id_conexion, ls_mensaje, ls_texto
                        from int_mensaje_intraway e
                       where e.id_lote = c_com_msj.id_lote;
                    exception
                      when others then
                        ls_id_conexion   := 0;
                        ls_mensaje       := 'No se encontró el id_conexión para el id_lote.' ||
                                            ls_mensaje || ' ' || ls_texto;
                        ln_error_proceso := -1;
                    end;

                    if ln_error_proceso = 0 then
                      if ln_error = 0 and ls_mensaje <> 'Operation Success' then
                        ln_error := -1;
                      end if;
                      --
                      if ln_error is not null then
                        --si es nulo no ha procesado por lote aun
                        --
                        if ln_error = 0 then
                          begin
                            update intraway.int_servicio_intraway
                               set nromensajecm       = decode(c_com_msj.id_estado,
                                                               0,
                                                               0,
                                                               1),
                                   fecha_modificacion = sysdate
                             where id_producto = c_com_msj.id_producto
                               and id_interfase = cn_cm
                               and id_cliente = c_msj.codcli
                               and id_venta = nvl(c_com_msj.id_venta, 0);

                            ln_error_proceso := 0;

                          exception
                            when others then
                              ls_mensaje       := 'Error al actualizar Servicios Intraway: 1 ' ||
                                                  sqlerrm;
                              ln_error_proceso := -1;
                              ln_error         := -1;
                          end;
                          begin
                            --Actualizar la int_transaccionesxsolot a estado con le_error
                            update intraway.int_comandoxmensaje_itw
                               set estado  = 3,
                                   envio   = nvl(envio, 0) + 1,
                                   fecmod  = sysdate,
                                   usumod  = user,
                                   mensaje = ls_mensaje,
                                   flag    = 0
                             where id_lote = c_com_msj.id_lote;

                            ln_error_proceso := 0;

                          exception
                            when others then
                              ls_mensaje       := 'Error al actualizar int_comandoxmensaje_itw: 3 ' ||
                                                  sqlerrm;
                              ln_error_proceso := -1;
                          end;

                          begin
                            select min(orden)
                              into ln_orden
                              from intraway.int_comandoxmensaje_itw
                             where flag = 0
                               and estado <> 3
                               and idtranmsj = c_com_msj.idtranmsj;

                            update intraway.int_comandoxmensaje_itw
                               set flag   = 1,
                                   usumod = user,
                                   fecmod = sysdate
                             where idtranmsj = c_com_msj.idtranmsj
                               and orden = ln_orden;
                          exception
                            when others then
                              ln_orden := -1;
                          end;
                        else
                          begin
                            --Actualizar a estado con error
                            update intraway.int_comandoxmensaje_itw
                               set estado       = 2,
                                   mensaje      = ls_mensaje,
                                   id_error_env = ln_error,
                                   id_error_rsp = ln_error,
                                   fecmod       = sysdate,
                                   usumod       = user,
                                   envio        = nvl(envio, 0) + 1
                             where id_lote = c_com_msj.id_lote;

                            ln_error_proceso := 0;

                          exception
                            when others then
                              ls_sql_error     := 'le_error al actualizar int_comandoxmensaje_itw: 2 ' ||
                                                  sqlerrm;
                              ln_error_proceso := -1;
                          end;
                        end if;
                        --
                      end if;
                      --
                    else
                      begin
                        --Actualizar a estado con error
                        update intraway.int_comandoxmensaje_itw
                           set estado       = 2,
                               mensaje      = ls_mensaje,
                               id_error_env = ln_error,
                               id_error_rsp = ln_error,
                               fecmod       = sysdate,
                               usumod       = user,
                               envio        = nvl(envio, 0) + 1
                         where id_lote = c_com_msj.id_lote;

                        ln_error_proceso := 0;

                      exception
                        when others then
                          ls_sql_error     := 'le_error al actualizar int_comandoxmensaje_itw: 2 ' ||
                                              sqlerrm;
                          ln_error_proceso := -1;
                      end;
                    end if;
                  end if;
                end if;
              end if;
            end if;
          end if;
          --Manejo de errores
          if ln_error_proceso = 0 then
            commit;
          else
            rollback;
            ls_mensaje := substr('Ha ocurrido un error procesando el id_lote: ' ||
                                 c_com_msj.id_lote || ' Error:' ||
                                 ls_mensaje,
                                 1,
                                 3000);
            intraway.pq_intraway.p_crea_mensaje_error(7777,
                                                      'p_proc_comando_mensaje',
                                                      sqlcode,
                                                      ls_mensaje);

          end if;
        end loop;
      end loop;

    exception
      when no_data_found then
        opewf.pq_send_mail_job.p_send_mail('p_proc_comando_mensaje',
                                           'DL-PE-ITSoportealNegocio@claro.com.pe',
                                           'Ha ocurrido un problema, no se ha configurado el número máximo de intentos de reenvío');
    end;
  exception
    when others then
      rollback;
      intraway.pq_intraway.p_crea_mensaje_error(7777,
                                                'p_proc_comando_mensaje',
                                                sqlcode,
                                                ls_mensaje);

  end;

  procedure p_revierte_comando_mensaje(a_iddettranmsj in int_comandoxmensaje_itw.iddettranmsj%type,
                                       a_proceso      in number,
                                       a_enviar_itw   in number default 1,
                                       o_resultado    in out varchar2,
                                       o_mensaje      in out varchar2,
                                       o_error        in out number) is
    v_id_lote                  number;
    v_id_interfaz              number;
    v_id_empresa               number;
    v_id_sistema               number;
    v_id_conexion              number;
    v_error                    number;
    v_cuenta_itw               number(3);
    v_flag_itw                 number(1);
    v_fase                     varchar2(10);
    v_null                     varchar2(10);
    v_estado                   varchar2(50);
    v_servicio                 varchar2(50);
    v_mensaje                  varchar2(1000);
    v_resultado                varchar2(10);
    v_cabecera_xml             int_interface.cabecera_xml%type;
    v_asincrono                int_interface.asincrono%type;
    v_transaccion              int_interface.transaccion%type;
    ln_iddettranmsj            int_comandoxmensaje_itw.iddettranmsj%type;
    lr_int_comandoxmensaje_itw int_comandoxmensaje_itw%rowtype;
    lc_codcli                  vtatabcli.codcli%type;
    an_idmsj                   number;
    an_estado                  number;
    -- Para Revertir Inicio
    an_idlote_rev number;
    -- Para Revertir Fin

  begin
    v_null     := null;
    v_error    := 0;
    v_estado   := intraway.pq_fnd_utilitario_interfaz.fnd_estado_cargado;
    v_servicio := intraway.pq_fnd_utilitario_interfaz.fnd_idservicio_cmm;
    v_fase     := intraway.pq_fnd_utilitario_interfaz.fnd_fase_validacion;

    select *
      into lr_int_comandoxmensaje_itw
      from int_comandoxmensaje_itw a
     where a.iddettranmsj = a_iddettranmsj;

    select a.codcli
      into lc_codcli
      from int_mensaje_itw_cab a
     where a.idtranmsj = lr_int_comandoxmensaje_itw.idtranmsj;

    -- Obtener la empresa
    select codigon
      into v_id_empresa
      from operacion.opedd
     where tipopedd = 188
       and descripcion = 'ID_EMPRESA';
    -- Obtener la empresa
    select codigon
      into v_id_sistema
      from operacion.opedd
     where tipopedd = 188
       and descripcion = 'ID_SISTEMA';
    -- Obtener la empresa
    select codigon
      into v_id_conexion
      from operacion.opedd
     where tipopedd = 188
       and descripcion = 'ID_CONEXION';

    select id_interfaz_intraway_s.nextval into v_id_interfaz from dual;

    select int_lote_proceso_itw.nextval into v_id_lote from dual;

    select cabecera_xml, asincrono, transaccion
      into v_cabecera_xml, v_asincrono, v_transaccion
      from int_interface
     where id_interface = lr_int_comandoxmensaje_itw.id_interfase;

    insert into int_mensaje_intraway
      (id_interfaz,
       id_sistema,
       id_conexion,
       id_empresa,
       id_interfase,
       id_estado,
       id_cliente,
       id_servicio,
       id_producto,
       id_venta,
       id_producto_padre,
       id_promotor_padre,
       id_servicio_padre,
       id_venta_padre,
       cabecera_xml,
       asincrono,
       id_lote,
       desc_lote,
       transaccion,
       estado,
       mensaje,
       fecha_creacion,
       creado_por,
       proceso,
       pidsga,
       codinssrv)
    values
      (v_id_interfaz,
       v_id_sistema,
       v_id_conexion,
       v_id_empresa,
       lr_int_comandoxmensaje_itw.id_interfase,
       decode(lr_int_comandoxmensaje_itw.id_estado, 0, 1, 0),
       lc_codcli,
       v_servicio,
       lr_int_comandoxmensaje_itw.id_producto,
       lr_int_comandoxmensaje_itw.id_venta,
       0,
       0,
       0,
       lr_int_comandoxmensaje_itw.id_venta_padre,
       v_cabecera_xml,
       v_asincrono,
       v_id_lote,
       null,
       v_transaccion,
       v_estado,
       null,
       sysdate,
       'SGA',
       a_proceso,
       lr_int_comandoxmensaje_itw.pid_sga,
       lr_int_comandoxmensaje_itw.codinssrv);

    insert into int_mensaje_atributo_intraway
      (id_mensaje_intraway, nombre_atributo, valor_atributo)
      select v_id_interfaz, id_parametro, id_valor
        from int_interface_parametro
       where id_interface = lr_int_comandoxmensaje_itw.id_interfase;

    insert into int_mensaje_atributo_intraway
      (id_mensaje_intraway, nombre_atributo, valor_atributo)
      select v_id_interfaz, b.parametro, b.valor
        from ope_comandoparametro_rel a, ope_parametros_det b
       where a.idparametro = b.idparametro
         and a.idcomando = lr_int_comandoxmensaje_itw.idcomando
         and a.flg_xml = 1
         and a.estado = 1;

    commit;

    if a_enviar_itw = 1 then

      select estado
        into an_estado
        from int_comandoxmensaje_itw
       where IDDETTRANMSJ = a_iddettranmsj;

      if an_estado <> 5 then

        -- Para Revertir Inicio
        select id_lote
          into an_idlote_rev
          from int_comandoxmensaje_itw
         where IDDETTRANMSJ = a_iddettranmsj;

        select id_lote
          into v_id_lote
          from intraway.int_envio
         where ID_LOTE_REVIERTE = an_idlote_rev
           and id_estado = 0;

        -- Para Revertir Fin

        --Envio de comando a Intraway
        pq_int_proceso_intraway.reproceso_maestro_interfaz('SGA',
                                                           v_id_lote,
                                                           v_null,
                                                           v_null,
                                                           v_null,
                                                           v_null,
                                                           v_resultado,
                                                           v_mensaje,
                                                           v_fase);

        --Obtener el resultado de la interfase
        select id_error, mensaje
          into v_error, v_mensaje
          from int_mensaje_intraway
         where id_interfaz = v_id_interfaz;

        if v_error = 0 and v_mensaje <> 'Operation Success' then
          v_error := -1;
        else
          select idtranmsj
            into an_idmsj
            from int_comandoxmensaje_itw
           where IDDETTRANMSJ = a_iddettranmsj;

          update int_mensaje_itw_cab
             set estado = 0
           where idtranmsj = an_idmsj;
          commit;
        end if;
      else
        v_error := -1;
      end if;

    else
      select sq_iddettranmsj.nextval into ln_iddettranmsj from dual;

      select count(1)
        into v_cuenta_itw
        from intraway.int_comandoxmensaje_itw
       where idtranmsj = lr_int_comandoxmensaje_itw.idtranmsj;

      if v_cuenta_itw = 0 then
        v_flag_itw := 1;
      else
        v_flag_itw := 0;
      end if;

      insert into intraway.int_comandoxmensaje_itw
        (iddettranmsj,
         idtranmsj,
         codinssrv,
         idcomando,
         id_interfase,
         id_estado,
         id_lote,
         id_producto,
         id_producto_padre,
         id_venta,
         id_venta_padre,
         pid_sga,
         orden,
         procedimiento,
         flag)
      values
        (ln_iddettranmsj,
         lr_int_comandoxmensaje_itw.idtranmsj,
         lr_int_comandoxmensaje_itw.codinssrv,
         lr_int_comandoxmensaje_itw.idcomando,
         lr_int_comandoxmensaje_itw.id_interfase,
         lr_int_comandoxmensaje_itw.id_estado,
         v_id_lote,
         lr_int_comandoxmensaje_itw.id_producto,
         lr_int_comandoxmensaje_itw.id_producto_padre,
         lr_int_comandoxmensaje_itw.id_venta,
         lr_int_comandoxmensaje_itw.id_venta_padre,
         lr_int_comandoxmensaje_itw.pid_sga,
         lr_int_comandoxmensaje_itw.orden,
         lr_int_comandoxmensaje_itw.procedimiento,
         v_flag_itw);
      commit;
    end if;

    o_resultado := v_resultado;
    o_mensaje   := v_mensaje;
    o_error     := v_error;
  exception
    when others then
      o_resultado := pq_fnd_utilitario_interfaz.fnd_estado_error;
      o_mensaje   := sqlerrm;
      o_error     := sqlcode;
  end;

  procedure p_enviacomando(ln_idlote    number,
                           ls_interfase int_comandoxmensaje_itw.id_interfase%type,
                           o_resultado  in out varchar2,
                           o_mensaje    in out varchar2,
                           o_error      in out number) is
    v_null      varchar2(10);
    v_mensaje   varchar2(1000);
    v_resultado varchar2(10);
    an_idlote   number;
    v_fase      varchar2(10);
    v_error     number;
  begin
    v_null    := null;
    an_idlote := ln_idlote;
    v_fase    := intraway.pq_fnd_utilitario_interfaz.fnd_fase_validacion;
    --Envio de comando a Intraway
    pq_int_proceso_intraway.reproceso_maestro_interfaz('SGA',
                                                       an_idlote,
                                                       v_null,
                                                       v_null,
                                                       v_null,
                                                       v_null,
                                                       v_resultado,
                                                       v_mensaje,
                                                       v_fase);

    --Obtener el resultado de la interfase
    select id_error, mensaje
      into v_error, v_mensaje
      from int_mensaje_intraway
     where id_lote = an_idlote
       and id_interfase = ls_interfase;

    if v_error = 0 and
       v_mensaje not in ('Operation Success', 'Check GetActivity') then
      v_error := -1;
    end if;

    o_resultado := v_resultado;
    o_mensaje   := v_mensaje;
    o_error     := v_error;

  end;

  procedure p_revisadetalle_comando(an_inicio number) is

    ln_cantidad number;
    an_estados  number;

    cursor c_cabecera is
      select *
        from int_mensaje_itw_cab
       where trunc(fecreg) = trunc(sysdate);

    cursor c_detalle(an_idtranmsj number) is
      select * from int_comandoxmensaje_itw where idtranmsj = an_idtranmsj;

  begin

    for c_cab in c_cabecera loop

      select count(1)
        into ln_cantidad
        from int_comandoxmensaje_itw
       where idtranmsj = c_cab.idtranmsj;

      an_estados := 0;
      for c_det in c_detalle(c_cab.idtranmsj) loop
        if c_det.estado = 3 then
          an_estados := an_estados + 1;
        end if;
      end loop;

      if ln_cantidad = an_estados then
        update int_mensaje_itw_cab
           set estado = 3
         where IDTRANMSJ = c_cab.idtranmsj;

      end if;
      commit;
    end loop;
  end;

  function f_obtiene_datos(an_codinssrv number) return number is
    an_res_codinssrv number;
  begin
    begin
      select codinssrv
        into an_res_codinssrv
        from inssrv
       where numslc =
             (select numslc from inssrv where codinssrv = an_codinssrv)
         and tipsrv = (select opedd.codigoc
                         from opedd, tipopedd
                        where tipopedd.tipopedd = opedd.tipopedd
                          and tipopedd.abrev = 'OPE_INTERNET');
    exception
      when no_data_found then
        an_res_codinssrv := an_codinssrv;
    end;

    return an_res_codinssrv;
  end;
  --Ini 1.1
  procedure p_proceso_enviomanual(as_codcli     marketing.vtatabcli.codcli%type,
                                  an_proceso    varchar2,
                                  an_idproducto intraway.int_servicio_intraway.id_producto%type,
                                  an_codinssrv  operacion.inssrv.codinssrv%type,
                                  an_sersut     collections.cxctabfac.sersut%type, --2.0
                                  an_numsut     collections.cxctabfac.numsut%type, --2.0
                                  as_resultado  out varchar2) is

    ls_resultado varchar2(4000);
    error_envio_cliente exception;
    ln_incidence    number; --2.0
    ln_incidence_ok number; --2.0
    ln_valintenvio  number; --4.0

  begin

    if an_idproducto is null then
      ls_resultado := 'No se envío el ID_producto a Intraway, no se enviará el comando';
      raise error_envio_cliente;
    end if;

    /**************************************************************************/
    --Proceso de envio de comando
    begin
      --Ini 2.0
      Select count(1) into ln_valintenvio from constante where constante = 'OPE_AVISOIW' and valor = 1;
      
      ln_incidence := f_val_incidence(as_codcli, an_sersut, an_numsut);

      if ln_incidence > 0 then

        ln_incidence_ok := f_val_estado_incidence(as_codcli,
                                                  an_sersut,
                                                  an_numsut);
        if ln_incidence_ok = 0 then
          --Fin 2.0
          if ln_valintenvio = 0 Then --4.0
            p_enviar_comando_pc(an_codinssrv,
                                cn_cm_int,
                                as_codcli,
                                an_idproducto,
                                an_proceso, /* L:Limpieza / R:Reenvio*/
                                null,
                                null,
                                ls_resultado);
          End If;
          --Ini 2.0
        else
          as_resultado := 'No se pudo enviar el comando. El cliente se encuentra con una factura reclamada y en proceso de evaluación';
        end if;
      else
        if ln_valintenvio = 0 Then --4.0
          p_enviar_comando_pc(an_codinssrv,
                              cn_cm_int,
                              as_codcli,
                              an_idproducto,
                              an_proceso, /* L:Limpieza / R:Reenvio*/
                              null,
                              null,
                              ls_resultado);
         End If;
      end if;
      --Fin 2.0
      as_resultado := ls_resultado;
    exception
      when others then
        as_resultado := 'No se pudo enviar el comando de Portal Cautivo' || ' ' ||
                        sqlerrm;
    end;
  exception
    when error_envio_cliente then
      as_resultado := ls_resultado;
    when others then
      rollback;
      as_resultado := sqlerrm;
  end;

  function f_obtiene_idproceso(as_parametro varchar2) return number is

    ln_parametro number;
  begin
    select codigon
      into ln_parametro
      from opedd, tipopedd
     where tipopedd.tipopedd = opedd.tipopedd
       and tipopedd.abrev = as_parametro;

    return ln_parametro;
  exception
    when others then
      return null;
  end;

  function f_obtiene_parametro(as_parametro varchar2) return number is

    ln_parametro number;
  begin
    select codigon
      into ln_parametro
      from operacion.opedd
     where tipopedd = 188
       and descripcion = as_parametro;

    return ln_parametro;
  exception
    when others then
      return null;
  end;

  procedure p_procesa_parametros(an_proceso    out number,
                                 as_idconexion out varchar2,
                                 as_idempresa  out varchar2,
                                 as_resultado  out varchar2) is
    error_proceso exception;
    ls_resultado varchar2(4000);
  begin

    /**************************************************************************/
    --Se obtiene el IDProceso de Intraway
    an_proceso := f_obtiene_idproceso('ITW_PROCESO');
    if an_proceso is null then
      ls_resultado := 'Falta configurar el IDProceso en la configuración de Tipos y Estados';
      raise error_proceso;
    end if;
    /**************************************************************************/
    --Se obtiene el IDConexion
    as_idconexion := f_obtiene_parametro('ID_CONEXION');
    if an_proceso is null then
      ls_resultado := 'No se configuró el IDConexión en Tipos y Estados';
      raise error_proceso;
    end if;
    /**************************************************************************/
    -- Se obtiene el IDEmpresa
    as_idempresa := f_obtiene_parametro('ID_EMPRESA');
    if as_idempresa is null then
      ls_resultado := 'No se configuró el IDEmpresa en Tipos y Estados';
      raise error_proceso;
    end if;

    ls_resultado := 'OK';
    as_resultado := ls_resultado;

  exception
    when error_proceso then
      as_resultado := ls_resultado;
    when others then
      as_resultado := 'ERROR';
  end p_procesa_parametros;

  procedure p_armar_xml(an_idinterfaz number, as_resultado out varchar2) is
  begin
    /**************************************************************************/
    --Registros para armar el XML
    insert into int_mensaje_atributo_intraway
      (id_mensaje_intraway, nombre_atributo, valor_atributo)
    --Ini 2.0
      select an_idinterfaz, p.parametro, c.valor
        from ope_mensajes_mae         a,
             ope_serviciomensaje_rel  s,
             ope_comando_rel          o,
             ope_comandoparametro_rel c,
             ope_parametros_det       p
       where a.idmensaje = s.idmensaje
         and o.idservmens = s.idservmens
         and c.idcomando = o.idcomando
         and c.idparametro = p.idparametro
         and a.mensaje = 'AVISO DE PAGO'
         and p.parametro = 'idMensajeCRM'
         and o.id_interfase_base = cn_cm
         and c.flg_xml = 1
         and c.estado = 1;
    /*  Se comenta
    select an_idinterfaz, b.parametro, a.valor
      from ope_comandoparametro_rel a, ope_parametros_det b
     where a.idparametro = b.idparametro
       and a.idcomando = cn_comando
       and a.flg_xml = 1
       and a.estado = 1;
    */
    --Fin 2.0
    insert into int_mensaje_atributo_intraway
      (id_mensaje_intraway, nombre_atributo)
      select an_idinterfaz, 'Custom1' from dummy_ope;

    insert into int_mensaje_atributo_intraway
      (id_mensaje_intraway, nombre_atributo, valor_atributo)
      select an_idinterfaz, 'NoBoot', 'AUTO' from dummy_ope;
    commit;
    as_resultado := 'OK';
  exception
    when others then
      as_resultado := 'No se insertaron los registros para armar el XML';
      rollback;
  end p_armar_xml;

  procedure p_ins_int_envio(ar_int_envio intraway.int_envio%ROWTYPE,
                            as_resultado out varchar2) is

  begin
    insert into intraway.int_envio
      (codsolot,
       fecha_creacion,
       proceso,
       codinssrv,
       id_lote,
       id_interfaz,
       id_conexion,
       id_interfase,
       id_estado,
       asincrono,
       fecha_diferido,
       id_cliente,
       id_empresa,
       id_venta,
       id_venta_padre,
       id_servicio,
       id_producto,
       id_servicio_padre,
       id_producto_padre,
       id_promotor,
       cabecera_xml,
       tiptrabajo,
       codcli,
       id_lote_revierte)
    values
      (ar_int_envio.codsolot,
       ar_int_envio.fecha_creacion,
       ar_int_envio.proceso,
       ar_int_envio.codinssrv,
       ar_int_envio.id_lote,
       ar_int_envio.id_interfaz,
       ar_int_envio.id_conexion,
       ar_int_envio.id_interfase,
       ar_int_envio.id_estado,
       ar_int_envio.asincrono,
       ar_int_envio.fecha_diferido,
       ar_int_envio.id_cliente,
       ar_int_envio.id_empresa,
       ar_int_envio.id_venta,
       ar_int_envio.id_venta_padre,
       ar_int_envio.id_servicio,
       ar_int_envio.id_producto,
       ar_int_envio.id_servicio_padre,
       ar_int_envio.id_producto_padre,
       ar_int_envio.id_promotor,
       ar_int_envio.cabecera_xml,
       ar_int_envio.tiptrabajo,
       ar_int_envio.codcli,
       ar_int_envio.id_lote_revierte);
    commit;
    as_resultado := 'OK';
  exception
    when others then
      as_resultado := 'No se insertó el registro en la tabla int_envio';
      rollback;
  end p_ins_int_envio;

  procedure p_arma_cab_xml(as_idinterfase  intraway.int_interface.id_interface%type,
                           as_cabecera_xml out intraway.int_interface.cabecera_xml%type,
                           an_asincrono    out intraway.int_interface.asincrono %type,
                           as_resultado    out varchar2) is

  begin
    select cabecera_xml, asincrono
      into as_cabecera_xml, an_asincrono
      from intraway.int_interface
     where id_interface = as_idinterfase;
    as_resultado := 'OK';
  exception
    when others then
      as_resultado := 'No se obtuvo la cabecera del XML para la interfaz 628';
  end p_arma_cab_xml;

  --2.0 Se elimina función f_obtiene_valor_xml

procedure p_enviar_comando_pc(as_codinssrv   inssrv.codinssrv%type,
                                as_idinterfase intraway.int_envio.id_interfase%type,
                                as_codcli      marketing.vtatabcli.codcli%type,
                                as_idproducto  intraway.int_envio.id_producto%type,
                                an_proceso     varchar2,
			        an_tiptrabajo  number,
				an_id_oac      number,
                                as_resultado   out varchar2) is

    ll_codsolot_lote    number := 0;
    ls_idconexion       varchar2(30);
    ln_estado_limpieza  number := 0;
    ln_estado_reenvio   number := 1;
    ln_asincrono        number;
    ls_idempresa        varchar2(30);
    put1                varchar2(2000);
    put2                varchar2(2000);
    ln_proceso          number;
    ls_cabecera_xml     varchar2(200);
    ln_idinterfaz       number;
    ln_idinterfaz2      number;
    ln_servicio         number;
    ln_proceso_ejecutar number := 5;
    ln_idlote           intraway.int_envio.id_lote%type;
    ls_resultado        varchar2(2000);
    error_portal_cautivo exception;
    lr_int_envio intraway.int_envio%ROWTYPE;

    cursor cabecera is
      select '<' || nombre_atributo || '>' || valor_atributo || '</' ||
             nombre_atributo || '>' val
        from int_mensaje_atributo_intraway
       where id_mensaje_intraway = ln_idinterfaz2;

  begin
    /**************************************************************************/
    --Procesamos constantes
    p_procesa_parametros(ln_proceso,
                         ls_idconexion,
                         ls_idempresa,
                         ls_resultado);

    if ls_resultado <> 'OK' then
      ls_resultado := ls_resultado;
      raise error_portal_cautivo;
    end if;

    /**************************************************************************/
    --Se arma la cabecera del XML
    p_arma_cab_xml(as_idinterfase,
                   ls_cabecera_xml,
                   ln_asincrono,
                   ls_resultado);

    if ls_resultado <> 'OK' then
      ls_resultado := ls_resultado;
      raise error_portal_cautivo;
    end if;
    /**************************************************************************/
    --Se obtiene el secuencial de int_mensaje_atributo_intraway
    begin
      select id_interfaz_intraway_s.nextval
        into ln_idinterfaz
        from dummy_ope;
    exception
      when others then
        ls_resultado := 'Error al calcular el secuencial de int_mensaje_atributo_intraway';
        raise error_portal_cautivo;
    end;
    /**************************************************************************/
    ln_servicio := intraway.pq_fnd_utilitario_interfaz.fnd_idservicio_cmm;
    /**************************************************************************/
    --Registros para armar el XML
    p_armar_xml(ln_idinterfaz, ls_resultado);
    if ls_resultado <> 'OK' then
      ls_resultado := 'No se insertaron los registros para armar el XML';
      raise error_portal_cautivo;
    end if;
    /**************************************************************************/
    ln_idinterfaz2 := ln_idinterfaz;

    put2 := '';
    for cc in cabecera loop
      put2 := put2 || cc.val;
    end loop;
    put1 := '<' || ls_cabecera_xml || '>' || put2 || '</' ||
            ls_cabecera_xml || '>';
    /**************************************************************************/
    --Obtenemos el IDLote
    select int_lote_proceso_itw.nextval into ln_idlote from dual;
    /**************************************************************************/
    if an_proceso = 'R' then
      lr_int_envio.PROCESO   := ln_proceso_ejecutar;
      lr_int_envio.ID_ESTADO := ln_estado_reenvio;
    elsif an_proceso = 'L' then
      lr_int_envio.PROCESO   := ln_proceso;
      lr_int_envio.ID_ESTADO := ln_estado_limpieza;
    end if;
    /**************************************************************************/
    --Insertamos la int_envio para la ejecución de Intraway

    --INI 3.0	
	if an_id_oac is not null then
		lr_int_envio.CODSOLOT          := an_id_oac;
	else	
		lr_int_envio.CODSOLOT          := ll_codsolot_lote;
	end if;	
    --FIN 3.0	
    lr_int_envio.fecha_creacion    := sysdate;
    lr_int_envio.CODINSSRV         := as_codinssrv;
    lr_int_envio.ID_LOTE           := ln_idlote;
    lr_int_envio.ID_INTERFAZ       := ln_idinterfaz;
    lr_int_envio.ID_CONEXION       := ls_idconexion;
    lr_int_envio.ID_INTERFASE      := as_idinterfase;
    lr_int_envio.ASINCRONO         := ln_asincrono;
    lr_int_envio.FECHA_DIFERIDO    := '';
    lr_int_envio.ID_CLIENTE        := as_codcli;
    lr_int_envio.ID_EMPRESA        := ls_idempresa;
    lr_int_envio.ID_VENTA          := 0;
    lr_int_envio.ID_VENTA_PADRE    := 0;
    lr_int_envio.ID_SERVICIO       := ln_servicio;
    lr_int_envio.ID_PRODUCTO       := as_idproducto;
    lr_int_envio.ID_SERVICIO_PADRE := 0;
    lr_int_envio.ID_PRODUCTO_PADRE := 0;
    lr_int_envio.ID_PROMOTOR       := 0;
    lr_int_envio.CABECERA_XML      := put1;
    lr_int_envio.TIPTRABAJO        := an_tiptrabajo;
    lr_int_envio.CODCLI            := as_codcli;
    lr_int_envio.id_lote_revierte  := 0;

    p_ins_int_envio(lr_int_envio, ls_resultado);

    --INI 3.0	
    if ls_resultado <> 'OK' then
      ls_resultado := 'No se insertó el registro en la tabla int_envio';
      raise error_portal_cautivo;
    end if;
    --FIN 3.0	

    if an_proceso = 'R' then
      as_resultado := 'Proceso de reenvío exitoso, en un momento se enviará el comando al cliente.';
    elsif an_proceso = 'L' then
      as_resultado := 'Proceso de limpieza exitoso, en un momento se enviará el comando al cliente.';
    end if;

  exception
    when error_portal_cautivo then
      as_resultado := ls_resultado;
    when others then
      rollback;
      as_resultado := SQLERRM;
  end p_enviar_comando_pc;
  --Fin 1.1

  --Ini 2.0
  procedure p_procesa_registros(an_caso       in operacion.ope_segmentomercado_rel.idmensaje%type,
                                an_grupo      in operacion.ope_grupomenssol_det.idgrupo%type,
                                an_comando    in operacion.ope_inscliente_rel.idcomando%type,
                                an_orden      in operacion.ope_inscliente_rel.orden%type,
                                an_aplica_seg in number,
                                an_aplica_sol in number,
                                an_idlote     in number,
                                ls_codcli     in operacion.ope_inscliente_rel.codcli%type,
                                ls_nomcli     in operacion.ope_inscliente_rel.nomcli%type,
                                ls_idsolucion in operacion.ope_inscliente_rel.idsolucion%type,
                                ls_codinssrv  in operacion.inssrv.codinssrv%type,
                                ls_nomabr     in collections.cxctabfac.nomabr%type,
                                ls_idfac      in collections.cxctabfac.idfac%type,
                                ls_codsegmark in operacion.ope_segmentomercado_rel.codsegmark%type) is

    lr_ope_inscliente_rel operacion.ope_inscliente_rel%rowtype;
    ln_segmento           number;
    ln_solucion           number;

  begin

    -- el cliente tiene un codsegmark ya que aplica la condicion, buscamos en nuestros
    -- registros si esta el codsegmark configurado, si me bota diferente de cero existe
    select count(1)
      into ln_segmento
      from ope_segmentomercado_rel
     where idmensaje = an_caso
       and codsegmark = ls_codsegmark
       and estado = 1;

    -- busca solucion asociada en tabla

    select count(1)
      into ln_solucion
      from ope_grupomenssol_det
     where idgrupo = an_grupo
       and idsolucion = ls_idsolucion
       and estadosol = 1;

    if an_aplica_seg = 1 then

      if an_aplica_sol = 1 then

        -- existe valores en segmento de mercado y solucion
        if ln_segmento != 0 and ln_solucion != 0 then

          lr_ope_inscliente_rel.idgrupomensaje := an_grupo;
          lr_ope_inscliente_rel.idmensaje      := an_caso;
          lr_ope_inscliente_rel.idcomando      := an_comando;
          lr_ope_inscliente_rel.codcli         := ls_codcli;
          lr_ope_inscliente_rel.idmensseg      := ls_codsegmark;
          lr_ope_inscliente_rel.idestado       := 1;
          lr_ope_inscliente_rel.fecha_estado   := sysdate;
          lr_ope_inscliente_rel.seleccion      := 1;
          lr_ope_inscliente_rel.orden          := an_orden;
          lr_ope_inscliente_rel.nomcli         := ls_nomcli;
          lr_ope_inscliente_rel.id_lote        := an_idlote;
          lr_ope_inscliente_rel.fecha_creacion := sysdate;
          lr_ope_inscliente_rel.codinssrv      := ls_codinssrv;
          lr_ope_inscliente_rel.nomabr         := ls_nomabr;
          lr_ope_inscliente_rel.idsolucion     := ls_idsolucion;
          lr_ope_inscliente_rel.codtipo        := 1;
          lr_ope_inscliente_rel.idfac          := ls_idfac;

          p_ins_ope_inscliente_rel(lr_ope_inscliente_rel);

        end if;

      else
        --existe valores en segmento
        if ln_segmento != 0 then

          lr_ope_inscliente_rel.idgrupomensaje := an_grupo;
          lr_ope_inscliente_rel.idmensaje      := an_caso;
          lr_ope_inscliente_rel.idcomando      := an_comando;
          lr_ope_inscliente_rel.codcli         := ls_codcli;
          lr_ope_inscliente_rel.idmensseg      := ls_codsegmark;
          lr_ope_inscliente_rel.idestado       := 1;
          lr_ope_inscliente_rel.fecha_estado   := sysdate;
          lr_ope_inscliente_rel.seleccion      := 1;
          lr_ope_inscliente_rel.orden          := an_orden;
          lr_ope_inscliente_rel.nomcli         := ls_nomcli;
          lr_ope_inscliente_rel.id_lote        := an_idlote;
          lr_ope_inscliente_rel.fecha_creacion := sysdate;
          lr_ope_inscliente_rel.codinssrv      := ls_codinssrv;
          lr_ope_inscliente_rel.nomabr         := ls_nomabr;
          lr_ope_inscliente_rel.idsolucion     := 0;
          lr_ope_inscliente_rel.codtipo        := 1;
          lr_ope_inscliente_rel.idfac          := ls_idfac;

          p_ins_ope_inscliente_rel(lr_ope_inscliente_rel);

        end if;

      end if;

    else
      if an_aplica_sol = 1 then
        -- existen valores que cumplen condicion de solución
        if ln_solucion != 0 then
          lr_ope_inscliente_rel.idgrupomensaje := an_grupo;
          lr_ope_inscliente_rel.idmensaje      := an_caso;
          lr_ope_inscliente_rel.idcomando      := an_comando;
          lr_ope_inscliente_rel.codcli         := ls_codcli;
          lr_ope_inscliente_rel.idmensseg      := 0;
          lr_ope_inscliente_rel.idestado       := 1;
          lr_ope_inscliente_rel.fecha_estado   := sysdate;
          lr_ope_inscliente_rel.seleccion      := 1;
          lr_ope_inscliente_rel.orden          := an_orden;
          lr_ope_inscliente_rel.nomcli         := ls_nomcli;
          lr_ope_inscliente_rel.id_lote        := an_idlote;
          lr_ope_inscliente_rel.fecha_creacion := sysdate;
          lr_ope_inscliente_rel.codinssrv      := ls_codinssrv;
          lr_ope_inscliente_rel.nomabr         := ls_nomabr;
          lr_ope_inscliente_rel.idsolucion     := ls_idsolucion;
          lr_ope_inscliente_rel.codtipo        := 1;
          lr_ope_inscliente_rel.idfac          := ls_idfac;

          p_ins_ope_inscliente_rel(lr_ope_inscliente_rel);

        end if;

      else
        lr_ope_inscliente_rel.idgrupomensaje := an_grupo;
        lr_ope_inscliente_rel.idmensaje      := an_caso;
        lr_ope_inscliente_rel.idcomando      := an_comando;
        lr_ope_inscliente_rel.codcli         := ls_codcli;
        lr_ope_inscliente_rel.idmensseg      := 0;
        lr_ope_inscliente_rel.idestado       := 1;
        lr_ope_inscliente_rel.fecha_estado   := sysdate;
        lr_ope_inscliente_rel.seleccion      := 1;
        lr_ope_inscliente_rel.orden          := an_orden;
        lr_ope_inscliente_rel.nomcli         := ls_nomcli;
        lr_ope_inscliente_rel.id_lote        := an_idlote;
        lr_ope_inscliente_rel.fecha_creacion := sysdate;
        lr_ope_inscliente_rel.codinssrv      := ls_codinssrv;
        lr_ope_inscliente_rel.nomabr         := ls_nomabr;
        lr_ope_inscliente_rel.idsolucion     := 0;
        lr_ope_inscliente_rel.codtipo        := 1;
        lr_ope_inscliente_rel.idfac          := ls_idfac;

        p_ins_ope_inscliente_rel(lr_ope_inscliente_rel);

      end if;
    end if;

  exception
    when others then
      rollback;
  end p_procesa_registros;

  procedure p_ins_ope_inscliente_rel(ar_ope_inscliente_rel operacion.ope_inscliente_rel%rowtype) is

  begin

    insert into operacion.ope_inscliente_rel
      (idgrupomensaje,
       idmensaje,
       idcomando,
       codcli,
       idmensseg,
       idestado,
       fecha_estado,
       seleccion,
       orden,
       nomcli,
       mensaje_itw,
       id_lote,
       id_producto,
       id_interfase,
       fecha_creacion,
       fecha_activacion,
       fecha_modificacion,
       nomabr,
       id_activacion,
       codinssrv,
       idsolucion,
       codtipo,
       idfac)
    values
      (ar_ope_inscliente_rel.idgrupomensaje,
       ar_ope_inscliente_rel.idmensaje,
       ar_ope_inscliente_rel.idcomando,
       ar_ope_inscliente_rel.codcli,
       ar_ope_inscliente_rel.idmensseg,
       ar_ope_inscliente_rel.idestado,
       ar_ope_inscliente_rel.fecha_estado,
       ar_ope_inscliente_rel.seleccion,
       ar_ope_inscliente_rel.orden,
       ar_ope_inscliente_rel.nomcli,
       ar_ope_inscliente_rel.mensaje_itw,
       ar_ope_inscliente_rel.id_lote,
       ar_ope_inscliente_rel.id_producto,
       ar_ope_inscliente_rel.id_interfase,
       ar_ope_inscliente_rel.fecha_creacion,
       ar_ope_inscliente_rel.fecha_activacion,
       ar_ope_inscliente_rel.fecha_modificacion,
       ar_ope_inscliente_rel.nomabr,
       ar_ope_inscliente_rel.id_activacion,
       ar_ope_inscliente_rel.codinssrv,
       ar_ope_inscliente_rel.idsolucion,
       ar_ope_inscliente_rel.codtipo,
       ar_ope_inscliente_rel.idfac);
    commit;

  exception
    when others then
      rollback;
  end p_ins_ope_inscliente_rel;

  procedure p_ins_ope_inscliente_cab(p_idlote out operacion.ope_inscliente_cab.id_lote%type) is

  begin

    insert into ope_inscliente_cab
      (nombre, tipo)
    values
      ('LOTE ANTES VENCIMIENTO', 1);
    commit;

    select max(id_lote) into p_idlote from ope_inscliente_cab;

  exception
    when others then
      rollback;
  end p_ins_ope_inscliente_cab;

  function f_val_incidence(as_codcli in collections.cxctabfac.codcli%type,
                           as_sersut in collections.cxctabfac.sersut%type,
                           as_numsut in collections.cxctabfac.numsut%type)
    return number is

    ln_contar number;
  begin
    select count(1)
      into ln_contar
      from collections.cxctabfac c
     where c.recosi is not null
       AND c.codcli = as_codcli
       AND c.sersut = as_sersut
       AND c.numsut = as_numsut;

    return ln_contar;

  exception
    when others then
      return 0;
  end f_val_incidence;

  function f_val_estado_incidence(as_codcli in collections.cxctabfac.codcli%type,
                                  as_sersut in collections.cxctabfac.sersut%type,
                                  as_numsut in collections.cxctabfac.numsut%type)
    return number is

    ln_contar number;
  begin
    select count(1)
      into ln_contar
      from atccorp.incidence i, collections.cxctabfac fac
     where i.codincidence = fac.recosi
       and i.codstatus in (cn_codstatus_gen, cn_codstatus_pro) -- 1 generado, 2 en proceso
       and fac.codcli = as_codcli
       and fac.sersut = as_sersut
       and fac.numsut = as_numsut;

    return ln_contar;

  exception
    when others then
      return 0;
  end f_val_estado_incidence;

--Fin 2.0
end;
/
