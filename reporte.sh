#!/bin/bash
#Producto más vendido
ventas_diarias="ventas_diarias.csv"

function producto_mas_vendido() {
    # Declarar el arrays asociativo
    declare -A productos  # para contar cuántas veces se vendió cada producto.
    declare -A total_por_producto # para acumular el total de ventas de cada producto.

    while IFS=";" read -r _ _ producto _ _ total; do #Los guiones bajos son para ignorar columna
        total=$(echo "$total" | tr -d '[:space:]') #eliminar espacios en blanco en total
        if [[ "$producto"  && "$total" =~ ^[0-9]+$ ]]; then # Verifica que producto no esté vacío y total sea un número entero
            ((productos["$producto"]++)) #incrementa el contador de ventas del producto en el array productos
            ((total_por_producto["$producto"]+=total)) # acumula el total de ventas del producto en el array
            
        fi 
    done < "$ventas_diarias"  # Leer desde el archivo

    contador_Productos=0 # Inicializa un contador para llevar un registro del número de ventas del producto
    producto_mas_vendido="" # Se inicializa una variable para guardar el nombre del producto más vendidio

    for producto in "${!productos[@]}"; do # recorre el array de productos
        if (( productos["$producto"] > contador_Productos )); then #Se compara si el número de ventas del producto actual es mayor que el contador guardado
            contador_Productos=${productos["$producto"]}
            producto_mas_vendido="$producto"
        fi
    done

    if [[ "$producto_mas_vendido" ]]; then # verifica si se ha encontrado un producto más vendido
        #Buscar el total acumulado del producto más vendido
        total_del_mas_vendido=${total_por_producto["$producto_mas_vendido"]}
        echo "El producto más vendido es: $producto_mas_vendido con $contador_Productos ventas"
        echo "Total del producto más vendido durante el año: \$$total_del_mas_vendido"
    else
        echo "No se encontraron productos."
    fi
}


producto_mas_vendido