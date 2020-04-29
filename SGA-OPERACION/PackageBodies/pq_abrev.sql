create or replace package body operacion.pq_abrev is

  /******************************************************************************
     NOMBRE:       PQ_ABREV_ATC
     PROPOSITO:

     REVISIONES:
     Ver        Fecha        Autor               Solicitado por   Descripcion
     ---------  ----------  ---------------      --------------   ----------------------

      1.0       24/10/2013  Alfonso Perez Ramos  Hector Huaman   REQ-164553: Creacion
  *********************************************************************/

  function f_obt_valores_codsrv(av_lista  varchar2,
                                an_indice number,
                                ac_delim  varchar2) return varchar2 is
    lv_valor  varchar2(100);
    start_pos number;
    end_pos   number;
    delim     varchar2(10);
  begin
    delim := ac_delim;

    if an_indice = 1 then
      start_pos := 1;
    else
      start_pos := instr(av_lista, delim, 1, an_indice - 1);
      if start_pos = 0 then
        lv_valor := null;
        return lv_valor;
      else
        start_pos := start_pos + length(delim);
      end if;
    end if;

    end_pos := instr(av_lista, delim, start_pos, 1);

    if end_pos = 0 then
      lv_valor := substr(av_lista, start_pos);
      return lv_valor;
    else
      lv_valor := substr(av_lista, start_pos, end_pos - start_pos);
      return lv_valor;
    end if;
  exception
    when others then
      lv_valor := null;
      return lv_valor;
  end;

  function f_val_existe_codsrv(as_numslc in vtatabslcfac.numslc%type,
                               an_idprod in producto.idproducto%type,
                               an_iddet  in detalle_paquete.iddet%type)
    return number is
    ln_existe number;
  begin
    select count(t.codsrv)
      into ln_existe
      from vtadetptoenl    v,
           detalle_paquete dp,
           linea_paquete   lp,
           tystabsrv       t
     where v.numslc = as_numslc
       and v.idproducto = an_idprod
       and v.iddet = an_iddet
       and dp.idpaq = v.idpaq
       and dp.flgestado = 1
       and lp.iddet = dp.iddet
       and lp.flgestado = 1
       and dp.iddet = v.iddet
       and t.codsrv = lp.codsrv
       and t.estado = 1
       and t.abrev is not null
       and t.flg_wimax = 1;

    return ln_existe;
  exception
    when others then
      ln_existe := null;
      return ln_existe;
  end;

  function f_geterrores(k_id in number) return varchar2 is
    v_valor varchar2(250);
    ex_error exception;
  begin

    if k_id is null then
      raise ex_error;
    end if;

    select admpv_des_error
      into v_valor
      from atccorp.admpt_errores_cc
     where admpn_cod_error = k_id;

    return v_valor;
  exception
    when ex_error then
      return 'Ingrese el codigo del error.';
    when no_data_found then
      return 'No esta registrado el error.';
    when others then
      return substr(sqlerrm, 1, 250);
  end;

  procedure p_obtiene_det_serv(as_numslc   in vtatabslcfac.numslc%type,
                               an_idprod   in producto.idproducto%type,
                               an_iddet    in vtadetptoenl.iddet%type,
                               o_banwid    out tystabsrv.banwid%type,
                               o_abrev     out tystabsrv.abrev%type,
                               o_resultado out number,
                               o_mensaje   out varchar2) is
  begin

    select t.banwid, t.abrev
      into o_banwid, o_abrev
      from vtadetptoenl    v,
           detalle_paquete dp,
           linea_paquete   lp,
           tystabsrv       t
     where v.numslc = as_numslc
       and v.idproducto = an_idprod
       and v.iddet = an_iddet
       and dp.idpaq = v.idpaq
       and dp.flgestado = 1
       and lp.iddet = dp.iddet
       and lp.flgestado = 1
       and dp.iddet = v.iddet
       and t.codsrv = lp.codsrv
       and t.estado = 1
       and t.abrev is not null;

    o_mensaje   := 'Exito';
    o_resultado := 0;
  exception
    when no_data_found then
      o_resultado := -1;
      o_mensaje   := 'No se encontro configurado el Paquete de Venta';
    when others then
      o_resultado := -1;
      o_mensaje   := 'Error al Obtener Parametros de Paquete de Venta';
  end;

  procedure p_genera_transaccion_det(an_sid      in number,
                                     as_codcli   in varchar2,
                                     as_codsvr   in varchar2,
                                     av_id       in number,
                                     o_coderror  out number,
                                     o_descerror out varchar2) is
  begin

    o_coderror := 0;

    insert into atccorp.atc_servprom_det
      (id_trx, sid, codcli, codsrv)
    values
      (av_id, an_sid, as_codcli, as_codsvr);

  exception
    when others then
      o_coderror  := -1;
      o_descerror := f_geterrores(o_coderror) || substr(sqlerrm, 1, 250);
  end p_genera_transaccion_det;

  procedure p_actualiza_abrev(as_numslc   in varchar2,
                              as_abrevia  in varchar2,
                              o_resultado out number,
                              o_mensaje   out varchar2) is
  begin
    update vtatabslcfac set resumen = as_abrevia where numslc = as_numslc;
    commit;
    o_mensaje   := 'Exito';
    o_resultado := 0;
  exception
    when no_data_found then
      o_resultado := -1;
      o_mensaje   := 'No se encontro configurado parametros de SOT para Promociones de Fidelizacion';
    when others then
      o_resultado := -1;
      o_mensaje   := 'Error al Obtener Parametros de Sot de Promociones';

  end;

  procedure p_ejecuta_abreviatura(as_numslc   in vtatabslcfac.numslc%type,
                                  o_abrev     out varchar2,
                                  o_coderror  out number,
                                  o_descerror out varchar2) is

    ln_existe      number;
    ln_cantidad    number;
    ln_registros   number;
    ln_detalle     number;
    ln_forma       number;
    ln_codsolot    number;
    ln_intentos    number;
    ln_reintentos  number;
    lv_descripcion varchar2(100); --atccorp.atc_trx_promocion.observ%type;
    v_banwid       tystabsrv.banwid%type;
    v_abrev        tystabsrv.abrev%type;
    v_resultado    number;
    v_mensaje      varchar2(100);
    v_mensaje_ora  varchar2(100);
    ls_abrev       varchar2(100);
    an_pos         number;
    --Creamos el cursor con registros con estado: Alta Promoci?n OK.
    cursor cur_ptos_enlace is
      select * from vtadetptoenl where numslc = as_numslc;

    --Creamos el cursor con los servicios asociados
    cursor cur_det_abrev is
      select * from ATCCORP.ATC_ABREVIATURA_TMP;

  BEGIN

    ls_abrev := '';
    ln_forma := 0;
    delete from ATCCORP.ATC_ABREVIATURA_TMP;

    for reg_ptos in cur_ptos_enlace loop
      ln_intentos := 1;
      --verificamos existencia
      ln_existe := f_val_existe_codsrv(reg_ptos.numslc,
                                       reg_ptos.idproducto,
                                       reg_ptos.iddet);

      if ln_existe > 0 then

        p_obtiene_det_serv(reg_ptos.numslc,
                           reg_ptos.idproducto,
                           reg_ptos.iddet,
                           v_banwid,
                           v_abrev,
                           v_resultado,
                           v_mensaje);

        if v_resultado = 0 then
          ln_forma := 1;
          --Buscamos si existe registro en la tabla
          select count(1)
            into ln_cantidad
            from ATCCORP.ATC_ABREVIATURA_TMP
           where banwid = v_banwid
             and abrev = v_abrev;

          if ln_cantidad = 0 then
            insert into ATCCORP.ATC_ABREVIATURA_TMP
              (abrev, banwid, cantidad)
            values
              (v_abrev, v_banwid, 1);
          else
            select cantidad
              into ln_detalle
              from ATCCORP.ATC_ABREVIATURA_TMP
             where banwid = v_banwid
               and abrev = v_abrev;

            ln_detalle := ln_detalle + 1;

            update ATCCORP.ATC_ABREVIATURA_TMP
               set cantidad = ln_detalle
             where banwid = v_banwid
               and abrev = v_abrev;
          end if;
        end if;
      end if;
    end loop;

    if ln_forma = 1 then

      select count(1) into ln_registros from ATCCORP.ATC_ABREVIATURA_TMP;

      an_pos := 0;

      for reg_det in cur_det_abrev loop
        an_pos := an_pos + 1;
        if ln_registros = an_pos then
          ls_abrev := ls_abrev || '' || to_char(reg_det.cantidad) || '_' ||
                      reg_det.banwid || '' || reg_det.abrev;
        else
          ls_abrev := ls_abrev || '' || to_char(reg_det.cantidad) || '_' ||
                      reg_det.banwid || '' || reg_det.abrev || '_';
        end if;
      end loop;
    end if;

    delete from ATCCORP.ATC_ABREVIATURA_TMP;

    COMMIT;

    o_abrev    := ls_abrev;
    v_mensaje  := 'Exito';
    o_coderror := ln_forma;
  exception
    when others then
      o_coderror := -1;
  end p_ejecuta_abreviatura;

end pq_abrev;
/
