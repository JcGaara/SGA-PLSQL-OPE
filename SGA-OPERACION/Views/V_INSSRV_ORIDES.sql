CREATE OR REPLACE VIEW OPERACION.V_INSSRV_ORIDES
AS 
SELECT 'ORIGEN' tipo, i.codinssrv codinsrsv, i.codinssrv_ori codinssrv_orides  
    FROM inssrv i  
     where i.codinssrv_ori is not null  
union all  
  SELECT 'DESTINO', i.codinssrv , i.codinssrv_des  
    FROM inssrv i  
     where  i.codinssrv_des is not null;


