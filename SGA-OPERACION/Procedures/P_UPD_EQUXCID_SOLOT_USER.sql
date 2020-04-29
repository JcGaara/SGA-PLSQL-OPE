CREATE OR REPLACE PROCEDURE OPERACION.P_UPD_EQUXCID_SOLOT_USER ( a_codsolot in number, a_punto in number, a_orden in number, a_CID in number, a_User in VarChar, a_Area in Varchar )IS

/******************************************************************************
Se pasa un equipoc/componentes que aparece en la Ot al inventario
******************************************************************************/

l_orden number(10);
l_FECINS date;
l_estado equxcid.estado%type;

BEGIN
--  dbms_output.put_line('OK: ' || a_codsolot);
  select nvl(max(orden),0) + 1 into l_orden from equxcid where cid = a_cid and nivel = 0;
  insert into equxcid (
   CID, ORDEN, ORDENPAD, TIPEQU, CANTIDAD, NIVEL, FECINS, ESTADO, RED,  NUMSERIE, PROPIETARIO, IOS, OBSERVACION, CODUSU, AREA)
   select
   a_CID, l_orden, null, TIPEQU,  CANTIDAD,  0,   FECINS, decode (estado, 2, 'EN INSTALACION',
                                                       5, 'INSTALACION TEMPORAL',
                                      4, 'INSTALACION DEFINITIVA',
                                      3, 'EN PRESTAMO',
                                      1, 'DESCONECTADO',
                                      6, 'FALLADO',
                                      7, 'DEMO'),

            TIPO, NUMSERIE,decode(tipprp, 0, 'FC',1, 'FC Alquiler',
                            2, 'FC Venta',
                            3, 'Cliente',
                            4, 'Otros', null ),
           null,  OBSERVACION, a_User, a_area
   from solotptoequ
   where
   codsolot = a_codsolot and
   punto = a_punto and
   orden = a_orden;

   select FECINS, decode (estado, 2, 'EN INSTALACION',
                                                       5, 'INSTALACION TEMPORAL',
                                      4, 'INSTALACION DEFINITIVA',
                                      3, 'EN PRESTAMO',
                                      1, 'DESCONECTADO',
                                      6, 'FALLADO',
                                      7, 'DEMO')
   into l_fecins, l_estado
   from solotptoequ where
   codsolot = a_codsolot and
   punto = a_punto and
   orden = a_orden;

   /* componenetes */
  insert into equxcid (
   CID, ORDEN,             ORDENPAD, TIPEQU, CANTIDAD, NIVEL, FECINS, ESTADO,              NUMSERIE, PROPIETARIO, IOS, OBSERVACION, CODUSU, AREA)
   select
   a_CID, l_orden * 1000 + rownum, l_orden, TIPEQU,  CANTIDAD,  1,   nvl(FECINS,l_fecins), nvl(decode (estado, 2, 'EN INSTALACION',
                                                       5, 'INSTALACION TEMPORAL',
                                      4, 'INSTALACION DEFINITIVA',
                                      3, 'EN PRESTAMO',
                                      1, 'DESCONECTADO',
                                      6, 'FALLADO',
                                      7, 'DEMO'), l_estado ), NUMSERIE, null, null,  OBSERVACION, a_User, a_Area
   from solotptoequcmp
   where
   codsolot = a_codsolot and
   punto = a_punto and
   orden = a_orden;

      update solotptoequ set flginv = 1, fecinv = sysdate
   where
   codsolot = a_codsolot and
   punto = a_punto and
   orden = a_orden;

   exception
--      when e_error_l then
--        dbms_output.put_line(lv_mensaje);
      when  others then dbms_output.put_line('FALLO: ' || a_codsolot);

   /* se actualiza el flag */

END;
/


