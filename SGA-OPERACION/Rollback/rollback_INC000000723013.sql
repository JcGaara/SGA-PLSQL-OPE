-- Drop columns 
alter table OPERACION.OPE_SP_MAT_EQU_DET drop column id_tecnologia;
alter table OPERACION.OPE_SP_MAT_EQU_DET drop column id_cod_sitio;
alter table OPERACION.OPE_SP_MAT_EQU_DET drop column name_sitio;

DELETE 
  FROM OPERACION.OPEDD D
WHERE D.TIPOPEDD = (SELECT T.TIPOPEDD
                       FROM OPERACION.TIPOPEDD T
                      WHERE T.ABREV = 'EST_SOL_PED')
   AND UPPER(D.DESCRIPCION) IN ('PDTE. UT', 'PDTE. PEP', 'OBSERVADO UT', 'OBSERVADO REQ');
 commit;