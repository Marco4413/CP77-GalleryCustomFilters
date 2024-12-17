module GalleryCustomFilters.Config

public class GalleryDefaultFiltersConfig {
  public static func GetInstance() -> ref<GalleryDefaultFiltersConfig> {
    return new GalleryDefaultFiltersConfig();
  }

  @runtimeProperty("ModSettings.mod", "Gallery Custom Filters")
  @runtimeProperty("ModSettings.displayName", "Enable Sort By Name Filter")
  public let SortByNameEnabled: Bool = true;
}
