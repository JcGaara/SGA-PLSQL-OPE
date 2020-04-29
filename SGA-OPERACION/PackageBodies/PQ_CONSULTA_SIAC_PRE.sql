CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_CONSULTA_SIAC_PRE is

  PROCEDURE P_DATOS_CLIENTE(P_CODRECARGA IN VARCHAR,
                            C_CUR_DATOS  OUT CUR_SGAT,
                            P_ERROR      OUT VARCHAR) IS
  /*****************************************************************************
    Ver        Fecha        Autor           Descripcion
   ---------  ----------  ---------------  ------------------------------------

    1.0       04/10/2011  José Ramos       Procedimiento que consulta los datos de un cliente
                                           en base al codigo de recarga (solo para servicio DTH)
  ******************************************************************************/

    p_codcli vtatabcli.codcli%type;
  BEGIN
    P_ERROR := '00';

    select codcli
      into p_codcli
      from ope_srv_recarga_cab
     where codigo_recarga = P_CODRECARGA
       and rownum < 2;

    OPEN C_CUR_DATOS FOR
      select v.nomcli as nombre,
             v.dircli direccion,
             decode(did.flg_int, 1, v.ntdide, did.nrodoc_default) nro_documento,
             v.codcli
        from vtatabcli v, vtatipdid did
       where v.tipdide = did.tipdide
         and codcli = p_codcli;
  EXCEPTION
    WHEN OTHERS THEN
      P_ERROR := '02';
  END P_DATOS_CLIENTE;

  PROCEDURE P_DATOS_INCIDENCIA(P_CODRECARGA IN VARCHAR,
                               C_CUR_DATOS  OUT CUR_SGAT,
                               P_ERROR      OUT VARCHAR) IS
  /*****************************************************************************
    Ver        Fecha        Autor           Descripcion
   ---------  ----------  ---------------  ------------------------------------

    1.0       04/10/2011  José Ramos       Procedimiento que consulta los datos principales de las incidencias
                                           generadas para un servicio DTH en base al codigo de recarga
  ******************************************************************************/
    p_codcli       vtatabcli.codcli%type;
    l_user_proceso varchar2(100);
    l_constante    varchar2(100);
  BEGIN
    P_ERROR := '00';

    select codcli
      into p_codcli
      from ope_srv_recarga_cab
     where codigo_recarga = P_CODRECARGA
       and rownum < 2;

    select codigoc
      into l_user_proceso
      from opedd
     where tipopedd = 1025
       and abreviacion = 'User Proceso';

    select codigoc
      into l_constante
      from opedd
     where tipopedd = 1025
       and abreviacion = 'DTH';

    OPEN C_CUR_DATOS FOR
      select distinct /*+ index(c,IDX_OPE_SRV_RECARGA_CAB_3)*/
                      i.codincidence numero_incidencia,
                      v.sequencedate as fecha_apertura,
                      l_constante || ' - ' ||
                      (select upper(incidence_type.description) || ' - ' ||
                              upper(incidence_description.description) dessubtype
                         from incidence_subtype,
                              incidence_description,
                              incidence_type
                        where (incidence_subtype.codincdescription =
                              incidence_description.codincdescription)
                          and (incidence_subtype.codinctype =
                              incidence_type.codinctype)
                          and ((incidence_subtype.active = 1))
                          and (incidence_subtype.codsubtype = i.codsubtype)) || ' - ' ||
                       upper(cas.DESCRIPTION) tipo_incidencia,
                      trim(v.userid) as usuario_registro,
                      (select upper(nombre)
                         from usuarioope
                        where usuario = v.userid) nombre_usuario,
                      '' apellido_usuario,
                      upper(channel.description) canal_ingreso,
                      l_user_proceso user_proceso,
                      upper(status.description) as estado_incidencia,
                      cxi.service servicio
        from incidence i,
             v_incidence_gen v,
             customerxincidence cxi,
             CASE_ATENTION cas,
             status,
             channel,
             inssrv,
             ope_srv_recarga_cab c,
             ope_srv_recarga_det d
       where i.codincidence = v.codincidence
         and cas.codcase=v.codcase
         and i.codincidence = cxi.codincidence
         and cxi.customercode = p_codcli
         and i.codstatus = status.codstatus
         and i.codchannel = channel.codchannel
         and cxi.servicenumber = inssrv.codinssrv(+)
         and inssrv.codinssrv = d.codinssrv
         and d.numregistro = c.numregistro
         and c.codigo_recarga = P_CODRECARGA;
  EXCEPTION
    WHEN OTHERS THEN
      P_ERROR := '02';
  END P_DATOS_INCIDENCIA;

  PROCEDURE P_DATOS_INCIDENCIA_FECHAS(P_CODRECARGA IN VARCHAR,
                                      C_CUR_DATOS  OUT CUR_SGAT,
                                      P_FECINI     IN VARCHAR,
                                      P_FECFIN     IN VARCHAR,
                                      P_ERROR      OUT VARCHAR) IS
  /*****************************************************************************
    Ver        Fecha        Autor           Descripcion
   ---------  ----------  ---------------  ------------------------------------

    1.0       04/10/2011  José Ramos       Procedimiento que consulta los datos principales de las incidencias
                                           generadas para un servicio DTH en base al codigo de recarga
  ******************************************************************************/
    p_codcli       vtatabcli.codcli%type;
    l_user_proceso varchar2(100);
    l_constante    varchar2(100);
  BEGIN
    P_ERROR := '00';

    select codcli
      into p_codcli
      from ope_srv_recarga_cab
     where codigo_recarga = P_CODRECARGA
       and rownum < 2;

    select codigoc
      into l_user_proceso
      from opedd
     where tipopedd = 1025
       and abreviacion = 'User Proceso';

   select codigoc
        into l_constante
        from opedd
       where tipopedd = 1025
         and abreviacion = 'DTH';

    OPEN C_CUR_DATOS FOR
      select distinct /*+ index(c,IDX_OPE_SRV_RECARGA_CAB_3)*/
                      i.codincidence numero_incidencia,
                      v.sequencedate as fecha_apertura,
                      l_constante || ' - ' ||
                      (select upper(incidence_type.description) || ' - ' ||
                              upper(incidence_description.description) dessubtype
                         from incidence_subtype,
                              incidence_description,
                              incidence_type
                        where (incidence_subtype.codincdescription =
                              incidence_description.codincdescription)
                          and (incidence_subtype.codinctype =
                              incidence_type.codinctype)
                          and ((incidence_subtype.active = 1))
                          and (incidence_subtype.codsubtype = i.codsubtype)) || ' - ' ||
                       upper(cas.DESCRIPTION) tipo_incidencia,
                      trim(v.userid) as usuario_registro,
                      (select upper(nombre)
                         from usuarioope
                        where usuario = v.userid) nombre_usuario,
                      '' apellido_usuario,
                      upper(channel.description) canal_ingreso,
                      l_user_proceso user_proceso,
                      upper(status.description) as estado_incidencia,
                      cxi.service servicio
        from incidence i,
             v_incidence_gen v,
             customerxincidence cxi,
             CASE_ATENTION cas,
             status,
             channel,
             inssrv,
             ope_srv_recarga_cab c,
             ope_srv_recarga_det d
       where i.codincidence = v.codincidence
         and cas.codcase=v.codcase
         and i.codincidence = cxi.codincidence
         and cxi.customercode = p_codcli
         and i.codstatus = status.codstatus
         and i.codchannel = channel.codchannel
         and cxi.servicenumber = inssrv.codinssrv(+)
         and inssrv.codinssrv = d.codinssrv
         and d.numregistro = c.numregistro
         and c.codigo_recarga = P_CODRECARGA
         and trunc(v.SEQUENCEDATE) >= to_date(P_FECINI,'dd/mm/yyyy')
         and trunc(v.SEQUENCEDATE) <= to_date(P_FECFIN,'dd/mm/yyyy');
  EXCEPTION
    WHEN OTHERS THEN
      P_ERROR := '02';
  END P_DATOS_INCIDENCIA_FECHAS;

  PROCEDURE P_SEGUIMIENTO_INCIDENCIA(P_CODINCIDENCE IN VARCHAR,
                                     C_CUR_DATOS    OUT CUR_SGAT,
                                     P_ERROR        OUT VARCHAR) IS
  /*****************************************************************************
    Ver        Fecha        Autor           Descripcion
   ---------  ----------  ---------------  ------------------------------------

    1.0       04/10/2011  José Ramos       Procedimiento que consulta los datos de seguimiento de las incidencias
                                           generadas para un servicio DTH en base al codincidence
  ******************************************************************************/
  BEGIN
    P_ERROR := '00';

    OPEN C_CUR_DATOS FOR
      select distinct trim(seq.userid) recepcionista,
                      seq.sequencedate fecha,
                      status.description estado,
                      department.description area_origen,
                      seq.userid usuario_origen,
                      department_c.description area_destino,
                      seq.deliveruser usuario_destino,
                      seq.observation observacion,
                      tt.description tipo_problema,
                      t.observation problema,
                      st.description tipo_solucion,
                      s.observation solucion
        from incidence i,
             incidence_sequence seq,
             trouble t,
             solution s,
             solution_type st,
             trouble_type tt,
             status,
             department,
             department department_c
       where i.codincidence = P_CODINCIDENCE
         and seq.codincidence = i.codincidence
         and seq.receiverdepartment = department.coddepartment
         and seq.deliverdepartment = department_c.coddepartment
         and seq.codincidence = t.codincidence(+)
         and seq.codsequence = t.codsequence(+)
         and seq.codincidence = s.codincidence(+)
         and seq.codsequence = s.codsequence(+)
         and t.codtroubletype = tt.codtroubletype(+)
         and s.codsolutiontype = st.codsolutiontype(+)
         and seq.codstatus = status.codstatus
         order by 2 asc;
  EXCEPTION
    WHEN OTHERS THEN
      P_ERROR := '02';
  END P_SEGUIMIENTO_INCIDENCIA;

  PROCEDURE P_DATOS_ULTIMO_SERVICIO(P_CODRECARGA IN VARCHAR,
                                    C_CUR_DATOS  OUT CUR_SGAT,
                                    P_ERROR      OUT VARCHAR) IS
  /*****************************************************************************
    Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------  ------------------------------------

    1.0       04/10/2011  José Ramos       Procedimiento que consulta los datos principales del último servicio
                                           DTH relacionados al codigo de recarga
  ******************************************************************************/

  l_max_numregistro ope_srv_recarga_cab.numregistro%type;

  BEGIN
    P_ERROR := '00';


    select max(numregistro)
    into l_max_numregistro
    from ope_srv_recarga_cab
    where codigo_recarga=P_CODRECARGA;

    OPEN C_CUR_DATOS FOR
      select distinct cab.codigo_recarga,
                      i.numero servicio,
                      cab.numregistro,
                      decode((select count(1)
                               from ope_srv_recarga_cab a, vtatabslcfac v
                              where a.flg_recarga = 1
                                and a.estado = '03'
                                and (((select trunc(b.fecfin)
                                         from operacion.control_corte_dth aa,
                                              solot                       b
                                        where aa.idctrlcorte =
                                              (select max(idctrlcorte)
                                                 from operacion.control_corte_dth
                                                where numregistro =
                                                      a.numregistro
                                                  and tipo = 'SUSPENSION'
                                                  and estcorte = 3)
                                          and aa.codsolot = b.codsolot) +
                                    (select b.codigon
                                         from operacion.tipopedd a,
                                              operacion.opedd    b
                                        where a.abrev = 'DTHRECARDIAS'
                                          and a.tipopedd = b.tipopedd
                                          and b.abreviacion = 'CORTE')) >
                                    trunc(sysdate))
                                and a.numslc = v.numslc
                                and exists
                              (select 1
                                       from ope_srv_recarga_cab aa
                                      where ((select max(idctrlcorte)
                                                from operacion.control_corte_dth
                                               where numregistro =
                                                     a.numregistro
                                                 and estcorte = 3) =
                                            (select max(idctrlcorte)
                                                from operacion.control_corte_dth
                                               where numregistro =
                                                     a.numregistro
                                                 and tipo = 'SUSPENSION'
                                                 and estcorte = 3))
                                        and aa.numregistro = a.numregistro)
                                and a.numslc = v.numslc
                                and exists
                              (select 1
                                       from opedd o, tipopedd b
                                      where o.tipopedd = b.tipopedd
                                        and b.abrev = 'CORTETIPTRA'
                                        and o.codigon is not null
                                        and o.codigon_aux is not null
                                        and o.codigoc =
                                            to_char(v.idsolucion))
                                and a.numregistro = cab.numregistro),
                             0,
                             t.descripcion,
                             (select o.descripcion
                                from ope_estado_recarga o
                               where o.codestrec = '05')) estado_registro,
                      (select upper(observacion)
                         from paquete_venta
                        where idpaq = cab.idpaq) paquete_venta,
                      (select upper(dscsrv) from tystabsrv where codsrv = i.codsrv) producto,
                      cab.fecusu fecha_activacion,
                      cab.fecinivig,
                      cab.fecfinvig,
                      cab.feccorte,
                      cab.codcli codigo_sga
        from ope_srv_recarga_cab cab,
             ope_srv_recarga_det det,
             inssrv              i,
             ope_estado_recarga  t
       where cab.numregistro = det.numregistro
         and det.codinssrv = i.codinssrv
         and t.codestrec = cab.estado
         and cab.codigo_recarga = P_CODRECARGA
         and cab.numregistro=l_max_numregistro;

  EXCEPTION
    WHEN OTHERS THEN
      P_ERROR := '02';
  END P_DATOS_ULTIMO_SERVICIO;

 PROCEDURE P_DATOS_SERVICIOS(P_CODRECARGA IN VARCHAR,
                             C_CUR_DATOS  OUT CUR_SGAT,
                             P_ERROR      OUT VARCHAR) IS
  /*****************************************************************************
    Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------  ------------------------------------

    1.0       04/10/2011  José Ramos       Procedimiento que consulta los datos principales de todos los servicios
                                           DTH relacionados al codigo de recarga
  ******************************************************************************/


  BEGIN
    P_ERROR := '00';


    OPEN C_CUR_DATOS FOR
      select distinct cab.codigo_recarga,
                      i.numero servicio,
                      cab.numregistro,
                      decode((select count(1)
                               from ope_srv_recarga_cab a, vtatabslcfac v
                              where a.flg_recarga = 1
                                and a.estado = '03'
                                and (((select trunc(b.fecfin)
                                         from operacion.control_corte_dth aa,
                                              solot                       b
                                        where aa.idctrlcorte =
                                              (select max(idctrlcorte)
                                                 from operacion.control_corte_dth
                                                where numregistro =
                                                      a.numregistro
                                                  and tipo = 'SUSPENSION'
                                                  and estcorte = 3)
                                          and aa.codsolot = b.codsolot) +
                                    (select b.codigon
                                         from operacion.tipopedd a,
                                              operacion.opedd    b
                                        where a.abrev = 'DTHRECARDIAS'
                                          and a.tipopedd = b.tipopedd
                                          and b.abreviacion = 'CORTE')) >
                                    trunc(sysdate))
                                and a.numslc = v.numslc
                                and exists
                              (select 1
                                       from ope_srv_recarga_cab aa
                                      where ((select max(idctrlcorte)
                                                from operacion.control_corte_dth
                                               where numregistro =
                                                     a.numregistro
                                                 and estcorte = 3) =
                                            (select max(idctrlcorte)
                                                from operacion.control_corte_dth
                                               where numregistro =
                                                     a.numregistro
                                                 and tipo = 'SUSPENSION'
                                                 and estcorte = 3))
                                        and aa.numregistro = a.numregistro)
                                and a.numslc = v.numslc
                                and exists
                              (select 1
                                       from opedd o, tipopedd b
                                      where o.tipopedd = b.tipopedd
                                        and b.abrev = 'CORTETIPTRA'
                                        and o.codigon is not null
                                        and o.codigon_aux is not null
                                        and o.codigoc =
                                            to_char(v.idsolucion))
                                and a.numregistro = cab.numregistro),
                             0,
                             t.descripcion,
                             (select o.descripcion
                                from ope_estado_recarga o
                               where o.codestrec = '05')) estado_registro,
                      (select upper(observacion)
                         from paquete_venta
                        where idpaq = cab.idpaq) paquete_venta,
                      (select upper(dscsrv) from tystabsrv where codsrv = i.codsrv) producto,
                      cab.fecusu fecha_activacion,
                      cab.fecinivig,
                      cab.fecfinvig,
                      cab.feccorte,
                      cab.codcli codigo_sga
        from ope_srv_recarga_cab cab,
             ope_srv_recarga_det det,
             inssrv              i,
             ope_estado_recarga  t
       where cab.numregistro = det.numregistro
         and det.codinssrv = i.codinssrv
         and t.codestrec = cab.estado
         and cab.codigo_recarga = P_CODRECARGA
         order by 3 desc;

  EXCEPTION
    WHEN OTHERS THEN
      P_ERROR := '02';

  END P_DATOS_SERVICIOS;

  PROCEDURE P_DATOS_SOLICITUD(P_CODRECARGA IN VARCHAR,
                              C_CUR_DATOS  OUT CUR_SGAT,
                              P_ERROR      OUT VARCHAR) IS
  /*****************************************************************************
    Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------  ------------------------------------

    1.0       04/10/2011  José Ramos       Procedimiento que consulta los datos de las solcitudes
                                           de orden de trabajo para los servicios DTH en base al codigo de recarga
  ******************************************************************************/
  BEGIN
    P_ERROR := '00';

    OPEN C_CUR_DATOS FOR
      select distinct s.codsolot,
                      s.numslc proyecto,
                      (select upper(descripcion)
                         from tiptrabajo
                        where tiptra = s.tiptra) tipo_sot,
                      (select upper(descripcion)
                         from estsol
                        where estsol = s.estsol) estado_sot,
                      s.fecusu fecha_generacion,
                      s.fecfin fecha_fin,
                      s.codusu solicitante,
                      (select upper(descripcion)
                         from areaope
                        where area = s.areasol) area,
                      i.numero servicio
        from solot               s,
             solotpto            so,
             inssrv              i,
             ope_srv_recarga_cab c,
             ope_srv_recarga_det d,
             vtatabcli           v
       where s.codsolot = so.codsolot
         and so.codinssrv = i.codinssrv
         and i.codinssrv = d.codinssrv
         and d.numregistro = c.numregistro
         and s.codcli = v.codcli
         and c.codigo_recarga = P_CODRECARGA
       order by 1 desc;
  EXCEPTION
    WHEN OTHERS THEN
      P_ERROR := '02';
  END P_DATOS_SOLICITUD;

 PROCEDURE P_DATOS_SOLICITUD_FECHAS(P_CODRECARGA IN VARCHAR,
                                       P_FECINI     IN VARCHAR,
                                       P_FECFIN     IN VARCHAR,
                                       C_CUR_DATOS  OUT CUR_SGAT,
                                       P_ERROR      OUT VARCHAR) IS
  /*****************************************************************************
    Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------  ------------------------------------

    1.0       04/10/2011  José Ramos       Procedimiento que consulta los datos de las solcitudes
                                           de orden de trabajo para los servicios DTH en base al codigo de recarga
                                           en un rango de fechas indicado
  ******************************************************************************/

  BEGIN
    P_ERROR := '00';

    OPEN C_CUR_DATOS FOR
      select distinct s.codsolot,
                      s.numslc proyecto,
                      (select upper(descripcion)
                         from tiptrabajo
                        where tiptra = s.tiptra) tipo_sot,
                      (select upper(descripcion)
                         from estsol
                        where estsol = s.estsol) estado_sot,
                      s.fecusu fecha_generacion,
                      s.fecfin fecha_fin,
                      s.codusu solicitante,
                      (select upper(descripcion)
                         from areaope
                        where area = s.areasol) area,
                      i.numero servicio
        from solot               s,
             solotpto            so,
             inssrv              i,
             ope_srv_recarga_cab c,
             ope_srv_recarga_det d,
             vtatabcli           v
       where s.codsolot = so.codsolot
         and so.codinssrv = i.codinssrv
         and i.codinssrv = d.codinssrv
         and d.numregistro = c.numregistro
         and s.codcli = v.codcli
         and trunc(s.fecusu) >= to_date(P_FECINI,'dd/mm/yyyy')
         and trunc(s.fecusu) <= to_date(P_FECFIN,'dd/mm/yyyy')
         and c.codigo_recarga = P_CODRECARGA
       order by 1 desc;
  EXCEPTION
    WHEN OTHERS THEN
      P_ERROR := '02';
  END P_DATOS_SOLICITUD_FECHAS;

  PROCEDURE P_DATOS_RECARGAS(P_CODRECARGA IN VARCHAR,
                             C_CUR_DATOS  OUT CUR_SGAT,
                             P_ERROR      OUT VARCHAR) IS
  /*****************************************************************************
    Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------  ------------------------------------

    1.0       04/10/2011  José Ramos       Procedimiento que consulta los datos de las recargas virtuales
                                           para un servicio DTH en base al codigo de recarga
  ******************************************************************************/
    l_tipo_pago      varchar2(100);
    l_debito_credito varchar2(100);
  BEGIN
    P_ERROR := '00';

    select codigoc
      into l_tipo_pago
      from opedd
     where tipopedd = 1025
       and abreviacion = 'Tipo Pago';

    select codigoc
      into l_debito_credito
      from opedd
     where tipopedd = 1025
       and abreviacion = 'Debito Credito';

    OPEN C_CUR_DATOS FOR
      select c.fecusu fecha_registro,
             l_tipo_pago tipo_pago,
             l_debito_credito credito_debito,
             c.monto saldo,
             upper(c.agenterecarga) agenterecarga,
             c.desde,
             c.hasta,
             (c.hasta - c.desde) dias,
             c.codsolot solicitud,
             decode(c.estado, 1, 'EFECTUADO', 9, 'ANULADO', 'OTRO') estado,
             c.numregistro
        from cuponpago_dth c
       where c.codigo_recarga = P_CODRECARGA
       order by 1 desc;
  EXCEPTION
    WHEN OTHERS THEN
      P_ERROR := '02';
  END P_DATOS_RECARGAS;

  PROCEDURE P_DATOS_RECARGAS_FECHAS(P_CODRECARGA IN VARCHAR,
                                    P_FECINI     IN VARCHAR,
                                    P_FECFIN     IN VARCHAR,
                                    C_CUR_DATOS  OUT CUR_SGAT,
                                    P_ERROR      OUT VARCHAR) IS
  /*****************************************************************************
    Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------  ------------------------------------

    1.0       04/10/2011  José Ramos       Procedimiento que consulta los datos de las recargas virtuales
                                           para un servicio DTH en base al codigo de recarga en un intervalo
                                           de fechas indicadas
  ******************************************************************************/
    l_tipo_pago      varchar2(100);
    l_debito_credito varchar2(100);
  BEGIN
    P_ERROR := '00';

    select codigoc
      into l_tipo_pago
      from opedd
     where tipopedd = 1025
       and abreviacion = 'Tipo Pago';

    select codigoc
      into l_debito_credito
      from opedd
     where tipopedd = 1025
       and abreviacion = 'Debito Credito';

    OPEN C_CUR_DATOS FOR
      select c.fecusu fecha_registro,
             l_tipo_pago tipo_pago,
             l_debito_credito credito_debito,
             c.monto saldo,
             upper(c.agenterecarga) agenterecarga,
             c.desde,
             c.hasta,
             (c.hasta - c.desde) dias,
             c.codsolot solicitud,
             decode(c.estado, 1, 'EFECTUADO', 9, 'ANULADO', 'OTRO') estado,
             c.numregistro
        from cuponpago_dth c
       where c.codigo_recarga = P_CODRECARGA
       and trunc(c.fecusu) >= to_date(P_FECINI,'dd/mm/yyyy')
       and trunc(c.fecusu) <= to_date(P_FECFIN,'dd/mm/yyyy')
       order by 1 desc;
  EXCEPTION
    WHEN OTHERS THEN
      P_ERROR := '02';
  END P_DATOS_RECARGAS_FECHAS;

end PQ_CONSULTA_SIAC_PRE;
/


