shader_type canvas_item;

uniform vec2 position = vec2(0.9, 1.1);
uniform vec2 offset = vec2(0.0, 0.0);
uniform vec2 size = vec2(1600.0, 1000.0);
uniform float zoom = -3.2;
uniform float palette_phase_r = 0.263;
uniform float palette_phase_g = 0.416;
uniform float palette_phase_b = 0.557;
uniform float palette_cycle_speed = 0.05;
uniform float distance_effect = 0.75;
uniform float distance_effect_mod = 0.25;
uniform float distance_effect_mod_speed = 0.1;
uniform float iteration_effect = 0.5;
uniform float iteration_effect_mod = 0.25;
uniform float iteration_effect_mod_speed = 0.25;
uniform float gamma = 1.25;
uniform float gamma_mod = 0.5;
uniform float gamma_mod_speed = 0.15;

//https://iquilezles.org/articles/palettes/
vec3 palette(float t) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(palette_phase_r, palette_phase_g, palette_phase_b);

    return a + b*cos( 6.28318*(c*t+d) );
}

vec2 complex_square(vec2 c) {
	// Input: complex number c = a + bi
	// Returns c^2 = a^2 - b^2 + 2abi
	return vec2(c.x * c.x - c.y * c.y, 2.0 * c.x * c.y);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Remapping UV to fit Mandelbrot fractal
	float scale = 2.0 - zoom;
	vec2 aspect_ratio = size.xy / size.y;
	vec2 position_corr = position + offset;
	vec2 uv = scale * UV * aspect_ratio - position_corr;

	// Base color is black
	vec3 color = vec3(0.0);
	vec2 z = vec2(0.0);
	float n = 0.0;
	// Iterate the mandelbrot equation, either until point escaped (distance greater than 2), or until 100 iterations
	while (n < 100.0) {
		vec2 z_next = complex_square(z) + uv;
		if (length(z_next) <= 2.0) {
			z = z_next;
			n++;
		} else {
			// color based on size of z and number of iterations, with cyclic modulation
			float distance_factor = distance_effect + distance_effect_mod * cos(distance_effect_mod_speed * TIME);
			float iteration_factor = pow(n, iteration_effect + iteration_effect_mod * sin(iteration_effect_mod_speed * TIME));
			color = vec3(palette(palette_cycle_speed * TIME - length(distance_factor * z/iteration_factor)));
			break;
		}
	}
	// adjusting gamma, with cyclic modulation
	float gamma_factor = max(gamma + gamma_mod * cos(gamma_mod_speed * TIME), 0.0);
	color = pow(color, vec3(1.0/gamma_factor));
	COLOR = vec4(color, 1.0);
}
