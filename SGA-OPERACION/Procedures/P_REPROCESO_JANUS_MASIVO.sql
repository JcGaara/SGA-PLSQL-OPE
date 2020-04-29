CREATE OR REPLACE PROCEDURE OPERACION.P_REPROCESO_JANUS_MASIVO(
                                 v_error   out number,
                                 v_message out varchar2) IS
   an_codsolot number;
   an_error    number;
   av_error    varchar2(500);
   
   --Registros con error a reprocesar para lineas de bscs
   CURSOR CUR_RP_PROV_BSCS IS
   select rp.ord_id,
          rp.ord_id_ant,
          rp.action_id,
          rp.co_id,
          rp.estado_prv,
          rp.fecha_insert,
          rp.valores,
          rp.errmsg
     from TIM.RP_PROV_BSCS_JANUS@dbl_bscs_bf rp,
          contract_all@dbl_bscs_bf           ca
    WHERE rp.Estado_Prv = 6
      and rp.co_id = ca.co_id
      and ca.sccode = 6 and trunc(rp.fecha_insert)= trunc(sysdate);
            
   --Registros con error a reprocesar para lineas de claro empresas   
   CURSOR CUR_RP_PROV_CTRL IS
   select rp.ord_id,
          rp.ord_id_ant,
          rp.action_id,
          rp.co_id,
          rp.estado_prv,
          rp.fecha_insert,
          rp.valores,
          rp.errmsg
     from TIM.RP_PROV_CTRL_JANUS@dbl_bscs_bf rp,
          contract_all@dbl_bscs_bf           ca
    WHERE rp.Estado_Prv = 6
      and rp.co_id = ca.co_id
      and ca.sccode = 6 and trunc(rp.fecha_insert)= trunc(sysdate);      

BEGIN
  
     FOR R IN CUR_RP_PROV_BSCS LOOP
       --Para obtener la sot a traves del contrato      
       an_codsolot := operacion.pq_sga_iw.f_max_sot_x_cod_id(R.co_id);   
       
       OPERACION.PQ_SGA_JANUS.p_reproceso_janusxsot(an_codsolot,
                                             an_error,
                                             av_error);  
                                                                                             
       DBMS_OUTPUT.put_line('p_reproceso_janusxsot-Clientes-SOT='||an_codsolot||' CODIGO='||an_error|| ' MENSAJE='||av_error);                                                                                                                                                                                      
     END LOOP;
     
     FOR R IN CUR_RP_PROV_CTRL LOOP
       --Para obtener la sot a traves del contrato      
       an_codsolot := operacion.pq_sga_iw.f_max_sot_x_cod_id(R.co_id);   

       OPERACION.PQ_SGA_JANUS.p_reproceso_janusxsot(an_codsolot,
                                             an_error,
                                             av_error); 
                                             
       DBMS_OUTPUT.put_line('p_reproceso_janusxsot-Claro empresas-SOT='||an_codsolot||' CODIGO='||an_error|| ' MENSAJE='||av_error);                                                                                                                                    
     END LOOP;
          
     v_message := 'El procedimiento P_REPROCESO_JANUS_MASIVO se ejecutó satisfactoriamente';
     v_error :=0;
     DBMS_OUTPUT.put_line(v_message);
EXCEPTION
    WHEN OTHERS THEN
      v_message := 'Error en el procedimiento P_REPROCESO_JANUS_MASIVO : ' || SQLERRM;
      v_error := sqlcode;      
      DBMS_OUTPUT.put_line(v_message||' '||v_error);
      
END P_REPROCESO_JANUS_MASIVO;
/
