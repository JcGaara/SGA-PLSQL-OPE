CREATE OR REPLACE PROCEDURE OPERACION.P_RADIOBASE_10_5 IS
--DECLARE
    cursor c_RADIOBASE_10_5 is
                  SELECT ubired.descripcion SITE,--1
                       ubired.codubired codigosite,--2
                       ambientered.descripcion ambiente,--3
                       equipored.descripcion equipo,--4
                       tarjetaxequipo.descripcion tarjeta,--5
                       tarjetaxequipo.slot, --6
                       puertoxequipo.puerto,--7
                       estado.descripcion estado_puerto,--8
                       a.bw, --9
                       a.bwoperaciones,--10
                       puertoxequipo.IDE, --11
                       cxi.cid,--12
                       productocorp.descripcion PRODUCTO,--13
                       v.nomcli, --14
                       TS.DSCTIPSRV FAMILIA_SERVICIO,--15
                       TA.DSCSRV SERVICIO,--16
                       EI.DESCRIPCION estado_servicio,--17
                       a.descripcion SEDE,--18
                       a.direccion,--19
                       a.descripcion_acceso DATOS_CID,--20
                       puertoxequipo.descripcion DATOS_IDE, --21
                       puertoxequipo.fecasig,--22
                       puertoxequipo.fecinst,--23
                       V_PROVENL.DESCRIPCION PROVEEDOR_ENLACE,--24
                       V_MEDIOTX.DESCRIPCION MEDIO_TRANSMISION, --25
                       TO_CHAR (SYSDATE,'YYYYMM') PERIODO,--29
                       TRUNC (SYSDATE - 1) FEC_DAT,--30
                       TRUNC (SYSDATE) FEC_EJE--31
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
                         TYSTIPSRV TS,
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
                         upper(substr(equipored.descripcion,1,3)) = 'RB_' ;
                         /*and
                         ubired.codubired in  (84,89,752,770,995,996,997,998,999,1001,1004,1060,1080,1081,1082,1112,1114,
                                              1116,1129,1090,1127,1107,1115,1126,1128,1089,1118,977,115,980,990)*/
                         /*ubired.codubired in  (84,752,770,995,996,998,999,1001,1060,1080,1081,1082,1112,1114,
                                              1116,1129,1090,1127,1107,1115,1126,1128,1089,1118,977,115,980,990)*/

    BEGIN
                       DELETE FROM OPERACIONES.t_RADIOBASE_10_5@pedwhprd.world;
                       FOR l_RADIOBASE_10_5 IN c_RADIOBASE_10_5 LOOP
                           INSERT INTO OPERACIONES.t_RADIOBASE_10_5@pedwhprd.world VALUES (
                                       l_RADIOBASE_10_5.SITE,--1
                                       l_RADIOBASE_10_5.codigosite,--2
                                       l_RADIOBASE_10_5.ambiente,--3
                                       l_RADIOBASE_10_5.equipo,--4
                                       l_RADIOBASE_10_5.tarjeta,--5
                                       l_RADIOBASE_10_5.slot,--6
                                       l_RADIOBASE_10_5.puerto,--7
                                       l_RADIOBASE_10_5.estado_puerto,--8
                                       l_RADIOBASE_10_5.bw,--9
                                       l_RADIOBASE_10_5.bwoperaciones,--10
                                       l_RADIOBASE_10_5.IDE,--11
                                       l_RADIOBASE_10_5.cid,--12
                                       l_RADIOBASE_10_5.PRODUCTO,--13
                                       l_RADIOBASE_10_5.nomcli,--14
                                       l_RADIOBASE_10_5.FAMILIA_SERVICIO,--15
                                       l_RADIOBASE_10_5.SERVICIO,--16
                                       l_RADIOBASE_10_5.estado_servicio,--17
                                       l_RADIOBASE_10_5.SEDE,--18
                                       l_RADIOBASE_10_5.direccion,--19
                                       l_RADIOBASE_10_5.DATOS_CID,--20
                                       l_RADIOBASE_10_5.DATOS_IDE, --21
                                       l_RADIOBASE_10_5.fecasig,--22
                                       l_RADIOBASE_10_5.fecinst,--23
                                       l_RADIOBASE_10_5.PROVEEDOR_ENLACE,--24
                                       l_RADIOBASE_10_5.MEDIO_TRANSMISION,--25
                                       l_RADIOBASE_10_5.PERIODO,
                                       l_RADIOBASE_10_5.FEC_DAT,
                                       l_RADIOBASE_10_5.FEC_EJE
                                       );
                            COMMIT;
                         END LOOP;
     END;
/


