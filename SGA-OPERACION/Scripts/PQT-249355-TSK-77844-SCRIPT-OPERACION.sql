-- SCRIPT OPERACION
DECLARE
  ln_count                NUMBER;

BEGIN    
 -- JC
 
  ln_count  := 0; 
  SELECT COUNT(*) INTO  ln_count  FROM operacion.parametro_cab_adc where abreviatura= 'SERVICIO_POSVENTA';
  IF  ln_count  = 0 THEN       
    insert into operacion.parametro_cab_adc (DESCRIPCION, ABREVIATURA, ESTADO)
    values ('TIPO DE SERVICIO POSVENTA', 'SERVICIO_POSVENTA', '1');

    insert into operacion.parametro_det_adc (id_parametro,codigoc,codigon,descripcion,abreviatura,estado)
    values ((select max(c.id_parametro) from operacion.parametro_cab_adc c WHERE upper(c.abreviatura) = 'SERVICIO_POSVENTA'),'0073', 418, 'HFC - TRASLADO INTERNO' ,'Claro Empresa',1);

    insert into operacion.parametro_det_adc (id_parametro,codigoc,codigon,descripcion,abreviatura,estado)
    values ((select max(c.id_parametro) from operacion.parametro_cab_adc c WHERE upper(c.abreviatura) = 'SERVICIO_POSVENTA'),'0073', 424, 'HFC - INSTALACION PAQUETES TODO CLARO DIGITAL' ,'Claro Empresa',1);  
    
   insert into operacion.parametro_det_adc (id_parametro,codigoc,codigon,descripcion,abreviatura,estado)
     values ((select max(c.id_parametro) from operacion.parametro_cab_adc c WHERE upper(c.abreviatura) = 'SERVICIO_POSVENTA'),'0073', 724, 'CE HFC - SERVICIOS MENORES' ,'Claro Empresa',1);

    -- DECO PRINCIPAL 
    insert into operacion.parametro_det_adc (id_parametro,codigoc,codigon,descripcion,abreviatura,estado)
    values ((select max(c.id_parametro) from operacion.parametro_cab_adc c WHERE upper(c.abreviatura) = 'SERVICIO_POSVENTA'),'Cable Digital - Claro Empresas en HFC', NULL, 'Producto principal - Deco adicional CE' ,'PRINCIPAL_DECO',1);
    -- ID PRODUCTO     
    insert into operacion.parametro_det_adc (id_parametro,codigoc,codigon,descripcion,abreviatura,estado)
    values ((select max(c.id_parametro) from operacion.parametro_cab_adc c WHERE upper(c.abreviatura) = 'SERVICIO_POSVENTA'),NULL, 855, 'Servicios Adicionales - Cable - Claro Empresas en HFC' ,'IDPRODUCTO_DECO',1);  
         
  end if ;
  commit;

  ln_count  := 0; 
  SELECT COUNT(*) INTO  ln_count  FROM operacion.parametro_cab_adc where abreviatura= 'TIPO_SERVICIOS';
  IF  ln_count  = 0 THEN   
      INSERT INTO operacion.parametro_cab_adc (descripcion, abreviatura, estado) VALUES ('TIPOS DE SERVICIO', 'TIPO_SERVICIOS', '1');
         
      INSERT INTO operacion.parametro_det_adc (id_parametro, codigoc, codigon, descripcion, abreviatura, estado) 
      VALUES ((SELECT a.id_parametro FROM operacion.parametro_cab_adc a WHERE a.abreviatura = 'TIPO_SERVICIOS'), '0073', null, 'Paquetes Pymes en HFC', 'Claro Empresa', '1');
  end if ;
  commit;
  
  ln_count  := 0; 
  SELECT COUNT(*) INTO  ln_count  FROM operacion.parametro_cab_adc where abreviatura= 'TIPO_TRABAJO';
  IF  ln_count  = 0 THEN 
      INSERT INTO operacion.parametro_cab_adc (descripcion, abreviatura, estado) VALUES ('TIPOS DE TRABAJO', 'TIPO_TRABAJO', '1');
          
      INSERT INTO operacion.parametro_det_adc (id_parametro, codigoc, codigon, descripcion, abreviatura, estado) 
      VALUES ((SELECT a.id_parametro FROM operacion.parametro_cab_adc a WHERE a.abreviatura = 'TIPO_TRABAJO'), '0', 424, 'HFC - INSTALACION PAQUETES TODO CLARO DIGITAL', 'HFC_INST_CE', '1');

      INSERT INTO operacion.parametro_det_adc (id_parametro, codigoc, codigon, descripcion, abreviatura, estado) 
      VALUES ((SELECT a.id_parametro FROM operacion.parametro_cab_adc a WHERE a.abreviatura = 'TIPO_TRABAJO'),'1',  620, 'CLARO EMPRESAS HFC - SERVICIOS MENORES', 'SRV_MENORES', '1');
  end if ;
  commit;
  
  ln_count  := 0; 
  SELECT COUNT(*) INTO  ln_count  FROM operacion.tipopedd where abrev= 'FLG_TIPO_ADC';
  IF  ln_count  = 0 THEN           
      insert into operacion.tipopedd (descripcion, abrev)
      values('TIPOS PARA ADC','FLG_TIPO_ADC');  
           
      insert into operacion.opedd (CODIGON, DESCRIPCION,ABREVIACION,tipopedd)
      values(1,'MASIVOS','MASIVOS',(SELECT TIPOPEDD FROM operacion.tipopedd  WHERE abrev = 'FLG_TIPO_ADC')  );
      insert into operacion.opedd (CODIGON, DESCRIPCION,ABREVIACION,tipopedd)
      values(2,'CLARO EMPRESAS','CE',(SELECT TIPOPEDD FROM operacion.tipopedd  WHERE abrev = 'FLG_TIPO_ADC')  );
      
      -- actualizamos la data actual -- MASIVOS
      update operacion.TIPO_ORDEN_ADC t set t.flg_tipo = 1 ;
      
      -- INSERTAMOS LOS TIPOS PARA CE
      insert into OPERACION.TIPO_ORDEN_ADC ( COD_TIPO_ORDEN, DESCRIPCION, TIPO_TECNOLOGIA, ESTADO, TIPO_SERVICIO,flg_Tipo)
      values ('CEHFCI', 'CE HFC Instalacion', 'HFC', 1, 'Instalacion',2);
      insert into OPERACION.TIPO_ORDEN_ADC ( COD_TIPO_ORDEN, DESCRIPCION, TIPO_TECNOLOGIA, ESTADO, TIPO_SERVICIO,flg_Tipo)
      values ('CEHFCM', 'CE HFC Mantenimiento', 'HFC', 1, 'Mantenimiento',2);
      insert into OPERACION.TIPO_ORDEN_ADC ( COD_TIPO_ORDEN, DESCRIPCION, TIPO_TECNOLOGIA, ESTADO, TIPO_SERVICIO,flg_Tipo)
      values ('CEHFCP', 'CE HFC Post-Venta', 'HFC', 1,'Post-Venta',2);
      insert into OPERACION.TIPO_ORDEN_ADC ( COD_TIPO_ORDEN, DESCRIPCION, TIPO_TECNOLOGIA, ESTADO, TIPO_SERVICIO,flg_Tipo)
      values ('CECANH', 'CE HFC Bajas', 'HFC', 1, 'Bajas',2);
  
   end if ;
   commit;
   
   ln_count  := 0; 
  SELECT COUNT(*) INTO  ln_count  FROM operacion.parametro_cab_adc where abreviatura= 'HFC_CE_ORDEN_LINEAS';
  IF  ln_count  = 0 THEN    
       --INSERTAMOS EN operacion.SUBTIPO_ORDEN_ADC  
      insert into operacion.parametro_cab_adc (descripcion, abreviatura, estado)        
      values('ASIGANCION DE NRO. DE LINEAS','HFC_CE_ORDEN_LINEAS','1');
       
      insert into operacion.parametro_det_adc (CODIGON, descripcion,abreviatura, estado,id_parametro)        
      values(1,'MENOR IGUAL A 3','MENOR_IGUAL_3','1',(SELECT id_parametro FROM operacion.parametro_cab_adc WHERE abreviatura = 'HFC_CE_ORDEN_LINEAS'));
      insert into operacion.parametro_det_adc (CODIGON, descripcion,abreviatura, estado,id_parametro)        
      values(2,'MAYOR A 3','MAYOR_3','1',(SELECT id_parametro FROM operacion.parametro_cab_adc WHERE abreviatura = 'HFC_CE_ORDEN_LINEAS'));
      
  end if ;

  ln_count  := 0; 
  SELECT COUNT(*) INTO  ln_count  FROM opedd where DESCRIPCION = 'Cambio de plan CE' AND ABREVIACION = 'tipo_trabajo';
  IF  ln_count  = 0 THEN    
      insert into opedd (IDOPEDD, CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
        values ((select max(IDOPEDD) + 1 from opedd), null, 724,'Cambio de plan CE','tipo_trabajo', 
        (select MAX(tipopedd) from tipopedd where abrev='etadirect'), 1);
  end if ;

  commit;      

  ln_count  := 0; 
  SELECT COUNT(*) INTO  ln_count  FROM operacion.matriz_incidence_adc;
  IF  ln_count  = 0 THEN    
      insert into operacion.matriz_incidence_adc (CODSUBTYPE, CODINCTYPE, CODINCDESCRIPTION, CODCHANNEL, CODTYPESERVICE, CODCASE, ESTADO, FECCRE, USUCRE, FECMOD, USUMOD, IPCRE, IPMOD)
      values (16, 13, 11, 1, 3, 461, '0', sysdate, user, null, null, null, null);

      insert into operacion.matriz_incidence_adc (CODSUBTYPE, CODINCTYPE, CODINCDESCRIPTION, CODCHANNEL, CODTYPESERVICE, CODCASE, ESTADO, FECCRE, USUCRE, FECMOD, USUMOD, IPCRE, IPMOD)
      values (2, 2, 1, 1, 2, null, '0', sysdate, user, null, null, null, null);
  
  end if ;
  commit;   

  -- actualizamos valores de xml
  update operacion.ope_cab_xml set  xml = 
    '<ServiceToInstall>
      <PID>@Pid</PID>
      <NroServicio>@NroServicio</NroServicio>
      <Tipo>@Tipo</Tipo>
      <Servicio>@Servicio</Servicio>
      <IPPrincipal>@IPPrincipal</IPPrincipal>
      <Cantidad>@Cantidad</Cantidad>
      <CID>@cid</CID>
      <SID>@sid</SID>
      <CodigoActivacionInter>@actint</CodigoActivacionInter>
      <CodigoActivacionTelef>@acttel</CodigoActivacionTelef>    
    </ServiceToInstall>' 
    where metodo = 'Services_ToInstall';

    
  COMMIT;
-- liz
 
   insert into operacion.bucket_contrata_adc (IDBUCKET, CODCON, ESTADO, FLG_REC_SUBTIPO)   values ('COM2NET_LIM_LIMA', 198, '1', '0');
   insert into operacion.bucket_contrata_adc (IDBUCKET, CODCON, ESTADO, FLG_REC_SUBTIPO)   values ('TELECOM_LIM_LIMA', 410, '1', '0');
   insert into operacion.bucket_contrata_adc (IDBUCKET, CODCON, ESTADO, FLG_REC_SUBTIPO)   values ('IGW_PERU_LIM_LIMA', 403, '1', '0');
 
  insert into OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC ( TIPSRV, TIPTRA, CON_CAP_V, CON_CAP_P, CON_CAP_O, CON_CAP_I, GEN_OT_AUT, TIPO_AGENDA, VALIDA_MOT, ESTADO)
   values ('0073', 424, 1, 1, 1, 0,'A', 'TODOS', 0, 0);
   insert into OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC ( TIPSRV, TIPTRA, CON_CAP_V, CON_CAP_P, CON_CAP_O, CON_CAP_I, GEN_OT_AUT, TIPO_AGENDA, VALIDA_MOT, ESTADO)
   values ('0073', 418, 1, 1, 1, 0, 'M', 'TODOS', 0, 0);
   insert into OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC ( TIPSRV, TIPTRA, CON_CAP_V, CON_CAP_P, CON_CAP_O, CON_CAP_I, GEN_OT_AUT, TIPO_AGENDA, VALIDA_MOT, ESTADO)
   values ('0073', 620, 1, 1, 1, 0,'M', 'TODOS', 0, 0);
   insert into OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC ( TIPSRV, TIPTRA, CON_CAP_V, CON_CAP_P, CON_CAP_O, CON_CAP_I, GEN_OT_AUT, TIPO_AGENDA, VALIDA_MOT, ESTADO)
   values ('0073', 610, 0, 0, 1, 1, 'A', 'TODOS', 0, 0);
   insert into OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC ( TIPSRV, TIPTRA, CON_CAP_V, CON_CAP_P, CON_CAP_O, CON_CAP_I, GEN_OT_AUT, TIPO_AGENDA, VALIDA_MOT, ESTADO)
   values ('0006', 610, 0, 0, 1, 1, 'A', 'TODOS', 0, 0);
   insert into OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC ( TIPSRV, TIPTRA, CON_CAP_V, CON_CAP_P, CON_CAP_O, CON_CAP_I, GEN_OT_AUT, TIPO_AGENDA, VALIDA_MOT, ESTADO)
   values ('0073', 448, 0, 1, 1, 0, 'A', 'ACOMETIDA', 1, 0);
   insert into OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC ( TIPSRV, TIPTRA, CON_CAP_V, CON_CAP_P, CON_CAP_O, CON_CAP_I, GEN_OT_AUT, TIPO_AGENDA, VALIDA_MOT, ESTADO)
   values ('0073', 448, 0, 1, 1, 0,'M', 'EQUIPOS', 1, 0);
   insert into OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC ( TIPSRV, TIPTRA, CON_CAP_V, CON_CAP_P, CON_CAP_O, CON_CAP_I, GEN_OT_AUT, TIPO_AGENDA, VALIDA_MOT, ESTADO)
   values ('0004', 610, 0, 0, 1, 1, 'A', 'TODOS', 0, 0);
   insert into OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC ( TIPSRV, TIPTRA, CON_CAP_V, CON_CAP_P, CON_CAP_O, CON_CAP_I, GEN_OT_AUT, TIPO_AGENDA, VALIDA_MOT, ESTADO)
   values ('0073', 724, 1, 1, 1, 0, 'A', 'TODOS', 0, 0);
 
   INSERT INTO operacion.matriz_tiptratipsrvmot_adc (id_matriz, id_motivo, gen_ot_aut, estado) 
   VALUES ((SELECT a.id_matriz FROM operacion.matriz_tystipsrv_tiptra_adc a    WHERE a.tipsrv  = '0073' and tiptra = 448 and gen_ot_aut = 'A'), 13, 'A', 0);
   INSERT INTO operacion.matriz_tiptratipsrvmot_adc (id_matriz, id_motivo, gen_ot_aut, estado) 
   VALUES ((SELECT a.id_matriz FROM operacion.matriz_tystipsrv_tiptra_adc a    WHERE a.tipsrv  = '0073' and tiptra = 448 and gen_ot_aut = 'M'), 188, 'M', 0);
   INSERT INTO operacion.matriz_tiptratipsrvmot_adc (id_matriz, id_motivo, gen_ot_aut, estado) 
   VALUES ((SELECT a.id_matriz FROM operacion.matriz_tystipsrv_tiptra_adc a    WHERE a.tipsrv  = '0073' and tiptra = 448 and gen_ot_aut = 'M'), 976, 'M', 0);
   INSERT INTO operacion.matriz_tiptratipsrvmot_adc (id_matriz, id_motivo, gen_ot_aut, estado) 
   VALUES ((SELECT a.id_matriz FROM operacion.matriz_tystipsrv_tiptra_adc a    WHERE a.tipsrv  = '0073' and tiptra = 448 and gen_ot_aut = 'M'), 955, 'M', 0);
   INSERT INTO operacion.matriz_tiptratipsrvmot_adc (id_matriz, id_motivo, gen_ot_aut, estado) 
   VALUES ((SELECT a.id_matriz FROM operacion.matriz_tystipsrv_tiptra_adc a    WHERE a.tipsrv  = '0073' and tiptra = 448 and gen_ot_aut = 'M'), 602, 'M', 0);
   INSERT INTO operacion.matriz_tiptratipsrvmot_adc (id_matriz, id_motivo, gen_ot_aut, estado) 
   VALUES ((SELECT a.id_matriz FROM operacion.matriz_tystipsrv_tiptra_adc a    WHERE a.tipsrv  = '0073' and tiptra = 448 and gen_ot_aut = 'M'), 604, 'M', 0);
   INSERT INTO operacion.matriz_tiptratipsrvmot_adc (id_matriz, id_motivo, gen_ot_aut, estado) 
   VALUES ((SELECT a.id_matriz FROM operacion.matriz_tystipsrv_tiptra_adc a    WHERE a.tipsrv  = '0073' and tiptra = 448 and gen_ot_aut = 'M'), 855, 'M', 0);
   INSERT INTO operacion.matriz_tiptratipsrvmot_adc (id_matriz, id_motivo, gen_ot_aut, estado) 
   VALUES ((SELECT a.id_matriz FROM operacion.matriz_tystipsrv_tiptra_adc a    WHERE a.tipsrv  = '0073' and tiptra = 448 and gen_ot_aut = 'M'), 12, 'M', 0);
   INSERT INTO operacion.matriz_tiptratipsrvmot_adc (id_matriz, id_motivo, gen_ot_aut, estado) 
   VALUES ((SELECT a.id_matriz FROM operacion.matriz_tystipsrv_tiptra_adc a    WHERE a.tipsrv  = '0073' and tiptra = 448 and gen_ot_aut = 'M'), 865, 'M', 0);
   INSERT INTO operacion.matriz_tiptratipsrvmot_adc (id_matriz, id_motivo, gen_ot_aut, estado) 
   VALUES ((SELECT a.id_matriz FROM operacion.matriz_tystipsrv_tiptra_adc a    WHERE a.tipsrv  = '0073' and tiptra = 448 and gen_ot_aut = 'M'), 601, 'M', 0);
   INSERT INTO operacion.matriz_tiptratipsrvmot_adc (id_matriz, id_motivo, gen_ot_aut, estado) 
   VALUES ((SELECT a.id_matriz FROM operacion.matriz_tystipsrv_tiptra_adc a    WHERE a.tipsrv  = '0073' and tiptra = 448 and gen_ot_aut = 'M'), 823, 'M', 0);

  
   insert into OPERACION.WORK_SKILL_ADC ( COD_WORK_SKILL, DESCRIPCION, ESTADO) values ('CEHFCIS', 'CE HFC - INSTALADOR SENIOR', 1 );
   insert into OPERACION.WORK_SKILL_ADC ( COD_WORK_SKILL, DESCRIPCION, ESTADO) values ('CEBARH', 'CE HFC Bajas - RECUPERO EQUIPOS', 1 );
   insert into OPERACION.WORK_SKILL_ADC ( COD_WORK_SKILL, DESCRIPCION, ESTADO) values ('CEHFCMS', 'CE HFC - MANTENIMIENTO SENIOR ', 1);
   insert into OPERACION.WORK_SKILL_ADC ( COD_WORK_SKILL, DESCRIPCION, ESTADO) values ('CEHFCPS', 'CE HFC - POST VENTA SENIOR ', 1);
   insert into OPERACION.WORK_SKILL_ADC ( COD_WORK_SKILL, DESCRIPCION, ESTADO) values ('CEBACH', 'CE HFC Bajas - CORTE DE ACOMETIDA', 1);

   update operacion.tiptrabajo set id_tipo_orden_ce= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'CEHFCI') where tiptra='424';
   update operacion.tiptrabajo set id_tipo_orden_ce= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'CEHFCP') where tiptra='620';
   update operacion.tiptrabajo set id_tipo_orden_ce= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'CEHFCP') where tiptra='418';
   update operacion.tiptrabajo set id_tipo_orden_ce= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'CEHFCM') where tiptra='610';
   update operacion.tiptrabajo set id_tipo_orden_ce= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'CECANH') where tiptra='448';
   update operacion.tiptrabajo set id_tipo_orden_ce= (SELECT a.id_tipo_orden FROM operacion.tipo_orden_adc a WHERE a.cod_tipo_orden = 'CEHFCP') where tiptra='724';

   commit;

   ln_count  := 0; 
   SELECT COUNT(*) INTO  ln_count  FROM operacion.parametro_cab_adc where abreviatura= 'SOLUCIONES_CE';
   IF  ln_count  = 0 THEN    
      
       INSERT INTO operacion.parametro_cab_adc (descripcion, abreviatura, estado) 
       VALUES ('SOLUCIONES CE', 'SOLUCIONES_CE', '1');
       
       INSERT INTO operacion.parametro_det_adc (id_parametro, codigoc, codigon, descripcion, abreviatura, estado) VALUES ((SELECT a.id_parametro FROM        operacion.parametro_cab_adc a WHERE a.abreviatura = 'SOLUCIONES_CE'), NULL, 100, 'Claro Empresas 1 Play Digital', '1_PLAY', '1');
       INSERT INTO operacion.parametro_det_adc (id_parametro, codigoc, codigon, descripcion, abreviatura, estado) VALUES ((SELECT a.id_parametro FROM        operacion.parametro_cab_adc a WHERE a.abreviatura = 'SOLUCIONES_CE'), NULL, 101, 'Claro Empresas 2 Play Digital', '2_PLAY', '1');
       INSERT INTO operacion.parametro_det_adc (id_parametro, codigoc, codigon, descripcion, abreviatura, estado) VALUES ((SELECT a.id_parametro FROM                     operacion.parametro_cab_adc a WHERE a.abreviatura = 'SOLUCIONES_CE'), NULL, 102, 'Claro Empresas 3 Play Digital', '3_PLAY', '1');

      
  end if ;


   ln_count  := 0; 
   SELECT COUNT(*) INTO  ln_count  FROM operacion.parametro_cab_adc where abreviatura= 'SERVICIOS_CE';
     IF  ln_count  = 0 THEN    
      
      
        INSERT INTO operacion.parametro_cab_adc (descripcion, abreviatura, estado) 
        VALUES ('SERVICIOS CE', 'SERVICIOS_CE', '1');
       
      
        INSERT INTO operacion.parametro_det_adc (id_parametro, codigoc, codigon, descripcion, abreviatura, estado) VALUES ((SELECT a.id_parametro FROM   operacion.parametro_cab_adc a WHERE a.abreviatura = 'SERVICIOS_CE'), 100, 1, 'TV', 'TV', '1');
        INSERT INTO operacion.parametro_det_adc (id_parametro, codigoc, codigon, descripcion, abreviatura, estado) VALUES ((SELECT a.id_parametro FROM   operacion.parametro_cab_adc a WHERE a.abreviatura = 'SERVICIOS_CE'), 100, 2, 'INTERNET', 'INTERNET', '1');
        INSERT INTO operacion.parametro_det_adc (id_parametro, codigoc, codigon, descripcion, abreviatura, estado) VALUES ((SELECT a.id_parametro FROM   operacion.parametro_cab_adc a WHERE a.abreviatura = 'SERVICIOS_CE'), 100, 3, 'TELEFONIA', 'TELEFONIA', '1');
        INSERT INTO operacion.parametro_det_adc (id_parametro, codigoc, codigon, descripcion, abreviatura, estado) VALUES ((SELECT a.id_parametro FROM   operacion.parametro_cab_adc a WHERE a.abreviatura = 'SERVICIOS_CE'), 101, 4, 'TV + TELEFONIA', 'TV_TELEFONIA', '1');
        INSERT INTO operacion.parametro_det_adc (id_parametro, codigoc, codigon, descripcion, abreviatura, estado) VALUES ((SELECT a.id_parametro FROM   operacion.parametro_cab_adc a WHERE a.abreviatura = 'SERVICIOS_CE'), 101, 5, 'TV + INTERNET', 'TV_INTERNET', '1');
        INSERT INTO operacion.parametro_det_adc (id_parametro, codigoc, codigon, descripcion, abreviatura, estado) VALUES ((SELECT a.id_parametro FROM   operacion.parametro_cab_adc a WHERE a.abreviatura = 'SERVICIOS_CE'), 101, 6, 'TELEFONIA + INTERNET', 'TELEFONIA_INTERNET', '1');
        INSERT INTO operacion.parametro_det_adc (id_parametro, codigoc, codigon, descripcion, abreviatura, estado) VALUES ((SELECT a.id_parametro FROM           operacion.parametro_cab_adc a WHERE a.abreviatura = 'SERVICIOS_CE'), 102, 7, 'TV + TELEFONIA + INTERNET', 'TV_TELEFONIA_INTERNET', '1'); 
   end if ;

  INSERT INTO OPERACION.SERVICIO_MAT_ADC (ID_SERV_MAT,ID_SOLUCION, ID_SERVICIO ) VALUES (1,100,1);
  INSERT INTO OPERACION.SERVICIO_MAT_ADC (ID_SERV_MAT,ID_SOLUCION, ID_SERVICIO ) VALUES (2,100,2);
  INSERT INTO OPERACION.SERVICIO_MAT_ADC (ID_SERV_MAT,ID_SOLUCION, ID_SERVICIO ) VALUES (3,100,3);
  INSERT INTO OPERACION.SERVICIO_MAT_ADC (ID_SERV_MAT,ID_SOLUCION, ID_SERVICIO ) VALUES (4,101,4);
  INSERT INTO OPERACION.SERVICIO_MAT_ADC (ID_SERV_MAT,ID_SOLUCION, ID_SERVICIO ) VALUES (5,101,5);
  INSERT INTO OPERACION.SERVICIO_MAT_ADC (ID_SERV_MAT,ID_SOLUCION, ID_SERVICIO ) VALUES (6,101,6);
  INSERT INTO OPERACION.SERVICIO_MAT_ADC (ID_SERV_MAT,ID_SOLUCION, ID_SERVICIO ) VALUES (7,102,7);



commit;
   
 END;
/