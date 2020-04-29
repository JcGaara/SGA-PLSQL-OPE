CREATE OR REPLACE VIEW OPERACION.V_INSTANCIA_SERVICIO
AS 
SELECT vtatabcli.nomcli iso_nomcli,
       ipb_cliente.nomcli ipb_nomcli,
       inssrv.codinssrv iso_codinssrv,
       inssrv.descripcion iso_descripcion,
       inssrv.direccion iso_direccion,
       inssrv.numero iso_numero,
       inssrv.cid iso_cid,
       estinssrv.descripcion iso_estado,
       tipinssrv.abrevi iso_tipo,
       inssrv.tipinssrv iso_tipinssrv,
       instanciaservicio.idinstserv isb_codigo_idinstserv,
       instanciaservicio.descripcion isb_descripcion,
       instanciaservicio.nomabr isb_nomabr,
       instanciaservicio.fecini isb_fecini,
       instanciaservicio.fecfin isb_fecfin,
       insprd.pid ipo_pid,
       estinsprd.descripcion ipo_estado,
       tystabsrv.dscsrv ipo_servicio,
       insprd.codsrv ipo_codsrv,
       insprd.fecini ipo_fecini,
       insprd.fecfin ipo_fecfin,
       insprd.numslc ipo_numslc,
       insprd.numpto ipo_numpto,
       insprd.codequcom ipo_codequcom,
       insprd.cantidad ipo_cantidad,
       instxproducto.idinstprod ipb_codigo_idinstprod,
       instxproducto.idproducto ipb_idproducto,
       instxproducto.idcod ipb_codigo_idinstserv,
       instxproducto.fecini ipb_fecini,
       instxproducto.fecfin ipb_fecfin,
       instxproducto.cantidad ipb_cantidad,
       instxproducto.montocr ipb_cr,
       instxproducto.montocnr ipb_cnr,
       instxproducto.ultfeccor ipb_ultima_facturacion,
       instxproducto.idmonedauso ipb_idmonedauso,
       DECODE (instxproducto.estado, 1, 'Activo', instxproducto.estado) ipb_estado,
       vtatabcli.codcli iso_codcli,
       instanciaservicio.codcli isb_codcli,
       instxproducto.codcli ipb_codcli,
       producto.descripcion ipb_descripcion_producto,
       vtaequcom.dscequ ipo_descripcion_equipo,
       instanciaservicio.ispadre isb_padre,
       is_padre.nomabr isb_nomabr_padre
  FROM insprd,
       inssrv,
       instanciaservicio,
       instxproducto,
       vtatabcli,
       estinsprd,
       estinssrv,
       tystabsrv,
       tipinssrv,
       vtatabcli ipb_cliente,
       producto,
       vtaequcom,
       instanciaservicio is_padre
 WHERE
       inssrv.codinssrv = insprd.codinssrv
   AND insprd.pid = instxproducto.pid(+)
   AND instxproducto.idcod = instanciaservicio.idinstserv(+)
   AND inssrv.tipinssrv = tipinssrv.tipinssrv
   AND inssrv.codcli = vtatabcli.codcli(+)
   AND estinsprd.estinsprd = insprd.estinsprd
   AND estinssrv.estinssrv = inssrv.estinssrv
   AND insprd.codsrv = tystabsrv.codsrv
   AND instxproducto.codcli = ipb_cliente.codcli(+)
   AND instxproducto.idproducto = producto.idproducto(+)
   AND insprd.codequcom = vtaequcom.codequcom(+)
   AND instanciaservicio.ispadre = is_padre.idinstserv(+);


