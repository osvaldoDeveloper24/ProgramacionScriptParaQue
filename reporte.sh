#!/bin/bash
#Producto más vendido
ventas_diarias="ventas_diarias.csv"

function producto_mas_vendido() {
    declare -A productos  # Declarar el array asociativo
    declare -A total_por_producto 

    while IFS=";" read -r _ _ producto _ _ total; do
        #eliminar espacios en blanco en total
        total=$(echo "$total" | tr -d '[:space:]')
        if [[ "$producto"  && "$total" =~ ^[0-9]+$ ]]; then #verifica que sea un número entero
            ((productos["$producto"]++))
            ((total_por_producto["$producto"]+=total))
            
        fi 
    done < "$ventas_diarias"  # Leer desde el archivo

    contador_Productos=0
    producto_mas_vendido=""

    for producto in "${!productos[@]}"; do
        if (( productos["$producto"] > contador_Productos )); then
            contador_Productos=${productos["$producto"]}
            producto_mas_vendido="$producto"
        fi
    done

    if [[ -n "$producto_mas_vendido" ]]; then
        #Buscar el total acumulado del producto más vendido
        total_del_mas_vendido=${total_por_producto["$producto_mas_vendido"]}
        echo "El producto más vendido es: $producto_mas_vendido con $contador_Productos ventas"
        echo "Total del producto más vendido durante el año: \$$total_del_mas_vendido"
    else
        echo "No se encontraron productos."
    fi
}


producto_mas_vendido