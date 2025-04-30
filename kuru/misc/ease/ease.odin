package ease

import "core:math"

PI :: 3.1415926535897932384626

C1 :: 1.70158
C2 :: 2.5949095
C3 :: 2.70158
C4 :: 2.09439510239
C5 :: 1.3962634

inSine       :: proc(t: f32)    -> f32 { return 1 - math.cos((t * PI) / 2) }
outSine      :: proc(t: f32)    -> f32 { return math.sin((t * PI) / 2) }
inOutSine    :: proc(t: f32)    -> f32 { return -(math.cos(t * PI) - 1) / 2 }

inSquare     :: proc(t: f32)    -> f32 { return t * t }
outSquare    :: proc(t: f32)    -> f32 { return 1 - (1 - t) * (1 - t) }
inOutSquare  :: proc(t: f32)    -> f32 { return (t < .5)? ( 2 * t * t ) : ( 1 - math.pow(-2 * t + 2, 2) / 2 ) }

inCubic      :: proc(t: f32)    -> f32 { return t * t * t }
outCubic     :: proc(t: f32)    -> f32 { return 1 - math.pow(1 - t, 3) }
inOutCubic   :: proc(t: f32)    -> f32 { return (t < .5)? ( 4 * t * t * t ) : ( 1 - math.pow(-2 * t + 2, 3) / 2 ) }

inQuart      :: proc(t: f32)    -> f32 { return t * t * t * t }
outQuart     :: proc(t: f32)    -> f32 { return 1 - math.pow(1 - t, 4) }
inOutQuart   :: proc(t: f32)    -> f32 { return (t < .5)? ( 8 * t * t * t * t ) : ( 1 - math.pow(-2 * t + 2, 4) / 2 ) }

inQuint      :: proc(t: f32)    -> f32 { return t * t * t * t }
outQuint     :: proc(t: f32)    -> f32 { return 1 - math.pow(1 - t, 5) }
inOutQuint   :: proc(t: f32)    -> f32 { return (t < .5)? ( 16 * t * t * t * t ) : ( 1 - math.pow(-2 * t + 2, 5) / 2 ) }

inN          :: proc(n, t: f32) -> f32 { return math.pow(t, n) }
outN         :: proc(n, t: f32) -> f32 { return 1 - math.pow(1 - t, n) }
inOutN       :: proc(n, t: f32) -> f32 { return (t < .5)? ( math.pow(2, n-1) * math.pow(t, n) ) : ( 1 - math.pow(-2 * t + 2, n) / 2 ) }

inExpo       :: proc(t: f32)    -> f32 { return t == 0? 0 : ( math.pow(2, 10 * t - 10) ) }
outExpo      :: proc(t: f32)    -> f32 { return t == 1? 1 : ( 1 - math.pow(2, -10 * t) ) }
inOutExpo    :: proc(t: f32)    -> f32 { return t == 0? 0 : ( t == 1? 1 : ( (t < .5)? ( math.pow(2, 20 * t - 10) / 2 ) : ( (2 - math.pow(2, -20 * t + 10)) / 2 ) ) ) }

inCirc       :: proc(t: f32)    -> f32 { return 1 - math.sqrt(1 - math.pow(t, 2)) }
outCirc      :: proc(t: f32)    -> f32 { return math.sqrt(1 - math.pow(t, 2)) }
inOutCirc    :: proc(t: f32)    -> f32 { return (t < .5)? ( (1 - math.sqrt_f32(1 - math.pow(2 * t, 2))) / 2 ) : ( (math.sqrt_f32(1 - math.pow(-2 * t + 2, 2)) + 1) / 2 ) }

inBack       :: proc(t: f32)    -> f32 { return C3 * t * t * t - C1 * t * t }
outBack      :: proc(t: f32)    -> f32 { return 1 + C3 * math.pow(t - 1, 3) + C1 * math.pow(t - 1, 2) }
inOutBack    :: proc(t: f32)    -> f32 { return (t < .5)? ( (math.pow(2 * t, 2) * ((C2 + 1) * 2 * t - C2)) / 2 ) : ( (math.pow(2 * t - 2, 2) * ((C2 + 1) * (t * 2 - 2) + C2) + 2) / 2 ) }

inElastic    :: proc(t: f32)    -> f32 { return t == 0? 0 : ( t == 1? 1 : ( -math.pow(2, 10 * t - 10) * math.sin((t * 10 - 10.75) * C4) ) ) }
outElastic   :: proc(t: f32)    -> f32 { return t == 0? 0 : ( t == 1? 1 : ( math.pow(2, -10 * t) * math.sin((t * 10 - .75) * C4) + 1 ) ) }

