using Gtk;
using GLib;
using Gdk;
using Cairo;

float x = 0;
float y = 0;
float vx = 0;
float vy = 0;
float h = 0;
Gdk.Screen Screen;
int sx = 0;
int sy = 0;
int cx = 0;
int cy = 0;
bool sim = false;
double scale;

DrawingArea figure;

int SIZE = 30;
const double RE=6371000.0;
const double SS=15;
const double GM=4e14;
const int iters=1000;
double R;

/* When button click signal received */
public void on_action_start_activate (Gtk.Action source) {
    stderr.printf ("Clicked! --> \n");
}

public void on_main_window_destroy (Gtk.Window source) {
    /* When window close signal received */
	stderr.printf ("Destroyed\n");
    Gtk.main_quit ();
}

public bool on_figure_draw (Widget da, Context ctx) {
	ctx.set_source_rgb (0, 0, 0);

	ctx.set_line_width (1);
	ctx.set_tolerance (0.7);
	int height = figure.get_allocated_height ();
	int width = figure.get_allocated_width ();
	cx = width >> 1;
	cy = height >> 2;
	ctx.arc (cx, cy, R, 0, 2 * Math.PI);
	ctx.set_source_rgb (0.39, 0.74, 1);
	ctx.fill_preserve ();
	ctx.set_source_rgb (0.39, 0.56, 1);
	ctx.stroke ();

	return true;
}

public bool timeout_func() {
	SIZE+=10;
	figure.queue_draw();
	return true;
}

int main (string[] args) {
    Gtk.init (ref args);

    var builder = new Builder ();
    /* Getting the glade file */
	try {
		builder.add_from_file ("planet.glade");
		builder.connect_signals (null);
		var window = builder.get_object ("main_window") as Gtk.Window;
		figure = builder.get_object ("figure") as DrawingArea;
		figure.draw.connect (on_figure_draw);
		window.show_all ();
	} catch (GLib.Error e) {
		stderr.printf ("Программа при загрузке интерфейса дала сбой!\n");
		stderr.printf ("Ошибка: \"%s\"\n", e.message);
		return 0;
	};
	Screen=Gdk.Screen.get_default();
	sx=Screen.get_width() >> 1;
	sy=Screen.get_height() >> 1;
	scale=sy/RE/SS;
	R=scale*RE;
	Timeout.add(2000, timeout_func);
    Gtk.main ();

    return 0;
}
// Makefile
