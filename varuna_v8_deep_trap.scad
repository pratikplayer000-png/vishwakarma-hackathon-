// =====================================================================
//  VARUNA - Prototype v8 (OpenSCAD)  "Deep trap basket + slide entrance"
//
//  CHANGES IN THIS VERSION
//   1) DEEPER BASKET: 150 mm deep (was 105), floor 20 mm below the keel,
//      about 12 L of storage.
//   2) STEEPER "SLIDE" ENTRANCE: ramp tilt 30 deg (was 20), smooth sloped
//      floor with side walls that follow the slope.
//   3) NO-ESCAPE MECHANISM (trash cannot flow back out):
//        a) DOUBLE one-way flap gate, 4 flap fingers each, hinged at the top
//        b) STOP RODS in front of the flaps - they open inward only
//        c) FISH-TRAP NECK: angled baffles narrow the inside of the basket
//        d) FINER MESH on sides, floor and rear (use 3-5 mm mesh when building)
//        e) Hatch with two latches
//   4) SENSOR POD: the four probes sit in fixed positions on a holder plate
//      inside a slatted guard box (protects them from trash, water flows
//      through). The sensor interface box sits behind it on the deck.
//
//  Axes: X = length (front = 0, rear = +X) | Y = width | Z = up (keel = 0)
//  Units: mm
// =====================================================================

$fn = 36;

// ---------------- FLOATS ----------------------------------------------
float_d    = 180;                 // float diameter (sheet: 18 cm)
float_r    = float_d/2;
float_cy   = 185;                 // float centre-line offset -> width 550, spacing 370
fl_x0      = 200;                 // float bow
fl_x1      = 1000;                // float stern  (overall length 1000 from funnel tip)
nose_len   = 170;                 // length of the pointed bow
tail_len   = 220;                 // length of the tapered stern
wl         = 120;                 // waterline height above keel (sheet: 12 cm draft)

// ---------------- TILTED TUNNEL ---------------------------------------
tilt       = 30;                  // slide slope (deg)  <-- steeper entrance
lip_x      = 220;                 // front lip of the ramp
lip_z      = wl - 15;             // lip sits 15 mm under the surface
ramp_x     = 190;                 // horizontal length of the ramp
tunnel_hw  = 87;                  // half-width of the tunnel channel
tip_x      = 0;                   // funnel wing tips (front-most point)
tip_y      = 250;                 // funnel mouth half-width (500 mm mouth)

// ---------------- BASKET ----------------------------------------------
bx0        = lip_x + ramp_x;      // basket starts where the ramp ends
bz0        = -20;                 // basket floor: 20 mm BELOW the keel (deeper)
bk_len     = 480;                 // "extended length" basket
bk_w       = 170;
bk_h       = 150;                 // deeper basket, top still at z = 130
taper_len  = 150;                 // fairing at the rear
taper_rise = 70;

// one-way gates (anti-escape)
flap_n     = 4;                   // flap fingers per gate
gate2_dx   = 95;                  // second gate sits this far behind the first
neck_w     = 100;                 // width of the fish-trap neck

// ---------------- DECK / FRAME ----------------------------------------
deck_z     = float_d;             // frame sits on top of the floats (z = 180..205)
cross_x    = [215, 290, 400, 495, 640, 700, 760, 940, 975];
wheel_x    = 700;

// ---------------- PADDLE WHEELS (same idea as before) ------------------
axle_z     = 165;
paddle_r   = 75;
ww         = 70;
wheel_yc   = 320;                 // wheel centre distance from centre line

// ---------------- ELECTRONICS / SOLAR / CAMERA -------------------------
enc_x = 500;  enc_l = 140;  enc_w = 120;
cam_x = 290;  mast_h = 110;
sensor_x = 940;                   // sensor pod position (behind the basket)

show_water      = true;
show_stern_fan  = false;          // optional centre fan (would sit next to the sensors)
detail_mesh     = true;           // false = coarser mesh, faster preview

// ---------------- COLOURS ---------------------------------------------
c_float  = "RoyalBlue";   c_cap   = "White";      c_strap = "Black";
c_frame  = "Silver";      c_wing  = "DodgerBlue"; c_wall  = "CornflowerBlue";
c_ramp   = [0.45,0.80,1.00,0.85];
c_flap   = [1.00,0.75,0.10,0.55];
c_mesh   = "DimGray";     c_rim   = "DarkOrange"; c_hatch = "Orange";
c_cell   = "MidnightBlue"; c_sgrid = "LightSteelBlue";
c_lid    = [0.75,0.88,1.0,0.35];
c_batt   = "RoyalBlue";   c_driver= "MediumPurple"; c_esp = "DarkGreen"; c_buck = "DeepSkyBlue";
c_paddle = "Black";       c_hub   = "DimGray";    c_gear  = "Silver";   c_motor = "DimGray";
c_water  = [0.35,0.62,0.9,0.35];
c_stop   = "Red";         c_baffle= "Gold";       c_pod   = "Teal";     c_plate = "DarkOrange";

// ---------------- HELPERS ---------------------------------------------
module bar(p, s) { translate(p) cube(s); }

// ---------------- 1. FLOATS (fusiform) --------------------------------
module float_body() {
    hull() {
        translate([fl_x0+nose_len, 0, float_r]) scale([nose_len/float_r,1,1]) sphere(r=float_r, $fn=56);
        translate([fl_x1-tail_len, 0, float_r]) scale([tail_len/float_r,1,1]) sphere(r=float_r, $fn=56);
    }
}
module floats() {
    for (s=[-1,1]) translate([0, s*float_cy, 0]) {
        color(c_float) intersection() { float_body(); translate([fl_x0+110,-200,-1]) cube([fl_x1-fl_x0-220,400,400]); }
        color(c_cap)   intersection() { float_body(); translate([fl_x0-1,-200,-1]) cube([111,400,400]); }
        color(c_cap)   intersection() { float_body(); translate([fl_x1-110,-200,-1]) cube([111,400,400]); }
        // straps under the cross members (cylindrical middle section only)
        color(c_strap) for (x=[400,640,760])
            translate([x-12,0,float_r]) rotate([0,90,0])
                difference() { cylinder(d=float_d+10, h=24); translate([0,0,-1]) cylinder(d=float_d-2, h=26); }
        // VARUNA label on the outer side
        color("White") translate([560, s*(float_cy+float_r)+s*0.6, float_r])
            mirror([s>0?1:0,0,0]) rotate([90,0,0]) linear_extrude(1.2)
                text("VARUNA", size=26, halign="center", valign="center", font="Liberation Sans:style=Bold");
    }
}

// ---------------- 2. FRAME (above water) -------------------------------
module frame() {
    color(c_frame) {
        for (s=[-1,1]) bar([215, s*float_cy-15, deck_z], [765, 30, 25]);              // side rails
        for (x=cross_x) { xl = (x==wheel_x) ? 300 : 275; bar([x-10, -xl, deck_z], [20, 2*xl, 25]); }
        // basket hangers (from the cross members down to the basket rim)
        for (x=[495,760], s=[-1,1]) bar([x-3, s*bk_w/2-3, bz0+bk_h], [6,6,deck_z-(bz0+bk_h)]);
        if (show_stern_fan) bar([990,-10,deck_z],[80,20,25]);
    }
}

// ---------------- 3. TILTED TUNNEL ------------------------------------
module funnel_wings() {
    color(c_wing)
    for (s=[-1,1])
        hull() {                                    // thin swept plate, low at the tip
            translate([tip_x, s*tip_y, wl-28]) cylinder(r=2.5, h=56, $fn=16);
            translate([lip_x, s*tunnel_hw, 70]) cylinder(r=2.5, h=112, $fn=16);
        }
}
module tunnel() {
    // side walls: lower edge follows the slide, so nothing hangs below the ramp
    color(c_wall) for (s=[-1,1]) translate([lip_x, s*tunnel_hw+2.5, 0]) rotate([90,0,0]) linear_extrude(5)
        polygon([[0,182],[0,lip_z-4],[ramp_x,lip_z-ramp_x*tan(tilt)-4],[ramp_x,182]]);
    // inclined slide
    color(c_ramp) translate([lip_x,0,lip_z]) rotate([0,tilt,0])
        translate([0,-tunnel_hw,-4]) cube([ramp_x/cos(tilt), 2*tunnel_hw, 4]);
    // rounded entry lip
    color(c_wing) translate([lip_x-3,0,lip_z-2]) rotate([90,0,0]) cylinder(d=8, h=2*tunnel_hw, center=true);
    // anti-escape mechanism
    one_way_gate(bx0, 133);                       // gate 1 (at the end of the slide)
    one_way_gate(bx0 + gate2_dx, bk_h - 6);       // gate 2 (reaches the basket floor)
    neck_baffle();
}

// hinged flap fingers + hinge rod + stop rod (flaps open INWARD only)
module one_way_gate(xh, fh) {
    fw = (bk_w - 6) / flap_n;
    ztop = bz0 + bk_h;
    color("Gray") translate([xh,0,ztop]) rotate([90,0,0]) cylinder(d=4, h=bk_w, center=true);
    color(c_flap) for (k=[0:flap_n-1])
        translate([xh, -bk_w/2 + 3 + k*fw + 1, ztop]) rotate([0,-8,0]) translate([-1.5,0,-fh]) cube([3, fw-2, fh]);
    color(c_stop) translate([xh-6, 0, ztop-40]) rotate([90,0,0]) cylinder(d=3, h=bk_w, center=true);
}

// fish-trap neck: angled baffles narrow the way back out
module neck_baffle() {
    color(c_baffle) for (s=[-1,1])
        translate([0,0,bz0+4]) linear_extrude(bk_h-8)
            polygon([[bx0+gate2_dx+10, s*(bk_w/2-1)], [bx0+gate2_dx+75, s*neck_w/2],
                     [bx0+gate2_dx+75, s*neck_w/2+s*3], [bx0+gate2_dx+10, s*(bk_w/2+2)]]);
}

// ---------------- 4. BASKET (mesh, faired) ----------------------------
function zlow(x) = x > bk_len-taper_len ? (x-(bk_len-taper_len))*taper_rise/taper_len : 0;
function xend(z) = z < taper_rise ? (bk_len-taper_len) + z*taper_len/taper_rise : bk_len;

module basket() {
    bt = 2.4;  bp = detail_mesh ? 16 : 30;
    translate([bx0,0,bz0]) {
        color(c_mesh) {
            for (s=[-1,1]) {
                for (x=[0:bp:bk_len]) translate([x-bt/2, s*bk_w/2-bt/2, zlow(x)]) cube([bt,bt,bk_h-zlow(x)]);
                for (z=[0:bp:bk_h])   translate([0, s*bk_w/2-bt/2, z]) cube([xend(z),bt,bt]);
                translate([bk_len-bt, s*bk_w/2-bt/2, taper_rise]) cube([bt,bt,bk_h-taper_rise]);   // rear corners
            }
            for (y=[-bk_w/2+bp/2:bp:bk_w/2-1]) {                                                    // floor + sloped tail
                translate([0,y-bt/2,0]) cube([bk_len-taper_len,bt,bt]);
                hull() { translate([bk_len-taper_len,y-bt/2,0]) cube([bt,bt,bt]);
                         translate([bk_len-bt,y-bt/2,taper_rise]) cube([bt,bt,bt]); }
            }
            for (x=[0:bp:bk_len]) translate([x-bt/2,-bk_w/2,zlow(x)]) cube([bt,bk_w,bt]);
            for (z=[taper_rise:bp:bk_h]) translate([bk_len-bt,-bk_w/2,z]) cube([bt,bk_w,bt]);       // rear wall
            for (y=[-bk_w/2+bp/2:bp:bk_w/2-1]) translate([bk_len-bt,y-bt/2,taper_rise]) cube([bt,bt,bk_h-taper_rise]);
        }
        color(c_rim) {
            for (s=[-1,1]) translate([0, s*bk_w/2-3, bk_h-6]) cube([bk_len,6,6]);
            translate([bk_len-6,-bk_w/2-3,bk_h-6]) cube([6,bk_w+6,6]);
            translate([0,-bk_w/2-3,bk_h-6]) cube([6,bk_w+6,6]);
        }
        // removable hatch at the rear (easy cleaning) with handle
        color(c_hatch) translate([bk_len-110,-bk_w/2-4,bk_h]) cube([100,bk_w+8,3]);
        color("DimGray") translate([bk_len-70,-20,bk_h+3]) cube([20,40,8]);
        color("Red") for (s=[-1,1]) translate([bk_len-112,s*(bk_w/2+2)-4,bk_h-4]) cube([6,8,10]);   // latches
    }
}

// ---------------- 5. SOLAR PANELS + ELECTRONICS -----------------------
module solar_panel(x0, l, w) {
    translate([x0,-w/2,deck_z+25]) {
        color("Silver") difference() { cube([l,w,12]); translate([6,6,2]) cube([l-12,w-12,12]); }
        color(c_cell) translate([6,6,5]) cube([l-12,w-12,5]);
        color(c_sgrid) {
            for (i=[1:3]) translate([6+i*(l-12)/4-0.7,6,10]) cube([1.4,w-12,0.6]);
            for (j=[1:7]) translate([6,6+j*(w-12)/8-0.7,10]) cube([l-12,1.4,0.6]);
        }
    }
}
module enclosure() {
    translate([enc_x,-enc_w/2,deck_z+25]) {
        color("WhiteSmoke") cube([enc_l,enc_w,20]);
        color(c_lid) translate([0,0,20]) cube([enc_l,enc_w,50]);
        color("White") for (i=[0:2]) translate([-10,22+i*38,10]) rotate([0,90,0]) cylinder(d=14,h=12);   // cable glands
        color(c_batt)   translate([10,10,20]) cube([70,40,26]);                                          // battery
        color(c_driver) translate([92,8,20])  cube([42,40,10]);                                          // driver 1
        color(c_driver) translate([92,62,20]) cube([42,40,10]);                                          // driver 2
        color(c_esp)    translate([10,64,20]) cube([54,32,3]);                                           // ESP32
        color("Black")  translate([16,70,23]) cube([24,18,3]);
        color(c_buck)   translate([70,64,20]) cube([18,28,8]);                                           // buck converter
        color("White")  translate([enc_l/2,enc_w/2,70]) linear_extrude(0.6)
            text("VARUNA", size=11, halign="center", valign="center", font="Liberation Sans:style=Bold");
    }
}
module camera() {
    z0 = deck_z + 25;
    color(c_frame) { translate([cam_x,0,z0]) cylinder(d=14,h=mast_h); translate([cam_x-22,-22,z0]) cube([44,44,4]); }
    color("Black") translate([cam_x-12,-22,z0+mast_h]) cube([24,44,28]);                                // ESP32-CAM
    color("Crimson") translate([cam_x-18,0,z0+mast_h+14]) rotate([0,90,0]) cylinder(d=15,h=7);
    color("White")   translate([cam_x-19,0,z0+mast_h+14]) rotate([0,90,0]) cylinder(d=7,h=2);
}

// ---------------- 6. WATER-QUALITY SENSOR POD -------------------------
probe_y = [-66,-22,22,66];                       // fixed probe positions on the holder plate

module sensor_rack() {
    z0 = deck_z + 25;  x = sensor_x;
    color("DimGray") for (y=probe_y) translate([x-9,y-9,z0]) cube([18,18,10]);          // collars

    // 1) water temperature - DS18B20 stainless probe
    color("Silver") translate([x,probe_y[0],75]) cylinder(d=6,h=z0-75);
    color("Silver") translate([x,probe_y[0],75]) sphere(d=6);
    color("Black")  translate([x,probe_y[0],z0-12]) cylinder(d=10,h=12);
    color("Red")    translate([x,probe_y[0],z0+10]) cylinder(d=3,h=30);

    // 2) pH electrode (BNC) with glass bulb
    color("Gold")      translate([x,probe_y[1],85]) cylinder(d=12,h=z0+35-85);
    color("LightCyan") translate([x,probe_y[1],72]) cylinder(d=10,h=13);
    color("LightCyan") translate([x,probe_y[1],72]) sphere(d=10);
    color("Silver")    translate([x,probe_y[1],z0+35]) cylinder(d=9,h=14);

    // 3) TDS probe - body + two stainless pins
    color("DimGray") translate([x,probe_y[2],95]) cylinder(d=14,h=z0+10-95);
    color("Silver")  for (dx=[-3.5,3.5]) translate([x+dx,probe_y[2],62]) cylinder(d=2.2,h=34);
    color("Black")   translate([x,probe_y[2],z0+10]) cylinder(d=8,h=22);

    // 4) turbidity sensor - optical head with a U-gap
    color("Black") translate([x,probe_y[3],110]) cylinder(d=10,h=z0+10-110);
    color("WhiteSmoke") translate([x-19,probe_y[3]-11,52]) difference() {
        cube([38,22,58]);
        translate([13,-1,10]) cube([12,24,26]);
    }
    color("Black") translate([x-6,probe_y[3]-10.5,62]) cube([12,0.8,10]);
}

// slatted guard box: protects the probes from trash, water flows straight through
module sensor_pod() {
    px0 = sensor_x - 40;  pl = 80;  pw = 190;  zb = 40;  zt = deck_z;
    color(c_pod) {
        for (x=[px0, px0+pl-4], y=[-pw/2, pw/2-4]) translate([x,y,zb]) cube([4,4,zt-zb]);          // corner posts
        for (z=[zb, zb+55, zt-4]) {                                                                 // rings
            for (y=[-pw/2, pw/2-4]) translate([px0,y,z]) cube([pl,4,4]);
            for (x=[px0, px0+pl-4]) translate([x,-pw/2,z]) cube([4,pw,4]);
        }
        for (y=[-pw/2+22:22:pw/2-22], x=[px0, px0+pl-3]) translate([x,y-1.5,zb]) cube([3,3,zt-zb]);  // front/back slats
        for (x=[px0+20:20:px0+pl-20], y=[-pw/2, pw/2-3]) translate([x-1.5,y,zb]) cube([3,3,zt-zb]);  // side slats
        for (x=[px0+25, px0+pl-29]) translate([x,-pw/2,zb]) cube([4,pw,4]);                         // open bottom grid
    }
    // holder plate that fixes the probe positions
    color(c_plate) translate([px0,-pw/2,zt-16]) difference() {
        cube([pl,pw,5]);
        for (y=probe_y) translate([pl/2,pw/2+y,-1]) cylinder(d=15,h=7);
    }
}
module sensor_box() {
    translate([952,-45,deck_z+25]) {
        color("WhiteSmoke") cube([60,90,14]);
        color(c_lid) translate([0,0,14]) cube([60,90,28]);
        color("RoyalBlue") translate([6,6,14])  cube([24,26,3]);      // pH board
        color(c_esp)       translate([6,40,14]) cube([24,26,3]);      // TDS board
        color("Tomato")    translate([32,6,14]) cube([24,26,3]);      // turbidity board
        color("Gold")      translate([32,40,14]) cube([24,26,3]);     // DS18B20 adapter
    }
}

// ---------------- 7. SIDE PADDLE WHEELS (left + right) -----------------
module paddle() {
    color(c_hub) {
        rotate([90,0,0]) cylinder(d=44, h=ww, center=true);
        for (y=[-ww/2, ww/2]) translate([0,y,0]) rotate([90,0,0]) cylinder(d=54, h=4, center=true);
    }
    color(c_paddle) for (a=[0:45:315])
        rotate([0,a,0]) rotate([0,18,0]) translate([-2,-ww/2,22]) cube([4,ww,paddle_r-22]);
}
module side_wheels() {
    outer = wheel_yc + ww/2 + 35;
    for (s=[-1,1]) {
        color(c_frame) {
            for (dx=[-85,85]) bar([wheel_x+dx-10, s>0 ? float_cy : -outer, deck_z], [20, outer-float_cy, 25]);   // arms
            bar([wheel_x-95, s>0 ? outer-10 : -outer-10, deck_z], [190,20,25]);                                 // tie bar
        }
        color(c_gear)  translate([wheel_x-17, s>0 ? 275 : -293, axle_z-20]) cube([34,18,40]);                    // inner bearing
        color(c_gear)  translate([wheel_x, s>0 ? 283 : -(outer+30), axle_z]) rotate([-90,0,0]) cylinder(d=12, h=outer+30-283);
        color(c_gear)  translate([wheel_x-17, s>0 ? outer : -(outer+34), axle_z-17]) cube([34,34,34]);           // gearbox
        color(c_motor) translate([wheel_x+17, s*(outer+17), axle_z]) rotate([0,90,0]) cylinder(d=34, h=55);     // motor
        translate([wheel_x, s*wheel_yc, axle_z]) paddle();
    }
}
module stern_fan() {
    color(c_gear)  translate([1010,-17,deck_z-10]) cube([34,34,34]);
    color(c_motor) translate([1027,17,deck_z+7]) rotate([-90,0,0]) cylinder(d=34,h=55);
    translate([1062,0,deck_z+7]) {
        color("White") { rotate([0,90,0]) cylinder(d=24,h=24,center=true);
            for (a=[0:45:315]) rotate([a,0,0]) rotate([0,0,32]) translate([-1.5,-13,10]) cube([3,26,55]); }
    }
}

module water() { color(c_water) translate([-400,-650,wl-2]) cube([1900,1300,2]); }

// ---------------- ASSEMBLY --------------------------------------------
floats();
frame();
funnel_wings();
tunnel();
basket();
solar_panel(305, 185, 390);
solar_panel(645, 115, 390);
enclosure();
camera();
sensor_rack();
sensor_pod();
sensor_box();
side_wheels();
if (show_stern_fan) stern_fan();
if (show_water) water();

// ---------------- QUICK CHECKS (see Console) --------------------------
function vsum(v, i=0) = i >= len(v) ? 0 : v[i] + vsum(v, i+1);
function fl_r(x) = let(xr = x-fl_x0, Lf = fl_x1-fl_x0)
    xr < nose_len ? float_r*sqrt(max(0, 1-pow((nose_len-xr)/nose_len,2)))
  : xr > Lf-tail_len ? float_r*sqrt(max(0, 1-pow((xr-(Lf-tail_len))/tail_len,2)))
  : float_r;
function seg_area(r, h) = let(hh = max(0, min(h, 2*r)))
    r <= 0 ? 0 : r*r*(acos((r-hh)/r)*PI/180) - (r-hh)*sqrt(max(0, 2*r*hh-hh*hh));
buoy_kg = 2 * vsum([for (x=[fl_x0:5:fl_x1]) seg_area(fl_r(x), wl-(float_r-fl_r(x)))]) * 5 / 1e6;
echo("Basket volume (approx)       =", bk_len*bk_w*bk_h/1e6, "L");
echo("Float width (hull)            =", 2*float_cy + float_d, "mm");
echo("Width incl. paddle wheels      =", 2*(wheel_yc + ww/2 + 35 + 34), "mm");
echo("Tunnel slope / ramp end height =", tilt, "deg /", lip_z - ramp_x*tan(tilt), "mm");
echo("Buoyancy at the waterline      =", buoy_kg, "kg (total boat weight must stay below this)");
