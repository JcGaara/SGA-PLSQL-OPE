delete from operacion.matriz_incidence_adc 
      where CODSUBTYPE in (2, 19) 
        and CODINCTYPE in (2, 16) 
        and CODINCDESCRIPTION = 1
        and CODCHANNEL is null
        and CODTYPESERVICE is null
        and CODCASE is null;		

------------------ RF 12: MENSAJE DE VALICACION PANEL DE AGENDAMIENTO-----------------------
delete from operacion.parametro_det_adc t
 where t.id_parametro in
       (select a.id_parametro
          from operacion.parametro_cab_adc a
         where a.abreviatura = 'VAL_PANAGE');
		 
delete from operacion.parametro_cab_adc t
 where t.abreviatura = 'VAL_PANAGE';	 

-------------------------RF: 06  MENSAJE DE VALICACION OT MANUAL Y AUTOMATICA ----------------
delete from operacion.parametro_det_adc t
 where t.id_parametro in
       (select a.id_parametro
          from operacion.parametro_cab_adc a
         where a.abreviatura = 'VAL_OT_MA');
		 
delete from operacion.parametro_cab_adc t
 where t.abreviatura = 'VAL_OT_MA';
 
commit;
/
---------------------------------------MODIFICACION DE TABLA ---------------------------------- 	
ALTER TABLE operacion.parametro_vta_pvta_adc 
DROP COLUMN PVAD_FLAG_PRIO;

---------------------------------RF: 06 INSERT EN MATRIZ -----------------------------------------
declare
   as_user  varchar2(30); 
   av_fecha varchar2(60);                         
begin  
   delete from operacion.matriz_tystipsrv_tiptra_adc t
         where to_char(t.fecre,'dd/mm/yyyy hh24:mi') = &av_fecha
           and t.usucre = &as_user
           and t.tipsrv || '-' || t.tiptra in ('0077-485','0077-498','0077-497','0077-612','0077-432',
                                               '0061-409','0061-410','0061-424','0061-660','0061-705',
                                               '0061-721','0061-407','0061-489','0061-678','0061-727');
                                               
   commit;
end;
/

----------------------------RF: 06 ACTUALIZACION DEL TIPTRABAJO ---------------------------------------------
declare
   type array_tra is varray(25) of number;
   type array_tip is varray(25) of varchar2(10);
   array_tra1 array_tra := array_tra(485,498,497,612,409,410,424,660,678,705,
                                     721,407,489,432,727,407,408,448,480,489,
                                     497,498,612,671,770);
   array_tip1 array_tip := array_tip('DTHI','DTHM','DTHP','DTHM','HFCP','HFCP','HFCP','HFCP','HFCP','HFCP',
                                     'HFCP','HFCM','HFCM','CAND','DTHM','HFCM','CANH','CANH','HFCM','HFCM',
                                     'DTHP','DTHM','DTHM','HFCM','HFCM');  
   as_user  varchar2(30);  
   av_fecha_tip_ord varchar2(60);                                                                  
   av_fecha_reagen varchar2(60);    
begin
   for m in 1..array_tra1.count loop              
       BEGIN
          update operacion.tiptrabajo T
             set t.id_tipo_orden = null,
                 t.fecusu = SYSDATE,
                 t.codusu = USER,
	         t.num_reagenda = decode(t.num_reagenda,3,null,t.num_reagenda)
           where t.tiptra = array_tra1(m)
             and to_char(t.fecusu,'dd/mm/yyyy hh24:mi') = &av_fecha_tip_ord
             and t.codusu = &as_user
             and t.id_tipo_orden = (select a.id_tipo_orden
                                      from operacion.tipo_orden_adc a
                                     where a.cod_tipo_orden = array_tip1(m));
           
       EXCEPTION
         WHEN NO_DATA_FOUND then
           null;
       END;  
   end loop;

    update operacion.TIPTRABAJO t 
       set t.num_reagenda = null,
		   t.fecusu = SYSDATE,
		   t.codusu = USER
     where t.num_reagenda = 3
       and to_char(t.fecusu,'dd/mm/yyyy hh24:mi') = &av_fecha_tip_ord
       and t.codusu = &as_user
       and T.TIPTRA in ('407','409','410','424','432','485','489','497',
                        '498','612','660','678','705','721','727');                                               
                                                  
   
   commit;
end;
/

 update operacion.tiptrabajo T
             set t.id_tipo_orden = 6
  where t.tiptra  = 497;

update operacion.tiptrabajo T
             set t.id_tipo_orden = 5
  where t.tiptra  = 498;

commit;

declare
   as_user  varchar2(30);   
   av_fecha varchar2(30); 
begin
  delete from operacion.matriz_tystipsrv_tiptra_adc where to_char(fecre,'dd/mm/yyyy hh24:mi') = &av_fecha and usucre = &as_user and tiptra in (407, 408, 448, 480, 489, 671, 770, 497, 498, 612, 727);
  commit;
end;
/

