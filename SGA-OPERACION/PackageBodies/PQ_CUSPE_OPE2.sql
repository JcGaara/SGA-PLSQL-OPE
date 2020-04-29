CREATE OR REPLACE PACKAGE BODY OPERACION.pq_cuspe_ope2 AS
  /**************************************************************
  NOMBRE:     PQ_CUSPE_OPE2
  PROPOSITO:  Manejo de las customizaciones de Operaciones.Segundo paquete de customizaciones.
  PROGRAMADO EN JOB:  SI

  REVISIONES:
  Version      Fecha        Autor                   Descripcisn
  ---------  ----------  ---------------            ------------------------
  1.0        08/05/2009  Hector Huaman Mendoza      Se creo el procedimiento P_INSERTA_VTA_CAB_ORDEN para registrar el envio a BrightStar  para la venta de PC
  2.0        08/09/2009  Miguel Aroñe               Req. 102127 se cambio el nombre del paquete invocado
  3.0        24/05/2009  Miguel Aroñe               Req. 114326 - Cortes y reconexiones servicios inalambricos creacion de workflows
  4.0        21/09/2010  Joseph Asencios            REQ.142338 REQ-MIGRACION-DTH:
  5.0        06/10/2010                             REQ.139588 Cambio de Marca
  6.0        10/02/2011  Alexander Yong             REQ-148648: Requerimiento para Instalar más de 01 línea telefónica por equipo eMTA
  7.0        23/02/2011  Antonio Lagos              REQ-148648: Requerimiento para Instalar más de 01 línea telefónica por equipo eMTA
  8.0        30/04/2011  Edilberto Astulle
  9.0        07/04/2011  Luis Patiño                PROY: SUMA DE CARGOS
  10.0       29/08/2011  Alexander Yong             REQ-160185: SOTs Baja 3Play
  11.0       20/12/2011  Edilberto Astulle          PROY-0935 Liberación de número de Clientes que están dado de baja
  12.0       02/11/2011  Widmer Quispe              Sincronización 11/05/2012 -  REQ 161199 - DTH Post Venta
  13.0       18/06/2012  Edson Caqui                Roberto Sanchez        Req.162626-Procedimiento Shell anulacion de sots
  14.0       16/01/2013  Arturo Saavedra            Arturo Saavedra        PROY-6748 IDEA-1324 Automatizar Cambio de Estado de SOT's a ANULADA
  15.0       06/08/2013  Dorian Sucasaca            Arturo Saavedra Req: 164536 Servicio de TV satelital empresas tiene problemas (67 Funciona, 119 No Funciona)
  16.0       24/06/2013  Carlos Lazarte             Tommy Arakaki         RQM 164387 - Mejora en Operaciones
  17.0       10/10/2013  Dorian Sucasaca            Tommy Arakaki          REQ 164648 - Cambio y Migracion de Ip Fase 2
  18.0       17/01/2014  Carlos Lazarte             Manuel Gallegos        RQM 164797 - Incidencia reconexiones DTH Facturable
  19.0       17/01/2014  Dorian Sucasaca            Tommy Arakaki       Mejoras Cambio y Migracion de Ip Fase 2
  20.0       10/10/2013   Carlos Lazarte            Manuel Gallegos      REQ 164660 - Migracion Traslados Externos HFC
  21.0       10/03/2014  David Garcia B             Arturo Saavedra      PROY-12756 IDEA-13013-Implemen mej. de cod.de activac. HFC y borrado de reservas en IWAY
  22.0       26/05/2014  Jorge Armas                Manuel Gallegos      PQT-195288-TSK-49691 - Portabilidad Numérica Fija del Flujo Masivo
  23.0       16/05/2014  Arturo Saavedra            Manuel Gallegos      REQ 164660 - Migracion Traslados Externos HFC
  24.0       09/10/2014  Edilberto Astulle          SD_55424 OBSERVACION - SERIES EXCEDENTES
  25.0       23/10/2014  Edilberto Astulle          SD_94902  INCIDENCIAS RIPLEY SAN ISIDRO SN02
  26.0       13/02/2015  Edilberto Astulle          SD 231042
  27.0       30/06/2015  Luis Flores Osorio         SD-318468 Liberacion de Numero Telefonico SGA
  28.0       07/01/2016  Freddy Gonzales            SD-621816
  ***********************************************************************************************************************************/
  PROCEDURE p_baja_srv_cmd(a_idtareawf in number,
                           a_idwf      in number,
                           a_tarea     in number,
                           a_tareadef  in number) IS
    /******************************************************************************
       Ver        Date                        Author                            Description
       --------- ----------                   ---------------               ------------------------------------
       1.0    21/08/2008            Hector Huaman Mendoza     Procedimiento que cancelar la instancia de servicio, el circuito asignado al servicio y libera el número asignado al servicio.
       2.0    16/07/2009            Marco De la Cruz          Req. 97354 Corrección de baja y envío de correo por error
       3.0    12/08/2009            Rolando Martinez R.       Req. 99932 Se cambia el criterio de busqueda para actualizar la numtel
       4.0    08/09/2009            Miguel Aroñe              Req. 102127 se cambio el nombre del paquete invocado
    ******************************************************************************/
    /*  l_codsolot         solotpto.codsolot%type;
    BEGIN

      select codsolot into l_codsolot from wf where idwf = a_idwf;

      Update inssrv set estinssrv = 3 where codinssrv in (select codinssrv from solotpto where codsolot = l_codsolot);

      Update acceso set estado = 0 where CID IN (select CID from solotpto where codsolot = l_codsolot);

      Update numtel set codinssrv = null, estnumtel = 6 where codinssrv in (select codinssrv from solotpto where codsolot =l_codsolot);
    END;*/

    --Req. 97354
    l_codsolot  solotpto.codsolot%type;
    l_numero    numtel.numero%type;
    l_feccom    solot.feccom%type;
    l_codinssrv inssrv.codinssrv%type;
    v_mensaje   varchar2(500);

  BEGIN

    select codsolot into l_codsolot from wf where idwf = a_idwf;

    select distinct codinssrv
      into l_codinssrv
      from solotpto
     where codsolot = l_codsolot;

    select numero
      into l_numero
      from inssrv
     where tipinssrv = 3
       and codinssrv = l_codinssrv;

    select feccom into l_feccom from solot where codsolot = l_codsolot;

    if l_feccom is not null then

      Update inssrv
         set estinssrv = 3, fecfin = l_feccom
       where codinssrv = l_codinssrv;

      Update solotpto
         set fecinisrv = l_feccom
       where codinssrv = l_codinssrv;

      Update acceso
         set estado = 0
       where CID IN
             (select distinct CID from solotpto where codsolot = l_codsolot);

      Update numtel
         set codinssrv = null, estnumtel = 6
       where codinssrv = l_codinssrv; /*-- Req. 99932 --*/

      Update sales.reginfcdma
         set flg_reserva = 2
       where numslc in (select distinct numslc
                          from inssrv
                         where codinssrv = l_codinssrv);

      delete from reservatel
       where codcli in
             (select codcli from solot where codsolot = l_codsolot);
      commit;
    else

      v_mensaje := 'Se produjo un error al liberar el número ' || l_numero ||
                   'de la SOT Nro. ' || l_codsolot ||
                   ', No tiene fecha de compromiso';

      --    p_envia_correo_c_attach('Error Procedimiento Baja de Número Telefónico - CDMA',--5.0
      --                            'DL-PE-Inalambrico-Soportedegestionycontrol',v_mensaje, null,'SGA-Intraway' );--5.0

    end if;

  exception
    when others then

      v_mensaje := 'Se produjo un error al liberar el número ' || l_numero ||
                   'de la SOT Nro. ' || l_codsolot || sqlerrm;

    --    p_envia_correo_c_attach('Error Procedimiento Baja de Número Telefónico - CDMA',--5.0
    --                            'DL-PE-Inalambrico-Soportedegestionycontrol',v_mensaje, null,'SGA-Intraway' );--5.0

    --Req. 97354
  END;

  FUNCTION F_VALIDA_ETAPA(an_codsolot NUMBER, an_etapa NUMBER)
    RETURN VARCHAR2 is
    /******************************************************************************
       Ver        Date                        Author                            Description
       --------- ----------                   ---------------               ------------------------------------
       1.0    04/09/2008            Hector Huaman Mendoza                   Funcion realizada para la configuracion Brasil: reconocimiento de etapas de planta externa
    ******************************************************************************/

    an_pex    NUMERIC;
    an_pi     NUMERIC;
    an_valida numeric;
  BEGIN

    --Trabajos para planta Externa
    select count(*)
      into an_pex
      from efptoeta e, solot s, efpto f, solotpto p
     where e.codef = to_number(s.numslc)
       and e.codeta in (641, 642, 639, 638, 640, 679)
       and f.codef = e.codef
       and e.punto = f.punto
       and p.codsolot = s.codsolot
       and p.direccion = f.direccion
       and s.codsolot = an_codsolot;

    CASE TRIM(an_etapa)
      WHEN 1 THEN

        IF (an_pex IS NULL) or (an_pex = 0) THEN
          an_valida := 0;
        ELSE
          an_valida := 1;
        END IF;

      WHEN 2 THEN
        if an_pex = 0 then
          select count(*)
            into an_pi
            from efptoeta e, solot s, efpto f, solotpto p
           where e.codef = to_number(s.numslc)
             and e.codeta not in (641, 642, 639, 638, 640, 679)
             and f.codef = e.codef
             and e.punto = f.punto
             and p.codsolot = s.codsolot
             and p.direccion = f.direccion
             and s.codsolot = an_codsolot;
        else
          an_pi := 0;
        end if;

        IF (an_pi IS NULL) or (an_pi = 0) THEN
          an_valida := 0;
        ELSE
          an_valida := 1;
        END IF;

    END CASE;

    RETURN(an_valida);
  END;

  FUNCTION F_VALIDA_BOLSA_TELEFONIA(l_codsolot NUMBER, an_etapa NUMBER)
    RETURN VARCHAR2 is
    /******************************************************************************
       Ver        Date                        Author                            Description
       --------- ----------                   ---------------               ------------------------------------
       1.0    04/09/2008            Hector Huaman Mendoza                   Funcion realizada para la configuracion Brasil: reconocimiento de etapas de planta externa
    ******************************************************************************/

    l_count    number;
    l_bolsamin number;
    an_valida  numeric;

  BEGIN
    select count(*) into l_count from solotpto where codsolot = l_codsolot;

    select count(*)
      into l_bolsamin
      from solotpto s, tystabsrv t
     where s.codsrvnue = t.codsrv
       and t.idproducto in
           (203, 733, 755, 761, 695, 769, 762, 703, 752, 743, 759, 202, 760)
       and s.codsolot = l_codsolot;
    IF (l_bolsamin = l_count) THEN
      an_valida := 1;
    ELSE
      an_valida := 0;
    END IF;

    RETURN(an_valida);
  END;

  FUNCTION F_VALIDA_ADMIN_ROUTER(l_codsolot NUMBER, an_etapa NUMBER)
    RETURN VARCHAR2 is
    /******************************************************************************
       Ver        Date                        Author                            Description
       --------- ----------                   ---------------               ------------------------------------
       1.0    10/10/2008            Hector Huaman Mendoza                   Funcion realizada para la configuracion Brasil: reconocimiento del servicio Derecho de Admin. de Router x Usuario del Cliente.
    ******************************************************************************/

    l_count        number;
    l_admin_router number;
    an_valida      numeric;

  BEGIN
    select count(*) into l_count from solotpto where codsolot = l_codsolot;

    select count(*)
      into l_admin_router
      from solotpto s, tystabsrv t
     where s.codsrvnue = t.codsrv
       and t.codsrv = '1644'
       and s.codsolot = l_codsolot;
    IF (l_admin_router = l_count) THEN
      an_valida := 1;
    ELSE
      an_valida := 0;
    END IF;

    RETURN(an_valida);
  END;

  PROCEDURE P_GENERACION_CID(a_idtareawf in number,
                             a_idwf      in number,
                             a_tarea     in number,
                             a_tareadef  in number) IS

    /******************************************************************************
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        01/10/2008  Hector Huaman   Generación del Circuito(CID) para la SOT
                  23/12/2008  José Ramos      Se agrega el tipo de producto 530 en filtro
                                              de generación de CIDs automáticos Req. 79181
    ******************************************************************************/

    l_codsolot solotpto.codsolot%type;

    l_valida_flag number;
    CURSOR c1 IS
      select solotpto.puerta,
             insprd.flgprinc,
             codsolot,
             solotpto.codinssrv,
             tystabsrv.tipsrv,
             solotpto.pid,
             solotpto.punto,
             tystabsrv.dscsrv,
             tystabsrv.idproducto
        from solotpto, tystabsrv, insprd
       where solotpto.codsrvnue = tystabsrv.codsrv
         and solotpto.pid = insprd.pid(+)
         and codsolot = l_codsolot;

  BEGIN

    select codsolot into l_codsolot from wf where idwf = a_idwf;

    FOR au IN c1 LOOP
      IF au.flgprinc = 1 THEN
        UPDATE SOLOTPTO
           SET PUERTA = 1
         WHERE CODSOLOT = au.CODSOLOT
           AND PUNTO = au.PUNTO;
        UPDATE SOLOTPTO_ID
           SET FLG_PI = 1
         WHERE CODSOLOT = au.CODSOLOT
           AND PUNTO = au.PUNTO;
        IF au.idproducto <> 524 and au.idproducto <> 702 and
           au.idproducto <> 501 and au.idproducto <> 511 and
           au.idproducto <> 530 then
          METASOLV.P_MOVER_INSSRV_A_ACCESO(au.codinssrv);
        end if;
      ELSE
        UPDATE SOLOTPTO
           SET PUERTA = 0
         WHERE CODSOLOT = au.CODSOLOT
           AND PUNTO = au.PUNTO;
        UPDATE SOLOTPTO_ID
           SET FLG_PI = 0
         WHERE CODSOLOT = au.CODSOLOT
           AND PUNTO = au.PUNTO;
      END IF;
    END LOOP;

  END;

  PROCEDURE P_INSERTA_VTA_CAB_ORDEN(a_idtareawf in number,
                                    a_idwf      in number,
                                    a_tarea     in number,
                                    a_tareadef  in number) IS

    v_codsolot  solot.codsolot%type;
    p_mensaje   varchar(1000);
    p_error     number;
    p_resultado varchar2(10);

  BEGIN
    -- Capturo el codigo de la solot
    select codsolot into v_codsolot from wf where idwf = a_idwf;

    --<req id=102127 responsable="miguel.arone" fecha="2009.09.08" comentario="se cambio el nombre del paquete invocado">
    sales.PQ_VTA_BRIGHTSTAR.p_proceso_interfaz(v_codsolot,
                                               a_idtareawf,
                                               p_resultado,
                                               p_mensaje);
    --</req>

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := PQ_FND_UTILITARIO_INTERFAZ.FND_ESTADO_ERROR;
      p_mensaje   := SQLERRM;
  END;

  --ini 3.0
  /**********************************************************************
  Procedimiento que genera solicitudes de suspension/activacion al conax.
  **********************************************************************/
  procedure p_gen_archivo_tvsat(a_idtareawf in number,
                                a_idwf      in number,
                                a_tarea     in number,
                                a_tareadef  in number) is

    lc_mensaje     varchar2(2000);
    ln_codsolot    solot.codsolot%type;
    lc_idtrancorte cxc_transaccionescorte.tipo%type;
    ln_tipsol      ope_tvsat_sltd_cab.tiposolicitud%type;
    ln_codinssrv   cxc_inscabcorte.codinssrv%type;
    lc_codcli      cxc_inscabcorte.codcli%type;
    ln_idsol       ope_tvsat_sltd_cab.idsol%type;
    lc_idfac       cxctabfac.idfac%type;
    lc_bouquets    tystabsrv.codigo_ext%type;
    ln_largo       number(4);
    ln_numbouquets number(4);
    lc_codext      varchar2(10);
    lc_numregistro reginsdth.numregistro%type;
    lc_correos_it  varchar2(2000);
    le_error exception;
    ln_num number; --9.0
  begin
    --Obtencion del numero de solot
    begin
      select codsolot into ln_codsolot from wf where idwf = a_idwf;
    exception
      when others then
        lc_mensaje := 'Error al obtener la informacion el codigo de solot';
        raise le_error;
    end;

    --Se actualiza el estado de la tarea a ejecucion
    update tareawf
       set esttarea = 2 -- En ejecucion
     where idtareawf = a_idtareawf;

    --Obtencion de la transaccion
    begin

    --ini 18.0
      SELECT ins.codinssrv, b.codcli, b.idfaccxc
        INTO ln_codinssrv, lc_codcli, lc_idfac
        FROM OPERACION.TRSOAC oac, bilfac b, instanciaservicio ins
       WHERE oac.codsolot = ln_codsolot
         AND oac.idfac = b.idfaccxc
         AND b.idisprincipal = ins.idinstserv
         AND oac.idgrupocorte = 15; --DTH Facturable

      SELECT tiptrs
        INTO lc_idtrancorte
        FROM solot s, tiptrabajo tp
       WHERE s.tiptra = tp.tiptra
         AND s.codsolot = ln_codsolot;
    --fin 18.0

    exception
      when others then
        lc_mensaje := 'Error al obtener la informacion de la transaccion';
        raise le_error;
    end;

    --identificacion del tipo de solicitud
    --if lc_idtrancorte = PQ_CXC_CORTE.FND_TIPOTRAN_CORTE THEN
    if lc_idtrancorte = 3 THEN --18.0
      --Es una solicitud de suspension
      ln_tipsol := 1; --Suspension
    --elsif lc_idtrancorte = PQ_CXC_CORTE.FND_TIPOTRAN_RECONEXION THEN
    elsif lc_idtrancorte = 4 THEN --18.0
      --Es una solicitud de reconexion
      ln_tipsol := 2; --Reconexion
    end if;

    --Obtener Registro de Cliente DTH
    begin
      pq_dth.p_get_numregistro(ln_codsolot, lc_numregistro);
    exception
      when others then
        lc_mensaje := 'Error al obtener el numero de registro dth';
        raise le_error;
    end;

    --Se genera el idsol
    select sq_ope_tvsat_sltd_cab_idsol.nextval
      into ln_idsol
      from DUMMY_OPE;

    --creacion de la cabecera de la solicitud
    insert into ope_tvsat_sltd_cab
      (idsol,
       tiposolicitud,
       codinssrv,
       codcli,
       codsolot,
       idwf,
       idtareawf,
       estado,
       numregistro)
    values
      (ln_idsol,
       ln_tipsol,
       ln_codinssrv,
       lc_codcli,
       ln_codsolot,
       a_idwf,
       a_idtareawf,
       PQ_OPE_INTERFAZ_TVSAT.FND_ESTADO_PEND_EJECUCION,
       lc_numregistro);

    /**********************************************************
    Cursor para obtener las tarjetas y boquetes
    ***********************************************************/
    --ini REQ-MIGRACION-DTH 4.0
    /*for reg in(select distinct
     r.numregistro,
     r.estado,
     eqdth.serie,
     (select distinct tystabsrv.codigo_ext
       from paquete_venta, detalle_paquete, linea_paquete, producto, tystabsrv
       where paquete_venta.idpaq = r.idpaq
       and paquete_venta.idpaq = detalle_paquete.idpaq
       and detalle_paquete.iddet = linea_paquete.iddet
       and detalle_paquete.idproducto = producto.idproducto
       and detalle_paquete.flgestado = 1
       and linea_paquete.flgestado = 1
       and detalle_paquete.flgprincipal = 1
       and producto.tipsrv = (select valor from constante where constante = 'FAM_CABLE')
       and linea_paquete.codsrv = tystabsrv.codsrv
       and tystabsrv.codigo_ext is not null
     )codigo_ext
     from bilfac bil,
         cr,
         instxproducto prod,
         --insprd ip,
         reginsdth r,
         estregdth est,
         equiposdth eqdth,
         instanciaservicio instser
    where bil.idfaccxc = lc_idfac
     and bil.codcli = lc_codcli
     and bil.idbilfac = cr.idbilfac
     and cr.idinstprod = prod.idinstprod
     and instser.idinstserv = prod.idcod
     and instser.codinssrv = r.codinssrv
     \*and prod.pid = ip.pid
     and ip.pid = r.pid*\
     and r.codcli = bil.codcli
     --and r.codinssrv = ip.codinssrv
     and est.codestdth = r.estado
     and eqdth.numregistro=r.numregistro
     and nvl(r.flg_recarga, 0) = 0
     and nvl(est.tipoestado, 0) <> 3
     and est.activo = 1
     and eqdth.grupoequ = 1
     )loop*/

    for reg in (select distinct srv_cab.numregistro,
                                srv_cab.estado,
                                se.numserie serie,
                                (select
                                 --distinct tystabsrv.codigo_ext --9.0 se comenta
                                 distinct trim(PQ_OPE_BOUQUET.f_conca_bouquet_srv(tystabsrv.codsrv)) --9.0 se agrega
                                   from paquete_venta,
                                        detalle_paquete,
                                        linea_paquete,
                                        producto,
                                        tystabsrv
                                  where paquete_venta.idpaq = srv_cab.idpaq
                                    and paquete_venta.idpaq =
                                        detalle_paquete.idpaq
                                    and detalle_paquete.iddet =
                                        linea_paquete.iddet
                                    and detalle_paquete.idproducto =
                                        producto.idproducto
                                    and detalle_paquete.flgestado = 1
                                    and linea_paquete.flgestado = 1
                                    and detalle_paquete.flgprincipal = 1
                                    and producto.tipsrv =
                                        (select valor
                                           from constante
                                          where constante = 'FAM_CABLE')
                                    and linea_paquete.codsrv =
                                        tystabsrv.codsrv
                                       --and tystabsrv.codigo_ext is not null 9.0 se comenta
                                    and PQ_OPE_BOUQUET.f_conca_bouquet_srv(tystabsrv.codsrv) is not null --9.0 se agrega
                                 ) codigo_ext
                --fin 6.0>
                  from bilfac bil,
                       cr,
                       instxproducto prod,
                       ope_srv_recarga_cab srv_cab,
                       ope_srv_recarga_det srv_det,
                       solotptoequ se,
                       inssrv insope,
                       vtatabslcfac pro,
                       soluciones sol,
                       (select a.codigon tipequope, codigoc grupoequ
                          from opedd a, tipopedd b
                         where a.tipopedd = b.tipopedd
                           and b.abrev = 'TIPEQU_DTH_CONAX') te,
                       instanciaservicio instser
                 where bil.idfaccxc = lc_idfac
                   and bil.codcli = lc_codcli
                   and bil.idbilfac = cr.idbilfac
                   and cr.idinstprod = prod.idinstprod
                   and instser.idinstserv = prod.idcod
                   and instser.codinssrv = insope.codinssrv
                   and instser.codcli = insope.codcli
                   and srv_cab.numregistro = srv_det.numregistro
                   and srv_det.tipsrv =
                       (select valor
                          from constante
                         where constante = 'FAM_CABLE')
                   and instser.codinssrv = srv_det.codinssrv
                   and instser.codcli = srv_cab.codcli
                   and insope.codinssrv = srv_det.codinssrv
                   and insope.codcli = srv_cab.codcli
                   and insope.numslc = pro.numslc
                   and insope.codcli = pro.codcli
                   and pro.idsolucion = sol.idsolucion
                   -- ini 15.0
                   and pro.idsolucion in ( select idsolucion
                                             from  soluciones
                                            where  idgrupocorte in ( select idgrupocorte
                                                                       from cxc_grupocorte
                                                                      where idgrupocorte = 15 ))
                   -- fin 15.0
                   -- Ini 12.0
                   and sales.pq_dth_postventa.f_obt_solucion_dth(pro.idsolucion) = 1
                   -- Fin 12.0
                   and srv_cab.codsolot = se.codsolot
                   and srv_cab.codcli = bil.codcli
                   and srv_cab.estado in ('02', '03', '05') --se grego el estado 05 --9.0
                   and nvl(srv_cab.flg_recarga, 0) = 0
                   and se.tipequ = te.tipequope
                   and te.grupoequ = '1') loop
      --fin REQ-MIGRACION-DTH 4.00

      lc_bouquets    := trim(reg.codigo_ext);
      ln_largo       := length(lc_bouquets);
      ln_numbouquets := (ln_largo + 1) / 4;

      /**********************************
      Se separan los bouquetes
      **********************************/
      for i in 1 .. ln_numbouquets loop

        lc_codext := LPAD(operacion.f_cb_subcadena2(lc_bouquets, i), 8, '0');

        --Insercion en la tabla temporal
        insert into ope_tmp_tarjeta_bouquete
          (numregistro, serie, codext)
        values
          (reg.numregistro, reg.serie, lc_codext);

      end loop;

    end loop;

    /***********************************************
    Registro del detalle de la solicitud (Tarjetas)
    ************************************************/
    for reg in (select distinct serie
                  from ope_tmp_tarjeta_bouquete
                 order by serie asc) loop

      insert into ope_tvsat_sltd_det
        (idsol, serie)
      values
        (ln_idsol, reg.serie);

    --      ln_det := ln_det + 1;
    end loop;

    /***********************************************
    Registro de los bouquetes
    ************************************************/
    for reg in (select distinct serie, codext
                  from ope_tmp_tarjeta_bouquete
                 order by serie, codext) loop
      insert into ope_tvsat_sltd_bouquete_det
        (idsol, serie, bouquete, tipo)
      values
        (ln_idsol,
         reg.serie,
         reg.codext,
         2 --principal ln_tipsol 9.0 se comenta
         );
    end loop;

    if ln_tipsol = 1 then
      --suspension
      /**************************************************
      Bouquetes adicionales
      **************************************************/

      for reg in (select b.idsol, b.serie, a.bouquets
                    from bouquetxreginsdth a, ope_tvsat_sltd_det b
                   where b.idsol = ln_idsol
                     and a.tipo in (0, 3) --9.0
                     and a.estado = 1
                     and a.numregistro = lc_numregistro) loop

        lc_bouquets    := trim(reg.bouquets);
        ln_largo       := length(lc_bouquets);
        ln_numbouquets := (ln_largo + 1) / 4;

        for i in 1 .. ln_numbouquets loop
          lc_codext := LPAD(operacion.f_cb_subcadena2(lc_bouquets, i),
                            8,
                            '0');

          --<ini9.0
          select count(1)
            into ln_num
            from OPE_TVSAT_SLTD_BOUQUETE_DET
           where idsol = reg.idsol
             and serie = reg.serie
             and bouquete = lc_codext;

          if ln_num = 0 then
            --fin 9.0 >
            insert into OPE_TVSAT_SLTD_BOUQUETE_DET
              (idsol, serie, bouquete, tipo)
            values
              (reg.idsol, reg.serie, lc_codext, 1); --adicional ln_tipsol 9.0
          end if; -- 9.0 se agrega
        end loop;

      end loop;

      --<ini 9.0
    elsif ln_tipsol = 2 then
      --reconexion
      /**************************************************
       Bouquetes adicionales
      **************************************************/
      for reg in (select b.idsol,
                         b.serie,
                         trim(PQ_OPE_BOUQUET.f_conca_bouquet_srv(a.codsrv)) bouquets
                    from bouquetxreginsdth a, ope_tvsat_sltd_det b
                   where b.idsol = ln_idsol
                     and (a.tipo = 0 or
                         (a.tipo = 3 and nvl(pq_vta_paquete_recarga.f_get_dias_pendientes(a.pid,
                                                                                           sysdate),
                                              0) > 0) --adicional cnr
                         )
                     and a.estado = 0
                     and a.numregistro = lc_numregistro) loop

        lc_bouquets    := trim(reg.bouquets);
        ln_largo       := length(lc_bouquets);
        ln_numbouquets := (ln_largo + 1) / 4;

        for i in 1 .. ln_numbouquets loop
          lc_codext := LPAD(operacion.f_cb_subcadena2(lc_bouquets, i),
                            8,
                            '0');

          select count(1)
            into ln_num
            from OPE_TVSAT_SLTD_BOUQUETE_DET
           where idsol = reg.idsol
             and serie = reg.serie
             and bouquete = lc_codext;

          if ln_num = 0 then

            insert into OPE_TVSAT_SLTD_BOUQUETE_DET
              (idsol, serie, bouquete, tipo)
            values
              (reg.idsol,
               reg.serie,
               lc_codext,
               1 --adicional
               );
          end if;
        end loop;

      end loop;

    end if;

    /**************************************************
    Bouquetes promocionales
    **************************************************/
    if ln_tipsol = 1 then
      --suspension
      for reg in (select b.idsol, b.serie, a.bouquets
                    from bouquetxreginsdth a, ope_tvsat_sltd_det b
                   where b.idsol = ln_idsol
                     and a.tipo = 2
                     and a.estado = 1
                     and a.numregistro = lc_numregistro) loop

        lc_bouquets    := trim(reg.bouquets);
        ln_largo       := length(lc_bouquets);
        ln_numbouquets := (ln_largo + 1) / 4;

        for i in 1 .. ln_numbouquets loop
          lc_codext := LPAD(operacion.f_cb_subcadena2(lc_bouquets, i),
                            8,
                            '0');

          select count(1)
            into ln_num
            from OPE_TVSAT_SLTD_BOUQUETE_DET
           where idsol = reg.idsol
             and serie = reg.serie
             and bouquete = lc_codext;

          if ln_num = 0 then
            insert into OPE_TVSAT_SLTD_BOUQUETE_DET
              (idsol, serie, bouquete, tipo)
            values
              (reg.idsol,
               reg.serie,
               lc_codext,
               3 --promocional
               );
          end if;
        end loop;
      end loop;
    end if;

    if ln_tipsol = 1 then
      --suspension
      --se actualizan los bouquets adicionales y promocionales
      update bouquetxreginsdth
         set estado = 0, fecultenv = sysdate
       where numregistro = lc_numregistro
         and tipo in (0, 2, 3) --adicional, promocional, adicional cnr
         and estado = 1;
    else
      for reg in (select a.codsrv,
                         trim(PQ_OPE_BOUQUET.f_conca_bouquet_srv(a.codsrv)) codigo_ext
                    from bouquetxreginsdth a, tystabsrv b
                   where a.codsrv = b.codsrv
                     and (a.tipo = 0 or
                         (a.tipo = 3 and nvl(pq_vta_paquete_recarga.f_get_dias_pendientes(a.pid,
                                                                                           sysdate),
                                              0) > 0))
                     and a.estado = 0
                     and a.numregistro = lc_numregistro) loop
        --se actualizan los bouquets adicionales
        update bouquetxreginsdth
           set estado = 1, fecultenv = sysdate, bouquets = reg.codigo_ext --se actualiza el codigo externo
         where numregistro = lc_numregistro
           and (tipo = 0 --adicional
               or (tipo = 3 and nvl(pq_vta_paquete_recarga.f_get_dias_pendientes(pid,
                                                                                  sysdate),
                                     0) > 0))
           and estado = 0
           and codsrv = reg.codsrv;
      end loop;
    end if;
    --fin 9.0>

    insert into tareawfseg
      (idtareawf, observacion)
    values
      (a_idtareawf, 'Solicitud conax generada');

  exception
    when le_error then
      rollback;
      --Se actualiza el estado de la tarea a ejecucion
      update tareawf
         set esttarea = 19 -- En ejecucion
       where idtareawf = a_idtareawf;
      --Se ingresa una anotacion
      insert into tareawfseg
        (idtareawf, observacion)
      values
        (a_idtareawf, lc_mensaje);
      lc_correos_it := PQ_CXC_CORTE.f_obtener_parametro_servidor('cortesyreconexiones.correo.it.cortes_reconexiones');
      --Se envia correo
      p_envia_correo_c_attach('Error generacion de solicitud de suspension - DTH',
                              lc_correos_it,
                              lc_mensaje,
                              null,
                              'SGA'); --5.0
    when others then
      rollback;
      --Se actualiza el estado de la tarea a ejecucion
      update tareawf
         set esttarea = 19 -- En ejecucion
       where idtareawf = a_idtareawf;
      lc_mensaje := sqlerrm;
      --Se ingresa una anotacion
      insert into tareawfseg
        (idtareawf, observacion)
      values
        (a_idtareawf, lc_mensaje);
      lc_mensaje    := 'Se produjo un error en la ejecucion de la tarea ' ||
                       a_idtareawf || 'de la SOT Nro. ' || ln_codsolot ||
                       sqlerrm;
      lc_correos_it := PQ_CXC_CORTE.f_obtener_parametro_servidor('cortesyreconexiones.correo.it.cortes_reconexiones');
      p_envia_correo_c_attach('Error generacion de solicitud de suspension - DTH',
                              lc_correos_it,
                              lc_mensaje,
                              null,
                              'SGA'); --5.0
  end;
  --fin 3.0
  --Ini 6.0
  procedure p_gen_reserva_iway(a_idtareawf in number,
                               a_idwf      in number,
                               a_tarea     in number,
                               a_tareadef  in number) is

    v_codsolot  solot.codsolot%type;
    v_opcion    number(2);
    p_resultado varchar2(10);
    p_mensaje   varchar(1000);
    p_error     number;
    L_ESTN      NUMBER; --28.0
    L_ENV       NUMBER; --28.0
    L_ESTM      VARCHAR2(50); --28.0
    L_VALD      NUMBER; --28.0
  BEGIN
    -- Capturo el codigo de la solot
    select codsolot into v_codsolot from wf where idwf = a_idwf;

    v_opcion := 3; -- Alta de Servicios
    -- ini 28.0
      BEGIN
        SELECT CODIGON
          INTO L_VALD

          FROM OPEDD
         WHERE TIPOPEDD = 1687
           AND ABREVIACION = 'R_HFC_SGA';
      EXCEPTION
        WHEN OTHERS THEN
         L_VALD := 0;
      END;

       IF L_VALD = 1 THEN
         L_ENV := 0;
         L_ESTN := 6;
         L_ESTM := 'PENDIENTE RESERVA';
       ELSE
         L_ENV := 1;
         L_ESTN := 5;
         L_ESTM := 'Envio a P_INTRAWAYEXE';
       END IF;
    -- fin 28.0

    OPERACION.PQ_OPE_INS_EQUIPO.p_gen_carga_inicial(v_codsolot,
                                                    p_mensaje,
                                                    p_error);

    intraway.PQ_INTRAWAY_PROCESO.P_INT_PROCESO(v_opcion,
                                               v_codsolot,
                                               p_resultado,
                                               p_mensaje,
                                               p_error,
                                               L_ENV --28.0
                                               ); --automatico

    update intraway.agendamiento_int
       set est_envio = L_ESTN, mensaje = L_ESTM --28.0
     where codsolot = v_codsolot;
    commit;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := PQ_FND_UTILITARIO_INTERFAZ.FND_ESTADO_ERROR;
      p_mensaje   := SQLERRM;
  End;
  --Fin 6.0
  --ini 7.0
  function f_verificar_reserva_iway(an_codsolot in number) return number is
    ln_num_reserva number;
  begin
    select count(1)
      into ln_num_reserva
      from int_servicio_intraway
     where codsolot = an_codsolot;

    if ln_num_reserva > 0 then
      return 1;
    else
      return 0;
    end if;
  end;

  procedure p_actualizar_plano_sucursal(ac_codsuc  varchar2,
                                        ac_idplano varchar2) is

    ln_idhub  vtatabgeoref.idhub%type;
    ln_idcmts vtatabgeoref.idcmts%type;
    ln_codubi vtatabgeoref.codubi%type;
  begin
    select idhub, idcmts, codubi
      into ln_idhub, ln_idcmts, ln_codubi
      from vtatabgeoref
     where idplano = ac_idplano;

    update vtasuccli
       set idplano = ac_idplano,
           idhub   = ln_idhub,
           idcmts  = ln_idcmts,
           ubisuc  = ln_codubi
     where codsuc = ac_codsuc;
  end;
  --fin 7.0

  --<ini 9.0
  /**********************************************************************
  Procedimiento que genera solicitudes de media suspension al conax.
  **********************************************************************/
  procedure p_gen_archivo_tvsat_susp(a_idtareawf in number,
                                     a_idwf      in number,
                                     a_tarea     in number,
                                     a_tareadef  in number) is

    lc_mensaje     varchar2(2000);
    ln_codsolot    solot.codsolot%type;
    lc_idtrancorte cxc_transaccionescorte.tipo%type;
    ln_tipsol      ope_tvsat_sltd_cab.tiposolicitud%type;
    ln_codinssrv   cxc_inscabcorte.codinssrv%type;
    lc_codcli      cxc_inscabcorte.codcli%type;
    ln_idsol       ope_tvsat_sltd_cab.idsol%type;
    lc_idfac       cxctabfac.idfac%type;
    lc_bouquets    tystabsrv.codigo_ext%type;
    ln_largo       number(4);
    ln_numbouquets number(4);
    lc_codext      varchar2(10);
    lc_numregistro reginsdth.numregistro%type;
    lc_correos_it  varchar2(2000);
    le_error exception;
    ln_num number;
  begin
    --Obtencion del numero de solot
    begin
      select codsolot into ln_codsolot from wf where idwf = a_idwf;
    exception
      when others then
        lc_mensaje := 'Error al obtener la informacion el codigo de solot';
        raise le_error;
    end;

    --Se actualiza el estado de la tarea a ejecucion
    update tareawf
       set esttarea = 2 -- En ejecucion
     where idtareawf = a_idtareawf;

    --Obtencion de la transaccion
    begin

    --ini 18.0
      SELECT ins.codinssrv, b.codcli, b.idfaccxc
        INTO ln_codinssrv, lc_codcli, lc_idfac
        FROM OPERACION.TRSOAC oac, bilfac b, instanciaservicio ins
       WHERE oac.codsolot = ln_codsolot
         AND oac.idfac = b.idfaccxc
         AND b.idisprincipal = ins.idinstserv
         AND oac.idgrupocorte = 15;

      SELECT tiptrs
        INTO lc_idtrancorte
        FROM solot s, tiptrabajo tp
       WHERE s.tiptra = tp.tiptra
         AND s.codsolot = ln_codsolot;
    --fin 18.0

    exception
      when others then
        lc_mensaje := 'Error al obtener la informacion de la transaccion';
        raise le_error;
    end;

    --identificacion del tipo de solicitud
    --if lc_idtrancorte = PQ_CXC_CORTE.FND_TIPOTRAN_CORTE THEN
    if lc_idtrancorte = 3 then --18.0
      --Es una solicitud de suspension
      ln_tipsol := 5; --Suspension
    end if;

    --Obtener Registro de Cliente DTH
    begin
      pq_dth.p_get_numregistro(ln_codsolot, lc_numregistro);
    exception
      when others then
        lc_mensaje := 'Error al obtener el numero de registro dth';
        raise le_error;
    end;

    --Se genera el idsol
    select sq_ope_tvsat_sltd_cab_idsol.nextval
      into ln_idsol
      from DUMMY_OPE;

    --creacion de la cabecera de la solicitud
    insert into ope_tvsat_sltd_cab
      (idsol,
       tiposolicitud,
       codinssrv,
       codcli,
       codsolot,
       idwf,
       idtareawf,
       estado,
       numregistro)
    values
      (ln_idsol,
       ln_tipsol,
       ln_codinssrv,
       lc_codcli,
       ln_codsolot,
       a_idwf,
       a_idtareawf,
       PQ_OPE_INTERFAZ_TVSAT.FND_ESTADO_PEND_EJECUCION,
       lc_numregistro);

    /**********************************************************
    Cursor para obtener las tarjetas y boquetes
    ***********************************************************/

    for reg in (select distinct srv_cab.numregistro,
                                srv_cab.estado,
                                se.numserie serie,
                                (select distinct trim(operacion.PQ_OPE_BOUQUET.f_conca_bouquet_srv_susp(c.codsrv))
                                   from ope_grupo_bouquet_cab  a,
                                        ope_grupo_bouquet_det  b,
                                        tys_tabsrvxbouquet_rel c
                                  where c.codsrv = insope.codsrv
                                    and c.stsrvb = 1 --primario
                                    and a.idgrupo = c.idgrupo
                                    and a.idgrupo = b.idgrupo
                                    and b.flg_activo = 1
                                  group by c.codsrv) codigo_ext
                  from bilfac bil,
                       cr,
                       instxproducto prod,
                       ope_srv_recarga_cab srv_cab,
                       ope_srv_recarga_det srv_det,
                       solotptoequ se,
                       inssrv insope,
                       vtatabslcfac pro,
                       soluciones sol,
                       (select a.codigon tipequope, codigoc grupoequ
                          from opedd a, tipopedd b
                         where a.tipopedd = b.tipopedd
                           and b.abrev = 'TIPEQU_DTH_CONAX') te,
                       instanciaservicio instser
                 where bil.idfaccxc = lc_idfac
                   and bil.codcli = lc_codcli
                   and bil.idbilfac = cr.idbilfac
                   and cr.idinstprod = prod.idinstprod
                   and instser.idinstserv = prod.idcod
                   and instser.codinssrv = insope.codinssrv
                   and instser.codcli = insope.codcli
                   and srv_cab.numregistro = srv_det.numregistro
                   and srv_det.tipsrv =
                       (select valor
                          from constante
                         where constante = 'FAM_CABLE')
                   and instser.codinssrv = srv_det.codinssrv
                   and instser.codcli = srv_cab.codcli
                   and insope.codinssrv = srv_det.codinssrv
                   and insope.codcli = srv_cab.codcli
                   and insope.numslc = pro.numslc
                   and insope.codcli = pro.codcli
                   and pro.idsolucion = sol.idsolucion
                   -- ini 15.0
                   and pro.idsolucion in ( select idsolucion
                                             from  soluciones
                                            where  idgrupocorte in ( select idgrupocorte
                                                                       from cxc_grupocorte
                                                                      where idgrupocorte = 15 ))
                   -- fin 15.0
                   -- Ini 12.0
                   and sales.pq_dth_postventa.f_obt_solucion_dth(pro.idsolucion) = 1
                   -- Fin 12.0
                   and srv_cab.codsolot = se.codsolot
                   and srv_cab.codcli = bil.codcli
                   and srv_cab.estado in ('02', '03')
                   and nvl(srv_cab.flg_recarga, 0) = 0
                   and se.tipequ = te.tipequope
                   and te.grupoequ = '1') loop

      lc_bouquets    := trim(reg.codigo_ext);
      ln_largo       := length(lc_bouquets);
      ln_numbouquets := (ln_largo + 1) / 4;

      /**********************************
      Se separan los bouquetes
      **********************************/
      for i in 1 .. ln_numbouquets loop

        lc_codext := LPAD(operacion.f_cb_subcadena2(lc_bouquets, i), 8, '0');

        --Insercion en la tabla temporal
        insert into ope_tmp_tarjeta_bouquete
          (numregistro, serie, codext)
        values
          (reg.numregistro, reg.serie, lc_codext);

      end loop;

    end loop;

    /***********************************************
    Registro del detalle de la solicitud (Tarjetas)
    ************************************************/
    for reg in (select distinct serie
                  from ope_tmp_tarjeta_bouquete
                 order by serie asc) loop

      insert into ope_tvsat_sltd_det
        (idsol, serie)
      values
        (ln_idsol, reg.serie);
    end loop;

    /***********************************************
    Registro de los bouquetes
    ************************************************/
    for reg in (select distinct serie, codext
                  from ope_tmp_tarjeta_bouquete
                 order by serie, codext) loop
      insert into ope_tvsat_sltd_bouquete_det
        (idsol, serie, bouquete, tipo)
      values
        (ln_idsol,
         reg.serie,
         reg.codext,
         2 --principal
         );
    end loop;

    /**************************************************
      Bouquetes adicionales
    **************************************************/
    if ln_tipsol = 5 then
      --suspension

      for reg in (select b.idsol, b.serie, a.bouquets
                    from bouquetxreginsdth a, ope_tvsat_sltd_det b
                   where b.idsol = ln_idsol
                     and (a.tipo = 0 or a.tipo = 3)
                     and a.estado = 1
                     and a.numregistro = lc_numregistro) loop

        lc_bouquets    := trim(reg.bouquets);
        ln_largo       := length(lc_bouquets);
        ln_numbouquets := (ln_largo + 1) / 4;

        for i in 1 .. ln_numbouquets loop
          lc_codext := LPAD(operacion.f_cb_subcadena2(lc_bouquets, i),
                            8,
                            '0');

          select count(1)
            into ln_num
            from OPE_TVSAT_SLTD_BOUQUETE_DET
           where idsol = reg.idsol
             and serie = reg.serie
             and bouquete = lc_codext;

          if ln_num = 0 then
            insert into OPE_TVSAT_SLTD_BOUQUETE_DET
              (idsol, serie, bouquete, tipo)
            values
              (reg.idsol,
               reg.serie,
               lc_codext,
               1 --adicional
               );
          end if;
        end loop;
      end loop;
    end if;

    /**************************************************
    Bouquetes promocionales
    **************************************************/
    if ln_tipsol = 5 then
      --suspension
      for reg in (select b.idsol, b.serie, a.bouquets
                    from bouquetxreginsdth a, ope_tvsat_sltd_det b
                   where b.idsol = ln_idsol
                     and a.tipo = 2
                     and a.estado = 1
                     and a.numregistro = lc_numregistro) loop

        lc_bouquets    := trim(reg.bouquets);
        ln_largo       := length(lc_bouquets);
        ln_numbouquets := (ln_largo + 1) / 4;

        for i in 1 .. ln_numbouquets loop
          lc_codext := LPAD(operacion.f_cb_subcadena2(lc_bouquets, i),
                            8,
                            '0');

          select count(1)
            into ln_num
            from OPE_TVSAT_SLTD_BOUQUETE_DET
           where idsol = reg.idsol
             and serie = reg.serie
             and bouquete = lc_codext;

          if ln_num = 0 then
            insert into OPE_TVSAT_SLTD_BOUQUETE_DET
              (idsol, serie, bouquete, tipo)
            values
              (reg.idsol,
               reg.serie,
               lc_codext,
               3 --promocional
               );
          end if;
        end loop;
      end loop;
    end if;

    if ln_tipsol = 5 then
      --suspension
      --se actualizan los bouquets adicionales y promocionales
      update bouquetxreginsdth
         set estado = 0, fecultenv = sysdate
       where numregistro = lc_numregistro
         and tipo in (0, 2, 3) --adicional, promocional, adicional cnr
         and estado = 1;
    end if;

    insert into tareawfseg
      (idtareawf, observacion)
    values
      (a_idtareawf, 'Solicitud conax generada');

  exception
    when le_error then
      rollback;
      --Se actualiza el estado de la tarea a ejecucion
      update tareawf
         set esttarea = 19 -- En ejecucion
       where idtareawf = a_idtareawf;
      --Se ingresa una anotacion
      insert into tareawfseg
        (idtareawf, observacion)
      values
        (a_idtareawf, lc_mensaje);
      lc_correos_it := PQ_CXC_CORTE.f_obtener_parametro_servidor('cortesyreconexiones.correo.it.cortes_reconexiones');
      --Se envia correo
      p_envia_correo_c_attach('Error generacion de solicitud de suspension - DTH',
                              lc_correos_it,
                              lc_mensaje,
                              null,
                              'SGA');
    when others then
      rollback;
      --Se actualiza el estado de la tarea a ejecucion
      update tareawf
         set esttarea = 19 -- En ejecucion
       where idtareawf = a_idtareawf;
      lc_mensaje := sqlerrm;
      --Se ingresa una anotacion
      insert into tareawfseg
        (idtareawf, observacion)
      values
        (a_idtareawf, lc_mensaje);
      lc_mensaje    := 'Se produjo un error en la ejecucion de la tarea ' ||
                       a_idtareawf || 'de la SOT Nro. ' || ln_codsolot ||
                       sqlerrm;
      lc_correos_it := PQ_CXC_CORTE.f_obtener_parametro_servidor('cortesyreconexiones.correo.it.cortes_reconexiones');
      p_envia_correo_c_attach('Error generacion de solicitud de suspension - DTH',
                              lc_correos_it,
                              lc_mensaje,
                              null,
                              'SGA');
  end;
  --fin 9.0>

  --ini 10.0
  procedure p_libera_numero(a_idtareawf in number,
                          a_idwf      in number,
                          a_tarea     in number,
                          a_tareadef  in number) is

  ln_codsolot solot.codsolot%type;
  ln_num number;
  ln_portable number;   --22.0
  ln_por_estado number; --22.0
  cursor cur_telef is
    select b.codinssrv
    ,c.codnumtel, b.codcli --11.0
    from solotpto a, inssrv b, numtel c
    where a.codinssrv = b.codinssrv
    and a.codsolot = ln_codsolot
    and b.codinssrv = c.codinssrv;

  begin
    select codsolot into ln_codsolot
    from wf where idwf = a_idwf;

    ln_portable := telefonia.pq_portabilidad.f_verif_portable(2, ln_codsolot); -- 22.0

    for c_telef in cur_telef loop
      if ln_portable = 0 then --22.0 -- no es portable
      update numtel
      set codinssrv = null, estnumtel = 6
      where codinssrv = c_telef.codinssrv;
      update reservatel set fecinires = sysdate  --11.0
      where codnumtel = c_telef.codnumtel and codcli = c_telef.codcli;--11.0
      --Ini 22.0
      else  -- es portable
        select count(*) into ln_portable
        from numtel
        where codinssrv = c_telef.codinssrv and flg_portable is null;
        if ln_portable > 0 then
          ln_por_estado := lc_est_liberado;
        else  -- un saliente que entro por portacion
          ln_por_estado := lc_est_entr_lib;
        end if;
        update numtel
        set codinssrv = null, estnumtel = ln_por_estado
        where codinssrv = c_telef.codinssrv;
        update reservatel set estnumtel = ln_por_estado, fecinires = sysdate
        where codnumtel = c_telef.codnumtel and codcli = c_telef.codcli;
      end if;
      --Fin 22.0
    end loop;
  end;
  --fin 10.0

  --INI 13.0
  procedure p_anula_sot_inst_shell is
    --Variables
    p_mensaje  varchar2(3000);
    p_error    number;
    n_sec_proc number;
    l_Cnt      number;
    l_Cnt_des  number;        --21.0
    n_cont_val number;        --24.0
    l_cnt_num_act number;     --26.0
    l_numero   varchar2(20);        --26.0
    --Inicio 28.0
    l_err      varchar2(3000);
    l_cent1    number;        
    l_cent2    number;         
    l_cent3    number;         
    l_mensproc varchar2(500);  
    v_mail     VARCHAR2(100);  
    l_mensaje  VARCHAR2(1000);
    -- Fin 28.0 
   --Cursor de Sots de Instalacion HFC rechazadas
    cursor c_sots_hfc_inst_x_anular is
      select s.*
        from solot s, estsol e
       where s.estsol = e.estsol
         and e.tipestsol = 7
         --and s.codsolot = 2126520 -- Eliminar para las pruebas.
         and s.tiptra in (select t2.codigon
                            from tipopedd t1, opedd t2
                           where t1.tipopedd = t2.tipopedd
                             and t1.abrev = 'TIPTRA_ANULA_SOT_INST_HFC'
                             and t2.codigoc = 'ACTIVO')
         and s.fecultest <
             sysdate - (select t2.codigon
                          from tipopedd t1, opedd t2
                         where t1.tipopedd = t2.tipopedd
                           and t1.abrev = 'DIAS_ANULA_SOT_INST_HFC'
                           and t2.codigoc = 'UNICO');
--Inicio 25.0
  cursor c_sot is
    select a.codsolot,a.cod_id,trunc(b.fecha), trunc(sysdate) from solot a, solotchgest b
    where a.codsolot=b.codsolot and a.estsol=b.estado
    and a.tiptra=658 and b.estado=29
    and trunc(b.fecha)=trunc(sysdate);

  begin
    --Obtener secuencial del proceso
    select operacion.sq_proc_anula_sot_hfc_inst.nextval
      into n_sec_proc
      from dummy_ope;
    --Lectura del Cursor de Sots identificadas
    for reg in c_sots_hfc_inst_x_anular loop
      --Inicio 28.0
      l_cent1 := 1;
      l_cent2 := 1;
      l_cent3 := 1;
      l_mensproc := null;
      -- Fin 28.0     
      insert into historico.log_sot_anuladas(idseq,codsolot,proceso)--25.0
      values(n_sec_proc,reg.codsolot,'Identificar SOT.');
      --Liberacion de espacio en Intraway
      -- Incio 28.0      
       begin
          operacion.pq_anulacion_bscs.p_anula_iw(reg.codsolot,p_error,p_mensaje);
          insert into historico.log_sot_anuladas(idseq,codsolot,proceso,error,descripcion)--25.0
            values(n_sec_proc,reg.codsolot,'Genera baja_XML Intraway.',p_error,p_mensaje);
          commit;   
       exception
         when others then
           ROLLBACK;
           l_err := sqlerrm;
           l_cent1 := 0;
           l_mensproc := 'PQ_ANULACION_BSCS.P_ANULA_IW'||chr(10)||l_err;
       end;       
      -- Fin 28.0
      select count(1) into n_cont_val from tipopedd where abrev='ANULSOTSGABSCS';
      -- Inicio 28.0
      if n_cont_val = 1 and reg.cod_id is not null then
        begin
      -- Fin 28.0
        TIM.PP021_VENTA_HFC.SP_ANULAR_VENTA@DBL_BSCS_BF(reg.cod_id,p_error,p_mensaje);--Libera el numero de BSCS
        insert into historico.log_sot_anuladas(idseq,codsolot,proceso,error,descripcion)--25.0
        values(n_sec_proc,reg.codsolot,'Liberar Número BSCS.',p_error,p_mensaje);
      -- Inicio 28.0
        commit;
         exception
           when others then
             ROLLBACK;
             l_err := sqlerrm;
             l_cent2 := 0;
             l_mensproc := 'PP021_VENTA_HFC.SP_ANULAR_VENTA@'||chr(10)||l_err;
         end;
      end if;    
      -- Fin 28.0
      
      --Actualizar secuencial de proceso
      begin
        update solot
           set n_sec_proc_shell = n_sec_proc
         where codsolot = reg.codsolot;
         commit; -- 28.0
      exception
        when others then
          ROLLBACK; -- 28.0
          p_mensaje := sqlerrm;
          -- Inicio 28.0
          l_cent3 := 0;
          l_mensproc := 'UPDATE SOLOT SET N_SEC_PROC_SHELL ='||N_SEC_PROC||'  WHERE CODSOLOT = '||REG.CODSOLOT||chr(10)||l_err;
          -- Fin 28.0          
      end;

      begin
         --INI 14.0
         --Inicio 28.0
          IF l_cent1 =1 AND l_cent2 = 1 AND l_cent3 = 1 then
        -- Fin 28.0  
           --Si existe reserva en INTRAWAY entonces se realiza una preanulacion
           operacion.pq_solot.p_anular_solot(reg.codsolot, 20); -- PRE ANULACION

           INSERT INTO solotchgest
              (codsolot, tipo, estado, fecha, observacion)
           VALUES
              (reg.codsolot, 1, 20, SYSDATE, 'Pre-Anulación Masiva HFC.');
           -- Llena Informacion a insertar la raiz en INT_ENVIO
        --Inicio 28.0   
        ELSE
            l_mensaje :='ERROR EN EL PROCESO DE PRE_ANULACION: P_ANULA_SOT_INST_SHELL'||CHR(10)||
                        'DETALLE DEL PROCESO: '||chr(10)||l_mensproc;

            SELECT EMAIL INTO v_mail FROM ENVCORREO WHERE TIPO = 10 AND CODDPT ='8001';
            OPEWF.PQ_SEND_MAIL_JOB.p_send_mail('OPERACION.PQ_CUSPE_OPE2.P_ANULA_SOT_INST_SHELL',
                                               v_mail,
                                               l_mensaje);               
        -- Fin 28.0      
        END IF;
        --FIN 14.0
      exception
        when others then
          --Inicio 28.0
          ROLLBACK;
          l_err := sqlerrm;
          l_mensaje :=' DETALLE DEL ERROR: '||l_err||chr(10)||
                                              dbms_utility.format_error_stack||'@'||
                                              dbms_utility.format_call_stack||chr(10)||
                                              dbms_utility.format_error_backtrace;

            SELECT EMAIL INTO v_mail FROM ENVCORREO WHERE TIPO = 10 AND CODDPT ='8001';
            OPEWF.PQ_SEND_MAIL_JOB.p_send_mail('OPERACION.PQ_CUSPE_OPE2.P_ANULA_SOT_INST_SHELL'||reg.codsolot,
                                               v_mail,
                                               l_mensaje);          
          -- Fin 28.0
      end;
      commit;
    end loop;
    --Envio de correo
    p_envia_correo_shell(n_sec_proc, p_mensaje, p_error);

    --Inicio 25.0
    for c_s in c_sot loop
      operacion.pq_iw_sga_bscs.p_act_bscs_ivr(c_s.codsolot,p_error,p_mensaje);
      insert into historico.log_sot_anuladas(idseq,codsolot,proceso,error,descripcion)
      values(n_sec_proc,c_s.codsolot,'Asignar Equipos.',p_error,p_mensaje);
    end loop;
    --Fin 25.0
  exception
    when others then
      null;
  end;

  procedure p_libera_reserva_shell(a_codsolot   in solot.codsolot%type,
                                   a_enviar_itw in number default 0,
                                   o_mensaje    out varchar2,
                                   o_error      out number) is
    --CONSTANTES DE INTERFACES
  /*
    --INI 14.0
    fnd_idinterface_cm      constant varchar2(4) := '620'; --INTERNET
    fnd_idinterface_mta     constant varchar2(4) := '820'; --TELEFONIA
    fnd_idinterface_ep      constant varchar2(4) := '824'; --TELEFONIA
    fnd_idinterface_cf      constant varchar2(4) := '830'; --TELEFONIA
    fnd_idinterface_stb     constant varchar2(4) := '2020'; --TELEVISION
    fnd_idinterface_stba    constant varchar2(4) := '2030'; --TELEVISION
    fnd_idinterface_stb_vod constant varchar2(4) := '2050'; --TELEVISION
    --Excepciones
    error exception;
    --Variables
    p_resultado       varchar2(500);
    p_error           number;
    p_mensaje         varchar2(3000);
    p_proceso         number;
    p_channelmap      varchar2(200);
    p_sendtocontroler varchar2(200);
    p_comando         varchar2(150);
    v_validaregistro  number;
    v_codcli          vtatabcli.codcli%type;
    vr_int_ser_itw    int_servicio_intraway%rowtype;
    --Cursor de servicios instalados
    cursor c_servicios_int_inst is
      select isw1.*
        from int_servicio_intraway isw1
       where isw1.codinssrv in
             (select distinct decode(t.tiptra,
                                     412,
                                     sp.codinssrv_tra,
                                     sp.codinssrv)
                from solotpto sp, solot t
               where sp.codsolot = t.codsolot
                 and sp.codsolot = a_codsolot)
         and isw1.estado = 1
         and isw1.id_interfase not in
             (fnd_idinterface_cf, fnd_idinterface_stba)
      union
      select isw2.*
        from int_servicio_intraway isw2
       where isw2.id_producto in
             (select id_producto
                from int_servicio_intraway
               where id_interfase = fnd_idinterface_cm
                 and codsolot = a_codsolot)
         and isw2.estado = 1
         and isw2.id_interfase in (fnd_idinterface_cm, fnd_idinterface_mta)
      union
      select isw3.*
        from int_servicio_intraway isw3
       where isw3.id_producto in
             (select id_producto_padre
                from int_servicio_intraway
               where id_interfase = fnd_idinterface_ep
                 and codinssrv in
                     (select distinct decode(t.tiptra,
                                             412,
                                             sp.codinssrv_tra,
                                             sp.codinssrv)
                        from solotpto sp, solot t
                       where sp.codsolot = t.codsolot
                         and sp.codsolot = a_codsolot))
         and isw3.estado = 1
       order by 2 desc;
       --FIN 14.0*/
  begin
    intraway.p_int_baja_total(a_codsolot, a_enviar_itw, o_mensaje, o_error);
    /*--Verificar si ya existe en las tablas intermedias
    --INI 14.0
    select count(1)
      into v_validaregistro
      from intraway.int_solot_itw
     where codsolot = a_codsolot;
    --Si no existe se registra
    if v_validaregistro = 0 then
      select codcli into v_codcli from solot where codsolot = a_codsolot;
      insert into intraway.int_solot_itw
        (codsolot, codcli, estado, flagproc)
      values
        (a_codsolot, v_codcli, 2, 0);
    end if;
    --Inicializacion
    p_error   := 0;
    p_proceso := 4;
    --Lectura del cursor de servicios instalados
    for reg in c_servicios_int_inst loop
      --INTERNET
      if reg.id_interfase = fnd_idinterface_cf then
        pq_intraway.p_mta_fac_administracion(0,
                                             reg.id_cliente,
                                             reg.id_producto,
                                             reg.pid_sga,
                                             reg.id_producto_padre,
                                             reg.codigo_ext,
                                             p_proceso,
                                             a_codsolot,
                                             reg.codinssrv,
                                             p_resultado,
                                             p_mensaje,
                                             p_error,
                                             a_enviar_itw,
                                             'TRUE',
                                             reg.id_venta,
                                             reg.id_venta_padre);
        --INTERNET
      elsif reg.id_interfase = fnd_idinterface_ep then
        pq_intraway.p_mta_ep_administracion(0,
                                            reg.id_cliente,
                                            reg.id_producto,
                                            reg.pid_sga,
                                            reg.id_producto_padre,
                                            reg.nroendpoint,
                                            reg.numero,
                                            reg.codigo_ext,
                                            p_proceso,
                                            a_codsolot,
                                            reg.codinssrv,
                                            p_resultado,
                                            p_mensaje,
                                            p_error,
                                            a_enviar_itw,
                                            reg.id_venta,
                                            reg.id_venta_padre,
                                            'TRUE');
        --TELEFONIA
      elsif reg.id_interfase = fnd_idinterface_cm then
        --Primero debemos eliminar la el espacio del MTA
        begin
          select *
            into vr_int_ser_itw
            from int_servicio_intraway
           where id_producto_padre = reg.id_producto
             and id_cliente = reg.id_cliente
             and id_interfase = fnd_idinterface_mta;
          pq_intraway.p_mta_crea_espacio(0,
                                         vr_int_ser_itw.id_cliente,
                                         vr_int_ser_itw.id_producto,
                                         vr_int_ser_itw.pid_sga,
                                         vr_int_ser_itw.id_producto_padre,
                                         vr_int_ser_itw.id_activacion,
                                         p_proceso,
                                         a_codsolot,
                                         vr_int_ser_itw.codigo_ext,
                                         p_resultado,
                                         p_mensaje,
                                         p_error,
                                         a_enviar_itw,
                                         vr_int_ser_itw.id_venta,
                                         vr_int_ser_itw.id_venta_padre);
          pq_intraway.p_cm_crea_espacio(0,
                                        reg.id_cliente,
                                        reg.id_producto,
                                        reg.pid_sga,
                                        reg.id_activacion,
                                        reg.codigo_ext,
                                        2,
                                        p_proceso,
                                        a_codsolot,
                                        reg.codinssrv,
                                        p_resultado,
                                        p_mensaje,
                                        p_error,
                                        null,
                                        null,
                                        a_enviar_itw,
                                        vr_int_ser_itw.id_venta,
                                        vr_int_ser_itw.id_venta_padre);
        exception
          when no_data_found then
            pq_intraway.p_cm_crea_espacio(0,
                                          reg.id_cliente,
                                          reg.id_producto,
                                          reg.pid_sga,
                                          reg.id_activacion,
                                          reg.codigo_ext,
                                          2,
                                          p_proceso,
                                          a_codsolot,
                                          reg.codinssrv,
                                          p_resultado,
                                          p_mensaje,
                                          p_error,
                                          null,
                                          null,
                                          a_enviar_itw,
                                          vr_int_ser_itw.id_venta,
                                          vr_int_ser_itw.id_venta_padre);
          when others then
            null;
        end;
        --TELEVISION
      elsif reg.id_interfase = fnd_idinterface_stb_vod then
        pq_intraway.p_stb_vod_administracion(0,
                                             reg.codigo_ext,
                                             reg.id_cliente,
                                             reg.id_producto,
                                             reg.pid_sga,
                                             reg.id_producto_padre,
                                             p_proceso,
                                             a_codsolot,
                                             reg.codinssrv,
                                             a_enviar_itw,
                                             0,
                                             0,
                                             p_resultado,
                                             p_mensaje,
                                             p_error);
        --TELEVISION
      elsif reg.id_interfase = fnd_idinterface_stba then
        pq_intraway.p_stb_sa_administracion(0,
                                            reg.id_cliente,
                                            reg.id_producto,
                                            reg.pid_sga,
                                            reg.id_producto_padre,
                                            reg.codigo_ext,
                                            p_proceso,
                                            a_codsolot,
                                            reg.codinssrv,
                                            p_resultado,
                                            p_mensaje,
                                            p_error,
                                            a_enviar_itw,
                                            'TRUE',
                                            reg.id_venta,
                                            reg.id_venta_padre);
        --TELEVISION
      elsif reg.id_interfase = fnd_idinterface_stb then
        --Se debe tomar en cuenta si el Set Top Box esta intalado o no.
        --En caso se encuentre instalada.
        p_channelmap      := 'BASICO';
        p_sendtocontroler := 'TRUE';
        --Forzar la coleccion de compras
        p_comando := 'collectppv';
        if (reg.macaddress is not null) and (reg.serialnumber is not null) then
          -- En caso de que se encuentre instalada
          intraway.pq_intraway.p_stb_mantenimiento(reg.id_cliente,
                                                   reg.id_producto,
                                                   0,
                                                   p_proceso,
                                                   a_codsolot,
                                                   reg.codinssrv,
                                                   p_comando,
                                                   p_resultado,
                                                   p_mensaje,
                                                   p_error,
                                                   a_enviar_itw);
          intraway.pq_intraway.p_stb_crea_espacio(4,
                                                  reg.id_cliente,
                                                  reg.id_producto,
                                                  reg.id_producto,
                                                  reg.id_activacion,
                                                  reg.codigo_ext,
                                                  p_channelmap,
                                                  reg.modelo,
                                                  p_sendtocontroler,
                                                  p_proceso,
                                                  a_codsolot,
                                                  reg.codinssrv,
                                                  p_resultado,
                                                  p_mensaje,
                                                  p_error,
                                                  a_enviar_itw,
                                                  reg.id_venta,
                                                  0);
          intraway.pq_intraway.p_stb_crea_espacio(2,
                                                  reg.id_cliente,
                                                  reg.id_producto,
                                                  reg.id_producto,
                                                  reg.id_activacion,
                                                  reg.codigo_ext,
                                                  p_channelmap,
                                                  'VES_DSP',
                                                  p_sendtocontroler,
                                                  p_proceso,
                                                  a_codsolot,
                                                  reg.codinssrv,
                                                  p_resultado,
                                                  p_mensaje,
                                                  p_error,
                                                  a_enviar_itw,
                                                  reg.id_venta,
                                                  0);
        end if;
        --En caso no se encuentre Instalada.
        p_sendtocontroler := 'FALSE';
        intraway.pq_intraway.p_stb_crea_espacio(0,
                                                reg.id_cliente,
                                                reg.id_producto,
                                                reg.id_producto,
                                                reg.id_activacion,
                                                reg.codigo_ext,
                                                p_channelmap,
                                                'VES_DSP',
                                                p_sendtocontroler,
                                                p_proceso,
                                                a_codsolot,
                                                reg.codinssrv,
                                                p_resultado,
                                                p_mensaje,
                                                p_error,
                                                a_enviar_itw,
                                                reg.id_venta,
                                                0);
      end if;
    end loop;
    --Resultado del proceso
    o_mensaje := p_mensaje;
    o_error   := p_error;
    --FIN 14.0*/
  exception
    when others then
      o_mensaje := 'Error en Procedimiento de Liberación de Reserva';
      o_error   := -1;
  end;

  procedure p_libera_numero_shell(a_codsolot in number,
                                  o_mensaje  out varchar2,
                                  o_error    out number) is
    --Variables
    p_error   number;
    p_mensaje varchar2(3000);
    --Cursor de numeros telefonicos asignados
    cursor cur_telef is
      select distinct b.codcli, b.codinssrv, c.codnumtel
        from solotpto a, inssrv b, numtel c
       where a.codsolot = a_codsolot
         and a.codinssrv = b.codinssrv
         and b.codinssrv = c.codinssrv;
  begin
    for reg in cur_telef loop
      begin
        --Actualizar numero al estado DISPONIBLE
        update numtel
           set estnumtel = 1,
               codinssrv = null,
               codusuasg = null,
               fecasg    = null
         where codinssrv = reg.codinssrv;
        --Actualizar reserva al estado DISPONIBLE
        update reservatel
           set estnumtel = 1,
               fecinires = sysdate,
               numslc    = null,
               codcli    = null
         where codnumtel = reg.codnumtel
           and codcli = reg.codcli;
        --Actualizar servicio con numero nulo
        update inssrv s
           set s.numero = null, s.fecini = null
         where codinssrv = reg.codinssrv;
      exception
        when others then
          p_mensaje := 'Error al liberar numero telefonico';
          p_error   := -1;
          goto salto;
      end;
    end loop;
    p_mensaje := 'OK';
    p_error   := 0;
    <<salto>>
    o_mensaje := p_mensaje;
    o_error   := p_error;
  exception
    when others then
      o_mensaje := 'Error en Procedimiento de Liberación de Numero Telefónico';
      o_error   := -1;
  end;

  procedure p_envia_correo_shell(a_sec_proc in number,
                                 o_mensaje  out varchar2,
                                 o_error    out number) is
    --Variables
    p_error             number;
    p_mensaje           varchar2(3000);
    stexto              varchar2(1000);
    sasunto             varchar2(500);
    sruta               varchar2(500);
    semail              varchar2(500);
    slinea              varchar2(10);
    binst_hfc_anula_sot boolean;
    harch               utl_file.file_type;
    --Cursor de sots anuladas del proceso
    cursor c_sots_hfc_inst_x_anular is
      select s.* from solot s where n_sec_proc_shell = a_sec_proc;
    --Cursor de E-mail de Notificacion
    cursor c_emails is
      select t2.descripcion
        from tipopedd t1, opedd t2
       where t1.tipopedd = t2.tipopedd
         and t1.abrev = 'EMAIL_ANULA_SOT_INST_HFC'
         and t2.codigoc = 'ACTIVO';
  begin
    --Inicializacion de variables
    semail              := '';
    binst_hfc_anula_sot := false;
    --Lectura de cursor de e-mails
    for reg in c_emails loop
      semail := semail || reg.descripcion || ',';
    end loop;
    --Obtener Ruta del utl file donde se escribe el archivo
    select t2.descripcion
      into sruta
      from tipopedd t1, opedd t2
     where t1.tipopedd = t2.tipopedd
       and t1.abrev = 'UTL_FILE_ANULA_SOT_INST_HFC'
       and t2.codigoc = 'ACTIVO';
    --Escritura del archivo
    begin
      --Abrir archivo
      harch := utl_file.fopen(sruta, 'SOTS_HFC_ANULA.TXT', 'w');
      --Lectura de sots anuladas del dia
      for reg2 in c_sots_hfc_inst_x_anular loop
        binst_hfc_anula_sot := true;
        slinea              := reg2.codsolot;
        --Escribir archivo
        utl_file.put_line(harch, slinea);
      end loop;
      --Cerrar archivo
      utl_file.fclose(harch);
    exception
      when others then
        p_error   := -1;
        p_mensaje := 'Error en escritura del archivo.';
        goto salto;
    end;
    --Envio del correo
    begin
      if semail is not null then
        semail  := substr(semail, 0, length(semail) - 1);
        sasunto := 'Asunto: Proceso anulación SOTs rechazadas';
        if binst_hfc_anula_sot then
          stexto := 'Cuerpo: Sres. se adjuntan la lista de SOTs anuladas. ';
          --ENVIO DE EMAIL ATACHADOS
          p_envia_correo_c_attach(sasunto,
                                  semail,
                                  stexto,
                                  sendmailjpkg.attachments_list(sruta ||
                                                                'SOTS_HFC_ANULA.TXT'));
        else
          stexto := 'Cuerpo: Sres. No se encontró SOTs para anular. ';
          --ENVIO DE EMAIL SIN ATACHADOS
          p_envia_correo_c_attach(sasunto, semail, stexto);
        end if;
      end if;
    exception
      when others then
        p_error   := -1;
        p_mensaje := 'Error en envio de correo';
        goto salto;
    end;
    p_mensaje := 'OK';
    p_error   := 0;
    <<salto>>
    o_mensaje := p_mensaje;
    o_error   := p_error;
  exception
    when others then
      o_mensaje := 'Error en Procedimiento de Envio de Correo';
      o_error   := -1;
  end;
  --FIN 13.0
  --Ini 14.0
  procedure p_int_iw_solot_anuladas(p_codsolot in solot.codsolot%type) is
  ----------------------------------------------------------------------------------
  -- Genera la raiz para el proceso de pre-anulacion masiva.
  ----------------------------------------------------------------------------------
  cursor lcur_iw_envio is
  select distinct i.id_nivel,ts.codsolot, i.id_interfase, i.id_estado , id_producto, id_venta, id_producto_padre, id_venta_padre
  from intraway.int_interface_iw i , int_transaccionesxsolot ts
  where ts.codsolot = p_codsolot and
        i.id_interfase = ts.id_interfase and
        i.id_estado = ts.id_estado and
        ts.estado = 0 and
        id_nivel = (select max(i2.id_nivel)
                    from int_transaccionesxsolot ts2, intraway.int_interface_iw i2
                    where ts2.codsolot = ts.codsolot and
                          ts2.id_producto = ts.id_producto and
                          nvl(ts2.id_venta,0) = nvl(ts.id_venta,0) and
                          nvl(ts2.id_producto_padre,0) = nvl(ts.id_producto_padre,0) and
                          nvl(ts.id_venta_padre,0) = nvl(ts.id_venta_padre,0) and
                          i2.id_interfase = ts2.id_interfase and
                          i2.id_estado = ts2.id_estado and
                          i2.id_tipo = 1 )
    union all
    select distinct i.id_nivel,ts.codsolot, i.id_interfase, i.id_estado , id_producto, id_venta, id_producto_padre, id_venta_padre
    from intraway.int_interface_iw i , int_transaccionesxsolot ts
    where ts.codsolot = p_codsolot and
          i.id_interfase = ts.id_interfase and
          i.id_estado = ts.id_estado and
          ts.estado = 0 and
          id_nivel = (select max(i2.id_nivel)
                      from int_transaccionesxsolot ts2, intraway.int_interface_iw i2
                      where ts2.codsolot = ts.codsolot and
                            decode(ts2.id_producto_padre,0,ts2.id_producto,ts2.id_producto_padre) = decode(ts.id_producto_padre,0,ts.id_producto,ts.id_producto_padre) and
                            ts2.estado = 0 and
                            i2.id_interfase = ts2.id_interfase and
                            i2.id_estado = ts2.id_estado and
                            i2.id_tipo = 2 );
  Begin
      For lcur_iw_e in lcur_iw_envio Loop
          -- Definir que se deberia hacer para cambiar a un nivel Superior
          intraway.pq_ejecuta_masivo.p_int_iw_bajas_anuladas(lcur_iw_e.codsolot, lcur_iw_e.id_interfase, lcur_iw_e.id_estado, lcur_iw_e.id_producto, lcur_iw_e.id_venta, lcur_iw_e.id_producto_padre, lcur_iw_e.id_venta_padre );
      End Loop;
  End;
  --Fin 14.0
  --ini 16.0
  PROCEDURE p_valida_numtel(as_numerotel IN numtel.numero%type,
                            as_codcli    in vtatabcli.codcli%type,
                            an_cod_error out number,
                            as_des_error out varchar2) is

    cursor cur_num_ope(ls_numerotel varchar2) is
      select codcli, codinssrv from inssrv
       where (numero = ls_numerotel)
         and (fecfin is null or fecfin > sysdate)
         and (tipinssrv = 3)
         and (estinssrv = 1);

    cursor cur_num_fac(ls_numerotel varchar2) is
      select codcli, codinssrv from instanciaservicio
       where nomabr = ls_numerotel
         and (fecfin is null or fecfin > sysdate)
         and (tipinstserv = 3);

    rec_num_ope cur_num_ope%ROWTYPE;
    rec_num_fac cur_num_fac%ROWTYPE;
    ln_codsolot    solot.codsolot%type;
    ls_codcli      vtatabcli.codcli%type;
    ln_estol       estsol.estsol%type;
    ls_descestsol  estsol.descripcion%type;
    ls_mensaje     varchar2(1000);
  begin
    an_cod_error := 0;
    --Operaciones
    open cur_num_ope(as_numerotel) ;
    loop
      fetch cur_num_ope
        into rec_num_ope;
      exit when cur_num_ope%notfound;
      if rec_num_ope.codcli <> as_codcli then
        begin
          select s.codsolot, rec_num_ope.codcli, (select e.descripcion from estsol e where e.estsol = s.estsol) into ln_codsolot, ls_codcli, ls_descestsol
           from solot s where s.codsolot = (select max(codsolot)
           from solotpto where codinssrv = rec_num_ope.codinssrv);
        exception
          when no_data_found then
            an_cod_error := -1;
            as_des_error:= 'Error. No se tiene detalle de la SOT';
            exit;
        end;
        an_cod_error := -1;
        ls_mensaje:= 'Codigo Cliente: '|| rec_num_ope.codcli ||' .Numero telefonico: '||as_numerotel ||' .SOT: '|| ln_codsolot || ' .Estado: ' ||ls_descestsol||chr(13);
        as_des_error:= 'Se debe dar de baja el servicio activo que tiene el mismo numero telefonico. '|| chr(13)||ls_mensaje;
        exit;
      end if;
    end loop;
    close cur_num_ope;

    -- Facturacion
    open cur_num_fac(as_numerotel);
    loop
      fetch cur_num_fac
        into rec_num_fac;
      exit when cur_num_fac%notfound;
      if rec_num_fac.codcli <> as_codcli then
        begin
          select s.codsolot, rec_num_fac.codcli, (select e.descripcion from estsol e where e.estsol = s.estsol) into ln_codsolot, ls_codcli, ls_descestsol
           from solot s where s.codsolot = (select max(codsolot)
           from solotpto where codinssrv = rec_num_fac.codinssrv);
        exception
          when no_data_found then
            an_cod_error := -1;
            as_des_error:= 'Error. No se tiene detalle de la SOT';
            exit;
        end;
        an_cod_error := -1;
        ls_mensaje:= 'Codigo Cliente: '|| rec_num_fac.codcli ||' .Numero telefonico: '||as_numerotel ||chr(13);
        as_des_error:= 'Este numero actualmente se encuentra facturando: '|| chr(13)||ls_mensaje;
        exit;
      end if;
    end loop;
    close cur_num_fac;
  end;
  --fin 16.0
 -- INI 17.0
 PROCEDURE  p_insertar_control_ip( an_codsolot         in solot.codsolot%type,
                                    ac_macaddress       in varchar2,
                                    ac_modelcrmid       in varchar2,
                                    ac_serie            in varchar2,
                                    ac_idproducto       in varchar2,
                                    an_idventa          in varchar2,
                                    an_idservicio       in number,  -- <19.0>
                                    an_ipcm             in varchar2,-- <19.0>
                                    an_cpe              in varchar2,-- <19.0>
                                    an_idcontrol        out number,
                                    an_mensaje          out varchar2)

   is
   -- ln_idcontrol  number(10);   -- <19.0>
   -- ls_idservicio varchar(20);  -- <19.0>
   -- ls_red_pc     varchar(20);  -- <19.0>
   ls_des_cmts   varchar(50);
   ln_cid        number(10);
   ls_codinssrv  number(10);
   ln_existe     number;  -- <19.0>

  BEGIN

   -- Generacion de id
   select operacion.sq_controlip_id.nextval into an_idcontrol
     from dual;

   -- Consulta de cid
   /* ini 19.0
   select distinct cid
     into ln_cid
     from operacion.inssrv
    where codinssrv = an_codinssrv;
      fin 19.0 */


        select a.cid, a.codinssrv
          into ln_cid, ls_codinssrv
          from solotpto a, tystabsrv b, insprd p
         where a.codsolot = an_codsolot
           and a.codsrvnue = b.codsrv
           and a.pid = p.pid
           and a.codinssrv = p.codinssrv
           and b.codsrv in ( select to_char(codigoc)
                               from operacion.opedd
                              where abreviacion = 'SRV_IP'
                                and codigon= to_char(b.idproducto));

  /* ini 19.0
   -- Consulta de codigo_ext
   select  ( select idispcrm
               from configuracion_itw
              where codigo_ext = i.codigo_ext )
     into ls_red_pc
     from intraway.int_servicio_intraway i
    where i.codsolot      = an_codsolot
      and i.codinssrv     = an_codinssrv
      and i.id_producto   = ac_idproducto
      and i.id_venta      = an_idventa
      and i.id_interfase  = 620;

   -- consulta de id_servicio
   select  id_servicio into ls_idservicio
     from  int_mensaje_intraway
    where  codsolot     = an_codsolot
      and  id_interfase = 620;
    fin 19.0 */

   -- consulta de cmts
   select distinct f.desccmts into ls_des_cmts
     from solot a,
          solotpto b,
          inssrv c,
          vtasuccli d,
          ope_hub e,
          ope_cmts f,
          vtatabgeoref g
    where a.codsolot   = b.codsolot
      and b.codinssrv  = c.codinssrv
      and c.codsuc     = d.codsuc
      and d.idhub      = e.idhub(+)
      and d.idcmts     = f.idcmts(+)
      and d.idhub      = f.idhub(+)
      and d.ubisuc     = g.codubi(+)
      and d.idplano    = g.idplano(+)
      and a.codsolot   = an_codsolot;
   -- ini 19.0
   /* Validacion de Existencia de SOT en Control de IP*/
   select count(*) into ln_existe
     from operacion.controlip
    where cod_solot = an_codsolot;
   -- fin 19.0

   if ln_existe = 0 then  --- ini 19.0
     -- Si sot no existe se creara un nuevo registro
   insert into operacion.controlip
          ( idcontrol,
            cod_cid,
            cod_solot,
            codinssrv,
            mac_address_cm,
            num_serie,
            modelo,
            ip_cm,         -- <19.0>
            red_pc,
            id_servicio,
            id_producto,
            id_venta,
            cmts,
            estado)
   values ( an_idcontrol,
            ln_cid,
            an_codsolot,
            ls_codinssrv,
            ac_macaddress,
            ac_serie,
            ac_modelcrmid,
            an_ipcm,      -- <19.0>
            an_cpe,
            an_idservicio,
            ac_idproducto,
            an_idventa,
            ls_des_cmts,
            0 );
      else
        -- Si sot ya existe se Actualizara los Campos recuperados de la Consulta aIW
        update operacion.controlip
           set cod_cid        =  ln_cid,
               codinssrv      =  ls_codinssrv,
               mac_address_cm =  ac_macaddress,
               num_serie      =  ac_serie,
               modelo         =  ac_modelcrmid,
               ip_cm          =  an_ipcm,
               red_pc         =  an_cpe,
               id_servicio    =  an_idservicio,
               id_producto    =  ac_idproducto,
               id_venta       =  an_idventa,
               cmts           =  an_idventa
         where cod_solot      = an_codsolot;
      end if;
      --- fin 19.0

      an_mensaje       := 'Ok';
      an_idcontrol     := an_idcontrol;
      commit;
  exception
    when others then
      an_mensaje       := sqlerrm;
      an_idcontrol     := 0;
  END;

 PROCEDURE  p_asociar_ip(  an_idcontrol   IN NUMBER,
                           an_ip_cm       IN VARCHAR2,
                           an_codsolot    IN NUMBER,
                           an_cod_cid     IN NUMBER,
                           an_ips_cpe     IN VARCHAR2,
                           an_mac_cpe     IN VARCHAR2,
                           an_dispositivo IN VARCHAR2,
                           an_estado      IN NUMBER,
                           an_mensaje     OUT VARCHAR2)
   is
 -- ln_estado     number; < 19.0 >
  BEGIN
   an_mensaje := 'OK';
    IF an_estado = 1 THEN

    /* -- ini 19.0
      select count(*) into ln_estado
        from operacion.controlip
       where idcontrol = an_idcontrol
         and cod_solot = an_codsolot
         and cod_cid   = an_cod_cid;
       -- fin 19.0 */

      if  an_estado = 1 then
      update operacion.controlip
         set ips_cpe_fija    = an_ips_cpe,
             mac_cpe_fija    = an_mac_cpe,
             dispositivo     = an_dispositivo,
             ip_cm           = an_ip_cm,
             codusu          = user,
             fecusu          = sysdate,
             fec_alta        = sysdate,
             fec_baja        = null,
             estado          = an_estado
       where idcontrol = an_idcontrol
         and cod_solot = an_codsolot
         and cod_cid   = an_cod_cid;
      /* -- ini 19.0
      else
        update operacion.controlip
           set ips_cpe_fija    = an_ips_cpe,
               mac_cpe_fija    = an_mac_cpe,
               dispositivo     = an_dispositivo,
               ip_cm           = an_ip_cm,
               fec_baja        = sysdate,
               codusumod       = user,
               fecusumod       = sysdate,
               estado          = an_estado
         where idcontrol = an_idcontrol
           and cod_solot = an_codsolot
           and cod_cid   = an_cod_cid;
         -- fin 19.0 */
      end if;

    ELSIF an_estado = 0 THEN
      update operacion.controlip
         set ips_cpe_fija    = an_ips_cpe,
             mac_cpe_fija    = an_mac_cpe,
             dispositivo     = an_dispositivo,
             ip_cm           = an_ip_cm,
             codusumod       = user,
             fecusumod       = sysdate,
             fec_baja        = sysdate,
             estado          = an_estado
       where idcontrol = an_idcontrol
         and cod_solot = an_codsolot
         and cod_cid   = an_cod_cid;

    END IF;
  exception
    when others then
      an_mensaje       := sqlerrm;
  END;
  -- FIN 17.0
  --ini 20.0
  PROCEDURE p_gen_reserva_te_iway(a_idtareawf IN NUMBER,
                                  a_idwf      IN NUMBER,
                                  a_tarea     IN NUMBER,
                                  a_tareadef  IN NUMBER) IS

    v_codsolot  solot.codsolot%TYPE;
    v_opcion    NUMBER(2);
    p_resultado VARCHAR2(10);
    p_mensaje   VARCHAR(1000);
    p_error     NUMBER;

  BEGIN
  -- Traslado Externo 23.0
    -- Capturo el codigo de la solot
    SELECT codsolot INTO v_codsolot FROM wf WHERE idwf = a_idwf;

    IF NOT pq_agendamiento.f_es_puerta_puerta(v_codsolot) = 1 THEN
      --Si no Es Puerta a Puerta
    RETURN;
    END IF;


    v_opcion := 14; -- Modificacion Servicios
    /*intraway.PQ_INTRAWAY_PROCESO.P_INT_PROCESO_TE(v_opcion,
                                               v_codsolot,
                                               1,
                                               p_resultado,
                                               p_mensaje,
                                               p_error);
     */
    --variables locales
    UPDATE intraway.agendamiento_int
       SET est_envio = 5, mensaje = 'Envio a P_INTRAWAYEXE'
     WHERE codsolot = v_codsolot;

    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      p_resultado := PQ_FND_UTILITARIO_INTERFAZ.FND_ESTADO_ERROR;
      p_mensaje   := SQLERRM;
  END;
  --fin 20.0

  --ini 19.0
  procedure p_pre_controlip(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number) as

    /* Declaracion de Variables Webservice */
    iw_esquemaxml   varchar2(30000);
    iw_respuestaxml varchar2(30000);
    iw_target_url   varchar2(2000);
    iw_action       varchar2(2000);
    iw_codcli       varchar2(100);
    ac_codcli       varchar2(100);
    iw_idtransaccion number(10);
    iw_ipaplicacion varchar2(100);
    iw_usuarioapp   varchar2(100);
    iw_key_iw       varchar2(100);
    iw_idempresacrm varchar2(100);
    iw_solot        solot.codsolot%type;
    iw_tipo         number;
    iw_coderror     number;
    iw_deserror     varchar2(1000);

    /* Declaracion de Variables controlip */
    ci_macaddress   varchar2(100);
    ci_modelcrmid   varchar2(100);
    ci_serie        varchar2(100);
    ci_idproducto   varchar2(100);
    ci_idventa      varchar2(100);
    ci_idservicio   number;
    ci_ipcm         varchar2(100); -- valor desconocido.
    ci_ipccpe       varchar2(100);
    ci_prueba       varchar2(100);
    ci_pid          number;
    ci_idcontrol    number;
    ci_mensaje      varchar(4000);
    ci_error        exception;
    ci_existe       number;

  BEGIN

    /* Consultas de SOT */
    select codsolot into iw_solot from wf where idwf = a_idwf;


    /* Validacion de Ip fija*/
    ci_existe := 1;

    /* Verificacion de Existencia de IP Fija */
    select count(*) into  ci_existe
      from solotpto a, tystabsrv b, insprd p
     where a.codsolot  = iw_solot
       and a.codsrvnue = b.codsrv
       and a.pid       = p.pid
       and a.codinssrv = p.codinssrv
       and b.codsrv in ( select to_char(codigoc)
                           from operacion.opedd
                          where abreviacion = 'SRV_IP'
                            and codigon= to_char(b.idproducto));

    if ci_existe > 0 then

      /* Consultas */
      select codcli   into ac_codcli  from solot where codsolot = iw_solot;

      iw_codcli       := to_Char(to_number(ac_codcli) -1);
      iw_ipaplicacion := SYS_CONTEXT('USERENV','IP_ADDRESS');
      iw_usuarioApp   := user;
      iw_tipo         := 2;
      select utl_raw.cast_to_varchar2(valor) into iw_key_iw from constante where constante='KEY_IW';

      select valor into iw_idempresacrm from constante where constante='IDEMPRESACRM';
      select valor into iw_target_url   from constante where constante='TARGET_URL_IW';
      select valor into iw_action       from constante where constante='ACTION_URL_IW';

      select operacion.seq_iw_idtransaccion.nextval into iw_idtransaccion from dummy_ope;

      /* Envio de Informacion a Intraway */
      iw_esquemaxml:='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:typ="http://claro.com.pe/eai/ebs/ws/operaciones/cargaequipos/types">
         <soapenv:Header/>
         <soapenv:Body>
            <typ:CargaEquiposRequest>
               <typ:idTransaccion>' || to_char(iw_idtransaccion) || '</typ:idTransaccion>
               <typ:ipAplicacion>' || iw_ipAplicacion || '</typ:ipAplicacion>
               <typ:usuarioApp>' || iw_usuarioApp || '</typ:usuarioApp>
               <typ:authKey>' || iw_key_iw || '</typ:authKey>
               <typ:idEmpresaCRM>' || iw_idempresacrm || '</typ:idEmpresaCRM>
               <typ:idClienteCRM>' || iw_codcli || '</typ:idClienteCRM>
               <typ:cantRecords>1</typ:cantRecords>
               <typ:tipoAccion>' || to_char(iw_tipo) || '</typ:tipoAccion>
               <typ:collectExternalInfo>TRUE</typ:collectExternalInfo>
               <typ:showDocsis>TRUE</typ:showDocsis>
               <typ:showPacketCable>TRUE</typ:showPacketCable>
               <typ:showSIP>TRUE</typ:showSIP>
               <typ:showTelevision>TRUE</typ:showTelevision>
            </typ:CargaEquiposRequest>
         </soapenv:Body>
      </soapenv:Envelope>';
      iw_respuestaxml := operacion.pq_iw_ope.f_call_webservice(iw_esquemaxml, iw_target_url, iw_action);

      update operacion.trs_ws_sga
         set respuestaxml  = substr(iw_respuestaxml,1,4000),
             esquemaxml    = substr(iw_esquemaxml,1,4000),
             codsolot      = iw_solot
      where  idtransaccion = iw_idtransaccion;

      /* recuperacion de variables */
      select doc.idservicio,
             doc.idproducto,
             doc.idventa,
             doc.ispcpe,
             doc.macaddress,
             doc.serialnumber
        into ci_idservicio,
             ci_idproducto,
             ci_idventa,
             ci_ipccpe,
             ci_macaddress,
             ci_serie
        from operacion.iw_docsis doc
       where doc.idtransaccion = iw_idtransaccion
         and doc.idproducto in ( select p.pid
                                   from solotpto a, tystabsrv b, insprd p
                                  where a.codsolot  = iw_solot
                                    and a.codsrvnue = b.codsrv
                                    and a.pid       = p.pid
                  and b.tipsrv  in ('0006','0004')
                                    and a.codinssrv = p.codinssrv);

      select pc.mtamodel,
             pc.macaddress
        into ci_modelcrmid,
             ci_prueba
        from operacion.iw_packetcable pc
       where idtransaccion = iw_idtransaccion
         and pc.idproducto in ( select p.pid
                                   from solotpto a, tystabsrv b, insprd p
                                  where a.codsolot  = iw_solot
                                    and a.codsrvnue = b.codsrv
                                    and a.pid       = p.pid
                  and b.tipsrv  in ('0006','0004')
                                    and a.codinssrv = p.codinssrv);

      /* generacion de registro de control_IP*/
      p_insertar_control_ip(iw_solot,
                            ci_macaddress,
                            ci_modelcrmid,
                            ci_serie,
                            ci_idproducto,
                            ci_idventa,
                            ci_idservicio,
                            ci_ipcm,
                            ci_ipccpe,
                            ci_idcontrol,
                            ci_mensaje);

      if ci_idcontrol = 0 then
        raise ci_error;
      end if;
    end if;
  exception
    when ci_error then
       iw_coderror:=-2;
       iw_deserror:= 'pq_cuspe_ope2.p_insertar_control_ip : '||substr(sqlerrm,1,200);

       update operacion.trs_ws_sga
         set codigoerror  = iw_coderror,
             mensajeerror = iw_deserror
       where idtransaccion=iw_idtransaccion;
      commit;
    when others then
      iw_coderror:=-2;
      iw_deserror:= 'pq_cuspe_ope2.p_pre_controlip : '||substr(sqlerrm,1,200);

      update operacion.trs_ws_sga
         set codigoerror  = iw_coderror,
             mensajeerror = iw_deserror
       where idtransaccion=iw_idtransaccion;
      commit;
  end p_pre_controlip;

  procedure p_chg_controlip(a_idtareawf in number,
                            a_idwf      in number,
                            a_tarea     in number,
                            a_tareadef  in number,
                            a_tipesttar in number,
                            a_esttarea  in number,
                            a_mottarchg in number,
                            a_fecini    in date,
                            a_fecfin    in date) is

    /* Declaracion de Variables */
    ch_codsolot   solot.codsolot%type;
    ch_cid        solotpto.cid%type;
    ch_codinssrv  solotpto.codinssrv%type;
    ch_pid        solotpto.pid%type;
    ch_mensajes   varchar(1000);
    ch_numip      number;
    ch_reg        number;
    ch_existe     number;
    ch_valida     number;
    ch_error1     exception;
    ch_error2     exception;

    cursor ip_fija(ip_codsolot  solot.codsolot%type,
                   ip_cid       solotpto.cid%type,
                   ip_codinssrv solotpto.codinssrv%type) is
         select *
           from operacion.controlip ip
          where ip.cod_solot = ip_codsolot
            and ip.cod_cid   = ip_cid
            and ip.codinssrv = ip_codinssrv;
  begin
    if a_tipesttar = 4  and a_esttarea = 4 then

      /* Consulta de SOT */
      select codsolot
        into ch_codsolot
        from wf
       where idwf = a_idwf;

      /* Verificacion de Existencia de IP Fija */
      select count(*) into  ch_existe
        from solotpto a, tystabsrv b, insprd p
       where a.codsolot  = ch_codsolot
         and a.codsrvnue = b.codsrv
         and a.pid       = p.pid
         and a.codinssrv = p.codinssrv
         and b.codsrv in ( select to_char(codigoc)
                             from operacion.opedd
                            where abreviacion = 'SRV_IP'
                              and codigon= to_char(b.idproducto));

      if ch_existe = 1 then
        /* Consulta */
        select a.cid, a.codinssrv,a.pid, a.cantidad
          into ch_cid, ch_codinssrv, ch_pid, ch_numip
          from solotpto a, tystabsrv b, insprd p
         where a.codsolot = ch_codsolot
           and a.codsrvnue = b.codsrv
           and a.pid = p.pid
           and a.codinssrv = p.codinssrv
           and b.codsrv in ( select to_char(codigoc)
                               from operacion.opedd
                              where abreviacion = 'SRV_IP'
                                and codigon= to_char(b.idproducto));

         select count(*)
           into ch_reg
           from operacion.controlip ip
          where ip.cod_solot = ch_codsolot
            and ip.cod_cid   = ch_cid
            and ip.codinssrv = ch_codinssrv
            and ip.estado    = 1;

        if  ch_numip > ch_reg then
            raise ch_error2;
        end if;

        /* Validacion de Control de IP */
        ch_valida := 1;
        for reg in ip_fija(ch_codsolot, ch_cid, ch_codinssrv) loop

            if reg.mac_address_cm is null then
               ch_mensajes := 'MAC Adress, ';
               ch_valida := 0;
            end if;
            if reg.num_serie is null then
               ch_mensajes := ch_mensajes || 'Serial Number, ';
               ch_valida := 0;
            end if;
            if reg.modelo is null then
               ch_mensajes := ch_mensajes || 'Modelo, ';
               ch_valida := 0;
            end if;
            if reg.Ip_Cm is null then
               ch_mensajes := ch_mensajes || 'IP CM, ';
               ch_valida := 0;
            end if;
            if reg.id_producto is null or reg.id_servicio is null  or reg.id_venta is null then
               ch_mensajes := ch_mensajes || 'Identificadador Intraway(idproducto, id_servicio, id_venta), ';
               ch_valida := 0;
            end if;
            if reg.red_pc is null then
               ch_mensajes := ch_mensajes || 'RED PC, ';
               ch_valida := 0;
            end if;
            if reg.ips_cpe_fija is null then
               ch_mensajes := ch_mensajes || 'IP FIJA CPE, ';
               ch_valida := 0;
            end if;
            if reg.mac_cpe_fija is null then
               ch_mensajes := ch_mensajes || 'MAC FIJA CPE, ';
               ch_valida := 0;
            end if;
            if ch_valida = 0 then
               raise ch_error1;
            end if;
        end loop;
      end if;
    end if;
  exception
    when ch_error1 then
      raise_application_error(-20500, 'Configuracion de IP FIJA: Faltan configurar los siguente(s) Campo(s) ' || ch_mensajes );
    when ch_error2 then
      raise_application_error(-20500, 'Configuracion de IP FIJA: Falta Registrar los numero de IP configuradas ');
    when others then
      return;
  end;
  --fin 19.0

--24.0
  procedure p_anula_sot_sga_bscs(an_codsolot number) is
    --Variables
    p_mensaje  varchar2(3000);
    p_error    number;
    n_sec_proc number;
    l_Cnt      number;
    l_Cnt_des  number;
   --Cursor de Sots de Instalacion HFC rechazadas
    cursor c_sots_hfc_inst_x_anular is
      select s.*
        from solot s, estsol e
       where s.estsol = e.estsol
         and e.tipestsol = 7
         and s.codsolot=an_codsolot;
    n_val_sot_sisact number;
  begin
    --Obtener secuencial del proceso
    select operacion.sq_proc_anula_sot_hfc_inst.nextval into n_sec_proc from dummy_ope;
    --Lectura del Cursor de Sots identificadas
    for reg in c_sots_hfc_inst_x_anular loop
      SELECT count(1) into n_val_sot_sisact FROM sales.int_negocio_instancia i,vtatabslcfac f, solot s
      where i.instancia = 'PROYECTO DE VENTA' and i.idinstancia= f.numslc
      and f.numslc = s.numslc and f.idsolucion = 182 and s.codsolot= reg.codsolot;
      if n_val_sot_sisact=0 then --No es de SISACT
        --Liberacion de espacio en Intraway
        select count(*)
        into l_Cnt
        from int_mensaje_intraway
        where codsolot = reg.codsolot and
              proceso = 3 and --Instalación
              id_error = 0;
        l_Cnt_des:=0;
        IF l_Cnt > 0 and reg.tiptra = 424 THEN
          select count(*)
          into l_Cnt_des
          from int_mensaje_intraway
          where codsolot = reg.codsolot and
                proceso = 4 and --DESinstalación
                id_error = 0;
        END IF;
        IF l_Cnt > 0 THEN
           delete from int_transaccionesxsolot
           where codsolot = reg.codsolot;

           delete from int_mensaje_intraway
           where codsolot = reg.codsolot;
           p_libera_reserva_shell(reg.codsolot, 0, p_mensaje, p_error);
           if p_error = -1 then
              goto salto;
           end if;
        END IF;
      else--SISACT
        TIM.PP021_VENTA_HFC.SP_ANULAR_VENTA@DBL_BSCS_BF(reg.cod_id,p_error,p_mensaje);--Libera el numero de BSCS
        if p_error = -1 or p_error = -2 then
          rollback;
          goto salto;
        end if;
        commit;
        p_libera_numero_iw(reg.codsolot);
      end if;
      --Liberacion de numero telefonico en SGA
      p_libera_numero_shell(reg.codsolot, p_mensaje, p_error);
      if p_error = -1 then
        goto salto;
      end if;
      --Actualizar secuencial de proceso
      begin
        update solot
           set n_sec_proc_shell = n_sec_proc
         where codsolot = reg.codsolot;
      exception
        when others then
          p_mensaje := sqlerrm;
          goto salto;
      end;

      begin
         --INI 14.0
        IF l_Cnt > 0 and l_Cnt_des > 0 THEN          --21.0
           --Si existe reserva en INTRAWAY entonces se realiza una preanulacion
           operacion.pq_solot.p_anular_solot(reg.codsolot, 20); -- PRE ANULACION

           INSERT INTO solotchgest
              (codsolot, tipo, estado, fecha, observacion)
           VALUES
              (reg.codsolot, 1, 20, SYSDATE, 'Pre-Anulación Masiva HFC.');
           -- Llena Informacion a insertar la raiz en INT_ENVIO
           p_int_iw_solot_anuladas(reg.codsolot);
        ELSE
           --Sino existe reserva en INTRAWAY entonces se anula la SOT.
           operacion.pq_solot.p_anular_solot(reg.codsolot, 13); -- ANULACION

           INSERT INTO solotchgest
              (codsolot, tipo, estado, fecha, observacion)
           VALUES
              (reg.codsolot, 1, 13, SYSDATE, 'Anulación Masiva HFC.');
        END IF;
        --FIN 14.0
      exception
        when others then
          goto salto;
      end;
      commit;
      <<salto>>
      rollback;
    end loop;
    --Envio de correo
    p_envia_correo_shell(n_sec_proc, p_mensaje, p_error);
  exception
    when others then
      null;
  end;

  procedure p_libera_numero_iw(an_codsolot number) is
  l_retorno NUMBER;
  y                   VARCHAR2(1000);
  l_clientecrm        CHAR(8);
  l_idproducto        VARCHAR2(100);
  l_idproductopadre   VARCHAR2(100);
  l_idventa           VARCHAR2(100);
  l_idventapadre      VARCHAR2(100);
  l_endpointn         VARCHAR2(100);
  l_homeexchangename  VARCHAR2(100);
  l_homeexchangecrmid VARCHAR2(100);
  l_fechaActivacion   DATE;
  v_mensaje                VARCHAR2(1000);
  yy                  VARCHAR2(1000);
  n_error         NUMBER;
cursor c_itw is
  SELECT i.codinssrv, i.numero,s.cod_id,s.customer_id,s.codcli
  FROM inssrv i, solot s
  WHERE i.numslc = s.numslc
  AND s.codsolot = an_codsolot
  AND i.tipinssrv = 3;
BEGIN
  for c_i in c_itw loop
    intraway.pq_consultaitw.p_int_consultatn(c_i.numero,l_retorno,y,l_clientecrm,
      l_idproducto,l_idproductopadre,l_idventa,l_idventapadre,l_endpointn,l_homeexchangename,
      l_homeexchangecrmid,l_fechaActivacion);
    IF l_retorno = 1 THEN
      intraway.pq_intraway.p_mta_ep_administracion(0,l_clientecrm,l_idproducto,l_idproducto,
        l_idproductopadre,l_endpointn,c_i.numero,l_homeexchangecrmid,4,an_codsolot,
        c_i.codinssrv,v_mensaje,yy,n_error,1,l_idventa,l_idventapadre);
      operacion.pq_iw_sga_bscs.p_reg_log(c_i.codcli,c_i.customer_id,NULL,an_codsolot,0,n_error,v_mensaje,c_i.cod_id,'Liberación IW: '|| c_i.numero);
    ELSE
      operacion.pq_iw_sga_bscs.p_reg_log(c_i.codcli,c_i.customer_id,NULL,an_codsolot,0,n_error,v_mensaje,c_i.cod_id,'Liberación IW: '|| c_i.numero);
    END IF;
  end loop;
end;


procedure p_libera_numero_bscs(an_cod_id in number, an_error out integer, av_error out varchar2)
 IS
  n_codsolot integer;
  error_general EXCEPTION;
  n_error integer;
  v_error varchar2(200);
  BEGIN
    TIM.PP021_VENTA_HFC.SP_ANULAR_VENTA@DBL_BSCS_BF(an_cod_id,n_error,v_error);
    if n_error<0 then
      RAISE error_general;
    end if;
    operacion.pq_iw_sga_bscs.p_reg_log(null,null,NULL,n_codsolot,null,an_error,av_error,an_cod_id,'Liberar Número BSCS');
  EXCEPTION
    WHEN error_general THEN
      an_Error:=n_error ;
      av_error:='Error SGA-BSCS: ' || v_error;
      operacion.pq_iw_sga_bscs.p_reg_log(null,null,NULL,n_codsolot,null,an_error,av_error,an_cod_id,'Liberar Número BSCS');
      raise_application_error(-20001, av_error);
    WHEN OTHERS THEN
      av_error:= 'Error Liberar Número BSCS: ' || SQLERRM;
      an_error:=sqlcode;
      operacion.pq_iw_sga_bscs.p_reg_log(null,null,NULL,n_codsolot,null,an_error,av_error,an_cod_id,'Liberar Número BSCS');
      raise_application_error(-20001, av_error);
END;

END;
/
