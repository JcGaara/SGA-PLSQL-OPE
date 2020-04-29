CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_SOLOT AS
  /*****************************************************************************************************
   NAME:       PQ_SOLOT
   PURPOSE:    Manejo de Sol. OT.

   REVISIONS:
     Ver        Date        Author             Solicitado por                  Description
     ---------  ----------  ---------------    --------------                  ----------------------
     1.0        16/10/2002  Carlos Corrales
                18/07/2003  Carlos Corrales                                    Se modifico P_ASIG_WF para que ejecute automaticamente la SOT al asignar un WF
                01/09/2003  Carlos Corrales                                    Se hizo las modificaciones para soportar DEMOs
                02/08/2004  Victor Valqui                                      Permite grabar la observacion cuando se cambia el estado de una SOT.
                11/08/2004  Victor Valqui                                      Motivo que permite corregir la fecha de compromiso.
                01/03/2005  Dessie Astocaza                                    En insert_trssolot, se permite registrar, flgbil,fecinifac,codclices
     2.0        27/05/2009  Hector Huaman M.                                   REQ.93756
     3.0        23/06/2009  Victor Valqui                                      Primesys Agregar campos usuarioresp,usuarioasig,arearesp
     4.0        22/09/2009  Hector Huaman M.                                   REQ.103636: Actualizar las fechas de compromiso a las SOT que aun no tengan la fecha de compromiso
     5.0        28/09/2009  Hector Huaman M.                                   REQ.102366:se cambio procedimiento p_insert_solot para agregar direccion referencial.
     6.0        29/09/2009  Hector Huaman M                                    REQ-96885:asegurar que pase a ejecucion la SOT cuando se le asigna el Worflow
     7.0        06/09/2009  Hector Huaman M                                    REQ-105020:para poder cerrar la SOT se considera el estado cancelado de las tareas
     8.0        12/09/2009  Hector Huaman M                                    REQ-104730:se creo el procedimiento p_valida_trssolot para valir el estado del servicio antes de  proceder a activarlo.
     9.0        13/09/2009  Antonio Lagos                                      Se crea procedure p_insert_solot_aut para crear solot
                                                                               de baja por procedimiento desde SGA Operaciones.
     10.0       19/09/2009  Luis Patiño                                        se agrego procedimiento para generacion de solicitud de anulacio plataforma
     11.0       03/12/2009  Jimmy Farfán/                                      Req. 97766
                             Edson Caqui                                       p_aprobar_solot:         para poder asignar WF automàticamente de
                                                                               acuerdo al WFDEF.
                                                                               p_crear_trssolot:        se obtiene el tipo de transacción configurado
                                                                               según el tipo de trabajo.
                                                                               p_exe_trssolot:          se agregó una validación para el tipo de transacción
                                                                               creada de nombre 'Activacion - No Factura'.
                                                                               p_activacion_automatica: Activación automática del servicio.
     12.0       01/02/2010  Antonio Lagos                                      REQ 106908 se crea funciones para obtener la sot de un proyecto y utilizarla en acceso directo a control de tareas
                                                                               se crea funciones para obtener el area de una solot y utilizarla en acceso directo a control de tareas
     13.0       24/03/2010  Antonio Lagos                                      REQ. 119998, se agrega area solicitante al crear sot.
     14.0       20/07/2010  Antonio Lagos                                      REQ. 134968, el usuario solicita correccion de duplicidad de equipos al cambiar de estado rechazado a en ejecuccion
                                                                               Razon del problema: cuando una sot pasa a un estado rechazado no deberia cancelar el wf, solo suspenderlo,
                                                                               porque cuando cambia de estado rechazado a en ejecucion no encuentra el wf y lo vuelve a crear.
     15.0       17/08/2010  Joseph Asencios                                    REQ-137046: Se modificó el procedimiento p_crear_trssolot
     16.0       15/10/2010  Joseph Asencios                                    Manuel Gallegos          REQ-145961: Se modificó el procedimiento p_chg_estado_solot
     17.0       08/07/2010  Joseph Asencios                                    REQ-118672: Se creo los procedimientos p_insert_trssolot_pa,p_insert_sol_fec_retro_det, p_exe_trssolot_pa,
                                                                               p_notifica_sol_act, p_registra_chg_estado_sol_act,f_valida_tipo_restriccion
     18.0       21/12/2010  Antonio Lagos                                      Edilberto Quispe       REQ-134845: Se agrega sincronizacion de estado de SOT a incidencia
     19.0       31/05/2010  Widmer Quispe      Edilberto Astulle               Req: 123054 y 123052, Asignacion de plataforma
     20.0       26/08/2011  Ivan Untiveros     Guillermo Salcedo               REQ-160869:Sincronizacion ventas masivas
     21.0       10/10/2011  Joseph Asencios    Manuel Gallegos                 REQ-160972:Adecuaciones para el envio de recibo vía email.
     22.0       30/11/2011  Roy Concepcion     Hector Huaman                   Req: 161362, Generacion de SOT para DTH Postventa
     23.0       15/11/2012  Carlos Lazarte     Tommy Arakaki                   Req: 163468, Corte de señal automática
     24.0       30/01/2013  Alfonso Pérez      Elver Ramirez                   Req:163839 Cierre de Facturación
     25.0       28/02/2012  Edilberto Astulle  PROY-6892                       Restriccion de Acceso a Servicios 3Play Edificios
     26.0       16/01/2013  Dorian Sucasaca    Tommy Arakaki                   Soporte: Mejora  para el cierre de WF
     27.0       06/08/2013  Dorian Sucasaca    Arturo Saavedra                 Req: 164536 Servicio de TV satelital empresas tiene problemas (67 Funciona, 119 No Funciona).
     28.0       18/06/2013  Carlos Lazarte     Tommy Arakaki                   Req:164387 Mejoras en operaciones
     29.0       22/08/2013  Erlinton Buitron   Alberto Miranda                 PROY 9184 - Instalación de TPI GSM
     30.0       25/10/2013  Alfonso Perez R.   Hector Huaman                   REQ-164553: Actualizar campo resumen en la sot
     31.0       28/10/2013  Ricardo Crisostomo Tommy Arakaki                   REQ 164669 - Retiro de Equipos
     32.0       05/03/2014  Eustaquio Gibaja   Christian Riquelme              PROY-12149 Lineas Control Janus
     33.0       23/05/2014  Dorian Sucasaca    Arturo Saavedra                 REQ 164813 PROY-11240 IDEA-13797 SOT para duplicar ancho de banda a clientes HFC
     34.0       10/03/2014  David Garcia B     Arturo Saavedra                 PROY-12756 IDEA-13013-Implemen mej. de cod.de activac. HFC y borrado de reservas en IWAY
     35.0       25/03/2014  Dorian Sucasaca    Arturo Saavedra                 REQ 164856 PROY-12422 IDEA-14895 Cambio titularidad, numero
     36.0       23/05/2014  David Garcia B.    Carlos Lazarte                  IDEA-7832 Migración Traslados Externos HFC
     37.0       21/11/2014  Freddy Gonzales    Alberto Miranda                 IDEA 21446-Mejoras de Portabilidad: Liberar numero en BSCS, IW y SISACT.
     38.0       03/12/2014  Edwin Vasquez      Gillermo Salcedo                SD-75117 - HFC en DATOS - habilitacion de facturacion SGA
     39.0       2015-02-03  Freddy Gonzales    Alberto Miranda                 SD-172757 - Anular portabilidad Claro Empresas
     40.0       30/06/2015  Luis Flores Osorio                                 SD-318468 - Validacion para que no libere numeros de acuerdo a los ID_PRODUCTO configurados
     41.0       24/05/2015  Eduardo Villafuerte  Rodolfo Ayala                 PROY-17824 - Anulación de SOT y asignación de número telefónico
     42.0       06/10/2015  Danny Sanchez      Eustaquio Gibaja                PQT-245308-TSK-75749 - 3Play Inalambrico
     43.0       10/06/2015  Jorge Rivas        Manuel Gallegos
     44.0       03/07/2017  Juan Gonzales      Alfredo Yi                      PROY-27792 - Rollback Cambio de Numero
	 44.0       03/07/2017  Luis Guzman        Tito Huerta                     PROY-27792 - Rollback Cambio de Plan
     45.0       19/10/2016  Juan Olivares      Henry Huamani                   PROY-26477-IDEA-33647 Mejoras en SIACs Reclamos, generación y cierre automático de SOTs
***************************************************************************************************/

/**********************************************************************
Inserta un registro en SOLOT
**********************************************************************/
procedure p_insert_solot(
   ar_solot  in solot%rowtype,
   a_codsolot out number
)
is

l_codsolot solot.codsolot%type;

begin

   if ar_solot.codsolot is null then
      l_codsolot:=  F_GET_CLAVE_SOLOT();
   else
      l_codsolot := ar_solot.codsolot;
   end if;

   insert into solot (
      codsolot,
      tiptra,
      estsol,
      docid,
      tipsrv,
      fecapr,
      fecfin,
      observacion,
      codcli,
      numslc,
      derivado,
      coddpt,
      recosi,
      codmotot,
      estasi,
      origen,
      cliint,
      tiprec,
      numpsp,
      idopc,
      tipcon,
      plan,
      estsolope,
      feccom,
      numptas,
      fecini,
      prycon,
      idproducto,
      areasol,--13.0
      arearesp, --3.0
      usuarioresp, --3.0
      direccion,--5.0
      codubi,--5.0
      codigo_clarify, -- 22.0
       resumen -- 30.0
       ) values (
      l_codsolot,
      ar_solot.tiptra,
      ar_solot.estsol,
      ar_solot.docid,
      ar_solot.tipsrv,
      ar_solot.fecapr,
      ar_solot.fecfin,
      ar_solot.observacion,
      ar_solot.codcli,
      ar_solot.numslc,
      decode(ar_solot.derivado,null,0,ar_solot.derivado),
      ar_solot.coddpt,
      ar_solot.recosi,
      ar_solot.codmotot,
      ar_solot.estasi,
      ar_solot.origen,
      ar_solot.cliint,
      ar_solot.tiprec,
      ar_solot.numpsp,
      ar_solot.idopc,
      ar_solot.tipcon,
      ar_solot.plan,
      ar_solot.estsolope,
      ar_solot.feccom,
      ar_solot.numptas,
      ar_solot.fecini,
      ar_solot.prycon,
      ar_solot.idproducto,
      ar_solot.areasol,--13.0
      ar_solot.arearesp, --3.0
      ar_solot.usuarioresp,  --3.0
      ar_solot.direccion,--5.0
      ar_solot.codubi,--5.0
      ar_solot.codigo_clarify,-- 22.0
      ar_solot.resumen); -- 30.0
   a_codsolot := l_codsolot;
end;

/**********************************************************************
Inserta un registro en SOLOTPTO
**********************************************************************/
procedure p_insert_solotpto(
   ar_solotpto  in solotpto%rowtype,
   a_punto out number
)
is

l_punto solotpto.punto%type;

begin

   if ar_solotpto.punto is null then
      select nvl(max(punto),0)+1 into l_punto from solotpto
      where codsolot = ar_solotpto.codsolot ;
   else
      l_punto := ar_solotpto.punto;
   end if;

   insert into solotpto (
      codsolot,
      punto,
      tiptrs,
      codsrvant,
      bwant,
      codsrvnue,
      bwnue,
      codinssrv,
      cid,
      descripcion,
      direccion,
      tipo,
      estado,
      visible,
      puerta,
      pop,
      codubi,
      fecini,
      fecfin,
      fecinisrv,
      feccom,
      tiptraef,
      tipotpto,
      efpto,
      pid,
      pid_old,
      cantidad,
      codpostal,
      codinssrv_tra,
      flgmt,
      idplataforma, --<19.0>
      codincidence, idplano --25.0
       ) values (
      ar_solotpto.codsolot,
      l_punto,
      ar_solotpto.tiptrs,
      ar_solotpto.codsrvant,
      ar_solotpto.bwant,
      ar_solotpto.codsrvnue,
      ar_solotpto.bwnue,
      ar_solotpto.codinssrv,
      ar_solotpto.cid,
      ar_solotpto.descripcion,
      ar_solotpto.direccion,
      ar_solotpto.tipo,
      ar_solotpto.estado,
      ar_solotpto.visible,
      ar_solotpto.puerta,
      ar_solotpto.pop,
      ar_solotpto.codubi,
      ar_solotpto.fecini,
      ar_solotpto.fecfin,
      ar_solotpto.fecinisrv,
      ar_solotpto.feccom,
      ar_solotpto.tiptraef,
      ar_solotpto.tipotpto,
      ar_solotpto.efpto,
      ar_solotpto.pid,
      ar_solotpto.pid_old,
      ar_solotpto.cantidad,
      ar_solotpto.codpostal,
      ar_solotpto.codinssrv_tra,
      nvl(ar_solotpto.flgmt,0),
      ar_solotpto.idplataforma, --<19.0>
      ar_solotpto.codincidence, ar_solotpto.idplano--25.0
      ) ;

   a_punto := l_punto;
end;

/**********************************************************************
Inserta un registro en trssolot
**********************************************************************/
procedure p_insert_trssolot(
   ar_trssolot  in trssolot%rowtype,
   a_codtrs out number
)
is

l_codtrs trssolot.codtrs%type;

begin

   if ar_trssolot.codtrs is null then
      l_codtrs:=  f_get_clave_trssolot();
   else
      l_codtrs := ar_trssolot.codtrs;
   end if;

   insert into trssolot (
      codtrs,
      codinssrv,
      codsolot,
      tipo,
      tiptrs,
      esttrs,
      estinssrv,
      estinssrvant,
      codsrvnue,
      bwnue,
      codsrvant,
      bwant,
      feceje,
      fectrs,
      numslc,
      numpto,
      idadd,
      fecusu,
      codusu,
      codusueje,
      punto,
      pid,
      pid_old,
    fecinifac,
    flgbil,
    codclices,
    codgrupopro,
    codgrupofac,
    idinstprodces,
    idplataforma, --<19.0>
    --ini 21.0
    idtipenv,
    codemail,
    feccodemail
    --fin 21.0
       ) values (
      l_codtrs,
      ar_trssolot.codinssrv,
      ar_trssolot.codsolot,
      ar_trssolot.tipo,
      ar_trssolot.tiptrs,
      ar_trssolot.esttrs,
      ar_trssolot.estinssrv,
      ar_trssolot.estinssrvant,
      ar_trssolot.codsrvnue,
      ar_trssolot.bwnue,
      ar_trssolot.codsrvant,
      ar_trssolot.bwant,
      ar_trssolot.feceje,
      ar_trssolot.fectrs,
      ar_trssolot.numslc,
      ar_trssolot.numpto,
      ar_trssolot.idadd,
      ar_trssolot.fecusu,
      ar_trssolot.codusu,
      ar_trssolot.codusueje,
      ar_trssolot.punto,
      ar_trssolot.pid,
      ar_trssolot.pid_old,
      ar_trssolot.fecinifac,
      ar_trssolot.flgbil,
      ar_trssolot.codclices,
      ar_trssolot.codgrupopro,
      ar_trssolot.codgrupofac,
      ar_trssolot.idinstprodces,
      ar_trssolot.idplataforma, --<19.0>
      --ini 21.0
      ar_trssolot.idtipenv,
      ar_trssolot.codemail,
      ar_trssolot.feccodemail
      --fin 21.0
       ) ;

   a_codtrs := l_codtrs;
end;

/******************************************************************************
  Llena las transacciones desde los proyectos o solicitudes segun corresponda

  opcion 0 : Transacciones desde un proyecto, instalaciones o upgrades
  opcion 1 : [No Implementada] Suspensiones o Cancelaciones dando como referencia un proyecto
  opcion 2 : [No Implementada] Bajas sin proyecto de referencia solo cliente
  opcion 3 : Llenar lo que esta en la solicitud de OT
  opcion 4 : averiguar de que se trata y llamar a uno de los anteriores

  TIPOS
  -----
  Tipo 1 : Puntos a activar desde proy
  Tipo 2 : [Ya no existe mas ] Equipos a activar desde proy
  Tipo 3 : Puntos desde la solicitud
******************************************************************************/
  procedure p_crear_trssolot(a_opcion   in number,
                             a_codsolot in number default null,
                             a_numslc   in char default null,
                             a_numpsp   in char default null,
                             a_idopc    in char default null,
                             a_codcli   in char default null) is

    r_trssolot trssolot%rowtype;
    l_codtrs   trssolot.codtrs%type;
    r_pid      insprd%rowtype;

    l_codcli solot.codcli%type;
    l_numslc solot.numslc%type;
    l_numpsp solot.numpsp%type;
    l_idopc  solot.idopc%type;
    l_cont   number;
    L_TIPTRS number(8);
    l_flg_ef number;

    l_codinssrv inssrv.codinssrv%type;
    --ini 15.0
    ln_surec     number;
    ln_estinsprd insprd.estinsprd%type;
    --fin 15.0

    --ini 21.0
    ln_idtipenv    vtatabprecon.idtipenv%type;
    ln_codemail    vtatabprecon.codemail%type;
    ld_feccodemail vtatabprecon.feccodemail%type;
    --fin 21.0

    --<INI 24.0>
    ln_cantidad number;
    ld_feccom   date;
    --<FIN 24.0>

    /* Datos para un SOT que viene de proyecto */
    cursor cur_det is
      select *
        from solotpto
       where codsolot = a_codsolot
         and punto not in (select punto
                             from trssolot
                            where codsolot = a_codsolot
                              and esttrs = 2)
         and pid is not null;

    /* Detalle de SOT sin PID */
    cursor cur_det_sol is
      select *
        from solotpto
       where codsolot = a_codsolot
         and codinssrv is not null
         and pid is null;

    /* Detalle de PID */
    cursor cur_det_sol_PID is
      select *
        from solotpto
       where codsolot = a_codsolot
         and codinssrv is not null
         and pid is not null;

    /* IP activas de la IS */
    cursor cur_pid is
      select *
        from insprd
       where codinssrv = l_codinssrv
         and estinsprd <> 3;

    l_tipcon number(1);

  begin

    if A_OPCION = 0 then
      /* Primero se hara una validacion
          solo se regeneran los puntos que no tengan ninguno aprobado
      select count(*) into l_cont from trssolot where codsolot = a_codsolot and esttrs = 2;
       if l_cont = 0 then -- Normal
        delete trssolot where numslc = a_codsolot and esttrs = 1 ;
       end if;
       */
      --ini 21.0
      begin
        select v.idtipenv, v.codemail, v.feccodemail
          into ln_idtipenv, ln_codemail, ld_feccodemail
          from vtatabprecon v
         where v.numslc in (select numslc from solot where codsolot = a_codsolot);
      exception
        when others then
          ln_idtipenv    := 1;
          ln_codemail    := null;
          ld_feccodemail := null;
      end;
      --fin 21.0

      --<INI 24.0>
      select nvl(count(1), 0)
        into ln_cantidad
        from atccorp.atc_trs_baja_x_cp
       where codsolot = a_codsolot;

      if ln_cantidad > 1 then
        select feccom
          into ld_feccom
          from atccorp.atc_trs_baja_x_cp
         where codsolot = a_codsolot;

        r_trssolot.fectrs := ld_feccom;
      end if;
      --<FIN 24.0>

      for r_det in cur_det loop

        select count(1)
          into l_cont
          from trssolot
         where codsolot = a_codsolot
           and punto = r_det.punto
           and esttrs = 2;

        if l_cont = 0 then

          delete trssolot
           where codsolot = a_codsolot
             and punto = r_det.punto
             and (pid = r_det.pid or pid = r_det.pid_old)
             and esttrs = 1;

          select * into r_pid from insprd where pid = r_det.pid;

          --<11.0>
          -- se obtiene el tipo de transacción configurado según el tipo de trabajo
          begin
            select t.tiptrs
              into l_tiptrs
              from solot s, tiptrabajo t
             where s.tiptra = t.tiptra
               and s.codsolot = a_codsolot;
          exception
            when others then
              l_tiptrs := null;
          end;

          if l_tiptrs is null then
            l_tiptrs := 1;
          end if;
          --</11.0>

          r_trssolot.codinssrv := r_det.codinssrv;
          r_trssolot.codsolot  := r_det.codsolot;
          r_trssolot.punto     := r_det.punto;
          r_trssolot.tipo      := 1;
          r_trssolot.tiptrs    := l_tiptrs; --1;             --<11.0>
          r_trssolot.esttrs    := 1;
          r_trssolot.codsrvnue := r_det.codsrvnue;
          r_trssolot.bwnue     := r_det.bwnue;
          r_trssolot.numslc    := r_pid.numslc;
          r_trssolot.numpto    := r_pid.numpto;
          r_trssolot.pid       := r_det.pid;
          r_trssolot.pid_old   := r_det.pid_old;
          --Ini 29.0
          if OPERACION.pq_cuspe_ope.exist_paquete_tpi_gsm(r_pid.numslc) then
            r_trssolot.flgbil := 7; -- Interfaz.
            r_trssolot.obserr := 'El producto TPI GSM no sera ingresado al ciclo'; -- Interfaz.
          elsif esta_habilitado() and pq_int_pryope.es_venta_sisact(r_pid.numslc) then
            r_trssolot.flgbil := get_flgbil();
          else
            r_trssolot.flgbil := 0; -- Interfaz.
          end if;
          --Fin 29.0
          r_trssolot.idplataforma := r_det.idplataforma; --<19.0>
          --ini 21.0
          r_trssolot.idtipenv    := ln_idtipenv;
          r_trssolot.codemail    := ln_codemail;
          r_trssolot.feccodemail := ld_feccodemail;
          --fin 21.0
          pq_solot.p_insert_trssolot(r_trssolot, l_codtrs);

          -- Se inserta la transaccion de cancelacion
          if r_det.pid_old is not null then
            -- Solo se genera Cancelacion si el PID nuevo no es DEMO
            select tipcon into l_tipcon from insprd where pid = r_det.pid;
            if l_tipcon = 0 then
              r_trssolot.codinssrv    := r_det.codinssrv;
              r_trssolot.codsolot     := r_det.codsolot;
              r_trssolot.punto        := r_det.punto;
              r_trssolot.tipo         := 1;
              r_trssolot.tiptrs       := 5; -- Cancelacion
              r_trssolot.esttrs       := 1;
              r_trssolot.codsrvnue    := r_det.codsrvnue;
              r_trssolot.bwnue        := r_det.bwnue;
              r_trssolot.numslc       := r_pid.numslc;
              r_trssolot.numpto       := r_pid.numpto;
              r_trssolot.pid          := r_det.pid_old;
              r_trssolot.pid_old      := null;
              r_trssolot.flgbil       := 0; -- Interfaz.
              r_trssolot.idplataforma := r_det.idplataforma; --<19.0>

              --ini 21.0
              r_trssolot.idtipenv    := ln_idtipenv;
              r_trssolot.codemail    := ln_codemail;
              r_trssolot.feccodemail := ld_feccodemail;
              --fin 21.0

              pq_solot.p_insert_trssolot(r_trssolot, l_codtrs);
            end if;
          end if;
        end if;

      end loop;

    elsif A_OPCION = 1 then
      raise_application_error(-20500,
                              'PQ_SOLOT.p_crear_trssolot opcion no valida: ' ||
                              a_opcion);
    elsif A_OPCION = 2 then
      raise_application_error(-20500,
                              'PQ_SOLOT.p_crear_trssolot opcion no valida: ' ||
                              a_opcion);
    elsif A_OPCION = 3 then

      --<INI 24.0>
      select nvl(count(1), 0)
        into ln_cantidad
        from atccorp.atc_trs_baja_x_cp
       where codsolot = a_codsolot;

      if ln_cantidad > 1 then
        select feccom
          into ld_feccom
          from atccorp.atc_trs_baja_x_cp
         where codsolot = a_codsolot;

        r_trssolot.fectrs := ld_feccom;
      end if;
      --<FIN 24.0>
      --delete trssolot where numslc = a_codsolot and esttrs = 1 ;

      select t.tiptrs
        into l_tiptrs
        from solot s, tiptrabajo t
       where s.tiptra = t.tiptra
         and s.codsolot = a_codsolot;

      --ini 15.0: se identifica si la transacion es del tipo suspension/reconexion
      select count(1)
        into ln_surec
        from tiptrs
       where abrevi in ('SU', 'RE')
         and tiptrs = l_tiptrs;
      --fin 15.0

      if l_tiptrs is null then
        raise_application_error(-20500,
                                'PQ_SOLOT.p_crear_trssolot Esta solicitud no puede afectar facturacion ' ||
                                a_codsolot);
      end if;

      for r_det in cur_det_sol loop

        l_codinssrv := r_det.codinssrv;
        for r_ip in cur_pid loop

          select count(1)
            into l_cont
            from trssolot
           where codsolot = a_codsolot
             and punto = r_det.punto
             and pid = r_ip.pid
             and esttrs = 2;

          if l_cont = 0 then
            --ini 15.0
            if ln_surec = 0 or (ln_surec > 0 and r_ip.estinsprd <> 4) then
              --fin 15.0
              delete trssolot
               where codsolot = a_codsolot
                 and punto = r_det.punto
                 and pid = r_ip.pid
                 and esttrs = 1;

              r_trssolot.codinssrv    := r_det.codinssrv;
              r_trssolot.codsolot     := r_det.codsolot;
              r_trssolot.tipo         := 1;
              r_trssolot.tiptrs       := l_tiptrs;
              r_trssolot.esttrs       := 1;
              r_trssolot.codsrvnue    := r_det.codsrvnue;
              r_trssolot.bwnue        := r_det.bwnue;
              r_trssolot.numslc       := null;
              r_trssolot.numpto       := null;
              r_trssolot.punto        := r_det.punto;
              r_trssolot.pid          := r_ip.pid;
              r_trssolot.pid_old      := null;
              r_trssolot.flgbil       := 0; -- Interfaz.
              r_trssolot.idplataforma := r_det.idplataforma; --<19.0>

              pq_solot.p_insert_trssolot(r_trssolot, l_codtrs);
              --ini 15.0
            end if;
            --fin 15.0
          end if;
        end loop;

      end loop;

      -- Las SOLOTPTO cod PID
      for r_det in cur_det_sol_pid loop

        select count(1)
          into l_cont
          from trssolot
         where codsolot = a_codsolot
           and punto = r_det.punto
           and pid = r_det.pid
           and esttrs = 2;

        --ini 15.0
        if ln_surec > 0 then
          select estinsprd into ln_estinsprd from insprd where pid = r_det.pid;
        end if;
        --fin 15.0

        if l_cont = 0 then
          --ini 15.0
          if ln_surec = 0 or (ln_surec > 0 and ln_estinsprd <> 4) then
            --fin 15.0
            delete trssolot
             where codsolot = a_codsolot
               and punto = r_det.punto
               and (pid = r_det.pid or pid = r_det.pid_old)
               and esttrs = 1;

            r_trssolot.codinssrv := r_det.codinssrv;
            r_trssolot.codsolot  := r_det.codsolot;
            r_trssolot.tipo      := 1;
            r_trssolot.tiptrs    := l_tiptrs;
            r_trssolot.esttrs    := 1;
            r_trssolot.codsrvnue := r_det.codsrvnue;
            r_trssolot.bwnue     := r_det.bwnue;
            --r_trssolot.numslc := r_det.numslc;
            --r_trssolot.numpto := r_det.numpto;
            r_trssolot.punto        := r_det.punto;
            r_trssolot.pid          := r_det.pid;
            r_trssolot.pid_old      := null;
            r_trssolot.flgbil       := 0; -- Interfaz.
            r_trssolot.idplataforma := r_det.idplataforma; --<19.0>

            pq_solot.p_insert_trssolot(r_trssolot, l_codtrs);
            --ini 15.0
          end if;
          --ini 15.0
        end if;
      end loop;

    elsif A_OPCION = 4 then
      if a_codsolot is not null then
        select codcli, numslc, numpsp, idopc
          into l_codcli, l_numslc, l_numpsp, l_idopc
          from solot
         where codsolot = a_codsolot;
        if l_numpsp is null then
          -- se trata dej una sol manual
          p_crear_trssolot(3, a_codsolot, null, null, null, null);
        else
          p_crear_trssolot(0, a_codsolot, l_numslc, l_numpsp, l_idopc, null);
        end if;

      end if;

    end if;

  end;

  /**********************************************************************
  Realiza el cambio de estado de la SOT
  **********************************************************************/
  procedure p_chg_estado_solot(a_codsolot    number,
                               a_estsol      number,
                               a_estsol_old  number default null,
                               a_observacion varchar2 default null) is

    l_tipsvr          solot.tipsrv%type;
    l_tip             tipestsol.tipestsol%type;
    l_tip_old         tipestsol.tipestsol%type;
    l_est_old         estsol.estsol%type;
    l_estsol_act      estsol.estsol%type;
    l_fecactual       date;
    n_tipestsol       estsol.tipestsol%type;
    l_tipo            paquete_venta.tipo%type;
    l_numslc          vtatabslcfac.numslc%type;
    l_idwf            wf.idwf%type;
    p_mensaje         varchar(1000);
    p_error           number;
    l_contwf          number;
    l_codcli          solot.codcli%type;
    l_cont            number;
    ls_resultado      varchar2(4000);
    ls_mensaje        varchar2(4000);
    l_generado        estsol.estsol%type := 17;
    lc_numregistro    ope_srv_recarga_cab.numregistro%type;
    lc_codigo_recarga ope_srv_recarga_cab.codigo_recarga%type;
    ln_srv_dth        number(5);
    ln_iway           number;
    l_tipopedd        number;
    p_mensajerechazo  varchar2(100);
    ln_estsolrxs      number;
    l_tipopedd7       number;
    l_iw              number(5);
    --<Ini 41.0>
    l_msg             varchar2(4000);
    l_res_alinea      number;
    l_tipo_al         number;
    l_alinea_bscs_iw  number;
    --<Fin 41.0>
    -- Ini 42.0
    l_codigon  opedd.codigon%TYPE;
    l_codigoc  number;
    l_idsolucion sales.vtatabslcfac.idsolucion%TYPE;
    l_tiptra        solot.tiptra%TYPE;
	ln_val_rchz pls_integer;
	ln_val_anl pls_integer;
    -- Fin 42.0
  --Ini 43.0
    excep_adc EXCEPTION;
    PRAGMA EXCEPTION_INIT(excep_adc,-20099);
    --Fin 43.0
	V_VALOR NUMBER;
  P_ERR NUMBER;
  P_MESSAGE VARCHAR(200);
  begin
    begin
      select estsol, nvl(numslc, ''), codcli
        into l_estsol_act, l_numslc, l_codcli
        from solot
       where codsolot = a_codsolot;
    exception
      when others then
        l_numslc := '';
    end;

    begin
      select distinct e.tipo
        into l_tipo
        from vtatabslcfac b, vtadetptoenl c, paquete_venta e
       where b.numslc = l_numslc
         and b.numslc = c.numslc
         and c.idpaq = e.idpaq
         and e.estado = 1;
    exception
      when others then
        l_tipo := '';
    end;

    if l_estsol_act <> nvl(a_estsol_old, l_estsol_act) then
      raise_application_error(-20500,
                              'Error - El estado no coincide con el valor actual en la Base de Datos.');
    end if;

    select tipestsol into l_tip from estsol where estsol = a_estsol;

    select solot.tipsrv, estsol.estsol, estsol.tipestsol
      into l_tipsvr, l_est_old, l_tip_old
      from solot, estsol
     where solot.codsolot = a_codsolot
       and solot.estsol = estsol.estsol;

    l_fecactual := sysdate;

    select t2.codigon, t2.descripcion
      into ln_estsolrxs, p_mensajerechazo
      from tipopedd t1, opedd t2
     where t1.tipopedd = t2.tipopedd
       and t2.abreviacion = 'RECH_X_SIS'
       and t2.codigoc = 'ACTIVO'
       and t1.abrev = 'MANT_IWAY_HFC';

    select count(*)
      into l_tipopedd7
      from solot c, estsol e
     where e.estsol = c.estsol
       and e.tipestsol = 6
       and e.estsol <> ln_estsolrxs
       and c.codsolot = a_codsolot
       and c.tiptra in
           (select t2.codigon
              from tipopedd t1, opedd t2
             where t1.tipopedd = t2.tipopedd
               and t1.abrev = 'TIPTRA_ANULA_SOT_INST_HFC');

    select count(*)
      into l_tipopedd
      from solot c, estsol e
     where e.estsol = c.estsol
       and e.tipestsol = 7
       and c.codsolot = a_codsolot
       and c.tiptra in
           (select t2.codigon
              from tipopedd t1, opedd t2
             where t1.tipopedd = t2.tipopedd
               and t1.abrev = 'TIPTRA_ANULA_SOT_INST_HFC');

    --Verificamos si la SOT corresponde a una SOT de tipo Activación de DTH
    select count(1)
      into ln_srv_dth
      from solot a, vtatabslcfac b, tiptrabajo c
     where a.codsolot = a_codsolot
       and a.numslc = b.numslc
       and b.idsolucion in
           (select idsolucion
              from soluciones
             where idgrupocorte in
                   (select idgrupocorte from cxc_grupocorte where idgrupocorte = 15))
       and a.tiptra = c.tiptra
       and c.tiptrs = 1;

    if l_tip = 1 then
      p_suspender_solot(a_codsolot, a_estsol);
    elsif l_tip = 2 then
      p_aprobar_solot(a_codsolot, a_estsol);
    elsif l_tip = 3 then
      p_suspender_solot(a_codsolot, a_estsol);
    elsif l_tip = 4 then
      p_cerrar_solot(a_codsolot, a_estsol);
    elsif l_tip = 5 then
       --<INI 41.0>
       -- activa el proceso de anulacion de sot
       l_tipo_al := operacion.pq_anulacion_bscs.f_valida_anulacion;


       IF l_tipo_al = 1 THEN
         BEGIN
           operacion.pq_anulacion_bscs.p_val_tipo_serv_sot(a_codsolot,l_alinea_bscs_iw,l_res_alinea);
           IF l_alinea_bscs_iw <> 0 THEN
               operacion.pq_anulacion_bscs.p_execute_main(l_alinea_bscs_iw,
                                                          a_codsolot,
                                                          l_res_alinea,
                                                          l_msg);
               IF l_res_alinea = -1 THEN
                  ROLLBACK;
                  raise_application_error(-20001,l_msg);
               END IF;

           END IF;
         END;

       ELSE
          l_res_alinea:=1;
       END IF;
       -- INI 44.0
	   BEGIN
        SELECT NVL(op.codigoc, '0')
          INTO V_VALOR
          FROM opedd op
         WHERE op.abreviacion = 'ACT_CPLAN'
           AND op.tipopedd =
               (SELECT tipopedd
                  FROM operacion.tipopedd b
                 WHERE B.ABREV = 'CONF_WLLSIAC_CP');
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          V_VALOR := '0';
      END;

	  IF V_VALOR = 1 THEN
		   OPERACION.PKG_SIAC_CAMBIO_NUMERO.SIACSU_ROLLBACK_ESTADO(a_codsolot,ls_resultado,ls_mensaje);

		   IF ls_resultado <>0 THEN
			  raise_application_error(-20001,ls_mensaje);
		   END IF;
		   -- FIN 44.0
		   -- INI 45.0
		   OPERACION.PQ_SIAC_CAMBIO_PLAN_LTE.SGASU_ROLLBACK_CP(a_codsolot,ls_resultado,ls_mensaje);

		   IF ls_resultado <>0 THEN
			  raise_application_error(-20001,ls_mensaje);
		   END IF;
		   --FIN 45.0
	   END IF;

       if l_res_alinea=1 then
        -- Ini 42.0
        BEGIN
          select a.codigon, to_number(a.codigoc)  into l_codigon, l_codigoc
          from opedd a, tipopedd b
          where a.tipopedd = b.tipopedd
          and b.abrev = 'TIPTRABAJO' and a.abreviacion = 'SISACT_WLL';

          if l_numslc<>'' or l_numslc is not null then
            select idsolucion into l_idsolucion from sales.vtatabslcfac a
            where a.numslc = (select t.numslc
            from OPERACION.SOLOT t
            where t.codsolot = a_codsolot);
            IF l_tiptra =  l_codigon and l_codigoc = l_idsolucion THEN
               -- Validando estado si el estado actual es de rechazo
               select count(1)
                 into ln_val_rchz
                 from operacion.estsol e
                where e.tipestsol=7
                  and e.estsol=a_estsol_old; -- Rechazado
               -- Validando si el nuevo estado es de anulado
               select count(1)
                 into ln_val_anl
                 from operacion.estsol e
                where e.tipestsol=5
                  and e.estsol=a_estsol; -- Anulado
               if ln_val_rchz = ln_val_anl then
                 OPERACION.PQ_3PLAY_INALAMBRICO.P_ANULA_SOT_LTE(a_codsolot, ls_resultado);
               end if;
            END IF;
          end if;
        EXCEPTION
          WHEN others THEN
            raise_application_error(-20099, SQLERRM);
        END;
        -- Fin 42.0
           --Fin <41.0>
          --<Ini 43.0>
        BEGIN
          p_anular_solot(a_codsolot, a_estsol);
        EXCEPTION
        WHEN excep_adc THEN
          raise_application_error(-20099, SQLERRM);
        END;
        --<Fin 43.0>
          -- Customizacion Brasil
          if a_estsol = 13 then
            CUSBRA.P_GEN_SOLOT_CANC(a_codsolot);
          end if;

          if l_tipo = 4 or l_tipo = 1 then
            OPERACION.PQ_CUSPE_PLATAFORMA.P_PRE_ANULA_RI(a_codsolot,
                                                         ls_resultado,
                                                         ls_mensaje);

            if ls_resultado = 'ERROR' then
              raise_application_error(-20500, ls_mensaje);
            end if;

            insert into intraway.agendamiento_int
              (codsolot, codcli, est_envio, mensaje)
            values
              (a_codsolot, l_codcli, 2, 'Anulación de SOT');

            select count(1)
              into l_contwf
              from wf
             where valido = 1
               and codsolot = a_codsolot;

            if l_contwf > 0 then
              if f_valida_anulsothfc(a_codsolot) = 0 then --40.0 (Libera Numero siempre y cuando no este configurado el ID_Producto)
                if not sales.pq_portabilidad_validacion.liberar_numero(a_codsolot) then
                  select idwf
                    into l_idwf
                    from wf
                   where valido = 1
                     and codsolot = a_codsolot;
                  OPERACION.PQ_CUSPE_OPE.P_LIBERAR_NUMERORESERVADO(null,
                                                                   l_idwf,
                                                                   null,
                                                                   null);
                end if;
              end if; -- 40.0
            end if;
          end if;

          --Verificamos si la SOT Anulada corresponde a una SOT de tipo Activación de DTH
          if ln_srv_dth > 0 then
            lc_numregistro := pq_inalambrico.f_obtener_numregistro(a_codsolot);

            if lc_numregistro is not null then
              operacion.pq_dth.p_desactivacion_conax(a_codsolot, p_error, p_mensaje);
              if p_error = -1 then
                raise_application_error(-20500, p_mensaje);
              end if;

              update ope_srv_recarga_cab
                 set estado = '04'
               where numregistro = lc_numregistro;
            end if;
          end if;
          --<INI 41.0>
           IF l_tipo_al = 1 THEN
              operacion.pq_anulacion_bscs.p_valida_libera_numero(a_codsolot);
           END IF;
       end if;
      --<FIN 41.0>
      
      IF operacion.pq_sga_BSCS.f_get_is_cp_hfc(a_codsolot) > 0 THEN
             OPERACION.PQ_SIAC_CAMBIO_PLAN.UPDATE_INSSERV_CAMBIO_PLAN(a_codsolot, P_ERR, P_MESSAGE);
      END IF;
      
    elsif l_tip = 6 then
      select count(*)
        into ln_iway
        from int_mensaje_intraway a
       where a.id_cliente = l_codcli
         and a.codsolot = a_codsolot
         and a.proceso = 4
         and nvl(a.id_error, 0) = 0
         and a.id_interfaz in (select max(m.id_interfaz)
                                 from int_mensaje_intraway m
                                where m.id_cliente = a.id_cliente
                                  and m.codsolot = a.codsolot);

      l_idwf := F_GET_WF_SOLOT(a_codsolot, 1);

      if (l_tipsvr = '0061' or l_tipsvr = '0062') and l_idwf is null then
        if a_estsol <> 29 then
          insert into operacion.tmp_solot_codigo
            (codsolot, estado, usuario, fecharegistro, fechaejecucion, estsolot)
          values
            (a_codsolot, 3, user, sysdate, null, a_estsol);

          select tipestsol into n_tipestsol from estsol where estsol = l_est_old;

          if (n_tipestsol = 7) then
            p_ejecutar_solot(a_codsolot, a_estsol);
          end if;
        else
          update solot set estsol = a_estsol where codsolot = a_codsolot;
        end if;
      else
        p_ejecutar_solot(a_codsolot, a_estsol);
      end if;

      -- SOTs que de Rechazado pasan a En Ejecución
      if l_tipo = 4 or l_tipo = 1 then
        -- Seleccionar el Tipo de Estado Original
        select tipestsol into n_tipestsol from estsol where estsol = l_est_old;

        if n_tipestsol = 7 and a_estsol = 17 and l_est_old <> ln_estsolrxs then
          ---se agrego el estsol 22 para evitar pasar a ejecucion los rechazados por sistema
          insert into intraway.agendamiento_int
            (codsolot, codcli, est_envio, mensaje)
          values
            (a_codsolot, l_codcli, 2, 'De Rechazado a Ejecución');
        end if;
      end if;

      if l_tipsvr = '0061' and pq_janus_utl.exist_janus_rechazo(l_idwf) then
        pq_janus_ejecucion.execute_proceso(l_idwf);
      end if;

      if (l_tipopedd > 0 and ln_iway > 0) then
        l_idwf := F_GET_WF_SOLOT(a_codsolot, 1);
        select count(*)
          into l_tipopedd
          from intraway.agendamiento_int t
         where t.codsolot = a_codsolot
           and t.est_envio = 2;

        if l_tipopedd > 0 then
          update intraway.agendamiento_int t
             set t.est_envio = 4
           where t.codsolot = a_codsolot;
        end if;

        INTRAWAY.PQ_SOTS_AGENDADAS.P_REGISTRA_AGENDAMIENTO(null,
                                                           l_idwf,
                                                           null,
                                                           null);
        --Genera Reserva  IW
        OPERACION.PQ_CUSPE_OPE2.p_gen_reserva_iway(null, l_idwf, null, null);
      end if;

      --Verificamos si la SOT Puesta en Ejecución corresponde a una SOT de tipo Activación de DTH
      if ln_srv_dth > 0 then
        -- Seleccionar el Tipo de Estado Original
        select tipestsol into n_tipestsol from estsol where estsol = l_est_old;

        if n_tipestsol = 7 and a_estsol = 17 then
          lc_numregistro := pq_inalambrico.f_obtener_numregistro(a_codsolot);

          if lc_numregistro is not null then
            lc_codigo_recarga := pq_dth.f_genera_codigo_recarga(lc_numregistro,
                                                                9,
                                                                7);

            update ope_srv_recarga_cab
               set codigo_recarga = lc_codigo_recarga
             where numregistro = lc_numregistro;

          end if;
        end if;
      end if;
    elsif l_tip = 7 then
      if l_tipo = 4 or l_tipo = 1 then
        OPERACION.PQ_CUSPE_PLATAFORMA.P_PRE_ANULA_RI(a_codsolot,
                                                     ls_resultado,
                                                     ls_mensaje);

        if ls_resultado = 'ERROR' then
          raise_application_error(-20500, ls_mensaje);
        end if;

        insert into intraway.agendamiento_int
          (codsolot, codcli, est_envio, mensaje)
        values
          (a_codsolot, l_codcli, 2, 'Rechazo de SOT');
      end if;

      if a_estsol_old = l_generado and
         pq_janus_utl.es_tx_janus_ejecutada(a_codsolot) then

        l_idwf := F_GET_WF_SOLOT(a_codsolot, 1);
        pq_janus_rechazo.execute_proceso(l_idwf);
      end if;

      --Verificamos si la SOT Rechazada corresponde a una SOT de tipo Activación de DTH
      if ln_srv_dth > 0 then
        lc_numregistro := pq_inalambrico.f_obtener_numregistro(a_codsolot);

        if lc_numregistro is not null then
          update ope_srv_recarga_cab
             set codigo_recarga = null
           where numregistro = lc_numregistro;
        end if;
      end if;
      p_suspender_solot(a_codsolot, a_estsol);

      --tipestsol=7 (De rechazado a Rechazado por sistema como estado default)
      insert into solotchgest
        (codsolot, tipo, estado, fecha, observacion)
      values
        (a_codsolot, 1, a_estsol, l_fecactual, a_observacion);

      if l_tipopedd7 > 0 then
        begin
          select count(*)
            into l_iw
            from int_servicio_intraway
           where codsolot = a_codsolot;

          if l_iw > 0 then
            update solot set estsol = ln_estsolrxs where codsolot = a_codsolot;

            insert into solotchgest
              (codsolot, tipo, estado, fecha, observacion)
            values
              (a_codsolot, 1, ln_estsolrxs, l_fecactual, p_mensajerechazo);

            --intraway.p_int_baja_total(a_codsolot, 0, p_mensaje, p_error);
            --OPERACION.PQ_CUSPE_OPE2.p_int_iw_solot_anuladas(a_codsolot);
          end if;
        exception
          when others then
            raise_application_error(-20500, sqlerrm || '-' || p_mensaje);
        end;
      end if;
    else
      update solot set estsol = a_estsol where codsolot = a_codsolot;
    end if;

    --Se graba el cambio de estado de una solot. Ingresado por VVS el 01/08/2004.
    if l_tip <> 7 then
      insert into SOLOTCHGEST
        (codsolot, tipo, estado, fecha, observacion)
      values
        (a_codsolot, 1, a_estsol, l_fecactual, a_observacion);
    end if;

    begin
      select idwf
        into l_idwf
        from wf
       where codsolot = a_codsolot
         and valido = 1;
      if l_idwf is not null then
        select count(1)
          into l_cont
          from tareawfcpy, tareawf
         where tareawfcpy.idtareawf = tareawf.idtareawf(+)
           and tareawfcpy.idwf = l_idwf
           and nvl(tareawf.tipesttar, 1) in (1, 2, 3, 5); --se considera: Generada ,En ejecucion, Suspendida y Cancelada
      end if;
    exception
      when others then
        l_cont := null;
    end;

    if l_cont = 0 then
      pq_solot.p_cerrar_solot(a_codsolot);
    end if;

    pq_incidence_solot.p_cambia_incidencia_solot(a_codsolot, a_estsol);

  exception
    when no_data_found then
      raise_application_error(-20500, sqlerrm);
    when others then
      raise;
  end;
--ini 34.0
procedure p_chg_estado_rxs (
    a_codsolot in number,
    a_estsol in number,
    a_estsol_old in number default null
) is
begin
  update operacion.solot
     set estsol = a_estsol
   where codsolot = a_codsolot;

exception
   when no_data_found then
      raise_application_error(-20500, sqlerrm);
   when others then
     raise;

end;
--fin 34.0
/**********************************************************************
Aprueba la SOT
1. Si se trabaja con WF => se intenta seleccionar un WF automaticamente
2. Si ya existia el flujo se activa
**********************************************************************/
procedure p_aprobar_solot (
    a_codsolot in number,
      a_estado in number
) is

l_wfdef wfdef.wfdef%type;
l_flg number(1);
l_auto number(1);
l_scfg varchar2(5);
l_numslc char(10);
ls_tipsrv char(4);
l_cambiar boolean := false;
l_cont number(1);
l_cont_wfdef number;
begin

      select PQ_CONSTANTES.F_GET_CFG_WF into l_flg from dummy_ope;
   -- Se selecciona el workflow automaticamente
   if l_flg = 1 then

 --Validacion para aprobar SOTs Manuales
      /**/
      if f_restringir_aprobacion(a_codsolot) = 0 then
          raise_application_error(-20500, 'Linea Control no se puede asignar este tipo de trabajo.');
      end if;


      select PQ_CONSTANTES.F_GET_CFG_SOLOT_AUTO_EXE into l_auto from dummy_ope;

      if l_auto = 1 then
         l_wfdef := CUSBRA.F_BR_SEL_WF(a_codsolot);
         --<11.0>
         if l_wfdef is not null then
            --Para determinar cuales son los WFs con asignacion automatica
            select count(1) into l_cont_wfdef from opedd where tipopedd = 260 and codigon =l_wfdef ;
             if l_cont_wfdef>0 then
               --asignar automaticamente el wf
               insert into operacion.tmp_solot_codigo (codsolot, estado, usuario, fecharegistro, fechaejecucion)
               values (a_codsolot, 4, user, sysdate, null);
               p_ejecutar_solot(a_codsolot,17 );
               insert into SOLOTCHGEST (codsolot,tipo, estado, fecha, observacion)
               values (a_codsolot,1,17,sysdate,'Asignación de workflow automática');
               l_cambiar :=false;
             else
               /*Insertamos en la tabla temporal de Codigos de SOT con el estado en 3 cuando se ejecute con el JOB pasara al estado 4             */
               insert into operacion.tmp_solot_codigo (codsolot, estado, usuario, fecharegistro, fechaejecucion)
               values (a_codsolot, 3, user, sysdate, null);
               l_cambiar :=true;
             end if;

             select decode(numslc,null,0,1) into l_cont from solot where codsolot = a_codsolot;
             if l_cont = 0 then
                 select tipsrv into ls_tipsrv from solot where codsolot=a_codsolot;
              else
                 /********Se realiza la captura de datos para la generacion de las PEP2 en forma automatica atraves de la asignacion
                 automatica del workflow ****************/
                 select pq_constantes.f_get_cfg into l_scfg from dummy_ope;
                 select numslc into l_numslc from solot where codsolot = a_codsolot;
                 OPERACION.P_SAP_LLENA_TMP_SAPSGA_PEP2(l_numslc,a_codsolot,l_scfg);
                 select tipsrv into ls_tipsrv  from vtatabslcfac where numslc=l_numslc;
              end if;

              /*Ya no ejecutamos el Ejecutar _Solot dado que esto sera realizado en Batch usando un JOB*/
            --p_ejecutar_solot( a_codsolot );
         else
            l_cambiar := true;
         end if;
         --<\11.0>

      end if;
   else
      l_cambiar := true;
   end if;

   if l_cambiar then
      -- se hace el update al registro
      update solot
      --Ini 20.0
      /*set estsol = a_estado*/
      set estsol = nvl(a_estado, c_estsol_aprobado )
      --Fin 20.0
        where codsolot = a_codsolot;
   end if;

end;

/**********************************************************************
Ejecutar la SOT
1. Si se trabaja con WF => se intenta seleccionar un WF automaticamente
2. Si ya existia el flujo se activa
**********************************************************************/
procedure p_ejecutar_solot (
    a_codsolot in number,
      a_estado in number default null
) is

l_idwf wf.idwf%type;
l_wfdef wfdef.wfdef%type;
l_flg number(1);
l_tiptra number(4);
l_plazo      number(4);
l_validalima varchar2(100);
l_estsol_old solot.estsol%type; --6.0

begin

   select PQ_CONSTANTES.F_GET_CFG_WF into l_flg from dummy_ope;
   -- Se selecciona el workflow automaticamente
   if l_flg = 1 then

     select tiptra into l_tiptra from solot where codsolot = a_codsolot;

     --<2.0
     begin

        SELECT decode(count(1), 0, 'PROVINCIA', 'LIMA')
          into l_validalima
          FROM SOLOTPTO S, V_UBICACIONES V -- Lima - Provincias
         WHERE S.CODUBI = V.codubi
           AND V.codest = 1
           and codpvc in (1)
           AND V.CODPAI = 51
           AND S.CODSOLOT = a_codsolot;

        select to_number(d.codigon)
          into l_plazo
          from opedd d
         where d.codigoc = l_tiptra
           and d.tipopedd = 212
           and decode(d.abreviacion, null, 'LIMA/PROVINCIA', d.abreviacion) =
               decode(d.abreviacion, null, 'LIMA/PROVINCIA', l_validalima);
      EXCEPTION
        WHEN OTHERS THEN
          l_plazo := null;
      END;
      if l_plazo is not null then
        update solot
           set feccom = sysdate + l_plazo
         where codsolot = a_codsolot
         and feccom is null;--<4.0>
      end if;
      --2.0>

   -- si el tipo de SOT es INSTALACIONDE PAQUTES TPI la fecha de compromiso de la SOT será
   -- la fecha de asignación de WF más 7 días calendario. Req. 57860 - Gustavo Ormeño
   /*select tiptra into l_tiptra from solot where codsolot = a_codsolot;
   if l_tiptra in (392, 393, 394, 402, 450, 369, 391, 389, 390, 368)  then
      update solot set feccom = sysdate + 7 where codsolot = a_codsolot;
   end if;*/

      l_idwf := F_GET_WF_SOLOT(a_codsolot,1);
      if l_idwf is not null then
         PQ_WF.P_REACTIVAR_WF(l_idwf);
      else
         l_wfdef := CUSBRA.F_BR_SEL_WF(a_codsolot);
         if l_wfdef is not null then
             PQ_WF.P_CREAR_WF( l_wfdef, l_idwf  );
            PQ_WF.P_SET_PARAM(l_idwf ,'CODSOLOT', a_codsolot );
            PQ_WF.P_ACTIVAR_WF( l_idwf );
            p_chg_estado_solot ( a_codsolot, 17 );--6.0
         end if;
      end if;

   end if;

---REQ 68710
   select  estsol into l_estsol_old from solot where codsolot = a_codsolot;--<6.0>
   -- se hace el update al registro
   --if l_tiptra <> 406 and l_idwf is not null then--<6.0>
   if l_tiptra <> 406 and l_idwf is not null and l_estsol_old not  in (29,12) then--<6.0>
      update solot set
      --Ini 20.0
      --Al hacer la Correccion de concepto de Anulacion en SGA en PQ_INT_VTAUNI, se encuentra optimo utilizar las constantes no en duro
      estsol = nvl(a_estado, c_estsol_ejecucion ),
    /*  estsol = a_estado,*/
      --Fin 20.0
      fecini = nvl(fecini,sysdate)
      where codsolot = a_codsolot;
   end if;

-- Fin REQ 68710

end;

/**********************************************************************
Anular la SOT
1. Si se trabaja con WF => se intenta anula el WF
**********************************************************************/
procedure p_anular_solot (
    a_codsolot in number,
      a_estado in number
) is

l_idwf wf.idwf%type;
l_wfdef wfdef.wfdef%type;
l_flg number(1);
--Ini 43.0
ln_iderror      NUMBER;
lv_mensajeerror VARCHAR2(3000);
ln_codsolot     operacion.agendamiento.codsolot%TYPE;
ln_flag_aplica  NUMBER;
--Fin 43.0
begin

   select PQ_CONSTANTES.F_GET_CFG_WF into l_flg from dummy_ope;
   -- Se selecciona el workflow automaticamente
   if l_flg = 1 then

      l_idwf := F_GET_WF_SOLOT(a_codsolot,1);
      if l_idwf is not null then
         PQ_WF.P_CANCELAR_WF(l_idwf);
      end if;

   end if;

   -- se hace el update al registro
   update solot set estsol = a_estado
     where codsolot = a_codsolot;

    --Ini 43.0
    operacion.pq_adm_cuadrilla.p_cancela_orden(a_codsolot,
                                               a_estado,
                                               ln_iderror,
                                               lv_mensajeerror);
    IF ln_iderror <> 1 THEN
       IF ln_iderror = -99 THEN
          RAISE_APPLICATION_ERROR(-20099,'ERROR-WS: '||lv_mensajeerror);
       ELSE
          RAISE_APPLICATION_ERROR(-20001,lv_mensajeerror);
       END IF;
    END IF;
    --Fin 43.0
end;

/**********************************************************************
Suspender la SOT
1. Si se trabaja con WF => se suspende el WF
**********************************************************************/
procedure p_suspender_solot (
    a_codsolot in number,
      a_estado in number
) is

l_idwf wf.idwf%type;
l_wfdef wfdef.wfdef%type;
l_flg number(1);

begin

   select PQ_CONSTANTES.F_GET_CFG_WF into l_flg from dummy_ope;
   -- Se selecciona el workflow automaticamente
   if l_flg = 1 then

      l_idwf := F_GET_WF_SOLOT(a_codsolot,1);
      --14.0
      if l_idwf is not null then
      /*if (l_idwf is not null and a_estado = 15) then --luis olarte
         PQ_WF.P_CANCELAR_WF(l_idwf);
      elsif l_idwf is not null then*/
      --14.0
         PQ_WF.P_SUSPENDER_WF(l_idwf);
      end if;

   end if;

   -- se hace el update al registro
   update solot set estsol = a_estado
     where codsolot = a_codsolot;

end;

/**********************************************************************
Cerrar la SOT
1. Si se cierra la SOT
**********************************************************************/
procedure p_cerrar_solot (
    a_codsolot in number,
      a_estado in number
) is


begin

   -- se hace el update al registro
   update solot
   --Ini 20.0
   --Al hacer la Correccion de concepto de Anulacion en SGA en PQ_INT_VTAUNI, se encuentra optimo utilizar las constantes no en duro
    set estsol = nvl(a_estado, c_estsol_cerrado ),
   /* set estsol = a_estado,*/
   --Fin 20.0
         fecfin = sysdate
     where codsolot = a_codsolot;

end;


/**********************************************************************
Clonar la SOT
1. Si se clona la SOT
**********************************************************************/
procedure p_clonar_solot (
       a_original_codsolot in number,
     a_clon_codsolot out number
) is
r_solot solot%rowtype;
r_det solotpto%rowtype;
l_punto number;

cursor cur_det is
select codsolot, punto from solotpto
   where codsolot = a_original_codsolot;

begin

  select * into r_solot
      from solot
      where solot.CODSOLOT=a_original_codsolot;

  r_solot.CODSOLOT := null;
   p_insert_solot(r_solot, a_clon_codsolot);

   for r in cur_det loop
      select * into r_det from solotpto where codsolot = r.codsolot and punto = r.punto;
      r_det.punto := null;
      r_det.codsolot := a_clon_codsolot ;
      p_insert_solotpto(r_det, l_punto);
   end loop;

--EXCEPTION
--     WHEN NO_DATA_FOUND THEN
--      raise_application_error(-20500, 'No existe la solicitud ' || a_original_codsolot);

end;

/******************************************************************************
Ejecuta una transaccion TRSSOLOT
Afecta las instancias de Producto afectadas
******************************************************************************/
procedure p_exe_trssolot (
   a_codtrs in number,
   a_esttrs in number,
   a_fectrs in date
)
IS


l_codmotinssrv number;
r_trssolot trssolot%rowtype;
--ini 35.0
ln_cont_tit number;
ln_codsolot trssolot.codsolot%type;
ld_feccorte trssolot.fectrs%type;
--fin 35.0
ln_codinssrv     NUMBER; --36.0
ln_codinssrv_tra NUMBER; --36.0

begin

   -- ejecutar
   if a_esttrs = 2 then
      -- ini 35.0
      Begin
        select codsolot
          into ln_codsolot
          from trssolot
         where codtrs = a_codtrs;

        select count(*)
          into ln_cont_tit
          from regvtamentab a,
               regdetsrvmen b
         where a.numregistro = b.numregistro
           and a.numslc = ( select numslc from solot where codsolot = ln_codsolot )
           and b.flg_tipo_vm = 'TIT';

        if ln_cont_tit > 0 then
          select distinct trunc(a.feccorte)
            into ld_feccorte
            from regvtamentab a,
                 regdetsrvmen b
           where a.numregistro = b.numregistro
             and a.numslc = ( select numslc from solot where codsolot = ln_codsolot )
             and b.flg_tipo_vm = 'TIT';

           -- Actualizamos la Fecha de Inicio de Facturacion/ Fecha de Cierre de Facturacion
           update trssolot
              set fecinifac = ld_feccorte
            where codtrs    = a_codtrs;

        end if;
      exception
        when others then
          ln_cont_tit := 0;
      end;
      -- fin 35.0

      update trssolot set
         esttrs = a_esttrs,
         fectrs = a_fectrs
         where codtrs = a_codtrs;

      select * into r_trssolot from trssolot where codtrs = a_codtrs;

    select codmotinssrv into l_codmotinssrv
       from tiptrabajo, solot
       where tiptrabajo.tiptra = solot.tiptra and
            codsolot = r_trssolot.codsolot;

      if r_trssolot.tiptrs = 1 then -- activacion
         -- ini 35.0
         if ln_cont_tit > 0  then
           update insprd
              set estinsprd = 1,
                  fecini = ld_feccorte
            where pid    = r_trssolot.pid;
         else
           -- fin 35.0
         update insprd set
            estinsprd = 1,
            fecini = a_fectrs
         where pid = r_trssolot.pid;
         end if;  -- 35.0
         pq_inssrv.p_valida_est_inssrv(r_trssolot.codinssrv,l_codmotinssrv);
      elsif r_trssolot.tiptrs = 2 then --upgrade
         raise_application_error(-20500, 'PQ_SOLOT.p_exe_trssolot tiptrs '||r_trssolot.tiptrs ||' invalida. codtrs = '||a_codtrs);
      elsif r_trssolot.tiptrs = 3 then -- suspension
         update insprd set
            estinsprd = 2
         where pid = r_trssolot.pid;
         pq_inssrv.p_valida_est_inssrv(r_trssolot.codinssrv,l_codmotinssrv);
      elsif r_trssolot.tiptrs = 4 then -- reconexion
         update insprd set
            estinsprd = 1
         where pid = r_trssolot.pid;
         pq_inssrv.p_valida_est_inssrv(r_trssolot.codinssrv,l_codmotinssrv);
      elsif r_trssolot.tiptrs = 5 then -- cancelacion
        -- ini 35.0
        if ln_cont_tit > 0 then
         update insprd
            set estinsprd = 3,
                fecfin    = ld_feccorte
          where pid       = r_trssolot.pid;
        else
         -- fin 35.0
         update insprd set
            estinsprd = 3,
            fecfin = a_fectrs
         where pid = r_trssolot.pid;
        end if; -- 35.0
        --ini 36.0
        BEGIN
          SELECT MIN(p.codinssrv_tra)
            INTO ln_codinssrv_tra
            FROM trssolot t, solotpto p
           WHERE t.codsolot = p.codsolot
             AND t.codinssrv = p.codinssrv
             AND nvl(p.codinssrv_tra, 0) > 0
             AND t.codsolot = r_trssolot.codsolot
             AND t.codtrs = r_trssolot.codtrs
             AND t.codinssrv = r_trssolot.codinssrv;
          IF nvl(ln_codinssrv_tra, 0) > 0 THEN
            ln_codinssrv := ln_codinssrv_tra;
          ELSE
            ln_codinssrv := r_trssolot.codinssrv;
          END IF;
        EXCEPTION
          WHEN no_data_found THEN
            ln_codinssrv := r_trssolot.codinssrv;
        END;
        --fin 36.0
        pq_inssrv.p_valida_est_inssrv(ln_codinssrv,l_codmotinssrv); --36.0
      elsif r_trssolot.tiptrs = 7 then -- suspension por límite de crédito
         update insprd set
            estinsprd = 2
         where pid = r_trssolot.pid;
         pq_inssrv.p_valida_est_inssrv(r_trssolot.codinssrv,l_codmotinssrv);
      elsif r_trssolot.tiptrs = 8 then -- reconexion por límite de crédito
         update insprd set
            estinsprd = 1
         where pid = r_trssolot.pid;
         pq_inssrv.p_valida_est_inssrv(r_trssolot.codinssrv,l_codmotinssrv);
      --<11.0>
      elsif r_trssolot.tiptrs = 9 then -- Transacción no facturable
         update insprd set
                estinsprd = 1,
                fecini = a_fectrs
         where pid = r_trssolot.pid;
         pq_inssrv.p_valida_est_inssrv(r_trssolot.codinssrv,l_codmotinssrv);
      --</11.0>
      elsif r_trssolot.tiptrs = 6 then --upgrade
         raise_application_error(-20500, 'PQ_SOLOT.p_exe_trssolot tiptrs '||r_trssolot.tiptrs ||' invalida. codtrs = '||a_codtrs);
      else
         raise_application_error(-20500, 'PQ_SOLOT.p_exe_trssolot tiptrs '||r_trssolot.tiptrs ||' invalida. codtrs = '||a_codtrs);
      end if;

   -- Rollback ??
   elsif a_esttrs = 1 then
      null;
   -- anular
   elsif a_esttrs = 3 then
      update trssolot set esttrs = a_esttrs
         where codtrs = a_codtrs;
   end if;

end;

/******************************************************************************
Valida si un solotpto puede ser insertado o ya se ingreso un item
con el mismo tipo y codigo
******************************************************************************/
FUNCTION f_val_solotpto (
   a_codsolot in number,
   a_punto in number,
   a_tipo in number,
   a_codigo in number
) return number is

tmp number(10);

begin
   if a_tipo = 2 then
      select count(1) into tmp from solotpto where codsolot = a_codsolot and
      tipo = a_tipo and codinssrv = a_codigo and punto <> nvl(a_punto, punto);
   elsif a_tipo = 3 then
      select count(1) into tmp from solotpto where codsolot = a_codsolot and
      tipo = a_tipo and cid = a_codigo  and punto <> nvl(a_punto, punto);
   elsif a_tipo = 4 then
      tmp := 0;
   elsif a_tipo = 5 then
      select count(1) into tmp from solotpto where codsolot = a_codsolot and
      tipo = a_tipo and pop = a_codigo  and punto <> nvl(a_punto, punto);
   elsif a_tipo = 6 then
      select count(1) into tmp from solotpto where codsolot = a_codsolot and
      tipo = a_tipo and pid = a_codigo  and punto <> nvl(a_punto, punto);
   else
      tmp := 0;
   end if;

   if tmp = 0 then
      return 1;
   else
      return 0;
   end if;
end;

/**********************************************************************
Aisgna un workflow a una SOT
Crea
Setea el parametro
Activa el WF
**********************************************************************/
procedure p_asig_wf (
    a_codsolot in number,
      a_wfdef in number
)
is

l_idwf wf.idwf%type;


begin
   if a_wfdef is not null and a_codsolot is not null then
      PQ_WF.P_CREAR_WF( a_wfdef, l_idwf  );
      PQ_WF.P_SET_PARAM(l_idwf ,'CODSOLOT', a_codsolot );
      -- ini 26.0
      P_CHG_ESTADO_SOLOT ( a_codsolot, 17 ); -- proc. agregado
      -- fin 26.0
      PQ_WF.P_ACTIVAR_WF( l_idwf );
      -- p_ejecutar_solot( a_codsolot );
      -- p_chg_estado_solot ( a_codsolot, 17 ); -- CAMBIAR POR ESTA LINEA 24.0  proc. comentado
   else
      raise_application_error(-20500, 'PQ_SOLOT.p_asig_wf parametros nulos');
   end if;
end;

function f_permiso_solot (
   a_codsolot in number,
   a_usuario in varchar2
) return number
/******************************************************************************
Determina si el usuario puede modificar esta solicitud
Devuelve 0 No puede
Devuelve 1 Puede modificar
Devuelve 2 Puede cambiar el estado
******************************************************************************/
is

tmpvar number;

l_cont number;
l_estsol number;
l_areasol number;
l_tipestsol number;

begin

   -- Valida el estado de la Solicitud
   select s.estsol, s.areasol, e.tipestsol into l_estsol, l_areasol, l_tipestsol
      from solot s, estsol e
      where s.codsolot = a_codsolot and
      s.estsol = e.estsol;

   if l_tipestsol in ( 4, 5 ) then -- Anul, Cerr
      return 0;
   end if;

   -- Si puede cambiar estado
   select count(1) into l_cont from accusudpt
      where accusudpt.codusu = rtrim(a_usuario) and area = l_areasol and
       accusudpt.tipo = 2  and aprob = 1 ;
   if l_cont > 0 then
      return 2;
   end if;

   -- Si puede modificar la sol.
   select count(1) into l_cont from accusudpt
      where accusudpt.codusu = rtrim(a_usuario) and area = l_areasol and
       accusudpt.tipo = 2  and acceso = 1 ;
   if l_cont > 0 then
      return 1;
   end if;

  return 0;

   EXCEPTION
     WHEN OTHERS THEN
     RETURN 0;

END;


/******************************************************************************
Determina si el usuario puede modificar los datos de cabecera de la Solicitud
Devuelve 0 No puede
Devuelve 1 Puede modificar
******************************************************************************/
function f_permiso_solot_cab (
   a_codsolot in number,
   a_usuario in varchar2
) return number
IS

l_estsol number;
l_tipestsol number;

BEGIN
/*
1  Generada
2  Aprobada
3  Suspendida
4  Cerrada
5  Anulada
*/
   select s.estsol, e.tipestsol into l_estsol, l_tipestsol from solot s, estsol e
   where s.codsolot = a_codsolot and
   s.estsol = e.estsol;

   if l_tipestsol in (1) then
      return 1;
   else
      return 0;
   end if;

   EXCEPTION
     WHEN OTHERS THEN
     RETURN 0;

END;


function f_permiso_solot_adm (
   a_codsolot in number,
   a_usuario in varchar2
) return number
/******************************************************************************
Determina si el usuario tiene permiso para acceder a las opciones de
Administracion
Devuelve 0 No
Devuelve >0 Nivel Administracion
******************************************************************************/
is
l_cont number;
l_areasol number;
begin

   if f_permiso_solot(a_codsolot, a_usuario) > 0 then

       select s.areasol into l_areasol
          from solot s
          where s.codsolot = a_codsolot;
       -- Si tiene opcion de Adm
       begin
          select opcion into l_cont from accusudpt
          where accusudpt.codusu = rtrim(a_usuario) and area = l_areasol and
           accusudpt.tipo = 2  and opcion <> 0 and rownum = 1 ;
          return l_cont;
       exception
         when others then
            return 0;
       end;
   else
      return 0;
   end if;

END;

procedure p_reiniciar_wf (
    a_codsolot in number
)
is

l_idwf wf.idwf%type;
l_wfdef wfdef.wfdef%type;

begin
   l_idwf := F_GET_WF_SOLOT(a_codsolot,0);
   if l_idwf is null then
      raise_application_error(-20500, 'No existe un workflow asignado, No se puede reiniciar.');
   else
      pq_wf.p_cancelar_wf(l_idwf);
      select wfdef into l_wfdef from wf where idwf = l_idwf;
      p_asig_wf(a_codsolot,l_wfdef);
      p_chg_estado_solot(a_codsolot, c_estsol_ejecucion );
   end if;

end;

procedure p_activar_solot(
   a_codsolot solot.codsolot%type,
   a_fecha date
) is
/**********************************************************************
Activa las transacciones de la SOT
Actualiza solotpto.fecinisrv
Actualiza y ejecuta TRSSOLOT
**********************************************************************/

cursor cur_trs is
   select codtrs from trssolot
      where codsolot = a_codsolot
      and esttrs = 1;

begin

   if a_fecha is null then
      raise_application_error(-20500, 'Fecha no puede ser NULL. P_BR_ACTSRV_SOLOT.');
   else

      pq_solot.p_crear_trssolot ( 4, a_codsolot, null, null, null, null) ;

      update solotpto set fecinisrv = a_fecha
      where codsolot = a_codsolot;

      for c in cur_trs loop
         pq_solot.p_exe_trssolot ( c.codtrs , 2, a_fecha );
      end loop;

   end if;

end;


procedure p_devolver_solot (
       a_original_codsolot in number,
     a_clon_codsolot out number
) is
/**********************************************************************
Devolver la SOT, reinicar el flujo
1. Clona la SOT
2. Reinicia el flujo de la nueva SOT
3. Si se devuelve la SOT
**********************************************************************/
l_wfdef wfdef.WFDEF%type;
l_idwf wf.IDWF%type;
l_estado number;
begin

   select estsol into l_estado
   from solot
   where codsolot = a_original_codsolot;

   --solo se puede devolver la solicitud si se encuentra en estado Em Devoluc?o/Correc?o(21)
    if l_estado=21 then

     l_idwf := F_GET_WF_SOLOT(a_original_codsolot,0);

     if l_idwf is null then
        raise_application_error(-20500, 'No existe un workflow asignado, No se puede devolver la Solicitud ' || a_original_codsolot);
     else
       pq_wf.p_cancelar_wf(l_idwf);
       select wfdef into l_wfdef from wf where idwf = l_idwf;
       p_clonar_solot(a_original_codsolot,a_clon_codsolot);


         --se clona el usuario y el area que origino la solicitud
        update solot
           set
            fecini = fecusu,
            observacion = 'SOT generada por devolucion de SOT '||trim(to_char(a_original_codsolot))||chr(13)||observacion
        where solot.CODSOLOT = a_clon_codsolot;

       p_asig_wf(a_clon_codsolot,l_wfdef);
       p_chg_estado_solot(a_clon_codsolot, c_estsol_ejecucion);
       p_chg_estado_solot(a_original_codsolot, c_estsol_devuelta);

     end if;

   else
     raise_application_error(-20500, 'Estado actual de la solicitud no permite devolverla.');
   end if;

end;

procedure p_devolver_cancelar_solot (
   a_codsolot solot.codsolot%type
) is
/**********************************************************************
Devolver la SOT cancelando servicios
1. Si se devuelve la SOT
2. Se cancelan las IS y IP sin activar generadas por este proyecto.
**********************************************************************/
l_wfdef wfdef.WFDEF%type;
l_idwf wf.IDWF%type;
l_estado number;
l_numpsp solot.numpsp%type;
cursor cur_pto is
   select numslc, punto, codinssrv, pid
       from solot,
       solotpto
     where solot.codsolot = solotpto.codsolot and
          numslc is not null and
         pid is not null and
         codinssrv is not null and
          solot.codsolot = a_codsolot;

begin

   select estsol, numpsp into l_estado, l_numpsp
   from solot
   where codsolot = a_codsolot;

    if l_numpsp is null then
       raise_application_error(-20500, 'No se puede devolver-cancelar una solicitud que no esta asociada a una Oferta Comercial. No se puede devolver la Solicitud ' || a_codsolot);
    end if;
   --solo se puede devolver la solicitud si se encuentra en estado Em Devoluc?o/Correc?o(21)
    if l_estado=21 then

     l_idwf := F_GET_WF_SOLOT(a_codsolot,0);

     if l_idwf is null then
        raise_application_error(-20500, 'No existe un workflow asignado, No se puede devolver la Solicitud ' || a_codsolot);
     else
       pq_wf.p_cancelar_wf(l_idwf);
       for lc1 in cur_pto loop
       -- Se cancela las instancias de servicio
           update inssrv
          set estinssrv = 3
        where codinssrv = lc1.codinssrv and
            numslc = lc1.numslc and
            estinssrv = 4;
       -- Se cancela las instancias de producto
           update insprd
          set estinsprd = 3
        where pid = lc1.pid and
            numslc = lc1.numslc and
            estinsprd = 4;
       -- Se eliminan las transacciones
           delete trssolot
          where codsolot = a_codsolot and
            esttrs <> 2;
       end loop;

       p_chg_estado_solot(a_codsolot, c_estsol_devuelta);

     end if;

   else
     raise_application_error(-20500, 'Estado actual de la solicitud no permite devolverla.');
   end if;
end;

/******************************************************************************
Determina si la sot puede ser aprobada
Devuelve 0 No puede aprobar
Devuelve 1 Puede aprobar
******************************************************************************/
function  f_restringir_aprobacion (
   a_codsolot in number
) return number
IS

l_count number;
l_tiptra number;
v_tipsrv tystabsrv.tipsrv%type;
cursor c_valida is
select codigoc,codigon,abreviacion from opedd where tipopedd = 213;

cursor c_sot is
select tipsrv, flag_lc from solotpto, tystabsrv
where codsolot = a_codsolot and solotpto.codsrvnue = tystabsrv.codsrv;

BEGIN
   select tiptra into l_tiptra from solot where codsolot = a_codsolot;
   for r_sot in c_sot loop  --Puntos
      for r_val in c_valida loop --Restricciones
        if l_tiptra = r_val.codigon and r_sot.tipsrv = r_val.codigoc and  r_sot.flag_lc = r_val.abreviacion  then
           return 0;
        end if;
      end loop;
   end loop;
   return 1;


END;

procedure p_valida_trssolot (
   a_codtrs in number,
   a_esttrs in number
)
IS
r_trssolot trssolot%rowtype;
r_inssrv inssrv%rowtype;
l_codinssrv inssrv.codinssrv%type;
l_valida number;
l_codcli vtatabcli.codcli%type;
l_numero inssrv.numero%type;
ls_texto varchar2(1200);
l_numslc vtatabslcfac.numslc%type;
l_validanumero number;
cursor c_inst_serv is
        select *
          from instanciaservicio
         where nomabr = l_numero
           and codcli <> l_codcli
           and fecini is not null
           and fecfin is null;




begin
  -- ejecutar
   if a_esttrs = 2 then
      select * into r_trssolot from trssolot where codtrs = a_codtrs;

      if r_trssolot.tiptrs = 1 then -- activacion
      select * into r_inssrv from inssrv where codinssrv =r_trssolot.codinssrv;

      --Valida que sea numero telefonico
      select count(1)
        into l_validanumero
        from numtel
       where numero = r_inssrv.numero;

      if l_validanumero >0 then
      --Valida que el servicio el numero no este activo para otro cliente
      begin
        select count(1)
          into l_valida
          from instanciaservicio
         where nomabr = r_inssrv.numero
           and codcli <> r_inssrv.codcli
           and fecini is not null
           and fecfin is null;
      exception
      when others then
       l_valida:=0;
      end;

        if l_valida > 0 then
           l_codcli:=r_inssrv.codcli;
           l_numero:=r_inssrv.numero;
            begin
             select numslc
               into l_numslc
               from inssrv
              where numero = l_numero
                and codcli <> l_codcli
                and estinssrv = 1;
            exception
            when others then
             l_numslc:=null;
            end;

           for r_ins in c_inst_serv loop
              ls_texto:= 'Código Cliente: '|| r_ins.codcli ||' .Número telefónico: '||r_ins.nomabr ||' .Proyecto de Instalación: '|| l_numslc||chr(13);
           end loop;
             raise_application_error(-20500, 'Se debe dar de baja el servicio activo que tiene el mismo número telefónico: '|| chr(13)||ls_texto);
        end if;
       end if;
      end if;
   end if;
end; --8.0

/**********************************************************************
Procedure que crea solot, se llama desde SGA Operaciones
**********************************************************************/
procedure p_insert_solot_aut(
   a_tiptra solot.tiptra%type,
   a_motot solot.codmotot%type,
   a_feccom solot.feccom%type,
   a_obs solot.observacion%type,
   a_codinssrv inssrv.codinssrv%type,
   a_codsolot out solot.codsolot%type,
   a_mensaje out varchar2
) is

lr_inssrv inssrv%rowtype;
lr_solot solot%rowtype;
ln_codsolot solot.codsolot%type;
lr_solotpto solotpto%rowtype;
ln_punto solotpto.punto%type;
lc_area solot.areasol%type;
ls_tipsrv constante.valor%type;
ls_descestado estsol.descripcion%type;
ls_desctiptra tiptrabajo.descripcion%type;
ld_fecusu solot.fecusu%type;
ln_num number;
ln_tiptrs tiptrabajo.tiptrs%type;
--ln_numpid number(3);
--error_pid exception;
error_validacion exception;

/*cursor cur_pid is
  select * from insprd
  where codinssrv = a_codinssrv
  and estinsprd in (1,2) --que este en activo o suspendido
  and fecini <= sysdate
  and (fecfin is null or fecfin >= sysdate); */

begin

   select tiptrs into ln_tiptrs
   from tiptrabajo
   where tiptra = a_tiptra;

   select count(1) into ln_num from
   solot a,solotpto b, estsol c, tiptrabajo d
   where  a.codsolot = b.codsolot
   and b.codinssrv = a_codinssrv
   and a.estsol = c.estsol
   and a.tiptra = d.tiptra
   and c.tipestsol in (4,6)
   and d.tiptrs = ln_tiptrs;

   --validacion para no dejar crear una sot si ya tiene
   --una sot cerrada o en ejecucion
   if ln_num = 0 then
     select * into lr_inssrv
     from inssrv where codinssrv = a_codinssrv;

     select area into lc_area
     from usuarioope where usuario = user;

     select i.tipsrv into ls_tipsrv
     from inssrv a,
       soluciones i,
       paquete_venta k
     where i.idsolucion = k.idsolucion
     and a.idpaq = k.idpaq
     and a.codinssrv = a_codinssrv;

     lr_solot.tiptra := a_tiptra;
     lr_solot.codmotot := a_motot;
     lr_solot.feccom := a_feccom;
     lr_solot.observacion := a_obs;
     lr_solot.estsol := 10;
     --lr_solot.tipsrv := lr_inssrv.tipsrv;
     lr_solot.tipsrv := ls_tipsrv;
     lr_solot.codcli := lr_inssrv.codcli;
     lr_solot.areasol := lc_area;

     --se crea la cabecera de la solot
     p_insert_solot(lr_solot, ln_codsolot);

     --ln_numpid := 0;
       --se crea el detalle para todos los pids de la inst. de servicio
     --for c_pid in cur_pid loop
       lr_solotpto.codsolot := ln_codsolot;
       lr_solotpto.tiptrs := 5;
       lr_solotpto.codsrvnue := lr_inssrv.codsrv;
       lr_solotpto.bwnue := lr_inssrv.bw;
       lr_solotpto.codinssrv := lr_inssrv.codinssrv;
       lr_solotpto.cid := lr_inssrv.cid;
       lr_solotpto.descripcion := lr_inssrv.descripcion;
       lr_solotpto.direccion := lr_inssrv.direccion;
       lr_solotpto.tipo := 2;
       lr_solotpto.estado := 1;
       lr_solotpto.visible := 1;
       lr_solotpto.codubi := lr_inssrv.codubi;
       --lr_solotpto.pid := c_pid.pid;
       lr_solotpto.codpostal := lr_inssrv.codpostal;

       p_insert_solotpto(lr_solotpto, ln_punto);

       --ln_numpid := ln_numpid + 1;
     --end loop;

     /*if ln_numpid = 0 then
        raise error_pid;
     end if;*/

     --se aprueba la SOT
     p_aprobar_solot(ln_codsolot,c_estsol_aprobado);
     --Se graba el cambio de estado a "Aprobado".
     insert into SOLOTCHGEST (codsolot,tipo, estado, fecha, observacion)
     values (ln_codsolot,1,c_estsol_aprobado,sysdate,'Aprobacion automatica.');

     --se ejecuta la SOT
     p_ejecutar_solot(ln_codsolot,c_estsol_ejecucion);

     a_codsolot := ln_codsolot;
   else
      raise error_validacion;
   end if;
exception
    --when error_pid then
     --raise_application_error(-20500, 'No se encontró ningún PID activo o suspendido para el SID:' || to_char(a_codinssrv));
     when error_validacion then
       a_mensaje := 'Ya existe una SOT Cerrada o en Ejecucion para el SID:' || to_char(a_codinssrv);
    when others then
       a_mensaje := 'Error al crear la SOT para el SID:' || to_char(a_codinssrv);
end; --9.0

--<11.0>
procedure p_activacion_automatica(a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number) is

  ln_codsolot solot.codsolot%type;

  cursor c_trssolot is
    select codtrs, fectrs, esttrs, codsolot, codinssrv, pid
      from trssolot
     where codsolot = ln_codsolot;

begin

  select codsolot into ln_codsolot from wf where idwf = a_idwf;

  OPERACION.pq_solot.p_crear_trssolot(4,
                                      ln_codsolot,
                                      null,
                                      null,
                                      null,
                                      null);

  for lc_trssolot in c_trssolot loop

    operacion.pq_solot.p_exe_trssolot(lc_trssolot.codtrs, 2, sysdate);

    update solotpto
       set fecinisrv = sysdate
     where pid = lc_trssolot.pid
       and codsolot = ln_codsolot
       and fecinisrv is null;

  end loop;

exception
  when others then
    raise_application_error(-20500, 'Error al activar el servicio.');

end;
--</11.0>

--<12.0>
function f_obtener_sot(a_numslc vtatabslcfac.numslc%type) return number
is
ln_codsolot solot.codsolot%type;

begin
  select min(codsolot) into ln_codsolot
  from solot,estsol
  where solot.estsol = estsol.estsol
  and numslc = a_numslc
  and estsol.tipestsol = 6;

  return ln_codsolot;
end;

function f_obtener_area(a_codsolot solot.codsolot%type) return number
is

ln_area tareawf.area%type;
begin
  select min(distinct b.area) into ln_area
  from wf a,tareawf b,esttarea c,areaope d, usuarioxareaope e
  where a.codsolot = a_codsolot
  and a.idwf = b.idwf
  and b.esttarea = c.esttarea
  and c.tipesttar in (1,2,3)
  and b.area = d.area
  and d.area = e.area
  and d.estado = 1
  and UPPER(e.usuario)= user;

  return ln_area;
end;
--</12.0>

--ini 17.0
procedure p_insert_trssolot_pa( a_codsolot  solot.codsolot%type,
                                a_lotetrs   number,
                                a_codtrs    trssolot.codtrs%type,
                                a_fec_retro trssolot.fectrs%type
)
is
begin
   insert into ope_trssolot_fecha_retro_det(codsolot,lotetrs,codtrs,fec_retro)
   values (a_codsolot,a_lotetrs,a_codtrs,a_fec_retro) ;
end;

procedure p_insert_sol_fec_retro_det( a_lotetrs ope_solicitud_fecha_retro_det.lotetrs%type,
                                      a_idsol ope_solicitud_fecha_retro_det.idsol%type
                                      )
is
cursor cur_trssolot_pa is
select codsolot, lotetrs, codtrs, fec_retro
  from ope_trssolot_fecha_retro_det
 where lotetrs = a_lotetrs;

begin

  for r_det in cur_trssolot_pa loop
   insert into ope_solicitud_fecha_retro_det(idsol,codsolot,lotetrs,codtrs,fec_retro)
   values (a_idsol,r_det.codsolot,a_lotetrs,r_det.codtrs,r_det.fec_retro) ;

  end loop;
end;

procedure p_exe_trssolot_pa(a_idsol ope_solicitud_fecha_retro_det.idsol%type )
is
cursor cur_trssolot_pa is
select a.codtrs,a.esttrs,a.fectrs from trssolot a, ope_solicitud_fecha_retro_det b
where a.codtrs = b.codtrs
  and b.idsol = a_idsol
  and a.esttrs = 5;

begin
  for r_det in cur_trssolot_pa loop
      p_valida_trssolot(r_det.codtrs,2);
      p_exe_trssolot(r_det.codtrs,2,r_det.fectrs);
  end loop;
end;

procedure p_notifica_sol_act(a_idsol ope_solicitud_fecha_retro_cab.idsol%type )
is
lr_sol                         ope_solicitud_fecha_retro_cab%rowtype;
a_correos                      dbms_sql.varchar2s;
lc_separador                   varchar2(1):= ';';
ls_asunto                      varchar2(150);
ls_cuerpo                      varchar2(2000);
ls_tipificacion                ope_tipo_res_fec_act_mae.descripcion%type;
ls_area_solicitante            areaope.descripcion%type;
ls_nombre_solicitante          usuarioope.nombre%type;
ls_area_aprobadora             areaope.descripcion%type;
ls_nombre_aprobador            usuarioope.nombre%type;
ls_codcli                      vtatabcli.codcli%type;
ls_nomcli                      vtatabcli.nomcli%type;
ls_tipo_trabajo                tiptrabajo.descripcion%type;
ls_nombre_estado_sol           ope_est_sol_act_pa_mae.descripcion%type;
ls_correo                      varchar2(1000);
ls_nombre_adm_reclamo          usuarioope.nombre%type;

begin

  select * into lr_sol from ope_solicitud_fecha_retro_cab where idsol = a_idsol;

  select v.codcli, v.nomcli, t.descripcion
  into ls_codcli, ls_nomcli, ls_tipo_trabajo
  from solot s, vtatabcli v, tiptrabajo t
  where s.codsolot = lr_sol.codsolot
  and s.codcli = v.codcli
  and s.tiptra = t.tiptra ;

  select a.descripcion into ls_tipificacion
  from ope_tipo_res_fec_act_mae a where a.idtipo = lr_sol.idtipo;

  select b.descripcion into ls_area_solicitante from areaope b
  where b.area = lr_sol.area_ejec;

  select b.nombre into ls_nombre_solicitante from usuarioope b
  where b.usuario = lr_sol.usu_ejec;

  select b.descripcion into ls_area_aprobadora from areaope b
  where b.area = lr_sol.area_resp;

  select b.nombre into ls_nombre_aprobador from usuarioope b
  where b.usuario = lr_sol.usu_aprob;

  select b.nombre into ls_nombre_adm_reclamo from usuarioope b
  where b.usuario = lr_sol.usu_adm_rec;

  select b.descripcion into ls_nombre_estado_sol from ope_est_sol_act_pa_mae b
  where b.estado = lr_sol.estado;

  if lr_sol.estado = 0 then --(Pendiente de aprobación)
     select email into ls_correo
       from usuarioope
      where usuario = lr_sol.usu_aprob; --(Correo Usuario aprobador)
  elsif lr_sol.estado = 1 then --(Aprobado)
     select email into ls_correo
       from usuarioope
      where usuario = lr_sol.usu_ejec; --(Usuario solicitador)
  elsif lr_sol.estado = 2 then --(Rechazado)
     ls_correo := lr_sol.correo_adm_rec; --(Usuario administrador de reclamos)
  end if;

  a_correos.delete;
  pq_fnd_utilitario_interfaz.prc_dividir_linea(ls_correo,a_correos,lc_separador);

  ls_asunto := ls_tipo_trabajo || ' - N° SOT  '  || lr_sol.codsolot;
  ls_cuerpo := 'Detalle de la Solicitud de activación retroactiva: ' || chr(13) || chr(13);
  ls_cuerpo := ls_cuerpo || 'Estado de la Solicitud: ' || ls_nombre_estado_sol || chr(13) || chr(13);
  ls_cuerpo := ls_cuerpo || 'Cliente: ' || ls_codcli || '-' || ls_nomcli || chr(13) || chr(13);
  ls_cuerpo := ls_cuerpo || 'Nro SOT: ' || lr_sol.codsolot  || chr(13) || chr(13);
  ls_cuerpo := ls_cuerpo || 'Tipificación: ' || ls_tipificacion || chr(13) || chr(13);
  ls_cuerpo := ls_cuerpo || 'Área Solicitante: ' || ls_area_solicitante || chr(13) || chr(13);
  ls_cuerpo := ls_cuerpo || 'Usuario Solicitante: ' || ls_nombre_solicitante || chr(13) || chr(13);

  if length(lr_sol.observacion) > 0  then
     ls_cuerpo := ls_cuerpo || 'Observación Solicitante: ' || lr_sol.observacion || chr(13) || chr(13);
  end if;

  ls_cuerpo := ls_cuerpo || 'Área Aprobadora: ' || ls_area_aprobadora || chr(13) || chr(13);
  ls_cuerpo := ls_cuerpo || 'Usuario Aprobador: ' || ls_nombre_aprobador || chr(13) || chr(13);

  if length(lr_sol.obs_aprob) > 0  then
     ls_cuerpo := ls_cuerpo || 'Observación Aprobador: ' || lr_sol.obs_aprob || chr(13) || chr(13);
  end if;

  ls_cuerpo := ls_cuerpo || 'Usuario Adm. Reclamos: ' || ls_nombre_adm_reclamo || chr(13) || chr(13);

  if length(lr_sol.obs_adm_rec) > 0  then
     ls_cuerpo := ls_cuerpo || 'Observación Adm. Reclamos: ' || lr_sol.obs_adm_rec || chr(13) || chr(13);
  end if;

  for i in 0.. (a_correos.count-1) loop
    produccion.p_envia_correo_de_texto_att(as_subject => ls_asunto,
                                           as_destino => a_correos(i),
                                           as_cuerpo => ls_cuerpo);
  end loop;

end;

procedure p_registra_chg_estado_sol_act( a_idsol in number,
                                         a_tipo in number,
                                         a_estado in number,
                                         a_observacion in varchar2,
                                         a_usuario in varchar2 default user,
                                         a_fecreg  in date default sysdate
                                        )
is
begin

  insert into ope_solicitud_fecha_retro_his(idsol,tipo,estado,observacion,usureg,fecreg)
  values (a_idsol,a_tipo,a_estado,a_observacion,a_usuario,a_fecreg);

end;

procedure p_reg_chg_fec_retro_sol_act( a_idsol in number,
                                       a_tipo in number,
                                       a_estado in number,
                                       a_fec_retro in date,
                                       a_usuario in varchar2 default user,
                                       a_fecreg  in date default sysdate
                                     )
is
cursor cur_solotpto is
select c.codsolot, c.punto
from ope_solicitud_fecha_retro_det a, trssolot b, solotpto c
where a.idsol = a_idsol
and a.codtrs = b.codtrs
and a.codsolot = c.codsolot
and b.pid = c.pid;

begin
  update trssolot
   set fectrs = a_fec_retro
  where codtrs in (select b.codtrs
                      from ope_solicitud_fecha_retro_det a, trssolot b
                     where a.idsol = a_idsol
                       and a.codtrs = b.codtrs);

  insert into ope_solicitud_fecha_retro_his(idsol,tipo,estado,fec_retro,campo,usureg,fecreg)
  values (a_idsol,a_tipo,a_estado,a_fec_retro,2,a_usuario,a_fecreg);

  for r_det in cur_solotpto loop
      update solotpto a
         set a.fecinisrv = a_fec_retro
       where a.codsolot = r_det.codsolot
         and a.punto = r_det.punto ;
  end loop;
end;

function f_valida_tipo_restriccion(a_area_ejec in ope_matriz_aprobacion_res_mae.area_ejec%type,
                                   a_tipo_rest in ope_tipo_res_fec_act_mae.idtipores%type)
return number
is
ln_cuenta number;

begin
   select count(1) into ln_cuenta
   from ope_matriz_aprobacion_res_mae a , ope_tipo_res_fec_act_mae b
   where a.idtipo = b.idtipo
     and a.area_ejec = a_area_ejec
     and b.idtipores = a_tipo_rest
     and a.estado = 1
     and b.estado = 1 ;

   if ln_cuenta > 0 then
      return 1;
   else
      return 0;
   end if;
end;

--fin 17.0
--ini 28.0
procedure p_modifica_fechini_servicio(an_codsolot   in solot.codsolot%type,
                                      ad_fecservini in inssrv.fecini%type,
                                      an_cod_error  out number,
                                      as_des_error  out varchar2) is
  ln_cant_ultidcon  number(4);
  ln_tiptrs tiptrabajo.tiptrs%type;
  lc_codcli vtatabcli.codcli%type;
  ex_trssolot       exception;
begin
  an_cod_error := 0;
  begin
  select distinct tip.tiptrs, s.codcli into ln_tiptrs, lc_codcli
    from solot s, tiptrabajo tip, trssolot tr
   where s.tiptra = tip.tiptra
     and s.codsolot = tr.codsolot
     and s.codsolot = an_codsolot;
  exception
    when NO_DATA_FOUND then
       raise ex_trssolot;
  end;
   --altas
   if ln_tiptrs = 1 then
     select count(distinct ip.idinstprod)
       into ln_cant_ultidcon
       from solot st, trssolot trs, instxproducto ip
      where st.codsolot = trs.codsolot
        and trs.pid = ip.pid
        and ip.fecfin is null
        and st.codsolot = an_codsolot
        and ip.ultidcon is null
        and ip.montocr > 0
        and ip.estado <> 9;

      if (ln_cant_ultidcon >= 0) then

        update solotpto set fecinisrv = ad_fecservini
         where codsolot = an_codsolot;
        --and trunc(fecinisrv) = l_fecha_antigua;

        update trssolot set fectrs = ad_fecservini, fecinifac = ad_fecservini
         where codsolot = an_codsolot;

        update inssrv set fecini = ad_fecservini
         where codinssrv in (select distinct codinssrv
                               from trssolot
                              where codsolot = an_codsolot)
           and fecfin is null;
        --and trunc(fecini) = l_fecha_antigua;

        update insprd set fecini = ad_fecservini
         where codinssrv in (select distinct codinssrv
                               from trssolot
                              where codsolot = an_codsolot)
           and fecfin is null;
        -- and trunc(fecini) = l_fecha_antigua;

        update instanciaservicio set fecini = ad_fecservini
         where codinssrv in
               (select codinssrv from trssolot where codsolot = an_codsolot)
           and fecfin is null;
        -- and trunc(fecini) = l_fecha_antigua;

        update instxproducto set fecini = ad_fecservini
         where pid in (select pid from trssolot where codsolot = an_codsolot)
           and fecfin is null;
        -- and trunc(fecini) = l_fecha_antigua;

        update instanciaxprom set fchini = ad_fecservini
         where idinstprod in
               (select idinstprod
                  from instxproducto
                 where pid in
                       (select pid from trssolot where codsolot = an_codsolot)
                   and fecfin is null)
           and fchfin is null;
        --and trunc(fchini) = l_fecha_antigua;

      else
         an_cod_error := -1;
         as_des_error := 'Altas - No se puede modificar la fecha de servicio, estas ya han sido facturadas';
      end if;
   elsif ln_tiptrs = 5 then --Bajas
      update solotpto set fecinisrv = ad_fecservini
       where codsolot = an_codsolot;
         --and trunc(fecinisrv) = l_fecha_antigua;

      update trssolot set fectrs = ad_fecservini, fecinifac = ad_fecservini
       where codsolot = an_codsolot;

      update inssrv set fecfin = ad_fecservini
       where codinssrv in (select distinct codinssrv
                             from trssolot
                            where codsolot = an_codsolot);
         --and trunc(fecfin) = l_fecha_antigua;

      update insprd set fecfin = ad_fecservini
       where codinssrv in (select distinct codinssrv
                             from trssolot
                            where codsolot = an_codsolot);
        -- and trunc(fecfin) = l_fecha_antigua;

      update instanciaservicio set fecfin = ad_fecservini
       where codinssrv in
             (select codinssrv from trssolot where codsolot = an_codsolot);
         --and trunc(fecfin) = l_fecha_antigua;

      update instxproducto set fecfin = ad_fecservini
       where pid in
             (select pid from trssolot where codsolot = an_codsolot);
        -- and trunc(fecfin) = l_fecha_antigua;

      update instanciaxprom set fchfin = ad_fecservini
       where idinstprod in
             (select idinstprod
                from instxproducto
               where pid in
                     (select pid from trssolot where codsolot = an_codsolot)
                 and fecfin is null);
        -- and trunc(fchfin) = l_fecha_antigua;
   elsif ln_tiptrs = 4 then --Reconexiones
      select count(distinct ip.idinstprod)
        into ln_cant_ultidcon
        from solot st, trssolot trs, instxproducto ip
       where st.codsolot = trs.codsolot
         and trs.pid = ip.pid
         and ip.fecfin is null
         and st.codsolot = an_codsolot
         and ip.ultidcon is null
         /*and ip.montocr > 0*/
         and ip.estado <> 9;

      if (ln_cant_ultidcon >= 0) then
          update solotpto set fecinisrv = ad_fecservini
           where codsolot = an_codsolot;
           --  and trunc(fecinisrv) = l_fecha_antigua;

          update trssolot set fectrs = ad_fecservini, fecinifac = ad_fecservini
           where codsolot = an_codsolot;

          update inssrv set fecini = ad_fecservini
           where codinssrv in (select distinct codinssrv
                                 from trssolot
                                where codsolot = an_codsolot)
             and fecfin is null;
           --  and trunc(fecini) = l_fecha_antigua;

          update insprd set fecini = ad_fecservini
           where codinssrv in (select distinct codinssrv
                                 from trssolot
                                where codsolot = an_codsolot)
             and fecfin is null;
           --  and trunc(fecini) = l_fecha_antigua;

          update instanciaservicio set fecini = ad_fecservini
           where codinssrv in
                 (select codinssrv from trssolot where codsolot = an_codsolot)
             and fecfin is null;
           --  and trunc(fecini) = l_fecha_antigua;

          update instxproducto set fecini = ad_fecservini
           where pid in
                 (select pid from trssolot where codsolot = an_codsolot)
             and fecfin is null;
            -- and trunc(fecini) = l_fecha_antigua;

          update instanciaxprom set fchini = ad_fecservini
           where idinstprod in
                 (select idinstprod
                    from instxproducto
                   where pid in
                         (select pid from trssolot where codsolot = an_codsolot)
                     and fecfin is null)
             and fchfin is null;
           --  and trunc(fchini) = l_fecha_antigua;

           update suspxinstprod set fecon = ad_fecservini
            where codcli = lc_codcli;
             -- and trunc(fecon) = l_fecha_antigua;
      else
         an_cod_error := -1;
         as_des_error := 'Reconexion - No se puede modificar la fecha de servicio, estas ya han sido facturadas';
      end if;

   end if;
exception
  when ex_trssolot then
    an_cod_error := -1;
    as_des_error := 'No se puede modificar fecha de servicio, debera realizar la aprobacion previamente';
  when others then
    an_cod_error := sqlcode;
    if an_cod_error = -20000 then
      as_des_error := substr(sqlerrm, 12);
    else
      as_des_error := substr(sqlerrm, 12) || ' (' ||
                      dbms_utility.format_error_backtrace || ')';
    end if;
end;
--fin 28.0

--Ini 31.0
  FUNCTION f_valida_duplicidad_sot_ope( a_codsolot   operacion.solot.codsolot%type ) return varchar2
  is
  ls_cliente    marketing.vtatabcli.codcli%type;
  ls_tiptra     operacion.tiptrabajo.tiptra%type;
  ls_codsolot   varchar(2000);
  ls_des        varchar2(100);
  ls_mensaje    varchar2(400);
  e_val_sot     exception;
  e_val_sus     exception;

  /** Cursor de Servicios **/
  cursor c_lis_servicios(ll_codsolot operacion.solot.codsolot%type) is
  select distinct codinssrv
    from operacion.solotpto
   where codsolot = ll_codsolot;

  /** Cursor de tipos de Trabajo  **/
  cursor c_lis_tiptra is
  select b.descripcion o_desc,
         b.codigon     o_tiptra
    from operacion.tipopedd a,
         operacion.opedd b
   where a.tipopedd    = b.tipopedd
     and a.descripcion = 'OPE-VAL-SOT'
     and b.codigon_aux = 1; -- 1 = activo, 0 = desactivado

  /** Cursor de tipos de Trabajo Suspendidos **/
  cursor c_lis_tiptra_res is
  select b.codigoc     o_estado,
         b.descripcion o_desc,
         b.codigon     o_tiptra,
         ( select estinssrv from estinssrv where abrevi = b.abreviacion ) o_estsrv
    from operacion.tipopedd a,
         operacion.opedd b
   where a.tipopedd    = b.tipopedd
     and a.descripcion = 'OPE-VAL-SUSP'
     and b.codigon_aux = 1; -- 1 = activo, 0 = desactivado

  /** Cursor de Estados  **/
  cursor c_lis_estados is
  select b.codigon     o_estsol
    from operacion.tipopedd a,
         operacion.opedd b
   where a.tipopedd    = b.tipopedd
     and a.descripcion = 'OPE-VAL-ESTADOS'
     and b.codigon_aux = 1; -- 1 = activo, 0 = desactivado

  /** Cursor de Validaciones Tipo Trabajo - Estados **/
  cursor c_lis_valsot( l_cliente   vtatabcli.codcli%type,
                        l_servicio inssrv.codinssrv%type,
                        l_tiptra   solot.tiptra%type,
                        l_estsol   solot.estsol%type) is
  select distinct a.codsolot solot
    from operacion.solot a,
         operacion.solotpto b
   where a.codsolot  =  b.codsolot
     and b.codinssrv =  l_servicio
     and a.codcli    =  l_cliente
     and a.tiptra    =  l_tiptra
     and a.estsol    =  l_estsol
     and a.codsolot not in (a_codsolot);


  /** Cursor de Validaciones Tipo Trabajo - Suspension **/
  cursor c_lis_valsot_suspension(  l_cliente   vtatabcli.codcli%type,
                                   l_servicio  inssrv.codinssrv%type,
                                   l_tiptra    solot.tiptra%type,
                                   l_estsol    solot.estsol%type,
                                   l_estinssrv estinssrv.estinssrv%type ) is
  select max(a.codsolot) solot
    from operacion.solot a,
         operacion.solotpto b
   where a.codsolot  =  b.codsolot
     and b.codinssrv =  l_servicio
     and a.codcli    =  l_cliente
     and a.tiptra    =  l_tiptra
     and a.estsol    =  l_estsol
     and ( select count(*)
             from inssrv
            where codinssrv = b.codinssrv
              and estinssrv = l_estinssrv ) = 1;

  begin

    -- Valores Iniciales
    ls_mensaje  := 'OK';

    -- Consultas
    select codcli, tiptra into ls_cliente, ls_tiptra
      from operacion.solot
     where codsolot = a_codsolot;

    -- cursor de servicios
    for r_serv in c_lis_servicios(a_codsolot)  loop
        -- Flujo 1: Control Suspensiones
        for r_tiptra_sus in c_lis_tiptra_res loop
          if ( r_tiptra_sus.o_tiptra =ls_tiptra ) then
            for r_val_sot_susp in c_lis_valsot_suspension(ls_cliente, r_serv.codinssrv, r_tiptra_sus.o_tiptra, r_tiptra_sus.o_estado, r_tiptra_sus.o_estsrv) loop
               if ( c_lis_valsot_suspension%rowcount > 0 ) then
                  if ls_codsolot is null then
                     ls_codsolot := to_char(r_val_sot_susp.solot);
                  else
                     ls_codsolot := to_char(ls_codsolot) || ',' || to_char(r_val_sot_susp.solot);
                  end if;
                  ls_des := r_tiptra_sus.o_desc;
               else
                  exit;
               end if;
            end loop;
            if ls_codsolot is not null then
              ls_mensaje :=  ' Para este SID: '|| r_serv.codinssrv || ' ,se tiene una SOT de: ' || ls_des ||  '  En Estado Cerrado con codigo de SOT: '|| ls_codsolot;
              raise e_val_sus;
            end if;
          end if;
        end loop;
        -- Flujo 2: Control Duplicidad
        for r_tiptra in c_lis_tiptra loop
            if r_tiptra.o_tiptra = ls_tiptra then
               for r_estsol in c_lis_estados loop
                 for r_val_sot in c_lis_valsot(ls_cliente, r_serv.codinssrv, r_tiptra.o_tiptra, r_estsol.o_estsol)  loop
                     if ( c_lis_valsot%rowcount > 0 ) then
                       if ls_codsolot is null then
                          ls_codsolot := to_char(r_val_sot.solot);
                       else
                          ls_codsolot := to_char(ls_codsolot) || ',' || to_char(r_val_sot.solot);
                       end if;
                       ls_des := r_tiptra.o_desc;
                     else
                       exit;
                     end if;
                 end loop;
                 if ls_codsolot is not null then
                    ls_mensaje :=  ' Para este SID: '|| r_serv.codinssrv || ' ,se tiene una SOT de: ' || ls_des ||  ' con codigo de SOT: '|| ls_codsolot;
                    raise e_val_sot;
                 end if;
              end loop;
            end if;
        end loop;
    end loop;
    return ls_mensaje;
   exception
      when e_val_sot then
        return ls_mensaje;
      when e_val_sus then
        return ls_mensaje;
  end;
  --Fin 31.0
--ini 33.0
procedure p_act_auto_fid(a_idtareawf in number,
                         a_idwf      in number,
                         a_tarea     in number,
                         a_tareadef  in number) is

  ln_codsolot solot.codsolot%type;
  ls_codcli   vtatabcli.codcli%type;

  cursor c_trssolot is
    select codtrs, fectrs, esttrs, codsolot, codinssrv, pid
      from trssolot
     where codsolot = ln_codsolot;

begin

  select codsolot into ln_codsolot from wf where idwf = a_idwf;
  select codcli   into ls_codcli   from solot where codsolot = ln_codsolot;

  OPERACION.pq_solot.p_crear_trssolot(4,
                                      ln_codsolot,
                                      null,
                                      null,
                                      null,
                                      null);

  for lc_trssolot in c_trssolot loop

    operacion.pq_solot.p_exe_trssolot(lc_trssolot.codtrs, 2, sysdate);

    update solotpto
       set fecinisrv = sysdate
     where pid = lc_trssolot.pid
       and codsolot = ln_codsolot
       and fecinisrv is null;

  end loop;

  INSERT INTO intraway.int_solot_itw(codsolot, codcli, estado, flagproc)
        VALUES(ln_codsolot, ls_codcli,2,0);


  intraway.pq_intraway.p_activa_fid_iw(a_idtareawf,
                                       a_idwf,
                                       a_tarea,
                                       a_tareadef);

  intraway.pq_ejecuta_masivo.p_carga_info_int_envio_fid(ln_codsolot);

exception
  when others then
    raise_application_error(-20500, 'Error al activar el servicio por Fidelizacion.');

end;

Function  f_restringir_cierre_fid( a_codsolot in number ) return number
is

 l_cnt_fid   number;
 l_cnt_iw    number;
 l_cnt_rsp_a number;
 l_cnt_rsp_b number;

begin


  -- validacion de existencia de sot de fidelizacion
  select count(*)
   into l_cnt_fid
   from billcolper.fidelizacion
  where codsolot = a_codsolot
    and estado   = 1;

  -- consulta de sot de fidelizacion
  if l_cnt_fid =  1 then

    select count(*)
      into l_cnt_iw
      from intraway.int_transaccionesxsolot
     where codsolot = a_codsolot;

    if l_cnt_iw > 0 then

       -- Validar respuesta de IW
       select count(*)
         into l_cnt_rsp_a
         from intraway.int_transaccionesxsolot
        where codsolot = a_codsolot;

       select count(*)
         into l_cnt_rsp_b
         from intraway.int_transaccionesxsolot
        where codsolot = a_codsolot
          and estado = 3;

       --Cierra la tarea de Configuracion de Intraway
       if l_cnt_rsp_a = l_cnt_rsp_b then
          return 1;
          delete intraway.int_envio where codsolot = a_codsolot;
       else
          return 0;
       End if;
    else
      return 0;
    end if;
  else
    return 1;
  end if;
end;
--fin 33.0
-- ini 35.0
procedure p_act_auto_titularidad( a_idtareawf in number,
                                  a_idwf      in number,
                                  a_tarea     in number,
                                  a_tareadef  in number) is

 ln_codsolot operacion.solot.codsolot%type;

begin
  -- Consultas
  select codsolot
    into ln_codsolot
    from wf
   where idwf = a_idwf;

   /* Liberacion de Numeros */
    operacion.pq_cuspe_ope2.p_libera_numero( a_idtareawf,
                                             a_idwf,
                                             a_tarea,
                                             a_tareadef);

   /* Asignacion de Numeros */
   operacion.p_asignacion_numero( a_idtareawf,
                                  a_idwf,
                                  a_tarea,
                                  a_tareadef);

   /* Generacion de Alta */
   p_gen_sot_alt(ln_codsolot);
end;

procedure p_act_auto_numero( a_idtareawf in number,
                             a_idwf      in number,
                             a_tarea     in number,
                             a_tareadef  in number) is

 ln_codsolot operacion.solot.codsolot%type;

begin
  -- Consultas
  select codsolot
    into ln_codsolot
    from wf
   where idwf = a_idwf;

    /* Liberacion de Numeros */
    operacion.pq_cuspe_ope2.p_libera_numero( a_idtareawf,
                                             a_idwf,
                                             a_tarea,
                                             a_tareadef);

    /* Asignacion de Numeros */
    operacion.pq_cuspe_ope.p_asig_numtelef_wf( a_idtareawf,
                                               a_idwf,
                                               a_tarea,
                                               a_tareadef);

   /* Generacion de Alta */
   p_gen_sot_alt(ln_codsolot);

end;

procedure p_gen_sot_baja( a_codsolot in operacion.solot.codsolot%type,
                          a_opc  in varchar2 ) is

  r_solot          operacion.solot%rowtype;
  r_det            operacion.solotpto%rowtype;
  a_baja_codsolot  operacion.solot.codsolot%type;
  l_punto          number;
  ln_tiptra        operacion.solot.tiptra%type;
  ln_codmot        operacion.solot.codmotot%type;
  ls_codcli        marketing.vtatabcli.codcli%type;
  ls_numslc        operacion.solot.numslc%type;
  ls_obs           varchar2(500);
  ld_feccorte      date;
  ld_wfdef         opewf.wf.wfdef%type;

  cursor cur_det is
  select codsolot, punto from solotpto
     where codsolot = a_codsolot
       order by punto;

begin

  select * into r_solot
    from solot
   where solot.codsolot = a_codsolot;

   select codigon, to_number(codigoc)
     into ln_tiptra, ln_codmot
     from crmdd
    where abreviacion = a_opc;

    select codcli, numslc_ori, feccorte
      into ls_codcli, ls_numslc, ld_feccorte
      from regvtamentab
     where numslc = r_solot.numslc;

  if a_opc = 'TIPTRA_BAJ_TIT' then

    select codigon
      into ld_wfdef
      from crmdd
     where abreviacion = trim('WF_BAJA_TIT');

    r_solot.codcli   := ls_codcli;
    ls_obs           := 'SOT generada por el Cambio de Titularidad: ';
    ls_obs           := ls_obs||chr(13)||'Proyecto '|| r_solot.numslc;
    ls_obs           := ls_obs||', SOT '|| r_solot.codsolot;
  else
    select codigon
      into ld_wfdef
      from crmdd
     where abreviacion = trim('WF_BAJA_NUM');

    ls_obs           := 'SOT generada por el Cambio de Numero: ';
    ls_obs           := ls_obs||chr(13)||'Proyecto '|| r_solot.numslc;
    ls_obs           := ls_obs||', SOT '|| r_solot.codsolot;
  end if ;

  r_solot.numslc          := ls_numslc;
  r_solot.observacion     := ls_obs;
  r_solot.tiptra          := ln_tiptra;
  r_solot.estsol          := 11;
  r_solot.codmotot        := ln_codmot;
  r_solot.codsolot        := null;

  p_insert_solot(r_solot, a_baja_codsolot);

  for r in cur_det loop
    select *
      into r_det
      from solotpto
     where codsolot = r.codsolot
       and punto = r.punto;

    if a_opc = 'TIPTRA_BAJ_TIT' then
       r_det.fecinisrv :=   ld_feccorte;
    end if;

    r_det.pid           := r_det.pid_old;
    r_det.codinssrv     := r_det.codinssrv_tra;

    select cid
      into r_det.cid
      from inssrv
     where codinssrv =  r_det.codinssrv;

    r_det.codsolot      := a_baja_codsolot ;
    r_det.codinssrv_tra := null;
    r_det.pid_old       := null;
    p_insert_solotpto(r_det, l_punto);
  end loop;

  p_asig_wf(a_baja_codsolot , ld_wfdef);

exception
  when others then
       raise_application_error(-20500,'Error en la Generacion de SOT de Baja por Cambio de Titularidad/Numero...' || SQLERRM );
end;


procedure p_gen_sot_alt( a_codsolot in operacion.solot.codsolot%type )
  is

  ls_codcli vtatabcli.codcli%type;

    cursor c_activar is
    select codtrs,
           fectrs,
           esttrs,
           codsolot,
           codinssrv,
           pid
      from trssolot
     Where codsolot = a_codsolot;

begin

    select codcli into ls_codcli from solot where codsolot = a_codsolot;

        operacion.pq_solot.p_crear_trssolot( 4,
                                             a_codsolot,
                                             null,
                                             null,
                                             null,null );

    for lc_activart in c_activar loop
        operacion.pq_solot.p_exe_trssolot( lc_activart.codtrs,
                                            2,
                                            sysdate );

        update solotpto
           set fecinisrv = sysdate
         where pid       = lc_activart.pid
           and codsolot  = a_codsolot
           and fecinisrv is null;
    end loop;


    insert into intraway.int_solot_itw(codsolot, codcli, estado, flagproc)
      values(a_codsolot, ls_codcli,2,0);


exception
  when others then
       raise_application_error(-20500,'Error en la Activacion de servicios por Cambio de Titularidad: ' || SQLERRM);
end;

procedure p_val_cierre_sot_tit_num(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number) is

  ln_codsolot    solot.codsolot%type;
  l_cantidad     number;
  l_conttrs_sot  number;
  l_cont_ejec    number;
begin
  select codsolot
    into ln_codsolot
    from wf
   where idwf = a_idwf;

  select count(*)
    into l_cantidad
    from intraway.int_transaccionesxsolot
   where codsolot = ln_codsolot;

  if l_cantidad > 0 then

    select count(*)
      into l_conttrs_sot
      from intraway.int_transaccionesxsolot
     where codsolot = ln_codsolot;

    select count(*)
      into l_cont_ejec
      from intraway.int_transaccionesxsolot
     where codsolot = ln_codsolot
       and estado = 3;

    if l_conttrs_sot <> l_cont_ejec then
       raise_application_error(-20500, 'La Tarea no se Puede Cerrar, se Necesita una Respuesta de Intraway');
    End if;
  end if;
exception
  when others then
    raise_application_error(-20500, 'Error En Validacion de Cierre de SOT');
end;
procedure p_int_envio(a_idtareawf in number,
                                   a_idwf      in number,
                                   a_tarea     in number,
                                   a_tareadef  in number) is

  ln_codsolot    solot.codsolot%type;
  l_cant         number;
begin
  select codsolot
    into ln_codsolot
    from wf
   where idwf = a_idwf;

  select count(*)
  into l_cant
  from intraway.int_envio
  where codsolot = ln_codsolot;

  IF l_cant = 0 THEN
    OPERACION.PQ_CUSPE_OPE2.p_int_iw_solot_anuladas(ln_codsolot);
  END IF;

exception
  when others then
    raise_application_error(-20500, 'Error En Validacion de Cierre de SOT');
end;

-- Fin 35.0
  --------------------------------------------------------------------------------
  function esta_habilitado return boolean is
    l_count number;

  begin
    select count(d.codigon)
      into l_count
      from tipopedd c, opedd d
     where c.tipopedd = d.tipopedd
       and c.abrev = 'PARAM_FACT_SGA'
       and d.abreviacion = 'habilitado'
       and d.codigon = 1;

    return l_count > 0;
  end;
  --------------------------------------------------------------------------------
  function get_flgbil return number is
    l_flgbil trssolot.flgbil%type;

  begin
    select d.codigon
      into l_flgbil
      from tipopedd c, opedd d
     where c.tipopedd = d.tipopedd
       and c.abrev = 'PARAM_FACT_SGA'
       and d.abreviacion = 'est_fact_sga';

    return l_flgbil;

  exception
    when others then
      raise_application_error(-20000,
                              $$plsql_unit || '.get_flgbil() ' || sqlerrm);
  end;

  -- ini 40.0
  function f_valida_anulsothfc(an_codsolot number) return number is
  ln_contar number;

  begin
    select count(distinct pto.codsrvnue)
      into ln_contar
      from solot s, solotpto pto, tystabsrv ser
     where s.codsolot = pto.codsolot
       and pto.codsrvnue = ser.codsrv
       and s.codsolot = an_codsolot
       and ser.idproducto in
           (select o.codigon
              from tipopedd ti, opedd o
             where ti.tipopedd = o.tipopedd
               and ti.abrev = 'ANUSOTHFC_IDPROD');

    return ln_contar;
  end;
  --fin 40.0
  -- Inicio 45.0
  --------------------------------------------------------------------------------
  procedure SGASI_RECLAMO_SOT(pi_codsolot    number,
                              pi_nro_caso    varchar2,
                              pi_nro_reclamo varchar2,
                              po_cod_error   out number,
                              po_des_error   out varchar2) is
    /*
    ****************************************************************
    * Nombre SP         : SGASI_RECLAMO_SOT
    * Propósito         : Registrar en la tabla OPERACION.SGAT_RECLAMO_SOT la SOT, 
                          n?mero de reclamo y n?mero de caso generado
    * Input             : pi_codsolot    --> SOT
                          pi_nro_caso    --> Caso generado
                          pi_nro_reclamo --> N?mero de reclamo
    * Output            : po_cod_error   --> Código de Error
                          po_des_error   --> Descripción de Error
    * Creado por        : Juan Olivares
    * Fec Creación      : 19/10/2016
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_error exception;
  
  begin
    if pi_codsolot is null or pi_nro_caso is null or pi_nro_reclamo is null then
      raise v_error;
    end if;
  
    insert into operacion.sgat_reclamo_sot
      (rsotv_nro_sot, rsotv_nro_caso, rsotv_nro_reclamo)
    values
      (pi_codsolot, pi_nro_caso, pi_nro_reclamo);
  
    po_cod_error := 0;
    po_des_error := 'Operación Exitosa';
  
  exception
    when v_error then
      po_cod_error := 2;
      po_des_error := 'FALTAN PARAMETROS';
    when others then
      po_cod_error := '-1';
      po_des_error := 'ERROR: ' || sqlerrm;
  end;
  ----------------------------------------------------------------------------------
  procedure SGASS_VAL_GEN_SOT_REC(pi_codsolot  number,
                                  po_valida    out number,
                                  po_cod_error out number,
                                  po_des_error out varchar2) is
    /*
    ****************************************************************
    * Nombre SP         : SGASS_VAL_GEN_SOT_REC
    * Propósito         : Validar si se puede generar una SOT a partir de otra SOT,
                          según el tipo de trabajo y estado de la SOT actual.
    * Input             : pi_codsolot  --> SOT
                          po_valida    --> 1: SOT V?lida
                                           0: Sot No V?lida
    * Output            : po_cod_error --> Código de Error
                          po_des_error --> Descripción de Error
    * Creado por        : Juan Olivares
    * Fec Creación      : 19/10/2016
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_error exception;
    v_tiptra solot.tiptra%type;
    v_estado solot.estsol%type;
    v_count  pls_integer;
  
  begin
    if pi_codsolot is null then
      raise v_error;
    end if;
  
    po_valida := 1;
  
    select tiptra, estsol
      into v_tiptra, v_estado
      from solot
     where codsolot = pi_codsolot;
  
    select count(1)
      into v_count
      from operacion.sgat_tiptra_recla_sot t
     where t.ttrsn_tipo_trabajo = v_tiptra
       and t.ttrsn_estado_sot = v_estado;
  
    if v_count > 0 then
      po_valida := 0;
    end if;
  
    po_cod_error := 0;
    po_des_error := 'OK';
  
  exception
    when v_error then
      po_valida    := 0;
      po_cod_error := 2;
      po_des_error := 'FALTAN PARAMETROS';
    when others then
      po_valida    := 0;
      po_cod_error := '-1';
      po_des_error := 'ERROR: ' || sqlerrm;
  end;
  --------------------------------------------------------------------------------
  procedure SGASS_TIPTRA_SERV(pi_servicio    varchar2,
                              po_tip_trabajo out sys_refcursor) is
    /*
    ****************************************************************
    * Nombre SP         : SGASS_TIPTRA_SERV
    * Propósito         : Listar los tipos de trabajo según el tipo de servicio
    * Input             : pi_servicio    --> Tipo de servicio
    * Output            : po_tip_trabajo --> Listado de Tipos de Trabajo
    * Creado por        : Juan Olivares
    * Fec Creación      : 19/10/2016
    * Fec Actualización : N/A
    ****************************************************************
    */
  
  begin
    open po_tip_trabajo for
      select distinct t.ttren_tipo_trabajo
        from operacion.sgat_tiptra_recla t
       where t.ttrev_servicio = pi_servicio;
  end;
  --------------------------------------------------------------------------------
  procedure SGASS_VAL_TIPTRA_REC(pi_tiptra    number,
                                 po_valida    out number,
                                 po_cod_error out number,
                                 po_des_error out varchar2) is
    /*
    ****************************************************************
    * Nombre SP         : SGASS_VAL_TIPTRA_REC
    * Propósito         : Validar que el tipo de trabajo enviado sea de condici?n: Reclamo.
    * Input             : pi_tiptra    --> Tipo de Trabajo
    * Output            : po_valida    --> 1: Tipo de Trabajo V?lido
                                           0: Tipo de Trabajo No V?lido
                          po_cod_error --> Código de Error
                          po_des_error --> Descripción de Error
    * Creado por        : Juan Olivares
    * Fec Creación      : 19/10/2016
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_error exception;
    v_existe pls_integer;
  
  begin
    if pi_tiptra is null then
      raise v_error;
    end if;
  
    po_valida := 0;
  
    select count(1)
      into v_existe
      from operacion.sgat_tiptra_recla t
     where t.ttren_tipo_trabajo = pi_tiptra;
  
    if v_existe > 0 then
      po_valida := 1;
    end if;
  
  exception
    when v_error then
      po_valida    := 0;
      po_cod_error := 2;
      po_des_error := 'FALTA PARAMETRO';
    when others then
      po_valida    := 0;
      po_cod_error := '-1';
      po_des_error := 'ERROR: ' || sqlerrm;
  end;
  --------------------------------------------------------------------------------
  procedure SGASS_CONSULTA_SOLOT(pi_codsolot    number,
                                 pi_nro_caso    varchar2,
                                 pi_nro_reclamo varchar2,
                                 po_dato        out sys_refcursor,
                                 po_cod_error   out number,
                                 po_des_error   out varchar2) is
    /*
    ****************************************************************
    * Nombre SP         : SGASS_CONSULTA_SOLOT
    * Propósito         : Obtener datos de una SOT para SGA
    * Input             : pi_codsolot    --> SOT
                          pi_nro_caso    --> N?mero de caso
                          pi_nro_reclamo --> N?mero de reclamo
    * Output            : po_cod_error   --> Código de Error
                          po_des_error   --> Descripción de Error
    * Creado por        : Juan Olivares
    * Fec Creación      : 19/10/2016
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_error1 exception;
    v_codsolot number;
  
  begin
    if pi_codsolot is null and pi_nro_caso is null and pi_nro_reclamo is null then
      raise v_error1;
    end if;
  
    select t.rsotv_nro_sot
      into v_codsolot
      from operacion.sgat_reclamo_sot t
     where t.rsotv_nro_sot = pi_codsolot
        or t.rsotv_nro_caso = pi_nro_caso
        or t.rsotv_nro_reclamo = pi_nro_reclamo;
  
    open po_dato for
      select s.codsolot,
             s.tiptra,
             s.estsol,
             s.docid,
             s.tipsrv,
             s.fecapr,
             s.fecfin,
             s.observacion,
             s.codcli,
             s.numslc,
             s.derivado,
             s.coddpt,
             s.recosi,
             s.codmotot,
             s.estasi,
             s.origen,
             s.cliint,
             s.tiprec,
             s.numpsp,
             s.idopc,
             s.tipcon,
             s.plan,
             s.estsolope,
             s.feccom,
             s.numptas,
             s.fecini,
             s.prycon,
             s.idproducto,
             s.areasol,
             s.arearesp,
             s.usuarioresp,
             s.direccion,
             s.codubi,
             r.rsotv_nro_caso,
             r.rsotv_nro_reclamo
        from solot s, operacion.sgat_reclamo_sot r
       where s.codsolot = v_codsolot
         and r.rsotv_nro_sot = s.codsolot;
  
    po_cod_error := 0;
    po_des_error := 'Operación Exitosa';
  
  exception
    when v_error1 then
      open po_dato for
        select null from dual;
      po_cod_error := 2;
      po_des_error := 'FALTAN PARAMETROS';
    when others then
      open po_dato for
        select null from dual;
      po_cod_error := '-1';
      po_des_error := 'ERROR: ' || sqlerrm;
  end;
  --------------------------------------------------------------------------------
  procedure SGASS_VALIDA_RECLAMO(pi_codsolot  number,
                                 po_cod_error out number,
                                 po_des_error out varchar2) is
    /*
    ****************************************************************
    * Nombre SP         : SGASS_VALIDA_RECLAMO
    * Propósito         : Valida que el reclamo este asociado a la SOT
    * Input             : pi_codsolot    --> SOT
    * Output            : po_cod_error   --> Código de Error
                          po_des_error   --> Descripción de Error
    * Creado por        : Juan Olivares
    * Fec Creación      : 25/10/2016
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_nro_reclamo varchar2(32);
  
  begin
    select t.rsotv_nro_reclamo
      into v_nro_reclamo
      from operacion.sgat_reclamo_sot t
     where t.rsotv_nro_sot = pi_codsolot;
  
    po_cod_error := 0;
    po_des_error := 'Reclamo válido';
  
  exception
    when no_data_found then
      po_cod_error := -1;
      po_des_error := sgafun_get_parametro('reclamos', 'msj_sot', 1);
  end;
  --------------------------------------------------------------------------------
  function SGAFUN_GET_PARAMETRO(pi_filtro1 varchar2,
                                pi_filtro2 varchar2,
                                pi_filtro3 number) return varchar2 is
    /*
    ****************************************************************
    * Nombre FUN        : SGAFUN_GET_PARAMETRO
    * Propósito         : Obtener parametros configurados
    * Input             : pi_filtro1 --> Filtro
                          pi_filtro2 --> Filtro
                          pi_filtro3 --> Filtro
    * Output            : Parametro solicitado
    * Creado por        : Juan Olivares
    * Fec Creación      : 25/10/2016
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_descripcion varchar2(100);
  
  begin
    select d.descripcion
      into v_descripcion
      from tipopedd c, opedd d
     where c.abrev = pi_filtro1
       and c.tipopedd = d.tipopedd
       and d.abreviacion = pi_filtro2
       and d.codigon = pi_filtro3
       and d.codigon_aux = 1;
  
    return v_descripcion;
  end;
  --------------------------------------------------------------------------------
  procedure SGASS_VALIDA_CREDENC(pi_codsolot  number,
                                 pi_usuario   varchar2,
                                 po_url       out varchar2,
                                 po_cod_error out number,
                                 po_des_error out varchar2) is
    /*
    ****************************************************************
    * Nombre SP         : SGASS_VALIDA_CREDENC
    * Propósito         : Acceder al WS ValidarCredencialesWSSB11
    * Input             : pi_codsolot  --> SOT
                          pi_usuario   --> Usuario que accede
    * Output            : po_url       --> URL de acceso
                          po_cod_error --> Código de Error
                          po_des_error --> Descripción de Error
    * Creado por        : Juan Olivares
    * Fec Creación      : 25/10/2016
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_req_reg_comu clob;
    v_res_reg_comu clob;
    v_secuencia    varchar2(100);
  
  begin
    --Request registrarComunicacion
    v_req_reg_comu := sgafun_regist_comunic(pi_codsolot, pi_usuario);
  
    --Response registrarComunicacion
    v_res_reg_comu := sgafun_response(v_req_reg_comu,
                                      sgafun_get_parametro('reclamos',
                                                           'url_ws',
                                                           1));
  
    --Descomponer Response registrarComunicacion
    sgass_desc_reg_comun(v_res_reg_comu, v_secuencia, po_url);
  
    po_url := po_url || '?secuencia=' || v_secuencia;
  
    po_cod_error := 0;
    po_des_error := 'Operación Exitosa';
  
  exception
    when no_data_found then
      po_url       := null;
      po_cod_error := 1;
      po_des_error := 'NO ENCONTRADO';
    when others then
      po_url       := null;
      po_cod_error := '-1';
      po_des_error := 'ERROR: ' || sqlerrm;
  end;
  --------------------------------------------------------------------------------
  function SGAFUN_REGIST_COMUNIC(pi_codsolot number, pi_usuario varchar2)
    return clob is
    /*
    ****************************************************************
    * Nombre FUN        : SGAFUN_REGIST_COMUNIC
    * Propósito         : Armar el xml Request del método registrarComunicacion.
    * Input             : pi_codsolot --> SOT
                          pi_usuario  --> Usuario que accede
    * Output            : Request del método registrarComunicacion
    * Creado por        : Juan Olivares
    * Fec Creación      : 25/10/2016
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_xml           varchar2(32767);
    v_idTransaccion varchar2(20);
    v_ipAplicacion  varchar2(20);
    v_Aplicacion    varchar2(10);
    v_opcion        varchar2(10);
    v_ipCliente     varchar2(10);
    v_ipServOrigen  varchar2(10);
    v_jason         varchar2(2000);
    v_nro_caso      varchar2(32);
    v_nro_contrato  varchar2(32);
    v_opcionjason   varchar2(100);
    v_estadoform    varchar2(100);
    v_tipocasoint   varchar2(100);
    v_aplicacion_siacrec varchar2(10);
  begin
    v_idTransaccion := to_char(sysdate, 'YYYYMMDDHHMISS');
    v_ipAplicacion  := sgafun_get_parametro('reclamos', 'param_req', 1);
    v_aplicacion    := sgafun_get_parametro('reclamos', 'param_req', 2);
    v_opcion        := sgafun_get_parametro('reclamos', 'param_req', 3);
    v_ipcliente     := sgafun_get_parametro('reclamos', 'param_req', 4);
    v_ipservorigen  := sgafun_get_parametro('reclamos', 'param_req', 5);
    v_opcionjason   := sgafun_get_parametro('reclamos', 'param_req', 6);
    v_estadoform    := sgafun_get_parametro('reclamos', 'param_req', 7);
    v_tipocasoint   := sgafun_get_parametro('reclamos', 'param_req', 8);
    v_aplicacion_siacrec   := sgafun_get_parametro('reclamos', 'param_req', 9);
  
    select t.rsotv_nro_caso
      into v_nro_caso
      from operacion.sgat_reclamo_sot t
     where t.rsotv_nro_sot = pi_codsolot;
  
    v_nro_contrato := null;
  
    v_jason := '{"casointeraccionid" : "' || v_nro_caso || '", "tipoapp" : "' ||
               v_Aplicacion || '", "coid" : "' || v_nro_contrato ||
               '", "opcion" : "' || v_opcionjason || '", "estadoform" : "' ||
               v_estadoform || '", "tipocasointeraccion" : "' || v_tipocasoint || '"}';
  
    v_xml := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" ';
    v_xml := v_xml ||
             'xmlns:val="http://service.eai.claro.com.pe/ValidarCredencialesSUWS">';
    v_xml := v_xml || '<soapenv:Header/>';
    v_xml := v_xml || '<soapenv:Body>';
  
    v_xml := v_xml || '<val:registrarComunicacionRequest>';
    v_xml := v_xml || '<val:auditRequest>';
    v_xml := v_xml || '<val:idTransaccion>' || v_idTransaccion ||
             '</val:idTransaccion>';
    v_xml := v_xml || '<val:ipAplicacion>' || v_ipAplicacion ||
             '</val:ipAplicacion>';
    v_xml := v_xml || '<val:nombreAplicacion>' || v_Aplicacion ||
             '</val:nombreAplicacion>';
    v_xml := v_xml || '<val:usuarioAplicacion>' || pi_usuario ||
             '</val:usuarioAplicacion>';
    v_xml := v_xml || '</val:auditRequest>';
  
    v_xml := v_xml || '<val:opcion>' || v_opcion || '</val:opcion>';
    v_xml := v_xml || '<val:aplicacion>' || v_aplicacion_siacrec || '</val:aplicacion>';
    v_xml := v_xml || '<val:ipCliente>' || v_ipCliente || '</val:ipCliente>';
    v_xml := v_xml || '<val:ipServOrigen>' || v_ipServOrigen ||
             '</val:ipServOrigen>';
    v_xml := v_xml || '<val:jsonParametros>' || v_jason ||
             '</val:jsonParametros>';
  
    v_xml := v_xml || '<val:listaAdicionalRequest>';
    v_xml := v_xml || '<val:parametrosRequest>';
    v_xml := v_xml || '<val:campo></val:campo>';
    v_xml := v_xml || '<val:valor></val:valor>';
    v_xml := v_xml || '</val:parametrosRequest>';
    v_xml := v_xml || '</val:listaAdicionalRequest>';
    v_xml := v_xml || '</val:registrarComunicacionRequest>';
    v_xml := v_xml || '</soapenv:Body>';
    v_xml := v_xml || '</soapenv:Envelope>';
  
    return v_xml;
  end;
  --------------------------------------------------------------------------------
  function SGAFUN_RESPONSE(pi_xml clob, pi_url_ws varchar2) return clob is
    /*
    ****************************************************************
    * Nombre FUN        : SGAFUN_RESPONSE
    * Propósito         : Obtener el Response
    * Input             : pi_xml    --> Request
                          pi_url_ws --> URL WS
    * Output            : Response del método registrarComunicacion
    * Creado por        : Juan Olivares
    * Fec Creación      : 25/10/2016
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_request  utl_http.req;
    v_response utl_http.resp;
    v_xml_res  clob;
  
  begin
    v_request := utl_http.begin_request(pi_url_ws, 'POST', 'HTTP/1.1');
    utl_http.set_header(v_request, 'Content-Type', 'text/xml');
    utl_http.set_header(v_request, 'Content-Length', length(pi_xml));
    utl_http.write_text(v_request, pi_xml);
    v_response := utl_http.get_response(v_request);
    utl_http.read_text(v_response, v_xml_res);
    utl_http.end_response(v_response);
  
    return v_xml_res;
  end;
  --------------------------------------------------------------------------------
  procedure SGASS_DESC_REG_COMUN(pi_xml       clob,
                                 po_secuencia out varchar2,
                                 po_url       out varchar2) is
    /*
    ****************************************************************
    * Nombre SP         : SGASS_DESC_REG_COMUN
    * Propósito         : Descomponer en datos el Response del método registrarComunicacion
    * Input             : pi_xml       --> Response
    * Output            : po_secuencia --> Secuencia generada
                          po_url       --> URL de autenticaci?n
    * Creado por        : Juan Olivares
    * Fec Creación      : 25/10/2016
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_dato1 elements;
    v_dato2 elements;
  
  begin
    --secuencia
    v_dato1      := sgafun_elements(pi_xml, 'secuencia');
    po_secuencia := sgafun_content(v_dato1(1), 'secuencia');
  
    --URL Autenticaci?n
    v_dato2 := sgafun_elements(pi_xml, 'urlAuth');
    po_url  := sgafun_content(v_dato2(1), 'urlAuth');
  end;
  --------------------------------------------------------------------------------
  function SGAFUN_ELEMENTS(pi_xml varchar2, pi_element varchar2) return elements is
    /*
    ****************************************************************
    * Nombre FUN        : SGAFUN_ELEMENTS
    * Propósito         : Descomponer en datos el Response
    * Input             : pi_xml     --> Response
                          pi_element --> Tag a buscar
    * Output            : Nodo solicitado
    * Creado por        : Juan Olivares
    * Fec Creación      : 25/10/2016
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_xml      varchar2(32767);
    v_pos      pls_integer;
    v_elements elements;
    v_idx      pls_integer;
  
  begin
    v_xml := pi_xml;
    v_idx := 1;
  
    while instr(v_xml, '<' || pi_element || '>') > 0 loop
      v_xml := substr(v_xml, instr(v_xml, '<' || pi_element || '>'));
      v_pos := instr(v_xml, '</' || pi_element || '>');
      v_elements(v_idx) := substr(v_xml, 1, v_pos + length(pi_element) + 2);
      v_xml := substr(v_xml, v_pos + length(pi_element) + 3);
      v_idx := v_idx + 1;
    end loop;
  
    return v_elements;
  end;
  --------------------------------------------------------------------------------
  function SGAFUN_CONTENT(pi_element varchar2, pi_markup varchar2)
    return varchar2 is
    /*
    ****************************************************************
    * Nombre FUN        : SGAFUN_CONTENT
    * Propósito         : Obtener el dato solicitado del Response
    * Input             : pi_element --> Nodo
                          pi_markup  --> Nombre del dato solicitado
    * Output            : Dato solicitado
    * Creado por        : Juan Olivares
    * Fec Creación      : 25/10/2016
    * Fec Actualización : N/A
    ****************************************************************
    */
    v_pos1    pls_integer;
    v_pos2    pls_integer;
    v_element varchar2(32767);
    v_content varchar2(32767);
  
  begin
    v_element := pi_element;
    v_pos1    := length(pi_markup) + 3;
    v_pos2    := instr(v_element, '</' || pi_markup || '>');
    v_content := substr(v_element, v_pos1, v_pos2 - v_pos1);
  
    return v_content;
  end;
  --------------------------------------------------------------------------------
-- Fin 45.0
  procedure SGASS_ESTADO_SOT_EXP(PI_CODSOLOT in number,
                                 PO_ESTADO_SOT out varchar2,
                                 PO_CODIGO_RESPUESTA out number,
                                 PO_MENSAJE_RESPUESTA out varchar2) is
    v_atentida number;
    v_cerrada number;
  
  begin
  
    select count(1) into v_atentida from SOLOT s, ESTSOL e where s.CODSOLOT = PI_CODSOLOT and  s.ESTSOL = e.ESTSOL and lower(e.DESCRIPCION) like '%atendida%';
    select count(1) into v_cerrada from SOLOT s, ESTSOL e where s.CODSOLOT = PI_CODSOLOT and s.ESTSOL = e.ESTSOL and lower(e.DESCRIPCION) like '%cerrada%';
  
  if v_atentida>0 or v_cerrada>0
   then 
    PO_CODIGO_RESPUESTA := 0;
    PO_MENSAJE_RESPUESTA :='La Consulta SI retorna Datos.';
   end if;
  if v_atentida>0
   then
    PO_ESTADO_SOT := 'Atendida';
   end if;
  if v_cerrada>0
   then
    PO_ESTADO_SOT := 'Cerrada';
   end if;
  if v_atentida=0 and v_cerrada=0
   then
    PO_CODIGO_RESPUESTA := 1;
    PO_MENSAJE_RESPUESTA :='La Consulta NO retorna Datos.';
   end if;

  exception 
      when others then
        PO_CODIGO_RESPUESTA := -1;
        PO_MENSAJE_RESPUESTA := ''|| SQLERRM ;
  end SGASS_ESTADO_SOT_EXP;
  ----------------------------------------------------------------------------------


procedure SIACSI_GENERA_SOT_SGA_NC(pi_numslc      in sales.vtatabslcfac.numslc%type,
                                   pi_tiptra      in number,
                                   pi_fecprog     in varchar2,
                                   pi_franja      in varchar2,
                                   pi_codmotot    in operacion.motot.codmotot%type,
                                   pi_observacion in operacion.solot.observacion%type,
                                   pi_plano       in marketing.vtatabgeoref.idplano%type,
                                   pi_tiposervico in number,
                                   pi_usuarioreg  in operacion.solot.codusu%type,
                                   pi_cargo       in operacion.agendamiento.cargo%type,
                                   po_codsolot    out number,
                                   po_res_cod     out number,
                                   po_res_desc    out varchar2) is

  l_codcli       sales.vtatabslcfac.codcli%type;
  l_fechaagenda  date;
  l_codsolot     operacion.solot.codsolot%type;
  ln_wf          number;
  ln_wfdef       opewf.wfdef.wfdef%type;
  l_codcuadrilla operacion.cuadrillaxcontrata.codcuadrilla%type;
  ln_codcon      operacion.cuadrillaxcontrata.codcon%type;
  ln_valida      number;

  error_no_valor exception;
  error_no_cli exception;
  error_exist_sot exception;
  error_no_sot exception;
  error_no_cuad exception;
  error_no_gensot exception;
  error_no_wf exception;
  error_cod  number;
  error_desc varchar2(5);

begin

  error_cod  := 0;
  error_desc := 'OK';

  if pi_numslc is null then
    raise error_no_valor;
  end if;
  if pi_tiptra is null then
    raise error_no_valor;
  end if;
  if pi_fecprog is null then
    raise error_no_valor;
  end if;
  if pi_franja is null then
    raise error_no_valor;
  end if;
  if pi_codmotot is null then
    raise error_no_valor;
  end if;
  if pi_plano is null then
    raise error_no_valor;
  end if;
  if pi_usuarioreg is null then
    raise error_no_valor;
  end if;

  begin
    select t.codcli
      into l_codcli
      from sales.vtatabslcfac t
     where t.numslc = pi_numslc;
  exception
    when no_data_found then
      raise error_no_cli;
  end;

  select count(*)
    into ln_valida
    from operacion.solot s, operacion.estsol e
   where s.codcli = l_codcli
     and s.tiptra in (select o.codigon
                        from operacion.opedd o, operacion.tipopedd t
                       where o.tipopedd = t.tipopedd
                         and t.abrev = 'TIPO_TRANS_SIAC'
                         and o.codigoc = '1')
     and s.estsol = e.estsol
     and e.estsol not in (select d.codigon
                            from operacion.tipopedd c, operacion.opedd d
                           where c.abrev = 'ESTADO_SOT'
                             and c.tipopedd = d.tipopedd);

  if ln_valida > 0 then
    raise error_exist_sot;
  end if;

  select to_date(pi_fecprog || pi_franja, 'dd/mm/yyyy hh24:mi')
    into l_fechaagenda
    from dual;

  sales.pq_postventa_unificada.p_gen_sot_siac(pi_numslc,
                                              l_codcli,
                                              pi_tiptra,
                                              pi_codmotot,
                                              ln_codcon,
                                              l_codcuadrilla,
                                              l_fechaagenda,
                                              pi_observacion,
                                              pi_plano,
                                              pi_tiposervico,
                                              l_codsolot);
  if l_codsolot is null then
    raise error_no_gensot;
  end if;

  update operacion.agendamiento
     set fecagenda = l_fechaagenda
   where codsolot = l_codsolot;

  select count(1) into ln_wf from opewf.wf where codsolot = l_codsolot;

  if ln_wf = 0 then
    ln_wfdef := cusbra.f_br_sel_wf(l_codsolot);
    if ln_wfdef is null then
      raise error_no_wf;
    end if;
  
    begin
      pq_solot.p_asig_wf(l_codsolot, ln_wfdef);
    exception
      when others then
        po_res_cod  := -1;
        po_res_desc := sqlerrm || ' (' ||
                       dbms_utility.format_error_backtrace || ')';
    end;
  
  end if;

  update operacion.solot
     set codusu = pi_usuarioreg, cargo = pi_cargo
   where codsolot = l_codsolot;

  po_codsolot := l_codsolot;
  po_res_cod  := error_cod;
  po_res_desc := error_desc;

exception
  when error_no_valor then
    po_res_cod  := 1;
    po_res_desc := 'no se ha ingresado todos los parámetros correctamente.';
  when error_no_cli then
    po_res_cod  := 1;
    po_res_desc := 'no se ha encontrado el cliente asociado.';
  when error_exist_sot then
    po_res_cod  := 1;
    po_res_desc := 'Ya existe una transacción en proceso, SOT';
  when error_no_sot then
    po_res_cod  := 1;
    po_res_desc := 'no se ha encontrado la sot asociada.';
  when error_no_cuad then
    po_res_cod  := 1;
    po_res_desc := 'no se ha encontrado la cuadrilla asociada.';
  when error_no_gensot then
    po_res_cod  := 1;
    po_res_desc := 'no se ha generado la sot.';
  when error_no_wf then
    po_res_cod  := 1;
    po_res_desc := 'no se encuentra definido un wf.';
  when others then
    po_res_cod  := -1;
    po_res_desc := 'error: ' || sqlcode || ' ' || sqlerrm;
  
end;

--Ini 20.0
--Al hacer la Correccion de concepto de Anulacion en SGA en PQ_INT_VTAUNI, se encuentra optimo utilizar las constantes no en duro
BEGIN
select estsol into c_estsol_generado  from estsol  where lower(descripcion) like '%generada%';
select estsol into c_estsol_aprobado  from estsol  where lower(descripcion) like '%aprobado%';
select estsol into c_estsol_cerrado  from estsol  where lower(descripcion) like '%cerrada%';
select estsol into c_estsol_cancelado  from estsol  where lower(descripcion) like '%anulada';
select estsol into c_estsol_devuelta   from estsol  where lower(descripcion) like '%rechazada%';
select estsol into c_estsol_suspendido  from estsol  where lower(descripcion) like '%suspendida%';
select estsol into c_estsol_ejecucion  from estsol  where lower(descripcion) like '%en ejecu%';


EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20500, SQLERRM);
--Fin 20.0
END PQ_SOLOT;
/
