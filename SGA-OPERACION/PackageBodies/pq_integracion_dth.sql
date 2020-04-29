create or replace package body operacion.pq_integracion_dth as
  /************************************************************
  NOMBRE:     pq_integracion_dth
  PROPOSITO:  Sincronizar tareas de Post Venta realizado por el sistema SIAC

  REVISIONES:
   Ver        Fecha        Autor           Solicitado por    Descripcion
  ---------  ----------  ---------------  --------------    ----------
  1.0        17/11/2011  Joseph Asencios  Hector Huaman     REQ-161362:Creación
  2.0        29/11/2011  Roy Concepcion   Hector Huaman     REQ-161362:Generacion de SOT para los tipos de transacción.
  3.0        31/05/2012  Alex Alamo       Hector Huaman     PROY-0642- DTH Postpago
  4.0        27/07/2012  Hector Huaman    Hector Huaman     PROY-3940- DTH Postpago (Mejoras): se creo procedimiento que anula la SOT
  5.0        10/09/2012  Mauro Zegarra    Christian Riquelme REQ-163185 Homologacion de Objetos para una incidencia SD 269175.
  6.0        07/12/2012  Juan Ortiz       Elver Ramirez      REQ-163669
  7.0        22/08/2013  Mauro Zegarra    Guillermo Salcedo  REQ-164606: Error al generar sot de instalacion de deco adicional
  8.0        31/10/2013  Fernando Pacheco Guillermo Salcedo
  9.0        02/10/2015  Justiniano Condori Eustaquio Gibaja 3 PLAY INALAMBRICO
  10.0       21/11/2015  Angel Condori    Alberto Miranda    Alineacion a Produccion
  11.0       26/11/2015  Luis Romero      Paul Moya          PROY-17652 IDEA-22491 - ETAdirect
 *************************************************************/

  procedure p_centro_poblado(ac_ubigeo        in varchar2,
                             ao_cursor        out SYS_REFCURSOR,
                             an_codigo_error  out number,
                             ac_mensaje_error out varchar2) is
  begin

    open ao_cursor for
      select cp.idpoblado,
       cp.idubigeo,
       cp.codclasificacion,
       cp.clasificacion,
       cp.codcategoria,
       cp.categoria,
       cp.nombre,
       cp.poblacion,
       cp.cobertura
  from pvt.tabpoblado@DBL_PVTDB cp
 where cp.idubigeo = ac_ubigeo;

    an_codigo_error  := 0;
    ac_mensaje_error := null;

  exception
    when others then
      an_codigo_error  := -2;
      ac_mensaje_error := SQLERRM;
  end p_centro_poblado;

  procedure p_cobertura(an_idpoblado     in number,
                        an_valido        out number,
                        an_codigo_error  out number,
                        ac_mensaje_error out varchar2) is
  ln_cobertura number;
  begin

    select cp.cobertura
      into ln_cobertura
      from pvt.tabpoblado@DBL_PVTDB cp
     where cp.idpoblado = an_idpoblado;

    an_valido := ln_cobertura;
    an_codigo_error  := 0;
    ac_mensaje_error := null;

  exception
    when others then
      an_valido := -1;
      an_codigo_error  := -2;
      ac_mensaje_error := SQLERRM;
  end p_cobertura;

procedure p_consulta_solot(an_codsolot      in number,
                             ao_cursor        out SYS_REFCURSOR,
                             an_codigo_error  out number,
                             ac_mensaje_error out varchar2) is
  begin

    open ao_cursor for
      select codcli,
             codsolot,
             tiptra,
             (select tt.descripcion
                from tiptrabajo tt
               where tt.tiptra = a.tiptra) Destiptra,
             observacion,
             estsol,
             (select es.descripcion
                from estsol es
               where es.estsol = a.estsol) Desestsol,
             recosi,
             to_char(feccom, 'dd/mm/yyyy') feccom,
             (select o.descripcion
                from opedd o
               where o.tipopedd = 170
                 and o.codigon = a.grado) desGrado,
             (select v.nomcli from vtatabcli v where v.codcli = a.codcli) nomcli,
             (select i.nticket
                from incidence i
               where i.codincidence = a.recosi) nticket,
             docid,
             tipsrv,
             (select dsctipsrv  from  tystipsrv ts where ts.tipsrv=a.tipsrv) Dsctipsrv ,
             to_char(fecapr, 'dd/mm/yyyy') fecapr,
             to_char(fecultest, 'dd/mm/yyyy') fecultest,
             to_char(fecfin, 'dd/mm/yyyy') fecfin,
             numslc,
             derivado,
             coddpt,
             to_char(fecusu, 'dd/mm/yyyy') fecusu,
             codusu,
             codmotot,
             (select m.descripcion  from motot m where m.codmotot=a.codmotot)motivo,
             estasi,
             origen,
             cliint,
             tiprec,
             numpsp,
             idopc,--3.0
             tipcon,
             plan,
             estsolope,
             numptas,
             to_char(fecini, 'dd/mm/yyyy') fecini,
             prycon,
             areasol,
             (select descripcion  from areaope ao where ao.area=a.areasol )descarea_sol,
             idproducto,
             to_char(fecusu_obs, 'dd/mm/yyyy') fecusu_obs,
             codusu_obs,
             codprec,
             grado,
             to_char(fecrep, 'dd/mm/yyyy') fecrep,
             transferido_sap,
             sotfacturable,
             to_char(fecrec, 'dd/mm/yyyy') fecrec,
             usuarioresp,
             usuarioasig,
             arearesp,
             (select descripcion  from areaope ao where ao.area=a.arearesp )descarea_resp,
             direccion,
             codubi,
             acta_instalacion,
             charging_area1,
             charging_area2,
             charging_area3,
             flg_penalidad,
             codigo_clarify,
             /*  --Ini 6.0
             (Select to_char(fecagenda,'DD/MM/YYYY HH24:MI') from agendamiento  where codsolot=a.codsolot)fecha_agenda
             --Fin 6.0*/
             --Ini 8.0
             (Select to_char(max(fecagenda),'DD/MM/YYYY HH24:MI') from agendamiento  where codsolot=a.codsolot) fecha_agenda -- 10.0
             --Fin 8.0
        from solot a
       where a.codsolot = an_codsolot;

    an_codigo_error  := 0;
    ac_mensaje_error := null;

  exception
    when others then
      an_codigo_error  := -2;
      ac_mensaje_error := SQLERRM;
  end p_consulta_solot;

  procedure p_consulta_tareas(an_codsolot      in number,
                              ao_cursor        out SYS_REFCURSOR,
                              an_codigo_error  out number,
                              ac_mensaje_error out varchar2) is

    ln_idwf number;

  begin

    ln_idwf := f_get_wf_solot(an_codsolot);

    open ao_cursor for
      select 0 flg,
             v_tareawf.idtareawf,
             v_tareawf.tarea_desc,
             v_tareawf.area_desc,
             nvl(v_tareawf.responsable_desc, ' ') responsable_desc,
             nvl(v_tareawf.estado_desc, ' ') estado_desc,
             v_tareawf.tipoestado_desc,
             to_char(v_tareawf.fecinisys, 'dd/mm/yyyy') fecinisys,
             to_char(v_tareawf.fecfinsys, 'dd/mm/yyyy') fecfinsys,
             to_char(v_tareawf.fecini, 'dd/mm/yyyy') fecini,
             to_char(v_tareawf.fecfin, 'dd/mm/yyyy') fecfin,
             to_char(v_tareawf.feccom, 'dd/mm/yyyy') feccom,
             v_tareawf.opcional,
             v_tareawf.usufin,
             v_tareawf.tareadef,
             v_tareawf.tipesttar,
             to_char((select fecini
                       from tareawfcpy
                      where idtareawf = v_tareawf.idtareawf),
                     'dd/mm/yyyy') fecinicomp,
             to_char((select fecfin
                       from tareawfcpy
                      where idtareawf = v_tareawf.idtareawf),
                     'dd/mm/yyyy') fecfincomp
        from v_tareawf
       where v_tareawf.idwf = ln_idwf
      union all
      select 1,
             c.idtareawf,
             c.descripcion,
             a.descripcion,
             nvl(c.responsable, ' ') responsable,
             ' ',
             ' ',
             to_char(null),
             to_char(null),
             to_char(null),
             to_char(null),
             to_char(null),
             c.opcional,
             ' ',
             0,
             0,
             to_char(c.fecini, 'dd/mm/yyyy') fecinicomp,
             to_char(c.fecfin, 'dd/mm/yyyy') fecfincomp
        from tareawfcpy c, areaope a
       where c.area = a.area(+)
         and idwf = ln_idwf
         and c.idtareawf not in
             (select idtareawf from tareawf where idwf = ln_idwf)
       order by 1;

    an_codigo_error  := 0;
    ac_mensaje_error := null;

  exception
    when others then
      an_codigo_error  := -2;
      ac_mensaje_error := SQLERRM;
  end p_consulta_tareas;

   /*Procedimiento que se invocara del webservice*/
  procedure p_ejecuta_transaccion_dth(av_tipo_trans in varchar2,
                                      an_cod_clarify in number,
                                      av_num_sec in varchar2,
                                      av_tipo_via in varchar2,
                                      av_nom_via  in varchar2,
                                      an_num_via  in number,
                                      an_tip_urb  in number,
                                      av_manzana  in varchar2,
                                      av_lote     in varchar2,
                                      av_ubigeo   in varchar2,
                                      av_referencia in varchar2,
                                      av_observacion in varchar2,
                                      ad_fec_prog in date,
                                      an_codsolot out number,
                                      av_error   out varchar2) is
 ln_tipo_trab_te  tiptrabajo.tiptra%type;
 ln_tipo_trab_ti  tiptrabajo.tiptra%type;
 ln_tipo_trab_m  tiptrabajo.tiptra%type;
 ln_tipo_trab    tiptrabajo.tiptra%type;
 vv_cod_cli varchar2(8);
 vv_CODSUC varchar2(10);
 vn_codinssrv number(10);
 vn_numregistro char(10);
 an_retorna number;
 ac_mensaje varchar2(100);
 vv_nomurb   vtatipurb.descripcion%type;
 vv_desvia   pertipvia.desvia%type;
 v_av_num_sec     varchar(200);
 v_trama         clob;
 vv_ubisuc    marketing.vtasuccli.ubisuc%type;
 vv_dirsuc   marketing.vtasuccli.dirsuc%type;
 

 begin

    SELECT  REGEXP_SUBSTR(av_num_sec, '[^;]+', 1,1) into v_av_num_sec FROM DUAL;
    SELECT  REGEXP_SUBSTR(av_num_sec, '[^;]+', 1,2) into v_trama FROM DUAL;

    IF LENGTH(V_TRAMA) > 0 THEN
       FLAG_ETA:='ETA' ;
    ELSE
       FLAG_ETA :='' ;
    END IF;

       ln_tipo_trab_te := f_obt_tip_transaccion_te_dth;
       ln_tipo_trab_ti := f_obt_tip_transaccion_ti_dth;
       ln_tipo_trab_m  := f_obt_tip_transaccion_m_dth;
       IF av_tipo_trans = '727' THEN
          ln_tipo_trab  := av_tipo_trans;
       ELSE
       ln_tipo_trab  := f_obt_tip_transaccion(av_tipo_trans);
       END IF;


       begin
          select i.codcli,i.codinssrv,ope.numregistro
             into vv_cod_cli,vn_codinssrv,vn_numregistro
          from inssrv i,ope_srv_recarga_det ope
          where i.codinssrv = ope.codinssrv and
     i.numsec = v_av_num_sec; --7.0 i.numero =  av_num_sec;
       exception
        when no_data_found then
           an_codsolot := 0;
           av_error := 'No se encontro la instancia de servicio para el Numero de Secuencia ' || av_num_sec  ;
           return;
       end;

       /*Si el tipo de transaccacion es de Trasalado Externo*/
       if ln_tipo_trab = ln_tipo_trab_te then
            /** Validando el tipo de urbanizacion **/
            begin
                select descripcion into vv_nomurb
                from vtatipurb
                where idtipurb = an_tip_urb;
            exception
            when others then
                an_codsolot := 0;
                av_error := 'No existe el tipo de urb. ingresado';
                return;
            end;
            /** Validando el tipo de via **/
            begin
                SELECT desvia INTO vv_desvia
                FROM pertipvia
                WHERE codvia = av_tipo_via;
            exception
            when others then
                 an_codsolot := 0;
                 av_error := 'No existe el tipo de via ingresado';
                 return;
            end;
            p_ins_sucurxcliente_dth( vv_cod_cli,
                                    av_tipo_via,
                                    av_nom_via,
                                    an_num_via,
                                    an_tip_urb,
                                    av_manzana,
                                    av_lote,
                                    av_ubigeo,
                                    av_referencia,
                                    vv_CODSUC,
                                    ac_mensaje);

            IF ac_mensaje <> 'OK' THEN
               an_codsolot := 0;
               av_error := ac_mensaje;
               RETURN;
            END IF;


       select vt.ubisuc, vt.dirsuc
              into vv_ubisuc, vv_dirsuc
              from vtasuccli vt where vt.codsuc = vv_CODSUC;

            UPDATE INSSRV SET CODSUC = vv_CODSUC, CODUBI = vv_ubisuc, DIRECCION = vv_dirsuc
            WHERE codinssrv  = vn_codinssrv;

            p_crea_sot_postventa_post(vn_numregistro,
                                 ln_tipo_trab_te,
                                 av_observacion,
                                 cv_traslado_externo,
                                 av_ubigeo,
                                 an_cod_clarify,
                                 ad_fec_prog,
                                 an_codsolot,
                                 an_retorna,
                                 ac_mensaje);

            if an_retorna <> 0 then
               an_codsolot := 0;
               av_error := ac_mensaje;
               return;
             end if;

       end if;

       /*Si el tipo de transaccacion es de Trasalado Interno*/
       if ln_tipo_trab = ln_tipo_trab_ti then
          p_crea_sot_postventa_post(vn_numregistro,
                                 ln_tipo_trab_ti,
                                 av_observacion,
                                 cv_traslado_interno,
                                 av_ubigeo,
                                 an_cod_clarify,
                                 ad_fec_prog,
                                 an_codsolot,
                                 an_retorna,
                                 ac_mensaje);

          if an_retorna <> 0 then
             an_codsolot := 0;
             av_error := ac_mensaje;
             return;
          end if;

       end if;

       /*Si el tipo de transaccacion es de Mantenimiento*/
       if ln_tipo_trab = ln_tipo_trab_m then

      IF an_cod_clarify = 0 then
       IF flag_eta = 'ETA' THEN
       p_crea_sot_postventa_post(vn_numregistro,
                                ln_tipo_trab_m,
                                av_observacion||','||v_trama,
                                cv_mantenimiento,
                                av_ubigeo,
                                an_cod_clarify,
                                ad_fec_prog,
                                an_codsolot,
                                an_retorna,
                                ac_mensaje);
  ELSE
        p_crea_sot_postventa_post(vn_numregistro,
                                ln_tipo_trab_m,
                                av_observacion,
                                cv_mantenimiento,
                                av_ubigeo,
                                an_cod_clarify,
                                ad_fec_prog,
                                an_codsolot,
                                an_retorna,
                                ac_mensaje);
      END IF ;

      ELSE
          p_crea_sot_postventa_post(vn_numregistro,
                                 ln_tipo_trab_m,
                                 av_observacion,
                                 cv_mantenimiento,
                                 av_ubigeo,
                                 an_cod_clarify,
                                 ad_fec_prog,
                                 an_codsolot,
                                 an_retorna,
                                 ac_mensaje);
      end if ;



          if an_retorna <> 0 then
             an_codsolot := 0;
             av_error := ac_mensaje;
             return;
          end if;
       END IF;

       /*Si el tipo de transaccacion es de relamos*/
       if ln_tipo_trab = '727' then

      IF an_cod_clarify = 0 then
       IF flag_eta = 'ETA' THEN
       p_crea_sot_postventa_post(vn_numregistro,
                                ln_tipo_trab,
                                av_observacion||','||v_trama,
                                cv_mantenimiento,
                                av_ubigeo,
                                an_cod_clarify,
                                ad_fec_prog,
                                an_codsolot,
                                an_retorna,
                                ac_mensaje);
  ELSE
        p_crea_sot_postventa_post(vn_numregistro,
                                ln_tipo_trab,
                                av_observacion,
                                cv_mantenimiento,
                                av_ubigeo,
                                an_cod_clarify,
                                ad_fec_prog,
                                an_codsolot,
                                an_retorna,
                                ac_mensaje);
      END IF ;

      ELSE
          p_crea_sot_postventa_post(vn_numregistro,
                                 ln_tipo_trab,
                                 av_observacion,
                                 cv_mantenimiento,
                                 av_ubigeo,
                                 an_cod_clarify,
                                 ad_fec_prog,
                                 an_codsolot,
                                 an_retorna,
                                 ac_mensaje);
      end if ;



          if an_retorna <> 0 then
             an_codsolot := 0;
             av_error := ac_mensaje;
             return;
          end if;
       END IF;

       av_error := ac_mensaje;
       commit;
 end p_ejecuta_transaccion_dth;

 function f_obt_tip_transaccion(av_tip_tran varchar2) return number is
 ln_tipo_trabajo tiptrabajo.tiptra%type;

 begin
   ln_tipo_trabajo := null;
   select op.codigon into ln_tipo_trabajo
    from opedd op, tipopedd td
    where op.tipopedd = td.tipopedd and
    UPPER(op.abreviacion) = av_tip_tran and
    UPPER(td.abrev) like '%TIPO_TRANS_DTH%';

   return ln_tipo_trabajo;
 exception
   when others then
        ln_tipo_trabajo := -1;
        return ln_tipo_trabajo;
 end f_obt_tip_transaccion;

 function f_obt_tip_transaccion_ti_dth return number is
 ln_tipo_trabajo tiptrabajo.tiptra%type;

 begin
   ln_tipo_trabajo := null;
   select op.codigon into ln_tipo_trabajo
    from opedd op, tipopedd td
    where op.tipopedd = td.tipopedd and
    UPPER(op.abreviacion) like '%TI_DTH%' and
    UPPER(td.abrev) like '%TIPO_TRANS_DTH%';

   return ln_tipo_trabajo;
 exception
   when others then
        ln_tipo_trabajo := -1;
        return ln_tipo_trabajo;
 end f_obt_tip_transaccion_ti_dth;

  function f_obt_tip_transaccion_te_dth return number is
 ln_tipo_trabajo tiptrabajo.tiptra%type;

 begin
   ln_tipo_trabajo := null;
   select op.codigon into ln_tipo_trabajo
    from opedd op, tipopedd td
    where op.tipopedd = td.tipopedd and
    UPPER(op.abreviacion) like '%TE_DTH%' and
    UPPER(td.abrev) like '%TIPO_TRANS_DTH%';

   return ln_tipo_trabajo;
 exception
   when others then
        ln_tipo_trabajo := -1;
        return ln_tipo_trabajo;
 end f_obt_tip_transaccion_te_dth;

 function f_obt_tip_transaccion_m_dth return number is
 ln_tipo_trabajo tiptrabajo.tiptra%type;

 begin
   ln_tipo_trabajo := null;
   select op.codigon into ln_tipo_trabajo
    from opedd op, tipopedd td
    where op.tipopedd = td.tipopedd and
    UPPER(op.abreviacion) like '%M_DTH%' and
    UPPER(td.abrev) like '%TIPO_TRANS_DTH%';

   return ln_tipo_trabajo;
 exception
   when others then
        ln_tipo_trabajo := -1;
        return ln_tipo_trabajo;
 end f_obt_tip_transaccion_m_dth;

  function f_obt_area_sol_dth return number is
 ln_tipo_trabajo tiptrabajo.tiptra%type;

 begin
   ln_tipo_trabajo := null;
   select op.codigon into ln_tipo_trabajo
    from opedd op, tipopedd td
    where op.tipopedd = td.tipopedd and
    UPPER(op.abreviacion) like '%AREA_TRA_DTH%' and
    UPPER(td.abrev) like '%DATO_SOLOT_DTH%';

   return ln_tipo_trabajo;
 exception
   when others then
        ln_tipo_trabajo := -1;
        return ln_tipo_trabajo;
 end f_obt_area_sol_dth;

 function f_obt_motivo_dth return number is
 ln_tipo_trabajo tiptrabajo.tiptra%type;

 begin
   ln_tipo_trabajo := null;
   select op.codigon into ln_tipo_trabajo
    from opedd op, tipopedd td
    where op.tipopedd = td.tipopedd and
    UPPER(op.abreviacion) like '%MOTIVO_TRA_DTH%' and
    UPPER(td.abrev) like '%DATO_SOLOT_DTH%';

   return ln_tipo_trabajo;
 exception
   when others then
        ln_tipo_trabajo := -1;
        return ln_tipo_trabajo;
 end f_obt_motivo_dth;

procedure p_obt_valor_nomsuc(av_nomsuc out varchar2, av_salida out varchar2) is
begin
    SELECT C.VALOR
    into  av_nomsuc
    FROM CONSTANTE C
    where upper(C.constante) like '%DTH_NOMSUC%';
    av_salida := 'OK';
 exception
   when others then
        av_nomsuc := null;
        av_salida := ' PROBLEMAS CON EL NOMBRE DE SUCURSAL - p_obt_valor_nomsuc : ' || SQLERRM;
end p_obt_valor_nomsuc;

procedure p_obt_valor_direccionsuc(av_dirsuc out varchar2, av_salida out varchar2) is
begin
    SELECT C.VALOR
    into  av_dirsuc
    FROM CONSTANTE C
    where upper(C.constante) like '%DTH_DIRSUC%';
    av_salida := 'OK';
 exception
   when others then
        av_dirsuc := null;
        av_salida := ' PROBLEMAS CON EL NOMBRE DE SUCURSAL - p_obt_valor_direccionsuc : ' || SQLERRM;
end p_obt_valor_direccionsuc;

PROCEDURE P_INS_INMUEBLE_DTH(AV_TIPVIAP IN varchar2,
                         AV_NOMVIA IN varchar2,
                         AV_NUMVIA IN varchar2,
                         AV_NOMURB IN varchar2,
                         AV_LOTE IN varchar2,
                         AV_MANZANA IN varchar2,
                         AV_REFERENCIA IN varchar2,
                         AV_CODUBI IN varchar2,
                         AN_IDINMUEBLE OUT INMUEBLE.IDINMUEBLE%TYPE) IS

  BEGIN

    SELECT LPAD(SQ_INMUEBLE.nextval, 8, '0') INTO AN_IDINMUEBLE FROM DUAL;

    --Insertamos el INMUEBLE
    INSERT INTO INMUEBLE
      (IDINMUEBLE,
       TIPVIAP,
       NOMVIA,
       NUMVIA,
       NOMURB,
       LOTE,
       MANZANA,
       REFERENCIA,
       CODUBI)
    VALUES
      (AN_IDINMUEBLE,
       AV_TIPVIAP,
       AV_NOMVIA,
       AV_NUMVIA,
       AV_NOMURB,
       AV_LOTE,
       AV_MANZANA,
       AV_REFERENCIA,
       AV_CODUBI);

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20500,
                              'ERROR AL CREAR INMUEBLE: En P_INS_INMUEBLE_DTH() - ' ||
                              SQLERRM);
  END;

 procedure p_ins_sucurxcliente_dth( av_cod_cli  in varchar2,
                                    av_tipo_via in varchar2,
                                    av_nom_via  in varchar2,
                                    an_num_via  in number,
                                    an_tip_urb  in number,
                                    av_manzana  in varchar2,
                                    av_lote     in varchar2,
                                    av_ubigeo   in varchar2,
                                    av_referencia in varchar2,
                                    AC_CODSUC OUT VTASUCCLI.CODSUC%TYPE,
                                    vv_salida   out varchar2) is
 vv_nomurb varchar2(150);
 vv_nomsuc VTASUCCLI.Nomsuc%type;
 vv_dirsuc vtasuccli.dirsuc%type;
 NUM_ID number;
 LC_CODSUC char(10);
 V_NOMSUC_ERROR EXCEPTION;
 vv_dirsuc_pobt constante.valor%type;
 ln_count_ubigeo number;
 vv_codubi  vtatabdst.codubi%type;
 vn_idinmueble inmueble.idinmueble%type;

 begin

      SELECT sq_vtasuccli.nextval into NUM_ID from dual;
      LC_CODSUC := LPAD(num_id, 10, '0');

      select descripcion into vv_nomurb
      from vtatipurb
      where idtipurb = an_tip_urb;

      select count(*)
      into ln_count_ubigeo
      from vtatabdst
      where trim(ubigeo) = trim(av_ubigeo);

      if ln_count_ubigeo > 0 then
          select codubi
          into vv_codubi
          from vtatabdst
          where trim(ubigeo) = trim(av_ubigeo)
          and rownum = 1;
      else
          vv_salida := 'No existe el codigo de Ubigeo enviado.';
          RAISE V_NOMSUC_ERROR;
      end if;

      p_obt_valor_nomsuc(vv_nomsuc,vv_salida);

      IF vv_salida <> 'OK' THEN
         RAISE V_NOMSUC_ERROR;
      END IF;

      p_obt_valor_direccionsuc(vv_dirsuc_pobt,vv_salida);

      IF vv_salida <> 'OK' THEN
         RAISE V_NOMSUC_ERROR;
      END IF;

      IF av_nom_via IS NULL AND vv_nomurb IS NOT NULL THEN
          vv_dirsuc := 'URB. ' || vv_nomurb;
      ELSIF vv_nomurb IS NULL AND av_nom_via IS NOT NULL THEN
          vv_dirsuc := av_nom_via || ' ' || an_num_via;
      ELSIF vv_nomurb IS NULL AND av_nom_via IS NULL THEN
          vv_dirsuc := vv_dirsuc_pobt;
      ELSE
          vv_dirsuc := av_nom_via || ' ' || an_num_via || ' URB. ' || vv_nomurb;
      END IF;

      /**** Creamos el inmueble ****/

     P_INS_INMUEBLE_DTH(av_tipo_via,
                         av_nom_via,
                         to_char(an_num_via),
                         vv_nomurb,
                         av_lote,
                         av_manzana,
                         av_referencia,
                         vv_codubi,
                         vn_idinmueble);


      /***** Se crea la sucursal ****/

      INSERT INTO VTASUCCLI
        (CODSUC,
         CODCLI,
         NOMSUC,
         DIRSUC,
         UBISUC,
         TIPVIAP,
         NOMVIA,
         NOMURB,
         REFERENCIA,
         LOTE,
         MANZANA,
         NUMVIA,
         idinmueble,
         idtipurb)--3.0
      VALUES
        (LC_CODSUC,
         av_cod_cli,
         vv_nomsuc,
         vv_dirsuc,
         vv_codubi,
         av_tipo_via,
         av_nom_via,
         vv_nomurb,
         av_referencia,
         av_lote,
         av_manzana,
         an_num_via,
         vn_idinmueble,
         an_tip_urb);--3.0

      AC_CODSUC := LC_CODSUC;
      vv_salida := 'OK';
EXCEPTION
WHEN V_NOMSUC_ERROR THEN
     AC_CODSUC := 0;
WHEN OTHERS THEN
     vv_salida := sqlerrm;
     AC_CODSUC := 0;
end p_ins_sucurxcliente_dth;

 /*Procedimiento que genera una SOT según el tipo de transacción*/
 procedure p_crea_sot_postventa_post(ac_numregistro in varchar2,
                                 an_tip_trabajo      in number,
                                 ac_observacion      in varchar2,
                                 ac_tipo_traslado    in varchar2,

                                 ac_codubi           in varchar2,
                                 an_cod_clarify      in number,
                                 ad_fec_prog         in date,
                                 an_codsolot         out number,
                                 an_retorna          out number,
                                 ac_mensaje          out varchar2) is
    lr_solot       solot%rowtype;
    ln_codmotot    solot.codmotot%type;
    ln_codsolot    solot.codsolot%type;
    lr_solotpto    solotpto%rowtype;
    ln_punto       solotpto.punto%type;
    --ln_tipotrabajo tiptrabajo.tiptra%type;
    ln_tiptrs      tiptrabajo.tiptrs%type;
    ln_wfdef       wfdef.wfdef%type;
    lc_codcli      vtatabcli.codcli%type;
    lc_tipsrv      soluciones.tipsrv%type;
    ln_idsolucion  soluciones.idsolucion%type;
    ln_area_sol    solot.areasol%type;

   v_trama2         clob;
   v_fecha          varchar2(20);
   v_franja         varchar2(10);
   v_bucket         varchar2(100);
   v_poblado        varchar2(10);
   v_subtiporden    varchar2(20);
   l_idPlano        varchar2(20);
   vresp            varchar2(100);
   l_codError       varchar2(100);
   v_ac_observacion solot.observacion%type;
   v_user           varchar2(20);
   v_codubi         marketing.vtatabdst.codubi%type;
    --Detalle del servicio DTH
    cursor cur_detalle is
      select det.codinssrv,
             i.codsrv,
             i.bw,
             i.cid,
             i.descripcion,
             i.direccion,
             i.codubi,
             i.codpostal
        from ope_srv_recarga_det det, inssrv i
       where det.codinssrv = i.codinssrv
         and det.numregistro = ac_numregistro;
  begin

   select REGEXP_SUBSTR(ac_observacion, '[^,]+', 1, 1)
     into v_ac_observacion
     from DUAL;
   select REGEXP_SUBSTR(ac_observacion, '[^,]+', 1, 2) into v_trama2 from DUAL;


    an_codsolot:= 0;
    an_retorna := 0;
    ac_mensaje := 'Por generar Sot.';

    ln_codmotot := f_obt_motivo_dth;

    --Se determina datos complementarios para la generación de SOT
    begin
      select a.codcli, c.tipsrv, b.idsolucion
        into lc_codcli, lc_tipsrv, ln_idsolucion
        from ope_srv_recarga_cab a, vtatabslcfac b, soluciones c
       where numregistro = ac_numregistro
         and b.idsolucion = c.idsolucion
         and a.numslc = b.numslc;
    exception
      when no_data_found then
        an_retorna := sqlcode;
        ac_mensaje := 'No se encontraron los siguientes datos: Codcli, Tipsrv, IdSolucion.';
        return;
    end;

    --DETERMINAR EL AREA SOLICITANTE
     ln_area_sol := f_obt_area_sol_dth;

    begin
       --se obtiene el CODUBI
      select distinct vt.codubi
        into v_codubi
        from marketing.vtatabdst vt
       where vt.ubigeo = ac_codubi;

      --Se registra los datos de la SOT

      lr_solot.codmotot    := ln_codmotot;
      lr_solot.codsolot    := null;
      lr_solot.tiptra      := an_tip_trabajo;
      lr_solot.feccom      := trunc(sysdate);
      lr_solot.estsol      := cn_sot_gen;
      lr_solot.tipsrv      := lc_tipsrv;
      lr_solot.codcli      := lc_codcli;
      lr_solot.areasol     := ln_area_sol; --area solicitante
      IF flag_eta = 'ETA' then
         lr_solot.observacion    := v_ac_observacion; --ac_observacion;
      ELSE
      lr_solot.observacion := ac_observacion;
      END IF;
      lr_solot.codigo_clarify := an_cod_clarify;
      lr_solot.feccom         := ad_fec_prog;
      lr_solot.codubi         := v_codubi; --ac_codubi;
      pq_solot.p_insert_solot(lr_solot, ln_codsolot);
      lr_solot.codsolot := ln_codsolot;
    exception
      when others then
        an_retorna := -1;
        ac_mensaje := 'No se registró la SOT: ' || sqlerrm || ' (' ||
                      dbms_utility.format_error_backtrace || ')';
        return;
    end;

    --Se determina el tipo de transación para generar la sot
    begin
      select tiptrs
        into ln_tiptrs
        from tiptrabajo
       where tiptra = an_tip_trabajo;
    exception
      when no_data_found then
        --an_retorna := -1;
        --ac_mensaje := 'No se encontró el tipo de transacción (Tiptrs).';
        --return;
        ln_tiptrs := '';
    end;

    --Registro del detalle de la SOT
    for c_det in cur_detalle loop
      lr_solotpto.codsolot    := ln_codsolot;
      lr_solotpto.tiptrs      := ln_tiptrs; --Cancelación
      lr_solotpto.codsrvnue   := c_det.codsrv;
      lr_solotpto.bwnue       := c_det.bw;
      lr_solotpto.codinssrv   := c_det.codinssrv;
      lr_solotpto.cid         := c_det.cid;
      lr_solotpto.descripcion := c_det.descripcion;
      lr_solotpto.direccion   := c_det.direccion;
      lr_solotpto.tipo        := cn_solot_tipo;
      lr_solotpto.estado      := cn_solot_estado;
      lr_solotpto.visible     := cn_solot_visible;
      lr_solotpto.codubi      := c_det.codubi;
      lr_solotpto.codpostal   := c_det.codpostal; -- para el traslado externo ¿?

      pq_solot.p_insert_solotpto(lr_solotpto, ln_punto);
    end loop;
   --SMN REG ETA

   if an_cod_clarify = 0 then
    IF flag_eta = 'ETA' THEN
        select REGEXP_SUBSTR(v_trama2, '[^|]+', 1, 1) into v_fecha from DUAL;
        select REGEXP_SUBSTR(v_trama2, '[^|]+', 1, 2) into v_franja from DUAL;
        select REGEXP_SUBSTR(v_trama2, '[^|]+', 1, 3) into v_bucket from DUAL;
        select REGEXP_SUBSTR(v_trama2, '[^|]+', 1, 4) into v_poblado from DUAL;
           select REGEXP_SUBSTR(v_trama2, '[^|]+', 1, 5) into v_subtiporden from DUAL;
        select REGEXP_SUBSTR(v_trama2, '[^|]+', 1, 6) into v_user from DUAL;

     IF V_FECHA = ' ' THEN
       V_FECHA := NULL;
     END IF;

        sales.pkg_etadirect.sp_insert_param_vta_pvta_adc(ln_codsolot,
                      l_idPlano,
                      v_poblado,
                      v_subtiporden,
                      v_fecha,
                      v_franja,
                      v_bucket,
                      '',
                      '',
                      sysdate,
                      v_user,
                      l_codError,
                      vresp);
     ELSE
          sales.pkg_etadirect.p_registro_eta(ln_codsolot, an_cod_clarify,0,ac_mensaje);
     END IF;
   ELSE
     sales.pkg_etadirect.p_registro_eta(ln_codsolot, an_cod_clarify,0,ac_mensaje);
   END IF;

      --SMN END ETA
    --Se determina el wf asociado
    ln_wfdef := cusbra.f_br_sel_wf(ln_codsolot);
    if ln_wfdef is null then
      an_retorna := -1;
      ac_mensaje := 'No se encuentra definido un WF.';
      return;
    end if;

    --Se asigna el wf
    begin
      pq_solot.p_asig_wf(ln_codsolot, ln_wfdef);

    exception
      when others then
        an_retorna := -1;
        if an_retorna = -20000 then
          ac_mensaje := substr(sqlerrm, 12);
        else
          ac_mensaje := sqlerrm || ' (' ||
                        dbms_utility.format_error_backtrace || ')';
        end if;
    end;
    an_retorna  := 0;
    ac_mensaje  := 'SOT creada.';
    an_codsolot := ln_codsolot;

  end p_crea_sot_postventa_post;
   --ini 3.0
  procedure p_validamaterial(n_opcion           in number,
                             ac_NumSerieDeco    in varchar2,
                             ac_NumSerieTarjeta in varchar2,
                             ac_salida          out gc_salida,
                             ac_resultado       out varchar2,
                             ac_mensaje         out varchar2) is
    error_formato_cli exception;
    error_tarjeta exception;
    error_deco exception;
    error_deco_tarjeta exception;
    lc_salida  gc_salida;
    ln_deco    number;
    ln_tarjeta number;
  begin
    ac_resultado := 'OK';
    begin
    if n_opcion is null then
      raise error_formato_cli;
        ac_resultado := 'Error';
    end if;
      if n_opcion not in (0, 1, 2) then
        raise error_formato_cli;
        ac_resultado := 'Error';
      end if;
      if n_opcion = 0 then
        -- búsqueda por numero de serie decodificador y tarjeta
        -- Tipo 1 Tarjeta / 2 Decodificador
        if ac_NumSerieDeco is null or ac_NumSerieTarjeta is null then
          raise error_formato_cli;
        end if;

        select count(1)
          into ln_tarjeta
          from OPERACION.TABEQUIPO_MATERIAL
         where numero_serie = ac_NumSerieTarjeta
           and tipo = 1;

        select count(1)
          into ln_deco
          from OPERACION.TABEQUIPO_MATERIAL
         --where numero_serie = ac_NumSerieDeco
         where imei_esn_ua = ac_NumSerieDeco -- 5.0
           and tipo = 2;

        if ln_tarjeta = 0 and ln_deco = 0 then
          raise error_deco_tarjeta;
        end if;
        IF ln_tarjeta = 0 then
          raise error_tarjeta;
        end if;
        IF ln_deco = 0 then
          raise error_deco;
        end if;
        open lc_salida for
          select tipo, numero_serie, imei_esn_ua, estado
            from OPERACION.TABEQUIPO_MATERIAL
           where numero_serie = ac_NumSerieTarjeta
             and tipo = 1
          union
          select tipo, numero_serie, imei_esn_ua, estado
            from OPERACION.TABEQUIPO_MATERIAL
           --where numero_serie = ac_NumSerieDeco
           where imei_esn_ua = ac_NumSerieDeco -- 5.0
             and tipo = 2;
        ac_salida := lc_salida;
      end if;

      if n_opcion = 1 then
        -- búsqueda por numero de serie decodificador
        if ac_NumSerieDeco is null then
          raise error_formato_cli;
        end if;
        open lc_salida for
          select tipo, numero_serie, imei_esn_ua, estado
            from OPERACION.TABEQUIPO_MATERIAL
           --where numero_serie = ac_NumSerieDeco
           where imei_esn_ua = ac_NumSerieDeco -- 5.0
             and tipo = 2;
        ac_salida := lc_salida;
      end if;
      if n_opcion = 2 then
        -- búsqueda por numero de serie tarjeta
        if ac_NumSerieTarjeta is null then
          raise error_formato_cli;
        end if;
        open lc_salida for
          select tipo, numero_serie, imei_esn_ua, estado
            from OPERACION.TABEQUIPO_MATERIAL
           where numero_serie = ac_NumSerieTarjeta
             and tipo = 1;
        ac_salida := lc_salida;
      end if;
    exception
      when error_deco_tarjeta then
        ac_resultado := 'ERROR';
        ac_mensaje   := 'El nro de serie de la tarjeta y el decodificador no existe';

        open lc_salida for
          select tipo, numero_serie, imei_esn_ua, estado
            from OPERACION.TABEQUIPO_MATERIAL
           where 1 = 0;
        ac_salida := lc_salida;

      when error_formato_cli then
        ac_resultado := 'ERROR';
        ac_mensaje   := 'Datos de búsqueda incompleta.';
        open lc_salida for

          select tipo, numero_serie, imei_esn_ua, estado
            from OPERACION.TABEQUIPO_MATERIAL
           where 1 = 0;
        ac_salida := lc_salida;

      when error_tarjeta then
        ac_resultado := 'ERROR';
        ac_mensaje   := 'El nro de serie de la tarjeta no existe';
        open lc_salida for

          select tipo, numero_serie, imei_esn_ua, estado
            from OPERACION.TABEQUIPO_MATERIAL
           where 1 = 0;
        ac_salida := lc_salida;

      when error_deco then
        ac_resultado := 'ERROR';
        ac_mensaje   := 'El nro de serie del decodificador no existe';
        open lc_salida for

          select tipo, numero_serie, imei_esn_ua, estado
            from OPERACION.TABEQUIPO_MATERIAL
           where 1 = 0;
        ac_salida := lc_salida;

      when others then
        ac_resultado := 'ERROR';
        ac_mensaje   := 'Error: ' || sqlcode || ' ' || sqlerrm;
        open lc_salida for

          select tipo, numero_serie, imei_esn_ua, estado
            from OPERACION.TABEQUIPO_MATERIAL
           where 1 = 0;
        ac_salida := lc_salida;

    end;
  end p_validamaterial;
  --fin 30.0
  --<4.0
procedure p_chg_solot(ln_numsec      in number,
                      ls_observacion in varchar2,
                      ln_estsol      in number,
                      an_codigo_error out number,
                      ac_mensaje_error out varchar2) is
  ln_codsolot    solot.codsolot%type;
  l_tip          tipestsol.tipestsol%type;
  l_estsol       estsol.estsol%type;
  l_estsol_old   estsol.estsol%type;
  l_valido number;
  cursor c_solot(l_numsec  number) is
    select x.o_codsolot codsolot
      from int_vtaregventa_aux x
     where x.idlote in (select distinct i.idlote
                        from int_vtacliente_aux i
                       where trim(i.TELEFONOM2) = l_numsec);

  Begin
     l_estsol:=ln_estsol;
     l_valido:=1;
     if l_estsol is null then
       l_estsol:=cn_anulado;
     end if;

 for c_sot  in c_solot(ln_numsec) loop
  if l_valido=1 then
       an_codigo_error   := 0;
       ac_mensaje_error :=null;
       ln_codsolot:=c_sot.codsolot;

     select tipestsol
       into l_tip
       from estsol e, solot s
      where e.estsol = s.estsol and s.codsolot = ln_codsolot;
    if l_tip  not in(4,5) then
         begin
          operacion.pq_solot.p_chg_estado_solot(ln_codsolot,l_estsol,l_estsol_old,ls_observacion);
        exception
          when OTHERS then
          an_codigo_error   := -2;
          ac_mensaje_error := 'Error en el cambio de estado de la SOT' || sqlerrm;
          l_valido:=0;
         end;
    end if;
   end if;
   end loop;
  end p_chg_solot;
--4.0>
--Ini 6.0
procedure p_consulta_cambio_estado(n_codsolot   number,
                                   ac_salida    OUT SYS_REFCURSOR,
                                   ac_resultado out varchar2,
                                   ac_mensaje   out varchar2) is
  ln_valores number;
  error_no_valor exception;
begin
  ac_resultado := '0';
  ac_mensaje   := 'Exito';
  open ac_salida for
    select estsol.descripcion estado,
           solotchgest.fecha,
           solotchgest.codusu idusuario,
           u.nombre usuario,
           solotchgest.observacion
      from solot, estsol, solotchgest, usuarioope u
     where solot.codsolot = solotchgest.codsolot
       and solotchgest.estado = estsol.estsol
       and solotchgest.tipo = 1
       and solotchgest.codusu = u.usuario(+)
       and solot.codsolot = n_codsolot
    union all
    select estsolope.descripcion estado,
           solotchgest.fecha,
           solotchgest.codusu idusuario,
           u.nombre usuario,
           solotchgest.observacion
      from solot, estsolope, solotchgest, usuarioope u
     where solot.codsolot = solotchgest.codsolot
       and solotchgest.estado = estsolope.estsolope
       and solotchgest.tipo = 2
       and solotchgest.codusu = u.usuario(+)
       and solot.codsolot = n_codsolot;

  select count(1)
    into ln_valores
    from (select solot.codsolot
            from solot, estsol, solotchgest, usuarioope u
           where solot.codsolot = solotchgest.codsolot
             and solotchgest.estado = estsol.estsol
             and solotchgest.tipo = 1
             and solotchgest.codusu = u.usuario(+)
             and solot.codsolot = n_codsolot
          union all
          select solot.codsolot
            from solot, estsolope, solotchgest, usuarioope u
           where solot.codsolot = solotchgest.codsolot
             and solotchgest.estado = estsolope.estsolope
             and solotchgest.tipo = 2
             and solotchgest.codusu = u.usuario(+)
             and solot.codsolot = n_codsolot);

  if ln_valores = 0 then
    raise error_no_valor;
  end if;
exception
  when error_no_valor then
    ac_resultado := '1';
    ac_mensaje   := 'No se encontraron datos para la búsqueda.';
  when others then
    ac_resultado := '-1';
    ac_mensaje   := 'Error: ' || sqlcode || ' ' || sqlerrm;
end p_consulta_cambio_estado;
--Fin 6.0

-- Ini 9.0
  procedure p_centro_poblado_lte(ac_ubigeo        in varchar2,
                                 ac_cobertura_dth in number,
                                 ac_cobertura_lte in number,
                                 ao_cursor        out SYS_REFCURSOR,
                                 an_codigo_error  out number,
                                 ac_mensaje_error out varchar2)
  is
  begin

    open ao_cursor for
      select cp.idpoblado,
       cp.idubigeo,
       cp.codclasificacion,
       cp.clasificacion,
       cp.codcategoria,
       cp.categoria,
       cp.nombre,
       cp.poblacion,
       cp.cobertura,
       cp.cobertura_lte
  from pvt.tabpoblado@DBL_PVTDB cp
 where cp.idubigeo = ac_ubigeo
   and cp.cobertura=ac_cobertura_dth
   and cp.cobertura_lte=ac_cobertura_lte;

    an_codigo_error  := 0;
    ac_mensaje_error := null;

  exception
    when others then
      an_codigo_error  := -2;
      ac_mensaje_error := SQLERRM;
  end p_centro_poblado_lte;
-- Fin 9.0


PROCEDURE SIACSS_CONSULTA_ESTADOS_AGENDA(P_COD_SOLOT NUMBER,
                                       P_CODIGO_RESPUESTA OUT NUMBER,
                                       P_MENSAJE_RESPUESTA OUT VARCHAR2,
                                       P_CUR_SALIDA OUT SYS_REFCURSOR) IS
BEGIN
  OPEN P_CUR_SALIDA FOR
  select  a.idagenda ID_AGENDA,
  b.descripcion ESTADO_AGENDA,
  a.observacion OBSERVACION,
  a.usureg USUARIO_REG,
  c.nombre NOMBRE_USER,
  a.fecreg FECHA_REG,
  a.fechaejecutado FECHA_EJECUTADO,
  (select desc_larga
   from operacion.estado_adc
   where id_estado = a.idestado_adc) ESTADO_ADC,
  d.codmot_solucion MOTIVO_SOL ,
  a.idseq ID_SEQ,
  e.codcon ID_CONTRATA,
  e.fecagenda FECHA_PROGRAMACION,
  co.nombre NOMBRE_CONTRATA
  from  agendamientochgest a, estagenda b, usuarioope c,mot_Solucion d,agendamiento e,contrata co
  where e.codsolot=  P_COD_SOLOT
  and a.estado = b.estage
  and a.idagenda=e.idagenda
  and a.usureg=c.usuario
  and a.codmot_solucion=d.codmot_solucion(+)
  and e.codcon = co.codcon
  order by a.fecreg desc;


  P_CODIGO_RESPUESTA := 0;
  P_MENSAJE_RESPUESTA := 'OK';

  EXCEPTION
    WHEN OTHERS THEN
      P_CODIGO_RESPUESTA := -2;
      P_MENSAJE_RESPUESTA := SQLERRM;
END;


end;
/
