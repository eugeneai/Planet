.PHONY: all vala glade

all:vala
	./planet_vala &

vala:	planet_vala

planet_vala: planet.vala
	valac --pkg gtk+-3.0 --pkg gmodule-2.0 planet.vala -o planet_vala

glade:
	glade planet.glade &
