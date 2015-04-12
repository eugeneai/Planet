.PHONY: all vala glade

all:vala
	./planet_vala

vala:	planet_vala

planet_vala: planet.vala
	valac --no-color --pkg gtk+-3.0 --pkg gmodule-2.0 --pkg glib-2.0 planet.vala -o planet_vala

glade:
	glade planet.glade &
