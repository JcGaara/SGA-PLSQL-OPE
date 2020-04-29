CREATE OR REPLACE PACKAGE BODY OPERACION.PQ_CONTROL_DTH is
  /************************************************************
     NOMBRE:     PQ_CONTROL_DTH
     PROPOSITO:  .

     PROGRAMADO EN JOB:  NO

     REVISIONES:
     Ver       Fecha        Autor            Solicitado por  Descripcion
   ---------  ----------  --------------- --------------  ------------------------
     1.0     23/04/2009  Hector Huaman                       REQ-90271: Se declaro el procedimiento p_job_verifica_reconexion,se corrigio el procedmiento p_job_ejecuta_reconexion y
                                                             p_job_verifica_reconexion
     2.0     27/04/2009  Joseph Asencios                     REQ 84617: Se creó el procedimiento p_job_ejecuta_reconexion_adic para el envio de bouquets adicionales y se agregó este procedimiento
                                                             al procedimiento job p_job_controldth. Se modificó el procedimiento p_job_migra_cuponpago para actualizar el flag de envio de
                                                             bouquets adicionales .
     3.0     25/05/2009  Joseph Asencios                     REQ 93539: Se modificó el procedimiento p_job_migra_cuponpago para que no considere en la creación automática de notas de crédito
                                                             documentos en estado igual a 01(Generado) y 06(Anulado).

     4.0     21/07/2009  José Robles                         REQ-87889: Modificaciones para Recarga Virtual por Bancos.

     5.0     10/08/2009  Joseph Asencios                     REQ-98037: Se comentó condición de unicidad del cursor c_rec_pendientes_pago
                                                             del procedimiento p_job_migra_cuponpago, para anular todos los recibos
                                                             pendiente de un cliente.
     6.0     18/08/2009  Joseph Asencios                     REQ-99155: Adecuaciones para contemplar la inserción y actualización del código de recarga

     7.0     31/08/2009  Joseph Asencios                     REQ-100186: Se agregó el procedimiento p_migra_sistema_facturacion.

     8.0     10/09/2009  José Ramos                          REQ-102642: Se modifica el orden de la ejecución de procedimientos del JOB p_job_controldth, para garantizar el cambio a Recarga Virtual

     9.0     27/10/2009  Hector Huaman                       REQ-105258:Se modifico el procedimiento  p_job_ejecuta_reconexion,para que se actualice el estado del registro (PID)
    10.0       05/11/2009  Jimmy A. Farfán                   REQ-104367: Ampliacion de recarga DTH. Se creó el procedimiento
                                                             p_modifica_fin_vigencia para cortar o reconectar registros
                                                             desde una incidencia pendiente.
  11.0       12/11/2009  Marcos Echevarria                   REQ-108907: se modifico p_modifica_fin_vigencia para el calculo de dias
  12.0       06/01/2010  Marcos Echevarria                   REQ-112635: se modifico p_job_actualiza_bdweb y p_job_transfer_bdweb  para que se tome los registros dth no que no sean tipo estado 3
  13.0       08/02/2010  Marcos Echevarria                   REQ-118662: se modifico p_job_actualiza_bdweb y p_job_transfer_bdweb  para que se tome los registros dth que tengan PID en estado Activo y Suspendido, no se consideran PIDs en estado Sin Activar, ni Cancelados
  14.0       24/03/2010  Antonio Lagos                       REQ-119998: DTH + CDMA, se llama a nueva estructura recargaxinssrv
  15.0       24/03/2010  Marcos Echevarria                   REQ-120836: se modifico p_modifica_fin_vigencia para que las vigencias tambien se actualicen en reginsdth_web.
  16.0       15/06/2010  Marcos Echevarria  Jose Ramos       REQ-133045: se comenta un procedimiento en p_job_controldth para evitar lentitud, el cual será pasado en otro job.
  17.0       24/06/2010  Antonio Lagos      Juan Gallegos    REQ.119999: DTH + CDMA, se pasa logica de bundle a paquete pq_control_inalambrico
  18.0       14/07/2010  Alexander Yong     José Ramos       Req. 134941: la actualización de las fechas de vigencia, no están tomando en cuenta si en ese instante, se tiene en proceso una recarga virtual
  19.0       05/06/2010  Vicky Sánchez      Juan Gallegoso   Promociones DTH: : Cuando se realiza un traslado de recarga, donde el origen haya sido Brigthstar, el flag de la conciliación dependerá del origen
  20.0       06/07/2010  Dennys Mallqui     Johnny Argume    Promociones DTH: : Desacoplar el motor de cálculo de promociones en PESGAINT con PESGAPRD
  21.0       08/09/2010  Edson Caqui        Jose Ramos       Req. 141852
  22.0       15/09/2010  Antonio Lagos      Juan Gallegos    REQ.142338 Migracion DTH
  23.0       21/09/2010  Joseph Asencios                     REQ.142338 REQ-DTH-MIGRACION: Homologación de DTH con las nuevas estructuras de bundle.
                                                             Se modificó: p_act_fechasxpago
  24.0       06/10/2010  Joseph Asencios    Juan Gallegos    REQ 145146: Se modificó el procedimiento p_gen_reconexion_adic para utilizar
                                                             las nuevas tablas de bundle.
  25.0       13/09/2010  Alfonso Pérez      Yuri Lingan      Se migra la configuración de Promociones en Línea <Proyecto DTH Venta Nueva>
                                                             REQ 140740
  26.0       07/10/2010                                      REQ.139588 Cambio de Marca
  27.0       04/11/2010  Yuri Lingán        José Ramos       Se migra la configuración de Promociones en Línea
                         REQ-147783
  28.0       29/09/2010  Miguel Aroñe                        Req 142941 - Desarrollo Sistema de Recarga Virtual en Red de Recarga Claro
  29.0       30/03/2011  Antonio Lagos      Edilberto A.     REQ 153934: mejoras en Suspension y Reconexion DTH
  30.0       07/04/2011  Ronal Corilloclla  Melvin Balcazar  Proyecto Suma de Cargos:
                                                             1 - p_job_transfer_bdweb() - Modificado - Cargo los precios de los paquetes: REC_DETPAQ_RECARGA_MAE
                                                             2 - p_job_transfer_bdweb() - Modificado - Borramos tablas de servicios REC_INSSRV_CAB, REC_INSPRD_DET
                                                             3 - p_job_transfer_bdweb() - Modificado - Cargamos tablas de servicios REC_INSSRV_CAB, REC_INSPRD_DET
                                                             4 - p_job_migra_bouquetxreginsdth() - Modificado - Campos nuevos al BOUQUETXREGINSDTH: idgrupo y pid
  31.0       04/07/2011  Antonio Lagos      Juan Gallegos    REQ.160112 Optimizar el tiempo de transferencia de los servicios (Suma de cargo).
  32.0       19/07/2011  Ivan Untiveros     Manuel Gallegos  REQ.160350 Optimizar el tiempo de transferencia de los servicios (Suma de cargo) hacia INT.
  33.0       03/08/2011  Widmer Quispe      Manuel Gallegos  REQ-160463 Optimizar el tiempo de transferencia de los servicios (Suma de cargo) hacia INT.
  34.0       08/01/2012  Miguel Londoña     Jose Ramos       Recargas Parciales : Se agrega el flg_defecto a la carga de la tabla vtatabrecargaxpaquete_web
  35.0       09/08/2014  Ronald Ramirez     Alicia Peña   Req: PROY-14342-IDEA-12729-Mejorar Proceso de Suspensión DTH
  36.0       09/08/2014  Michael Boza       Alicia Peña   Req: PROY-14342-IDEA-12729-Mejorar Proceso de Suspensión DTH
  ******************************************************************************/
  --Ini 19.0
  procedure p_graba_log(av_mensaje varchar2, av_oraerror varchar2) is
    pragma autonomous_transaction;
    /***********************************************************************
    NOMBRE:           p_graba_log
    PROPOSITO:        Graba el detalle del log para la transferencia a INT
    PROGRAMADO EN JOB:  No
    ************************************************************************/
    ln_idlog ope_detlog_transfer.idlog%type;
  begin

    select sq_ope_detlog_transfer.nextval into ln_idlog from dummy_ope;
    insert into ope_detlog_transfer
      (idlog, mensaje, oraerror)
    values
      (ln_idlog, av_mensaje, av_oraerror);
    commit;
  end p_graba_log;
  --Fin 19.0
  -- Función que verifica si hay incidencias de sin servicio registradas en estado generado o en proceso
  function f_ch_verifica_reclamo(lc_numregistro char) return number is
    ln_retorno number;
  begin
    select count(1)
      into ln_retorno
      from incidence a, customerxincidence b, reginsdth c
     where a.codincidence = b.codincidence
       and b.servicenumber = c.codinssrv
       and c.numregistro = lc_numregistro
       and a.codstatus in (1, 2);
    if ln_retorno > 1 then
      return 1;
    else
      return 0;
    end if;
  end;

  function f_get_ult_recarga(lc_numregistro char) return number is
    ln_nroconfir number;
  begin
    begin
      select nroconfir
        into ln_nroconfir
        from cuponpago_dth
       where idcupon in (select max(idcupon)
                           from cuponpago_dth
                          where numregistro = lc_numregistro);
    exception
      when no_data_found then
        ln_nroconfir := 0;
    end;
    return ln_nroconfir;
  end;
  /*
    Función que verifica si hay incidencias de sin servicio registradas y su estado
    - Si las incidencias son responsabilidad de Claro retorna 1 para que no genere corte
    - Si las incidencias son responsabilidad del Cleinte retorna 0 para que se proceda con el corte
  */
  function f_verifica_reclamo(ln_codinssrv number) return number is
    -- Incidencias de la instancia a cortar
    cursor c_incidence(p_codinssrv number) is
      select idincdth,
             codincidence,
             customersequence,
             service,
             servicenumber,
             numregistro,
             fecreg,
             estado
        from incidence_dth
       where servicenumber = p_codinssrv
         and estado = 1;
    -- Registros de solucion
    cursor c_solucion(p_codincidence number, p_service varchar2) is
      select codsequence, sequencedate
        from incidence_sequence
       where codincidence = p_codincidence
         and service = p_service
         and codstatus = 3;
    ln_retorno       number;
    ln_codassociated number;
    ls_fecini        date;
    ls_fecfin        date;
    ln_dias          number;
    ln_cantidad      number;
  begin
    ln_retorno := -1;

    select count(1)
      into ln_cantidad
      from incidence_dth
     where servicenumber = ln_codinssrv
       and estado = 1;
    if ln_cantidad = 0 then
      return 0;
    end if;

    -- Buscamos todas las incidencias de sin señal del servicio
    for r_incidence in c_incidence(ln_codinssrv) loop
      -- Verificar si existe registro seguimiento de tipo solucion
      for r_solucion in c_solucion(r_incidence.codincidence,
                                   r_incidence.service) loop
        begin
          select codassociated
            into ln_codassociated
            from trouble
           where codincidence = r_incidence.codincidence
             and codsequence = r_solucion.codsequence;
        exception
          when no_data_found then
            ln_codassociated := 9;
        end;
        -- Si el problema esta asociado al cliente
        if ln_codassociated = 2 then
          update operacion.incidence_dth
             set codassociated = ln_codassociated, estado = 2
           where idincdth = idincdth;
          -- Se cambia el valor de retorno solo si este no es 1
          if ln_retorno = -1 then
            ln_retorno := 0;
          end if;
        else
          -- CLARO
          update incidence_dth
             set codassociated = ln_codassociated, estado = 2
           where idincdth = idincdth;
          begin
            select startdate, enddate
              into ls_fecini, ls_fecfin
              from time_interruption
             where codincidence = r_incidence.codincidence
               and codsequence = r_solucion.codsequence;
          exception
            when no_data_found then
              ls_fecini := r_incidence.fecreg;
              ls_fecfin := r_solucion.sequencedate;
          end;
          select ceil(ls_fecfin - ls_fecini) into ln_dias from dummy_ope;
          update reginsdth
             set fecfinvig = fecfinvig + ln_dias
           where numregistro = r_incidence.numregistro;
          update reginsdth
             set feccorte = feccorte + ln_dias
           where numregistro = r_incidence.numregistro;
          ln_retorno := 1;
        end if;
      end loop;
    end loop;
    -- Si no ha existido ningun cambio se mantiene el no corte
    if ln_retorno = -1 then
      ln_retorno := 1;
    end if;
    return ln_retorno;
  end;

  procedure p_actualiza_reclamo_dth is
  begin
    null;
  end;

  --- Transferencia de Datos a BD Web
  procedure p_job_actualiza_bdweb is
    --  Job que transfiere los registros nuevos cada 5 minutos
    --<14.0
    --<17.0
    --ini 22.0
    ln_estinsprd insprd.estinsprd%type;
    ln_num_act   number;
    ln_num_sus   number;

    cursor c_recarga_cab is
      select /*+ RULE*/
      --select x.numregistro,
       x.numregistro,
       x.fecinivig,
       x.fecfinvig,
       x.fecalerta,
       x.feccorte,
       x.estado,
       (select e.descripcion
          from ope_estado_recarga e
         where e.codestrec = x.estado) dscestdth,
       (select nomcli from vtatabcli where codcli = x.codcli) nomcli,
       x.numslc,
       x.codcli,
       x.idpaq,
       x.codsolot,
       p.nrodoc,
       0 idcontrato,
       null nrodoc_contrato,
       --0 estinsprd,
       0 flgtransferir,
       (select decode(tipdide, '001', ntdide, '0000000000')
          from vtatabcli
         where codcli = x.codcli) ruc,
       x.codigo_recarga
      --from recargaproyectocliente x,
        from ope_srv_recarga_cab x, vtatabpspcli p
       where x.numslc is not null
         and x.numslc = p.numslc
            --and (nvl((select tipoestado from estregdth where codestdth = x.estado),0) <> 3)
         and x.estado <> '04' --no se incluyen los registros en estado cancelado, tabla ope_estado_recarga
         and not exists (select 1
              --from reginsdth_web z
                from reginsdth_web_pivot z
               where z.numregistro = x.numregistro)
            --ini 22.0
         and x.tipbqd = 4 --solo se envia DTH, no CDMA
      --fin 22.0
      ;
    --fin 22.0
    --17.0>
    --14.0>

    --<20.0
    --ini 22.0
    cursor c_recarga_det(p_numregistro ope_srv_recarga_det.numregistro%type) is
      select a.numregistro,
             a.codinssrv,
             a.tipsrv,
             a.codsrv,
             a.fecact,
             a.fecbaja,
             a.pid,
             a.estado,
             a.ulttareawf
        from ope_srv_recarga_det a
       where a.numregistro = p_numregistro
         and a.tipsrv in (select c.valor
                            from constante c
                           where c.constante = 'FAM_CABLE');

    /*cursor c_reginsdth is
    select + RULE
     x.numregistro,
     x.codinssrv,
     s.tipsrv,
     s.codsrv,
     x.nrodoccon,
     x.fecactconax,
     x.fecinivig,
     x.fecfinvig,
     x.fecalerta,
     x.feccorte,
     x.estado,
     (select e.dscestdth from estregdth e where e.codestdth = x.estado) dscestdth,
     x.nomcli,
     x.numslc,
     x.codcli,
     x.idpaq,
     x.codsolot,
     x.pid,
     s.cid,
     p.nrodoc,
     0 idcontrato,
     null nrodoc_contrato,
     f.estinsprd,
     0 flgtransferir,
     (select decode(tipdide, '001', ntdide, '0000000000')
        from vtatabcli --REQ 87889
       where codcli = s.codcli) ruc, --REQ 87889
     x.codigo_recarga -- REQ 99155
      from reginsdth x, vtatabpspcli p, inssrv s, insprd f
     where x.numslc is not null
       and x.numslc = p.numslc
       and x.pid = f.pid
       and x.codinssrv = s.codinssrv
       and f.estinsprd not in (3, 4) -- <13.0> Solo se incluyen servicios activos y suspendidos
          -- and x.estado not in ('18','05','06','12') --<12.0>
       and (nvl((select tipoestado
                  from estregdth
                 where codestdth = x.estado),
                0) <> 3) --<12.0>
          Ini 20.0: Se realiza la consulta directa a PRD y ya no a INT
           and not exists (select 1
                                  from reginsdth_web z
                                 where z.numregistro = x.numregistro)
          Fin 20.0
       and not exists (select 1
              from reginsdth_web_pivot z
             where z.numregistro = x.numregistro);*/
    --fin 22.0

    cursor c_bouquet_mae is
      select x.idbouquet, x.codbouquet, x.descripcion, x.flg_activo
        from ope_bouquet_mae x
       where not exists (select 1
                from rec_bouquet_mae z
               where z.idbouquet = x.idbouquet);

    cursor c_grupo_bouquet_det is
      select idgrupo, codbouquet, flg_activo
        from ope_grupo_bouquet_det x
       where not exists (select 1
                from rec_grupo_bouquet_det z
               where z.idgrupo = x.idgrupo
                 and z.codbouquet = x.codbouquet);
    --ini 20.0
    --cursor c_bouquetxreginsdth is
    cursor c_bouquetxreginsdth(ac_numregistro bouquetxreginsdth.numregistro%type) is
    --Fin 20.0
      select *
        from bouquetxreginsdth r
       where r.estado = 1 --solo se transfiere los activos
         and r.fecha_inicio_vigencia is null --los que se registren directamente en bouquetxreginsdth no proviene de promociones
         and r.fecha_fin_vigencia is null
         and r.numregistro = ac_numregistro --20.0
         and not exists (select 1
                from rec_bouquetxreginsdth_cab rec
               where rec.numregistro = r.numregistro
                 and rec.bouquets = r.bouquets
                 and rec.codsrv = r.codsrv
                 and rec.numregistro = ac_numregistro /*20.0*/
              );
    --20.0>

    --Ini 25.0
    cursor c_promo_insert is
      select *
        from fac_promocion_en_linea_mae pi
       where pi.idpromocion not in
             (select pf.idprom_en_linea
                from promocion pf
               where pf.idprom_en_linea is not null);

    cursor c_promo_update is
      select * from fac_promocion_en_linea_mae;

    an_aux number;
    --Fin 25.0

  begin
    begin
      --<20.0
      /*
      insert into reginsdth_web
        (numregistro,
         nrodoccon,
         fecactconax,
         fecinivig,
         fecfinvig,
         fecalerta,
         feccorte,
         estado,
         dscestdth,
         nomcli,
         numslc,
         codcli,
         idpaq,
         codsolot,
         pid,
         cid,
         nrodoc,
         idcontrato,
         nrodoc_contrato,
         estinsprd,
         flgtransferir,
         ruc, --REQ 87889
         CODIGO_RECARGA  -- REQ 99155
         )
        select x.numregistro,
               x.nrodoccon,
               x.fecactconax,
               x.fecinivig,
               x.fecfinvig,
               x.fecalerta,
               x.feccorte,
               x.estado,
              (select e.dscestdth from estregdth e where  e.codestdth = x.estado),
               x.nomcli,
               x.numslc,
               x.codcli,
               x.idpaq,
               x.codsolot,
               x.pid,
               s.cid,
               p.nrodoc,
               0,
               null,
               f.estinsprd,
               0 flgtransferir,
              (select decode(tipdide,'001',ntdide,'0000000000') from vtatabcli   --REQ 87889
                 where codcli = s.codcli) ruc, --REQ 87889
               x.codigo_recarga -- REQ 99155
         from reginsdth     x,
              vtatabpspcli  p,
              inssrv        s,
              insprd        f
         where x.numslc is not null
           and x.numslc = p.numslc
           and x.pid = f.pid
           and x.codinssrv = s.codinssrv
           and f.estinsprd not in (3, 4) -- <13.0> Solo se incluyen servicios activos y suspendidos
              -- and x.estado not in ('18','05','06','12') --<12.0>
          and (nvl((select tipoestado from estregdth where codestdth = x.estado) ,0) <> 3) --<12.0>
          and not exists (select 1
                  from reginsdth_web z
                 where z.numregistro = x.numregistro);
      */
      --Ini 20.0
      delete reginsdth_web_pivot;

      commit;

      insert into reginsdth_web_pivot
        select numregistro from reginsdth_web;

      commit;
      --Fin 20.0
      --ini 22.0
      /*for r_reginsdth in c_reginsdth loop

        insert into reginsdth_web
          (numregistro,
           nrodoccon,
           fecactconax,
           fecinivig,
           fecfinvig,
           fecalerta,
           feccorte,
           estado,
           dscestdth,
           nomcli,
           numslc,
           codcli,
           idpaq,
           codsolot,
           pid,
           cid,
           nrodoc,
           idcontrato,
           nrodoc_contrato,
           estinsprd,
           flgtransferir,
           ruc, --REQ 87889
           codigo_recarga -- REQ 99155
           )
        values
          (r_reginsdth.numregistro,
           r_reginsdth.nrodoccon,
           r_reginsdth.fecactconax,
           r_reginsdth.fecinivig,
           r_reginsdth.fecfinvig,
           r_reginsdth.fecalerta,
           r_reginsdth.feccorte,
           r_reginsdth.estado,
           r_reginsdth.dscestdth,
           r_reginsdth.nomcli,
           r_reginsdth.numslc,
           r_reginsdth.codcli,
           r_reginsdth.idpaq,
           r_reginsdth.codsolot,
           r_reginsdth.pid,
           r_reginsdth.cid,
           r_reginsdth.nrodoc,
           r_reginsdth.idcontrato,
           r_reginsdth.nrodoc_contrato,
           r_reginsdth.estinsprd,
           r_reginsdth.flgtransferir,
           r_reginsdth.ruc, --REQ 87889
           r_reginsdth.codigo_recarga -- REQ 99155
           );

        insert into rec_srv_recarga_det
          (numregistro,
           codinssrv,
           tipsrv,
           codsrv,
           fecact,
           fecbaja,
           pid,
           estado,
           ulttareawf)
        values
          (r_reginsdth.numregistro,
           r_reginsdth.codinssrv,
           r_reginsdth.tipsrv,
           r_reginsdth.codsrv,
           r_reginsdth.fecinivig,
           r_reginsdth.fecfinvig,
           r_reginsdth.pid,
           r_reginsdth.estado,
           null);

        for c1 in c_bouquetxreginsdth(r_reginsdth.numregistro) loop

          insert into rec_bouquetxreginsdth_cab
            (numregistro,
             codsrv,
             bouquets,
             tipo,
             estado,
             codusu,
             fecusu,
             flg_transferir,
             flg_rectransferir,
             fecultenv,
             usumod,
             fecmod,
             fecha_inicio_vigencia,
             fecha_fin_vigencia,
             idcupon)
          values
            (c1.numregistro,
             c1.codsrv,
             c1.bouquets,
             c1.tipo,
             c1.estado,
             c1.codusu,
             c1.fecusu,
             c1.flg_transferir,
             1, --flg_rectransferir
             c1.fecultenv,
             c1.usumod,
             c1.fecmod,
             c1.fecha_inicio_vigencia,
             c1.fecha_fin_vigencia,
             c1.idcupon);

        end loop;
      end loop;
      commit; --20.0*/
      --fin 22.0

      for r_bouquet_mae in c_bouquet_mae loop
        insert into rec_bouquet_mae
          (idbouquet, codbouquet, descripcion, flg_activo)
        values
          (r_bouquet_mae.idbouquet,
           r_bouquet_mae.codbouquet,
           r_bouquet_mae.descripcion,
           r_bouquet_mae.flg_activo);
      end loop;
      commit; --20.0

      for r_grupo_bouquet_det in c_grupo_bouquet_det loop
        insert into rec_grupo_bouquet_det
          (idgrupo, codbouquet, flg_activo)
        values
          (r_grupo_bouquet_det.idgrupo,
           r_grupo_bouquet_det.codbouquet,
           r_grupo_bouquet_det.flg_activo);
      end loop;
      commit; --20.0
      --20.0>
      --<14.0, se transfiere de las nuevas estructuras de recarga
      --<17.0
      --ini 22.0, se descomenta
      for r_recarga_cab in c_recarga_cab loop
        select count(1)
          into ln_num_act
        --from recargaxinssrv a, insprd b
          from ope_srv_recarga_det a, insprd b
         where a.numregistro = r_recarga_cab.numregistro
           and a.pid = b.pid
           and b.estinsprd = 1; --activos

        ln_estinsprd := 0;

        if ln_num_act = 0 then
          select count(1)
            into ln_num_sus
          --from recargaxinssrv a, insprd b
            from ope_srv_recarga_det a, insprd b
           where a.numregistro = r_recarga_cab.numregistro
             and a.pid = b.pid
             and b.estinsprd = 2; --suspendidos

          if ln_num_sus > 0 then
            ln_estinsprd := 2; --si no tiene activos pero tiene al menos uno suspendido
          end if;
        else
          ln_estinsprd := 1; --si tiene al menos uno activo
        end if;

        --si no es ni activo ni suspendido no se envia
        if ln_estinsprd > 0 then
          insert into reginsdth_web
            (numregistro,
             fecinivig,
             fecfinvig,
             fecalerta,
             feccorte,
             estado,
             dscestdth,
             nomcli,
             numslc,
             codcli,
             idpaq,
             codsolot,
             nrodoc,
             idcontrato,
             nrodoc_contrato,
             estinsprd,
             flgtransferir,
             ruc,
             codigo_recarga)
          values
            (r_recarga_cab.numregistro,
             r_recarga_cab.fecinivig,
             r_recarga_cab.fecfinvig,
             r_recarga_cab.fecalerta,
             r_recarga_cab.feccorte,
             r_recarga_cab.estado,
             r_recarga_cab.dscestdth,
             r_recarga_cab.nomcli,
             r_recarga_cab.numslc,
             r_recarga_cab.codcli,
             r_recarga_cab.idpaq,
             r_recarga_cab.codsolot,
             r_recarga_cab.nrodoc,
             r_recarga_cab.idcontrato,
             r_recarga_cab.nrodoc_contrato,
             ln_estinsprd,
             r_recarga_cab.flgtransferir,
             r_recarga_cab.ruc,
             r_recarga_cab.codigo_recarga);

          --se agrega
          for r_recarga_det in c_recarga_det(r_recarga_cab.numregistro) loop

            insert into rec_srv_recarga_det
              (numregistro,
               codinssrv,
               tipsrv,
               codsrv,
               fecact,
               fecbaja,
               pid,
               estado,
               ulttareawf)
            values
              (r_recarga_det.numregistro,
               r_recarga_det.codinssrv,
               r_recarga_det.tipsrv,
               r_recarga_det.codsrv,
               r_recarga_det.fecact,
               r_recarga_det.fecbaja,
               r_recarga_det.pid,
               r_recarga_det.estado,
               r_recarga_det.ulttareawf);

          end loop;

          for c1 in c_bouquetxreginsdth(r_recarga_cab.numregistro) loop
            insert into rec_bouquetxreginsdth_cab
              (numregistro,
               codsrv,
               bouquets,
               tipo,
               estado,
               codusu,
               fecusu,
               flg_transferir,
               flg_rectransferir,
               fecultenv,
               usumod,
               fecmod,
               fecha_inicio_vigencia,
               fecha_fin_vigencia,
               IDGRUPO, --30.0
               PID --30.0
               )
            values
              (c1.numregistro,
               c1.codsrv,
               c1.bouquets,
               c1.tipo,
               c1.estado,
               c1.codusu,
               c1.fecusu,
               c1.flg_transferir,
               1,
               c1.fecultenv,
               c1.usumod,
               c1.fecmod,
               c1.fecha_inicio_vigencia,
               c1.fecha_fin_vigencia,
               c1.idgrupo, --30.0
               c1.pid --30.0
               );

          end loop;
        end if;
      end loop;
      --fin 22.0
      --17.0>
      --14.0>

      --Ini 25.0
      for c_cursor in c_promo_insert loop

        if (c_cursor.var_porcentaje is not null) and
           (c_cursor.var_monto is null) then
          an_aux := 4; -- Tipo Dscto Porcentaje
        end if;
        if (c_cursor.var_monto is not null) and
           (c_cursor.var_porcentaje is null) then
          an_aux := 1; -- Tipo Dscto Cantidad
        end if;

        insert into PROMOCION
          (DSCPROM,
           PRIORIDAD,
           LIMITEAPLIC,
           FCHINI,
           FCHFIN,
           AFECTACNR,
           AFECTACR,
           flg_prom_en_linea,
           idprom_en_linea,
           flgact,
           estado,
           cantidad,
           porcentaje,
           duracion,
           cabdet,
           nivel,
           deptiphor,
           deptipuso,
           excluyente,
           visible,
           afecta,
           aplicainstprod,
           depinstprod,
           idtipprom)
        values
          (c_cursor.DESCRIPCION,
           c_cursor.PRIORIDAD,
           c_cursor.LIMITE_APLICACION,
           c_cursor.FECHA_INICIO,
           c_cursor.FECHA_FIN,
           c_cursor.FLG_AFECTACNR,
           c_cursor.FLG_AFECTACR,
           1,
           c_cursor.IDPROMOCION,
           1,
           1,
           c_cursor.var_monto * c_cursor.signo_var_monto,
           c_cursor.var_porcentaje * c_cursor.signo_var_porcentaje,
           c_cursor.SIGNO_VAR_DIAS_VIGENCIA * c_cursor.VAR_DIAS_VIGENCIA,
           0,
           2,
           0,
           0,
           0,
           0,
           1,
           1,
           1,
           an_aux);
      end loop;

      for c_cursor in c_promo_update loop

        if (c_cursor.var_porcentaje is not null) and
           (c_cursor.var_monto is null) then
          an_aux := 4; -- Tipo Dscto Porcentaje
        end if;
        if (c_cursor.var_monto is not null) and
           (c_cursor.var_porcentaje is null) then
          an_aux := 1; -- Tipo Dscto Cantidad
        end if;

        update promocion
           set dscprom     = c_cursor.descripcion,
               prioridad   = c_cursor.prioridad,
               limiteaplic = c_cursor.limite_aplicacion,
               fchini      = c_cursor.fecha_inicio,
               fchfin      = c_cursor.fecha_fin,
               afectacnr   = c_cursor.flg_afectacnr,
               afectacr    = c_cursor.flg_afectacr,
               cantidad    = c_cursor.var_monto * c_cursor.signo_var_monto,
               porcentaje  = c_cursor.var_porcentaje *
                             c_cursor.signo_var_porcentaje,
               duracion    = c_cursor.signo_var_dias_vigencia *
                             c_cursor.var_dias_vigencia,
               idtipprom   = an_aux
         where idprom_en_linea = c_cursor.idpromocion;

      end loop;
      --Fin 25.0

    exception
      when others then
        p_graba_log('Error en transferencia a PESGAINT: Actualiza_BDweb',
                    sqlerrm); --19.0
        opewf.pq_send_mail_job.p_send_mail('Error en transferencia a PESGAINT',
                                           'DL-PE-ITSoportealNegocio', --26.0
                                           'No se ha podido actualizar los registros de DTH en PESGAINT');
    end;

    commit;

  end p_job_actualiza_bdweb;

  procedure p_job_transfer_bdweb (p_resultado IN OUT VARCHAR2,
                                  p_mensaje   IN OUT VARCHAR2) is --35.0
    --  Job que transfiere todos los registros por la madrugada
    --<14.0
    ln_estinsprd insprd.estinsprd%type;
    ln_num_act   number;
    ln_num_sus   number;
    ls_mensaje   varchar2(4000);--35.0

    --<20.0
    --ini 22.0
    /*cursor c_reginsdth is
    select \*+ RULE*\ --20.0
     x.numregistro,
     x.codinssrv,
     s.tipsrv,
     s.codsrv,
     x.nrodoccon,
     x.fecactconax,
     x.fecinivig,
     x.fecfinvig,
     x.fecalerta,
     x.feccorte,
     x.estado,
     (select e.dscestdth from estregdth e where e.codestdth = x.estado) dscestdth,
     x.nomcli,
     x.numslc,
     x.codcli,
     x.idpaq,
     x.codsolot,
     x.pid,
     s.cid,
     p.nrodoc,
     0 idcontrato,
     null nrodoc_contrato,
     f.estinsprd,
     0 flgtransferir,
     (select decode(tipdide, '001', ntdide, '0000000000')
        from vtatabcli --REQ 87889
       where codcli = s.codcli) ruc, --REQ 87889
     x.codigo_recarga -- REQ 99155
      from reginsdth x, vtatabpspcli p, inssrv s, insprd f
     where x.numslc is not null
       and x.numslc = p.numslc
       and x.pid = f.pid
       and x.codinssrv = s.codinssrv
       and f.estinsprd not in (3, 4) -- <13.0> Solo se incluyen servicios activos y suspendidos
          -- and x.estado not in ('18','05','06','12') --<12.0>
       and (nvl((select tipoestado
                  from estregdth
                 where codestdth = x.estado),
                0) <> 3) --<12.0>
    ;*/
    --fin 22.0
    cursor c_recarga_det(p_numregistro ope_srv_recarga_det.numregistro%type) is
      select a.numregistro,
             a.codinssrv,
             a.tipsrv,
             a.codsrv,
             a.fecact,
             a.fecbaja,
             a.pid,
             a.estado,
             a.ulttareawf
        from ope_srv_recarga_det a
       where a.numregistro = p_numregistro
         and a.tipsrv in (select c.valor
                            from constante c
                           where c.constante = 'FAM_CABLE');

    cursor c_bouquet_mae is
      select x.idbouquet, x.codbouquet, x.descripcion, x.flg_activo
        from ope_bouquet_mae x;

    cursor c_grupo_bouquet_det is
      select idgrupo, codbouquet, flg_activo from ope_grupo_bouquet_det x;

    cursor c_bouquetxreginsdth(ac_numregistro ope_srv_recarga_det.numregistro%type) is
      select x.*
        from bouquetxreginsdth x
       where x.numregistro = ac_numregistro
         and x.estado = 1; --solo transfiere los activos

    --20.0>

    cursor c_recarga_cab is
      select /*+ RULE*/ --20.00
       x.numregistro,
       x.fecinivig,
       x.fecfinvig,
       x.fecalerta,
       x.feccorte,
       x.estado,
       (select e.descripcion
          from ope_estado_recarga e
         where e.codestrec = x.estado) dscestdth,
       (select nomcli from vtatabcli where codcli = x.codcli) nomcli,
       x.numslc,
       x.codcli,
       x.idpaq,
       x.codsolot,
       p.nrodoc,
       0 idcontrato,
       null nrodoc_contrato,
       --0 estinsprd,
       0 flgtransferir,
       (select decode(tipdide, '001', ntdide, '0000000000')
          from vtatabcli
         where codcli = x.codcli) ruc,
       --ini 31.0
       x.fecusu,
       --fin 31.0
       x.codigo_recarga,
       x.flg_sc --33.0
      --from recargaproyectocliente x, --17.0
        from ope_srv_recarga_cab x, --17.0
             vtatabpspcli        p
       where x.numslc is not null
         and x.numslc = p.numslc
            --and (nvl((select tipoestado from estregdth where codestdth = x.estado),0) <> 3)
         and x.estado <> '04' --no se incluyen los registros en estado cancelado, tabla ope_estado_recarga
            --ini 22.0
         and x.tipbqd = 4 --solo se envia DTH, no CDMA
      --fin 22.0
      ;

    --14.0>

    --ini 28.0
    cursor cur_agentes_recarga is
      select AGENTERECARGA,
             PASSWORD,
             CODCLI,
             IDPROM,
             ESTADO,
             CONDICION_EXTORNO
        from REC_AGENTE_RECARGA_MAE;
    --fin 28.0

  begin

    begin
      delete from vtatabrecargaxpaquete_web;

      insert into vtatabrecargaxpaquete_web
        (idpaq,
         idrecarga,
         descripcion,
         tipvigencia,
         vigencia,
         monto,
         estado,
         codusu,
         fecusu,
         flg_defecto) --34.0
        select a.idpaq,
               a.idrecarga,
               b.descripcion,
               b.tipvigencia,
               b.vigencia,
               b.monto,
               a.estado,
               a.codusu,
               a.fecusu,
               a.flg_defecto --34.0
          from vtatabrecargaxpaquete a, vtatabrecarga b
         where a.idrecarga = b.idrecarga
           and a.estado = 1;
           null;
    exception
      when others then
        p_graba_log('Error en transferencia a PESGAINT', sqlerrm); --19.0
        rollback;
        opewf.pq_send_mail_job.p_send_mail('Error en transferencia a PESGAINT',
                                           'DL-PE-ITSoportealNegocio', --26.0
                                           'No se ha podido transferir los precios de recarga a PESGAINT');
    end;

    --30.0 Suma de Cargos: 1 - Cargo los precios de los paquetes: REC_DETPAQ_RECARGA_MAE
    BEGIN
      PQ_vta_PAQUETE_recarga.P_JOB_CONFIGURAPAQ_MAE;
    EXCEPTION
      when others then
        p_graba_log('Error en transferencia a PESGAINT', sqlerrm);
        rollback;
        opewf.pq_send_mail_job.p_send_mail('Error en transferencia a PESGAINT',
                                           'DL-PE-ITSoportealNegocio',
                                           'No se ha podido transferir los precios de recarga a PESGAINT');

    END;

    commit;

    begin
      delete from reginsdth_web;
      --<20.0
      delete from rec_srv_recarga_det;
      delete from rec_bouquet_mae;
      delete from rec_grupo_bouquet_det;
      delete from rec_bouquetxreginsdth_cab;
      --ini 28.0
      delete from reg_agente_recarga_mae;
      --fin 28.0

      --30.0 Suma de Cargos: 2 - Borramos tablas de servicios REC_INSSRV_CAB, REC_INSPRD_DET
      -- Ini 33.0
      /*DELETE FROM REC_INSSRV_CAB;
      DELETE FROM REC_INSPRD_DET;*/
      -- Fin 33.0
      /*
        insert into reginsdth_web
          (numregistro,
           nrodoccon,
           fecactconax,
           fecinivig,
           fecfinvig,
           fecalerta,
           feccorte,
           estado,
           dscestdth,
           nomcli,
           numslc,
           codcli,
           idpaq,
           codsolot,
           pid,
           cid,
           nrodoc,
           idcontrato,
           nrodoc_contrato,
           estinsprd,
           flgtransferir,
           ruc, --REQ 87889
            CODIGO_RECARGA  -- REQ 99155
           )
          select x.numregistro,
                 x.nrodoccon,
                 x.fecactconax,
                 x.fecinivig,
                 x.fecfinvig,
                 x.fecalerta,
                 x.feccorte,
                 x.estado,
                (select e.dscestdth from estregdth e where  e.codestdth = x.estado),
                 x.nomcli,
                 x.numslc,
                 x.codcli,
                 x.idpaq,
                 x.codsolot,
                 x.pid,
                 s.cid,
                 p.nrodoc,
                 0,
                 null,
                 f.estinsprd,
                 0 flgtransferir,
                (select decode(tipdide,'001',ntdide,'0000000000') from vtatabcli --REQ 87889
                   where codcli = s.codcli) ruc, --REQ 87889
                 x.codigo_recarga -- REQ 99155
           from reginsdth     x,
                vtatabpspcli  p,
                inssrv        s,
                insprd        f
           where x.numslc is not null
             and x.numslc = p.numslc
             and x.pid = f.pid
             and x.codinssrv = s.codinssrv
             and f.estinsprd not in (3, 4) -- <13.0> Solo se incluyen servicios activos y suspendidos
                -- and x.estado not in ('18','05','06','12') --<12.0>
            and (nvl((select tipoestado from estregdth where codestdth = x.estado) ,0) <> 3) --<12.0>
          ;
      */
      --ini 22.0
      /*for r_reginsdth in c_reginsdth loop

        insert into reginsdth_web
          (numregistro,
           nrodoccon,
           fecactconax,
           fecinivig,
           fecfinvig,
           fecalerta,
           feccorte,
           estado,
           dscestdth,
           nomcli,
           numslc,
           codcli,
           idpaq,
           codsolot,
           pid,
           cid,
           nrodoc,
           idcontrato,
           nrodoc_contrato,
           estinsprd,
           flgtransferir,
           ruc, --REQ 87889
           codigo_recarga -- REQ 99155
           )
        values
          (r_reginsdth.numregistro,
           r_reginsdth.nrodoccon,
           r_reginsdth.fecactconax,
           r_reginsdth.fecinivig,
           r_reginsdth.fecfinvig,
           r_reginsdth.fecalerta,
           r_reginsdth.feccorte,
           r_reginsdth.estado,
           r_reginsdth.dscestdth,
           r_reginsdth.nomcli,
           r_reginsdth.numslc,
           r_reginsdth.codcli,
           r_reginsdth.idpaq,
           r_reginsdth.codsolot,
           r_reginsdth.pid,
           r_reginsdth.cid,
           r_reginsdth.nrodoc,
           r_reginsdth.idcontrato,
           r_reginsdth.nrodoc_contrato,
           r_reginsdth.estinsprd,
           r_reginsdth.flgtransferir,
           r_reginsdth.ruc, --REQ 87889
           r_reginsdth.codigo_recarga -- REQ 99155
           );

        insert into rec_srv_recarga_det
          (numregistro,
           codinssrv,
           tipsrv,
           codsrv,
           fecact,
           fecbaja,
           pid,
           estado,
           ulttareawf)
        values
          (r_reginsdth.numregistro,
           r_reginsdth.codinssrv,
           r_reginsdth.tipsrv,
           r_reginsdth.codsrv,
           r_reginsdth.fecinivig,
           r_reginsdth.fecfinvig,
           r_reginsdth.pid,
           r_reginsdth.estado,
           null);

        for c1 in c_bouquetxreginsdth(r_reginsdth.numregistro) loop
          insert into rec_bouquetxreginsdth_cab
            (numregistro,
             codsrv,
             bouquets,
             tipo,
             estado,
             codusu,
             fecusu,
             flg_transferir,
             flg_rectransferir,
             fecultenv,
             usumod,
             fecmod,
             fecha_inicio_vigencia,
             fecha_fin_vigencia,
             idcupon)
          values
            (c1.numregistro,
             c1.codsrv,
             c1.bouquets,
             c1.tipo,
             c1.estado,
             c1.codusu,
             c1.fecusu,
             c1.flg_transferir,
             1, --flg_rectransferir
             c1.fecultenv,
             c1.usumod,
             c1.fecmod,
             c1.fecha_inicio_vigencia,
             c1.fecha_fin_vigencia,
             c1.idcupon);

        end loop;

      end loop;*/
      --fin 22.0

      for r_bouquet_mae in c_bouquet_mae loop
        insert into rec_bouquet_mae
          (idbouquet, codbouquet, descripcion, flg_activo)
        values
          (r_bouquet_mae.idbouquet,
           r_bouquet_mae.codbouquet,
           r_bouquet_mae.descripcion,
           r_bouquet_mae.flg_activo);
      end loop;

      for r_grupo_bouquet_det in c_grupo_bouquet_det loop
        insert into rec_grupo_bouquet_det
          (idgrupo, codbouquet, flg_activo)
        values
          (r_grupo_bouquet_det.idgrupo,
           r_grupo_bouquet_det.codbouquet,
           r_grupo_bouquet_det.flg_activo);
      end loop;

      --20.0>
      --<14.0, se transfiere de las nuevas estructuras de recarga
      for r_recarga_cab in c_recarga_cab loop
        select count(1)
          into ln_num_act
        --from recargaxinssrv a,insprd b --17.0
          from ope_srv_recarga_det a, insprd b --17.0
         where a.numregistro = r_recarga_cab.numregistro
           and a.pid = b.pid
           and b.estinsprd = 1; --activos

        ln_estinsprd := 0;

        if ln_num_act = 0 then
          select count(1)
            into ln_num_sus
          --from recargaxinssrv a,insprd b --17.0
            from ope_srv_recarga_det a, insprd b --17.0
           where a.numregistro = r_recarga_cab.numregistro
             and a.pid = b.pid
             and b.estinsprd = 2; --suspendidos

          if ln_num_sus > 0 then
            ln_estinsprd := 2; --si no tiene activos pero tiene al menos uno suspendido
          end if;
        else
          ln_estinsprd := 1; --si tiene al menos uno activo
        end if;

        if ln_estinsprd > 0 then
          insert into reginsdth_web
            (numregistro,
             fecinivig,
             fecfinvig,
             fecalerta,
             feccorte,
             estado,
             dscestdth,
             nomcli,
             numslc,
             codcli,
             idpaq,
             codsolot,
             nrodoc,
             idcontrato,
             nrodoc_contrato,
             estinsprd,
             flgtransferir,
             ruc,
             codigo_recarga)
          values
            (r_recarga_cab.numregistro,
             r_recarga_cab.fecinivig,
             r_recarga_cab.fecfinvig,
             r_recarga_cab.fecalerta,
             r_recarga_cab.feccorte,
             r_recarga_cab.estado,
             r_recarga_cab.dscestdth,
             r_recarga_cab.nomcli,
             r_recarga_cab.numslc,
             r_recarga_cab.codcli,
             r_recarga_cab.idpaq,
             r_recarga_cab.codsolot,
             r_recarga_cab.nrodoc,
             r_recarga_cab.idcontrato,
             r_recarga_cab.nrodoc_contrato,
             ln_estinsprd,
             r_recarga_cab.flgtransferir,
             r_recarga_cab.ruc,
             r_recarga_cab.codigo_recarga);

          --<20.0
          for r_recarga_det in c_recarga_det(r_recarga_cab.numregistro) loop
            begin--35.0
            insert into rec_srv_recarga_det
              (numregistro,
               codinssrv,
               tipsrv,
               codsrv,
               fecact,
               fecbaja,
               pid,
               estado,
               ulttareawf)
            values
              (r_recarga_det.numregistro,
               r_recarga_det.codinssrv,
               r_recarga_det.tipsrv,
               r_recarga_det.codsrv,
               r_recarga_det.fecact,
               r_recarga_det.fecbaja,
               r_recarga_det.pid,
               r_recarga_det.estado,
               r_recarga_det.ulttareawf);
             --<35.0
                   exception
               when others then
               p_graba_log('Error en insercion de Registros de Recarga', sqlerrm); 
               --rollback;--36.0
               
               ls_mensaje :=ls_mensaje||'**Error:'||sqlerrm||'/'||to_char(r_recarga_det.fecbaja,'dd/mm/yyyy hh:mm:ss')||trim(r_recarga_det.numregistro)||'/';--36.0
               ls_mensaje := ls_mensaje||trim(r_recarga_cab.codigo_recarga)||'/'||trim(r_recarga_det.codinssrv)||'/'||trim(r_recarga_det.estado);
          
                           
                  p_resultado := '-1';
                  p_mensaje := ls_mensaje;
                end ;      
             --35.0>

            --ini 31.0
            --solo se consideran registros a partir de la implementacion
            --de la funcionalidad de suma de cargos
            /*if r_recarga_cab.fecusu >= gd_fec_sum_cargos then*/ --33.0
            --fin 31.0
                --Ini 32.0
                --Se valida aqui si proyecto es suma de cargos
                -- Ini 33.0
                /*--If PQ_VTA_PAQUETE_INSTANCIA.F_VALIDA_VENTA(r_recarga_cab.numslc)=1 then
                --Ini 30.0 Suma de Cargos: 3 - Cargamos tablas de servicios REC_INSSRV_CAB, REC_INSPRD_DET
                   PQ_VTA_PAQUETE_recarga.P_INS_SERVICIO(r_recarga_det.codinssrv);
                   --Fin 30.0
                end if;*/
                -- Fin 33.0
                --Fin 32.0
            --ini 31.0
            --end if;
            --fin 31.0
          end loop;

          for c1 in c_bouquetxreginsdth(r_recarga_cab.numregistro) loop
            insert into rec_bouquetxreginsdth_cab
              (numregistro,
               codsrv,
               bouquets,
               tipo,
               estado,
               codusu,
               fecusu,
               flg_transferir,
               flg_rectransferir,
               fecultenv,
               usumod,
               fecmod,
               fecha_inicio_vigencia,
               fecha_fin_vigencia,
               IDGRUPO, --30.0
               pid --30.0
               )
            values
              (c1.numregistro,
               c1.codsrv,
               c1.bouquets,
               c1.tipo,
               c1.estado,
               c1.codusu,
               c1.fecusu,
               c1.flg_transferir,
               1,
               c1.fecultenv,
               c1.usumod,
               c1.fecmod,
               c1.fecha_inicio_vigencia,
               c1.fecha_fin_vigencia,
               c1.IDGRUPO, --30.0
               c1.pid --30.0
               );

          end loop;

          --20.0>

        end if;
      end loop;
	   --<36.0
       if ls_mensaje is not null then
      
          opewf.pq_send_mail_job.p_send_mail('Error en insercion de Registros de Recarga',
                                           'DL-PE-ITSoportealNegocio', 
                                           ls_mensaje);
                  
                  p_resultado := '-1';
                  p_mensaje := ls_mensaje;
       end if;
	   --36.0>
      --14.0>
      -- Ini 33.0
      for r_anu in ( select d.codinssrv
                      from ope_srv_recarga_cab x,
                           ope_srv_recarga_det d
                     where x.numslc is not null
                       and x.estado = '04'
                       and x.tipbqd = 4
                       and x.numregistro = d.numregistro
                       and d.tipsrv in (select c.valor
                                          from constante c
                                         where c.constante = 'FAM_CABLE')
                       and x.flg_sc = 1)
                            loop
        delete from rec_insprd_det d where d.codinssrv = r_anu.codinssrv;
        delete from rec_inssrv_cab c where c.codinssrv = r_anu.codinssrv;
      end loop;

     sales.pq_vta_paquete_recarga.p_act_servicio;
     -- Fin 33.0

      --ini 28.0
      for reg in cur_agentes_recarga loop
        insert into REG_AGENTE_RECARGA_MAE
          (agenterecarga,
           password,
           codcli,
           idprom,
           estado,
           condicion_extorno)
        values
          (reg.agenterecarga,
           reg.password,
           reg.codcli,
           reg.idprom,
           reg.estado,
           reg.condicion_extorno);
      end loop;
      --fin 28.0

    exception
      when others then
        p_graba_log('Error en transferencia a PESGAINT', sqlerrm); --19.0
        rollback;
        opewf.pq_send_mail_job.p_send_mail('Error en transferencia a PESGAINT',
                                           'DL-PE-ITSoportealNegocio', --26.0
                                           'No se ha podido transferir los registros de DTH a PESGAINT');
    end;
    commit;
  end p_job_transfer_bdweb;

  procedure p_job_ejecuta_reconexion is
    --<14.0
    /*
    cursor c_reconexion is
     select *
       from reconexiondth_web
      where flgtransferir = 1; */
    cursor c_reconexion is
      select a.idcupon, b.numregistro, c.estado, c.codinssrv, c.pid
        from reconexiondth_web a, cuponpago_dth_web b, reginsdth c
       where a.flgtransferir = 1
         and a.idcupon = b.idcupon
         and b.numregistro = c.numregistro;
    --14.0>
    --<14.0
    /*ls_estado    reginsdth.estado%type; --<9.0
    ls_codinssrv inssrv.codinssrv%type;
    ls_pid       insprd.pid%type;
    ls_numregistro reginsdth.numregistro%type;--9.0>
    */
    --14.0>
    ls_resultado varchar2(100);
    ls_mensaje   varchar2(100);
  begin
    --REQ 90271 inicio
    -- Se verifica reconexiones de DTH ejecutados previamente
    p_job_verifica_reconexion;
    -- Generacion de nuevas reconexiones
    --REQ 90271 fin
    for r_reconexion in c_reconexion loop
      --<14.0
      /*
      select b.estado,--<9.0
             b.numregistro,
             b.codinssrv,
             b.pid--9.0>
        into ls_estado,--<9.0
             ls_numregistro,
             ls_codinssrv,
             ls_pid --9.0>
        from cuponpago_dth_web a, reginsdth b
       where a.idcupon = r_reconexion.idcupon
         and a.numregistro = b.numregistro */

      --14.0>
      --if ls_estado = '16' then --14.0
      if r_reconexion.estado = '16' then
        --14.0 --corte de servicio
        operacion.pq_dth.p_reconexion_dth(r_reconexion.pid,
                                          ls_resultado,
                                          ls_mensaje);
        if ls_resultado = 'OK' then
          update reconexiondth_web
             set flgtransferir = 2
           where idcupon = r_reconexion.idcupon;
        end if;
        --<9.0
      else
        --if ls_estado in ('07','17') then --14.0
        if r_reconexion.estado in ('07', '17') then
          --14.0
          update insprd
             set estinsprd = 1
          --where pid = ls_pid --14.0
           where pid = r_reconexion.pid --14.0
             and estinsprd = 2;
          update inssrv
             set estinssrv = 1
          --where codinssrv = ls_codinssrv --14.0
           where codinssrv = r_reconexion.codinssrv --14.0
             and estinssrv = 2;
          -- Se actualiza estado del servicio en PESGAINT
          update reginsdth_web
             set estinsprd = 1
          --where numregistro = ls_numregistro; --14.0
           where numregistro = r_reconexion.numregistro; --14.0
          update reconexiondth_web
             set flgtransferir = 2
           where idcupon = r_reconexion.idcupon;
        end if;
        --9.0>
      end if;
      commit;
    end loop;
  end p_job_ejecuta_reconexion;
  --<REQ ID=84617>
  procedure p_job_ejecuta_reconexion_adic is
    cursor c_bouquets is
      select distinct numregistro
        from bouquetxreginsdth
       where flg_transferir = 1;
    ls_resultado varchar2(100);
    ls_mensaje   varchar2(100);
  begin
    for r_bouquets in c_bouquets loop
      operacion.pq_dth.p_reconexion_adic_dth(r_bouquets.numregistro,
                                             ls_resultado,
                                             ls_mensaje);
      if ls_resultado = 'OK' then
        update bouquetxreginsdth
           set flg_transferir = 0, fecultenv = sysdate
         where numregistro = r_bouquets.numregistro
           and flg_transferir = 1;
        commit;
      end if;
    end loop;
  end p_job_ejecuta_reconexion_adic;
  --</REQ>
  procedure p_job_ejecuta_corte is
    cursor c_corte is
      select *
        from cortedth_web
       where flgtransferir = 1 --ini 21.0  ;
         and pid is not null
       order by idcupon;
    --fin 21.0

    ls_resultado   varchar2(100);
    ls_mensaje     varchar2(100);
    ls_numregistro reginsdth.numregistro%type;
    ln_idctrlcorte number;
  begin
    -- Se verifica cortes ejecutados previamente
    p_job_verifica_corte;
    -- Generacion de nuevos cortes
    for r_corte in c_corte loop
      -- Obtenemos el numero de registro asociado al corte
      select numregistro
        into ls_numregistro
        from cuponpago_dth_web
       where idcupon = r_corte.idcupon;
      select sq_ctrlcortedth.nextval into ln_idctrlcorte from dummy_ope;
      insert into operacion.control_corte_dth
        (idctrlcorte, numregistro, feccortereal, estcorte, motivo, tipo)
      values
        (ln_idctrlcorte,
         ls_numregistro,
         sysdate,
         1,
         'CORTE POR EXTORNO',
         'CORTE');
      operacion.pq_dth.p_corte_dth(r_corte.pid, ls_resultado, ls_mensaje);
      if ls_resultado = 'OK' then
        update cortedth_web
           set flgtransferir = 2
         where idcupon = r_corte.idcupon;
        -- Se pasa a estado corte enviado al CONAX
        update control_corte_dth
           set estcorte = 2
         where idctrlcorte = ln_idctrlcorte;
      else
        -- Se pasa a estado corte anulado
        update control_corte_dth
           set estcorte = 9
         where idctrlcorte = ln_idctrlcorte;
      end if;
      commit;
    end loop;
  end p_job_ejecuta_corte;

  -- ini 27.0
  procedure p_job_migra_promocion_en_linea is

    cursor c_promo_insert is
      select pi.*
        from fac_promocion_en_linea_mae pi, fac_tipo_promocion_mae t
       where pi.idtipo_promocion = t.idtipo_promocion
         and pi.idpromocion not in
             (select pf.idprom_en_linea
                from promocion pf
               where pf.idprom_en_linea is not null);

    cursor c_promo_update is
      select fac_promocion_en_linea_mae.*
        from fac_promocion_en_linea_mae, fac_tipo_promocion_mae
       where fac_promocion_en_linea_mae.idtipo_promocion =
             fac_tipo_promocion_mae.idtipo_promocion
         and fac_tipo_promocion_mae.clase = 3;

    an_aux number;

  begin

    for c_cursor in c_promo_insert loop

      an_aux := null; -- Tipo Dscto Nulo

      if (c_cursor.var_porcentaje is not null) and
         (c_cursor.var_monto is null) then
        an_aux := 4; -- Tipo Dscto Porcentaje
      end if;
      if (c_cursor.var_monto is not null) and
         (c_cursor.var_porcentaje is null) then
        an_aux := 1; -- Tipo Dscto Cantidad
      end if;

      insert into PROMOCION
        (DSCPROM,
         PRIORIDAD,
         LIMITEAPLIC,
         FCHINI,
         FCHFIN,
         AFECTACNR,
         AFECTACR,
         flg_prom_en_linea,
         idprom_en_linea,
         flgact,
         estado,
         cantidad,
         porcentaje,
         duracion,
         cabdet,
         nivel,
         deptiphor,
         deptipuso,
         excluyente,
         visible,
         afecta,
         aplicainstprod,
         depinstprod,
         idtipprom)
      values
        (c_cursor.DESCRIPCION,
         c_cursor.PRIORIDAD,
         c_cursor.LIMITE_APLICACION,
         c_cursor.FECHA_INICIO,
         c_cursor.FECHA_FIN,
         c_cursor.FLG_AFECTACNR,
         c_cursor.FLG_AFECTACR,
         1,
         c_cursor.IDPROMOCION,
         1,
         1,
         c_cursor.var_monto * c_cursor.signo_var_monto,
         c_cursor.var_porcentaje * c_cursor.signo_var_porcentaje,
         c_cursor.SIGNO_VAR_DIAS_VIGENCIA * c_cursor.VAR_DIAS_VIGENCIA,
         0,
         2,
         0,
         0,
         0,
         0,
         1,
         1,
         1,
         an_aux);
    end loop;

    for c_cursor in c_promo_update loop

      an_aux := null; -- Tipo Dscto Nulo

      if (c_cursor.var_porcentaje is not null) and
         (c_cursor.var_monto is null) then
        an_aux := 4; -- Tipo Dscto Porcentaje
      end if;
      if (c_cursor.var_monto is not null) and
         (c_cursor.var_porcentaje is null) then
        an_aux := 1; -- Tipo Dscto Cantidad
      end if;

      update promocion
         set dscprom     = c_cursor.descripcion,
             prioridad   = c_cursor.prioridad,
             limiteaplic = c_cursor.limite_aplicacion,
             fchini      = c_cursor.fecha_inicio,
             fchfin      = c_cursor.fecha_fin,
             afectacnr   = c_cursor.flg_afectacnr,
             afectacr    = c_cursor.flg_afectacr,
             cantidad    = c_cursor.var_monto * c_cursor.signo_var_monto,
             porcentaje  = c_cursor.var_porcentaje *
                           c_cursor.signo_var_porcentaje,
             duracion    = c_cursor.signo_var_dias_vigencia *
                           c_cursor.var_dias_vigencia,
             idtipprom   = an_aux
       where idprom_en_linea = c_cursor.idpromocion;

    end loop;

    commit;
  end;
  -- fin 27.0

  procedure p_job_migra_cuponpago is

    --ln_tipo number; --14.0 --1 DTH, 2 DTH + CDMA --17.0

    cursor c_cuponpago is
    --<17.0
    /*select *
                                                                  from cuponpago_dth_web
                                                                 where flgtransferir = 1;*/
      select a.*
        from cuponpago_dth_web a, reginsdth b
       where a.numregistro = b.numregistro
                and a.flgtransferir = 1;
    --17.0>
    cursor c_rec_pendientes_pago(a_numregistro varchar2, ppid number) is
    --<REQ ID = 98037>
    /*select rownum orden, x.idfac, x.sersut, x.numsut from
                                                                            (*/
    --</REQ>
      select distinct f.idfac, f.sersut, f.numsut
        from cxctabfac f, bilfac b, cr c, instxproducto i
       where f.idfac = b.idfaccxc
         and b.idbilfac = c.idbilfac
         and c.idinstprod = i.idinstprod
            --<14.0
         and i.pid = ppid --17.0
            --<17.0
            /*and i.pid in (select ppid from dummy_ope where 1 = ln_tipo
                                                                                                                                                                                                           union all
                                                                                                                                                                                                         select pid from recargaxinssrv where 2 = ln_tipo
                                                                                                                                                                                                         and numregistro = a_numregistro)*/
            --17.0>
            --14.0>
            --and f.estfac != '05' --REQ 93539
         and f.estfac not in ('01', '05', '06') --REQ 93539
       order by 3 desc
      --<REQ ID = 98037>
      /*) x
                                                                                                 where rownum = 1*/
      ;
    --</REQ>
    ll_reconec number;
    --ln_num number; --14.0 --17.0

  begin

    for r_cuponpago in c_cuponpago loop

      --<14.0
      --<17.0
      /*select count(1) into ln_num
        from recargaproyectocliente
       where numregistro = r_cuponpago.numregistro;

      if ln_num > 0 then
        ln_tipo := 2;
      else
        ln_tipo := 1;
        end if;*/
      --17.0>
      --14.0>
      --1. Transferir el pago a PESGAPRD
      insert into cuponpago_dth
        (idcupon,
         codcli,
         cantidad,
         monto,
         estado,
         feccargo,
         desde,
         hasta,
         numregistro,
         pid,
         idinstprod,
         idlote,
         iddet,
         contrato,
         idcuponpagoweb,
         nroconfir,
         idterminal,
         agenterecarga,
         idpaq,
         cid,
         flgliquidacion,
         numser, ----REQ 87889
         numsut, ----REQ 87889
         idbilfac, ----REQ 87889
         codigo_recarga -- REQ 99155
         )
      values
        (r_cuponpago.idcupon,
         r_cuponpago.codcli,
         r_cuponpago.cantidad,
         r_cuponpago.monto,
         r_cuponpago.estado,
         r_cuponpago.feccargo,
         r_cuponpago.desde,
         r_cuponpago.hasta,
         r_cuponpago.numregistro,
         r_cuponpago.pid,
         r_cuponpago.idinstprod,
         r_cuponpago.idlote,
         r_cuponpago.iddet,
         r_cuponpago.contrato,
         r_cuponpago.idcupon,
         r_cuponpago.refnumber,
         r_cuponpago.idterminal,
         r_cuponpago.agenterecarga,
         r_cuponpago.idpaq,
         r_cuponpago.cid,
         nvl(r_cuponpago.flgliquidacion, 0), /*19.0: para el caso de Traslados*/
         r_cuponpago.numser, --REQ 87889
         r_cuponpago.numsut, --REQ 87889
         r_cuponpago.idbilfac, --REQ 87889
         r_cuponpago.codigo_recarga -- REQ 99155
         );

      update cuponpago_dth_web
         set flgtransferir = 2
       where idcupon = r_cuponpago.idcupon;
      --<REQ ID = '84617'>
      -- Se verifica si se ha generado reconexion
      select count(1)
        into ll_reconec
        from reconexiondth_web
       where idcupon = r_cuponpago.idcupon;
      if ll_reconec = 0 then
        update operacion.bouquetxreginsdth
           set flg_transferir = 1
         where numregistro = r_cuponpago.numregistro
           and tipo = 0
           and estado = 0;
      end if;
      --</REQ>
      --2. Anular los documentos en estado generado para que no se emitan
      update bilfac
         set estfac = '06'
       where estfac = '01'
         and idbilfac in (select distinct idbilfac
                            from cr, instxproducto i
                           where cr.idinstprod = i.idinstprod
                                --<14.0
                                --<17.0
                             and i.pid = r_cuponpago.pid);
      /*and i.pid in (select r_cuponpago.pid from dummy_ope where 1 = ln_tipo
      union all
                             select pid from recargaxinssrv where 2 = ln_tipo
                             and numregistro = r_cuponpago.numregistro));*/
      --17.0>
      --14.0>
      --3. Generar N/C por los documentos pendientes de pago
      for r_rec_pend_pago in c_rec_pendientes_pago(r_cuponpago.numregistro,
                                                   r_cuponpago.pid) loop
        collections.pq_notacredito_automatica.p_ncrecarga_dth(r_rec_pend_pago.idfac,
                                                              r_rec_pend_pago.sersut,
                                                              r_cuponpago.refnumber,
                                                              r_cuponpago.feccargo);
      end loop;

      --<14.0
      --<17.0
      /*if ln_tipo = 2 then
        pq_control_inalambrico.p_crea_sot_pago(r_cuponpago.numregistro,r_cuponpago.idcupon);
      end if;*/
      --17.0>
      --14.0>
      commit;

    end loop;

  end p_job_migra_cuponpago;

  procedure p_migra_sistema_brightstar(ln_idtipfac number,
                                       ls_codcli   char,
                                       ln_pid      number) is
    --14.0 --17.0
    --procedure p_migra_sistema_brightstar(ln_idtipfac number,ls_codcli char,ln_pid number,a_numregistro number) is --14.0 --17.0
    cursor c_grupo(pidtipfac number, pcodcli char, ppid number) is --17.0
    --cursor c_grupo(pidtipfac number,pcodcli char,a_tipo number,pnumregistro varchar2,ppid number) is --17.0
      select distinct grupo, cicfac
        from instxproducto
      --<14.0
      --17.0
       where pid = ppid
            /*where pid in (select ppid from dummy_ope where 1 = a_tipo
                                                                                                                                                                                                         union all
                                                                                                                                                                                                        select pid from recargaxinssrv
                                                                                                                                                                                                          where numregistro = pnumregistro
                                                                                                                                                                                                        and 2 = a_tipo)*/
            --17.0>
            --14.0>
         and codcli = pcodcli
         and idtipfac = pidtipfac;

    nnuecicfac number;
    --ln_num number; --14.0 --17.0
    --ln_tipo number; --14.0 --17.0
  begin
    nnuecicfac := 28;
    --<14.0
    --<17.0
    /*select count(1) into ln_num
      from recargaxinssrv
     where numregistro = a_numregistro;

    if ln_num > 0 then
      ln_tipo := 2;
    else
      ln_tipo := 1;
     end if;*/
    --17.0>
    --14.0>
    --1. Migrar el servicio al sistema brightstar
    for r_grupo in c_grupo(ln_idtipfac, ls_codcli, ln_pid) loop
      --14.0 --17.0
      --for r_grupo in c_grupo(ln_idtipfac,ls_codcli,ln_tipo,a_numregistro,ln_pid) loop --14.0 --17.0

      -- Actualiza el ciclo en los tabgrupos afectados
      update tabgrupo
         set cicfac = nnuecicfac
       where idtipfac = ln_idtipfac
         and codcli = ls_codcli
         and cicfac = r_grupo.cicfac
         and grupo = r_grupo.grupo;

      -- Actualiza el ciclo en las instancias de promocion de ese cliente/Tipo Facturacion
      update instanciaxprom
         set cicfac = nnuecicfac
       where idinstprod in (select idinstprod
                              from instxproducto
                             where idtipfac = ln_idtipfac
                               and codcli = ls_codcli
                               and cicfac = r_grupo.cicfac
                               and grupo = r_grupo.grupo);

      -- Actualiza el ciclo en las instancias de producto de ese cliente/Tipo Facturacion
      update instxproducto
         set cicfac = nnuecicfac
       where idtipfac = ln_idtipfac
         and codcli = ls_codcli
         and cicfac = r_grupo.cicfac
         and grupo = r_grupo.grupo;

      p_graba_auditoria(22,
                        'Se cambio de Ciclo al Cliente ' || ls_codcli ||
                        ' para el grupo ' || to_char(r_grupo.grupo) ||
                        '. Paso al ciclo de Brightstar' ||
                        to_char(nnuecicfac) || '.',
                        ls_codcli,
                        to_char(nnuecicfac));

    end loop;

  end p_migra_sistema_brightstar;

  procedure p_migra_sistema_facturacion(ln_idtipfac number,
                                        ls_codcli   char,
                                        ln_pid      number) is
    cursor c_grupo(pidtipfac number, pcodcli char, ppid number) is
      select distinct grupo, cicfac
        from instxproducto
       where pid = ppid
         and codcli = pcodcli
         and idtipfac = pidtipfac;

    nnuecicfac number;
    ln_dia     number;
  begin

    select to_number(to_char(sysdate, 'dd')) into ln_dia from dummy_ope;

    if (ln_dia < 16) then
      nnuecicfac := 23; -- Ciclo al 16 DTH
    else
      nnuecicfac := 22; -- Ciclo al 1 DTH
    end if;

    --1. Migrar el servicio al sistema brightstar
    for r_grupo in c_grupo(ln_idtipfac, ls_codcli, ln_pid) loop

      -- Actualiza el ciclo en los tabgrupos afectados
      update tabgrupo
         set cicfac = nnuecicfac
       where idtipfac = ln_idtipfac
         and codcli = ls_codcli
         and cicfac = r_grupo.cicfac
         and grupo = r_grupo.grupo;

      -- Actualiza el ciclo en las instancias de promocion de ese cliente/Tipo Facturacion
      update instanciaxprom
         set cicfac = nnuecicfac
       where idinstprod in (select idinstprod
                              from instxproducto
                             where idtipfac = ln_idtipfac
                               and codcli = ls_codcli
                               and cicfac = r_grupo.cicfac
                               and grupo = r_grupo.grupo);

      -- Actualiza el ciclo en las instancias de producto de ese cliente/Tipo Facturacion
      update instxproducto
         set cicfac = nnuecicfac
       where idtipfac = ln_idtipfac
         and codcli = ls_codcli
         and cicfac = r_grupo.cicfac
         and grupo = r_grupo.grupo;

      p_graba_auditoria(22,
                        'Se cambio de Ciclo al Cliente ' || ls_codcli ||
                        ' para el grupo ' || to_char(r_grupo.grupo) ||
                        '. Paso al ciclo de Brightstar' ||
                        to_char(nnuecicfac) || '.',
                        ls_codcli,
                        to_char(nnuecicfac));

    end loop;

  end p_migra_sistema_facturacion;

  procedure p_job_migra_reginsdth is
    cursor c_reginsdth is
    --<17.0
    /*select numregistro,
                                                                         codcli,
                                                                         fecinivig,
                                                                         fecfinvig,
                                                                         fecalerta,
                                                                         feccorte,
                                                                         pid,
                                                                         estinsprd,
                                                                         flgtransferir
                                                                    from reginsdth_web
                                                                 where flgtransferir = 1;*/

      select a.numregistro,
             a.codcli,
             a.fecinivig,
             a.fecfinvig,
             a.fecalerta,
             a.feccorte,
             a.pid,
             a.estinsprd,
             a.flgtransferir
        from reginsdth_web a, reginsdth b
       where a.numregistro = b.numregistro
         and a.flgtransferir = 1;
    --17.0>
    ln_flg_recarga number;
    --ln_num number; --14.0 --17.0

  begin
    for r_reginsdth in c_reginsdth loop
      --<14.0
      --<17.0
      /*select count(1) into ln_num
       from reginsdth
      where numregistro = r_reginsdth.numregistro;

       if ln_num > 0 then*/
      --17.0>
      --14.0>
      select nvl(flg_recarga, 0)
        into ln_flg_recarga
        from reginsdth
       where numregistro = r_reginsdth.numregistro;

      update reginsdth
         set fecinivig   = r_reginsdth.fecinivig,
             fecfinvig   = r_reginsdth.fecfinvig,
             fecalerta   = r_reginsdth.fecalerta,
             feccorte    = r_reginsdth.feccorte,
             flg_recarga = 1
       where numregistro = r_reginsdth.numregistro;

      update insprd
         set estinsprd = r_reginsdth.estinsprd
       where pid = r_reginsdth.pid;

      update reginsdth_web
         set flgtransferir = 2
       where numregistro = r_reginsdth.numregistro;

      if ln_flg_recarga = 0 then
        p_migra_sistema_brightstar(1, r_reginsdth.codcli, r_reginsdth.pid); --14.0 --17.0
        --p_migra_sistema_brightstar(1,r_reginsdth.codcli,r_reginsdth.pid,r_reginsdth.numregistro);  --14.0 --17.0
      end if;

      commit;
      --end if; --14.0 --17.0
    end loop;
  end p_job_migra_reginsdth;

  --<20.0

  procedure p_job_migra_bouquetxreginsdth is
    --30.0 Suma de Cargos: 4 - Campos nuevos al BOUQUETXREGINSDTH: idgrupo y pid
    cursor c_bouquetxreginsdth is
      select numregistro,
             codsrv,
             bouquets,
             tipo,
             estado,
             codusu,
             fecusu,
             flg_transferir,
             fecultenv,
             usumod,
             fecmod,
             fecha_inicio_vigencia,
             fecha_fin_vigencia,
             idcupon,
             flg_instantanea, -- 25.0
             pid,
             idgrupo
        from rec_bouquetxreginsdth_cab
       where flg_rectransferir = 0
         and estado = 1;
    ln_cant number;
  begin
    for r_bouquetxreginsdth in c_bouquetxreginsdth loop
      --Se determina si existe el registro
      select count(*)
        into ln_cant
        from bouquetxreginsdth b
       where b.numregistro = r_bouquetxreginsdth.numregistro
         and b.bouquets = r_bouquetxreginsdth.bouquets
         and b.codsrv = r_bouquetxreginsdth.codsrv
         and ((b.fecha_inicio_vigencia =
             r_bouquetxreginsdth.fecha_inicio_vigencia and
             b.fecha_inicio_vigencia is not null) or
             b.fecha_inicio_vigencia is null);

      if ln_cant > 0 then
        --30.0 Suma de Cargos: 4 - Campos nuevos al BOUQUETXREGINSDTH: idgrupo y pid
        update bouquetxreginsdth r
           set codsrv                = r_bouquetxreginsdth.codsrv,
               bouquets              = r_bouquetxreginsdth.bouquets,
               tipo                  = r_bouquetxreginsdth.tipo,
               estado                = r_bouquetxreginsdth.estado,
               codusu                = r_bouquetxreginsdth.codusu,
               fecusu                = r_bouquetxreginsdth.fecusu,
               flg_transferir        = r_bouquetxreginsdth.flg_transferir,
               fecultenv             = r_bouquetxreginsdth.fecultenv,
               usumod                = r_bouquetxreginsdth.usumod,
               fecmod                = r_bouquetxreginsdth.fecmod,
               fecha_inicio_vigencia = r_bouquetxreginsdth.fecha_inicio_vigencia,
               fecha_fin_vigencia    = r_bouquetxreginsdth.fecha_fin_vigencia,
               flg_instantanea       = r_bouquetxreginsdth.flg_instantanea, -- 25.0
               idgrupo               = r_bouquetxreginsdth.idgrupo,
               pid                   = r_bouquetxreginsdth.pid
         where r.numregistro = r_bouquetxreginsdth.numregistro
           and r.bouquets = r_bouquetxreginsdth.bouquets
           and r.codsrv = r_bouquetxreginsdth.codsrv
           and ((r.fecha_inicio_vigencia =
               r_bouquetxreginsdth.fecha_inicio_vigencia and
               r.fecha_inicio_vigencia is not null) or
               r.fecha_inicio_vigencia is null);

        update rec_bouquetxreginsdth_cab
           set flg_rectransferir = 1
         where numregistro = r_bouquetxreginsdth.numregistro
           and bouquets = r_bouquetxreginsdth.bouquets
           and codsrv = r_bouquetxreginsdth.codsrv
           and fecha_inicio_vigencia =
               r_bouquetxreginsdth.fecha_inicio_vigencia;
      else
        --30.0 Suma de Cargos: 4 - Campos nuevos al BOUQUETXREGINSDTH: idgrupo y pid
        insert into bouquetxreginsdth
          (numregistro,
           codsrv,
           bouquets,
           tipo,
           estado,
           codusu,
           fecusu,
           flg_transferir,
           fecultenv,
           usumod,
           fecmod,
           fecha_inicio_vigencia,
           fecha_fin_vigencia,
           idcupon,
           flg_instantanea, -- 25.0
           idgrupo,
           pid)
        values
          (r_bouquetxreginsdth.numregistro,
           r_bouquetxreginsdth.codsrv,
           r_bouquetxreginsdth.bouquets,
           r_bouquetxreginsdth.tipo,
           r_bouquetxreginsdth.estado,
           r_bouquetxreginsdth.codusu,
           r_bouquetxreginsdth.fecusu,
           r_bouquetxreginsdth.flg_transferir,
           r_bouquetxreginsdth.fecultenv,
           r_bouquetxreginsdth.usumod,
           r_bouquetxreginsdth.fecmod,
           r_bouquetxreginsdth.fecha_inicio_vigencia,
           r_bouquetxreginsdth.fecha_fin_vigencia,
           r_bouquetxreginsdth.idcupon,
           r_bouquetxreginsdth.flg_instantanea, -- 25.0
           r_bouquetxreginsdth.idgrupo,
           r_bouquetxreginsdth.pid);

        update rec_bouquetxreginsdth_cab
           set flg_rectransferir = 1
         where numregistro = r_bouquetxreginsdth.numregistro
           and bouquets = r_bouquetxreginsdth.bouquets
           and codsrv = r_bouquetxreginsdth.codsrv
           and ((fecha_inicio_vigencia =
               r_bouquetxreginsdth.fecha_inicio_vigencia and
               fecha_inicio_vigencia is not null) or
               fecha_inicio_vigencia is null);

      end if;
      commit;
    end loop;

  end p_job_migra_bouquetxreginsdth;
  --20.0>

  procedure p_job_controldth is
    -- Job que controla la actualizacion de pesgaprd para ejecutar cada 5 minutos
    ln_existe_periodo number;
  begin
    select count(1)
      into ln_existe_periodo
      from cxcperiodo
     where estado = 1;
    if ln_existe_periodo = 1 then
      --<8.0
      --ini 16.0
      -- p_job_migra_cuponpago;
      --fin 16.0
      --ini 22.0
      /*p_job_migra_reginsdth;
      p_job_ejecuta_reconexion;
      p_job_ejecuta_corte;*/
      --fin 22.0
      --<20.0
      p_job_migra_bouquetxreginsdth;
      pq_fac_promocion_en_linea.p_job_gen_alta_bouquetxprom(sysdate, null);
      --20.0>
      pq_fac_promocion_en_linea.p_job_gen_alta_bouquetxprom2(sysdate, null); -- 25.0
      --ini 19.0 Genera Corte Bouquets promocionales
      --ini 29.0
      --pq_fac_promocion_en_linea.p_job_gen_corte_bouquetxprom(sysdate, null);
      --fin 29.0
      --fin 19.0
      /*     p_job_migra_cuponpago;
      p_job_migra_reginsdth;*/ --8.0>
      p_job_ejecuta_reconexion_adic;
    end if;
  end;

  procedure p_job_genera_corte(ld_feccorte date) is
    cursor c_regcorte is
      select *
        from reginsdth
       where flg_recarga = 1
            --and f_verifica_reclamo(numregistro) = 0
         and trunc(feccorte) <= trunc(ld_feccorte)
         and estado in ('07', '17');
    ln_idctrlcorte number;
    ls_resultado   varchar2(100);
    ls_mensaje     varchar2(100);
  begin
    p_actualiza_reclamo_dth;
    for r_regcorte in c_regcorte loop
      if f_verifica_reclamo(r_regcorte.codinssrv) = 0 then
        select sq_ctrlcortedth.nextval into ln_idctrlcorte from dummy_ope;
        insert into operacion.control_corte_dth
          (idctrlcorte,
           numregistro,
           feccorteprg,
           feccortereal,
           estcorte,
           motivo,
           tipo)
        values
          (ln_idctrlcorte,
           r_regcorte.numregistro,
           r_regcorte.feccorte,
           sysdate,
           1,
           'FIN DE VIGENCIA',
           'CORTE');
        operacion.pq_dth.p_corte_dth(r_regcorte.pid,
                                     ls_resultado,
                                     ls_mensaje);
        if ls_resultado = 'OK' then
          -- Se pasa a estado corte generado
          update control_corte_dth
             set estcorte = 2
           where idctrlcorte = ln_idctrlcorte;
          --Ini 21.0
          -- Se actulizan los estados de los servicios una vez enviado en corte de manera correcta
          update insprd
             set estinsprd = 2
           where codinssrv = r_regcorte.codinssrv
             and estinsprd = 1;
          update inssrv
             set estinssrv = 2
           where codinssrv = r_regcorte.codinssrv;
          --Fin 21.0
        else
          -- Se anula el envio del corte
          update control_corte_dth
             set estcorte = 9, mensaje = 'Error en generación de corte'
           where idctrlcorte = ln_idctrlcorte;
        end if;
        commit;
        --ini 19.0 Genera Corte Bouquets promocionales
        pq_fac_promocion_en_linea.p_job_gen_corte_bouquetxprom(null,
                                                               r_regcorte.numregistro);
        --fin 19.0
      end if;
    end loop;
  end p_job_genera_corte;

  procedure p_job_verifica_corte is

    ls_resultado   varchar2(20);
    ls_mensaje     varchar2(1000);
    ls_estado      operacion.reginsdth.estado%type;
    ln_idctrlcorte number;
    -- registros con solicitud de corte en sistema recarga
    cursor c_regverif is
      select *
        from reginsdth
       where estado = '13'
         and flg_recarga = 1;

  begin
    for r_regverif in c_regverif loop
      ls_resultado := '';
      ls_mensaje   := '';
      operacion.pq_dth.p_proc_recu_filesxcli(r_regverif.numregistro,
                                             3,
                                             ls_resultado,
                                             ls_mensaje);
      commit;

      select estado
        into ls_estado
        from operacion.reginsdth
       where numregistro = r_regverif.numregistro;

      select max(idctrlcorte)
        into ln_idctrlcorte
        from operacion.control_corte_dth
       where numregistro = r_regverif.numregistro
         and estcorte = 2;

      if ls_resultado = 'OK' and ls_estado = '16' then
        -- Ejecuta Corte
        -- Se suspende instancias de operaciones
        update insprd
           set estinsprd = 2
         where codinssrv = r_regverif.codinssrv
           and estinsprd = 1;
        update inssrv
           set estinssrv = 2
         where codinssrv = r_regverif.codinssrv;
        -- Se actualiza estado del servicio en PESGAINT
        update reginsdth_web
           set estinsprd = 2
         where numregistro = r_regverif.numregistro;
        -- Se actualiza el control de los cortes a Verificado Conax
        update control_corte_dth
           set estcorte = 3
         where idctrlcorte = ln_idctrlcorte;
      else
        p_envia_correo_c_attach('Cortes DTH',
                                'miguel.londona@claro.com.pe', --26.0
                                'No se completó la verificación del corte  de servicio DTH, ID Ctrl de Corte: ' ||
                                ln_idctrlcorte || ', PID: ' ||
                                r_regverif.pid || ', mensaje: ' ||
                                ls_mensaje,
                                null,
                                'SGA'); --26.0
        p_envia_correo_c_attach('Cortes DTH',
                                'melvin.balcazar@claro.com.pe', --26.0
                                'No se completó la verificación del corte  de servicio DTH, ID Ctrl de Corte: ' ||
                                ln_idctrlcorte || ', PID: ' ||
                                r_regverif.pid || ', mensaje: ' ||
                                ls_mensaje,
                                null,
                                'SGA'); --26.0

      end if;
    end loop;
  end;

  procedure p_job_verifica_reconexion is

    ls_resultado varchar2(20);
    ls_mensaje   varchar2(1000);
    ls_estado    operacion.reginsdth.estado%type;
    --<14.0
    --<17.0
    /*ls_tipesttar esttarea.tipesttar%TYPE;
    ls_idtareawf           tareawf.idtareawf%type;
    lv_observacion         varchar2(4000);
    ln_codsolot            solot.codsolot%type;
    ls_esttarea            tareawf.esttarea%type;
    l_canfileenv_con_error number;*/
    --17.0>
    --14.0>
    --ln_idctrlcorte number;
    -- registros con solicitud de reconexion en sistema recarga
    cursor c_regverif is
      select * --14.0 --17.0
      --select 1 tipo,numregistro,codinssrv,pid, null ulttareawf --tipo 1 DTH,2 DTH + CDMA --14.0 --17.0
        from reginsdth
       where estado = '14'
         and flg_recarga = 1;
    --<14.0
    --<17.0
    /*union all
    select 2 tipo, a.numregistro, b.codinssrv, b.pid, b.ulttareawf
      from recargaproyectocliente a, recargaxinssrv b
     where a.numregistro = b.numregistro
       and b.estado = '14'
       and a.flg_recarga = 1
     and b.tipsrv = (select valor from constante where constante = 'FAM_CABLE');*/
    --17.0>
    --14.0>

  begin
    for r_regverif in c_regverif loop
      ls_resultado := '';
      ls_mensaje   := '';
      --<14.0
      --<17.0
      /*if r_regverif.tipo = 2 then
         select esttarea into ls_esttarea
         from tareawf where idtareawf = r_regverif.ulttareawf;
      end if;

      --si es tipo DTH siempre verifica, si es tipo bundle solo verifica si no esta marcado con estado error
      if (r_regverif.tipo = 1) or
          (r_regverif.tipo = 2 and ls_esttarea <> cn_esttarea_error) then*/
      --17.0>
      --14.0>
      operacion.pq_dth.p_proc_recu_filesxcli(r_regverif.numregistro,
                                             4,
                                             ls_resultado,
                                             ls_mensaje);
      commit;

      --if r_regverif.tipo = 1 then --14.0 --17.0
      select estado
        into ls_estado
        from operacion.reginsdth
       where numregistro = r_regverif.numregistro;
      --<14.0
      --<17.0
      /*else
       select estado
         into ls_estado
         from recargaxinssrv
        where numregistro = r_regverif.numregistro
         and tipsrv = (select valor from constante where constante = 'FAM_CABLE');
      end if;*/
      --17.0>
      --14.0>

      if ls_resultado = 'OK' and ls_estado = '17' then

        --if r_regverif.tipo = 1 then --14.0 --DTH --17.0
        -- Ejecuta Reconexion
        -- Se reconecta instancias de operaciones
        update insprd
           set estinsprd = 1
         where codinssrv = r_regverif.codinssrv
           and estinsprd = 2;
        update inssrv
           set estinssrv = 1
         where codinssrv = r_regverif.codinssrv;
        -- Se actualiza estado del servicio en PESGAINT

        update reginsdth_web
           set estinsprd = 1
         where numregistro = r_regverif.numregistro;
        --<14.0
        --<17.0
        /*else
            --se cierra la tarea de reconexion
            --se cambia a estado error plataforma
             SELECT tipesttar
              INTO ls_tipesttar
              FROM esttarea
             WHERE esttarea = cn_esttarea_cerrado;

             OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(r_regverif.ulttareawf,
                                             ls_tipesttar,
                                             cn_esttarea_cerrado,
                                             0,
                                             SYSDATE,
                                             SYSDATE);
            --se ingresa comentario en la tarea
            lv_observacion := 'Verificado en Conax.';
             insert into tareawfseg(idtareawf, observacion)
             values(r_regverif.ulttareawf, lv_observacion);
            --
          end if;
        else
           if r_regverif.tipo = 2 then -- BUNDLE DTH + CDMA

            --se averigua si ha habido error en los archivos enviados
            select count(1)
              into l_canfileenv_con_error
              from operacion.reg_archivos_enviados
             where estado = 3 --error
               and numregins = r_regverif.numregistro
               and fecenv is not null;

            if l_canfileenv_con_error > 0 then
              --se cambia a estado con errores
               SELECT tipesttar
                INTO ls_tipesttar
                FROM esttarea
               WHERE esttarea = cn_esttarea_error;

               OPEWF.PQ_WF.P_CHG_STATUS_TAREAWF(r_regverif.ulttareawf,
                                               ls_tipesttar,
                                               cn_esttarea_error,
                                               0,
                                               SYSDATE,
                                               SYSDATE);

              begin
                 select b.codsolot into ln_codsolot
                  from tareawf a, wf b
                 where a.idtareawf = r_regverif.ulttareawf
                   and a.idwf = b.idwf;

                --se ingresa comentario en la tarea
                 insert into tareawfseg(idtareawf, observacion)
                 values(r_regverif.ulttareawf, ls_mensaje);
                --
              exception
                when others then
                  ln_codsolot := null;
              end;

              p_envia_correo_c_attach('Reconexion BUNDLE',
                                      'miguel.londona@claro.com.pe',
                                      'No se completó la verificación de la reconexion del servicio DTH, SOT: ' ||
                                       to_char(ln_codsolot) || ', NumRegistro: ' || r_regverif.numregistro || ', PID: ' || r_regverif.pid ||
                                       ', mensaje: ' || ls_mensaje,
                                      null,
                                      'SGA');
              p_envia_correo_c_attach('Reconexion BUNDLE',
                                      'melvin.balcazar@claro.com.pe',
                                      'No se completó la verificación de la reconexion del servicio DTH, SOT: ' ||
                                       to_char(ln_codsolot) || ', NumRegistro: ' || r_regverif.numregistro || ', PID: ' || r_regverif.pid ||
                                       ', mensaje: ' || ls_mensaje,
                                      null,
                                      'SGA');

              lv_observacion := 'Se verifico en conax con errores.';
            else
              lv_observacion := 'No hubo resultado de verificación.';
            end if;

            --se ingresa comentario en la tarea
             insert into tareawfseg(idtareawf, observacion)
             values(r_regverif.ulttareawf, lv_observacion);*/
        --17.0>
      else
        --14.0>
        p_envia_correo_c_attach('Reconexion DTH',
                                'miguel.londona@claro.com.pe', --26.0
                                'No se completó la verificación de la reconexion de servicio DTH, NumRegistro: ' ||
                                r_regverif.numregistro || ', PID: ' ||
                                r_regverif.pid || ', mensaje: ' ||
                                ls_mensaje,
                                null,
                                'SGA'); --26.0
        p_envia_correo_c_attach('Reconexion DTH',
                                'melvin.balcazar@claro.com.pe', --26.0
                                'No se completó la verificación de la reconexion de servicio DTH, NumRegistro: ' ||
                                r_regverif.numregistro || ', PID: ' ||
                                r_regverif.pid || ', mensaje: ' ||
                                ls_mensaje,
                                null,
                                'SGA'); --26.0
        --end if; --14.0 --17.0
      end if;
      --end if;--14.0 --17.0
    end loop;
  end p_job_verifica_reconexion;

  procedure p_act_fechasxpago(ln_numregistro char) is
    maxdesde date;
    maxhasta date;
  begin
    begin
      --ini 23.0
      /*select (select max(cr.desde)
                from instxproducto i, cr, bilfac b, cxctabfac c
               where i.pid = x.pid
                 and i.idinstprod = cr.idinstprod
                 and cr.idbilfac = b.idbilfac
                 and b.idfaccxc = c.idfac
                 and c.estfac = '05'),
             (select max(cr.hasta)
                from instxproducto i, cr, bilfac b, cxctabfac c
               where i.pid = x.pid
                 and i.idinstprod = cr.idinstprod
                 and cr.idbilfac = b.idbilfac
                 and b.idfaccxc = c.idfac
                 and c.estfac = '05') maxhasta
        into maxdesde, maxhasta
        from reginsdth x
       where estado not in ('12', '05')
         and nvl(flg_recarga, 0) = 0
         and x.numregistro = ln_numregistro;

      update reginsdth
         set fecinivig = maxdesde,
             fecfinvig = maxhasta,
             fecalerta = maxhasta - billcolper.f_parametrosfac(651),
             feccorte  = maxhasta + billcolper.f_parametrosfac(652)
       where numregistro = ln_numregistro;*/

      select (select max(cr.desde)
                from instxproducto i, cr, bilfac b, cxctabfac c
               where i.pid = y.pid
                 and i.idinstprod = cr.idinstprod
                 and cr.idbilfac = b.idbilfac
                 and b.idfaccxc = c.idfac
                 and c.estfac = '05'),
             (select max(cr.hasta)
                from instxproducto i, cr, bilfac b, cxctabfac c
               where i.pid = y.pid
                 and i.idinstprod = cr.idinstprod
                 and cr.idbilfac = b.idbilfac
                 and b.idfaccxc = c.idfac
                 and c.estfac = '05') maxhasta
        into maxdesde, maxhasta
        from ope_srv_recarga_cab x, ope_srv_recarga_det y
       where x.numregistro = y.numregistro
         and y.tipsrv in
             (select valor from constante where constante = 'FAM_CABLE')
         and nvl(x.flg_recarga, 0) = 0
         and x.estado <> '04'
         and x.numregistro = ln_numregistro;

      update ope_srv_recarga_cab
         set fecinivig = maxdesde,
             fecfinvig = maxhasta,
             fecalerta = maxhasta - billcolper.f_parametrosfac(651),
             feccorte  = maxhasta + billcolper.f_parametrosfac(652)
       where numregistro = ln_numregistro;

      --fin 23.0

      update reginsdth_web
         set fecinivig = maxdesde,
             fecfinvig = maxhasta,
             fecalerta = maxhasta - billcolper.f_parametrosfac(651),
             feccorte  = maxhasta + billcolper.f_parametrosfac(652)
       where numregistro = ln_numregistro;

    exception
      when no_data_found then
        null;
      when others then
        null;
    end;
  end p_act_fechasxpago;

  procedure p_job_genera_bajadef is
  begin
    null;
  end p_job_genera_bajadef;

  --<REQ ID = 84617>
  procedure p_gen_reconexion_adic(ls_idfac char, ls_numregistro char) is

    ln_cant_doc number;
    ln_cant_reg number;

  begin

    select count(1)
      into ln_cant_doc
      from cxctabfac c
     where c.idfac = ls_idfac
       and trunc(c.fecven) >= trunc(c.feccan)
       and c.feccan is not null
       and c.estfac = '05'
       and not exists
     (select 1 from faccanfac where idfaccan = c.idfac);

    if ln_cant_doc > 0 then
      --ini 24.0
      /*select count(1)
       into ln_cant_reg
       from reginsdth
      where numregistro = ls_numregistro
        and estado in
            (select codestdth from estregdth where tipoestado = 1);*/

      select count(1)
        into ln_cant_reg
        from ope_srv_recarga_cab
       where numregistro = ls_numregistro
         and estado = '02';
      --fin 24.0
      if ln_cant_reg > 0 then

        update operacion.bouquetxreginsdth
           set flg_transferir = 1
         where numregistro = ls_numregistro
           and tipo = 0
           and estado = 0;

      end if;

    end if;

  end p_gen_reconexion_adic;
  --</REQ>

  --<10.0>
  procedure p_modifica_fin_vigencia(a_codincidence  incidence.codincidence%type,
                                    a_numregistro   reginsdth.numregistro%type,
                                    a_fecfinvig_new reginsdth.fecfinvig%type,
                                    a_observaciones reginsdth.observacion%type,
                                    a_resultado     out varchar2) is

    v_estado_old         reginsdth.estado%type;
    v_estado_new         reginsdth.estado%type;
    v_fecfinvig_old      reginsdth.fecfinvig%type;
    v_flg_gen_corte      reginsdth_vigencia.flg_gen_corte%type := 0;
    v_flg_gen_reconexion reginsdth_vigencia.flg_gen_reconexion%type := 0;
    v_serv_cortado       number(3);
    v_pid                reginsdth.pid%type;
    v_mensaje            varchar2(100);
    v_idctrlcorte        number;
    v_idpaq              reginsdth.idpaq%type;
    v_montodiario        reginsdth_vigencia.monto%type;
    v_monto              reginsdth_vigencia.monto%type;
    v_dias               reginsdth_vigencia.dias%type;
    v_serv_activo        number(3); --<11.0>
    l_rec_proceso        number(2); --<18.0>

  begin

    select estado, fecfinvig, pid
      into v_estado_old, v_fecfinvig_old, v_pid
      from reginsdth
     where numregistro = a_numregistro;

    --Ini 18.0
    select count(1)
      into l_rec_proceso
      from reginsdth_web
     where numregistro = a_numregistro
       and flgtransferir = 1;

    if (l_rec_proceso > 0) then

      raise_application_error(-20500,
                              'El registro: ' || a_numregistro ||
                              ' tiene en proceso una recarga virtual,
                                    por favor intente dentro de una hora.');

    end if;

    --Fin 18.0

    select count(1)
      into v_serv_cortado
      from estregdth
     where tipoestado = 2
       and codestdth = v_estado_old;
    --<11.0>
    select count(1)
      into v_serv_activo
      from estregdth
     where tipoestado = 1
       and codestdth = v_estado_old;
    --</11.0>
    update reginsdth
       set fecfinvig = a_fecfinvig_new,
           fecalerta = a_fecfinvig_new - 3,
           feccorte  = a_fecfinvig_new + 1
     where numregistro = a_numregistro;
    --<15.0> actualizacion en interfase web
    update reginsdth_web
       set fecfinvig = a_fecfinvig_new,
           fecalerta = a_fecfinvig_new - 3,
           feccorte  = a_fecfinvig_new + 1
     where numregistro = a_numregistro;
    --</15.0>
    case
      when ((to_char(a_fecfinvig_new, 'yyyymmdd') <
           to_char(sysdate, 'yyyymmdd')) and (v_serv_activo > 0)) then
        --<11.0>
        --enviar corte al CONAX
        select sq_ctrlcortedth.nextval into v_idctrlcorte from dummy_ope;

        insert into operacion.control_corte_dth
          (idctrlcorte, numregistro, feccortereal, estcorte, motivo, tipo)
        values
          (v_idctrlcorte,
           a_numregistro,
           sysdate,
           1,
           'MODIFICACIÓN FIN DE VIGENCIA',
           'CORTE');

        operacion.pq_dth.p_corte_dth(v_pid, a_resultado, v_mensaje);
        v_flg_gen_corte := 1;

        if a_resultado = 'OK' then
          -- Se pasa a estado corte enviado al CONAX
          update operacion.control_corte_dth
             set estcorte = 2
           where idctrlcorte = v_idctrlcorte;

        else
          -- Se pasa a estado corte anulado
          update operacion.control_corte_dth
             set estcorte = 9
           where idctrlcorte = v_idctrlcorte;
        end if;
        commit;

      when ((to_char(a_fecfinvig_new, 'yyyymmdd') >
           to_char(sysdate, 'yyyymmdd')) and v_serv_cortado > 0) then
        --enviar reconexión al CONAX
        operacion.pq_dth.p_reconexion_dth(v_pid, a_resultado, v_mensaje);
        v_flg_gen_reconexion := 1;
        commit;
      else
        a_resultado := 'OK';
        commit;
    end case;

    select estado, idpaq
      into v_estado_new, v_idpaq
      from reginsdth
     where numregistro = a_numregistro;

    select nvl(round(b.monto / b.vigencia, 4), 0)
      into v_montodiario
      from vtatabrecargaxpaquete a, vtatabrecarga b
     where a.idrecarga = b.idrecarga
       and a.estado = 1
       and b.vigencia = 30
       and b.tipvigencia = 1
       and a.idpaq = v_idpaq;

    --<11.0>
    if ((v_serv_cortado > 0) and
       ((v_estado_new = '14') or (v_estado_new = '17'))) then
      v_dias := trunc(a_fecfinvig_new) - trunc(sysdate);
    else
      v_dias := trunc(a_fecfinvig_new) - trunc(v_fecfinvig_old);
    end if;

    v_monto := round(v_dias * v_montodiario, 2);
    --</11.0>

    insert into operacion.reginsdth_vigencia
      (idvigencia, --<11.0>
       codincidence,
       numregistro,
       estado_old,
       fecfinvig_old,
       estado_new,
       fecfinvig_new,
       flg_gen_corte,
       flg_gen_reconexion,
       observaciones,
       dias,
       monto)
    values
      (null, --<11.0>
       a_codincidence,
       a_numregistro,
       v_estado_old,
       v_fecfinvig_old,
       v_estado_new,
       a_fecfinvig_new,
       v_flg_gen_corte,
       v_flg_gen_reconexion,
       a_observaciones,
       v_dias,
       v_monto);

  end p_modifica_fin_vigencia;
  --</10.0>
  --<36.0
   PROCEDURE p_regula_corte_dth (ac_resultado   OUT CHAR,
                                 av_mensaje     OUT VARCHAR2)
   IS
      CURSOR c_regcorte (an_dias_gracia NUMBER)
      IS
         -- select todos los registros que estan con fechas de vigencias vencidas y activos
         SELECT a.*
           FROM ope_srv_recarga_cab a, vtatabslcfac b
          WHERE     a.numslc = b.numslc
                AND TRUNC (a.fecfinvig) < TRUNC (SYSDATE) -- fecha de vigencia menor a hoy
                AND a.estado = '02'                                 -- Activos
                AND b.idsolucion IN (SELECT m.codigon
                                       FROM operacion.opedd m
                                      WHERE abreviacion = 'TV_SAT') --¿    67  TV Staelital
                AND a.flg_recarga = 1;                              -- Recarga


      ln_idctrlcorte              NUMBER;
      ln_num_cortes_pendientes    NUMBER;
      ln_fecha_menor              NUMBER;
      ln_sots_no_cerradas         NUMBER;
      ln_recargas_no_procesadas   NUMBER;
      ln_proceso_sot              NUMBER;
      ln_dias_gracias             NUMBER;
      ls_error_sot                VARCHAR2 (500);
      ls_mensaje                  VARCHAR2 (500);
      error_eliminar              EXCEPTION;
   BEGIN
      ac_resultado := '0';                                                --OK
      av_mensaje := 'OK';
      ln_dias_gracias := 0;

      ls_error_sot := 'Error en generación de suspension, al crear SOT';

      ---no deben existir en operacion.control_corte_dth d de
      DELETE operacion.control_corte_dth d
       WHERE numregistro IN
                (SELECT a.numregistro
                   FROM ope_srv_recarga_cab a, vtatabslcfac b
                  WHERE     a.numslc = b.numslc
                        AND TRUNC (a.fecfinvig) < TRUNC (SYSDATE) -- fecha de vigencia menor a hoy
                        AND a.estado = '02'                       -- Activos--
                        AND b.idsolucion IN (SELECT m.codigon
                                               FROM operacion.opedd m
                                              WHERE abreviacion = 'TV_SAT') --¿
                        AND a.flg_recarga = 1)
             AND d.codsolot IS NOT NULL
             AND d.estcorte IN (1, 2);

      COMMIT;

      -------------------------------------------------------------
      ---------------------------------------------------------------
      FOR r_regcorte IN c_regcorte (ln_dias_gracias)
      LOOP
         SELECT COUNT (1)
           INTO ln_fecha_menor
           FROM ope_srv_recarga_cab a
          WHERE a.numregistro = r_regcorte.numregistro;

         ln_sots_no_cerradas := 0;

         SELECT COUNT (1)
           INTO ln_recargas_no_procesadas
           FROM cuponpago_dth_web
          WHERE numregistro = r_regcorte.numregistro
                AND flgtransferir IN (0, 1);

         IF     ln_fecha_menor > 0
            AND ln_sots_no_cerradas = 0
            AND ln_recargas_no_procesadas = 0
         THEN
            SELECT COUNT (1)
              INTO ln_num_cortes_pendientes
              FROM operacion.control_corte_dth
             WHERE     numregistro = r_regcorte.numregistro
                   AND codsolot IS NOT NULL
                   AND estcorte IN (1, 2); --1:Generado - 2:Enviado - 3:Verificado - 9 Anulado

            IF ln_num_cortes_pendientes = 0
            THEN
               BEGIN
                  --- genera secuencial de corte
                  SELECT operacion.sq_ctrlcortedth.NEXTVAL
                    INTO ln_idctrlcorte
                    FROM dummy_ope;

                  -- inserta registros de corte
                  INSERT INTO operacion.control_corte_dth (idctrlcorte,
                                                           numregistro,
                                                           feccorteprg,
                                                           feccortereal,
                                                           estcorte,
                                                           motivo,
                                                           tipo)
                       VALUES (ln_idctrlcorte,
                               r_regcorte.numregistro,
                               r_regcorte.feccorte,
                               SYSDATE,
                               1,
                               (SELECT m.codigoc
                                  FROM operacion.opedd m
                                 WHERE abreviacion = 'FVIG_DTH'), --fin de vigencia opedd
                               (SELECT m.codigoc
                                  FROM operacion.opedd m
                                 WHERE abreviacion = 'SUSP_DTH')); -- Suspension opedd
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     ac_resultado := '-1';
                     av_mensaje :=
                           'No se pudo registrar el corte, NumRegistro: '
                        || r_regcorte.numregistro
                        || ', Error : '
                        || SQLERRM;
               END;

               COMMIT;

               BEGIN
                  operacion.pq_control_inalambrico.p_crea_sot (
                     r_regcorte.numregistro,
                     NULL,
                     ln_idctrlcorte);
                  ln_proceso_sot := 1;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     ROLLBACK;

                     ln_proceso_sot := 0;

                     UPDATE operacion.control_corte_dth
                        SET estcorte = 9,                            --anulado
                                         mensaje = ls_error_sot
                      WHERE idctrlcorte = ln_idctrlcorte;

                     ac_resultado := '1';
                     av_mensaje := ls_error_sot;
               END;

               ls_mensaje := 'Error al actualizar en INT';

               IF ln_proceso_sot = 1
               THEN
                  BEGIN
                     UPDATE reginsdth_web
                        SET estado = '03', estinsprd = 2
                      WHERE numregistro = r_regcorte.numregistro;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        ROLLBACK;

                        UPDATE operacion.control_corte_dth
                           SET estcorte = 9,                         --anulado
                                            mensaje = ls_mensaje
                         WHERE idctrlcorte = ln_idctrlcorte;

                        ac_resultado := '2';
                        av_mensaje := ls_mensaje;
                  END;
               END IF;

               COMMIT;
            END IF;
         END IF;
      END LOOP;
   EXCEPTION
      WHEN error_eliminar
      THEN
         ac_resultado := '-1';
         av_mensaje :=
            'No se eliminó el grupo de numeros pendientes de cortes: '
            || SQLERRM;
   END;

  --36.0>

end pq_control_dth;
/