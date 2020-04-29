CREATE OR REPLACE VIEW OPERACION.V_ACTIVIDAD
AS 
SELECT ACTIVIDAD.CODACT, ACTIVIDAD.DESCRIPCION, ACTIVIDAD.CODUND, ACTIVIDAD.COSTO, 0 CODCON, ALMUNIMED.DESUND,  
 actividad.moneda_id, actividad.codubi, vtatabdst.NOMDST, aCTIVIDAD.MONEDA_ID  
FROM ACTIVIDAD, ALMUNIMED, vtatabdst  
WHERE ACTIVIDAD.CODUND = ALMUNIMED.CODUND (+) and actividad.codubi = vtatabdst.codubi (+) and actividad.estado = 1  
UNION  
SELECT A.CODACT,A.DESCRIPCION, A.CODUND, NVL(B.COSTO,A.COSTO) COSTO, A.CODCON, C.DESUND , a.moneda , a.codubi, d.nomdst, a.MONEDA_ID FROM  
(SELECT A.CODACT,A.DESCRIPCION, A.CODUND, A.COSTO, C.CODCON CODCON, a.moneda_id moneda, a.codubi, a.MONEDA_ID FROM CONTRATA C, ACTIVIDAD A where A.estado = 1 ) A,  
ACTXCONTRATA B,  
ALMUNIMED C ,  
vtatabdst d  
WHERE A.CODCON = B.CODCON (+) AND  
A.CODACT = B.CODACT (+) AND  
C.CODUND (+) = A.CODUND and  
a.codubi = d.codubi (+);


