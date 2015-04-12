using Gtk;
/* When button click signal received */
public void on_action_start_activate (Button source) {
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
    Gtk.main ();

    return 0;
}
// Makefile
