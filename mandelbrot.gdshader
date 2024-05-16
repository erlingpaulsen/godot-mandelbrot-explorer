shader_type canvas_item;

uniform vec2 position;
uniform vec2 offset;
uniform vec2 size = vec2(2500.0, 2000.0);
uniform float zoom;
uniform float time_scale = 0.05;
uniform float palette_scale = 0.75;
uniform float palette_scale_modulation = 0.25;
uniform float palette_scale_modulation_speed = 0.1;
uniform float iteration_effect = 0.5;
uniform float iteration_effect_modulation = 0.25;
uniform float iteration_effect_modulation_speed = 0.25;
uniform float gamma = 1.25;
uniform float gamma_modulation = 0.5;
uniform float gamma_modulation_speed = 0.15;

//https://iquilezles.org/articles/palettes/
vec3 palette(float t) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263,0.416,0.557);

    return a + b*cos( 6.28318*(c*t+d) );
}

vec2 complex_square(vec2 c) {
	// c = a + bi
	// returning c^2 = a^2 - b^2 + 2abi
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
	vec2 uv = scale * UV * aspect_ratio - position_corr;// - position - vec2(0.5, 0.0);

	// Base color is black
	vec3 color = vec3(0.0);
	vec2 z = vec2(0.0);
	float n = 0.0;
	while (n < 100.0) {
		vec2 z_next = complex_square(z) + uv;
		if (length(z_next) <= 2.0) {
			z = z_next;
			n++;
		} else {
			// color based on size of z and number of iterations
			float palette_factor = palette_scale + palette_scale_modulation * cos(palette_scale_modulation_speed * TIME);
			float iteration_factor = pow(n, iteration_effect + iteration_effect_modulation * sin(iteration_effect_modulation_speed * TIME));
			color = vec3(palette(time_scale * TIME - length(palette_factor * z/iteration_factor)));
			break;
		}
	}
	color = pow(color, vec3(1.0/(gamma + gamma_modulation * cos(gamma_modulation_speed * TIME))));
	//color = color - exp(1.0 / n);
	//color = vec3(0.0 + 1.0/n);
	COLOR = vec4(color, 1.0);

	//COLOR = vec4(vec3(uv, 0.0), 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
