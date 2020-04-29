-- Drop columns 
alter table OPERACION.UBI_TECNICA drop column AREA_EMPRESA;
alter table OPERACION.UBI_TECNICA drop column REGION;

/*********  DELETE Constantes estados ************/
DELETE FROM OPERACION.OPEDD D
 WHERE D.TIPOPEDD =
       (SELECT T.TIPOPEDD
          FROM OPERACION.TIPOPEDD T
         WHERE T.ABREV = 'EST_SOL_PED'
           AND D.codigoc = '1'
           AND D.ABREVIACION IN ('EST_SOL_PED_M', 'EST_SOL_PED_F'));
 commit;						
 /*********  DELETE Constantes estados ************/
DELETE FROM OPERACION.OPEDD D
 WHERE D.TIPOPEDD = (SELECT T.TIPOPEDD
                       FROM OPERACION.TIPOPEDD T
                      WHERE T.ABREV = 'CON_ATT_REQ');
 commit;

DELETE FROM OPERACION.TIPOPEDD D 
WHERE D.ABREV = 'CON_ATT_REQ'; 
commit;

/*********  DELETE Constantes grupo ************/
 DELETE FROM OPERACION.OPEDD D
 WHERE D.TIPOPEDD = (SELECT T.TIPOPEDD
                       FROM OPERACION.TIPOPEDD T
                      WHERE T.ABREV = 'GRUPO_AUTORIZACION');
 commit;

DELETE FROM OPERACION.TIPOPEDD D 
WHERE D.ABREV = 'GRUPO_AUTORIZACION'; 
commit;

/*********  DELETE Constantes area_empresa ************/
 DELETE FROM OPERACION.OPEDD D
 WHERE D.TIPOPEDD = (SELECT T.TIPOPEDD
                       FROM OPERACION.TIPOPEDD T
                      WHERE T.ABREV = 'AREA_EMPRESA');
 commit;

DELETE FROM OPERACION.TIPOPEDD D 
WHERE D.ABREV = 'AREA_EMPRESA'; 
commit;

/****** ELIMINACION DE PROCEDURES ******/
-- Eliminacion de Procedures
DROP PROCEDURE operacion.sgass_estado_sol;
DROP PROCEDURE operacion.sgass_listar_usuario;
DROP PROCEDURE operacion.sgass_sinergia_mant;
commit;

/