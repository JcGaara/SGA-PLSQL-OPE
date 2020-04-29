create or replace procedure operacion.sgass_val_vel_int_hfc(an_cod_id in number,
                                                            an_flag   out number,
                                                            an_error  out number,
                                                            av_error  out varchar2) is

  error_tipo_contrato EXCEPTION;
  error_motot_visita  EXCEPTION;
  ln_codsolot operacion.solot.codsolot%TYPE;
  error_no_sot EXCEPTION;
  ln_val_ctv_old NUMBER;
  ln_val_int_old NUMBER;
  ln_val_tlf_old NUMBER;
  ln_total_old   number;
  LV_VEL_IPFIJA  NUMBER;
  ln_vel_int_act number;

  FUNCTION f_val_tipsrv_old(an_codsolot operacion.solot.codsolot%TYPE,
                            av_tipsrv   tystipsrv.tipsrv%TYPE) RETURN NUMBER IS
    ln_return NUMBER;
  BEGIN
    SELECT COUNT(DISTINCT i.tipsrv)
      INTO ln_return
      FROM solot s, solotpto pto, inssrv i, insprd p, tystabsrv t
     WHERE s.codsolot = pto.codsolot
       AND pto.codinssrv = i.codinssrv
       AND i.codinssrv = p.codinssrv
       AND p.codsrv = t.codsrv
       AND s.codsolot = an_codsolot
       AND operacion.pq_conciliacion_hfc.f_get_no_es_srv_principal(i.tipsrv,
                                                                   t.idproducto,
                                                                   p.flgprinc) = 1
       AND i.tipsrv = av_tipsrv;

    RETURN ln_return;
  exception
    when others then
      RETURN 0;
  END;

  function f_val_velocidad_int(an_codsolot in solot.codsolot%type)
    return number is
    lv_capacidad configuracion_itw.capacidad%type;
  begin
    select distinct iw.capacidad
      into lv_capacidad
      from solotpto pto, inssrv ins, tystabsrv t, configuracion_itw iw
     where pto.codinssrv = ins.codinssrv
       and ins.codsrv = t.codsrv
       and TO_NUMBER(t.codigo_ext) = iw.idconfigitw
       and pto.codsolot = an_codsolot
       and ins.tipsrv = '0006';

    return to_number(lv_capacidad);

  exception
    when others then
      return 0;
  end;

BEGIN
  an_flag  := 0;
  an_error := 0;
  av_error := 'OK';

  ln_val_ctv_old := 0;
  ln_val_int_old := 0;
  ln_val_tlf_old := 0;

  -- Proceso de validacion de los servicios
  ln_codsolot := operacion.pq_sga_iw.f_max_sot_x_cod_id(an_cod_id);

  LV_VEL_IPFIJA := OPERACION.PQ_SGA_JANUS.F_GET_CONSTANTE_CONF('CVELINT_IPFIJA');

  IF ln_codsolot = 0 THEN
    RAISE error_no_sot;
  END IF;

  ln_val_ctv_old := f_val_tipsrv_old(ln_codsolot, '0062'); -- CTV;
  ln_val_int_old := f_val_tipsrv_old(ln_codsolot, '0006'); -- INT;
  ln_val_tlf_old := f_val_tipsrv_old(ln_codsolot, '0004'); -- TLF;

  ln_total_old := ln_val_ctv_old + ln_val_int_old + ln_val_tlf_old;

  IF ln_total_old >= 3 THEN
    ln_vel_int_act := f_val_velocidad_int(ln_codsolot);

    if ln_vel_int_act >= LV_VEL_IPFIJA and ln_vel_int_act != 0 then
      an_flag := 1;
    else
      an_flag := 0;
    end if;
  END IF;

EXCEPTION
  WHEN error_no_sot THEN
    an_error := -1;
    av_error := 'Error : No existe SOT de Alta asociado al contrato : ' ||
                an_cod_id;

  WHEN OTHERS THEN
    an_error := -99;
    av_error := 'Error : ' || SQLCODE || ' ' || SQLERRM || ' Linea (' ||
                dbms_utility.format_error_backtrace || ')';
END;
/