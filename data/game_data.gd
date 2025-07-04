extends Node

# Guia para leitura:
# 0--- = personagem controlado pelo jogador;
# 1--- = inimigos
# 2--- = ações
# 3--- = itens

const CHARACTERS = [
	{
		"id" : "0001",
		"name" : "Luís",
		"type" : "PLAYER",
		"texture" : preload("res://images/luis.png"),
		"max-hp" : 100,
		"speed" : 15,
		"actions" : []
	},
	{
		"id" : "0002",
		"name" : "Sophia",
		"type" : "PLAYER",
		"texture" : preload("res://images/sophia.png"),
		"max-hp" : 80,
		"speed" : 10,
		"actions" : []
	},
	{
		"id" : "0003",
		"name" : "Levi",
		"type" : "PLAYER",
		"texture" : preload("res://images/levi.png"),
		"max-hp" : 100,
		"speed": 20,
		"actions" : []
	},
	{
		"id" : "0004",
		"name" : "Pedro",
		"type" : "PLAYER",
		"texture" : preload("res://images/pedro.png"),
		"max-hp" : 125,
		"speed" : 25,
		"actions" : []
	}
]

const ENEMIES = [
	{
		"id" : "1001",
		"name" : "Pirata",
		"type" : "ENEMY",
		"texture" : preload("res://images/pirate.png"),
		"max-hp" : 300,
		"speed" : 5,
		"actions" : []
	},
	{
		"id" : "1002",
		"name" : "Palhaço",
		"type" : "ENEMY",
		"texture" : preload("res://images/Clown.png"),
		"max-hp" : 400,
		"speed" : 5,
		"actions" : []
	},
	{
		"id" : "1003",
		"name" : "Homem do Saco",
		"type" : "ENEMY",
		"texture" : preload("res://images/sackMan.png"),
		"max-hp" : 500,
		"speed" : 5,
		"actions" : []
	}
]

const ACTIONS = [
	{
		"id" : "2001",
		"name" : "Ataque",
		"type" : "attack",
		"target" : "ENEMY",
		"amount" : 25,
	}
]
