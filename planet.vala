using Gtk;
using GLib;
using Cairo;

float x = 0;
float y = 0;
float vx = 0;
float vy = 0;
float h = 0;
int sx = 0;
int sy = 0;
int cx = 0;
int cy = 0;
bool sim = false;
// var Timer = new GLib.Timer();

const int SIZE = 30;

/* When button click signal received */
public void on_action_start_activate (Gtk.Action source) {
    /* change button label to clicked! */
    //source.label = "Clicked!";
    stderr.printf ("Clicked! --> \n");
}

public void on_main_window_destroy (Window source) {
    /* When window close signal received */
	stderr.printf ("Destroyed\n");
    Gtk.main_quit ();
}

public bool on_figure_draw (Widget da, Context ctx) {
	ctx.set_source_rgb (0, 0, 0);

	ctx.set_line_width (SIZE / 4);
	ctx.set_tolerance (0.1);

	ctx.set_line_join (LineJoin.ROUND);
	ctx.set_dash (new double[] {SIZE / 4.0, SIZE / 4.0}, 0);
	stroke_shapes (ctx, 0, 0);

	ctx.set_dash (null, 0);
	stroke_shapes (ctx, 0, 3 * SIZE);

	ctx.set_line_join (LineJoin.BEVEL);
	stroke_shapes (ctx, 0, 6 * SIZE);

	ctx.set_line_join (LineJoin.MITER);
	stroke_shapes(ctx, 0, 9 * SIZE);

	fill_shapes (ctx, 0, 12 * SIZE);

	ctx.set_line_join (LineJoin.BEVEL);
	fill_shapes (ctx, 0, 15 * SIZE);
	ctx.set_source_rgb (1, 0, 0);
	stroke_shapes (ctx, 0, 15 * SIZE);

	return true;
}

public void stroke_shapes (Context ctx, int x, int y) {
	draw_shapes (ctx, x, y, ctx.stroke);
}

public void fill_shapes (Context ctx, int x, int y) {
	draw_shapes (ctx, x, y, ctx.fill);
}

public delegate void DrawMethod ();

public void draw_shapes (Context ctx, int x, int y, DrawMethod draw_method) {
	ctx.save ();

	ctx.new_path ();
	ctx.translate (x + SIZE, y + SIZE);
	bowtie (ctx);
	draw_method ();

	ctx.new_path ();
	ctx.translate (3 * SIZE, 0);
	square (ctx);
	draw_method ();

	ctx.new_path ();
	ctx.translate (3 * SIZE, 0);
	triangle (ctx);
	draw_method ();

	ctx.new_path ();
	ctx.translate (3 * SIZE, 0);
	inf (ctx);
	draw_method ();

	ctx.restore();
}

public void triangle (Context ctx) {
	ctx.move_to (SIZE, 0);
	ctx.rel_line_to (SIZE, 2 * SIZE);
	ctx.rel_line_to (-2 * SIZE, 0);
	ctx.close_path ();
}

public void square (Context ctx) {
	ctx.move_to (0, 0);
	ctx.rel_line_to (2 * SIZE, 0);
	ctx.rel_line_to (0, 2 * SIZE);
	ctx.rel_line_to (-2 * SIZE, 0);
	ctx.close_path ();
}

public void bowtie (Context ctx) {
	ctx.move_to (0, 0);
	ctx.rel_line_to (2 * SIZE, 2 * SIZE);
	ctx.rel_line_to (-2 * SIZE, 0);
	ctx.rel_line_to (2 * SIZE, -2 * SIZE);
	ctx.close_path ();
}

public void inf (Context ctx) {
	ctx.move_to (0, SIZE);
	ctx.rel_curve_to (0, SIZE, SIZE, SIZE, 2 * SIZE, 0);
	ctx.rel_curve_to (SIZE, -SIZE, 2 * SIZE, -SIZE, 2 * SIZE, 0);
	ctx.rel_curve_to (0, SIZE, -SIZE, SIZE, -2 * SIZE, 0);
	ctx.rel_curve_to (-SIZE, -SIZE, -2 * SIZE, -SIZE, -2 * SIZE, 0);
	ctx.close_path ();
}


int main (string[] args) {
    Gtk.init (ref args);

    var builder = new Builder ();
    /* Getting the glade file */
	try {
		builder.add_from_file ("planet.glade");
		builder.connect_signals (null);
		var window = builder.get_object ("main_window") as Window;
		var figure = builder.get_object ("figure") as DrawingArea;
		figure.draw.connect (on_figure_draw);
    /* thats another way to do something when signal received */
	/*
    start.activate.connect (() => {
        stderr.printf ("Started\n");
    });
	*/
		window.show_all ();
	} catch (GLib.Error e) {
		stderr.printf ("Программа при загрузке интерфейса дала сбой!\n");
		stderr.printf ("Ошибка: \"%s\"\n", e.message);
		return 0;
	};
    Gtk.main ();

    return 0;
}
// Makefile
