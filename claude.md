### Game details
Create a 2d pixelart GMS2 action Roguelike dungeon crawler game where you traverse procedurally generated dungeons. Each floor of the dungeon has a ladder/stairs which take you deeper. Each floor is filled with enemies. As you go deeper the enemies get harder and every ten levels you fight a boss. There are 50 levels in total meaning there are 5 main bosses.

The player can select between 3 different classes for now: Warrior, Archer, Assassin. Each class has a basic attack (left mouse click to attack), a starting utility skill, a starting movement ability, starting damage ability and a starting ultimate ability and a starting class buff/trait. There will be abilities/buffs obtainable during the run which can replace the starting ability but for now just create the starting abilities.

Warrior (sword and shield): 
Basic attack (left click) - thrust sword (1x weapon damage)
Movement abiltity (space) - a short shuffle
Utility (right click) - Raise shield (blocks all incoming projectiles and greatly reduces damage taken while active)
Damage ability (e) - Charges up for up to 3 seconds, release to attack. Does 1x weapon damage base, each half second of charge adds 1x weapon damage and increases aoe radius
Ultimate ability (q) - Takes out a giant 2h sword for 10 seconds (huge damage increase, left click becomes a large swing and right click instead becomes a riposte (if attacked while right click is held, take no damage and instantly swing back doing large damage))
Unique Trait - All damage taken is reduced

Assassin daggers:
Basic attack (left click) - daggers both stab (1x weapon damage per dagger) - counts as two attacks for procs
movement ability (space) - goes invisible for 4 seconds with high movespeed buff during duration. Attacking before the duration finishes ends it early but the resulting attack always crits.
Damage ability (e) - flurry - stab 3 times with each dagger (6 times total), each stab has an increasing change to land a crit (counts as 6 attacks for procs and other mechanics)
Utility - Throws a smoke bomb down for 4 seconds. Cannot be hit in smoke bomb
Ultimate ability (q) - A single attack which teleports behind to the enemy closest to cursor, hitting 20 times at once
Unique Trait - Crits do 3x damage (instead of 2x)


Archer (bow):

Basic attack (left click) - short delay and then fires an arrow in a straight line
movement ability - dodges in a direction, next arrow pins the target in place for two seconds
damage ability - Charges in place for up to 3 seconds. Starts with 1x weapon damage. Each half second of charge increases the distance of the arrow, the damage of the arrow and the hitbox width - pierces all enemies
ultimate - Enchanted quiver - For 10 seconds, all arrows count as maximum distance
Unique Trait - Damage increases with projectile travel distance


### Bosses
Boss enemies are fought every 10 levels. Boss rooms are spacious rooms with a boss in the middle. Bosses are tough, having multiple mechanics and phases. Happy for you to use the same bosses you used in the recent 'companion dungeon crawler' game we worked on.


### Mobs
Regular enemies (mobs) should be numerous and dangerous, however, much like bosses players should be able to dodge their attacks.