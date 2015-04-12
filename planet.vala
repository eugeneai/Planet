using Gtk;
using GLib;

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
var Timer = new GLib.Timer();


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

int main (string[] args) {
    Gtk.init (ref args);

    var builder = new Builder ();
    /* Getting the glade file */
	try {
		builder.add_from_file ("planet.glade");
		builder.connect_signals (null);
		var window = builder.get_object ("main_window") as Window;
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
