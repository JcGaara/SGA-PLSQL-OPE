CREATE OR REPLACE PROCEDURE OPERACION.p_tifweb IS

--DECLARE
nConta number;
CURSOR c_tifweb IS
              --Completar la informacion para realzar la isercion
              SELECT
              (SELECT  max(idpartif) FROM ind_parametro_tif)+1 idpartif,
              (SELECT  max(periodo) FROM ind_parametro_tif)+1 periodo,
              Tabla_2.G001,
              Tabla_2.G002,
              Tabla_2.G003,
              Tabla_2.G004,
              Tabla_2.G999,
              1 activo,
              'ACALLIRGOS' usureg,
              sysdate fecreg
              FROM
              (
                  --Realizar el acumulado para realizar la insercion e la tabla ind_parametro_tif
                  SELECT
                  sum(G001) G001,sum(G002) G002,sum(G003) G003,sum(G004) G004,sum(G999) G999
                  FROm
                  (
                    --Modificar la data de grupo para poder utilizarmos como consulta
                    SELECT
                    sysdate,
                    Case GRUPO
                      WHEN '001' THEN (cantidad) END G001,
                    Case GRUPO
                      WHEN '002' THEN (cantidad) END G002,
                    Case GRUPO
                      WHEN '003' THEN (cantidad) END G003,
                    Case GRUPO
                      WHEN '004' THEN (cantidad) END G004,
                    Case GRUPO
                      WHEN '999' THEN  (cantidad) END G999
                    --FROM operaciones.t_tif@pedwhprd.world
                    FROM operaciones.t_tif@pedwhprd.world where periodo = to_char(sysdate,'yyyymm')---Verificar
                  ) Tabla_1
              ) Tabla_2
           ;
           BEGIN
            --No duplicar la insercion del mismo mes
            Select count(*) Into nConta from ind_parametro_tif Where to_char(fecreg,'yyyymm') = to_char(sysdate,'yyyymm');
            If nConta = 0 then
              FOR l_tifweb IN c_tifweb LOOP
                  INSERT INTO ind_parametro_tif VALUES (
                                                        l_tifweb.idpartif,
                                                        l_tifweb.periodo,
                                                        l_tifweb.G001,
                                                        l_tifweb.G002,
                                                        l_tifweb.G003,
                                                        l_tifweb.G004,
                                                        l_tifweb.activo,
                                                        l_tifweb.usureg,
                                                        l_tifweb.fecreg
                                                        );
                  COMMIT;
              END LOOP;
            END IF;
           END;
/


