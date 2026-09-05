class_name Sequence
extends Node

signal finished


func start() -> void:
	push_error("Sequence.start() não implementado")


func complete() -> void:
	finished.emit()
