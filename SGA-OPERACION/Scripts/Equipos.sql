declare  
  
  CURSOR c_principal is
-------------------------------
select vc.tipper DATAC_TIPO_PERSONA,
       iso.codcli DATAC_CODCLI,
       (case nvl(vc.nomcli,'null') when 'null' then vc.nomabr else vc.nomcli end) DATAV_NOMABR,
       (case nvl(vc.NOMCLIRES,'null') when 'null' then vc.nombre else vc.NOMCLIRES end) DATAV_NOMCLI,
       (case nvl(vc.apepatcli,'null') when 'null' then vc.apepat else vc.apepatcli end) DATAV_APEPAT,
       (case nvl(vc.apematcli,'null') when 'null' then vc.apmat else vc.apematcli end) DATAV_APEMAT,
       vc.tipdide DATAC_TIPDOC,
       (select abrdid from vtatipdid where tipdide = vc.tipdide) DATAV_DESCDOC,
       vc.ntdide DATAV_NUMDOC,
       nvl(vc.fecnac,to_date('01/01/1980')) DATAD_FECNAC,
       to_date(iso.fecini,'dd/mm/yy') DATAD_FECHAINI,
       to_date(iso.fecfin,'dd/mm/yy') DATAD_FECHAFIN,
       (case nvl(vc.mail,'null') when 'null' then 'iClaroCorreo@iclaro.com.pe' else vc.mail end) DATAV_EMAILPRINC,
       (select email1 from tabgrupo where codcli = ipb.codcli and grupo = ipb.grupo) DATAV_EMAIL1,
       (select email2 from tabgrupo where codcli = ipb.codcli and grupo = ipb.grupo) DATAV_EMAIL2,
       
       (select tipsrv from vtatabslcfac 
         where numslc = iso.numslc) DATAC_TIPSRV,
       (select dsctipsrv from tystipsrv 
         where tipsrv = (select tipsrv from vtatabslcfac 
                          where numslc = iso.numslc)) DATAV_DESCTIPSRV,
       (select v.idcampanha from vtatabslcfac v 
         where v.numslc = iso.numslc ) DATAN_CODCAMP, 
       (select c.DESCRIPCION from campanha c, vtatabslcfac v 
         where c.IDCAMPANHA = v.idcampanha 
           and v.numslc = iso.numslc) DATAV_DESCAMP, 
                                                                                       
      (select PLAZO_SRV from vtatabslcfac 
        where numslc = iso.numslc) DATAN_CODPLAZO,
      (select tc.descripcion from tipo_calificacion tc, vtatabslcfac v 
        where v.numslc = iso.numslc
          and v.plazo_srv = tc.codigo(+) 
          and tc.ESTADO = '1'  and tc.tipo = 'C') DATAV_DESCPLAZO,
       (select idsolucion from paquete_venta where idpaq = iso.idpaq) DATAN_IDSOLUCION,
       (select solucion from soluciones where idsolucion = (select idsolucion from paquete_venta where idpaq = iso.idpaq)) DATAV_SOLUCION,
       iso.idpaq DATAN_IDPAQ,
       (select observacion from paquete_venta where idpaq = iso.idpaq) DATAV_PAQUETE,
       (select tipsrv from producto where idproducto = ts.idproducto) DATAC_TIPPROD, 
       (select dsctipsrv from tystipsrv where tipsrv = (select tipsrv from producto where idproducto = ts.idproducto)) DATAV_DESCTIPPROD,
       ts.idproducto DATAN_IDPROD,
       (select descripcion  from producto where idproducto = ts.idproducto) DATAV_PROD,
       (select s.idgrupo_sisact from sales.grupo_sisact s where s.idproducto = ts.idproducto) DATAV_EQ_PROD_SISACT,
       ipo.codsrv DATAC_CODSRV,
       (select dscsrv from tystabsrv where codsrv = ipo.codsrv) DATAV_SERVICIO,
       (select s.IDSERVICIO_SISACT from sales.servicio_sisact s where s.codsrv = ipo.codsrv) DATAV_EQ_SERV_SISACT,
       case
         when ipo.codequcom is not null then
          ipb.descripcion
       end DATAV_DESCPLAN,
      'Equipos' DATAV_TIPOSERVICIO,
      iso.estinssrv DATAN_IDESTSERV,
      (select descripcion from estinssrv where  estinssrv = iso.estinssrv) DATAV_DESCESTSERV,
       iso.tipinssrv DATAN_IDTIPINSS,
       (select tis.descripcion from TIPINSSRV tis where tis.tipinssrv = iso.tipinssrv ) DATAV_TIPINSS,
       ipo.codinssrv DATAN_CODINSSRV, 
       ipo.pid DATAN_PID,
       (select veq.idmarcaequipo
        from vtaequcom veq
        where veq.activo = 1
        and veq.codequcom = ipo.codequcom) DATAN_IDMARCAEQUIPO,
       (select meq.descripcion
        from vtaequcom veq, SALES.MARCAEQUIPO meq
        where veq.idmarcaequipo = meq.idequipo
        and veq.activo = 1
        and veq.codequcom = ipo.codequcom) DATAV_MARCAEQUIPO,
       (select max(teq.codtipequ)
        from vtaequcom veq, equcomxope eq, tipequ teq
        where veq.codequcom = eq.codequcom
        and eq.tipequ = teq.tipequ
        and veq.activo = 1
        and eq.esparte = 0
        and veq.codequcom = ipo.codequcom) DATAC_CODTIPEQU,
       (select max(teq.tipequ)
        from vtaequcom veq, equcomxope eq, tipequ teq
        where veq.codequcom = eq.codequcom
        and eq.tipequ = teq.tipequ
        and veq.activo = 1
        and eq.esparte = 0
        and veq.codequcom = ipo.codequcom) DATAN_TIPEQU,
       (select teq.descripcion
        from tipequ teq
        where teq.tipequ = (select max(teq.tipequ)
                            from vtaequcom veq, equcomxope eq, tipequ teq
                            where veq.codequcom = eq.codequcom
                            and eq.tipequ = teq.tipequ
                            and veq.activo = 1
                            and eq.esparte = 0
                            and veq.codequcom = ipo.codequcom) ) DATAV_TIPO_EQUIPO,
       (select teq.tipo
        from tipequ teq
        where teq.tipequ = (select max(teq.tipequ)
                              from vtaequcom veq, equcomxope eq, tipequ teq
                              where veq.codequcom = eq.codequcom
                              and eq.tipequ = teq.tipequ
                              and veq.activo = 1
                              and eq.esparte = 0
                              and veq.codequcom = ipo.codequcom) ) DATAV_EQU_TIPO,
       ipo.codequcom DATAC_COD_EQUIPO,
       case
         when ipo.codequcom is not null then
          (select dscequ from vtaequcom where codequcom = ipo.codequcom)
       end DATAV_MODELO_EQUIPO,
       'Equipo' DATAV_TIPO,
       null DATAV_NUMERO,
       (select flag_lc from tystabsrv where codsrv=ipb.codsrv) DATAN_CONTROL,
       
       iso.numslc DATAC_IDPROYECTO,
       (select decode(count(1),1,'1Play',2,'2Play',3,'3Play') 
          from inssrv x, tystabsrv y, tystipsrv z 
         where numslc = iso.numslc
           and codsuc = iso.codsuc 
           and estinssrv in (1,2)
           and x.codsrv = y.codsrv 
           and y.tipsrv = z.tipsrv 
           and z.tipsrv in ('0004','0006','0062')) DATAV_PLAY,
       case
         when ipo.codequcom is not null and ipb.montocr > 0 then
          ipb.montocr
       end DATAN_CARGOFIJO,
       ipb.cantidad DATAN_CANTIDAD,
       null DATAC_PUBLICAR,
       ipb.cicfac DATAN_IDCICLO,  
       c.descripcion DATAV_DESCICLO,
       iso.bw DATAN_BW,
       iso.cid DATAN_CIDVENTA,
       iso.codsuc DATAC_CODSUCURSAL,
       iso.codubi DATAC_CODUBIGEO,
       iso.direccion DATAV_DIRVENTA,
       iso.codpostal DATAV_CODPOSVENTA,
       iso.descripcion DATAV_DESCVENTA,

      (select codsol from vtatabslcfac 
        where numslc = (select numslc from solot
                         where codsolot = 
                             (select max(s.codsolot)
                                from solot s, solotpto pto
                               where s.codsolot = pto.codsolot
                                 and pto.codinssrv = iso.codinssrv
                                 and exists (select 1 from estsol e
                                              where e.estsol = s.estsol 
                                                and e.tipestsol in (1,2,3,4,6))
                                 and exists (select 1
                                                from tipopedd t, opedd o
                                               where t.tipopedd = o.tipopedd
                                                 and t.abrev = 'CONFSERVADICIONAL'
                                                 and o.abreviacion = 'TIPTRAVAL'
                                                 and o.codigon = s.tiptra)) )) DATAC_COD_EV,
      (select vt.tipdide from vtatabslcfac v, VTATABECT vt 
        where v.numslc = (select numslc from solot
                           where codsolot = 
                               (select max(s.codsolot)
                                  from solot s, solotpto pto
                                 where s.codsolot = pto.codsolot
                                   and pto.codinssrv = iso.codinssrv
                                   and exists (select 1 from estsol e
                                                where e.estsol = s.estsol 
                                                  and e.tipestsol in (1,2,3,4,6))
                                   and exists (select 1
                                                  from tipopedd t, opedd o
                                                 where t.tipopedd = o.tipopedd
                                                   and t.abrev = 'CONFSERVADICIONAL'
                                                   and o.abreviacion = 'TIPTRAVAL'
                                                   and o.codigon = s.tiptra)) ) 
          and vt.codect = v.codsol) DATAC_IDTIPDOC_EV, 
      (select abrdid from vtatipdid 
        where tipdide = (select vt.tipdide from vtatabslcfac v, VTATABECT vt 
                          where v.numslc = (select numslc from solot
                                             where codsolot = 
                                                 (select max(s.codsolot)
                                                    from solot s, solotpto pto
                                                   where s.codsolot = pto.codsolot
                                                     and pto.codinssrv = iso.codinssrv
                                                     and exists (select 1 from estsol e
                                                                  where e.estsol = s.estsol 
                                                                    and e.tipestsol in (1,2,3,4,6))
                                                     and exists (select 1
                                                                    from tipopedd t, opedd o
                                                                   where t.tipopedd = o.tipopedd
                                                                     and t.abrev = 'CONFSERVADICIONAL'
                                                                     and o.abreviacion = 'TIPTRAVAL'
                                                                     and o.codigon = s.tiptra)) ) 
                            and vt.codect = v.codsol)) DATAV_TIPDOC_EV,
      (select vt.ntdide from vtatabslcfac v, VTATABECT vt 
        where v.numslc = (select numslc from solot
                           where codsolot = 
                               (select max(s.codsolot)
                                  from solot s, solotpto pto
                                 where s.codsolot = pto.codsolot
                                   and pto.codinssrv = iso.codinssrv
                                   and exists (select 1 from estsol e
                                                where e.estsol = s.estsol 
                                                  and e.tipestsol in (1,2,3,4,6))
                                   and exists (select 1
                                                  from tipopedd t, opedd o
                                                 where t.tipopedd = o.tipopedd
                                                   and t.abrev = 'CONFSERVADICIONAL'
                                                   and o.abreviacion = 'TIPTRAVAL'
                                                   and o.codigon = s.tiptra)) ) 
          and vt.codect = v.codsol) DATAV_NUMDOC_EV,
      (select vt.nomect from vtatabslcfac v, VTATABECT vt 
        where v.numslc = (select numslc from solot
                           where codsolot = 
                               (select max(s.codsolot)
                                  from solot s, solotpto pto
                                 where s.codsolot = pto.codsolot
                                   and pto.codinssrv = iso.codinssrv
                                   and exists (select 1 from estsol e
                                                where e.estsol = s.estsol 
                                                  and e.tipestsol in (1,2,3,4,6))
                                   and exists (select 1
                                                  from tipopedd t, opedd o
                                                 where t.tipopedd = o.tipopedd
                                                   and t.abrev = 'CONFSERVADICIONAL'
                                                   and o.abreviacion = 'TIPTRAVAL'
                                                   and o.codigon = s.tiptra)) ) 
          and vt.codect = v.codsol) DATAV_NOM_EV,

      (SELECT vta.tipdoc FROM VTATIPDOCOFE vta, VTATABPRECON vp, vtatabslcfac v 
        WHERE vta.TIPDOC = vp.TIPDOC 
          and v.numslc = vp.numslc 
          and v.numslc = (select numslc from solot
                           where codsolot = 
                               (select max(s.codsolot)
                                  from solot s, solotpto pto
                                 where s.codsolot = pto.codsolot
                                   and pto.codinssrv = iso.codinssrv
                                   and exists (select 1 from estsol e
                                                where e.estsol = s.estsol 
                                                  and e.tipestsol in (1,2,3,4,6))
                                   and exists (select 1
                                                  from tipopedd t, opedd o
                                                 where t.tipopedd = o.tipopedd
                                                   and t.abrev = 'CONFSERVADICIONAL'
                                                   and o.abreviacion = 'TIPTRAVAL'
                                                   and o.codigon = s.tiptra)) )) DATAC_IDTIPVEN,
      (SELECT vta.DESCRIPCION FROM VTATIPDOCOFE vta, VTATABPRECON vp, vtatabslcfac v 
        WHERE vta.TIPDOC = vp.TIPDOC 
          and v.numslc = vp.numslc 
          and v.numslc = (select numslc from solot
                           where codsolot = 
                               (select max(s.codsolot)
                                  from solot s, solotpto pto
                                 where s.codsolot = pto.codsolot
                                   and pto.codinssrv = iso.codinssrv
                                   and exists (select 1 from estsol e
                                                where e.estsol = s.estsol 
                                                  and e.tipestsol in (1,2,3,4,6))
                                   and exists (select 1
                                                  from tipopedd t, opedd o
                                                 where t.tipopedd = o.tipopedd
                                                   and t.abrev = 'CONFSERVADICIONAL'
                                                   and o.abreviacion = 'TIPTRAVAL'
                                                   and o.codigon = s.tiptra)) )) DATAV_TIPVEN,
      (SELECT vp.NRODOC FROM VTATABPRECON vp, vtatabslcfac v 
        WHERE v.numslc = vp.numslc 
          and v.numslc = (select numslc from solot
                           where codsolot = 
                               (select max(s.codsolot)
                                  from solot s, solotpto pto
                                 where s.codsolot = pto.codsolot
                                   and pto.codinssrv = iso.codinssrv
                                   and exists (select 1 from estsol e
                                                where e.estsol = s.estsol 
                                                  and e.tipestsol in (1,2,3,4,6))
                                   and exists (select 1
                                                  from tipopedd t, opedd o
                                                 where t.tipopedd = o.tipopedd
                                                   and t.abrev = 'CONFSERVADICIONAL'
                                                   and o.abreviacion = 'TIPTRAVAL'
                                                   and o.codigon = s.tiptra)) )) DATAV_IDCONT,           
      (SELECT vp.CARTA FROM VTATABPRECON vp, vtatabslcfac v 
        WHERE v.numslc = vp.numslc 
          and v.numslc = (select numslc from solot
                           where codsolot = 
                               (select max(s.codsolot)
                                  from solot s, solotpto pto
                                 where s.codsolot = pto.codsolot
                                   and pto.codinssrv = iso.codinssrv
                                   and exists (select 1 from estsol e
                                                where e.estsol = s.estsol 
                                                  and e.tipestsol in (1,2,3,4,6))
                                   and exists (select 1
                                                  from tipopedd t, opedd o
                                                 where t.tipopedd = o.tipopedd
                                                   and t.abrev = 'CONFSERVADICIONAL'
                                                   and o.abreviacion = 'TIPTRAVAL'
                                                   and o.codigon = s.tiptra)) )) DATAN_NROCART,             
      (SELECT pr.idcarrier FROM PRECARRIER pr, VTATABPRECON vp, vtatabslcfac v 
        WHERE pr.IDCARRIER = vp.CARRIER 
          and v.numslc = vp.numslc 
          and v.numslc = (select numslc from solot
                           where codsolot = 
                               (select max(s.codsolot)
                                  from solot s, solotpto pto
                                 where s.codsolot = pto.codsolot
                                   and pto.codinssrv = iso.codinssrv
                                   and exists (select 1 from estsol e
                                                where e.estsol = s.estsol 
                                                  and e.tipestsol in (1,2,3,4,6))
                                   and exists (select 1
                                                  from tipopedd t, opedd o
                                                 where t.tipopedd = o.tipopedd
                                                   and t.abrev = 'CONFSERVADICIONAL'
                                                   and o.abreviacion = 'TIPTRAVAL'
                                                   and o.codigon = s.tiptra)) )) DATAC_CODOPE,
      (SELECT pr.descripcion FROM PRECARRIER pr, VTATABPRECON vp, vtatabslcfac v 
        WHERE pr.IDCARRIER = vp.CARRIER 
          and v.numslc = vp.numslc 
          and v.numslc = (select numslc from solot
                           where codsolot = 
                               (select max(s.codsolot)
                                  from solot s, solotpto pto
                                 where s.codsolot = pto.codsolot
                                   and pto.codinssrv = iso.codinssrv
                                   and exists (select 1 from estsol e
                                                where e.estsol = s.estsol 
                                                  and e.tipestsol in (1,2,3,4,6))
                                   and exists (select 1
                                                  from tipopedd t, opedd o
                                                 where t.tipopedd = o.tipopedd
                                                   and t.abrev = 'CONFSERVADICIONAL'
                                                   and o.abreviacion = 'TIPTRAVAL'
                                                   and o.codigon = s.tiptra)) )) DATAV_OPERADOR,
      (SELECT vp.presusc FROM VTATABPRECON vp, vtatabslcfac v 
        WHERE v.numslc = vp.numslc 
          and v.numslc = (select numslc from solot
                           where codsolot = 
                               (select max(s.codsolot)
                                  from solot s, solotpto pto
                                 where s.codsolot = pto.codsolot
                                   and pto.codinssrv = iso.codinssrv
                                   and exists (select 1 from estsol e
                                                where e.estsol = s.estsol 
                                                  and e.tipestsol in (1,2,3,4,6))
                                   and exists (select 1
                                                  from tipopedd t, opedd o
                                                 where t.tipopedd = o.tipopedd
                                                   and t.abrev = 'CONFSERVADICIONAL'
                                                   and o.abreviacion = 'TIPTRAVAL'
                                                   and o.codigon = s.tiptra)) )) DATAN_PRESUS,   
      (SELECT vp.publicar FROM VTATABPRECON vp, vtatabslcfac v 
        WHERE v.numslc = vp.numslc
          and v.numslc = (select numslc from solot
                           where codsolot = 
                               (select max(s.codsolot)
                                  from solot s, solotpto pto
                                 where s.codsolot = pto.codsolot
                                   and pto.codinssrv = iso.codinssrv
                                   and exists (select 1 from estsol e
                                                where e.estsol = s.estsol 
                                                  and e.tipestsol in (1,2,3,4,6))
                                   and exists (select 1
                                                  from tipopedd t, opedd o
                                                 where t.tipopedd = o.tipopedd
                                                   and t.abrev = 'CONFSERVADICIONAL'
                                                   and o.abreviacion = 'TIPTRAVAL'
                                                   and o.codigon = s.tiptra)) )) DATAN_PUBLI, 
      (SELECT t.idtipenv FROM billcolper.tipenveml t, VTATABPRECON vp, vtatabslcfac v 
        where vp.idtipenv = t.idtipenv 
          and v.numslc = vp.numslc 
          and v.numslc = (select numslc from solot
                           where codsolot = 
                               (select max(s.codsolot)
                                  from solot s, solotpto pto
                                 where s.codsolot = pto.codsolot
                                   and pto.codinssrv = iso.codinssrv
                                   and exists (select 1 from estsol e
                                                where e.estsol = s.estsol 
                                                  and e.tipestsol in (1,2,3,4,6))
                                   and exists (select 1
                                                  from tipopedd t, opedd o
                                                 where t.tipopedd = o.tipopedd
                                                   and t.abrev = 'CONFSERVADICIONAL'
                                                   and o.abreviacion = 'TIPTRAVAL'
                                                   and o.codigon = s.tiptra)) ) 
          and t.idtipenv <> 3) DATAN_IDTIPENVIO,
      (SELECT t.dsctipenv FROM billcolper.tipenveml t, VTATABPRECON vp, vtatabslcfac v 
        where vp.idtipenv = t.idtipenv 
          and v.numslc = vp.numslc
          and v.numslc = (select numslc from solot
                           where codsolot = 
                               (select max(s.codsolot)
                                  from solot s, solotpto pto
                                 where s.codsolot = pto.codsolot
                                   and pto.codinssrv = iso.codinssrv
                                   and exists (select 1 from estsol e
                                                where e.estsol = s.estsol 
                                                  and e.tipestsol in (1,2,3,4,6))
                                   and exists (select 1
                                                  from tipopedd t, opedd o
                                                 where t.tipopedd = o.tipopedd
                                                   and t.abrev = 'CONFSERVADICIONAL'
                                                   and o.abreviacion = 'TIPTRAVAL'
                                                   and o.codigon = s.tiptra)) ) 
          and t.idtipenv <> 3) DATAV_TIPENVIO,
      (SELECT vf.nomemail FROM marketing.vtaafilrecemail vf, VTATABPRECON vp, vtatabslcfac v 
        where vp.codemail = vf.codemail 
          and v.numslc = vp.numslc
          and v.numslc = (select numslc from solot
                           where codsolot = 
                               (select max(s.codsolot)
                                  from solot s, solotpto pto
                                 where s.codsolot = pto.codsolot
                                   and pto.codinssrv = iso.codinssrv
                                   and exists (select 1 from estsol e
                                                where e.estsol = s.estsol 
                                                  and e.tipestsol in (1,2,3,4,6))
                                   and exists (select 1
                                                  from tipopedd t, opedd o
                                                 where t.tipopedd = o.tipopedd
                                                   and t.abrev = 'CONFSERVADICIONAL'
                                                   and o.abreviacion = 'TIPTRAVAL'
                                                   and o.codigon = s.tiptra)) )) DATAV_CORELEC, 

       (select codest FROM v_ubicaciones WHERE vc.codubi = codubi) DATAV_IDDEP_DIRCLI,
       (select codpvc from v_ubicaciones where vc.codubi = codubi) DATAC_IDPROV_DIRCLI,
       (SELECT coddst FROM v_ubicaciones WHERE vc.codubi = codubi) DATAC_IDDIST_DIRCLI,
       (SELECT nomest FROM v_ubicaciones WHERE vc.codubi = codubi) DATAV_DEPA_DIRCLI,
       (select nompvc from v_ubicaciones where vc.codubi = codubi) DATAV_PROV_DIRCLI,         
       (SELECT nomdst FROM v_ubicaciones v WHERE vc.codubi = codubi) DATAV_DIST_DIRCLI, 
       vc.dircli DATAV_DIRCLI,
       vc.CODUBI DATAC_CODUBIDIR,
      (select vtd.ubigeo from MARKETING.VTATABDST vtd where vtd.codubi = vc.CODUBI) DATAC_UBIGEODIR,
       vc.TIPVIAP DATAC_IDTIPOVIADIR,
      (select tv.dlargu from pertbex02 tv where tv.cdargu = vc.TIPVIAP and tv.cdtabl = 'TV') DATAV_TIPOVIADIR,
       vc.NOMVIA DATAV_NOMVIADIR,
       vc.NUMVIA DATAV_NUMVIADIR,
       vc.IDTIPOOFICINA DATAN_IDTIPODOMIDIR,
      (select tpo.descripcion from TIPOOFICINA tpo where tpo.idtipooficina = vc.IDTIPOOFICINA) DATAV_TIPODOMIDIR,
       vc.NOMURB DATAV_NOMURBDIR,
       vc.CODZONA DATAN_IDZONADIR,
      (select zo.dsczona from zona zo where zo.CODZONA = vc.CODZONA) DATAV_ZONADIR,
       vc.REFERENCIA DATAV_REFERENCIADIR,
       vc.TELEFONO1 DATAV_TELF1DIR,
       vc.TELEFONO2 DATAV_TELF2DIR,
       vc.CODPOS DATAV_CODPOSDIR,
       vc.MANZANA DATAV_MANZANADIR,
       vc.LOTE DATAV_LOTEDIR,
       vc.SECTOR DATAV_SECTORDIR,
       vc.CODEDIFICIO DATAN_CODEDIFDIR,
      (select nombre from edificio where codigo = vc.CODEDIFICIO ) DATAV_EDIFICDIR,
       vc.PISO DATAN_PISODIR,
       vc.INTERIOR DATAV_INTERIORDIR,
       vc.NUMINTERIOR DATAV_NUM_INTERIORDIR,
       vc.IDPLANO DATAV_IDPLANODIR,
      (select vg.descripcion from VTATABGEOREF VG where vg.idplano = vc.IDPLANO and vg.codubi = vc.CODUBI) DATAV_PLANODIR,
      
       (select codest from v_ubicaciones where codubi = vs.ubisuc) DATAV_IDDEPI,
       (select codpvc from v_ubicaciones where codubi = vs.ubisuc) DATAC_IDPROVI,
       (select coddst from v_ubicaciones where codubi = vs.ubisuc) DATAC_IDDISTI,
       (select nomest from v_ubicaciones where codubi = vs.ubisuc) DATAV_DEPARTAMENTOI,
       (select nompvc from v_ubicaciones where codubi = vs.ubisuc) DATAV_PROVINCIAI,
       (select nomdst from v_ubicaciones where codubi = vs.ubisuc) DATAV_DISTRITOI,
       vs.dirsuc DATAV_DIRSUCI,
       vs.nomsuc DATAV_NOMSUCI, 
       vs.ubisuc DATAC_UBISUCI,
       (select vtd.ubigeo from MARKETING.VTATABDST vtd where vtd.codubi = vs.ubisuc) DATAC_UBIGEOI, 
       vs.tipviap DATAC_IDTIPOVIAI, 
       (select tv.dlargu from pertbex02 tv where tv.cdargu = vs.tipviap and tv.cdtabl = 'TV') DATAV_TIPOVIAI,  
       vs.nomvia DATAV_NOMVIAI, 
       vs.numvia DATAV_NUMVIAI, 
       vs.idtipooficina DATAN_IDTIPODOMII, 
       (select tpo.descripcion from TIPOOFICINA tpo where tpo.idtipooficina = vs.idtipooficina) DATAV_TIPODOMII,
       vs.idtipurb DATAN_IDTIPURBI,
       vs.nomurb DATAV_NOMURBI, 
       vs.codzona DATAN_IDZONAI, 
       (select zo.dsczona from zona zo where zo.CODZONA = vs.CODZONA) DATAV_ZONAI,
       vs.referencia DATAV_REFERENCIAI, 
       vs.telefono1 DATAV_TELF1I, 
       vs.telefono2 DATAV_TELF2I, 
       vs.codpos DATAV_CODPOSI, 
       vs.manzana DATAV_MANZANAI, 
       vs.lote DATAV_LOTEI, 
       vs.sector DATAV_SECTORI, 
       VS.CODEDI DATAN_CODEDIFI,
       (select nombre from edificio where codigo = VS.CODEDI ) DATAV_EDIFICIOI,
       vs.piso DATAN_PISOI, 
       vs.interior DATAV_INTERIORI,
       vs.numinterior DATAV_NUM_INTERIORI,
       VS.IDPLANO DATAV_IDPLANOI,
       (select vg.descripcion from VTATABGEOREF VG where vg.idplano = VS.IDPLANO and vg.codubi = vs.ubisuc) DATAV_PLANOI,
       
       (select codest from v_ubicaciones v, tabgrupo tg  where v.codubi = tg.codubifac and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_IDDEPF,
       (select codpvc from v_ubicaciones v, tabgrupo tg  where v.codubi = tg.codubifac and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAC_IDPROVF,
       (select coddst from v_ubicaciones v, tabgrupo tg  where v.codubi = tg.codubifac and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAC_IDDISTF,
       (select nomest from v_ubicaciones v, tabgrupo tg   where v.codubi = tg.codubifac and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_DEPARTAMENTOF,
       (select nompvc from v_ubicaciones v, tabgrupo tg   where v.codubi = tg.codubifac and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_PROVINCIAF,
       (select nomdst from v_ubicaciones v, tabgrupo tg   where v.codubi = tg.codubifac and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_DISTRITOF,
       
       (select dirfac from tabgrupo tg where tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_DIRSUCF,
 
       (select nomsuc from vtasuccli vt,tabgrupo tg where vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo)  DATAV_NOMSUCF,
      
       (select codubifac from tabgrupo tg  where tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAC_UBISUCF,
      
       (select vtd.ubigeo from MARKETING.VTATABDST vtd, tabgrupo tg where vtd.codubi = tg.codubifac and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAC_UBIGEOF, 
       
       (select tipviap from vtasuccli vt,tabgrupo tg  where vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAC_IDTIPOVIAF, 
       
       (select tv.dlargu from pertbex02 tv, vtasuccli vt,tabgrupo tg  where tv.cdargu = vt.tipviap and tv.cdtabl = 'TV' and vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_TIPOVIAF, 
       
       (select nomvia from vtasuccli vt,tabgrupo tg  where vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_NOMVIAF, 
       
       (select numvia from vtasuccli vt,tabgrupo tg  where vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_NUMVIAF,        
       
       (select idtipooficina from vtasuccli vt,tabgrupo tg  where vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAN_IDTIPODOMIF,               
       
       (select tpo.descripcion from TIPOOFICINA tpo, vtasuccli vt,tabgrupo tg  where tpo.idtipooficina = vt.idtipooficina and vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_TIPODOMIF,               

       (select idtipurb from vtasuccli vt,tabgrupo tg  where vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAN_IDTIPURBF,                      
       
       (select nomurb from vtasuccli vt,tabgrupo tg  where vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_NOMURBF,                      

       (select codzona from vtasuccli vt,tabgrupo tg  where vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAN_IDZONAF,                             
       
       (select zo.dsczona from zona zo, vtasuccli vt,tabgrupo tg  where zo.CODZONA = vt.CODZONA and vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_ZONAF,                             
       
       (select referencia from vtasuccli vt,tabgrupo tg  where vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_REFERENCIAF,                                    

       (select telefono1 from vtasuccli vt,tabgrupo tg  where vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_TELF1F,                                           

       (select telefono2 from vtasuccli vt,tabgrupo tg  where vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_TELF2F,                                                  
        
       (select codpos from vtasuccli vt,tabgrupo tg  where vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_CODPOSF,                                                         
       
       (select manzana from vtasuccli vt,tabgrupo tg  where vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_MANZANAF,                                                                

       (select lote from vtasuccli vt,tabgrupo tg  where vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_LOTEF,                                                                       

       (select sector from vtasuccli vt,tabgrupo tg  where vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_SECTORF,                                                                              

       (select CODEDI from vtasuccli vt,tabgrupo tg  where vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAN_CODEDIFF,                                                                                     

       (select nombre from edificio, vtasuccli vt,tabgrupo tg  where codigo = Vt.CODEDI and vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_EDIFICIOF,                                                                                     

       (select piso from vtasuccli vt,tabgrupo tg  where vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAN_PISOF,                                                                                            

       (select interior from vtasuccli vt,tabgrupo tg  where vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_INTERIORF,                                                                                                   
       
       (select numinterior from vtasuccli vt,tabgrupo tg  where vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_NUM_INTERIORF,                                                                                                          
       
       (select IDPLANO from vtasuccli vt,tabgrupo tg  where vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_IDPLANOF,                                                                                                          
       
       (select vg.descripcion from VTATABGEOREF VG, vtasuccli vt,tabgrupo tg  where vg.idplano = Vt.IDPLANO and vg.codubi = vt.ubisuc and vt.codcli = tg.codcli and vt.codsuc = tg.codsuc and tg.codcli = ipb.codcli and tg.grupo = ipb.grupo) DATAV_PLANOF,                                                                                                                 
       
        (select max(s.codsolot)
          from solot s, solotpto pto
         where s.codsolot = pto.codsolot
           and pto.codinssrv = iso.codinssrv
           and exists (select 1 from estsol e
                        where e.estsol = s.estsol 
                          and e.tipestsol in (1,2,3,4,6))
           and exists (select 1
                          from tipopedd t, opedd o
                         where t.tipopedd = o.tipopedd
                           and t.abrev = 'CONFSERVADICIONAL'
                           and o.abreviacion = 'TIPTRAVAL'
                           and o.codigon = s.tiptra)) DATAN_SOLOTACTV

  from instxproducto ipb,
       insprd       ipo,
       inssrv        iso,
       vtasuccli     vs,
       tystabsrv     ts,
       vtatabcli     vc,
       ciclo         c
       
where  
   ipb.pid = ipo.pid   
   and iso.codinssrv = ipo.codinssrv
   and ipb.codcli = vs.codcli
   and iso.codsuc = vs.codsuc
   and iso.codsrv = ts.codsrv
   and ipb.codcli = vc.codcli
   and ipb.cicfac = c.cicfac
   and vs.codcli = vc.codcli
   
   and 
 ( trunc(nvl(ipb.fecfin,'01/01/1900')) >= trunc(sysdate)
    or   
   
   trunc(nvl(ipb.fecfin,'01/01/1900')) ='01/01/1900'
  )   

   and exists (select 1 from OPERACION.Migrt_Clientes_a_Migrar cm where  ipb.codcli = cm.datac_codcli)
   and ipb.estado = 1
   and c.prefijo in ('XPL','3PL')
   and ipo.estinsprd in (1, 2)
   and ipo.codequcom is not null
   and iso.estinssrv in (1, 2)
   and (select tipsrv from vtatabslcfac where numslc = iso.numslc ) = '0061';--Masivos
-------------------------------      

begin

   FOR c_reg_principal IN c_principal loop
        insert into OPERACION.MIGRT_DATAPRINC (      
      DATAC_TIPO_PERSONA,
      DATAC_CODCLI,
      DATAV_NOMABR,
      DATAV_NOMCLI,
      DATAV_APEPAT,
      DATAV_APEMAT,
      DATAC_TIPDOC,
      DATAV_DESCDOC,
      DATAV_NUMDOC,
      DATAD_FECNAC,
      DATAD_FECHAINI,
      DATAD_FECHAFIN,
      DATAV_EMAILPRINC,
      DATAV_EMAIL1,
      DATAV_EMAIL2,
      DATAC_TIPSRV,
      DATAV_DESCTIPSRV,
      DATAN_CODCAMP,
      DATAV_DESCAMP,
      DATAN_CODPLAZO,
      DATAV_DESCPLAZO,
      DATAN_IDSOLUCION,
      DATAV_SOLUCION,
      DATAN_IDPAQ,
      DATAV_PAQUETE,
      DATAC_TIPPROD,
      DATAV_DESCTIPPROD,
      DATAN_IDPROD,
      DATAV_PROD,
      DATAV_EQ_PROD_SISACT,
      DATAC_CODSRV,
      DATAV_SERVICIO,
      DATAV_EQ_SERV_SISACT,
      DATAV_DESCPLAN,
      DATAV_TIPOSERVICIO,
      DATAN_IDESTSERV,
      DATAV_DESCESTSERV,
      DATAN_IDTIPINSS,
      DATAV_TIPINSS,
      DATAN_CODINSSRV,
      DATAN_PID,
      DATAN_IDMARCAEQUIPO,
      DATAV_MARCAEQUIPO,
      DATAC_CODTIPEQU,
      DATAN_TIPEQU,
      DATAV_TIPO_EQUIPO,
      DATAV_EQU_TIPO,
      DATAC_COD_EQUIPO,
      DATAV_MODELO_EQUIPO,
      DATAV_TIPO,
      DATAV_NUMERO,
      DATAN_CONTROL,
      DATAC_IDPROYECTO,
      DATAV_PLAY,
      DATAN_CARGOFIJO,
      DATAN_CANTIDAD,
      DATAC_PUBLICAR,
      DATAN_IDCICLO,
      DATAV_DESCICLO,
      DATAN_BW,
      DATAN_CIDVENTA,
      DATAC_CODSUCURSAL,
      DATAC_CODUBIGEO,
      DATAV_DIRVENTA,
      DATAV_CODPOSVENTA,
      DATAV_DESCVENTA,
      DATAC_COD_EV,
      DATAC_IDTIPDOC_EV,
      DATAV_TIPDOC_EV,
      DATAV_NUMDOC_EV,
      DATAV_NOM_EV,
      DATAC_IDTIPVEN,
      DATAV_TIPVEN,
      DATAV_IDCONT,
      DATAN_NROCART,
      DATAC_CODOPE,
      DATAV_OPERADOR,
      DATAN_PRESUS,
      DATAN_PUBLI,
      DATAN_IDTIPENVIO,
      DATAV_TIPENVIO,
      DATAV_CORELEC,
      DATAV_IDDEP_DIRCLI,
      DATAC_IDPROV_DIRCLI,
      DATAC_IDDIST_DIRCLI,
      DATAV_DEPA_DIRCLI,
      DATAV_PROV_DIRCLI,
      DATAV_DIST_DIRCLI,
      DATAV_DIRCLI,
      DATAC_CODUBIDIR,
      DATAC_UBIGEODIR,
      DATAC_IDTIPOVIADIR,
      DATAV_TIPOVIADIR,
      DATAV_NOMVIADIR,
      DATAV_NUMVIADIR,
      DATAN_IDTIPODOMIDIR,
      DATAV_TIPODOMIDIR,
      DATAV_NOMURBDIR,
      DATAN_IDZONADIR,
      DATAV_ZONADIR,
      DATAV_REFERENCIADIR,
      DATAV_TELF1DIR,
      DATAV_TELF2DIR,
      DATAV_CODPOSDIR,
      DATAV_MANZANADIR,
      DATAV_LOTEDIR,
      DATAV_SECTORDIR,
      DATAN_CODEDIFDIR,
      DATAV_EDIFICDIR,
      DATAN_PISODIR,
      DATAV_INTERIORDIR,
      DATAV_NUM_INTERIORDIR,
      DATAV_IDPLANODIR,
      DATAV_PLANODIR,
      DATAV_IDDEPI,
      DATAC_IDPROVI,
      DATAC_IDDISTI,
      DATAV_DEPARTAMENTOI,
      DATAV_PROVINCIAI,
      DATAV_DISTRITOI,
      DATAV_DIRSUCI,
      DATAV_NOMSUCI,
      DATAC_UBISUCI,
      DATAC_UBIGEOI,
      DATAC_IDTIPOVIAI,
      DATAV_TIPOVIAI,
      DATAV_NOMVIAI,
      DATAV_NUMVIAI,
      DATAN_IDTIPODOMII,
      DATAV_TIPODOMII,
      DATAN_IDTIPURBI,
      DATAV_NOMURBI,
      DATAN_IDZONAI,
      DATAV_ZONAI,
      DATAV_REFERENCIAI,
      DATAV_TELF1I,
      DATAV_TELF2I,
      DATAV_CODPOSI,
      DATAV_MANZANAI,
      DATAV_LOTEI,
      DATAV_SECTORI,
      DATAN_CODEDIFI,
      DATAV_EDIFICIOI,
      DATAN_PISOI,
      DATAV_INTERIORI,
      DATAV_NUM_INTERIORI,
      DATAV_IDPLANOI,
      DATAV_PLANOI,
      DATAV_IDDEPF,
      DATAC_IDPROVF,
      DATAC_IDDISTF,
      DATAV_DEPARTAMENTOF,
      DATAV_PROVINCIAF,
      DATAV_DISTRITOF,
      DATAV_DIRSUCF,
      DATAV_NOMSUCF,
      DATAC_UBISUCF,
      DATAC_UBIGEOF,
      DATAC_IDTIPOVIAF,
      DATAV_TIPOVIAF,
      DATAV_NOMVIAF,
      DATAV_NUMVIAF,
      DATAN_IDTIPODOMIF,
      DATAV_TIPODOMIF,
      DATAN_IDTIPURBF,
      DATAV_NOMURBF,
      DATAN_IDZONAF,
      DATAV_ZONAF,
      DATAV_REFERENCIAF,
      DATAV_TELF1F,
      DATAV_TELF2F,
      DATAV_CODPOSF,
      DATAV_MANZANAF,
      DATAV_LOTEF,
      DATAV_SECTORF,
      DATAN_CODEDIFF,
      DATAV_EDIFICIOF,
      DATAN_PISOF,
      DATAV_INTERIORF,
      DATAV_NUM_INTERIORF,
      DATAV_IDPLANOF,
      DATAV_PLANOF,
      DATAN_SOLOTACTV)
      values( C_REG_PRINCIPAL.DATAC_TIPO_PERSONA,
  C_REG_PRINCIPAL.DATAC_CODCLI,
  C_REG_PRINCIPAL.DATAV_NOMABR,
  C_REG_PRINCIPAL.DATAV_NOMCLI,
  C_REG_PRINCIPAL.DATAV_APEPAT,
  C_REG_PRINCIPAL.DATAV_APEMAT,
  C_REG_PRINCIPAL.DATAC_TIPDOC,
  C_REG_PRINCIPAL.DATAV_DESCDOC,
  C_REG_PRINCIPAL.DATAV_NUMDOC,
  C_REG_PRINCIPAL.DATAD_FECNAC,
  C_REG_PRINCIPAL.DATAD_FECHAINI,
  C_REG_PRINCIPAL.DATAD_FECHAFIN,
  C_REG_PRINCIPAL.DATAV_EMAILPRINC,
  C_REG_PRINCIPAL.DATAV_EMAIL1,
  C_REG_PRINCIPAL.DATAV_EMAIL2,
  C_REG_PRINCIPAL.DATAC_TIPSRV,
  C_REG_PRINCIPAL.DATAV_DESCTIPSRV,
  C_REG_PRINCIPAL.DATAN_CODCAMP,
  C_REG_PRINCIPAL.DATAV_DESCAMP,
  C_REG_PRINCIPAL.DATAN_CODPLAZO,
  C_REG_PRINCIPAL.DATAV_DESCPLAZO,
  C_REG_PRINCIPAL.DATAN_IDSOLUCION,
  C_REG_PRINCIPAL.DATAV_SOLUCION,
  C_REG_PRINCIPAL.DATAN_IDPAQ,
  C_REG_PRINCIPAL.DATAV_PAQUETE,
  C_REG_PRINCIPAL.DATAC_TIPPROD,
  C_REG_PRINCIPAL.DATAV_DESCTIPPROD,
  C_REG_PRINCIPAL.DATAN_IDPROD,
  C_REG_PRINCIPAL.DATAV_PROD,
  C_REG_PRINCIPAL.DATAV_EQ_PROD_SISACT,
  C_REG_PRINCIPAL.DATAC_CODSRV,
  C_REG_PRINCIPAL.DATAV_SERVICIO,
  C_REG_PRINCIPAL.DATAV_EQ_SERV_SISACT,
  C_REG_PRINCIPAL.DATAV_DESCPLAN,
  C_REG_PRINCIPAL.DATAV_TIPOSERVICIO,
  C_REG_PRINCIPAL.DATAN_IDESTSERV,
  C_REG_PRINCIPAL.DATAV_DESCESTSERV,
  C_REG_PRINCIPAL.DATAN_IDTIPINSS,
  C_REG_PRINCIPAL.DATAV_TIPINSS,
  C_REG_PRINCIPAL.DATAN_CODINSSRV,
  C_REG_PRINCIPAL.DATAN_PID,
  C_REG_PRINCIPAL.DATAN_IDMARCAEQUIPO,
  C_REG_PRINCIPAL.DATAV_MARCAEQUIPO,
  C_REG_PRINCIPAL.DATAC_CODTIPEQU,
  C_REG_PRINCIPAL.DATAN_TIPEQU,
  C_REG_PRINCIPAL.DATAV_TIPO_EQUIPO,
  C_REG_PRINCIPAL.DATAV_EQU_TIPO,
  C_REG_PRINCIPAL.DATAC_COD_EQUIPO,
  C_REG_PRINCIPAL.DATAV_MODELO_EQUIPO,
  C_REG_PRINCIPAL.DATAV_TIPO,
  C_REG_PRINCIPAL.DATAV_NUMERO,
  C_REG_PRINCIPAL.DATAN_CONTROL,
  C_REG_PRINCIPAL.DATAC_IDPROYECTO,
  C_REG_PRINCIPAL.DATAV_PLAY,
  C_REG_PRINCIPAL.DATAN_CARGOFIJO,
  C_REG_PRINCIPAL.DATAN_CANTIDAD,
  C_REG_PRINCIPAL.DATAC_PUBLICAR,
  C_REG_PRINCIPAL.DATAN_IDCICLO,
  C_REG_PRINCIPAL.DATAV_DESCICLO,
  C_REG_PRINCIPAL.DATAN_BW,
  C_REG_PRINCIPAL.DATAN_CIDVENTA,
  C_REG_PRINCIPAL.DATAC_CODSUCURSAL,
  C_REG_PRINCIPAL.DATAC_CODUBIGEO,
  C_REG_PRINCIPAL.DATAV_DIRVENTA,
  C_REG_PRINCIPAL.DATAV_CODPOSVENTA,
  C_REG_PRINCIPAL.DATAV_DESCVENTA ,
  C_REG_PRINCIPAL.DATAC_COD_EV,
  C_REG_PRINCIPAL.DATAC_IDTIPDOC_EV,
  C_REG_PRINCIPAL.DATAV_TIPDOC_EV,
  C_REG_PRINCIPAL.DATAV_NUMDOC_EV,
  C_REG_PRINCIPAL.DATAV_NOM_EV,
  C_REG_PRINCIPAL.DATAC_IDTIPVEN,
  C_REG_PRINCIPAL.DATAV_TIPVEN,
  C_REG_PRINCIPAL.DATAV_IDCONT,
  C_REG_PRINCIPAL.DATAN_NROCART,
  C_REG_PRINCIPAL.DATAC_CODOPE,
  C_REG_PRINCIPAL.DATAV_OPERADOR,
  C_REG_PRINCIPAL.DATAN_PRESUS,
  C_REG_PRINCIPAL.DATAN_PUBLI,
  C_REG_PRINCIPAL.DATAN_IDTIPENVIO,
  C_REG_PRINCIPAL.DATAV_TIPENVIO,
  C_REG_PRINCIPAL.DATAV_CORELEC,
  C_REG_PRINCIPAL.DATAV_IDDEP_DIRCLI,
  C_REG_PRINCIPAL.DATAC_IDPROV_DIRCLI,
  C_REG_PRINCIPAL.DATAC_IDDIST_DIRCLI,
  C_REG_PRINCIPAL.DATAV_DEPA_DIRCLI,
  C_REG_PRINCIPAL.DATAV_PROV_DIRCLI,
  C_REG_PRINCIPAL.DATAV_DIST_DIRCLI,
  C_REG_PRINCIPAL.DATAV_DIRCLI,
  C_REG_PRINCIPAL.DATAC_CODUBIDIR,
  C_REG_PRINCIPAL.DATAC_UBIGEODIR,
  C_REG_PRINCIPAL.DATAC_IDTIPOVIADIR,
  C_REG_PRINCIPAL.DATAV_TIPOVIADIR,
  C_REG_PRINCIPAL.DATAV_NOMVIADIR,
  C_REG_PRINCIPAL.DATAV_NUMVIADIR,
  C_REG_PRINCIPAL.DATAN_IDTIPODOMIDIR,
  C_REG_PRINCIPAL.DATAV_TIPODOMIDIR,
  C_REG_PRINCIPAL.DATAV_NOMURBDIR,
  C_REG_PRINCIPAL.DATAN_IDZONADIR,
  C_REG_PRINCIPAL.DATAV_ZONADIR,
  C_REG_PRINCIPAL.DATAV_REFERENCIADIR,
  C_REG_PRINCIPAL.DATAV_TELF1DIR,
  C_REG_PRINCIPAL.DATAV_TELF2DIR,
  C_REG_PRINCIPAL.DATAV_CODPOSDIR,
  C_REG_PRINCIPAL.DATAV_MANZANADIR,
  C_REG_PRINCIPAL.DATAV_LOTEDIR,
  C_REG_PRINCIPAL.DATAV_SECTORDIR,
  C_REG_PRINCIPAL.DATAN_CODEDIFDIR,
  C_REG_PRINCIPAL.DATAV_EDIFICDIR,
  C_REG_PRINCIPAL.DATAN_PISODIR,
  C_REG_PRINCIPAL.DATAV_INTERIORDIR,
  C_REG_PRINCIPAL.DATAV_NUM_INTERIORDIR,
  C_REG_PRINCIPAL.DATAV_IDPLANODIR,
  C_REG_PRINCIPAL.DATAV_PLANODIR,
  C_REG_PRINCIPAL.DATAV_IDDEPI,
  C_REG_PRINCIPAL.DATAC_IDPROVI,
  C_REG_PRINCIPAL.DATAC_IDDISTI,
  C_REG_PRINCIPAL.DATAV_DEPARTAMENTOI,
  C_REG_PRINCIPAL.DATAV_PROVINCIAI,
  C_REG_PRINCIPAL.DATAV_DISTRITOI,
  C_REG_PRINCIPAL.DATAV_DIRSUCI,
  C_REG_PRINCIPAL.DATAV_NOMSUCI,
  C_REG_PRINCIPAL.DATAC_UBISUCI,
  C_REG_PRINCIPAL.DATAC_UBIGEOI,
  C_REG_PRINCIPAL.DATAC_IDTIPOVIAI,
  C_REG_PRINCIPAL.DATAV_TIPOVIAI,
  C_REG_PRINCIPAL.DATAV_NOMVIAI,
  C_REG_PRINCIPAL.DATAV_NUMVIAI,
  C_REG_PRINCIPAL.DATAN_IDTIPODOMII,
  C_REG_PRINCIPAL.DATAV_TIPODOMII,
  C_REG_PRINCIPAL.DATAN_IDTIPURBI,
  C_REG_PRINCIPAL.DATAV_NOMURBI,
  C_REG_PRINCIPAL.DATAN_IDZONAI,
  C_REG_PRINCIPAL.DATAV_ZONAI,
  C_REG_PRINCIPAL.DATAV_REFERENCIAI,
  C_REG_PRINCIPAL.DATAV_TELF1I,
  C_REG_PRINCIPAL.DATAV_TELF2I,
  C_REG_PRINCIPAL.DATAV_CODPOSI,  
  C_REG_PRINCIPAL.DATAV_MANZANAI,
  C_REG_PRINCIPAL.DATAV_LOTEI,
  C_REG_PRINCIPAL.DATAV_SECTORI,
  C_REG_PRINCIPAL.DATAN_CODEDIFI,
  C_REG_PRINCIPAL.DATAV_EDIFICIOI,
  C_REG_PRINCIPAL.DATAN_PISOI,
  C_REG_PRINCIPAL.DATAV_INTERIORI,
  C_REG_PRINCIPAL.DATAV_NUM_INTERIORI,
  C_REG_PRINCIPAL.DATAV_IDPLANOI,
  C_REG_PRINCIPAL.DATAV_PLANOI  ,
  C_REG_PRINCIPAL.DATAV_IDDEPF  ,
  C_REG_PRINCIPAL.DATAC_IDPROVF ,
  C_REG_PRINCIPAL.DATAC_IDDISTF ,
  C_REG_PRINCIPAL.DATAV_DEPARTAMENTOF ,
  C_REG_PRINCIPAL.DATAV_PROVINCIAF  ,
  C_REG_PRINCIPAL.DATAV_DISTRITOF ,
  C_REG_PRINCIPAL.DATAV_DIRSUCF ,
  C_REG_PRINCIPAL.DATAV_NOMSUCF ,
  C_REG_PRINCIPAL.DATAC_UBISUCF ,
  C_REG_PRINCIPAL.DATAC_UBIGEOF ,
  C_REG_PRINCIPAL.DATAC_IDTIPOVIAF, 
  C_REG_PRINCIPAL.DATAV_TIPOVIAF  ,
  C_REG_PRINCIPAL.DATAV_NOMVIAF ,
  C_REG_PRINCIPAL.DATAV_NUMVIAF ,
  C_REG_PRINCIPAL.DATAN_IDTIPODOMIF ,
  C_REG_PRINCIPAL.DATAV_TIPODOMIF ,
  C_REG_PRINCIPAL.DATAN_IDTIPURBF ,
  C_REG_PRINCIPAL.DATAV_NOMURBF ,
  C_REG_PRINCIPAL.DATAN_IDZONAF ,
  C_REG_PRINCIPAL.DATAV_ZONAF ,
  C_REG_PRINCIPAL.DATAV_REFERENCIAF,
  C_REG_PRINCIPAL.DATAV_TELF1F  ,
  C_REG_PRINCIPAL.DATAV_TELF2F  ,
  C_REG_PRINCIPAL.DATAV_CODPOSF ,
  C_REG_PRINCIPAL.DATAV_MANZANAF  ,
  C_REG_PRINCIPAL.DATAV_LOTEF ,
  C_REG_PRINCIPAL.DATAV_SECTORF,
  C_REG_PRINCIPAL.DATAN_CODEDIFF,
  C_REG_PRINCIPAL.DATAV_EDIFICIOF,
  C_REG_PRINCIPAL.DATAN_PISOF ,
  C_REG_PRINCIPAL.DATAV_INTERIORF ,
  C_REG_PRINCIPAL.DATAV_NUM_INTERIORF ,
  C_REG_PRINCIPAL.DATAV_IDPLANOF  ,
  C_REG_PRINCIPAL.DATAV_PLANOF  ,
  C_REG_PRINCIPAL.DATAN_SOLOTACTV
     );      
  END LOOP;
    
   commit;           
end;  
/
