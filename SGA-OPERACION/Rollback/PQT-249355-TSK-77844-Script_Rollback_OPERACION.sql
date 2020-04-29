-- SCRIPT OPERACION
DECLARE
  ln_count                NUMBER;

BEGIN 
    ln_count  := 0; 
    SELECT COUNT(*) INTO  ln_count  FROM operacion.tipopedd where abrev= 'FLG_TIPO_ADC';
    IF ln_count  > 0 THEN 
      delete from  OPERACION.TIPO_ORDEN_ADC where flg_Tipo = 2;
      delete from  operacion.opedd where tipopedd = (SELECT TIPOPEDD FROM operacion.tipopedd  WHERE abrev = 'FLG_TIPO_ADC') ;
      delete FROM operacion.tipopedd where abrev= 'FLG_TIPO_ADC';
    end if;
    
    commit;
    ln_count  := 0; 
    SELECT COUNT(*) INTO  ln_count  FROM operacion.parametro_cab_adc where abreviatura= 'HFC_CE_ORDEN_LINEAS';
    IF  ln_count  > 0 THEN   
      delete from operacion.parametro_det_adc where id_parametro = (SELECT id_parametro FROM operacion.parametro_cab_adc WHERE abreviatura = 'HFC_CE_ORDEN_LINEAS');
      delete FROM operacion.parametro_cab_adc where abreviatura= 'HFC_CE_ORDEN_LINEAS';
    end if;    
    commit;
    
    ln_count  := 0; 
    SELECT COUNT(*) INTO LN_COUNT FROM OPERACION.PARAMETRO_DET_ADC
     WHERE ID_PARAMETRO IN
           (SELECT A.ID_PARAMETRO
              FROM OPERACION.PARAMETRO_CAB_ADC A
             WHERE A.ABREVIATURA IN ('TIPO_SERVICIOS', 'TIPO_TRABAJO'));                         
    IF  ln_count  > 0 THEN   
      DELETE FROM OPERACION.PARAMETRO_DET_ADC
       WHERE ID_PARAMETRO IN
             (SELECT A.ID_PARAMETRO
                FROM OPERACION.PARAMETRO_CAB_ADC A
               WHERE A.ABREVIATURA IN ('TIPO_SERVICIOS', 'TIPO_TRABAJO'));
               
      DELETE FROM OPERACION.PARAMETRO_CAB_ADC A
       WHERE A.ABREVIATURA IN ('TIPO_SERVICIOS', 'TIPO_TRABAJO');  
    end if;    
    commit;
    
     ln_count  := 0; 
  SELECT COUNT(*) INTO  ln_count  FROM operacion.parametro_cab_adc where abreviatura= 'SERVICIO_POSVENTA';
  IF  ln_count  > 0 THEN       
     DELETE FROM OPERACION.PARAMETRO_DET_ADC D
      WHERE D.ID_PARAMETRO =
            (SELECT C.ID_PARAMETRO
               FROM OPERACION.PARAMETRO_CAB_ADC C
              WHERE UPPER(C.ABREVIATURA) = 'SERVICIO_POSVENTA');
     DELETE FROM OPERACION.PARAMETRO_CAB_ADC C
      WHERE UPPER(C.ABREVIATURA) = 'SERVICIO_POSVENTA';
  end if ;

   ln_count  := 0; 
   SELECT COUNT(*) INTO  ln_count  FROM operacion.parametro_cab_adc where abreviatura= 'SERVICIOS_CE';
   IF  ln_count  > 0 THEN       
      DELETE FROM OPERACION.PARAMETRO_DET_ADC
       WHERE ID_PARAMETRO IN
             (SELECT A.ID_PARAMETRO
                FROM OPERACION.PARAMETRO_CAB_ADC A
               WHERE A.ABREVIATURA IN ('SERVICIOS_CE'));
               
      DELETE FROM OPERACION.PARAMETRO_CAB_ADC A
       WHERE A.ABREVIATURA IN ('SERVICIOS_CE');  
   end if ;

   ln_count  := 0; 
   SELECT COUNT(*) INTO  ln_count  FROM operacion.parametro_cab_adc where abreviatura= 'SOLUCIONES_CE';
   IF  ln_count  > 0 THEN       
      DELETE FROM OPERACION.PARAMETRO_DET_ADC
       WHERE ID_PARAMETRO IN
             (SELECT A.ID_PARAMETRO
                FROM OPERACION.PARAMETRO_CAB_ADC A
               WHERE A.ABREVIATURA IN ('SOLUCIONES_CE'));
               
      DELETE FROM OPERACION.PARAMETRO_CAB_ADC A
       WHERE A.ABREVIATURA IN ('SOLUCIONES_CE');  
   end if ;

  commit;



   delete  operacion.bucket_contrata_adc  where CODCON in (198,410,403);
   delete  operacion.matriz_tiptratipsrvmot_adc  where id_matriz in (SELECT a.id_matriz FROM operacion.matriz_tystipsrv_tiptra_adc a WHERE a.tipsrv  = '0073' );
 delete  operacion.matriz_tiptratipsrvmot_adc  where id_matriz in (SELECT a.id_matriz FROM operacion.matriz_tystipsrv_tiptra_adc a WHERE a.tiptra  = 610 );   
   delete  OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC where  TIPSRV= '0073';
   delete OPERACION.MATRIZ_TYSTIPSRV_TIPTRA_ADC where  TIPTRA= 610;
   delete  operacion.subtipo_orden_adc where cod_subtipo_orden like 'CE%';
   delete  OPERACION.WORK_SKILL_ADC where COD_WORK_SKILL like 'CE%';
   delete operacion.inventario_em_adc where flg_tipo=2;
   delete OPERACION.ESTADO_MOTIVO_SGA_ADC where id_tipo_orden in (select id_tipo_orden  from operacion.tipo_orden_adc where cod_tipo_orden  like 'CE%');
   delete from opedd where DESCRIPCION = 'Cambio de plan CE' AND ABREVIACION = 'tipo_trabajo'; 
   
    -- actualizamos valores de xml FASE 1
    update operacion.ope_cab_xml set  xml = 
      '<ServiceToInstall>
        <PID>@Pid</PID>
        <NroServicio>@NroServicio</NroServicio>
        <Tipo>@Tipo</Tipo>
        <Servicio>@Servicio</Servicio>
        <IPPrincipal>@IPPrincipal</IPPrincipal>
        <Cantidad>@Cantidad</Cantidad>
      </ServiceToInstall>' 
      where metodo = 'Services_ToInstall';
    ---------------------------  
       
COMMIT;
 END;
/
