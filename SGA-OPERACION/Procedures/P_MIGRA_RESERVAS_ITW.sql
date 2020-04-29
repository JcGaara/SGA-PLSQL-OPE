CREATE OR REPLACE PROCEDURE OPERACION.P_MIGRA_RESERVAS_ITW(
p_id_cliente in varchar2,
p_codsolot in number,
p_indicador in number,
p_salida out varchar2)
IS
    V_TELEFONO varchar2(3000);
    V_HOMEEX varchar2(3000);
    v_id_venta int_mensaje_salida_intraway.id_venta%type;
    v_id_interfaz_stb int_mensaje_salida_intraway.id_interfaz%type;
    v_id_interfaz_cm int_mensaje_salida_intraway.id_interfaz%type;
    v_id_interfaz_mta int_mensaje_salida_intraway.id_interfaz%type;
    v_mta_interfaz    int_mensaje_salida_intraway.id_interfaz%type;
    v_mta_id_venta    int_mensaje_salida_intraway.id_venta%type;
    v_mta_id_venta_padre int_mensaje_salida_intraway.id_venta_padre%type;
    v_mta_promotor     int_mensaje_salida_intraway.id_promotor_padre%type;
    v_activationcode   INT_MENSAJE_SALIDA_ATRIB_IWAY.VALOR_ATRIBUTO%type;
    v_profile          INT_MENSAJE_SALIDA_ATRIB_IWAY.VALOR_ATRIBUTO%type;
    v_cm_interfaz     int_mensaje_salida_intraway.id_interfaz%type;
    v_cm_id_venta      int_mensaje_salida_intraway.id_venta%type;
    v_cm_id_venta_padre  int_mensaje_salida_intraway.id_venta_padre%type;
    v_cm_promotor      int_mensaje_salida_intraway.id_promotor_padre%type;
    v_activationcode_cm  INT_MENSAJE_SALIDA_ATRIB_IWAY.VALOR_ATRIBUTO%type;
    v_codigo_ext      INT_MENSAJE_SALIDA_ATRIB_IWAY.VALOR_ATRIBUTO%type;
    V_EndpointNumber  INT_MENSAJE_SALIDA_ATRIB_IWAY.VALOR_ATRIBUTO%type;
    v_cantcpe     INT_MENSAJE_SALIDA_ATRIB_IWAY.VALOR_ATRIBUTO%type;
    v_valatrib_ua_stb  INT_MENSAJE_SALIDA_ATRIB_IWAY.VALOR_ATRIBUTO%type;
    v_valatrib_sn_stb INT_MENSAJE_SALIDA_ATRIB_IWAY.VALOR_ATRIBUTO%type;

    v_countcm number;
    v_countmta number;
    v_count_stb number;
    v_count_stb_ca number;
    v_countep number;
--    v_countcola number;
    v_countcmins number;
    v_countmtains number;
    v_countespacio number;
    p_resultado varchar2(30);
    p_mensaje varchar2(200);
    p_error number;
    v_countstbins NUMBER;
    v_salida varchar2(3000);
    v_channelmap varchar2(100);
    v_sendtocontroler varchar2(30);
    v_activationcode_stb varchar2(30);
    v_a_productocrm varchar2(30);

    v_id_ventamta int_mensaje_salida_intraway.ID_VENTA%TYPE;
    v_id_cliente  int_mensaje_salida_intraway.ID_CLIENTE%TYPE;
    v_valatrib_ma_cm int_mensaje_salida_atrib_iway.valor_atributo%type;
    v_valatrib_ma_mta int_mensaje_salida_atrib_iway.valor_atributo%type;
    v_valatrib_lq_mta int_mensaje_salida_atrib_iway.valor_atributo%type;
    v_valatrib_mmc_mta int_mensaje_salida_atrib_iway.valor_atributo%type;
    v_a_defaultConfigCRMId int_mensaje_salida_atrib_iway.valor_atributo%type;
    excepcion_mtaprov exception;
    excepcion_cmprov exception;
    excepcion_stbprov exception;
cursor c_stb_migra is
    select STBSGA.IDCAMPO, STBSGA.PID, STBMANUAL.ID_INTERFAZ
    FROM
    (select ROWNUM IDCAMPO, Z.ID_PRODUCTO PID, '' ID_INTERFAZ
    FROM INTRAWAY.INT_SERVICIO_INTRAWAY Z
    WHERE Z.id_cliente = v_id_cliente
    AND Z.codsolot = P_codsolot AND ID_INTERFASE = 2020) STBSGA,
     ( SELECT ROWNUM IDCAMPO, '' PID,
    (           SELECT s.id_interfaz
                     FROM int_mensaje_salida_intraway s
                        WHERE s.id_venta = S1.id_venta
                           AND s.id_interfase = 2022
                          AND s.id_error = 0
                          AND s.mensaje = 'Operation Success'
                          AND s.id_estado = 1
                          AND s.id_interfaz = (
                              SELECT max(id_interfaz) FROM int_mensaje_salida_intraway s2
                              WHERE s2.id_venta = s.id_venta
                              AND s2.id_venta = S1.id_venta
                              AND s2.id_interfase = 2022
                              AND s2.id_error = 0
                              AND s2.mensaje = 'Operation Success'
                              AND s2.id_estado = 1  )) ID_INTERFAZ

            FROM int_mensaje_salida_intraway s1
            WHERE s1.id_interfase = 2020
                  AND s1.id_error = 0
                  AND s1.mensaje = 'Operation Success'
                  AND s1.id_estado = 1
                  AND s1.id_cliente = p_id_cliente
                  AND s1.id_venta <> 0
    AND EXISTS
    (           SELECT 'XXXX'
                   FROM int_mensaje_salida_intraway s
                      WHERE s.id_venta = S1.id_venta
                         AND s.id_interfase = 2020
                        AND s.id_error = 0
                        AND s.mensaje = 'Operation Success'
                        AND s.id_estado = 2
                        AND s.id_interfaz = (
                            SELECT max(id_interfaz) FROM int_mensaje_salida_intraway s2
                            WHERE s2.id_venta = s.id_venta
                            AND s2.id_venta = S1.id_venta
                            AND s2.id_interfase = 2020
                            AND s2.id_error = 0
                            AND s2.mensaje = 'Operation Success'))
    AND EXISTS
    (           SELECT 'YYYY'
                     FROM int_mensaje_salida_intraway s
                        WHERE s.id_venta = S1.id_venta
                           AND s.id_interfase = 2022
                          AND s.id_error = 0
                          AND s.mensaje = 'Operation Success'
                          AND s.id_estado = 1
                          AND s.id_interfaz = (
                              SELECT max(id_interfaz) FROM int_mensaje_salida_intraway s2
                              WHERE s2.id_venta = s.id_venta
                              AND s2.id_venta = S1.id_venta
                              AND s2.id_interfase = 2022
                              AND s2.id_error = 0
                              AND s2.mensaje = 'Operation Success'
                              AND s2.id_estado = 1  )) ) STBMANUAL
    WHERE STBSGA.IDCAMPO = STBMANUAL.IDCAMPO;

BEGIN

/*  I := 0;
  J := 0;
  K := 0;
  m := 0;
  P := 0;
  Q := 0;
  r := 0;*/

  p_error := 0;
  v_countstbins := 0;
  v_salida := 'La migración de la reserva manual al SGA concluyó satisfactoriamente.';

  p_error := 0;

  /****************************** MIGRACIONES *******************************************/
  IF p_indicador = 2 AND p_error = 0 THEN -- Se desea migrar los servicios
       /****************************** Transferencia a Intraway *******************************************/
       PQ_INTRAWAY_PROCESO.P_INT_PROCESO ( 3, p_codsolot,p_resultado, p_mensaje, p_error );

       IF p_error <> 0 THEN
          p_mensaje := 'No se realizó correctamente la transferencia a Intraway de la SOT ' || p_codsolot|| ' '|| p_mensaje;
          --p_mensaje := p_mensaje ||' '||'No se realizó correctamente la eliminación del espacio del STB para el IdVenta: ' || lc2.id_venta;
          p_salida := p_mensaje;
          INTRAWAY.PQ_INTRAWAY.P_CREA_MENSAJE_ERROR ( 1111,
                                              'INTRAWAY.P_MIGRA_RESERVAS_ITW',
                                              p_codsolot,
                                              p_error);
       ELSE
          --Obtener el Cliente del SGA
          SELECT codcli
          INTO v_id_cliente
          FROM SOLOT
          WHERE codsolot = p_codsolot;

          -- Verificar si los servicios estuvieron instalados anteriormente
          /****************************** Cable Modem *******************************************/
            BEGIN

             SELECT NVL(valor_atributo, 'X')
               into v_valatrib_ma_cm
               FROM INT_MENSAJE_SALIDA_ATRIB_IWAY
              WHERE ID_MENSAJE_SALIDA_INTRAWAY = (
                   SELECT max(ID_INTERFAZ) FROM INT_MENSAJE_SALIDA_INTRAWAY Y
                   WHERE ID_CLIENTE = p_id_cliente AND ID_VENTA > 0
                   AND ID_INTERFASE = 622 )
              and nombre_atributo = 'MacAddress';

            EXCEPTION
              WHEN OTHERS THEN
                 p_error := 99;
                 v_valatrib_ma_cm := 'X';
            END;

            if p_error = 0 and v_valatrib_ma_cm <> 'X' then
              PQ_INTRAWAY_PROCESO.P_CM_PROVISION(3,p_codsolot,v_id_cliente,v_valatrib_ma_cm,p_resultado,p_mensaje,p_error);
            END IF;

              IF p_error <> 0 THEN
                 p_mensaje := 'No se realizo la provisión para el CM en la SOLOT: '  || to_char(p_codsolot)|| ' '|| p_mensaje;
                 --p_mensaje := p_mensaje ||' ' ||'No se realizo la provisión para el CM en la SOLOT: '  || to_char(p_codsolot);
                  p_salida := p_mensaje;
                  INTRAWAY.PQ_INTRAWAY.P_CREA_MENSAJE_ERROR ( 1111,
                                                      'INTRAWAY.P_MIGRA_RESERVAS_ITW',
                                                      p_codsolot,
                                                      p_mensaje);

              END IF;


            /****************************** MTA *******************************************/
          --  IF v_countmtains > 0 THEN
             /* IF Q = 1 and m = 0 and o_error = 0 and o_mensaje = 'Operation Success' THEN*/
               BEGIN

                   SELECT max(ID_INTERFAZ)
                   INTO v_id_interfaz_mta
                   FROM INT_MENSAJE_SALIDA_INTRAWAY Y
                   WHERE ID_CLIENTE = p_id_cliente AND ID_VENTA > 0
                   AND ID_INTERFASE = 822 ;

                  select a.valor_atributo into v_valatrib_ma_mta
                  from int_mensaje_salida_atrib_iway a
                  where a.id_mensaje_salida_intraway = v_id_interfaz_mta
                  and a.nombre_atributo = 'MacAddress';

                  select a.valor_atributo into v_valatrib_lq_mta
                  from int_mensaje_salida_atrib_iway a
                  where a.id_mensaje_salida_intraway = v_id_interfaz_mta
                  and a.nombre_atributo = 'LinesQty';

                  select a.valor_atributo into v_valatrib_mmc_mta
                  from int_mensaje_salida_atrib_iway a
                  where a.id_mensaje_salida_intraway = v_id_interfaz_mta
                  and a.nombre_atributo = 'MtaModelCrmId';

               EXCEPTION
                WHEN excepcion_mtaprov THEN
                    p_error := 99;
                   v_id_interfaz_mta := 0;
                END;

                IF p_error = 0 AND v_id_interfaz_mta > 0 THEN
                   PQ_INTRAWAY_PROCESO.P_MTA_PROVISION(3,p_codsolot,v_id_cliente,v_valatrib_ma_mta,v_valatrib_mmc_mta,p_resultado,p_mensaje,p_error);
                END IF;

                IF p_error <> 0 THEN
                     p_mensaje := 'No se realizo la provisión para el MTA en la SOLOT: '  || to_char(p_codsolot)|| ' '|| p_mensaje;
                     --p_mensaje := p_mensaje||' '||'No se realizo la provisión para el MTA en la SOLOT: '  || to_char(p_codsolot);
                     p_salida := p_mensaje;
                     INTRAWAY.PQ_INTRAWAY.P_CREA_MENSAJE_ERROR ( 1111,
                                                      'INTRAWAY.P_MIGRA_RESERVAS_ITW',
                                                      p_codsolot,
                                                      p_mensaje);

                END IF;
              END IF;

              /****************************** SET TOP BOX *******************************************/

          /*IF T = 1 and z = 0 and o_error = 0 and o_mensaje = 'Operation Success' THEN*/
         -- IF v_countstbins > 0 THEN

              FOR lc_stb IN c_stb_migra LOOP

                BEGIN
                   select a.valor_atributo into v_valatrib_ua_stb
                   from int_mensaje_salida_atrib_iway a
                   where a.id_mensaje_salida_intraway = lc_stb.id_interfaz
                   and a.nombre_atributo = 'unitAddress';

                   select a.valor_atributo into v_valatrib_sn_stb
                   from int_mensaje_salida_atrib_iway a
                   where a.id_mensaje_salida_intraway = lc_stb.id_interfaz
                   and a.nombre_atributo = 'serialNumber';

                   PQ_INTRAWAY_PROCESO.P_STB_PROVISION(v_valatrib_sn_stb,v_valatrib_ua_stb,v_id_cliente,
                   p_codsolot, lc_stb.pid ,p_resultado, p_mensaje, p_error);

                   IF p_error <> 0 THEN --or p_mensaje <> 'Operation Success' THEN
                     RAISE excepcion_stbprov;
                   END IF;
                EXCEPTION
                WHEN excepcion_stbprov THEN
                    p_error := 0;

                END;
                  IF p_error <> 0 THEN
                     p_mensaje := 'No se realizo la provisión para el STB en el IdVenta: '  || lc_stb.pid|| ' '|| p_mensaje;
                     --p_mensaje := p_mensaje ||' '||'No se realizo la provisión para el STB en el IdVenta: '  || lc2.id_venta;
                     p_salida := p_mensaje;
                     INTRAWAY.PQ_INTRAWAY.P_CREA_MENSAJE_ERROR ( 1111,
                                                      'INTRAWAY.P_MIGRA_RESERVAS_ITW',
                                                      p_codsolot,
                                                      p_mensaje);

                     EXIT;
                END IF;
            END LOOP;
   --END IF;
  END IF;
--  END IF;
  IF p_salida is null  THEN
     p_salida := v_salida;
  END IF;

END;
/


