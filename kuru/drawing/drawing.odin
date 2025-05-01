package drawing

import rl "vendor:raylib"
import sdl "vendor:sdl2"

rend: ^sdl.Renderer

cur_col: rl.Color

clear :: proc(r,g,b: u8) {
    rl.ClearBackground(rl.Color{r,g,b,1})
}

fill :: proc(r,g,b: u8, a: u8 = 255) {
    cur_col = rl.Color{r,g,b,a}
}

point :: proc(x,y: i32) {
    rl.DrawPixel(x,y,cur_col)
}
fpoint :: proc(x,y: f32) {
    rl.DrawPixel(i32(x),i32(y),cur_col)
}

rect :: proc(x,y,w,h: i32) {
    rl.DrawRectangle(x,y,w,h,cur_col)
} 
frect :: proc(x,y,w,h: f32) {
    rl.DrawRectangle(i32(x),i32(y),i32(w),i32(h),cur_col)
}

circ :: proc(x,y,r: i32) {
    rl.DrawCircle(x,y,f32(r),cur_col)
}
fcirc :: proc(x,y,r: f32) {
    rl.DrawCircle(i32(x),i32(y),r,cur_col)
}


iimage :: proc(tex: rl.Texture2D, x,y,w,h: i32) {
    rl.DrawTexturePro(
        tex,
        rl.Rectangle{0,0,f32(tex.width),f32(tex.height)},
        rl.Rectangle{f32(x),f32(y),f32(w),f32(h)},
        rl.Vector2{}, 0, cur_col
    )
}
image :: proc(tex: rl.Texture2D, x,y,w,h: f32) {
    rl.DrawTexturePro(
        tex,
        rl.Rectangle{0,0,f32(tex.width),f32(tex.height)},
        rl.Rectangle{x,y,w,h},
        rl.Vector2{}, 0, cur_col
    )
}

iimage_sd :: proc(tex: rl.Texture2D, sx,sy,sw,sh, dx,dy,dw,dh: i32) {
    rl.DrawTexturePro(
        tex,
        rl.Rectangle{f32(sx),f32(sy),f32(sw),f32(sh)},
        rl.Rectangle{f32(dx),f32(dy),f32(dw),f32(dh)},
        rl.Vector2{}, 0, cur_col
    )
}
image_sd :: proc(tex: rl.Texture2D, sx,sy,sw,sh, dx,dy,dw,dh: f32) {
    rl.DrawTexturePro(
        tex,
        rl.Rectangle{sx,sy,sw,sh},
        rl.Rectangle{dx,dy,dw,dh},
        rl.Vector2{}, 0, cur_col
    )
}

rento_rentex :: proc(tex: rl.RenderTexture2D, render: proc()) {
    rl.BeginTextureMode(tex)
        render()
    rl.EndTextureMode()
}
