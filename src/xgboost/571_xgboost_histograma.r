# XGBoost  sabor HISTOGRAMA
# corre en la PC local

#limpio la memoria
rm( list=ls() )  #remove all objects
gc()             #garbage collection

require("data.table")
require("xgboost")

#Aqui se debe poner la carpeta de la computadora local
setwd("c:/desarrollo")   #Establezco el Working Directory

#cargo el dataset donde voy a entrenar
dataset  <- fread("./datasets/paquete_premium_202011.csv", stringsAsFactors= TRUE)


#paso la clase a binaria que tome valores {0,1}  enteros
dataset[ , clase01 := ifelse( clase_ternaria=="BAJA+2", 1L, 0L) ]

#los campos que se van a utilizar
campos_buenos  <- setdiff( colnames(dataset), c("clase_ternaria","clase01") )


#dejo los datos en el formato que necesita XGBoost
dtrain  <- xgb.DMatrix( data= data.matrix(  dataset[ , campos_buenos, with=FALSE]),
                        label= dataset$clase01 )

#genero el modelo con los parametros por default
modelo  <- xgb.train( data= dtrain,
                      param= list( objective=       "binary:logistic",
                                   tree_method=     "hist",
                                   grow_policy=     "lossguide",
                                   base_score= mean( getinfo(dtrain, "label")),
                                   max_bin=            256,
                                   max_leaves=          437,
                                   min_child_weight=    10,
                                   eta=                 0.010028544, 
                                   colsample_bytree=    0.647462947,
                                   gamma=                0.0,  #por ahora, lo dejo fijo, equivalente a  min_gain_to_split
                                   alpha=                0.0,  #por ahora, lo dejo fijo, equivalente a  lambda_l1
                                   lambda=               0.0,  #por ahora, lo dejo fijo, equivalente a  lambda_l2
                                   subsample=            1.0,  #por ahora, lo dejo fijo
                                   max_depth=           0,    #ya lo voy a cambiar
                                   scale_pos_weight=     1.0   #por ahora, lo dejo fijo
                                   ),
                      nrounds= 191  # MUY IMPORTANTE,  la cantidad de arboles del ensemble
                    )

#aplico el modelo a los datos sin clase
dapply  <- fread("./datasets/paquete_premium_202101.csv")

#aplico el modelo a los datos nuevos
prediccion  <- predict( modelo, 
                        data.matrix( dapply[, campos_buenos, with=FALSE ]) )


#Genero la entrega para Kaggle
entrega  <- as.data.table( list( "numero_de_cliente"= dapply[  , numero_de_cliente],
                                 "Predicted"= as.integer( prediccion > 0.0132705923482666)  ) ) #genero la salida

dir.create( "./labo/exp/",  showWarnings = FALSE ) 
dir.create( "./labo/exp/KA5710/", showWarnings = FALSE )
archivo_salida  <- "./labo/exp/KA5710/KA_571_024.csv"

#genero el archivo para Kaggle
fwrite( entrega, 
        file= archivo_salida, 
        sep= "," )