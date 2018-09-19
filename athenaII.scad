/************************************************************************************

athena.scad - structural and tool objects required to build an Athena delta platform
Copyright 2015 Jerry Anzalone
Author: Jerry Anzalone <info@phidiasllc.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

************************************************************************************/

// requires the common delta modules
include <simple_delta_common.scad>

/************  layer_height is important - set it to the intended print layer height  ************/
layer_height = 0.33; // layer height that the print will be produced with

// Bowden sheath dims
d_175_sheath = 4.8;
175_bowden = [d_M4_nut, h_M4_nut, d_175_sheath];
d_300_sheath = 6.55;
300_bowden = [d_M6_nut, h_M6_nut, d_300_sheath];

bowden = 175_bowden; // set to the diameter of the Bowden sheath desired, defined above

echo_dims = true; // set to true to echo pertinent dimensions - will repeat some

// [w, l, t] = [y, x, z]
$fn = 100;
pi = 3.1415926535897932384626433832795;

// bar clamp dims
t_bar_clamp = 8;
h_bar_clamp = 10;

// the following sets the spacing of the linking board mounts on motor/idler ends
cc_idler_mounts = 120; // c-c of mounts on idler end - large to maximize x-y translation when in fixed tool mode and minimizes material use for bases
cc_motor_mounts = 75; // c-c of mounts on idler end

// printer dims
r_printer = 175; // radius of the printer, distance from printer center to guide rod centers - typically 175
l_tie_rod = 250; // length of the tie rods - typically 250
l_guide_rods = 595; // length of the guide rods - only used for assembly

// belt, pulley and idler dims
idler = bearing_608;
w_belt = 6; // width of the belt (not used)
pulley_cogs = 16; // number of cogs on the pulley
belt = GT2; // the type of drive belt to be used
h_idler_washer = h_M8_washer; // idler bearing shaft washer
d_idler_shaft_head = d_M8_nut; // idler bearing shaft head diameter
h_idler_shaft_head = h_M8_nut; // idler bearing shaft head height - sets nut pocket depth

// the diameter of the pulley isn't the whole story - the belt rides on the pulley at it's root radius
// but on the idler bearing, it rides on the tips of the cogs, pushing its pitch radius outwards
od_idler = idler[0]; // idler OD
id_idler = idler[1]; // idler id
h_idler = h_608; // thickness of idler
n_idlers = 2; // number of idler bearings
d_pulley = pulley_cogs * belt[0] / pi - (belt[1] - belt[2]); // diameter of the pulley (used to center idler)
offset_idler = (od_idler - d_pulley) / 2 + belt[2]; // amount to offset idler bearing so belt stays parallel with guide rods

// guide rod and clamp dims
cc_guides = 60; // center-to-center of the guide rods
d_guides = 8.4; // diameter of the guide rods - a little big for clearance
pad_clamp = 8; // additional material around guide rods
gap_clamp = 2; // opening for clamp

// following for tabs on either side of clamp to which linking boards are attached
// the radius of the delta measured from the center of the guide rods to the center of the triangle
// as drawn here, the tangent is parallel to the x-axis and the guide rod centers lie on y=0
//cc_mount = 75; // center to center distance of linking board mount pivot points standard = 75
h_apex = 1.5 * 25.4; // height of the portion of motor and idler ends mating with linking board
w_mount = 12; // thickness of the tabs the boards making up the triangle sides will attach to
l_mount = 40; // length of said tabs
cc_mount_holes = 16;
l_base_mount = l_mount;
w_base_mount = 14.1;
t_base_mount = 9.0;
r_base_mount = 3;
l_mount_slot = 2; // length of the slot for mounting screw holes
d_base_mount = 5; // diameter of holes for mounting the hexagonal base to the motor ends

cc_v_board_mounts = 2 * (cc_guides / 2 - pad_clamp + d_M3_screw / 2); // c-c mounts for vertical boards

l_idler_relief = cc_guides - d_guides - pad_clamp - 1.5; // with guide rod clamp design, the length needs to be smaller so there are walls for bridging
w_idler_relief = n_idlers * h_idler + 2 * h_idler_washer;
r_idler_relief = 2; // radius of the relief inside the apex
l_clamp = cc_guides + d_guides + pad_clamp;
w_clamp = w_idler_relief + pad_clamp + 8;
h_clamp = l_NEMA17;
l_base_mount = 88; // added 3/1/18 GCA for the new mounting system
h_base_mount = 10; // added 3/1/18 GCA for the new mounting system

// magnetic ball joint dims
d_ball_bearing = 3 * 25.4 / 8;
id_magnet = 15 * 25.4 / 64;
od_magnet = 3 * 25.4 / 8 + 0.35;
h_magnet = 25.4 / 8;
r_bearing_seated = pow(pow(d_ball_bearing / 2, 2) - pow(id_magnet / 2, 2), 0.5); // depth ball bearing sinks into magnet id
h_carriage_magnet_mount = 9;
h_effector_magnet_mount = 10;
r_pad_carriage_magnet_mount = 2;
r_pad_effector_magnet_mount = 2;

// effector dims
// l_effector needs to be played with to keep the fan from hitting the tie rods
l_effector = 60; // cc of tie rod bearings on effector
h_effector = equilateral_height_from_base(l_effector);
r_effector = l_effector * tan(30) / 2 + 11; // radius of the magnet mounts
t_effector = 6; // thickness of the effector base
h_triangle_inner = h_effector + 12;
r_triangle_middle = equilateral_base_from_height(h_triangle_inner) * tan(30) / 2;

// for the small tool end effector:
d_small_effector_tool_mount = 30; // diameter of the opening in the end effector that the tool will pass through
d_small_effector_tool_magnet_mount = 1 + d_small_effector_tool_mount + od_magnet + 2 * r_pad_effector_magnet_mount; // ring diameter of the effector tool magnet mounts

// for the large tool end effector:
d_large_effector_tool_mount = 50;
d_large_effector_tool_magnet_mount = h_triangle_inner;

// Bowden sheath quick release fitting dims
d_quickrelease_threads = 6.4; // M6 threads, but this gives best fit
l_quickrelease_threads = 5; // length of threads on quick release
pitch_quickrelease_threads = 1;
d_quickrelease = 12; // diameter of the hex portion for counter-sinking quick release into hot end tool
countersink_quickrelease = 6; // depth to contersink quick release fitting into hot end tool when not headless

// hot end dims
pad_jhead = 8; // this is added to the diameter of the cage to permit clearance for the hotend
pad_e3d = 14;
t_hotend_cage = t_heat_x_jhead - h_groove_jhead - h_groove_offset_jhead;
d_hotend_side = d_large_jhead + pad_jhead;
z_offset_retainer = t_hotend_cage - t_effector / 2 - 3;  // need an additional 3mm to clear the interior of the cage
a_fan_mount = 15;
l_fan = 39.5;
r_flare = 6;
h_retainer_body = h_groove_jhead + h_groove_offset_jhead + 4;
r1_retainer_body = d_hotend_side / 2 + r_flare * 3 / t_hotend_cage;
r2_retainer_body = r1_retainer_body - r_flare * h_retainer_body / t_hotend_cage;
r2_opening = (d_hotend_side - 5 ) / 2 + r_flare * (t_hotend_cage - 6 - t_effector + 3.0) / (t_hotend_cage - 6);//r1_opening - r_flare * (t_effector + 1.5) / t_hotend_cage;
r1_opening = r2_opening - 1.5;
d_retainer_screw = d_M2_screw;

// carriage dims:
w_carriage_web = 4;
h_carriage = l_lm8uu + 4;
carriage_offset = 18.6; // distance from center of guide rods to center of ball mount pivot
y_web = - od_lm8uu / 2 - (3 - w_carriage_web / 2);
stage_mount_pad = 2.2;

// limit switch dims
l_limit_switch = 24;
w_limit_switch = 6;
t_limit_switch = 14;
cc_limit_mounts = 9.5;
limit_x_offset = 11; // 11 places limit switch at guide rod, otherwise center at cc_guides / 2 - 8
limit_y_offset = d_M3_screw - carriage_offset;

// center-to-center of tie rod pivots
tie_rod_angle = acos((r_printer - r_effector - carriage_offset) / l_tie_rod);

// tool mount member dims
w_member = 25.4; // narrow dimension of member
l_member = 3 * 25.4; // wide dimension of member

// aluminum member dims
l_vertical_board = 3 * 25.4; // long dimension of rectangular tube making vertical board
w_vertical_board = 25.4; // short dimention of rectangular tube making vertical board
l_linking_board = 38.6;
w_linking_board = 3 * 25.4 / 4;

// BBB dims; origin at corner w/ power jack, starting from hole nearest power jack, going counter clockwise
bbb_hole0 = [14.61, 3.18];
bbb_hole1 = [14.61 + 66.5, 6.35];
bbb_hole2 = [14.61 + 66.5, 6.35 + 42.6];
bbb_hole3 = [14.61, 3.18 + 48.39];
bbb_holes = [bbb_hole0, bbb_hole1, bbb_hole2, bbb_hole3];

// dimension from the base dxf
cc_idler_jig = 92.6467;

// spool holder to mount to vertical board
l_mount = 28;
w_mount = 24;
l_holder = 110;
w_holder = 20;
h_holder = 12;
d_pivot = 14;
h_pivot = 6;
d_retainer = 2.75;

l_bbl_opening = 15; // length of barrel connector panel opening
w_bbl_opening = 11.5; // width of barrel connector panel opening
t_bbl_mount = 2; // thickness of the barrel connector mounting plate
t_bbl_panel = 1.75; // thickness of the barrel connector panel (groove in barrel jack)
l_bbl_body = l_bbl_opening + 2; // length of connector body
w_bbl_body = w_bbl_opening + 2; // width of connector body
h_bbl_case = 18; // height of the barrel connector case

h_plate = 12 + t_bbl_panel; // tall enough for hooking into 12mm plywood

l_rj45_housing = 36.5;
w_rj45_housing = 22;
w_rj45_jack = 14;
l_rj45_jack = 16.5;
top_offset_rj45_jack = 6;
cc_rj45_mounts = 27.5;

l_usb_housing = 38;
w_usb_housing = 13;
cc_usb_mounts = 28;
l_usb_opening = 17;
w_usb_opening = 9;
r_plate_corners = 10;
l_plate = 102; //l_rj45_housing + l_usb_housing + w_bbl_opening + 12;
w_plate = 24; //w_rj45_housing + 2;

if (echo_dims) {
	echo(str("Printer radius = ", r_printer));
	echo(str("Effector offset = ", r_effector, "mm"));
	echo(str("Carriage offset = ", carriage_offset, "mm"));
	echo(str("Printer effective radius = ", r_printer - r_effector - carriage_offset));
	echo(str("Radius of base plate = ", ceil(r_printer - d_guides / 2 - 1), "mm"));
	echo(str("Tie rod angle at (0, 0, 0) = ", tie_rod_angle));
	echo(str("Effector tie rod c-c = ", l_effector, " mm"));
	echo(str("Vertical board mount c-c = ", cc_v_board_mounts));
	echo(str("Vertical board offset = ", 8 - h_clamp / 2 + 3));
	echo(str("Offset_idler = ", offset_idler));
    echo(str("Clamp height = ",  h_clamp));
    echo(str("Guide rod pocket = ", h_clamp - 8));
}

module wire_keeper()
{
    difference()
    {
        hull()
        {
            translate([-19.95, 0, 0])
                cube([0.1, 20, 10], center = true);
            
            cylinder(d = 20, h = 10, center = true);
        }

        hull()
        {
            translate([-20, 0, 0])
                cube([0.1, 12, 11], center = true);
            
            cylinder(d = 12, h = 11, center = true);
        }
        
        translate([-15, 0, 0])
            rotate([90, 0, 0])
                cylinder(d = 4, h = 11);
    }
}

module verticle_board_template() {
    difference()
    {
        translate([0, 1.5, -1.5])
            cube([66, 23, 3], center = true);
        
        cube([61, 20, 3], center = true);
        
        for (i = [-1, 1])
            translate([i * cc_v_board_mounts / 2, 0, -2.25])
                cylinder(d1 = 2, d2 = 1, h = 1.5, center = true);

    }
}

module idler_jig()
{
    d_bit = 3 * 25.4 / 16; // diameter of the end mill used to cut the wooden pieces
    difference()
    {
        union()
        {
            translate([0, 0, -3])
                hull()
                {
                    for (i = [-1, 1])
                        translate([i * cc_idler_jig / 2, (w_idler_relief - d_bit) / 2, 0])
                            cylinder(d1 = d_bit - 0.5, d2 = d_bit, h = 12, center = true);
                    
                    for (i = [-1, 1])
                        translate([i * (l_idler_relief - w_idler_relief) / 2 , w_idler_relief / 2 + (w_idler_relief / 2 - 2) - (h_clamp - 8), 0])
                            cylinder(r = w_idler_relief / 2 - 2, h = 12, center = true);
                }
     
            for (i = [-1, 1])
                translate([i * (l_idler_relief - w_idler_relief) / 2 , 0, 6])
                    cylinder(d = w_idler_relief, h = 6, center = true);
        }
        
       for (i = [-1, 1])
            translate([i * (l_idler_relief - w_idler_relief) / 2 , 0, 12])
                cylinder(r = w_idler_relief / 2 - 2, h = 18, center = true);

/*        translate([0, 0, -5])
            hull()
            {
                for (i = [-1, 1])
                    translate([i * cc_idler_jig / 2, (w_idler_relief - d_bit) / 2, 0])
                        cylinder(d = d_bit - 3, h = 12, center = true);
                
                for (i = [-1, 1])
                    translate([i * (l_idler_relief - w_idler_relief + 1) / 2 , w_idler_relief / 2 + (w_idler_relief / 2 - 2) - (h_clamp - 8) - 1, 0])
                        cylinder(r = w_idler_relief / 2 - 5, h = 12, center = true);
            }
*/
        // guide rod pocket
        translate([0, 0, 6])
            rotate([90, 0, 0])
                cylinder(d = 8, h = 80, center = true);
    }
}

// athena_end_idler is the structural component to which idler bearings and guide rods are attached
module athena_end_idler(z_offset_guides = 8) {
	id_wire_retainer = 8; // the id of the hull forming the wire retainer
		difference() {
			union() {
				round_box(
					l_clamp,
					w_clamp,
					h_clamp
				);

                hull()
                {
                    hull()
                        for (i= [-1, 1], j = [0, 1])
                            translate([i * (l_clamp - 8) / 2, j * (w_clamp / 2 + 8), (h_base_mount - h_clamp) / 2])
                                cylinder(d = 8, h = h_base_mount, center = true);

                    hull()
                        for (i= [-1, 1], j = [0, 1])
                            translate([i * (l_clamp - 8) / 2, j * (w_clamp - 8) / 2, 5])
                                cylinder(d = 8, h = 0.1, center = true);
                }
                
/*                for (i = [-1, 1])
                    translate([i * (l_clamp / 2 - 6.5), w_clamp / 2 - 6, 5])
                        rotate([90, 0, 0])
                            rotate_extrude(convexity = 10)
                                translate([10, 0, 0])
                                    circle(d = 4);
*/            }


            // cutout for mounting screws
            translate([0, w_clamp, h_base_mount])
                cube([l_clamp - 12, w_clamp, h_clamp], center = true);
            
             // mounting screw holes
             for (i = [-1, 0, 1])
                 hull()
                    for (j = [0, 3])
                 translate([i * (l_clamp + 5)/ 3, w_clamp / 2 + 5 + j, -h_clamp / 2])
                    cylinder(d = 4.5, h = h_base_mount * 2 +1, center = true);
             
            // place the idler shaft such that the belt is parallel with the pulley - the belt connection will be on the right looking down the vertical axis
			translate([-offset_idler, 0, 0]) // update 09212014
				rotate([90, 0, 0])
					union() {
						cylinder(r = id_idler / 2, h = w_clamp + 2, center = true);

						translate([0, 0, -w_clamp / 2])
							cylinder(r = d_idler_shaft_head / 2, h = 2 * h_idler_shaft_head, center = true, $fn = 6);
					}

			// idler will be two bearing thick plus two washers
			round_box(
				length = l_idler_relief,
				width = w_idler_relief,
				height = h_clamp + 2,
				radius = r_idler_relief
			);

			// limit switch mount
			translate([l_clamp / 2 - 28.5, -w_clamp / 2, h_clamp / 2 - 6]) {
				cube([l_limit_switch, w_limit_switch, t_limit_switch], center = true);

				rotate([90, 0, 0])
					for (i = [-1, 1])
						translate([i * 9.5 / 2, 0, -8])
							cylinder(r = 0.85, h = 12, center = true);
			}

			// guide rod pockets
            for (i = [-1, 1])
                translate([i * cc_guides / 2, 0, z_offset_guides])
                    cylinder(r = d_guides / 2, h = h_clamp, center = true);

			// relief for vertical boards
            for (i = [-1, 1])
                translate([i * cc_v_board_mounts / 2, 0, 23 - h_clamp / 2])
                    rotate([90, 0, 0])
                        cylinder(r = d_M3_screw / 2, h = w_clamp + 1, center = true);

            for (i = [-1, 1])
                translate([i * (l_clamp / 2 + 36), 25, 5-h_clamp / 2])
                    rotate_extrude(convexity = 10)
                        translate([42, 0, 0])
                            circle(d = 4);

            for (i = [-1, 1])
                translate([i * (l_clamp / 2 + 36), -20, 5-h_clamp / 2])
                    rotate_extrude(convexity = 10)
                        translate([42, 0, 0])
                            circle(d = 4);
		}
}

// athena_end_motor is the structural component to which motors and guide rods are attached
module athena_end_motor(z_offset_guides = 8) {
	h_brace = 8; // height of cross brace triangle
	b_brace = equilateral_base_from_height(h_brace);
	difference() {
		union() {
			difference() {
                union()
                {
                    round_box(
                        l_clamp,
                        w_clamp,
                        h_clamp
                    );

                    translate([0, 6 - w_clamp / 2, -(h_clamp - h_base_mount) / 2])
                        hull()
                            for (i = [-1, 1])
                                translate([i * l_clamp / 2, 0, 0])
                                    cylinder(r = 6, h = h_base_mount, center = true);
                }
                
				translate([0, 0, (l_NEMA17 - h_clamp) / 2])
					round_box(
						length = l_idler_relief,
						width = w_idler_relief,
						height = l_NEMA17 + 2,
						radius = r_idler_relief
					);


				// motor mount
				translate([0, 0, (l_NEMA17 - h_clamp) / 2])
					rotate([90, 0, 0]) {
						NEMA_parallel_mount(
							height = w_clamp + 2,
							l_slot = 0,
							motor = NEMA17);

					// tear drop motor opening to improve printing
					hull() {
						cylinder(r = NEMA17[1] / 2, h = w_clamp + 2, center = true);

						translate([0, h_clamp / 2 - 4, 0])
							cylinder(r = 0.1, h = w_clamp + 2, center = true);
					}
				}

				// set screw access - access from bottom of printer
				translate([-2.5, -w_clamp / 2 - 1, d_NEMA17_collar / 2 + 0.5])
					cube([5, w_clamp / 2, (h_clamp - d_NEMA17_collar) / 2]);

                // guide rod pockets
                for (i = [-1, 1])
                    translate([i * cc_guides / 2, 0, -z_offset_guides])
                        cylinder(r = d_guides / 2, h = h_clamp, center = true);

                // relief for vertical boards
                for (i = [-1, 1])
                    translate([i * cc_v_board_mounts / 2, 0, h_clamp / 2 - 20])
                        rotate([90, 0, 0])
                            cylinder(r = d_M3_screw / 2, h = w_clamp + 1, center = true);
			}

			// cross bracing to minimize motor torquing into box
			for (i = [-1, 1])
				translate([i * (b_brace + 5) / 2, 0, h_clamp / 2 - h_brace])
					rotate([90, 0, 0])
						linear_extrude(height = w_clamp - 2, center = true)
							equilateral(h_brace);
		}
        
        for (i = [-1, 1])
            translate([i * l_clamp / 2, 6 - w_clamp / 2, 0])
            {
                translate([0, 0, (h_base_mount - h_clamp) / 2])
                    hull()
                        for (j = [-1.5, 1.5])
                            translate([0, j, 0])
                                cylinder(d = 4.5, h = h_base_mount + 1, center = true);
                    
                translate([0, 0, h_base_mount])
                    hull()
                        for (i = [0, -10])
                            translate([0, i, 0])
                                cylinder(r = 6, h = h_clamp, center = true);
            }
	}
}

/**********
							following are belt terminators used on the Athena platform
**********/

// Athena uses GT2 belts, make belt terminators that fit properly:
module athena_fixed_belt_terminator() {
	terminator(l_pass = 10, w_pass = 2.0, flag = false, mount = true, magnet = false); // narrowed the passage for a thinner GT2 belt
}

module athena_free_belt_terminator() {
	terminator(l_pass = 10, w_pass = 2.0, flag = false, mount = 0, magnet = false);
}

module athena_belt_terminators() {
	athena_fixed_belt_terminator();

	translate([11, 0, 0])
		athena_free_belt_terminator();
}

/**********
							following are carriages for the Athena
							one is simple and does not permit fixed tool mode operation
							the other is convertible, permitting use in both mobile and fixed tool modes
**********/

// athena_basic_carriage does not have magnet mounts required for fixed tool mode
module athena_basic_carriage() {
    difference() {
        union() {
            carriage_body();

            // magnet mounts
            for (i = [-1, 1])
                translate([i * l_effector / 2, -carriage_offset, -4])
                    rotate([90 - tie_rod_angle, 0, 0])
                        magnet_mount(r_pad = r_pad_carriage_magnet_mount, h_pad = h_carriage_magnet_mount);
        }

        for (i = [-1, 1])
            translate([i * cc_guides / 2, 0, 0])
                carriage_wire_tie_relief();

        carriage_bearing_relief();

        // belt terminator mount
        translate([d_pulley / 2, y_web, h_carriage / 2 - d_M3_screw / 2 - 5])
            rotate([90, 0, 0])
                cylinder(r = d_M3_screw / 2, h = w_carriage_web + 2, center = true);

        // flatten the bottom
        translate([0, 0, -h_carriage])
            cube([2 * cc_guides, 4 * (od_lm8uu + 6), h_carriage], center = true);
        
        // brand
        translate([0, -12, 0])
            rotate([-90, 0, 0])
                mirror([1, 0, 0])
                    linear_extrude(height = 2)
                        text("Athena II", halign = "center", valign = "center", size = 8);
    }
}

// athena_convertible_carriage is required if the platform will be used in fixed tool mode
module athena_convertible_carriage(linear_bearing = bearing_lm8uu) {
	difference() {
		union() {
			carriage_body(linear_bearing = linear_bearing);

			// magnet mounts
			for (i = [-1, 1])
				translate([i * l_effector / 2, -carriage_offset, stage_mount_pad + h_carriage_magnet_mount / sin(tie_rod_angle)])
					rotate([90 - tie_rod_angle, 0, 0])
						magnet_mount(r_pad = r_pad_carriage_magnet_mount, h_pad = h_carriage_magnet_mount);

			mirror([0, 0, 1])
				for (i = [-1, 1])
					translate([i * l_effector / 2, -carriage_offset, stage_mount_pad + h_carriage_magnet_mount / sin(tie_rod_angle)])
						rotate([90 - tie_rod_angle, 0, 0]) {
							magnet_mount(r_pad = r_pad_carriage_magnet_mount, h_pad = h_carriage_magnet_mount);

							// support for printing the mounts
							translate([0, 0, (h_magnet + h_carriage_magnet_mount) / 2 - r_bearing_seated + 0.25])
								difference() {
									cylinder(r = od_magnet / 2 + r_pad_carriage_magnet_mount, h = h_magnet + h_carriage_magnet_mount, center = true);

									cylinder(r = od_magnet / 2, h = h_magnet + h_carriage_magnet_mount, center = true);
								}
					}

			// add a protrusion for making the vertical board-mounted directional limit switch
			translate([d_pulley / 2 + x_pass / 2 + 5, y_web - 7.5, 0]) // offset it from the belt terminator mount point
				rotate([0, 90, 0])
					intersection() {
						cylinder(r = h_carriage / 2, h = 7, center = true);

						translate([0, h_carriage / 2 - y_web - 2, 0])
							cube([h_carriage, h_carriage, 11], center = true);
					}
		}

		for (i = [-1, 1])
			translate([i * cc_guides / 2, 0, 0])
				carriage_wire_tie_relief(linear_bearing = linear_bearing);

		carriage_bearing_relief(linear_bearing = linear_bearing);

		// belt terminator mount
		translate([d_pulley / 2, y_web, h_carriage / 2 - d_M3_screw / 2 - 5])
			rotate([90, 0, 0])
				cylinder(r = d_M3_screw / 2, h = w_carriage_web + 2, center = true);

		// flatten the bottom
		translate([0, 0, -h_carriage])
			cube([2 * cc_guides, 4 * (linear_bearing[0] + 6), h_carriage], center = true);
	}
}

/**********
							following for the limit switch required for fixed tool mode operation
							it is not necessary if the platform does not have a fixed tool mount
**********/

// central_limit_switch permits mounting a switch on the interior of vertical boards
module central_limit_switch() {
	l_switch_mount = 20;
	w_switch_mount = 10;
	h_switch_mount = 20;

	difference() {
		cube([l_switch_mount, w_switch_mount, h_switch_mount], center = true);

		translate([-5, 3.5, 0])
			cube([l_switch_mount, w_switch_mount, h_switch_mount + 1], center = true);

		// limit switch mounts
		translate([l_switch_mount / 2, 2, 0])
			rotate([0, 90, 0])
				for (i = [-1, 1])
					translate([i * cc_limit_mounts / 2, 0, 0])
						cylinder(r = 0.8, h = 14, center = true);

		for (i = [-1, 1])
			translate([-2.5, 0, i * 5])
				rotate([90, 0, 0])
					hull()
						for (j = [-1, 1])
							translate([j * 2.5, 0, 0])
								cylinder(r = d_M3_screw / 2 + 0.25, h = 13, center = true);
	}
}

/**********
							following for mounting controller boards to the base of the platform
							render and print necessary holders
**********/

// BBB_mount is for mounting a Beaglebone Black to the base of the platform
module BBB_mount(
	bbb_standoff = 6,
	mount_offset = 14) {
	// standoff is the total height of the mount
	// offset is the location of the mounting holes for mounting to whatever, in the case of Athena, the underside of the base
	slope0_2 = (bbb_hole2[1] - bbb_hole0[1]) / (bbb_hole2[0] - bbb_hole0[0]);

	difference() {
		union() {
			translate([0, 0, -bbb_standoff / 2 + 1]) {
				hull()
					for (i = [0, 2])
						translate([bbb_holes[i][0], bbb_holes[i][1], 0])
							cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

				hull()
					for (i = [1, 3])
						translate([bbb_holes[i][0], bbb_holes[i][1], 0])
							cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
			}

			for (i = [0:3])
				translate([bbb_holes[i][0], bbb_holes[i][1], 0])
							cylinder(r1 = d_M3_screw / 2 + 3, r2 = d_M3_screw / 2 + 1, h = bbb_standoff, center = true);
		}

		for (i = [0:3])
			translate([bbb_holes[i][0], bbb_holes[i][1], 1])
				cylinder(r = d_M3_screw / 2 - 0.25, h = bbb_standoff, center = true);

		translate([bbb_hole0[0] + mount_offset, bbb_hole0[1] + mount_offset * slope0_2, 0])
			cylinder(r = d_M3_screw / 2, h = bbb_standoff + 1, center = true);

		translate([bbb_hole2[0] - mount_offset, bbb_hole2[1] - mount_offset * slope0_2, 0])
			cylinder(r = d_M3_screw / 2, h = bbb_standoff + 1, center = true);
	}
}

/**********
							following are various holders for convenience, not necessary for construction of platform
**********/

// athena_tool_holder is an object to be mounted on a vertical board for holding effector tools
module athena_tool_holder(wood_mount = false) {
	// a tool holder for the side of the printer
	l_mount = 2 * d_small_effector_tool_magnet_mount * cos(60);
	w_mount = 16;
	h_mount = 20;

	mirror([0, 0, (wood_mount) ? 0 : 1]) // want to flip it over if aluminum mounting
		difference() {
			union() {
				if (wood_mount)
					// fits over the vertical board and covers wires
					translate([0, d_small_effector_tool_magnet_mount * sin(60) / 2 + 6, (h_mount - t_effector) / 2])
						12mm_board_mount(
							height = h_mount,
							length = l_mount,
							width = w_mount
							);
				else
					translate([0, d_small_effector_tool_magnet_mount * sin(60) / 2, 0])
						hull() {
							for (i = [-1, 1])
								translate([i * 10, 10, 0])
									cylinder(r = d_M3_nut / 2, h = t_effector, center = true);

								cube([20 + d_M3_nut, 4, t_effector], center = true);
						}

				hull()
					for (i = [0:2])
						rotate([0, 0, i * 120 + 60])
							translate([0, d_small_effector_tool_magnet_mount / 2, 0])
								cylinder(r = od_magnet / 2 + r_pad_effector_magnet_mount, h = t_effector, center = true);
			}

			if (!wood_mount)
				translate([0, d_small_effector_tool_magnet_mount * sin(60) / 2, 0])
					for (i = [-1, 1])
						translate([i * 10, 10, 0])
							cylinder(r = d_M3_screw / 2, h = t_effector + 1, center = true);

			cylinder(r = d_small_effector_tool_mount / 2, h = h_effector + 1, center = true);

			for (i = [0:2])
				rotate([0, 0, i * 120 + 60])
					translate([0, d_small_effector_tool_magnet_mount / 2, -t_effector / 2])
						cylinder(r1 = od_magnet / 2, r2 = od_magnet / 2 + 0.5, h = h_magnet + 2, center = true);

			for (i = [-1, 1])
				translate([i * l_mount / 4, d_small_effector_tool_magnet_mount * sin(60) / 2, h_mount - 8])
					rotate([90, 0, 0])
						cylinder(r = d_M3_screw / 2, h = 5, center = true);
		}
}

module athena_spool_holder(
	render_mount = false,
	render_arm = false,
	mount_wood = false) {
    h_mount = (mount_wood) ? 25 : 12;
    if (render_mount)
		translate([0, 0, h_mount / 2])
			difference() {
				union()
                {
					if (mount_wood)
						mirror([0, 0, 1])
							12mm_board_mount(
								height = h_mount,
								length = l_mount,
								width = w_mount,
								d_wire_guide = 12.2,
								wire_guide_offset = 5);
					else
						difference() {
							cube([l_mount, w_member + 8, h_mount], center = true);

							translate([0, 0, -4])
								cube([l_mount + 1, w_member, 6], center = true);
						}

					translate([-1, -3, (h_pivot + h_mount) / 2 + 0.5])
                        cylinder(r = d_pivot / 2, h = h_pivot + 1, center = true);
				}

                // 06-13-18 GCA screw goes completely through mount to strengthen it - use 16mm instead of 12mm screw
                // pivot mount screw
                translate([-1, -3, 0])
                    cylinder(r = d_M3_screw / 2 - 0.2, h = h_pivot + h_mount + 12, center = true);
                
				translate([-1, -3, h_mount / 2 - 5])
					intersection() {
						rotate_extrude(convexity = 10)
							translate([8, 0, 0])
								square([10, 6]);

						rotate([0, 0, 800])
							translate([-l_mount / 2 + 6, w_mount / 2, 5])
								cube([20, 27, 10], center = true);
					}

				if (mount_wood)
					translate([0, -w_mount / 2, -h_mount / 2 + 5])
						rotate([90, 0, 0])
							translate([0, 0, -2])
								for (i = [-1, 1])
									translate([i * 8, 0, 0])
										cylinder(r = 2, h = 10, center = true);
				else {
					translate([-1, 3, -1 + layer_height])
						cylinder(r = d_M3_screw / 2, h = h_mount + h_pivot + 3);

//						translate([0, 0, h_pivot])
//							cylinder(r = d_M3_cap / 2, h = h_M3_cap + 1, center = true);
//					}
				}
			}

	if (render_arm) // 06-13-18 GCA fixed mirrored arm problem that persisted far too long
		translate([0, (render_mount) ? (w_mount + h_holder) / 2 + 2 : 0, 0])
        {
			translate([0, 0, w_holder / 2])
				rotate([90, 0, 0])
					union()
                    {
						difference()
                        {
							hull()
								for (i = [-1, 1])
									translate([i * (l_holder - w_holder) / 2, 0, 0])
										cylinder(r = w_holder / 2 / cos(30), h = h_holder, center = true, $fn = 6);

							translate([(l_holder - w_holder) / 2, 0, 0])
                            {
                                cylinder(r = d_pivot / 2 + 0.25, h = 2 * h_pivot + 1, center = true);

								translate([0, 0, 0.1])
									cylinder(r1 = d_pivot / 2 + 0.25, r2 = d_pivot / 2 + 3, h = h_holder - h_pivot);
							}

							translate([-10, 0, h_holder / 2 + 2.75])
								rotate([0, -5, 0])
									cube([l_holder, w_holder + 1, h_holder], center = true);

							translate([-10, 14, 0])
								rotate([0, 0, 7])
									cube([l_holder / 1.5, w_holder, h_holder + 1], center = true);
						}

						translate([l_holder / 2 - 23, (4 - w_holder) / 2, -7])
							difference()
                            {
								cube([10, 4, 10], center = true);

								translate([-10, 0, -h_holder / 2 - 3])
									rotate([0, 7, 0])
										cube([l_holder, w_holder + 1, h_holder], center = true);
							}
					}
                }
                
            if (render_retainer)
            {
//				translate([0, 20, 0])
					difference() {
						cylinder(r1 = d_pivot / 2 + 0.25, r2 = d_pivot / 2 + 3, h = h_holder - h_pivot);

						translate([0, 0, -1])
							cylinder(r = d_M3_screw / 2, h = h_holder);

						translate([0, 0, h_holder - h_pivot - h_M3_cap])
							cylinder(r = d_M3_cap / 2, h = h_M3_cap + 1);
					}
            }
}

// athena_hand_tool_holder is an object to mount to a vertical board that wires can be tucked underneath and drivers can be hung on
// sonicare model E toothbrush ends have nice magnets in them, good for holding scraper
module athena_hand_tool_holder(
	wood_mount = false,
	sonicare_magnet = false
) {
	l_mount = 30;
	w_mount = 22;
	h_mount = (sonicare_magnet) ? 50 : 30;
	difference() {
		union() {
			if (wood_mount)
				translate([5, 0, l_mount / 2])
					rotate([0, 90, 0])
						12mm_board_mount(
							height = h_mount,
							length = l_mount,
							width = w_mount
							);
			else
				translate([0, 0, l_mount / 2])
					hull()
						for (i = [-1, 1])
							translate([i * l_mount / 2, 0, 0])
								cylinder(r = d_M3_nut / 2, h = h_mount, center = true);

			translate([30 - h_mount / 2, -13 - w_mount / 2, 2.5])
				hull()
					for (i = [-1, 1])
						translate([i * 30, 0, 0])
							cylinder(r = 15, h = 5, center = true);
		}

		translate([-h_mount / 2, -13 - w_mount / 2, 2.5])
			for (i = [0:4])
				translate([i * 15, 0, 0])
					cylinder(r = 3, h = 6, center = true);

		for (i = [0, 1])
		translate([14, -w_mount / 2, i * 15 + 10])
			rotate([90, 0, 0]) {
				cylinder(r = d_M3_screw / 2, h = 20, center = true);

				cylinder(r = 4, h = 5, center = true);
			}

		// magnet relief for sonicar magnets
		if (sonicare_magnet) {
			translate([1, 2.7 - w_mount / 2, h_mount / 3])
				rotate([90, 0, 0]) {
					for (i = [-1, 1])
						translate([i * (3.7 + 5.2) / 2, 0, 0])
							cube([5.2, 10.2, 6], center = true);

					translate([0, 0, -3 / 2])
						cube([19, 17, 2], center = true);
			}
		}
	}
}

module hotend_effector(
	quickrelease = true,
	dalekify = false,
	vent = false,
	headless = false
) {
	difference() {
		union() {
			hotend_mount(
				dalekify = dalekify,
				quickrelease = quickrelease,
				vent = vent,
				headless = headless
			);

			effector_base(large = false);
		}

		// opening at bottom
		translate([0, 0, 0])
			cylinder(r1 = r1_opening, r2 = r2_opening, h = t_effector + 0.1, center = true);

		translate([0, 0, -t_effector / 2 - 1])
			rotate([0, 0, 60])
				effector_shroud_holes(diameter = d_M3_screw / 2 - 0.15, height = t_effector + 1 - 2 * layer_height);
	}
}

module effector_shroud_holes(diameter, height) {
		for (i = [0:2])
			rotate([0, 0, i * 120])
				translate([0, r2_opening + 4, 0])
					cylinder(r = diameter, h = height);
}

module glass_holddown() {
	difference() {
		hull()
			for (i = [-1,1])
				translate([i * 1, 0, 0])
					cylinder(r = 6, h = 12, center = true);

		translate([4, 0, 0]) {
			cylinder(r = 2.5, h = 13, center = true);
		}

		translate([0, 0, -4])
			cube([20, 20, 8], center = true);

		translate([-152, 0, 0])
			cylinder(r = 152, h = 3, center = true);
	}
}

module template_fixed_tool_mount() {
	cc_arm_mounts = 50;
	v_offset_arm_mount = 20; // offset from the top of the printer vertical
	y_third_hole = pow(pow(cc_arm_mounts, 2) - pow(cc_arm_mounts / 2, 2), 0.5);
	l_al_spacer = 80; // length of the aluminum 1" x 3" spacer between the two verticals
	offset_arm_mount = l_al_spacer - v_offset_arm_mount - y_third_hole;
	arm_mount = true; // set to true to generate template for the second vertical (part that arm attaches to)

	difference() {
		translate([0, (v_offset_arm_mount - cc_arm_mounts) / 2 + 3, 0])
			cube([l_member + 6, cc_arm_mounts + v_offset_arm_mount, 3], center = true);

		translate([0, (arm_mount) ? v_offset_arm_mount - offset_arm_mount : 0, 0]) {
			for (i = [-1, 1])
				translate([i * cc_arm_mounts / 2, (arm_mount) ? -y_third_hole : 0, 0])
					cylinder(r = 1.5, h = 5, center = true);

			translate([0, (arm_mount) ? 0 : -y_third_hole, 0])
				cylinder(r = 1.5, h = 5, center = true);
		}

		translate([0, (v_offset_arm_mount - cc_arm_mounts) / 2 - 5, 1])
			cube([l_member + 1, cc_arm_mounts + v_offset_arm_mount + 10, 3], center = true);
	}
}

module thumbscrew_quickrelease() {
	hex = 10.2; // size of hex head, mm
	r_hex = hex / 2 / cos(30); // radius of hex
	points = 6; // points in closed end thumbscrew
	h_wrench = 7; // thickness of the thumbscrew, mm

	difference() {
		union() {
			cylinder(r = r_hex + 5, h = h_wrench, center = true, $fn = 6);

			for (i = [0:5])
				rotate([0, 0, i * 360 / 6])
					translate([r_hex + 3.5, 0, 0])
						cylinder(r = 2.5, h = h_wrench, center = true, $fn = 16);
		}

		cylinder(r = r_hex, h = h_wrench + 1, center = true, $fn = points);
	}
}

module bbb_melzi_mount(
	render_small = true,
	render_large = true
) {
	// width is short dimension, length is long dimension
	cc_w_melzi_mounts = 45.75 - 3.75; // c-c of melzi mounts on width axis
	cc_l_melzi_mounts = 200; // c-c of melzi mounts on length axis
	offset_melzi_mounts = 3.75 / 2 + 2; // distance from edge of board
	w_melzi = 50;
	w_bbb = 54.5;
	l_bbb = 86.3;
	bbb_melzi_offset = -20;
	h_standoff = 9;

	if (render_large)
		union() {
			// melzi
			translate([bbb_melzi_offset, -w_melzi, 0]) {
				difference() {
					union() {
						for (i = [-1, 1])
								translate([offset_melzi_mounts, i * cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
									cylinder(r1 = d_M3_screw / 2 + 3, r2 = d_M3_screw / 2 + 1, h = h_standoff, center = true);

						translate([0, 0, 1 - h_standoff / 2]) {
							hull(){
								translate([offset_melzi_mounts, -cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

								translate([-bbb_melzi_offset + bbb_hole1[0], w_melzi + bbb_hole1[1], 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
							}

							hull(){
								translate([offset_melzi_mounts, -cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

								translate([offset_melzi_mounts, cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
							}

							hull(){
								translate([offset_melzi_mounts, cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

								translate([-bbb_melzi_offset + bbb_hole0[0], w_melzi + bbb_hole0[1], 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
							}

							hull(){
								translate([offset_melzi_mounts, -cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

								translate([-bbb_melzi_offset + bbb_hole0[0], w_melzi + bbb_hole0[1], 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
							}

							hull(){
								translate([-bbb_melzi_offset + bbb_hole0[0], w_melzi + bbb_hole0[1], 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

								translate([-bbb_melzi_offset + bbb_hole1[0], w_melzi + bbb_hole1[1], 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
							}

							hull(){
								translate([-bbb_melzi_offset + bbb_hole1[0], w_melzi + bbb_hole1[1], 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

								translate([-bbb_melzi_offset + bbb_hole2[0], w_melzi + bbb_hole2[1], 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
							}

							hull(){
								translate([-bbb_melzi_offset + bbb_hole0[0], w_melzi + bbb_hole0[1], 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

								translate([-bbb_melzi_offset + bbb_hole2[0], w_melzi + bbb_hole2[1], 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
							}

							translate([4, w_melzi / 2, 0])
								hull()
									for (i = [0, -10])
										translate([i, 0, 0])
											cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);


							translate([-bbb_melzi_offset + bbb_hole1[0], w_melzi + bbb_hole2[1] - (bbb_hole2[1] - bbb_hole1[1]) / 2, 0])
								hull()
									for (i = [0, 10])
										translate([i, 0, 0])
											cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

						}
					}

					for (i = [-1, 1])
						translate([offset_melzi_mounts, i * cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
							cylinder(r = d_M3_screw / 2 - 0.25, h = h_standoff + 1, center = true);

					translate([-6, w_melzi / 2, 0])
						cylinder(r = d_M3_screw / 2, h = h_standoff + 1, center = true);

					translate([-bbb_melzi_offset + bbb_hole1[0] + 10, w_melzi + bbb_hole2[1] - (bbb_hole2[1] - bbb_hole1[1]) / 2, 0])
						cylinder(r = d_M3_screw / 2, h = h_standoff + 1, center = true);
				}
			}

			// bbb
			difference() {
				for (i = [0:2])
					translate([bbb_holes[i][0], bbb_holes[i][1], 0])
						cylinder(r1 = d_M3_screw / 2 + 3, r2 = d_M3_screw / 2 + 1, h = h_standoff, center = true);

				for (i = [0:3])
					translate([bbb_holes[i][0], bbb_holes[i][1], 0])
						cylinder(r = d_M3_screw / 2 - 0.25, h = h_standoff + 1, center = true);
			}
		}

	if (render_small)
		// for the opposite end of the melzi:
		translate([w_melzi / 2, 20, 0])
			rotate([0, 0, 90])
				difference() {
					union() {
						for (i = [-1, 1])
							translate([offset_melzi_mounts, i * cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
								cylinder(r1 = d_M3_screw / 2 + 3, r2 = d_M3_screw / 2 + 1, h = h_standoff, center = true);

						translate([0, 0, 1 - h_standoff / 2]) {
							hull(){
								translate([offset_melzi_mounts, -cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);

								translate([offset_melzi_mounts, cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
									cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
							}

							translate([4, w_melzi / 2, 0])
								hull()
									for (i = [0, -10])
										translate([i, 0, 0])
											cylinder(r = d_M3_screw / 2 + 3, h = 2, center = true);
						}
					}

					for (i = [-1, 1])
						translate([offset_melzi_mounts, i * cc_w_melzi_mounts / 2 + w_melzi / 2, 0])
							cylinder(r = d_M3_screw / 2 - 0.25, h = h_standoff + 1, center = true);

					translate([-6, w_melzi / 2, 0])
						cylinder(r = d_M3_screw / 2, h = h_standoff + 1, center = true);
				}
}

module connector_plate() {
	difference() {
		union() {
			hull()
				for (i = [-1, 1])
					for (j = [-1, 1])
						translate([i * (l_plate / 2 - r_plate_corners), j * (w_plate / 2 - r_plate_corners), 0])
							cylinder(r = r_plate_corners, h = h_plate);

			hull()
				for (i = [-1, 1])
					for (j = [-1, 1])
						translate([i * (l_plate / 2 - r_plate_corners + 5), j * (w_plate / 2 - r_plate_corners + 5), 0])
							cylinder(r = r_plate_corners, h = t_bbl_panel);

			translate([(l_plate - l_usb_housing) / 2 - 5 - l_usb_housing / 2, 0, h_plate])
				hull()
					for (i = [-1, 1])
						translate([0, i * (w_plate / 2 - 1), 0])
							cylinder(r1 = 4, r2 = 0, h = 3);

			translate([0, 0, h_plate])
				hull()
					for (i = [-1, 1])
						translate([i * (l_plate / 2 - 1), 0, 0])
							cylinder(r1 = 4, r2 = 0, h = 3);

		}

		hull()
			for (i = [-1, 1])
				for (j = [-1, 1])
					translate([i * (l_plate / 2 - r_plate_corners - 1), j * (w_plate / 2 - r_plate_corners - 1), t_bbl_panel])
						cylinder(r = r_plate_corners - 1, h = h_plate + 5);

		// barrel connector
		translate([-(l_plate - w_bbl_opening) / 2 + 1, w_plate / 2 - l_bbl_opening - 1, 0]) {
			translate([0, 0, -1])
				cube([w_bbl_opening, l_bbl_opening + 10, h_bbl_case + 1]);

			translate([-3, -3, t_bbl_panel])
				cube([w_bbl_opening + 6, l_bbl_opening + 16, h_plate]);
		}

		// rj45 jack
		translate([-12, 0, 0]) {
			translate([-l_rj45_jack / 2, top_offset_rj45_jack - w_rj45_housing / 2, -1]) {
				cube([l_rj45_jack, w_rj45_jack, h_plate + 2]);

				translate([-(w_rj45_housing - l_rj45_jack) / 2, -w_plate / 2, t_bbl_panel + 1])
					cube([w_rj45_housing, 2 * w_plate, h_plate]);
			}

			for (i = [-1, 1])
				translate([i * cc_rj45_mounts / 2, 0, -1])
					cylinder(r = d_M3_screw / 2, h = h_plate + 2);
		}

		// usb jack
		translate([(l_plate - l_usb_housing) / 2 - 4, 0, 0]) {
			for (i = [-1, 1])
				translate([i * cc_usb_mounts / 2, 0, -1])
					cylinder(r = d_M3_screw / 2, h = h_plate + 2);

			translate([-l_usb_opening / 2, -w_usb_opening / 2, -1])
				cube([l_usb_opening, w_usb_opening, h_plate + 2]);
		}
	}
}
