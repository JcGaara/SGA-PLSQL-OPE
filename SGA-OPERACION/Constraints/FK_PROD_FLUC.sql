ALTER TABLE operacion.sgat_df_proceso_det
    ADD CONSTRAINT fk_prod_fluc FOREIGN KEY ( prodn_idflujo )
        REFERENCES operacion.sgat_df_flujo_cab ( flucn_idflujo );
