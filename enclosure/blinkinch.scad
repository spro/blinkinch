wall = 1.5; // Decent thickness
inch = 25.4;
corner_r = 2;
outr = 2;
inr = 1.3;
epsilon = 0.001;

notch_w = 3;
notch_neck_h = 1;
notch_head_h = 1;
notch_t = 0.7;
notch_in = wall/2;

usb_h = 10.9;
usb_w = 12.05;

pcb_t = 1.6;
lead_t = 1.5;

board_offset = wall+corner_r/2;
board_w = in2mm(0.98);
board_l = in2mm(0.94);

$fn=16;

h = wall + pcb_t + lead_t + usb_h;
l = h * 2;
w = h * 2;

function mm2in(mm) = mm / inch;
function in2mm(in) = in * inch;

module round_cube(l, w, h, r=2) {
    hull() {
        for(x=[0+r, l-r]) {
            for(y=[0+r, w-r]) {
                for(z=[0+r, h-r]) {
                    translate([x, y, z])
                    sphere(r);
                }
            }
        }
    }
}

// Notches
module notch() {
    linear_extrude(height=notch_w) {
        // Neck
        polygon([
            [0, 0], [notch_t,-1], [notch_t,notch_neck_h], [0, notch_neck_h]
        ], [
            [0, 1, 2, 3]
        ]);
        translate([0, notch_neck_h, 0])
        // Head
        polygon([
            [0, 0], [notch_t+notch_in,0], [notch_t+notch_in/3,notch_head_h], [0, notch_head_h]
        ], [
            [0, 1, 2, 3]
        ]);
    }
}

module bottom_notches() {
    for(x=[l/4, l*3/4]) {
        translate([x+notch_w/2, wall+notch_t, h])
        rotate([90, 00, 270])
        notch();

        translate([x-notch_w/2, w-wall-notch_t, h])
        rotate([90, 00, 90])
        notch();
    }
}

module bottom() {
    difference() {
        // Full shell
        intersection() {
            difference() {
                round_cube(l, w, h*2, r=outr);
                translate([wall, wall, wall])
                round_cube(l-2*wall, w-2*wall, (h-wall)*2, r=inr);
            }
            // Intersect with bottom half
            cube([l, w, h]);
        }

        // USB Plug hole
        hole_z = wall + 3.10;
        translate([-1, board_offset + in2mm(0.35) - usb_w/2, hole_z])
        cube([usb_w, usb_w, usb_h+epsilon]);

        // Air holes
        /* for (ai=[2:9]) { */
        /*     translate([l-2*ai, -epsilon, wall]) */
        /*     cube([1, w+2*epsilon, h-2*wall]); */
        /* } */
    }

    bottom_notches();
}

module top() {
    translate([0, 0, 5]) {
        // Main shell
        difference() {
            intersection() {
                difference() {
                    round_cube(l, w, h*2, r=outr);
                    translate([wall, wall, wall])
                    round_cube(l-2*wall, w-2*wall, (h-wall)*2, r=inr);
                }
                // Top half
                translate([0, 0, h])
                cube([l, w, h]);
            }
            
            // Notch holes
            translate([l/4-notch_w/2, wall-notch_in, h+notch_neck_h])
            cube([notch_w, w-2*notch_in, notch_head_h]);
            translate([l*3/4-notch_w/2, wall-notch_in, h+notch_neck_h])
            cube([notch_w, w-2*notch_in, notch_head_h]);

            // Maia logo
            /* logo_w = w * 2/3; */
            /* translate([(w-logo_w)/2, (w-logo_w)/2, h*2-(wall-0.7)]) */
            /* linear_extrude(height=1+epsilon) resize([logo_w, logo_w]) import("/Users/sean/Desktop/20151116/lohgo.dxf"); */
        }
    }
}

module board() {
    translate([board_offset, board_offset, wall + lead_t])
    color([0.5, 0.9, 0.6])
    cube([board_w, board_l, pcb_t]);
}

bottom();
*board();
top();
