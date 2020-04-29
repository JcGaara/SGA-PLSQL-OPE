CREATE OR REPLACE PROCEDURE OPERACION.p_tif
IS
/************************************************************
   NOMBRE:     PQ_sots_agendadas
   PROPOSITO:
   PROGRAMADO EN JOB:  NO

   REVISIONES:
   Ver        Fecha        Autor             Descripcion
   ---------  ----------  ---------------    ------------------------
   1.0        24/09/2009  Cesar Rosciano       req. 103782
     ***********************************************************/

--DECLARE
  nConta Number;
  CURSOR c_tif IS
SELECT
                  tabla_principal.Modulo,
                  tabla_principal.periodo,
                  tabla_principal.fec_eje,
                  tabla_principal.Codigo_Servicio,
                  tabla_principal.FAMILIA_SERVICIO,
                  tabla_principal.Cantidad,
                           case
                              --PRIS
                              when tabla_principal.Codigo_Servicio IN ('50000','50001','250') then '001'
                              --Acceso a Internet
                              when tabla_principal.Codigo_Servicio IN ('0006')  then '002'
                              --Portador Local
                              when tabla_principal.Codigo_Servicio in ('0005','0036','0052','0060') then '003'
                              --Portador Larga Distancia
                              when tabla_principal.Codigo_Servicio in ('0014','0042','0019','0022','0049','0053','0066') then '004'
                              else '999'
                            end Grupo

                  FROM
                  (
--*****************     'Acceso a Internet'
SELECT  'Acceso a Internet' Modulo,to_char(sysdate,'yyyymm') periodo,
                  trunc(sysdate) fec_eje,tabla_1.Codigo_Servicio,tabla_1.FAMILIA_SERVICIO, count (*) Cantidad
                  FROM
                  (

SELECT
distinct

cxi.cid,------verificarubired.descripcion SITE,
       /*ambientered.descripcion ambiente,
       equipored.descripcion equipo,
       tarjetaxequipo.descripcion tarjeta,
       tarjetaxequipo.slot,
       puertoxequipo.puerto,
       estado.descripcion estado_puerto,
       a.bw,
       a.bwoperaciones,
       puertoxequipo.IDE,

       productocorp.descripcion PRODUCTO,
       v.codcli,---
       v.nomcli,*/
       TS.TIPSRV Codigo_Servicio,
       TS.DSCTIPSRV FAMILIA_SERVICIO
       /*TA.DSCSRV SERVICIO,
       EI.DESCRIPCION estado_servicio,
       a.descripcion SEDE,
       a.direccion,
       a.descripcion_acceso DATOS_CID,
       puertoxequipo.descripcion DATOS_IDE,
       puertoxequipo.fecasig,
       puertoxequipo.fecinst,
       V_PROVENL.DESCRIPCION PROVEEDOR_ENLACE,
       V_MEDIOTX.DESCRIPCION MEDIO_TRANSMISION*/
    FROM puertoxequipo,
         equipored,
         tarjetaxequipo,
         productocorp,
         tipequipored,
         ubired,
         ambientered,
         rackred,
         (select codigon, descripcion from opedd where tipopedd = 22) estado,
         cidxide cxi,
         acceso a,
         vtatabcli v,
         INSSRV I,
         TYSTIPSRV TS,--
         TYSTABSRV TA,
         ESTINSSRV EI,
         (SELECT CODIGON,DESCRIPCION FROM OPEDD WHERE TIPOPEDD = 151) V_PROVENL,
         (SELECT CODIGON,DESCRIPCION FROM OPEDD WHERE TIPOPEDD = 169) V_MEDIOTX
   WHERE
         equipored.codequipo (+) = puertoxequipo.codequipo and
         tarjetaxequipo.codtarjeta (+) = puertoxequipo.codtarjeta and
         productocorp.codprd (+) = puertoxequipo.codprd and
         puertoxequipo.estado = estado.codigon and
         equipored.tipo = tipequipored.codtipo(+) and
         equipored.codubired = ubired.codubired(+) and
         equipored.codambiente = ambientered.codambiente(+) and
         equipored.codrack = rackred.codrack(+) and
         puertoxequipo.ide = cxi.ide(+) and
         cxi.cid = a.cid(+) and
         v.codcli (+) = a.codcli and
         a.CODINSSRV= I.CODINSSRV(+) AND
         I.TIPSRV=TS.TIPSRV(+) AND
         I.CODSRV=TA.CODSRV(+) AND
         I.ESTINSSRV = EI.ESTINSSRV(+) and
         PUERTOXEQUIPO.PROVENLACE = V_PROVENL.CODIGON(+) AND
         PUERTOXEQUIPO.MEDIOTX = V_MEDIOTX.CODIGON(+) and
         --v.codcli not in ('00017603','00088224')
         EI.ESTINSSRV in (1,2) and---activo, suspendido
         TS.TIPSRV='0006' and ---Acceso a Internet
         v.codcli not in ('00003653','00006932','00017603','00022812','00088224','00329691','00380908','00385533',
                          '00580366','00577343','00600376','00603669','00632976','00652155','00665270','00663565',
                          '00006046','00441083','00385487')

 ) tabla_1
        Group By tabla_1.Codigo_Servicio,tabla_1.FAMILIA_SERVICIO

UNION

--*****************     'Portador Larga Distancia'
SELECT  'Portador Larga Distancia' Modulo,to_char(sysdate,'yyyymm') periodo,
                  trunc(sysdate) fec_eje,tabla_2.Codigo_Servicio,tabla_2.FAMILIA_SERVICIO, count (*) Cantidad
                  FROM
                  (

SELECT

distinct /*ubired.descripcion SITE,
       ambientered.descripcion ambiente,
       equipored.descripcion equipo,
       tarjetaxequipo.descripcion tarjeta,
       tarjetaxequipo.slot,
       puertoxequipo.puerto,
       estado.descripcion estado_puerto,
       a.bw,
       a.bwoperaciones,
       puertoxequipo.IDE,*/
       cxi.cid,--
       /*productocorp.descripcion PRODUCTO,
       v.codcli,---
       v.nomcli,*/
       TS.TIPSRV Codigo_Servicio,--
       TS.DSCTIPSRV FAMILIA_SERVICIO--
       /*TA.DSCSRV SERVICIO,
       EI.DESCRIPCION estado_servicio,
       a.descripcion SEDE,
       a.direccion,
       a.descripcion_acceso DATOS_CID,
       puertoxequipo.descripcion DATOS_IDE,
       puertoxequipo.fecasig,
       puertoxequipo.fecinst,
       V_PROVENL.DESCRIPCION PROVEEDOR_ENLACE,
       V_MEDIOTX.DESCRIPCION MEDIO_TRANSMISION*/
    FROM puertoxequipo,
         equipored,
         tarjetaxequipo,
         productocorp,
         tipequipored,
         ubired,
         ambientered,
         rackred,
         (select codigon, descripcion from opedd where tipopedd = 22) estado,
         cidxide cxi,
         acceso a,
         vtatabcli v,
         INSSRV I,
         TYSTIPSRV TS,--
         TYSTABSRV TA,
         ESTINSSRV EI,
         (SELECT CODIGON,DESCRIPCION FROM OPEDD WHERE TIPOPEDD = 151) V_PROVENL,
         (SELECT CODIGON,DESCRIPCION FROM OPEDD WHERE TIPOPEDD = 169) V_MEDIOTX
   WHERE
         equipored.codequipo (+) = puertoxequipo.codequipo and
         tarjetaxequipo.codtarjeta (+) = puertoxequipo.codtarjeta and
         productocorp.codprd (+) = puertoxequipo.codprd and
         puertoxequipo.estado = estado.codigon and
         equipored.tipo = tipequipored.codtipo(+) and
         equipored.codubired = ubired.codubired(+) and
         equipored.codambiente = ambientered.codambiente(+) and
         equipored.codrack = rackred.codrack(+) and
         puertoxequipo.ide = cxi.ide(+) and
         cxi.cid = a.cid(+) and
         v.codcli (+) = a.codcli and
         a.CODINSSRV= I.CODINSSRV(+) AND
         I.TIPSRV=TS.TIPSRV(+) AND
         I.CODSRV=TA.CODSRV(+) AND
         I.ESTINSSRV = EI.ESTINSSRV(+) and
         PUERTOXEQUIPO.PROVENLACE = V_PROVENL.CODIGON(+) AND
         PUERTOXEQUIPO.MEDIOTX = V_MEDIOTX.CODIGON(+) and
         --v.codcli not in ('00017603','00088224')
         EI.ESTINSSRV in (1,2) and---activo, suspendido
         TS.TIPSRV in ('0014','0042','0019','0022','0049','0053','0066') and ---Portador Larga Distancia
         v.codcli not in ('00003653','00006932','00017603','00022812','00088224','00329691','00380908','00385533',
                          '00580366','00577343','00600376','00603669','00632976','00652155','00665270','00663565',
                          '00006046','00441083','00385487')

 ) tabla_2
        Group By tabla_2.Codigo_Servicio,tabla_2.FAMILIA_SERVICIO

UNION

--*****************     'Portador Local'
SELECT  'Portador Local' Modulo,to_char(sysdate,'yyyymm') periodo,
                  trunc(sysdate) fec_eje,tabla_3.Codigo_Servicio,tabla_3.FAMILIA_SERVICIO, count (*) Cantidad
                  FROM
                  (

SELECT
distinct
/*ubired.descripcion SITE,
       ambientered.descripcion ambiente,
       equipored.descripcion equipo,
       tarjetaxequipo.descripcion tarjeta,
       tarjetaxequipo.slot,
       puertoxequipo.puerto,
       estado.descripcion estado_puerto,
       a.bw,
       a.bwoperaciones,
       puertoxequipo.IDE,*/
       cxi.cid,--
       /*productocorp.descripcion PRODUCTO,
       v.codcli,---
       v.nomcli,*/
       TS.TIPSRV Codigo_Servicio,--
       TS.DSCTIPSRV FAMILIA_SERVICIO--
       /*TA.DSCSRV SERVICIO,
       EI.DESCRIPCION estado_servicio,
       a.descripcion SEDE,
       a.direccion,
       a.descripcion_acceso DATOS_CID,
       puertoxequipo.descripcion DATOS_IDE,
       puertoxequipo.fecasig,
       puertoxequipo.fecinst,
       V_PROVENL.DESCRIPCION PROVEEDOR_ENLACE,
       V_MEDIOTX.DESCRIPCION MEDIO_TRANSMISION*/
    FROM puertoxequipo,
         equipored,
         tarjetaxequipo,
         productocorp,
         tipequipored,
         ubired,
         ambientered,
         rackred,
         (select codigon, descripcion from opedd where tipopedd = 22) estado,
         cidxide cxi,
         acceso a,
         vtatabcli v,
         INSSRV I,
         TYSTIPSRV TS,--
         TYSTABSRV TA,
         ESTINSSRV EI,
         (SELECT CODIGON,DESCRIPCION FROM OPEDD WHERE TIPOPEDD = 151) V_PROVENL,
         (SELECT CODIGON,DESCRIPCION FROM OPEDD WHERE TIPOPEDD = 169) V_MEDIOTX
   WHERE
         equipored.codequipo (+) = puertoxequipo.codequipo and
         tarjetaxequipo.codtarjeta (+) = puertoxequipo.codtarjeta and
         productocorp.codprd (+) = puertoxequipo.codprd and
         puertoxequipo.estado = estado.codigon and
         equipored.tipo = tipequipored.codtipo(+) and
         equipored.codubired = ubired.codubired(+) and
         equipored.codambiente = ambientered.codambiente(+) and
         equipored.codrack = rackred.codrack(+) and
         puertoxequipo.ide = cxi.ide(+) and
         cxi.cid = a.cid(+) and
         v.codcli (+) = a.codcli and
         a.CODINSSRV= I.CODINSSRV(+) AND
         I.TIPSRV=TS.TIPSRV(+) AND
         I.CODSRV=TA.CODSRV(+) AND
         I.ESTINSSRV = EI.ESTINSSRV(+) and
         PUERTOXEQUIPO.PROVENLACE = V_PROVENL.CODIGON(+) AND
         PUERTOXEQUIPO.MEDIOTX = V_MEDIOTX.CODIGON(+) and
         --v.codcli not in ('00017603','00088224')
         EI.ESTINSSRV in (1,2) and---activo, suspendido
         TS.TIPSRV in ('0005','0036','0052','0060') and ---Portador Local
           v.codcli not in ('00003653','00006932','00017603','00022812','00088224','00329691','00380908','00385533',
                          '00580366','00577343','00600376','00603669','00632976','00652155','00665270','00663565',
                          '00006046','00441083','00385487')

 ) tabla_3
        Group By tabla_3.Codigo_Servicio,tabla_3.FAMILIA_SERVICIO

UNION

--*****************     'PRIS'
SELECT
                  'PRIS' Modulo,
                  to_char(sysdate,'yyyymm') periodo,
                  trunc(sysdate) fec_eje,
                  '50000' Codigo_Servicio, --cod_descripcion_producto,
                  'Pris Canales' FAMILIA_SERVICIO, --descripcion_producto,
                  SUM(CANTCIRCUITOS) Cantidad
                  FROM CAMINO
                  WHERE CAMINO.IDCENTRAL=3
                  AND CAMINO.IDCAMINO >=  1000
                  AND CAMINO.DESCRIPCION NOT IN (SELECT DESCRIPCION FROM CAMINO WHERE DESCRIPCION LIKE '%TELMEX%') --omitir las cantidades que en su descripcion contenga la palabra TELMEX
                  AND CAMINO.ESTADOTRONCAL = 1 --solicitado por Carlos Yapias 11/02/2009

UNION

SELECT  'PUNTORED' Modulo,to_char(sysdate,'yyyymm') periodo,
                  trunc(sysdate) fec_eje,to_char(tabla_4.cod_descripcion_producto) cod_descripcion_producto,tabla_4.descripcion_producto, count (*) Cantidad
                  FROM
                  (
                  --Select de los todos los puntos de red excepto NATIONAL IP DATA SERICES
                  SELECT distinct
                           puertoxequipo.codpuerto,
                           puertoxequipo.IDE,
                           equipored.descripcion equipo,
                           tarjetaxequipo.descripcion tarjeta,
                           puertoxequipo.descripcion,
                           estado.descripcion estado_puerto,
                           puertoxequipo.fecasig,
                           puertoxequipo.fecinst,
                           puertoxequipo.puerto,
                           puertoxequipo.servicio,
                           productocorp.codprd cod_descripcion_producto,
                           productocorp.descripcion descripcion_producto,
                           productocorp.tipoproducto,
                           tarjetaxequipo.slot,
                           tarjetaxequipo.flgsubtarj,
                           tarjetaxequipo.codtiptarj,
                           puertoxequipo.codprd,
                           --select * from estado .descripcion
                           puertoxequipo.estado,
                           puertoxequipo.tipo,
                           puertoxequipo.codequipo,
                           puertoxequipo.codtarjeta,
                           tipequipored.descripcion,
                           ubired.descripcion,
                           V_PROVENL.DESCRIPCION PROVEEDOR_ENLACE,
                           PUERTOXEQUIPO.PROVENLACE,
                           PUERTOXEQUIPO.INTERFACE,
                           ambientered.descripcion ambiente,
                           rackred.descripcion rack,
                           puertoxequipo.mediotx,
                           V_MEDIOTX.DESCRIPCION MEDIO_TRANSMISION,
                           CIDXIDE.NSR,
                           puertoxequipo.coordenadas,
                           soluciones.idsolucion,
                           soluciones.solucion
                           --SELECT * FROM productocorp WHERE mostrar=1 order by descripcion
                      FROM puertoxequipo,
                           equipored,
                           tarjetaxequipo,
                           productocorp,
                           tipequipored,
                           ubired,
                           ambientered,
                           rackred,
                           (SELECT CODIGON,DESCRIPCION FROM OPEDD WHERE TIPOPEDD = 151) V_PROVENL,
                           (select codigon, descripcion from opedd where tipopedd = 22) estado,
                           (SELECT CODIGON,DESCRIPCION FROM OPEDD WHERE TIPOPEDD = 169) V_MEDIOTX,
                           CIDXIDE,
                           ACCESO,
                           (select distinct(codinssrv) codinssrv,numslc from vtadetptoenl where codinssrv is not null) detproy,
                           vtatabslcfac,
                           soluciones
                     WHERE
                           ( equipored.codequipo (+) = puertoxequipo.codequipo) and
                           ( tarjetaxequipo.codtarjeta (+) = puertoxequipo.codtarjeta) and
                           ( productocorp.codprd (+) = puertoxequipo.codprd) and
                           ( puertoxequipo.estado = estado.codigon ) and
                           equipored.tipo = tipequipored.codtipo(+) and
                           equipored.codubired = ubired.codubired(+) and
                           equipored.codambiente = ambientered.codambiente(+) and
                           equipored.codrack = rackred.codrack(+) AND
                           PUERTOXEQUIPO.PROVENLACE = V_PROVENL.CODIGON(+) AND
                           PUERTOXEQUIPO.MEDIOTX = V_MEDIOTX.CODIGON(+) AND
                           CIDXIDE.CID(+)=PUERTOXEQUIPO.CID AND
                           CIDXIDE.IDE(+)=PUERTOXEQUIPO.IDE and
                           puertoxequipo.cid = acceso.cid(+)  and
                           acceso.codinssrv  =  detproy.codinssrv(+) and
                           detproy.numslc = vtatabslcfac.numslc(+) and
                           vtatabslcfac.idsolucion = soluciones.idsolucion(+) AND
                           productocorp.mostrar=1 AND
                           productocorp.codprd <> 2 AND
                           estado.descripcion='Activo' AND
                           (to_char(puertoxequipo.fecinst,'yyyymm') <= (to_char(sysdate,'yyyymm')-1)  OR puertoxequipo.fecinst Is NUll)
                           and productocorp.codprd = '250'
                           ORDER BY productocorp.descripcion

                        ) tabla_4
                        Group By tabla_4.cod_descripcion_producto,tabla_4.descripcion_producto
union
                 --Select para hallar la consulta exlor@ (SGA - Atencion al Cliente/Reportes/Otros/Consulta Explra, filtro 01/08/2006 hasta el ultimo dia del periodo)
                  SELECT
                  'CONSULTAXPLORA' Modulo,
                  to_char(sysdate,'yyyymm') periodo,
                  trunc(sysdate) fec_eje,
                  '50001' cod_descripcion_producto,
                  'Lineas Analogicas Explora' descripcion_producto,
                  sum (to_number(Cantidad)) Cantidad
                  FROM
                  (
                  SELECT ubired.descripcion SITE,
                         ambientered.descripcion ambiente,
                         equipored.descripcion equipo,
                         (select descripcion
                            from tipotarjeta
                           where codtiptar = tarjetaxequipo.codtiptarj) tipotarjeta,
                         tarjetaxequipo.descripcion tarjeta,
                         PUERTOXEQUIPO.INTERFACE,
                         tarjetaxequipo.slot,
                         tarjetaxequipo.flgsubtarj, --~"S.SLOT~",
                         puertoxequipo.puerto,
                         estado.descripcion estado,
                         puertoxequipo.IDE,
                         puertoxequipo.descripcion,
                         V_MEDIOTX.DESCRIPCION MEDIO_TRANSMISION,
                         productocorp.descripcion,
                         V_PROVENL.DESCRIPCION PROVEEDOR_ENLACE,
                         tipequipored.descripcion tipoequipo,
                         puertoxequipo.fecasig,
                         puertoxequipo.fecinst,
                         rackred.descripcion rack,
                         (SELECT count(ta.idproducto)
                            FROM acceso,
                                 vtatabcli,
                                 INSSRV I,
                                 TYSTIPSRV TS,
                                 TYSTABSRV TA,
                                 ESTINSSRV EI,
                                 CIDXIDE CXI
                           WHERE (vtatabcli.codcli(+) = acceso.codcli)
                             and ACCESO.CODINSSRV = I.CODINSSRV(+)
                             AND I.TIPSRV = TS.TIPSRV(+)
                             AND I.CODSRV = TA.CODSRV(+)
                             AND I.ESTINSSRV = EI.ESTINSSRV(+)
                             and CXI.CID = ACCESO.CID
                             and ta.idproducto in (select idproducto from planproducto)
                             AND CXI.IDE = puertoxequipo.IDE) Cantidad
                    FROM puertoxequipo,
                         equipored,
                         tarjetaxequipo,
                         productocorp,
                         tipequipored,
                         ubired,
                         ambientered,
                         rackred,
                         (SELECT CODIGON, DESCRIPCION FROM OPEDD WHERE TIPOPEDD = 151) V_PROVENL,
                         (select codigon, descripcion from opedd where tipopedd = 22) estado,
                         (SELECT CODIGON, DESCRIPCION FROM OPEDD WHERE TIPOPEDD = 169) V_MEDIOTX
                   WHERE (equipored.codequipo(+) = puertoxequipo.codequipo)
                     and (tarjetaxequipo.codtarjeta(+) = puertoxequipo.codtarjeta)
                     and (productocorp.codprd(+) = puertoxequipo.codprd)
                     and (puertoxequipo.estado = estado.codigon)
                     and equipored.tipo = tipequipored.codtipo(+)
                     and equipored.codubired = ubired.codubired(+)
                     and equipored.codambiente = ambientered.codambiente(+)
                     and equipored.codrack = rackred.codrack(+)
                     AND PUERTOXEQUIPO.PROVENLACE = V_PROVENL.CODIGON(+)
                     AND PUERTOXEQUIPO.MEDIOTX = V_MEDIOTX.CODIGON(+)
                     and puertoxequipo.codprd in (719,708,716,709,712,721,710,713,717,714,711,706,704,705)
                     and puertoxequipo.estado = 1
                     --And puertoxequipo.fecasig between to_date('01/08/2006','dd/mm/yyyy') and to_date('30/11/2008','dd/mm/yyyy')
                     AND to_char(puertoxequipo.fecasig,'yyyymm') between '200608' and to_char(sysdate,'yyyymm')-1
                     ) Tabla_5

 ) Tabla_Principal;
 BEGIN
                    --No se vuelva insertar mas registros en el mismo dia de ejecucion
                    Select count(*) Into nConta from operaciones.t_tif@pedwhprd.world Where periodo = to_char(sysdate,'yyyymm');--Fec_eje = trunc(sysdate -1);
                    If nConta = 0 then
                    FOR l_tif IN c_tif LOOP
                         INSERT INTO operaciones.t_tif@pedwhprd.world VALUES (
                                                            l_tif.Modulo,
                                                            l_tif.periodo,
                                                            l_tif.fec_eje,
                                                            l_tif.Codigo_Servicio,--cod_descripcion_producto,
                                                            l_tif.FAMILIA_SERVICIO,--descripcion_producto,
                                                            l_tif.Cantidad,
                                                            l_tif.Grupo
                                                                           );
                                       COMMIT;
                                  END LOOP;
                                  END IF;
                           END;
/


