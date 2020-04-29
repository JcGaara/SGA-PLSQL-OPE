CREATE OR REPLACE PROCEDURE      OPERACION.P_ELIMINAR_RESERVAS_STB_ITW(p_id_venta in number, 
                                 p_result out number) 
/****************************************************************************** 
  1.0  06/10/2010           REQ.139588 
******************************************************************************/ 
IS 
v_countespacio number; 
v_id_cliente INT_MENSAJE_SALIDA_INTRAWAY.ID_CLIENTE%TYPE; 
v_countcola NUMBER; 
v_id_interfaz INT_MENSAJE_SALIDA_INTRAWAY.ID_INTERFAZ%TYPE; 
v_id_promotor_padre INT_MENSAJE_SALIDA_INTRAWAY.ID_PROMOTOR_PADRE%TYPE; 
v_a_defaultConfigCRMId int_mensaje_salida_atrib_iway.valor_atributo%type; 
v_channelmap varchar2(100); 
v_sendtocontroler varchar2(30); 
v_activationcode varchar2(30); 
v_a_productocrm varchar2(30); 
ln_pivot number; --2.0
--v_error number; 
  p_resultado varchar2(30); 
  p_mensaje varchar2(200); 
  p_error number; 
I number; 
J number; 
 
BEGIN 
    I := 0; 
    J := 0; 
    p_error := 0; 
    p_resultado := 0; 
 
    -- Verificar si existe este id_venta para la interfase del STB 
    SELECT count(s.id_interfaz) 
    into v_countespacio 
    FROM int_mensaje_salida_intraway s 
    WHERE s.id_interfase = 2020 
       AND s.id_error = 0 
       AND s.mensaje = 'Operation Success' 
       AND s.id_estado = 1 
       AND s.id_venta = p_id_venta; 
 
    IF v_countespacio > 0 THEN 
      I := 1; 
      BEGIN 
        -- Obtener el id_cliente 
        SELECT id_cliente 
        into  v_id_cliente 
        FROM int_mensaje_salida_intraway s 
         WHERE s.id_interfase = 2020 
          AND s.id_error = 0 
          AND s.mensaje = 'Operation Success' 
          AND s.id_estado = 1 
          AND s.id_venta = p_id_venta 
          AND ROWNUM = 1; 
        -- Verificar si el STB ya fue activado 
        SELECT count(s.id_interfaz) 
        into v_countespacio 
        FROM int_mensaje_salida_intraway s 
        WHERE s.id_interfase = 2022 
          AND s.id_error = 0 
          AND s.mensaje = 'Operation Success' 
          AND s.id_estado = 1 
          AND s.id_venta = p_id_venta; 
        IF v_countespacio > 0 THEN 
         J := 1; 
        END IF; 
      EXCEPTION 
      WHEN others THEN 
        select max(idmail) + 1 into v_countcola from opewf.cola_send_mail_job; 
        insert into opewf.cola_send_mail_job (idmail,nombre,subject,destino,cuerpo,flg_env) 
        values (v_countcola,'SGA-SoportealNegocio','No se encuentra este Cliente con este Producto de STB','dl-pe-itsoportealnegocio@claro.com.pe','No se encontro el cliente para el ID_VENTA : ' || to_char(p_id_venta),'0');--1.0 
        commit; 
      END; 
    ELSE 
      p_resultado := 2; -- No se encontro el id_venta en la salida de Intraway 
    END IF; 
 
    IF I = 1 THEN 
      BEGIN 
        v_channelmap := 'BASICO'; 
        v_sendtocontroler := 'TRUE'; 
        SELECT s.id_interfaz, s.id_promotor_padre 
        into v_id_interfaz,v_id_promotor_padre 
        FROM INT_MENSAJE_SALIDA_INTRAWAY S 
        WHERE S.ID_VENTA = p_id_venta 
        AND S.ID_INTERFASE = 2020 ANd S.ID_ESTADO = 1 
        AND S.ID_VENTA > 0 
        AND S.MENSAJE IN ('Operation Success','CheckGetActivity'); 
 
        SELECT SA.VALOR_ATRIBUTO 
        INTO v_activationcode 
        FROM INT_MENSAJE_SALIDA_ATRIB_IWAY SA 
        WHERE SA.ID_MENSAJE_SALIDA_INTRAWAY = v_id_interfaz 
         AND SA.NOMBRE_ATRIBUTO = 'activationCode'; 
 
        select a.valor_atributo 
        into v_a_productocrm 
        from int_mensaje_salida_atrib_iway a 
        where a.id_mensaje_salida_intraway = v_id_interfaz 
         and a.nombre_atributo = 'defaultProductCRMId'; 
 
        --Nuevo ZQA 
        BEGIN 
          select a.valor_atributo 
          into v_a_defaultConfigCRMId 
          from int_mensaje_salida_atrib_iway a 
          where a.id_mensaje_salida_intraway = v_id_interfaz 
           --and lower(a.nombre_atributo) like '%defaultConfigCRMId%'; 
          and a.nombre_atributo = 'defaultConfigCRMId'; 
        EXCEPTION 
          WHEN OTHERS THEN 
           v_a_defaultConfigCRMId := ''; 
        END; 
 
        --Fin ZQA 
      EXCEPTION 
      WHEN others THEN 
        select max(idmail) + 1 into v_countcola from opewf.cola_send_mail_job; 
        insert into opewf.cola_send_mail_job (idmail,nombre,subject,destino,cuerpo,flg_env) 
        values (v_countcola,'SGA-SoportealNegocio','No se encuentra algunos valores de la Inerfase 2020','dl-pe-itsoportealnegocio@claro.com.pe','No se encontro parametros para la Interfase 2020 en el ID_VENTA: ' || to_char(p_id_venta),'0');--1.0 
        commit; 
        J := 0; 
        p_error := 1; 
      END; 
    END IF; 
 
    IF J = 1 THEN 
      BEGIN 
        --2020/4 Se procede a deshabilitar el STB 
        v_sendtocontroler := 'TRUE'; 
        intraway.PQ_INTRAWAY_REG.P_STB_CREA_ESPACIO(4,v_id_cliente,0, v_activationcode,v_a_productocrm, 
        'BASICO',v_a_defaultConfigCRMId,'TRUE',null,null,p_id_venta,0,0, p_resultado, p_mensaje, p_error ); 
 
      EXCEPTION 
      WHEN others THEN 
        p_error := 1; 
      END; 
 
      IF p_error = 0 THEN 
        BEGIN 
          --2020/2 Se regresa a estado OFF_PLANT al STB 
           v_a_defaultConfigCRMId  := 'VES_DSP'; 
           v_sendtocontroler := 'TRUE'; 
          INTRAWAY.PQ_INTRAWAY_REG.P_STB_CREA_ESPACIO(2,v_id_cliente,0, 
          v_activationcode,v_a_productocrm,'BASICO',v_a_defaultConfigCRMId,'TRUE',null,null,p_id_venta,0,0, p_resultado, p_mensaje, p_error ); 
        EXCEPTION 
        WHEN others THEN 
          p_error := 1; 
        END; 
      ELSE 
        select max(idmail) + 1 into v_countcola from opewf.cola_send_mail_job; 
        insert into opewf.cola_send_mail_job (idmail,nombre,subject,destino,cuerpo,flg_env) 
        values (v_countcola,'SGA-SoportealNegocio','No se realizó correctamente la deshabilitación del STB','dl-pe-itsoportealnegocio@claro.com.pe','No se realizó correctamente la deshabilitación del STB para el ID_VENTA: ' || to_char(p_id_venta),'0');--1.0 
        commit; 
      END IF; 
    END IF; 
 
    IF I = 1 and p_error = 0 THEN 
      BEGIN 
        --2020/0 Se regresa a estado OFF_PLANT al STB 
        v_a_defaultConfigCRMId  := 'VES_DSP'; 
        v_sendtocontroler := 'FALSE'; 

        INTRAWAY.PQ_INTRAWAY_REG.P_STB_CREA_ESPACIO(0,v_id_cliente,0, 
        v_activationcode,v_a_productocrm,'BASICO',v_a_defaultConfigCRMId,'TRUE',null,null,p_id_venta,0,0, p_resultado, p_mensaje, p_error ); 

        INTRAWAY.PQ_INTRAWAY_REG.P_ACT_CLIENTE_INTRAWAY(v_id_cliente,0, p_resultado, p_mensaje, p_error );
        --Ini 2.0
        select count(1) into  ln_pivot from  constante where constante = 'PIVOT' and valor = '1';
        If ln_pivot > 0 Then
          INTRAWAY.PQ_INTRAWAY_REG.P_ACT_CLIENTE_INTRAWAY(v_id_cliente,0, p_resultado, p_mensaje, p_error );
        End If;
        --fin 2.0
        
        p_resultado := 0; 
      EXCEPTION 
      WHEN others THEN 
        select max(idmail) + 1 into v_countcola from opewf.cola_send_mail_job; 
        insert into opewf.cola_send_mail_job (idmail,nombre,subject,destino,cuerpo,flg_env) 
        values (v_countcola,'SGA-SoportealNegocio','No se realizó correctamente la eliminación del espacio del STB','dl-pe-itsoportealnegocio@claro.com.pe','No se realizó correctamente la eliminación del espacio del STB para el ID_VENTA: ' || to_char(p_id_venta),'0');--1.0 
        commit; 
      END; 
    ELSE 
      p_resultado := 1; 
    END IF; 
END; 
/
