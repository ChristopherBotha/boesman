extends Node

signal update_enemies(val)
signal update_enemies_death(val)
signal update_player_health(health)
signal update_player_Maxhealth(health)
signal update_blood_meter(val)
signal trauma(val,timer)
signal healthbarVisible(val)

signal playerID(val)
#player changes
signal updatePlayerHealth(val)
signal updatePlayerMana(val)
signal healthUpdated(val)

#player upgrades / stats
signal updatePlayerMaxHealth(val)
signal updatePlayerDamage(val)
signal updatePlayerMaxMana(val)
#Game Machanics
signal updateExperience(val)
signal updateGold(val)
signal updateScore(val)
#world interaction
signal interact(val)
#Enemies
signal updateEnemiesDamage(val)
signal enemyCounter(val)

#moveplatform
signal movePlatform()
signal releaseVictim(val)

signal delayChange(val)
signal hitStop(val,time)
signal chainCollision(val)

signal exBarValue(val)
signal exTrue(val)

############debug
signal swordState(val)
signal speedUpdated(val)
signal sprintingUpdated(val)
signal swordSheathedUpdated(val)
signal playerStateName(val)
signal attackingUpdated(val)
signal exBarUpdated(val)

signal spawnEnemy(val)

signal attackLanded()
signal player_damaged()
signal comboTimeout()

#Player variables
signal comboRankCount(rank, combo_count)
signal enemyDied()
signal experienceGains(gains)
signal EXPgain(gainz)
signal playerLocation(playerLoc)
signal levelUp(level)

#player Selection
signal WaterSelected()
signal EarthSelected()
signal FireSelected()

#spawn particles
signal DamageNumber(amount, where)
signal spawnBlood(where)
signal gacha()
signal shockWave()
signal playerSelect()

#perks
signal increasedHealth()
signal increaseMana()
signal increaseDamage()
signal increasePhysical()
signal increaseMagical()

signal throw_spear()
signal catch_spear()
signal spear_returned()

signal Ocean(val)
signal spawn_ocean(val)
