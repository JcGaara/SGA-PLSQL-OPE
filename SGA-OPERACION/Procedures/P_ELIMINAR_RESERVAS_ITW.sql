CREATE OR REPLACE PROCEDURE      OPERACION.P_ELIMINAR_RESERVAS_ITW( 
p_id_cliente in varchar2, 
p_codsolot in number, 
p_indicador in number, 
p_salida out varchar2) 
/****************************************************************************** 
  1.0  06/10/2010           REQ.139588 
******************************************************************************/ 
IS 
  V_TELEFONO varchar2(3000); 
  V_HOMEEX varchar2(3000); 
  v_id_venta int_mensaje_salida_intraway.id_venta%type; 
  v_id_interfaz_stb int_mensaje_salida_intraway.id_interfaz%type; 
--  v_id_interfaz_cm int_mensaje_salida_intraway.id_interfaz%type; 
  v_id_interfaz_mta int_mensaje_salida_intraway.id_interfaz%type; 
  v_mta_interfaz  int_mensaje_salida_intraway.id_interfaz%type; 
  v_mta_id_venta  int_mensaje_salida_intraway.id_venta%type; 
  v_mta_id_venta_padre int_mensaje_salida_intraway.id_venta_padre%type; 
  v_mta_promotor   int_mensaje_salida_intraway.id_promotor_padre%type; 
  v_activationcode  INT_MENSAJE_SALIDA_ATRIB_IWAY.VALOR_ATRIBUTO%type; 
  v_profile     INT_MENSAJE_SALIDA_ATRIB_IWAY.VALOR_ATRIBUTO%type; 
  v_cm_interfaz   int_mensaje_salida_intraway.id_interfaz%type; 
  v_cm_id_venta   int_mensaje_salida_intraway.id_venta%type; 
  v_cm_id_venta_padre int_mensaje_salida_intraway.id_venta_padre%type; 
  v_cm_promotor   int_mensaje_salida_intraway.id_promotor_padre%type; 
  v_activationcode_cm INT_MENSAJE_SALIDA_ATRIB_IWAY.VALOR_ATRIBUTO%type; 
  v_codigo_ext   INT_MENSAJE_SALIDA_ATRIB_IWAY.VALOR_ATRIBUTO%type; 
  V_EndpointNumber INT_MENSAJE_SALIDA_ATRIB_IWAY.VALOR_ATRIBUTO%type; 
  v_cantcpe   INT_MENSAJE_SALIDA_ATRIB_IWAY.VALOR_ATRIBUTO%type; 
  v_valatrib_ua_stb INT_MENSAJE_SALIDA_ATRIB_IWAY.VALOR_ATRIBUTO%type; 
  v_valatrib_sn_stb INT_MENSAJE_SALIDA_ATRIB_IWAY.VALOR_ATRIBUTO%type; 
 
  v_countcm number; 
  v_countmta number; 
  v_count_stb number; 
  v_count_stb_ca number; 
  v_countep number; 
--  v_countcola number; 
--  v_countcmins number; 
--  v_countmtains number; 
  v_countespacio number; 
  p_resultado varchar2(30); 
  p_mensaje varchar2(3000); 
  p_error number; 
  v_countstbins NUMBER; 
  v_salida varchar2(3000); 
  v_channelmap varchar2(100); 
  v_sendtocontroler varchar2(30); 
  v_activationcode_stb varchar2(30); 
  v_a_productocrm varchar2(30); 
 
  v_id_ventamta int_mensaje_salida_intraway.ID_VENTA%TYPE; 
  v_id_cliente int_mensaje_salida_intraway.ID_CLIENTE%TYPE; 
  v_valatrib_ma_cm int_mensaje_salida_atrib_iway.valor_atributo%type; 
  v_valatrib_ma_mta int_mensaje_salida_atrib_iway.valor_atributo%type; 
  v_valatrib_lq_mta int_mensaje_salida_atrib_iway.valor_atributo%type; 
  v_valatrib_mmc_mta int_mensaje_salida_atrib_iway.valor_atributo%type; 
  v_a_defaultConfigCRMId int_mensaje_salida_atrib_iway.valor_atributo%type; 
  excepcion_mtaprov exception; 
  excepcion_cmprov exception; 
  excepcion_stbprov exception; 
  
  ln_pivot number;--2.0
 
CURSOR C1 IS 
 SELECT * 
 from int_mensaje_salida_intraway s1 
 where s1.id_venta_padre = v_id_ventamta 
 and s1.id_interfase = 824 and s1.id_estado = 1 
 and ( select ( select count(id_estado) from int_mensaje_salida_intraway s2 
         where s2.id_venta = s1.id_venta 
         and s2.id_interfase = 824 
         AND s2.id_error = 0 
         AND s2.mensaje = 'Operation Success' 
         and  id_estado = 1 ) 
          - 
          ( select count(id_estado) from int_mensaje_salida_intraway s2 
         where s2.id_venta = s1.id_venta 
         and s2.id_interfase = 824 
         AND s2.id_error = 0 
         AND s2.mensaje = 'Operation Success' 
         and  id_estado = 0 ) from dual ) 
          > 0 ; 
cursor C2 is 
  SELECT S1.id_venta, S1.ID_VENTA_PADRE, s1.id_promotor_padre, s1.id_interfaz 
    FROM int_mensaje_salida_intraway s1 
    WHERE s1.id_interfase = 2020 
       AND s1.id_error = 0 
       AND s1.mensaje = 'Operation Success' 
       AND s1.id_estado = 1 
       AND s1.id_cliente = p_id_cliente 
       AND s1.id_venta <> 0 
        and ( select ( select count(id_estado) from int_mensaje_salida_intraway s2 
                where s2.id_venta = s1.id_venta 
                and s2.id_interfase = 2020 
                AND s2.id_error = 0 
                AND s2.mensaje = 'Operation Success' 
                and  id_estado = 1 ) 
                 - 
                 ( select count(id_estado) from int_mensaje_salida_intraway s2 
                where s2.id_venta = s1.id_venta 
                and s2.id_interfase = 2020 
                AND s2.id_error = 0 
                AND s2.mensaje = 'Operation Success' 
                and  id_estado = 0 ) from dual ) 
                 > 0 ; 
cursor c_stb_migra is 
  select STBSGA.IDCAMPO, STBSGA.PID, STBMANUAL.ID_INTERFAZ 
  FROM 
  (select ROWNUM IDCAMPO, Z.ID_PRODUCTO PID, '' ID_INTERFAZ 
  FROM INTRAWAY.INT_SERVICIO_INTRAWAY Z 
  WHERE Z.id_cliente = v_id_cliente 
  AND Z.codsolot = P_codsolot AND ID_INTERFASE = 2020) STBSGA, 
   ( SELECT ROWNUM IDCAMPO, '' PID, 
  (      SELECT s.id_interfaz 
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
               AND s2.id_estado = 1 )) ID_INTERFAZ 
 
      FROM int_mensaje_salida_intraway s1 
      WHERE s1.id_interfase = 2020 
         AND s1.id_error = 0 
         AND s1.mensaje = 'Operation Success' 
         AND s1.id_estado = 1 
         AND s1.id_cliente = p_id_cliente 
         AND s1.id_venta <> 0 
          and ( select ( select count(id_estado) from int_mensaje_salida_intraway s2 
                  where s2.id_venta = s1.id_venta 
                  and s2.id_interfase = 2020 
                  AND s2.id_error = 0 
                  AND s2.mensaje = 'Operation Success' 
                  and  id_estado = 1 ) 
                   - 
                   ( select count(id_estado) from int_mensaje_salida_intraway s2 
                  where s2.id_venta = s1.id_venta 
                  and s2.id_interfase = 2020 
                  AND s2.id_error = 0 
                  AND s2.mensaje = 'Operation Success' 
                  and  id_estado = 0 ) from dual ) 
                   > 0 
  AND EXISTS 
  (      SELECT 'XXXX' 
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
  (      SELECT 'YYYY' 
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
               AND s2.id_estado = 1 )) ) STBMANUAL 
  WHERE STBSGA.IDCAMPO = STBMANUAL.IDCAMPO; 
 
BEGIN 
 
/* I := 0; 
 J := 0; 
 K := 0; 
 m := 0; 
 P := 0; 
 Q := 0; 
 r := 0;*/ 
 
 p_error := 0; 
 v_countstbins := 0; 
 v_salida := 'La migración de la reserva manual al SGA concluyó satisfactoriamente.'; 
 
   BEGIN 
   /****************************** CABLE MODEM *******************************************/ 
    -- Obtiene ID Venta del Cable Modem ( Si ha sido reservado ) 
     select distinct S1.id_venta into v_id_venta 
     from int_mensaje_salida_intraway S1 
     where S1.id_cliente = p_id_cliente and S1.id_interfase = 620 AND S1.ID_VENTA <> 0 
     and S1.id_estado = 1 and S1.mensaje = 'Operation Success' 
     and ( select ( select count(id_estado) from int_mensaje_salida_intraway s2 
             where s2.id_venta = s1.id_venta 
                and s2.id_interfase = 620 
                AND s2.id_error = 0 
                AND s2.mensaje = 'Operation Success' 
             and  id_estado = 1 ) 
              - 
              ( select count(id_estado) from int_mensaje_salida_intraway s2 
             where s2.id_venta = s1.id_venta 
                and s2.id_interfase = 620 
                AND s2.id_error = 0 
                AND s2.mensaje = 'Operation Success' 
             and  id_estado = 0 ) from dual ) 
              > 0 ; 
      v_countcm := 1; 
   EXCEPTION 
     WHEN OTHERS THEN 
      v_id_venta := 0; 
      v_countcm := 0; 
   END; 
 
    /*   P := 1; 
       r := 1;*/ 
     /****************************** MTA *******************************************/ 
      /* J := 1;*/ 
     BEGIN 
       -- Obtiene ID Venta del MTA ( Si ha sido reservado ) 
       select s1.id_venta into v_id_ventamta 
       from int_mensaje_salida_intraway s1 
       where s1.id_venta_padre = v_id_venta and s1.id_interfase = 820 and s1.id_estado = 1 
       and ( select ( select count(id_estado) from int_mensaje_salida_intraway s2 
         where s2.id_venta = s1.id_venta 
               and s2.id_interfase = 820 
               AND s2.id_error = 0 
               AND s2.mensaje = 'Operation Success' 
         and  id_estado = 1 ) 
          - 
          ( select count(id_estado) from int_mensaje_salida_intraway s2 
         where s2.id_venta = s1.id_venta 
               and s2.id_interfase = 820 
               AND s2.id_error = 0 
               AND s2.mensaje = 'Operation Success' 
         and  id_estado = 0 ) from dual ) 
          > 0 ; 
        v_countmta := 1; 
 
     EXCEPTION 
       WHEN OTHERS THEN 
        v_id_ventamta := 0; 
        v_countmta := 0; 
     END; 
     -- Verifica si el MTA se encuentra instalado 
     IF v_countmta > 0 THEN 
/*         Q := 1; 
         r := 1;*/ 
       /****************************** END POINT *******************************************/ 
       --select count(id_interfaz) INTO v_countep from int_mensaje_salida_intraway where id_venta_padre = v_id_ventamta and id_interfase = 824 and id_estado = 1; 
       BEGIN 
         select count(id_interfaz) INTO v_countep 
         from int_mensaje_salida_intraway s1 
          where s1.id_venta_padre = v_id_ventamta 
          and s1.id_interfase = 824 and s1.id_estado = 1 
          and ( select ( select count(id_estado) from int_mensaje_salida_intraway s2 
                  where s2.id_venta = s1.id_venta 
                 and s2.id_interfase = 824 
                 AND s2.id_error = 0 
                 AND s2.mensaje = 'Operation Success' 
                  and  id_estado = 1 ) 
                   - 
                   ( select count(id_estado) from int_mensaje_salida_intraway s2 
                  where s2.id_venta = s1.id_venta 
                 and s2.id_interfase = 824 
                 AND s2.id_error = 0 
                 AND s2.mensaje = 'Operation Success' 
                  and  id_estado = 0 ) from dual ) 
                   > 0 ; 
       EXCEPTION 
         WHEN OTHERS THEN 
          v_countep := 0; 
       END; 
/*       IF v_countep > 0 THEN 
         K := 1; 
       END IF;*/ 
 
   END IF; 
/* EXCEPTION 
 WHEN others THEN 
 
   select max(idmail) + 1 into v_countcola from opewf.cola_send_mail_job; 
   insert into opewf.cola_send_mail_job (idmail,nombre,subject,destino,cuerpo,flg_env) 
   values (v_countcola,'SGA-SoportealNegocio','No se encontro el IdVenta en INTRAWAY','dl-pe-itsoportealnegocio','No se encontro el IdVenta en INTRAWAY para el IdVenta: ' || v_id_venta, 0);--1.0 
   commit; 
   m := 1;*/ 
 
 
/* IF K = 1 and m = 0 THEN*/ 
 /****************************** END POINT *******************************************/ 
 IF v_countep > 0 THEN 
   FOR c1_tel IN C1 LOOP 
     BEGIN 
       --Obtener el nro telefonico 
       SELECT DISTINCT A.VALOR_ATRIBUTO INTO V_TELEFONO 
       FROM INT_MENSAJE_SALIDA_ATRIB_IWAY A 
       WHERE A.NOMBRE_ATRIBUTO = 'TN' 
       AND A.ID_MENSAJE_SALIDA_INTRAWAY = c1_tel.id_interfaz; 
       --Obtener el nro telefonico 
       SELECT DISTINCT A.VALOR_ATRIBUTO INTO V_HOMEEX 
       FROM INT_MENSAJE_SALIDA_ATRIB_IWAY A 
       WHERE A.ID_MENSAJE_SALIDA_INTRAWAY = c1_tel.id_interfaz 
       AND A.NOMBRE_ATRIBUTO = 'HomeExchangeCrmId'; 
       --Obtener el nro EndpointNumber 
       SELECT DISTINCT A.VALOR_ATRIBUTO INTO V_EndpointNumber 
       FROM INT_MENSAJE_SALIDA_ATRIB_IWAY A 
       WHERE A.ID_MENSAJE_SALIDA_INTRAWAY = c1_tel.id_interfaz --c1_tel.id_interfaz 
       AND A.NOMBRE_ATRIBUTO = 'EndpointNumber'; 
 
       -- Eliminando los END POINTS 
       --intraway.pq_intraway_reg.P_MTA_EP_ADMINISTRACION(0,T.ID_cliente,0,0,1,V_TELEFONO,V_HOMEEX,99,NULL,T.ID_VENTA,T.ID_VENTA_PADRE,T.ID_PROMOTOR_PADRE); 
       intraway.PQ_INTRAWAY_REG.P_MTA_EP_ADMINISTRACION(0,c1_tel.id_cliente,0,0,to_number(V_EndpointNumber),V_TELEFONO,V_HOMEEX,99,NULL,c1_tel.ID_VENTA,c1_tel.ID_VENTA_PADRE,c1_tel.ID_PROMOTOR_PADRE, p_resultado, p_mensaje, p_error ); 
 
     EXCEPTION 
     WHEN others THEN 
/*       select max(idmail) + 1 into v_countcola from opewf.cola_send_mail_job; 
       insert into opewf.cola_send_mail_job (idmail,nombre,subject,destino,cuerpo,flg_env) 
       values (v_countcola,'SGA-SoportealNegocio','No se realizo la eliminación de Reserva para el END POINT','dl-pe-itsoportealnegocio','No se realizo la eliminación de los END POINT para la Interfaz : ' || to_char(c1_tel.id_interfaz),'0');--1.0 
       commit;*/ 
 
       p_error := 99; 
       /* m := 1;*/ 
     END; 
     /*IF m = 1 THEN*/ 
     IF p_error <> 0 THEN 
       p_mensaje := 'No se realizo la eliminación de la reserva para el end point de IDINTERFAZ ' || c1_tel.id_interfaz||' ' ||SQLERRM; 
 
       --p_mensaje := p_mensaje ||' '|| 'No se realizo la eliminación de la reserva para el end point de IDINTERFAZ ' || c1_tel.id_interfaz; 
       INTRAWAY.PQ_INTRAWAY.P_CREA_MENSAJE_ERROR ( 7777, 
                         'INTRAWAY.P_ELIMINAR_RESERVAS_ITW', 
                         p_codsolot, 
                         p_mensaje); 
       p_salida := p_mensaje; 
       exit; 
     END IF; 
   END LOOP; 
 END IF; 
 /****************************** MTA *******************************************/ 
 /*IF J = 1 and m = 0 THEN*/ 
 IF v_countmta > 0 AND p_error = 0 THEN 
    BEGIN 
      SELECT DISTINCT B.ID_INTERFAZ, B.ID_VENTA, B.ID_VENTA_PADRE, B.ID_PROMOTOR_PADRE 
      INTO v_mta_interfaz, v_mta_id_venta, v_mta_id_venta_padre, v_mta_promotor 
      FROM int_mensaje_salida_intraway B 
      WHERE B.ID_VENTA = v_id_ventamta and id_interfase = 820 and id_estado = 1; 
      --Obtener el Codigo de Activacion 
      SELECT DISTINCT A.VALOR_ATRIBUTO INTO v_activationcode 
      FROM INT_MENSAJE_SALIDA_ATRIB_IWAY A 
      WHERE A.NOMBRE_ATRIBUTO = 'ActivationCode' 
      AND A.ID_MENSAJE_SALIDA_INTRAWAY = v_mta_interfaz; 
      --Obtener el Profile 
      SELECT DISTINCT A.VALOR_ATRIBUTO INTO v_profile 
      FROM INT_MENSAJE_SALIDA_ATRIB_IWAY A 
      WHERE A.NOMBRE_ATRIBUTO = 'profileCrmId' 
      AND A.ID_MENSAJE_SALIDA_INTRAWAY = v_mta_interfaz; 
      --Eliminando el MTA 
      --intraway.pq_intraway_reg.P_MTA_CREA_ESPACIO(0,T.ID_cliente,0,0,v_activationcode,99,null,v_profile,v_mta_id_venta,v_mta_id_venta_padre,v_mta_promotor); 
      intraway.PQ_INTRAWAY_REG.P_MTA_CREA_ESPACIO(0,p_id_cliente,0,0,v_activationcode,99,null,v_profile,v_mta_id_venta,v_mta_id_venta_padre,v_mta_promotor, p_resultado, p_mensaje, p_error ); 
 
    EXCEPTION 
    WHEN others THEN 
/*      select max(idmail) + 1 into v_countcola from opewf.cola_send_mail_job; 
      insert into opewf.cola_send_mail_job (idmail,nombre,subject,destino,cuerpo,flg_env) 
      values (v_countcola,'SGA-SoportealNegocio','No se realizo la eliminación de Reserva para el MTA','dl-pe-itsoportealnegocio','No se realizo la eliminación del MTA para la Interfaz : ' || to_char(v_mta_interfaz),'0');--1.0 
      commit;*/ 
      p_error := 99; 
      /* m := 1;*/ 
    END; 
    /*IF m = 1 THEN*/ 
    IF p_error <> 0 THEN 
      p_mensaje := 'No se realizo la eliminación del MTA para la Interfaz : ' || to_char(v_mta_interfaz)|| ' '|| sqlerrm ; 
 
      INTRAWAY.PQ_INTRAWAY.P_CREA_MENSAJE_ERROR ( 7777, 
                         'INTRAWAY.P_ELIMINAR_RESERVAS_ITW', 
                         p_codsolot, 
                         p_mensaje); 
      p_salida := p_mensaje; 
    END IF; 
 END IF; 
  /****************************** CABLE MODEM *******************************************/ 
/* IF I = 1 and m = 0 THEN*/ 
 IF v_countcm > 0 AND p_error = 0 THEN 
    BEGIN 
      SELECT DISTINCT B.ID_INTERFAZ, B.ID_VENTA, B.ID_VENTA_PADRE, B.ID_PROMOTOR_PADRE 
      INTO v_cm_interfaz, v_cm_id_venta, v_cm_id_venta_padre, v_cm_promotor 
      FROM int_mensaje_salida_intraway B 
      WHERE B.ID_VENTA = v_mta_id_venta_padre and id_interfase = 620 and id_estado = 1; 
      --Obtener el Codigo de Activacion 
      SELECT DISTINCT nvl(A.VALOR_ATRIBUTO, '') INTO v_activationcode_cm 
      FROM INT_MENSAJE_SALIDA_ATRIB_IWAY A 
      WHERE A.NOMBRE_ATRIBUTO = 'ActivationCode' 
      AND A.ID_MENSAJE_SALIDA_INTRAWAY = v_cm_interfaz; 
      --Obtener el Codigo Ext 
      SELECT DISTINCT A.VALOR_ATRIBUTO INTO v_codigo_ext 
      FROM INT_MENSAJE_SALIDA_ATRIB_IWAY A 
      WHERE A.NOMBRE_ATRIBUTO = 'ServicePackageCRMID' 
      AND A.ID_MENSAJE_SALIDA_INTRAWAY = v_cm_interfaz; 
      --Obtener la Cantidad de CPE 
      SELECT DISTINCT A.VALOR_ATRIBUTO INTO v_cantcpe 
      FROM INT_MENSAJE_SALIDA_ATRIB_IWAY A 
      WHERE A.NOMBRE_ATRIBUTO = 'CantCPE' 
      AND A.ID_MENSAJE_SALIDA_INTRAWAY = v_cm_interfaz; 
      --Eliminando los CM 
      intraway.PQ_INTRAWAY_REG.P_CM_CREA_ESPACIO(0,p_id_cliente,0,0,v_activationcode_cm,v_codigo_ext ,v_cantcpe,99,null,v_cm_id_venta,v_cm_id_venta_padre,v_cm_promotor, p_resultado, p_mensaje, p_error ); 
 
 
    EXCEPTION 
    WHEN others THEN 
/*      select max(idmail) + 1 into v_countcola from opewf.cola_send_mail_job; 
      insert into opewf.cola_send_mail_job (idmail,nombre,subject,destino,cuerpo,flg_env) 
      values (v_countcola,'SGA-SoportealNegocio','No se realizo la eliminación de Reserva para el CM','dl-pe-itsoportealnegocio','No se realizo la eliminación del CM para la Interfaz : ' || to_char(v_cm_interfaz),'0');--1.0 
      commit;*/ 
 
      /* m := 1;*/ 
      p_error := 99; 
    END; 
 
    /*IF m = 1 THEN*/ 
    IF p_error <> 0 THEN 
       --p_mensaje := p_mensaje ||' ' || 'No se realizo la eliminación de la reserva para el CM de IDINTERFAZ ' || v_cm_interfaz; 
      p_mensaje :='No se realizo la eliminación del CM para la Interfaz : ' || to_char(v_cm_interfaz)|| ' '|| sqlerrm ; 
 
      INTRAWAY.PQ_INTRAWAY.P_CREA_MENSAJE_ERROR ( 7777, 
                         'INTRAWAY.P_ELIMINAR_RESERVAS_ITW', 
                         p_codsolot, 
                         p_mensaje); 
      p_salida := p_mensaje; 
    END IF; 
 END IF; 
 /****************************** SET-TOP-BOX *******************************************/ 
 FOR lc2 in C2 LOOP 
/*    I := 0; 
    J := 0; 
    T := 0; 
    h := 0; 
    z := 0; 
    o_error := 0; 
    o_mensaje := 'Operation Success';*/ 
 
    v_countespacio := 1; 
 
    /*  I := 1;*/ 
    -- Verifica si el STB se encuentra instalado 
      -- Obtener el id_interfaz para el caso de las instalaciones 
     BEGIN 
       SELECT count(id_interfaz) 
        into  v_count_stb 
        FROM int_mensaje_salida_intraway s 
         WHERE s.id_venta = lc2.id_venta 
           AND s.id_interfase = 2020 
          AND s.id_error = 0 
          AND s.mensaje = 'Operation Success' 
          AND s.id_estado = 2 
          AND s.id_interfaz = ( 
            SELECT max(id_interfaz) FROM int_mensaje_salida_intraway s2 
            WHERE s2.id_venta = s.id_venta 
            AND s2.id_venta = lc2.id_venta 
            AND s2.id_interfase = 2020 
            AND s2.id_error = 0 
            AND s2.mensaje = 'Operation Success' 
            AND s2.id_estado = 2 ); 
      EXCEPTION 
        WHEN OTHERS THEN 
         v_count_stb := 0; 
      END; 
 
       IF v_count_stb > 0 THEN 
        /* h := 1; 
         T := 1;*/ 
         BEGIN 
         SELECT s.id_interfaz 
         into  v_id_interfaz_stb 
         FROM int_mensaje_salida_intraway s 
          WHERE s.id_venta = lc2.id_venta 
            AND s.id_interfase = 2022 
           AND s.id_error = 0 
           AND s.mensaje = 'Operation Success' 
           AND s.id_estado = 1 
           AND s.id_interfaz = ( 
             SELECT max(id_interfaz) FROM int_mensaje_salida_intraway s2 
             WHERE s2.id_venta = s.id_venta 
             AND s2.id_venta = lc2.id_venta 
             AND s2.id_interfase = 2022 
             AND s2.id_error = 0 
             AND s2.mensaje = 'Operation Success' 
             AND s2.id_estado = 1 ); 
           v_count_stb_ca := 1; 
 
         EXCEPTION 
           WHEN OTHERS THEN 
            v_count_stb_ca := 0; 
            v_id_interfaz_stb := 0; 
         END; 
 
       END IF; 
 
       IF v_count_stb_ca > 0 AND v_count_stb > 0 THEN 
         v_countstbins := v_countstbins + 1; 
       END IF; 
/*        IF v_count_stb_ca > 0 THEN 
         J := 1; 
        END IF;*/ 
 /*      IF z = 1 THEN 
       p_salida := 'No se encuentra este IdVenta ' || lc2.id_venta; 
       exit; 
      END IF;*/ 
    /* ELSE 
      p_salida := 'No se encuentra este IdVenta ' || lc2.id_venta; 
      exit; 
    END IF;*/ 
 
   /* IF I = 1 THEN*/ 
    -- Se obtienen Datos que fueron enviados al realizar la reserva 
   BEGIN 
     v_channelmap := 'BASICO'; 
     v_sendtocontroler := 'TRUE'; 
     SELECT NVL(SA.VALOR_ATRIBUTO, '') 
     INTO v_activationcode_stb 
     FROM INT_MENSAJE_SALIDA_ATRIB_IWAY SA 
     WHERE SA.ID_MENSAJE_SALIDA_INTRAWAY = lc2.id_interfaz --v_id_interfaz 
      AND SA.NOMBRE_ATRIBUTO = 'activationCode'; 
 
     select NVL(a.valor_atributo, '') 
     into v_a_productocrm 
     from int_mensaje_salida_atrib_iway a 
     where a.id_mensaje_salida_intraway = lc2.id_interfaz --v_id_interfaz 
      and a.nombre_atributo = 'defaultProductCRMId' ; 
 
     select NVL(a.valor_atributo, '') 
     into v_a_defaultConfigCRMId 
     from int_mensaje_salida_atrib_iway a 
     where a.id_mensaje_salida_intraway = lc2.id_interfaz --v_id_interfaz 
      and a.nombre_atributo= 'defaultConfigCRMId'; 
 
 
      EXCEPTION 
      WHEN others THEN 
/*        select max(idmail) + 1 into v_countcola from opewf.cola_send_mail_job; 
        insert into opewf.cola_send_mail_job (idmail,nombre,subject,destino,cuerpo,flg_env) 
        values (v_countcola,'SGA-SoportealNegocio','No se encuentra algunos valores de la Interfase 2020','dl-pe-itsoportealnegocio','No se encontro parametros para la Interfase 2020 en el ID_VENTA: ' || lc2.id_venta,'0');--1.0 
        commit;*/ 
        p_error := 99; 
       /* z := 1;*/ 
      END; 
      /*IF z = 1 THEN*/ 
      IF p_error <> 0 THEN 
      p_mensaje := 'No se encuentra algunos valores de la Interfase 2020 en el ID_VENTA: ' || lc2.id_venta || ' '|| sqlerrm ; 
 
      INTRAWAY.PQ_INTRAWAY.P_CREA_MENSAJE_ERROR ( 7777, 
                         'INTRAWAY.P_ELIMINAR_RESERVAS_ITW', 
                         p_codsolot, 
                         p_mensaje); 
      p_salida := p_mensaje; 
       exit; 
      END IF; 
 
 
    --Verificar si el STB solo estuvo reservado 
    /*IF I = 1 and z = 0 AND J = 0 THEN */-- Si solo estuvo reservado 
    IF v_count_stb = 0 AND v_count_stb_ca = 0 THEN 
      BEGIN 
        intraway.PQ_INTRAWAY_REG.P_STB_CREA_ESPACIO(0,p_id_cliente,0,v_activationcode_stb,v_a_productocrm,'BASICO', 
                            v_a_defaultConfigCRMId,'TRUE',99,null,lc2.id_venta,0,0,p_resultado, p_mensaje, p_error ); 
      EXCEPTION 
      WHEN others THEN 
/*        select max(idmail) + 1 into v_countcola from opewf.cola_send_mail_job; 
        insert into opewf.cola_send_mail_job (idmail,nombre,subject,destino,cuerpo,flg_env) 
        values (v_countcola,'SGA-SoportealNegocio','No se realizó correctamente la eliminación del espacio del STB','dl-pe-itsoportealnegocio','No se realizó correctamente la eliminación del espacio del STB para el ID_VENTA: ' || lc2.id_venta,'0');--1.0 
        commit;*/ 
        p_error := 99; 
        /*z := 1;*/ 
      END; 
      /*IF z = 1 THEN*/ 
      IF p_error <> 0 THEN 
       p_mensaje := 'No se realizó correctamente la eliminación del espacio del STB para el IdVenta: ' || lc2.id_venta|| ' '|| sqlerrm; 
 
       INTRAWAY.PQ_INTRAWAY.P_CREA_MENSAJE_ERROR ( 7777, 
                         'INTRAWAY.P_ELIMINAR_RESERVAS_ITW', 
                         p_codsolot, 
                         p_mensaje); 
       p_salida := p_mensaje; 
       --p_mensaje := p_mensaje ||' '||'No se realizó correctamente la eliminación del espacio del STB para el IdVenta: ' || lc2.id_venta; 
       exit; 
      END IF; 
   /*  ELSE 
      p_salida := 'No se realizó correctamente la eliminación del espacio del STB para el IdVenta: ' || lc2.id_venta;*/ 
    END IF; 
    --Verificar si estuvo instalado 
    /*IF J = 1 and z = 0 THEN*/ 
    IF v_count_stb > 0 AND v_count_stb_ca > 0 THEN 
      --Se desea solo eliminar el STB 
      IF p_indicador = 1 THEN 
          --2020/4 Se procede a deshabilitar el STB 
          v_sendtocontroler := 'TRUE'; 
          INTRAWAY.PQ_INTRAWAY_REG.P_STB_CREA_ESPACIO(4,p_id_cliente,0, 
          v_activationcode_stb,v_a_productocrm,'BASICO',v_a_defaultConfigCRMId,'TRUE',null,null,lc2.id_venta,lc2.id_venta_padre,lc2.id_promotor_padre,p_resultado, p_mensaje, p_error ); 
 
          IF p_error = 0 THEN 
           --2020/2 Se regresa a estado OFF_PLANT al STB 
           v_a_defaultConfigCRMId  := 'VES_DSP'; 
           v_sendtocontroler := 'TRUE'; 
            INTRAWAY.PQ_INTRAWAY_REG.P_STB_CREA_ESPACIO(2,p_id_cliente,0, 
            v_activationcode_stb,v_a_productocrm,'BASICO',v_a_defaultConfigCRMId,'TRUE',null,null,lc2.id_venta,lc2.id_venta_padre,lc2.id_promotor_padre,p_resultado, p_mensaje, p_error ); 
 
            IF p_error = 0 THEN 
              --2020/0 Se regresa a estado OFF_PLANT al STB 
             v_a_defaultConfigCRMId  := 'VES_DSP'; 
             v_sendtocontroler := 'FALSE'; 
              INTRAWAY.PQ_INTRAWAY_REG.P_STB_CREA_ESPACIO(0,p_id_cliente,0, 
              v_activationcode_stb,v_a_productocrm,'BASICO',v_a_defaultConfigCRMId,'TRUE',null,null,lc2.id_venta,lc2.id_venta_padre,lc2.id_promotor_padre,p_resultado, p_mensaje, p_error ); 
            END IF; 
          END IF ; 
 
          IF p_error <> 0 THEN 
           p_mensaje := 'No se realizó correctamente la eliminación del espacio del STB para el IdVenta: ' || lc2.id_venta|| ' '|| sqlerrm; 
 
           INTRAWAY.PQ_INTRAWAY.P_CREA_MENSAJE_ERROR ( 7777, 
                             'INTRAWAY.P_ELIMINAR_RESERVAS_ITW', 
                             p_codsolot, 
                             p_mensaje); 
           p_salida := p_mensaje; 
           exit; 
          END IF; 
 
      --Se desea migrar al SGA 
      ELSIF p_indicador = 2 THEN 
 
        BEGIN 
          select a.valor_atributo into v_valatrib_ua_stb 
          from int_mensaje_salida_atrib_iway a 
          where a.id_mensaje_salida_intraway = v_id_interfaz_stb 
          and a.nombre_atributo = 'unitAddress'; 
 
          select a.valor_atributo into v_valatrib_sn_stb 
          from int_mensaje_salida_atrib_iway a 
          where a.id_mensaje_salida_intraway = v_id_interfaz_stb 
          and a.nombre_atributo = 'serialNumber'; 
 
          --2020/4 Se procede a deshabilitar el STB 
          intraway.PQ_INTRAWAY_REG.P_STB_INSTALACION(0,p_id_cliente,0, v_valatrib_sn_stb, 
          v_valatrib_ua_stb,'FALSE', 99, NULL, lc2.id_venta, lc2.id_promotor_padre,p_resultado, p_mensaje, p_error ); 
 
          IF p_error = 0 THEN 
            --2020/4 Se procede a deshabilitar el STB 
            intraway.PQ_INTRAWAY_REG.P_STB_CREA_ESPACIO(0,p_id_cliente,0, 
            v_activationcode_stb,v_a_productocrm,'BASICO',v_a_defaultConfigCRMId,'',99,null,lc2.id_venta,0,lc2.id_promotor_padre,p_resultado, p_mensaje, p_error ); 
          END IF; 
 
          IF p_error <> 0 THEN 
           p_mensaje := 'No se realizó correctamente la eliminación del espacio del STB para el IdVenta: ' || lc2.id_venta|| ' '|| sqlerrm; 
 
           INTRAWAY.PQ_INTRAWAY.P_CREA_MENSAJE_ERROR ( 7777, 
                             'INTRAWAY.P_ELIMINAR_RESERVAS_ITW', 
                             p_codsolot, 
                             p_mensaje); 
           p_salida := p_mensaje; 
           exit; 
          END IF; 
 
        EXCEPTION 
        WHEN others THEN 
          /*z := 1;*/ 
          p_error := 99; 
        END; 
        IF p_error <> 0 THEN 
         p_mensaje := 'No se realizó correctamente la eliminación del espacio del STB para el IdVenta: ' || lc2.id_venta|| ' '|| sqlerrm; 
         --p_mensaje := p_mensaje ||' '||'No se realizó correctamente la eliminación del espacio del STB para el IdVenta: ' || lc2.id_venta; 
 
         INTRAWAY.PQ_INTRAWAY.P_CREA_MENSAJE_ERROR ( 7777, 
                           'INTRAWAY.P_ELIMINAR_RESERVAS_ITW', 
                           p_codsolot, 
                           p_mensaje); 
         p_salida := p_mensaje; 
         exit; 
        END IF; 
/*        IF z = 1 THEN 
         p_salida := 'No se deshabilito el STB para el IdVenta : ' || lc2.id_venta; 
         exit; 
        END IF;*/ 
 
      END IF; 
 
    END IF; 
 END LOOP; 
 
 IF p_error = 0 THEN 
   -- Se anula al cliente 
   intraway.PQ_INTRAWAY_REG.P_ACT_CLIENTE_INTRAWAY(p_id_cliente,0,p_resultado, p_mensaje, p_error ); 
    --Ini 2.0
    select count(1) into  ln_pivot from  constante where constante = 'PIVOT' and valor = '1';
    If ln_pivot > 0 Then
      intraway.PQ_INTRAWAY_REG.P_ACT_CLIENTE_INTRAWAY(p_id_cliente,0,p_resultado, p_mensaje, p_error );
    End If;
    --fin 2.0
 END IF; 
 
 /****************************** MIGRACIONES *******************************************/ 
 IF p_indicador = 2 AND p_error = 0 THEN -- Se desea migrar los servicios 
 --IF h = 1 and z = 0 THEN 
 /*IF I = 1 and z = 0 THEN 
   SELECT COUNT(codsolot) into v_cont from operacion.ope_solot_provisionamiento a where a.codsolot = p_codsolot and a.opcion = 3; 
   IF v_cont = 0 THEN 
    INSERT INTO operacion.ope_solot_provisionamiento(codsolot, opcion) values (p_codsolot,3);*/ 
    /****************************** Transferencia a Intraway *******************************************/ 
    PQ_INTRAWAY_PROCESO.P_INT_PROCESO ( 3, p_codsolot,p_resultado, p_mensaje, p_error ); 
 
    IF p_error <> 0 THEN 
     p_mensaje := 'No se realizó correctamente la transferencia a Intraway de la SOT ' || p_codsolot|| ' '|| sqlerrm; 
     --p_mensaje := p_mensaje ||' '||'No se realizó correctamente la eliminación del espacio del STB para el IdVenta: ' || lc2.id_venta; 
     INTRAWAY.PQ_INTRAWAY.P_CREA_MENSAJE_ERROR ( 7777, 
                       'INTRAWAY.P_ELIMINAR_RESERVAS_ITW', 
                       p_codsolot, 
                       p_mensaje); 
     p_salida := p_mensaje; 
     --p_mensaje := p_mensaje ||' '||'No se realizó correctamente la transferencia a Intraway de la SOT ' ||p_codsolot; 
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
       WHEN others THEN 
         p_error := 99; 
         v_valatrib_ma_cm := 'X'; 
       END; 
 
       IF p_error = 0 AND v_valatrib_ma_cm <> 'X' then 
         PQ_INTRAWAY_PROCESO.P_CM_PROVISION(3,p_codsolot,v_id_cliente,v_valatrib_ma_cm,p_resultado,p_mensaje,p_error); 
       ELSE 
         p_mensaje := 'No se realizo la provisión para el CM en la SOLOT: ' || to_char(p_codsolot)|| ' '|| sqlerrm; 
         --p_mensaje := p_mensaje ||' ' ||'No se realizo la provisión para el CM en la SOLOT: ' || to_char(p_codsolot); 
 
         INTRAWAY.PQ_INTRAWAY.P_CREA_MENSAJE_ERROR ( 7777, 
                           'INTRAWAY.P_ELIMINAR_RESERVAS_ITW', 
                           p_codsolot, 
                           p_mensaje); 
         p_salida := p_mensaje; 
       END IF; 
       /****************************** MTA *******************************************/ 
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
        WHEN OTHERS THEN 
          p_error := 99; 
          v_id_interfaz_mta := 0; 
        END; 
 
        IF p_error = 0 AND v_id_interfaz_mta > 0 THEN 
 
         PQ_INTRAWAY_PROCESO.P_MTA_PROVISION(3,p_codsolot,v_id_cliente,v_valatrib_ma_mta,v_valatrib_mmc_mta,p_resultado,p_mensaje,p_error); 
        ELSE 
         p_mensaje := 'No se realizo la provisión para el MTA en la SOLOT: ' || to_char(p_codsolot)|| ' '|| sqlerrm; 
           --p_mensaje := p_mensaje||' '||'No se realizo la provisión para el MTA en la SOLOT: ' || to_char(p_codsolot); 
 
         INTRAWAY.PQ_INTRAWAY.P_CREA_MENSAJE_ERROR ( 7777, 
                           'INTRAWAY.P_ELIMINAR_RESERVAS_ITW', 
                           p_codsolot, 
                           p_mensaje); 
         p_salida := p_mensaje; 
        END IF; 
 
       /****************************** SET TOP BOX *******************************************/ 
 
     /*IF T = 1 and z = 0 and o_error = 0 and o_mensaje = 'Operation Success' THEN*/ 
     IF v_countstbins > 0 THEN 
 
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
 /*          select max(idmail) + 1 into v_countcola from opewf.cola_send_mail_job; 
          insert into opewf.cola_send_mail_job (idmail,nombre,subject,destino,cuerpo,flg_env) 
          values (v_countcola,'SGA-SoportealNegocio','No se realizo la provisión para el STB','dl-pe-itsoportealnegocio','No se realizo la provisión para el STB en el IdVenta : ' ||lc_stb.pid,'0');--1.0 
          commit;*/ 
          p_error := 0; 
 
          /*z := 1;*/ 
        END; 
        /*IF z = 1 THEN*/ 
        IF p_error <> 0 THEN 
           p_mensaje := 'No se realizo la provisión para el STB en el IdVenta: ' || lc_stb.pid|| ' '|| sqlerrm; 
           --p_mensaje := p_mensaje ||' '||'No se realizo la provisión para el STB en el IdVenta: ' || lc2.id_venta; 
 
           INTRAWAY.PQ_INTRAWAY.P_CREA_MENSAJE_ERROR ( 7777, 
                           'INTRAWAY.P_ELIMINAR_RESERVAS_ITW', 
                           p_codsolot, 
                           p_mensaje); 
           p_salida := p_mensaje; 
           EXIT; 
        END IF; 
      END LOOP; 
  END IF; 
 END IF; 
 END IF; 
 IF p_salida is null /*or p_salida = ''*/ THEN 
   p_salida := v_salida; 
 END IF; 
 
END; 
/
