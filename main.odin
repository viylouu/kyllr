package main

import "core:fmt"
import "core:math"
import "core:math/rand"
import "core:math/linalg"
import "core:strings"
import "core:strconv"

import "kuru"
import d "kuru/drawing"
import inp "kuru/input"
import "kuru/misc/ease"

import rl "vendor:raylib"

vec2 :: [2]f32


/// ----   bullets   ---- ///
boolet :: struct {
    pos: vec2,
    dir: vec2
}; boolets: ^[dynamic]boolet

shoot_cooldown: f32 = 0.33
shoot_cooled:   f32 = 0


/// ----   enemies   ---- ///
enemyType :: enum {
    normal
}

enemy :: struct {
    type: enemyType,

    pos: vec2,
    tdir: vec2,

    tdir_cooldown: f32, // default 1
    tdir_cooled:   f32  // default 0
}; enemies: ^[dynamic]enemy

enemy_cooldown: f32 = 0.85
enemy_cooled:   f32 = 0


/// ----   money   ---- ///
munee :: struct {
    pos: vec2,
    amt: u32
}; munnees: ^[dynamic]munee


/// ----   player   ---- ///
pos: vec2


/// ----   timing   ---- ///
delta: f32

update_fps: f32    = 240
update_delta: f32  = 1/update_fps
update_cooled: f32 = 0


/// ----   rendering   ---- ///
ren_targ: rl.RenderTexture2D


main :: proc() { kuru.master("kyllr", 1280,720, init,tick,draw,quit) }

init :: proc() { 
    boolets = new([dynamic]boolet)
    enemies = new([dynamic]enemy)

    pos = vec2{320,180}

    ren_targ = rl.LoadRenderTexture(640,360)
}

tick :: proc() {
    delta = f32(rl.GetFrameTime())

    update_cooled += delta

    for update_cooled >= update_delta {
        update_player()

        update_enemies()

        update_bullets()

        update_cooled -= update_delta
    }
}

gun_pos: vec2

buf: [19]u8

draw :: proc() {
    rl.BeginTextureMode(ren_targ)
        rl.ClearBackground(rl.BLACK)

        d.fill(0,255,0)
        d.frect(pos.x-16,pos.y-16,32,32)

        d.fill(255,255,255)
        d.frect(gun_pos.x-4,gun_pos.y-4,8,8)

        /* boolets */ {
            d.fill(0,255,255)

            for i := 0; i < len(boolets); i += 1 { d.frect(boolets[i].pos.x-2,boolets[i].pos.y-2,4,4) }
        }

        /* enemies */ {
            d.fill(255,0,0)

            for i := 0; i < len(enemies); i += 1 { d.fcirc(enemies[i].pos.x-6,enemies[i].pos.y-6,12) }
        }

        rl.DrawText(strings.clone_to_cstring(strconv.append_int(buf[:], i64(len(enemies)), 10)), 0, 20, 20, rl.DARKGREEN)
        rl.DrawFPS(0,0)
    rl.EndTextureMode()

    rl.DrawTexturePro(ren_targ.texture, rl.Rectangle{0,360,640,-360}, rl.Rectangle{0,0,1280,720}, rl.Vector2{0,0}, 0, rl.WHITE)
}

quit :: proc() {
    free(boolets)
    free(enemies)
    free(munnees)

    rl.UnloadRenderTexture(ren_targ)
}


update_player :: proc() {
    /* movement */ {
        spd :f32: 128

        if inp.is_key_down(rl.KeyboardKey.W) { pos.y -= spd * update_delta }
        if inp.is_key_down(rl.KeyboardKey.S) { pos.y += spd * update_delta }
        if inp.is_key_down(rl.KeyboardKey.A) { pos.x -= spd * update_delta }
        if inp.is_key_down(rl.KeyboardKey.D) { pos.x += spd * update_delta }
    }

    /* weapon */ {
        mx,my := inp.mouse_x/2, inp.mouse_y/2

        gun_pos = pos + 48* linalg.vector_normalize(vec2{mx,my}-pos)\

        shoot_cooled += update_delta

        if inp.is_mouse_down(rl.MouseButton.LEFT) && shoot_cooled >= shoot_cooldown {
            append(boolets, boolet{
                pos = gun_pos,
                dir = (gun_pos-pos) /48
            })

            shoot_cooled = 0
        }
    }
}

update_bullets :: proc() {
    for i := 0; i < len(boolets); i += 1 {
        blt := &boolets[i]

        blt.pos += blt.dir * 512 * update_delta

        if blt.pos.x < 0 || blt.pos.x > 1280 || blt.pos.y < 0 || blt.pos.y > 720 {
            ordered_remove(boolets, i)
            i -= 1
        }
    }
}

update_enemies :: proc() {
    /* spawning */ {
        enemy_cooled += update_delta
       
        if enemy_cooled >= enemy_cooldown {
            append(enemies, enemy{
                type = enemyType.normal,
                pos = vec2 { rand.float32_range(0,1280), f32(rand.int31_max(2)*868-64) },
                tdir_cooldown = 1.5,
                tdir_cooled   = rand.float32_range(.5,1)
            })
            enemy_cooled = 0
        }
    }

    i := 0
    was_hit: b8

    for i < len(enemies) {
        enm := &enemies[i]

        enm.tdir_cooled += update_delta

        if enm.tdir_cooled >= enm.tdir_cooldown {
            enm.tdir_cooled = 0
            enm.tdir = linalg.vector_normalize(pos-enm.pos)
        }

        enm.pos += enm.tdir * (1 - ease.outBack(enm.tdir_cooled/1.5)) * 256 * update_delta

        for j := 0; j < len(enemies); j += 1 {
            if j == i { continue }
            
            oth := &enemies[j]
            if linalg.distance(enm.pos,oth.pos) < 24 {
                dirb := linalg.vector_normalize(oth.pos-enm.pos)
                oth.pos = enm.pos + dirb * 24
            }
        }

        was_hit = false
        for j := 0; j < len(boolets); j += 1 {
            if linalg.distance(enm.pos,boolets[j].pos) < 16 {
                unordered_remove(enemies,i)
                unordered_remove(boolets,j)
                was_hit = true
                break
            }
        }

        if !was_hit {
            i += 1
        }
    }
}
