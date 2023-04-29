extends Node3D
class_name FootComponent

@onready var foot_particle: GPUParticles3D = $footParticle
@onready var foot_sound: AudioStreamPlayer3D = $footSound

func foot_effects()-> void:
		if owner.is_on_floor() and owner.velocity.length() >= 1:
			foot_particle.emitting = true
			foot_sound.pitch_scale = randf_range(0.5,2.0)
			foot_sound.play()
		else:
			foot_particle.emitting = false
