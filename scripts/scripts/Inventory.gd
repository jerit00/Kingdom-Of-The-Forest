# Inventory.gd
extends Node2D

var items = []  # Lista de objetos en el inventario

# Agregar un objeto al inventario
func add_item(item):
	items.append(item)
	print("Item agregado:", item)

# Quitar un objeto del inventario
func remove_item(item):
	if item in items:
		items.erase(item)
		print("Item removido:", item)

# Mostrar los objetos del inventario (puedes adaptar esto a tu UI)
func show_inventory():
	for item in items:
		print("Objeto en inventario:", item)
