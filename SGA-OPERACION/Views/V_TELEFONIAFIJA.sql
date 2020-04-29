CREATE OR REPLACE VIEW OPERACION.V_TELEFONIAFIJA
AS 
SELECT A.CID,A.CODCLI,A.NOMCLI,'PRI' DESCRIPCION,A.NROCANAL,A.NUMERO,A.DIRECCION DIRECCION_inst,A.nomdst nomdst_INST,A.nompvc nompvc_INST,A.nomest nomest_INST
,T.DIRFAC DIRECCION_FAC,V.NOMDST nomdst_FAC,V.NOMPVC nompvc_FAC,V.NOMEST nomest_FAC,A.FECINI,A.ESTADO FROM (
SELECT inssrv.cid,
vtatabcli.codcli,
vtatabcli.nomcli,
numtel.numero,
pritel.nrocanal,
INSSRV.DIRECCION,
u.nomdst,
u.nompvc,
u.nomest,
inssrv.fecini,
ei.descripcion ESTADO,
MAX(PB.GRUPO) GRUPO
FROM pritel,prixhunting,hunting,numtel,inssrv,puertoxequipo,acceso,v_ubicaciones u,estinssrv ei,
vtatabcli,
INSTANCIASERVICIO SB,
INSTXPRODUCTO PB
WHERE ( pritel.codinssrv = inssrv.codinssrv ) and
( inssrv.cid = puertoxequipo.cid ) and
( puertoxequipo.cid = acceso.cid ) and
( vtatabcli.codcli = acceso.codcli ) and
( pritel.codpritel = prixhunting.codpritel ) and
( prixhunting.codcab = hunting.codcab ) and
( hunting.codnumtel = numtel.codnumtel )
and puertoxequipo.estado = 1
and u.codubi= inssrv.codubi
and inssrv.estinssrv=ei.estinssrv
AND INSSRV.CODINSSRV=SB.CODINSSRV(+)
AND SB.IDINSTSERV=PB.IDCOD(+)
AND INSSRV.CODCLI=SB.CODCLI(+)
GROUP BY inssrv.cid,vtatabcli.codcli,vtatabcli.nomcli,numtel.numero,pritel.nrocanal,INSSRV.DIRECCION,
u.nomdst,u.nompvc,u.nomest,inssrv.fecini,ei.descripcion) A,
TABGRUPO T,
V_UBICACIONES V
WHERE A.CODCLI=T.CODCLI(+)
AND A.GRUPO=T.GRUPO(+)
AND T.CODUBIFAC=V.CODUBI(+)
union
SELECT A.CID,A.CODCLI,A.NOMCLI,'ANALOGICA' DESCRIPCION,0 NROCANAL,A.NUMERO,A.DIRECCION DIRECCION_inst,A.nomdst nomdst_INST,A.nompvc nompvc_INST,A.nomest nomest_INST
,T.DIRFAC DIRECCION_FAC,V.NOMDST nomdst_FAC,V.NOMPVC nompvc_FAC,V.NOMEST nomest_FAC,A.FECINI,A.ESTADO
 FROM (SELECT
        puertoxequipo.cid,
        VTATABCLI.CODCLI,
        vtatabcli.nomcli,
        productocorp.descripcion ,
        INSSRV.DIRECCION,
        u.nomdst,
        u.nompvc,
        u.nomest,
        inssrv.fecini,
        ei.descripcion ESTADO,
        inssrv.numero,
        MAX(PB.GRUPO) GRUPO
            FROM puertoxequipo,
            acceso,
            equipored,
            tarjetaxequipo,
            vtatabcli,
            productocorp,
            tipequipored,
            ubired,
            inssrv,v_ubicaciones u,estinssrv ei,
            (select codigon, descripcion from opedd where tipopedd = 22) estado,
            INSTANCIASERVICIO SB,
            INSTXPRODUCTO PB
                  WHERE ( puertoxequipo.cid = acceso.cid (+)) and
                  ( equipored.codequipo (+) = puertoxequipo.codequipo) and
                  ( tarjetaxequipo.codtarjeta (+) = puertoxequipo.codtarjeta) and
                  ( vtatabcli.codcli (+) = acceso.codcli) and
                  ( productocorp.codprd (+) = puertoxequipo.codprd) and
                  ( puertoxequipo.estado = estado.codigon ) and
                  equipored.tipo = tipequipored.codtipo(+) and
                  equipored.codubired = ubired.codubired(+)
                  AND puertoxequipo.codprd=250
                  AND estado.codigon=1
                  and inssrv.codinssrv=acceso.codinssrv
                  and u.codubi(+)= inssrv.codubi
                  and inssrv.estinssrv=ei.estinssrv
                  AND INSSRV.CODINSSRV=SB.CODINSSRV(+)
                  AND SB.IDINSTSERV=PB.IDCOD(+)
                  AND INSSRV.CODCLI=SB.CODCLI(+)
              GROUP BY puertoxequipo.cid,
              VTATABCLI.CODCLI,
              vtatabcli.nomcli,
              productocorp.descripcion,
              INSSRV.DIRECCION,
              u.nomdst,
              u.nompvc,
              u.nomest,
              inssrv.fecini,
              ei.descripcion,
              inssrv.numero) A,
TABGRUPO T,
V_UBICACIONES V
WHERE A.CODCLI=T.CODCLI(+)
AND A.GRUPO=T.GRUPO(+)
AND T.CODUBIFAC=V.CODUBI(+);


