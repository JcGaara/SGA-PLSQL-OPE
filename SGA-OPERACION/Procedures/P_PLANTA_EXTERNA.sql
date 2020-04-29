CREATE OR REPLACE PROCEDURE OPERACION.p_planta_externa is
--declare
cursor c_planta_externa is
              select
                decode(b.descripcion,null,'LOCALES PROVINCIAS',b.descripcion) nodo,
                a.Descripcion pop,
                c.descripcion descable,
                ct.descripcion descajter,
                ct.direccion direccion_1,
                f.descripcion desfibra,
                f.codestfibra,
                f.observacion,
                f.fecha_baja,
                i.numero,
                f.fecins,
                cli.codcli,
                decode(cli.nomcli,null,fcli.nomcli,cli.nomcli) nomcli,
                decode(i.numslc,null,f.numslc,i.numslc) numslc,
                i.cid,
                ta.dscsrv,
                (SELECT  numtel.numero
                      FROM pritel,
                     prixhunting,
                     hunting,
                     numtel
                      WHERE pritel.codpritel = prixhunting.codpritel and
                      prixhunting.codcab = hunting.codcab and
                      hunting.codnumtel = numtel.codnumtel and
                      pritel.codinssrv = i.codinssrv ) telefono,
                decode(i.direccion,null,fsuc.dirsuc,i.direccion) direccion_2,
                decode(i.descripcion,null,fsuc.dirsuc,i.descripcion) descripcion,
                e.descripcion estinssrv,
                TRUNC(SYSDATE) FEC_EJE,
                TO_CHAR(SYSDATE,'YYYYMM') PERIODO
              from
                pex_cable c,
                pex_fibra f,
                pex_cajter ct,
                vtatabcli cli,
                inssrv i,
                estinssrv e,
                pex_fibra_orides fo,
                tystabsrv ta,
                tystipsrv ti,
                vtatabcli fcli,
                vtasuccli fsuc,
                UBIRED a,
                nodo b
                where
                 f.codcable = c.codcable
                 and f.codcajter = ct.codcajter
                 and f.codfibra = fo.codfibra(+)
                 and fo.codubired = a.CODUBIRED
                 and a.codubiredpad = b.codnod (+)
                 and i.codcli = cli.codcli(+)
                 and f.codinssrv = i.codinssrv (+)
                 and i.estinssrv = e.estinssrv (+)
                 and ta.codsrv(+) = i.codsrv
                 and ta.tipsrv = ti.tipsrv(+)
                 and f.codcli = fcli.codcli (+)
                 and f.codsuc = fsuc.codsuc (+)
                 and f.codestfibra <> 6
                 and (a.estado=1 and a.tipo in (3,6))
                 and (a.codubiredpad is not null or a.codubiredpad = 757)
                      order by
                       b.descripcion ,
                       a.Descripcion ,
                       c.descripcion,
                       f.descripcion ;
Begin
      delete operaciones.t_planta_externa@pedwhprd.world;
      for l_pe in c_planta_externa loop
         Insert into operaciones.t_planta_externa@pedwhprd.world values (
                                                l_pe.nodo,
                                                l_pe.pop,
                                                l_pe.descable,
                                                l_pe.descajter,
                                                l_pe.direccion_1,
                                                l_pe.desfibra,
                                                l_pe.codestfibra,
                                                l_pe.observacion,
                                                l_pe.fecha_baja,
                                                l_pe.numero,
                                                l_pe.fecins,
                                                l_pe.codcli,
                                                l_pe.nomcli,
                                                l_pe.numslc,
                                                l_pe.cid,
                                                l_pe.dscsrv,
                                                l_pe.telefono,
                                                l_pe.direccion_2,
                                                l_pe.descripcion,
                                                l_pe.estinssrv,
                                                l_pe.FEC_EJE,
                                                l_pe.PERIODO
                                                );
      end loop;
     commit;
end;
/


