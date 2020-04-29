CREATE OR REPLACE VIEW OPERACION.PROV_BSCS_IL_LTE AS
SELECT a."REQUEST",a."REQUEST_PADRE",a."STATUS",a."USERID",a."CUSTOMER_ID",a."CO_ID",a."INSERT_DATE",a."PRIORITY",a."ACTION_DATE",a."ACTION_ID",a."ERROR_CODE",a."OBSERVACION",a."SOT",a."ORIGEN_PROV",a."TIPO_PROD",a."MSISDN_OLD",a."MSISDN_NEW",a."IMSI_OLD",a."IMSI_NEW",a."SNCODE_ADIC",a."NCOS",a."LTEV_USUCREACION",a."LTED_FECHA_CREACION",a."LTEV_USUMODIFICACION",a."LTED_FECHAMODIFICACION",a."ID_SERVICIO", '0' hist
  FROM tim.lte_control_prov@dbl_bscs_bf a
UNION
SELECT b."REQUEST",b."REQUEST_PADRE",b."STATUS",b."USERID",b."CUSTOMER_ID",b."CO_ID",b."INSERT_DATE",b."PRIORITY",b."ACTION_DATE",b."ACTION_ID",b."ERROR_CODE",b."OBSERVACION",b."SOT",b."ORIGEN_PROV",b."TIPO_PROD",b."MSISDN_OLD",b."MSISDN_NEW",b."IMSI_OLD",b."IMSI_NEW",b."SNCODE_ADIC",b."NCOS",b."LTEV_USUCREACION",b."LTED_FECHA_CREACION",b."LTEV_USUMODIFICACION",b."LTED_FECHAMODIFICACION",b."ID_SERVICIO", '1' hist
  FROM tim.lte_control_prov_hist@dbl_bscs_bf b;