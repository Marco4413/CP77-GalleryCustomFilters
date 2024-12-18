## Cyberpunk2077 - GalleryCustomFilters

![preview](preview.png)

## About

This Cyberpunk 2077 mod adds custom filters to the smart frame screenshot selection menu.

> Patch 2.2 added Smart Frames which allow for custom images to be displayed in V's appartments.
> This mod allows other mods to add custom filter rules to better handle screenshots.

A filter for screenshot names comes bundled with the mod.
By default it only sorts screenshots by name. However, with Mod Settings
installed, it's possible to configure it to filter out images that have
the `photomode_` prefix.

This mod can also be used by other mods to implement more custom filters.

## Requirements

- [redscript 0.5.27+](https://github.com/jac3km4/redscript)
- [Mod Settings 0.2.8+](https://github.com/jackhumbert/mod_settings) (optional, adds in-game config for built-in filters)

## API for Modders

An example of the API's usage can be found in the [r6/scripts/GalleryCustomFilters/SortByName](r6/scripts/GalleryCustomFilters/SortByName) folder.

Classes that must be used to implement a `CustomFilter` are found within [GalleryCustomFiltersBase.reds](r6/scripts/GalleryCustomFilters/GalleryCustomFiltersBase.reds) along with documentation for their methods.
