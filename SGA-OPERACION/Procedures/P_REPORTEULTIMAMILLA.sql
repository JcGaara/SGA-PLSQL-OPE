CREATE OR REPLACE PROCEDURE OPERACION.p_reporteultimamilla IS

            --DECLARE
                  CURSOR c_reporteultimamilla IS
                    SELECT o170564.CODIGO as CODIGO,--E170569,--1
                          o170564.DESCRIPCION as DESCRIPCION,--E170570,--2
                          o170564.SITE as SITE,--E170571,--3
                          o170564.ESTADO_EQUIPO as ESTADO_EQUIPO,--E170572,--4
                          o170564.TIPO_EQUIPO as TIPO_EQUIPO,--E170573,--5
                          o170564.IP as IP,--E170574,--6
                          o170564.DIRECCION as DIRECCION,--E170575,--7
                          o170564.NAMING_CONVENTION as NAMING_CONVENTION,--E170576,--8
                          o170564.AMBIENTE as AMBIENTE,--E170577,--9
                          o170564.RACK as RACK,--E170578,--10
                          o170564.MARCA as MARCA,--E170579,--11
                          o170564.EQUIPO_MODELO as EQUIPO_MODELO,--E170580,--12
                          o170564.ACCESO_RED as ACCESO_RED,--E170581,--13
                          o170564.ASIGNACION as ASIGNACION,--E170582,--14
                          o170564.INI_SERVICIO as INI_SERVICIO,--E170583,--15
                          o170564.SLOT as SLOT,--E170584,--16
                          o170564.SUBSLOT as SUBSLOT,--E170585,--17
                          o170564.TARJETA as TARJETA,--E170586,--18
                          o170564.ESTADO as ESTADO,--E170587,--19
                          o170564.TIPO as TIPO,--E170588,--20
                          o170564.TARJETA_OBS as TARJETA_OBS,--E170614,--21
                          o170564.TARJETA_MODELO as TARJETA_MODELO,--E170590,--22
                          o170564.NSERIE as NSERIE,--E170591,--23
                          ----
                          substr(LTRIM(o170564.TIPOALMACEN),1,200) as TIPOALMACEN,--E170592,--24
                          ----
                          o170564.FW_REVISION as FW_REVISION,--E170593,--25
                          o170564.FW_REVISION_BC as FW_REVISION_BC,--E170594,--26
                          o170564.PATRON as PATRON,--E170615--27
                          o170564.codusumod,
                          o170564.fecusumod,                          
                        TO_CHAR (SYSDATE,'YYYYMM') PERIODO,
                        TRUNC (SYSDATE - 1) FEC_DAT,
                        TRUNC (SYSDATE) FEC_EJE
                    FROM (  SELECT equipored.codequipo Codigo,
                         equipored.descripcion Descripcion,
                         ubired.descripcion Site,
                         o2.descripcion Estado_Equipo,
                         tipequipored.descripcion Tipo_Equipo,
                         equipored.ip IP,
                         ubired.direccion Direccion,
                         equipored.namcon Naming_Convention,
                         ambientered.descripcion Ambiente,
                         rackred.descripcion Rack,
                         equipored.marca Marca,
                         equipored.modelo Equipo_Modelo,
                         v_dd_ubic_equipored.descripcion Acceso_Red,
                         equipored.fecasig Asignacion,
                         equipored.fecini Ini_servicio,
                         tarjetaxequipo.slot Slot,
                         tarjetaxequipo.flgsubtarj SubSlot,
                         tarjetaxequipo.descripcion Tarjeta,
                         o1.descripcion Estado,
                         t1.descripcion Tipo,
                         tarjetaxequipo.observacion Tarjeta_Obs,
                         tarjetaxequipo.modelo Tarjeta_Modelo,
                         tarjetaxequipo.fc_numserie NSerie,
                         TE1.descripcion TipoAlmacen,
                         tarjetaxequipo.version_ios FW_Revision,
                         tarjetaxequipo.version_ios_bc FW_Revision_BC,
                         (select o3.descripcion from opedd o3 where o3.tipopedd = 13 and o3.codigon = tipequipored.patron) Patron,
                         tarjetaxequipo.codusumod,
                         tarjetaxequipo.fecusumod
                    FROM EQUIPORED,
                         ubired,
                         TIPEQU,
                         tipequipored,
                         ambientered,
                         rackred,
                         TARJETAXEQUIPO,
                         TIPEQU TE1,
                         TIPEQU TE2,
                         TIPOTARJETA T1,
                         TIPOTARJETA T2,
                         opedd o1,
                         opedd o2,
                         v_dd_ubic_equipored
                    WHERE o1.codigon = tarjetaxequipo.estado(+)
                     and o1.tipopedd = 35
                     and o2.codigon = equipored.estado(+)
                     and o2.tipopedd = 36
                     and EQUIPORED.TIPEQU = TIPEQU.TIPEQU(+)
                     and equipored.codubired = ubired.codubired(+)
                     and equipored.codambiente = ambientered.codambiente(+)
                     and tipequipored.codtipo(+) = equipored.tipo
                     and equipored.codrack = rackred.codrack(+)
                     and TARJETAXEQUIPO.CODEQUIPO = EQUIPORED.CODEQUIPO
                     AND TE1.TIPEQU(+) = TARJETAXEQUIPO.TIPEQU
                     AND TE2.TIPEQU(+) = TARJETAXEQUIPO.TIPEQU_BC
                     AND T1.CODTIPTAR(+) = TARJETAXEQUIPO.CODTIPTARJ
                     AND T2.CODTIPTAR(+) = TARJETAXEQUIPO.CODTIPTARJ_BC
                     and v_dd_ubic_equipored.tipo(+) = equipored.acceso_red
                    order by equipored.codequipo, tarjetaxequipo.slot asc
                    ) o170564;

         BEGIN
                    DELETE FROM operaciones.t_reporteultimamilla@PEDWHPRD.WORLD;
                    FOR l_reporteultimamilla IN c_reporteultimamilla LOOP
                        INSERT INTO operaciones.t_reporteultimamilla@PEDWHPRD.WORLD VALUES (
                                                        l_reporteultimamilla.codigo,
                                                        l_reporteultimamilla.descripcion,
                                                        l_reporteultimamilla.site,
                                                        l_reporteultimamilla.estado_equipo,
                                                        l_reporteultimamilla.tipo_equipo,
                                                        l_reporteultimamilla.ip,
                                                        l_reporteultimamilla.direccion,
                                                        l_reporteultimamilla.naming_convention,
                                                        l_reporteultimamilla.ambiente,
                                                        l_reporteultimamilla.rack,
                                                        l_reporteultimamilla.marca,
                                                        l_reporteultimamilla.equipo_modelo,
                                                        l_reporteultimamilla.acceso_red,
                                                        l_reporteultimamilla.asignacion,
                                                        l_reporteultimamilla.ini_servicio,
                                                        l_reporteultimamilla.slot,
                                                        l_reporteultimamilla.subslot,
                                                        l_reporteultimamilla.tarjeta,
                                                        l_reporteultimamilla.estado,
                                                        l_reporteultimamilla.tipo,
                                                        l_reporteultimamilla.tarjeta_obs,
                                                        l_reporteultimamilla.tarjeta_modelo,
                                                        l_reporteultimamilla.nserie,
                                                        l_reporteultimamilla.tipoalmacen,--
                                                        l_reporteultimamilla.fw_revision,
                                                        l_reporteultimamilla.fw_revision_bc,
                                                        l_reporteultimamilla.patron,
                                                        l_reporteultimamilla.PERIODO,
                                                        l_reporteultimamilla.FEC_DAT,
                                                        l_reporteultimamilla.FEC_EJE,
                                                        l_reporteultimamilla.codusumod,
                                                        l_reporteultimamilla.fecusumod                                                        
                                                        );
                        COMMIT;
                    END LOOP;
END;
/


