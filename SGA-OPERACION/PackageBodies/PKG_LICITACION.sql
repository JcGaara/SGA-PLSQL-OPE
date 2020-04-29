create or replace package body COLLECTIONS.PKG_LICITACION is

 PROCEDURE SP_LISTA_CLIENTE(P_NOMCLI VARCHAR2,P_CODCLI VARCHAR2 , PO_CURSOR OUT VG_CURSOR)
      IS
       BEGIN
          
          IF LENGTH(TRIM(P_NOMCLI))>0 AND LENGTH(TRIM(P_CODCLI)) > 0 THEN        
          OPEN PO_CURSOR FOR
          SELECT codcli, nomcli , ntdide
          FROM    MARKETING.vtatabcli 
          WHERE  upper(TRIM(codcli)) LIKE  '%' ||  upper(TRIM(P_CODCLI)) || '%'
          AND   upper(TRIM(nomcli)) LIKE '%' || upper(TRIM(P_NOMCLI)) || '%';  
      
          
          ElSIF LENGTH(TRIM(P_NOMCLI))>0 THEN                   
          OPEN PO_CURSOR FOR
          SELECT  codcli, nomcli, ntdide
          FROM    MARKETING.vtatabcli 
          WHERE upper(TRIM(nomcli)) LIKE  '%' ||upper(TRIM(P_NOMCLI)) || '%'; 
          
          ELSIF  LENGTH(TRIM(P_CODCLI)) > 0 THEN                   
          OPEN PO_CURSOR FOR
          SELECT  codcli, nomcli, ntdide
          FROM    MARKETING.vtatabcli 
          WHERE   upper(TRIM(codcli))  = upper(TRIM(P_CODCLI)) ;       
          
      END IF ; 
     END;
 
  PROCEDURE SP_LISTA_SERVICIO(P_TIPSRV VARCHAR2,P_NOMABR VARCHAR2, PO_CURSOR OUT VG_CURSOR)
       IS
       BEGIN
          
      IF LENGTH(TRIM(P_TIPSRV))>0 AND LENGTH(TRIM(P_NOMABR)) > 0 THEN             
          OPEN PO_CURSOR FOR
          SELECT tipsrv , nomabr  FROM SALES.tystipsrv
          WHERE estado = 1 
          AND  upper(TRIM(tipsrv)) LIKE '%' ||  upper(TRIM(P_TIPSRV)) || '%'
          AND  upper(TRIM(nomabr)) LIKE  '%' ||upper(TRIM(P_NOMABR)) || '%';           
              
      ELSIF LENGTH(TRIM(P_TIPSRV))>0 THEN     
          OPEN PO_CURSOR FOR              
          SELECT tipsrv , nomabr  FROM SALES.tystipsrv
          WHERE estado = 1 
          AND upper(TRIM(tipsrv)) = upper(TRIM(P_TIPSRV))  ;    
      
      ELSIF LENGTH(TRIM(P_NOMABR)) > 0 THEN   
          OPEN PO_CURSOR FOR                
          SELECT tipsrv , nomabr  FROM SALES.tystipsrv
          WHERE estado = 1 
          AND upper(TRIM(nomabr)) LIKE  '%' ||upper(TRIM(P_NOMABR)) || '%';        
      END IF;
      
     END;

	 
   PROCEDURE SP_LISTA_PROYECTO_FIJA(P_NOMCLI VARCHAR2,P_COD_CLI VARCHAR2, P_NUMSLC VARCHAR2,PO_CURSOR OUT VG_CURSOR)
      IS
      BEGIN
       IF  LENGTH(TRIM(P_NOMCLI))>0 AND LENGTH(TRIM(P_COD_CLI)) > 0 AND  LENGTH(TRIM(P_NUMSLC))>0 THEN
         
          OPEN PO_CURSOR FOR      
          SELECT
          VTATABPSPCLI.TIPSRV,
          VTATABPSPCLI.CODCLI,
          (SELECT T.NOMCLI FROM MARKETING.VTATABCLI T WHERE T.CODCLI = VTATABPSPCLI.CODCLI)Nomcli,
          (SELECT T.NTDIDE FROM MARKETING.VTATABCLI T WHERE T.CODCLI = VTATABPSPCLI.CODCLI)RUC,
          VTATABPSPCLI.NUMSLC,
          VTATABPSPCLI.DURCON,
          contrato.fec_fincontrato,
          contrato.fec_firmacontrato,
          contrato.nrodoc_contrato 
          FROM SALES.VTATABPSPCLI, CONTRATO.contrato, SALES.vtatipdocofe td 
          WHERE ((VTATABPSPCLI.NUMPSP, VTATABPSPCLI.IDOPC)
          IN (select numpsp, max(idopc) from SALES.vtatabpspcli where numpsp = VTATABPSPCLI.NUMPSP group by numpsp)) 
          AND VTATABPSPCLI.numpsp = contrato.numpsp(+)
          AND VTATABPSPCLI.idopc = contrato.idopc(+) and contrato.tipdoc = td.tipdoc(+)
          AND upper(TRIM(VTATABPSPCLI.NUMSLC)) LIKE '%' || upper(TRIM(P_NUMSLC)) || '%'
          AND upper(TRIM(VTATABPSPCLI.CODCLI)) LIKE '%'|| upper(TRIM(P_COD_CLI)) ||'%'
          AND upper(TRIM((SELECT T.NOMCLI FROM MARKETING.VTATABCLI T WHERE T.CODCLI = VTATABPSPCLI.CODCLI))) LIKE '%'|| upper(TRIM(P_NOMCLI)) || '%';
       
       ELSIF LENGTH(TRIM(P_NOMCLI)) > 0  AND LENGTH(TRIM(P_COD_CLI)) > 0 THEN
       
          OPEN PO_CURSOR FOR      
          SELECT
          VTATABPSPCLI.TIPSRV,
          VTATABPSPCLI.CODCLI,
          (SELECT T.NOMCLI FROM MARKETING.VTATABCLI T WHERE T.CODCLI = VTATABPSPCLI.CODCLI)Nomcli,
          (SELECT T.NTDIDE FROM MARKETING.VTATABCLI T WHERE T.CODCLI = VTATABPSPCLI.CODCLI)RUC,
          VTATABPSPCLI.NUMSLC,
          VTATABPSPCLI.DURCON,
          contrato.fec_fincontrato,
          contrato.fec_firmacontrato,
          contrato.nrodoc_contrato 
          FROM SALES.VTATABPSPCLI, CONTRATO.contrato, SALES.vtatipdocofe td 
          WHERE ((VTATABPSPCLI.NUMPSP, VTATABPSPCLI.IDOPC)
          IN (select numpsp, max(idopc) from SALES.vtatabpspcli where numpsp = VTATABPSPCLI.NUMPSP group by numpsp)) 
          AND VTATABPSPCLI.numpsp = contrato.numpsp(+)
          AND VTATABPSPCLI.idopc = contrato.idopc(+) and contrato.tipdoc = td.tipdoc(+)
          AND upper(TRIM(VTATABPSPCLI.CODCLI)) LIKE '%'|| upper(TRIM(P_COD_CLI)) ||'%'
          AND upper(TRIM((SELECT T.NOMCLI FROM MARKETING.VTATABCLI T WHERE T.CODCLI = VTATABPSPCLI.CODCLI))) LIKE '%'|| upper(TRIM(P_NOMCLI)) || '%';
               
       ELSIF LENGTH(TRIM(P_COD_CLI)) > 0  AND LENGTH(TRIM(P_NUMSLC)) > 0 THEN 
       
          OPEN PO_CURSOR FOR      
          SELECT
          VTATABPSPCLI.TIPSRV,
          VTATABPSPCLI.CODCLI,
          (SELECT T.NOMCLI FROM MARKETING.VTATABCLI T WHERE T.CODCLI = VTATABPSPCLI.CODCLI)Nomcli,
          (SELECT T.NTDIDE FROM MARKETING.VTATABCLI T WHERE T.CODCLI = VTATABPSPCLI.CODCLI)RUC,
          VTATABPSPCLI.NUMSLC,
          VTATABPSPCLI.DURCON,
          contrato.fec_fincontrato,
          contrato.fec_firmacontrato,
          contrato.nrodoc_contrato 
          FROM SALES.VTATABPSPCLI, CONTRATO.contrato, SALES.vtatipdocofe td 
          WHERE ((VTATABPSPCLI.NUMPSP, VTATABPSPCLI.IDOPC)
          IN (select numpsp, max(idopc) from SALES.vtatabpspcli where numpsp = VTATABPSPCLI.NUMPSP group by numpsp)) 
          AND VTATABPSPCLI.numpsp = contrato.numpsp(+)
          AND VTATABPSPCLI.idopc = contrato.idopc(+) and contrato.tipdoc = td.tipdoc(+)
          AND upper(TRIM(VTATABPSPCLI.NUMSLC)) LIKE '%' || upper(TRIM(P_NUMSLC)) || '%'
          AND upper(TRIM(VTATABPSPCLI.CODCLI)) LIKE '%'|| upper(TRIM(P_COD_CLI)) ||'%';
     
       ELSIF LENGTH(TRIM(P_NOMCLI)) > 0 THEN
          
          OPEN PO_CURSOR FOR      
          SELECT
          VTATABPSPCLI.TIPSRV,
          VTATABPSPCLI.CODCLI,
          (SELECT T.NOMCLI FROM MARKETING.VTATABCLI T WHERE T.CODCLI = VTATABPSPCLI.CODCLI)Nomcli,
          (SELECT T.NTDIDE FROM MARKETING.VTATABCLI T WHERE T.CODCLI = VTATABPSPCLI.CODCLI)RUC,
          VTATABPSPCLI.NUMSLC,
          VTATABPSPCLI.DURCON,
          contrato.fec_fincontrato,
          contrato.fec_firmacontrato,
          contrato.nrodoc_contrato 
          FROM SALES.VTATABPSPCLI, CONTRATO.contrato, SALES.vtatipdocofe td 
          WHERE ((VTATABPSPCLI.NUMPSP, VTATABPSPCLI.IDOPC)
          IN (select numpsp, max(idopc) from SALES.vtatabpspcli where numpsp = VTATABPSPCLI.NUMPSP group by numpsp)) 
          AND VTATABPSPCLI.numpsp = contrato.numpsp(+)
          AND VTATABPSPCLI.idopc = contrato.idopc(+) and contrato.tipdoc = td.tipdoc(+)
          AND upper(TRIM((SELECT T.NOMCLI FROM MARKETING.VTATABCLI T WHERE T.CODCLI = VTATABPSPCLI.CODCLI))) LIKE '%'|| upper(TRIM(P_NOMCLI)) || '%';

       ELSIF LENGTH(TRIM(P_COD_CLI)) > 0 THEN
       
          OPEN PO_CURSOR FOR      
          SELECT
          VTATABPSPCLI.TIPSRV,
          VTATABPSPCLI.CODCLI,
          (SELECT T.NOMCLI FROM MARKETING.VTATABCLI T WHERE T.CODCLI = VTATABPSPCLI.CODCLI)Nomcli,
          (SELECT T.NTDIDE FROM MARKETING.VTATABCLI T WHERE T.CODCLI = VTATABPSPCLI.CODCLI)RUC,
          VTATABPSPCLI.NUMSLC,
          VTATABPSPCLI.DURCON,
          contrato.fec_fincontrato,
          contrato.fec_firmacontrato,
          contrato.nrodoc_contrato 
          FROM SALES.VTATABPSPCLI, CONTRATO.contrato, SALES.vtatipdocofe td 
          WHERE ((VTATABPSPCLI.NUMPSP, VTATABPSPCLI.IDOPC)
          IN (select numpsp, max(idopc) from SALES.vtatabpspcli where numpsp = VTATABPSPCLI.NUMPSP group by numpsp)) 
          AND VTATABPSPCLI.numpsp = contrato.numpsp(+)
          AND VTATABPSPCLI.idopc = contrato.idopc(+) and contrato.tipdoc = td.tipdoc(+)
          AND upper(TRIM(VTATABPSPCLI.CODCLI)) LIKE '%'|| upper(TRIM(P_COD_CLI)) ||'%';
                 
       ELSIF LENGTH(TRIM(P_NUMSLC)) > 0 THEN
       
          OPEN PO_CURSOR FOR      
          SELECT
          VTATABPSPCLI.TIPSRV,
          VTATABPSPCLI.CODCLI,
          (SELECT T.NOMCLI FROM MARKETING.VTATABCLI T WHERE T.CODCLI = VTATABPSPCLI.CODCLI)Nomcli,
          (SELECT T.NTDIDE FROM MARKETING.VTATABCLI T WHERE T.CODCLI = VTATABPSPCLI.CODCLI)RUC,
          VTATABPSPCLI.NUMSLC,
          VTATABPSPCLI.DURCON,
          contrato.fec_fincontrato,
          contrato.fec_firmacontrato,
          contrato.nrodoc_contrato 
          FROM SALES.VTATABPSPCLI, CONTRATO.contrato, SALES.vtatipdocofe td 
          WHERE ((VTATABPSPCLI.NUMPSP, VTATABPSPCLI.IDOPC)
          IN (select numpsp, max(idopc) from SALES.vtatabpspcli where numpsp = VTATABPSPCLI.NUMPSP group by numpsp)) 
          AND VTATABPSPCLI.numpsp = contrato.numpsp(+)
          AND VTATABPSPCLI.idopc = contrato.idopc(+) and contrato.tipdoc = td.tipdoc(+)
          AND upper(TRIM(VTATABPSPCLI.NUMSLC))  =  upper(TRIM(P_NUMSLC));
        
       END IF;
     
     END;
   

END PKG_LICITACION;