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
double sx = 0;
double sy = 0;
int scrw;
int scrh;
int cx = 0;
int cy = 0;
bool sim = false;
double scale;

DrawingArea figure;

const double RE=6371000.0;
const double SS=15;
const double GM=4e14;
const int iters=1000;
double R;

Cairo.ImageSurface surface; // drawing surface, which is copied to the pixmap
Cairo.Context surface_ctx; // surface Cairo context

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
	var cw=figure.get_allocated_width ();
	var ch=figure.get_allocated_height ();
	var cx=cw/2.0;
	var cy=ch/2.0;
	var by=cy-sy;
	if (by>0) by=0;
	ctx.set_source_surface (surface, cx-sx,by);
	ctx.paint ();
	return true;
}

public bool draw_surface (Context ctx) {
	ctx.set_source_rgb (1,1,1);
	ctx.rectangle (0,0,scrw,scrh);
	ctx.fill ();
	ctx.set_source_rgb (0, 0, 0);
	ctx.set_tolerance (0.7);
	ctx.arc (sx, sy, R, 0, 2 * Math.PI);
	ctx.set_source_rgb (0.39, 0.74, 1);
	ctx.fill_preserve ();
	ctx.set_source_rgb (0.39/2, 0.56/2, 1/2);
	ctx.set_line_width (1.5);
	ctx.stroke ();
	return true;
}

public bool timeout_func() {
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
		window.set_size_request(500,500);
		figure.draw.connect (on_figure_draw);
		window.show_all ();
	} catch (GLib.Error e) {
		stderr.printf ("Программа при загрузке интерфейса дала сбой!\n");
		stderr.printf ("Ошибка: \"%s\"\n", e.message);
		return 0;
	};
	Screen=Gdk.Screen.get_default();
	scrw=Screen.get_width();
	scrh=Screen.get_height();
	sx=scrw / 2.0;
	sy=scrh / 2.0;
	scale=sy/RE/SS;
	sy/=2.0;
	R=scale*RE;
	surface = new Cairo.ImageSurface (Cairo.Format.ARGB32, scrw, scrh);
	surface_ctx = new Cairo.Context (surface);
	draw_surface(surface_ctx);
	Timeout.add(2000, timeout_func);
    Gtk.main ();

    return 0;
}
// Makefile
