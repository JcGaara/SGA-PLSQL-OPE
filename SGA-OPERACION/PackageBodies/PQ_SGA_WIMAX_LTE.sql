CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_SGA_WIMAX_LTE IS

  /*******************************************************************************************************
   NAME:       OPERACION.PQ_SGA_WIMAX
   PURPOSE:    Paquete de objetos necesarios para
               realizar la migración de WIMAX a LTE

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------
    1.0       --          --               Creación
  *******************************************************************************************************/

  -- Funcion que valida si es cliente WIMAX
  function f_val_cli_wimax (v_codcli marketing.vtatabcli.codcli%TYPE) return number is

  n_val_wix number;

  begin

    select count(distinct s.codsolot)
      into n_val_wix
      from solot s,
           solotpto pto,
           tystabsrv ser,
           producto p,
           (select o.codigon
              from tipopedd t, opedd o
             where t.tipopedd = o.tipopedd
               and t.abrev = 'IDPRODUCTOCONTINGENCIA'
               and o.codigon_aux = 4) xx
     where s.codsolot = pto.codsolot
       and pto.codsrvnue = ser.codsrv
       and ser.idproducto = p.idproducto
       and p.idproducto = xx.codigon
       and s.codcli = v_codcli
       and exists (select o.codigon
                         from tipopedd t, opedd o
                        where t.tipopedd = o.tipopedd
                          and t.abrev = 'PARBAJAWIMAX'
                          and o.abreviacion = 'ESTSOTBAJWIMAX'
                          and o.codigon = s.estsol)
       and exists (select o.codigoc
                         from tipopedd t, opedd o
                        where t.tipopedd = o.tipopedd
                          and t.abrev = 'PARBAJAWIMAX'
                          and o.abreviacion = 'TIPSRVBAJWIMAX'
                          and o.codigoc = s.tipsrv)
       and exists (select o.codigon
                         from tipopedd t, opedd o
                        where t.tipopedd = o.tipopedd
                          and t.abrev = 'PARBAJAWIMAX'
                          and o.abreviacion = 'TIPTRABAJWIMAX'
                          and o.codigon = s.tiptra);  

      return n_val_wix;
    exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit ||
                              'Error al validar cliente: Error de BD ORA - ' || sqlerrm || ' Linea (' || dbms_utility.format_error_backtrace || ')');
  end;
  
  function f_obtiene_sot_cli_wimax (v_codcli marketing.vtatabcli.codcli%TYPE) return number is

  ln_codsolot_wix number;

  begin

    select distinct s.codsolot
    into ln_codsolot_wix
      from solot s,
           solotpto pto,
           tystabsrv ser,
           producto p,
           (select o.codigon
              from tipopedd t, opedd o
             where t.tipopedd = o.tipopedd
               and t.abrev = 'IDPRODUCTOCONTINGENCIA'
               and o.codigon_aux = 4) xx
     where s.codsolot = pto.codsolot
       and pto.codsrvnue = ser.codsrv
       and ser.idproducto = p.idproducto
       and p.idproducto = xx.codigon
       and s.codcli = v_codcli
       and exists (select o.codigon
                         from tipopedd t, opedd o
                        where t.tipopedd = o.tipopedd
                          and t.abrev = 'PARBAJAWIMAX'
                          and o.abreviacion = 'ESTSOTBAJWIMAX'
                          and o.codigon = s.estsol)
       and exists (select o.codigoc
                         from tipopedd t, opedd o
                        where t.tipopedd = o.tipopedd
                          and t.abrev = 'PARBAJAWIMAX'
                          and o.abreviacion = 'TIPSRVBAJWIMAX'
                          and o.codigoc = s.tipsrv)
       and exists (select o.codigon
                         from tipopedd t, opedd o
                        where t.tipopedd = o.tipopedd
                          and t.abrev = 'PARBAJAWIMAX'
                          and o.abreviacion = 'TIPTRABAJWIMAX'
                          and o.codigon = s.tiptra);

      return ln_codsolot_wix;
      
    exception
    when others then
      return 0;
  end;
  
  procedure p_asoc_wimax_lte (av_linea    in   VARCHAR2, 
                              av_iccid    in   VARCHAR2, 
                              av_material in   VARCHAR2,
                              an_sot      in   number,
                              an_error    out number,
                              av_error    out varchar2) IS


    AV_SERNR                VARCHAR2(18);
    AN_DEPRI_IDDESCRIP_PROD NUMBER;
    AN_NRSII_IDNRO_SIMCARDS NUMBER;
    AN_EXISTE               NUMBER;
    AV_MSJ_ERROR            VARCHAR2(500);
    exception_general       EXCEPTION;
    AV_MATERIALES           VARCHAR2(18);
    ln_cod1                 number;
    lv_resul                varchar2(4000);
  begin

    an_error := 1;
    av_error := 'OK';
    AV_MATERIALES := LPAD(av_material,18,0);

    SELECT COUNT(1)
      INTO AN_EXISTE
      FROM SANS.ZNS_NRO_SIMCARDS@DBL_SANDB NS
     WHERE NS.NRO_TELEF = LPAD(TRIM(av_linea), 15, 0);

    IF AN_EXISTE = 0 THEN
      AV_MSJ_ERROR := 'LA LÍNEA NO SE ENCUENTRA REGISTRADA EN SANS';
      RAISE exception_general;
    ELSE
      SELECT NS.NRSII_IDNRO_SIMCARDS
        INTO AN_NRSII_IDNRO_SIMCARDS
        FROM SANS.ZNS_NRO_SIMCARDS@DBL_SANDB NS
       WHERE NS.NRO_TELEF = LPAD(av_linea, 15, 0);
    END IF;

   SELECT COUNT(1)
      INTO AN_EXISTE
      FROM SANS.ZNS_DESCRIP_PROD@DBL_SANDB D
     WHERE D.MATNR = AV_MATERIALES
        OR D.MATNR_OLD = AV_MATERIALES;

    IF AN_EXISTE = 0 THEN
      AV_MSJ_ERROR := 'EL MATERIAL NO SE ENCUENTRA REGISTRADO EN SANS';
      raise exception_general;
    ELSE
     SELECT D.DEPRI_IDDESCRIP_PROD
        INTO AN_DEPRI_IDDESCRIP_PROD
        FROM SANS.ZNS_DESCRIP_PROD@DBL_SANDB D
       WHERE D.MATNR = AV_MATERIALES;

     IF LENGTH(TRIM(SUBSTR(av_iccid, 1, 18))) <> 18 THEN
       AV_MSJ_ERROR := 'EL ICCID INGRESADO ES INCORRECTO, DEBE TENER 18 DIGITOS';
       raise exception_general;
     ELSE

       AV_SERNR := TRIM(SUBSTR(av_iccid, 1, 18));

       UPDATE SANS.ZNS_NRO_SIMCARDS@DBL_SANDB NS
               SET NS.SERNR                = AV_SERNR,
                   NS.DEPRI_IDDESCRIP_PROD = AN_DEPRI_IDDESCRIP_PROD,
                   NS.STNRI_IDSTAT_NRO_TEL = 11,
                   NS.NRSII_ELIMINADO      = 0
             WHERE NS.NRSII_IDNRO_SIMCARDS = AN_NRSII_IDNRO_SIMCARDS;

       INSERT INTO SANS.ZNS_HISTORIAL@DBL_SANDB H
              (H.NRSII_IDNRO_SIMCARDS,
               H.FECHA_CAMBIO,
               H.USUARIO,
               H.STNRI_IDSTAT_NRO_TEL,
               H.HISTD_FEC_CREACION,
               H.DEPRI_IDDESCRIP_PROD,
               H.SERNR)
            VALUES
              (AN_NRSII_IDNRO_SIMCARDS,
               TRUNC(SYSDATE),
               'USRWIMAXLTE',
               11,
               SYSDATE,
               AN_DEPRI_IDDESCRIP_PROD,
               AV_SERNR);
    END IF;
  END IF;
  
  av_error := 'Se asoció correctamente WIMAX con LTE.';
  operacion.pq_3play_inalambrico.p_log_3playi(an_sot, 'p_asoc_wimax_lte', av_error, null, ln_cod1, lv_resul);
  exception
    when exception_general then
      an_error := -1;
      av_error := AV_MSJ_ERROR;
      operacion.pq_3play_inalambrico.p_log_3playi(an_sot, 'p_asoc_wimax_lte', av_error, null, ln_cod1, lv_resul);
    when others then
      an_error := -1;
      av_error := 'Error al asociar WIMAX al LTE: Error de BD ORA - ' || sqlerrm || ' Linea (' || dbms_utility.format_error_backtrace || ')';
      operacion.pq_3play_inalambrico.p_log_3playi(an_sot, 'p_asoc_wimax_lte', av_error, null, ln_cod1, lv_resul);
  end;           

  procedure p_act_fact_sga_bscs(an_codsolot   number,
                                av_check_apli varchar2,
                                an_error      out number,
                                av_error      out varchar2) is
    ln_count number;

  begin

    an_error := 0;
    av_error := 'OK';
    select count(1)
      into ln_count
      from historico.log_proceso_3play l
     where l.codsolot = an_codsolot
       and l.nom_proceso = 'PARAM_FACT_LTE_WIMAX_ACT_BSCS';

    if ln_count = 0 then
      operacion.pq_3play_inalambrico.p_log_3playi(an_codsolot,
                                                  'PARAM_FACT_LTE_WIMAX_ACT_BSCS',
                                                  av_check_apli,
                                                  null,
                                                  an_error,
                                                  av_error);
    else
      update historico.log_proceso_3play l
         set l.des_mensaje = av_check_apli
       where l.codsolot = an_codsolot
         and l.nom_proceso = 'PARAM_FACT_LTE_WIMAX_ACT_BSCS';
    end if;
    commit;
  exception
    when others then
      an_error := -1;
      av_error := 'ERROR : ' || sqlerrm;
  end;

  function f_obt_act_fact_sga_bscs(an_codsolot number) return number is
    ln_flag number;
  begin
    select distinct l.des_mensaje
      into ln_flag
      from historico.log_proceso_3play l
     where l.codsolot = an_codsolot
       and l.nom_proceso = 'PARAM_FACT_LTE_WIMAX_ACT_BSCS';

    return to_number(nvl(ln_flag, 0));
  end;
end;
/