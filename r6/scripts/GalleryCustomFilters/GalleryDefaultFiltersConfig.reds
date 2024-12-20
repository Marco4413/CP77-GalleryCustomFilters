module GalleryCustomFilters.Config

public class GalleryDefaultFiltersConfig {
  public static func GetInstance() -> ref<GalleryDefaultFiltersConfig> {
    return new GalleryDefaultFiltersConfig();
  }

  @runtimeProperty("ModSettings.mod", "Gallery Custom Filters")
  @runtimeProperty("ModSettings.displayName", "Enable Sort By Name Filter")
  public let SortByNameEnabled: Bool = true;

  @runtimeProperty("ModSettings.mod", "Gallery Custom Filters")
  @runtimeProperty("ModSettings.displayName", "Sort By Name - Show Only non-Photomode")
  @runtimeProperty("ModSettings.description", "Will only show images that DO NOT start with the 'photomode_' prefix.")
  @runtimeProperty("ModSettings.dependency", "SortByNameEnabled")
  public let SortByNameShowOnlyCustomImages: Bool = false;
}
