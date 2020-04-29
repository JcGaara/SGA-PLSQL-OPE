CREATE OR REPLACE VIEW OPERACION.VM_OPE_FACTURAS AS
select fac.idfac,
       fac.codcli,
       fac.nomcli,
       fac.nomabr,
       fac.sldact,
       fac.tipdoc,
       fac.sersut,
       fac.numsut,
       fac.fecemi,
       fac.fecven,
       bil.idisprincipal,
       ins.codinssrv,
       fac.recosi,
       fac.estfacrec,
       ins.idgrupocorte,
       ins.estinssrv,
       ins.codsegmark,
       bil.cicfac,
       bil.grupo,
       ins.idsolucion
  from cxctabfac fac, bilfac bil, COLLECTIONS.V_OPE_INSTANCIA_SERVICIO ins
 where fac.idfac = bil.idfaccxc
   and fac.codcli = bil.codcli
   and bil.codcli = ins.codcli
   and bil.idisprincipal = ins.idinstserv
   and fac.estfac in ('02', '04') --02 emitido y 04 cancelado parcialmente
   and collections.pq_cxc_corte.f_valida_doc_refinanciado(fac.idfac) = 0
   and fac.tipdoc in
       (SELECT codigoc
          FROM tipopedd t, opedd o
         WHERE t.tipopedd = o.tipopedd
           AND TRIM(t.abrev) = 'CONF_PORTAL_CAUTIVO'
           AND TRIM(o.abreviacion) = 'REC_PORTAL_C')
   and ins.idgrupocorte = 12
   and fac.sldact >=
       (select codigon
          from tipopedd t, opedd o
         where t.tipopedd = o.tipopedd
           and trim(t.abrev) = 'CONF_PORTAL_CAUTIVO'
           and trim(o.abreviacion) = 'MONTO_PC')
   and fac.gencarcta in
       (select codigon
          from tipopedd t, opedd o
         where t.tipopedd = o.tipopedd
           and trim(t.abrev) = 'CONF_PORTAL_CAUTIVO'
           and trim(o.abreviacion) = 'CARGO_CTA_PC');
