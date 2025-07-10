extends Node

# Guia para leitura:
# id:
# 0--- = personagem controlado pelo jogador;
# 1--- = inimigos
# 2--- = ações
# 3--- = itens

# Tipos de personagens
const TYPE_PLAYER = "PLAYER"
const TYPE_ENEMY = "ENEMY"

# Tipos de ações:
const TYPE_ATTACK = "ATTACK"
const TYPE_HEAL = "HEAL"
const TYPE_BUFF = "BUFF"

# Escopo de alvos:
const TARGET_SINGLE = "SINGLE"
const TARGET_ALL = "ALL"
const TARGET_RANDOM = "RANDOM"
const TARGET_SELF = "SELF"

# Lados/grupos:
const SIDE_PLAYER = "PLAYER_SIDE"
const SIDE_ENEMY = "ENEMY_SIDE"

# Buffs / Efeitos:
const BUFF_PARALYZED = "PARALISADO"
const BUFF_TAUNTED = "PROVOCAR"

const CHARACTERS = [
	{
		"id" : "0001",
		"name" : "Luís",
		"type" : TYPE_PLAYER,
		"texture" : preload("res://images/luis.png"),
		"max_hp" : 100,
		"speed" : 15,
		"actions" : ["2001", "2002"]
	},
	{
		"id" : "0002",
		"name" : "Sophia",
		"type" : TYPE_PLAYER,
		"texture" : preload("res://images/sophia.png"),
		"max_hp" : 80,
		"speed" : 10,
		"actions" : ["2007", "2008"]
	},
	{
		"id" : "0003",
		"name" : "Levi",
		"type" : TYPE_PLAYER,
		"texture" : preload("res://images/levi.png"),
		"max_hp" : 120,
		"speed": 20,
		"actions" : ["2005", "2006"]
	},
	{
		"id" : "0004",
		"name" : "Pedro",
		"type" : TYPE_PLAYER,
		"texture" : preload("res://images/pedro.png"),
		"max_hp" : 150,
		"speed" : 25,
		"actions" : ["2003", "2004"]
	}
]

const ENEMIES = [
	{
		"id" : "1001",
		"name" : "Pirata",
		"type" : TYPE_ENEMY,
		"texture" : preload("res://images/pirate.png"),
		"max_hp" : 300,
		"speed" : 5,
		"actions" : ["2009", "2010"]
	},
	{
		"id" : "1002",
		"name" : "Palhaço",
		"type" : TYPE_ENEMY,
		"texture" : preload("res://images/Clown.png"),
		"max_hp" : 400,
		"speed" : 5,
		"actions" : ["2011", "2012"]
	},
	{
		"id" : "1003",
		"name" : "Homem",
		"type" : TYPE_ENEMY,
		"texture" : preload("res://images/sackMan.png"),
		"max_hp" : 500,
		"speed" : 5,
		"actions" : ["2013", "2014", "2015", "2016"]
	}
]

const ACTIONS = [
	{
		"id" : "2001",
		"name" : "Arremesso",
		"type" : TYPE_ATTACK,
		"target" : {
			"side" : SIDE_ENEMY,
			"scope" : TARGET_SINGLE
		},
		"amount" : 20,
		"hits" : 1
	},
	{
		"id" : "2002",
		"name" : "Arremesso triplo",
		"type" : TYPE_ATTACK,
		"target" : {
			"side" : SIDE_ENEMY,
			"scope" : TARGET_SINGLE
		},
		"amount" : 20,
		"hits" : 3,
	},
	{
		"id" : "2003",
		"name" : "Soco",
		"type" : TYPE_ATTACK,
		"target" : {
			"side" : SIDE_ENEMY,
			"scope" : TARGET_SINGLE
		},
		"amount" : 25,
		"hits" : 1,
	},
	{
		"id" : "2004",
		"name" : "Careta",
		"type": TYPE_BUFF,
		"target": {
			"side": SIDE_ENEMY,
			"scope": TARGET_SINGLE
		},
		"buff": BUFF_TAUNTED,
		"amount": 0,
	},
	{
		"id" : "2005",
		"name" : "Golpe de Espada",
		"type" : TYPE_ATTACK,
		"target" : {
			"side" : SIDE_ENEMY,
			"scope" : TARGET_SINGLE
		},
		"amount" : 30,
		"hits" : 1,
	},
	{
		"id" : "2006",
		"name" : "Ponto Fraco",
		"type" : TYPE_ATTACK,
		"target" : {
			"side" : SIDE_ENEMY,
			"scope" : TARGET_SINGLE
		},
		"amount" : 50,
		"hits" : 1,
	},
	{
		"id" : "2007",
		"name" : "Abraço",
		"type" : TYPE_HEAL,
		"target" : {
			"side" : SIDE_PLAYER,
			"scope" : TARGET_SINGLE
		},
		"amount" : 40,
		"hits" : 1,
	},
	{
		"id" : "2008",
		"name" : "Abraço em grupo",
		"type" : TYPE_HEAL,
		"target" : {
			"side" : SIDE_PLAYER,
			"scope" : TARGET_ALL
		},
		"amount" : 25,
		"hits" : 1,
	},
	{
		"id" : "2009",
		"name" : "Gancho",
		"type" : TYPE_ATTACK,
		"target" : {
			"side" : SIDE_PLAYER,
			"scope" : TARGET_SINGLE
		},
		"amount" : 35,
		"hits" : 1,
	},
	{
		"id" : "2010",
		"name" : "Disparo",
		"type" : TYPE_ATTACK,
		"target" : {
			"side" : SIDE_PLAYER,
			"scope" : TARGET_SINGLE
		},
		"amount" : 50,
		"hits" : 1,
	},
	{
		"id" : "2011",
		"name" : "Boing!",
		"type" : TYPE_ATTACK,
		"target" : {
			"side" : SIDE_PLAYER,
			"scope" : TARGET_SINGLE
		},
		"amount" : 40,
		"hits" : 1,
	},
	{
		"id" : "2012",
		"name" : "Gargalhar",
		"type" : TYPE_ATTACK,
		"target" : {
			"side" : SIDE_PLAYER,
			"scope" : TARGET_SINGLE
		},
		"amount" : 30,
		"hits" : 1,
	},
	{
		"id" : "2013",
		"name" : "Rasgar",
		"type" : TYPE_ATTACK,
		"target" : {
			"side" : SIDE_PLAYER,
			"scope" : TARGET_SINGLE
		},
		"amount" : 40,
		"hits" : 1,
	},
	{
		"id" : "2014",
		"name" : "Raptar",
		"type" : TYPE_BUFF,
		"target" : {
			"side" : SIDE_PLAYER,
			"scope" : TARGET_SINGLE
		},
		"amount" : 0,
		"hits" : 1,
		"buff" : BUFF_PARALYZED
	},
	{
		"id" : "2015",
		"name" : "Sem fuga",
		"type" : TYPE_ATTACK,
		"target" : {
			"side" : SIDE_PLAYER,
			"scope" : TARGET_ALL
		},
		"amount" : 30,
		"hits" : 1,
	},
	{
		"id" : "2016",
		"name" : "Temam",
		"type" : TYPE_HEAL,
		"target" : {
			"side" : SIDE_ENEMY,
			"scope" : TARGET_SINGLE
		},
		"amount" : 50,
		"hits" : 1,
	}
]
