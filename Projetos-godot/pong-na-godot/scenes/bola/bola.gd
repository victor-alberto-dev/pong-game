extends Area2D

# Movimento
var velocidade_da_bola : int  = 500
var velocidade_inicial : int = 500
var posicao_inicial : Vector2 = Vector2(640, 360)
var direcao_inicial : Vector2 = Vector2(0, 0)
var nova_direcao : Vector2 = Vector2(0, 0)

# Limites
var x_minimo : float = 0
var x_maximo : float = 1280
var y_minimo : float = 0
var y_maximo : float = 720

# Efeitos Sonoros
@onready var som_impacto_barreira: AudioStreamPlayer = $SomImpactoBarreira
@onready var som_impacto_jogador: AudioStreamPlayer = $SomImpactoJogador

# Timer
@onready var timer : Timer = $Timer


func _ready():
	rodar_timer()


func _process(delta):
	movimentar_bola(delta)
	colidir_com_as_paredes()
	

func rodar_timer() -> void:
	timer.start()

	
func resetar_bola() -> void:
	# Centraliza a bola e a manda para uma direção aleatória
	position = posicao_inicial
	
	# Reseta a velocidade da bola quando reseta o jogo
	velocidade_da_bola = velocidade_inicial
	
	escolher_direcao_inicial()


func escolher_direcao_inicial() -> void:
	# Escolhe as direções Horizontal e Vertical
	var x_aleatorio = [-1, 1].pick_random()
	var y_aleatorio = [-1, 1].pick_random()
	
	# Aplica as novas direções
	direcao_inicial = Vector2(x_aleatorio, y_aleatorio)
	nova_direcao = direcao_inicial


func movimentar_bola(delta : float) -> void:
	# Movimenta a bola
	position += nova_direcao * velocidade_da_bola * delta
	
	
func colidir_com_as_paredes() -> void:
	# Manda a bola na direção contraria ao tentar sair da tela
	if position.y >= y_maximo or position.y <= y_minimo:
		if position.x >= x_minimo and position.x <= x_maximo:
			nova_direcao.y *= -1
			som_impacto_barreira.play()
	
	
func _on_body_entered(body):
	# Manda a bola na direção contraria ao colidir com os jogadores
	if body.is_in_group("jogadores"):
		nova_direcao.x *= -1
		velocidade_da_bola += 20
		som_impacto_jogador.play()
		
		
func _on_timer_timeout() -> void:
	resetar_bola()
