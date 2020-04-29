CREATE OR REPLACE PROCEDURE OPERACION.p_job_actualiza_bdweb_tst is
/************************************************************
     NOMBRE:     p_job_actualiza_bdweb_tst
   PROPOSITO:  .

     PROGRAMADO EN JOB:  NO

     REVISIONES:
     Ver       Fecha        Autor            Solicitado por  Descripcion
   ---------  ----------  --------------- --------------  ------------------------
     1.0     25/08/2010  Dennys Mallqui      REQ-112339: Mejora performance
     2.0     06/10/2010                      REQ.139588 Cambio de Marca
******************************************************************************/



    --  Job que transfiere los registros nuevos cada 5 minutos
    --<14.0
    --<17.0
  /*ln_estinsprd insprd.estinsprd%type;
    ln_num_act   number;
    ln_num_sus   number;

    cursor c_recarga_cab is
      select x.numregistro,
             x.fecinivig,
             x.fecfinvig,
             x.fecalerta,
             x.feccorte,
             x.estado,
        (select e.descripcion from ope_estado_recarga e where  e.codestrec = x.estado) dscestdth,
        (select nomcli from vtatabcli
               where codcli = x.codcli) nomcli,
             x.numslc,
             x.codcli,
             x.idpaq,
             x.codsolot,
             p.nrodoc,
             0 idcontrato,
             null nrodoc_contrato,
             --0 estinsprd,
             0 flgtransferir,
        (select decode(tipdide,'001',ntdide,'0000000000') from vtatabcli
               where codcli = x.codcli) ruc,
             x.codigo_recarga
   from recargaproyectocliente x,
        vtatabpspcli  p
       where x.numslc is not null
         and x.numslc = p.numslc
            --and (nvl((select tipoestado from estregdth where codestdth = x.estado),0) <> 3)
         and x.estado <> '04' --no se incluyen los registros en estado cancelado, tabla ope_estado_recarga
         and not exists (select 1
                from reginsdth_web z
                           where z.numregistro = x.numregistro)
    ;*/
    --17.0>
    --14.0>

  --<20.0
  cursor c_reginsdth is
  select /*+ RULE*/
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
        (select e.dscestdth from estregdth e where  e.codestdth = x.estado) dscestdth,
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
            from reginsdth_web_pivot z
           where z.numregistro = x.numregistro);

  cursor c_bouquet_mae is
  select x.idbouquet,
         x.codbouquet,
         x.descripcion,
         x.flg_activo
  from   ope_bouquet_mae x
  where  not exists (select 1
            from rec_bouquet_mae z
           where z.idbouquet = x.idbouquet);

  cursor c_grupo_bouquet_det is
  select idgrupo,
         codbouquet,
         flg_activo
  from   ope_grupo_bouquet_det x
  where  not exists (select 1
            from rec_grupo_bouquet_det z
           where z.idgrupo = x.idgrupo
                 and z.codbouquet = x.codbouquet);

    cursor c_bouquetxreginsdth(ac_numregistro bouquetxreginsdth.numregistro%type) is
    select *
      from bouquetxreginsdth r
     where r.estado = 1 --solo se transfiere los activos
       and r.fecha_inicio_vigencia is null --los que se registren directamente en bouquetxreginsdth no proviene de promociones
       and r.fecha_fin_vigencia is null
       and r.numregistro = ac_numregistro
       and not exists (select 1
              from rec_bouquetxreginsdth_cab rec
             where rec.numregistro = r.numregistro
               and rec.bouquets = r.bouquets
               and rec.codsrv = r.codsrv
               and rec.numregistro = ac_numregistro
               );
  --20.0>

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

      delete reginsdth_web_pivot;

      commit;

      insert into reginsdth_web_pivot
      select numregistro from reginsdth_web;

      commit;

      for r_reginsdth in c_reginsdth loop

          insert into reginsdth_web(
             numregistro,
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
           ) values (
             r_reginsdth.numregistro,
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
             r_reginsdth.CODIGO_RECARGA  -- REQ 99155
           );

           insert into rec_srv_recarga_det(
             numregistro,
             codinssrv,
             tipsrv,
             codsrv,
             fecact,
             fecbaja,
             pid,
             estado,
             ulttareawf
           ) values (
             r_reginsdth.numregistro,
             r_reginsdth.codinssrv,
             r_reginsdth.tipsrv,
             r_reginsdth.codsrv,
             r_reginsdth.fecinivig,
             r_reginsdth.fecfinvig,
             r_reginsdth.pid,
             r_reginsdth.estado,
             null
           );

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
             1,--flg_rectransferir
             c1.fecultenv,
             c1.usumod,
             c1.fecmod,
             c1.fecha_inicio_vigencia,
             c1.fecha_fin_vigencia,
             c1.idcupon);

        end loop;

      end loop;

      for r_bouquet_mae in c_bouquet_mae loop
         insert into rec_bouquet_mae(
           idbouquet,
           codbouquet,
           descripcion,
           flg_activo
         ) values (
           r_bouquet_mae.idbouquet,
           r_bouquet_mae.codbouquet,
           r_bouquet_mae.descripcion,
           r_bouquet_mae.flg_activo
         );
      end loop;

      for r_grupo_bouquet_det in c_grupo_bouquet_det loop
         insert into rec_grupo_bouquet_det(
           idgrupo,
           codbouquet,
           flg_activo
         ) values (
           r_grupo_bouquet_det.idgrupo,
           r_grupo_bouquet_det.codbouquet,
           r_grupo_bouquet_det.flg_activo
         );
      end loop;

      --20.0>
      --<14.0, se transfiere de las nuevas estructuras de recarga
         --<17.0
        /*for r_recarga_cab in c_recarga_cab loop
          select count(1) into ln_num_act
          from recargaxinssrv a, insprd b
         where a.numregistro = r_recarga_cab.numregistro
           and a.pid = b.pid
           and b.estinsprd = 1; --activos

        ln_estinsprd := 0;

        if ln_num_act = 0 then
            select count(1) into ln_num_sus
            from recargaxinssrv a, insprd b
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

        end if;
        end loop;*/
         --17.0>
      --14.0>

    exception
      when others then
          operacion.pq_control_dth.p_graba_log('Error en transferencia a PESGAINT',sqlerrm);--19.0
          opewf.pq_send_mail_job.p_send_mail('Error en transferencia a PESGAINT','DL-PE-ITSoportealNegocio@claro.com.pe','No se ha podido actualizar los registros de DTH en PESGAINT');--2.0
    end;

    commit;

  end p_job_actualiza_bdweb_tst;
/


